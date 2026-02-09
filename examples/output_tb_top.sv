package tb_pkg;
import uvm_pkg::*;
  `include "uvm_macros.svh"
  // -------------------------------------------------
  // Global testbench parameters
  // -------------------------------------------------
parameter int DEPTH=8;
parameter int DWIDTH=16;
//sequence_item
class seq_item extends uvm_sequence_item;
	`uvm_object_utils(seq_item)
	rand bit rstn;
	rand bit clk;
	rand bit wr_en;
	rand bit rd_en;
	function new(string name="seq_item");
		super.new(name);
	endfunction
endclass

//sequence
class myseq extends uvm_sequence#(seq_item);
	`uvm_object_utils(myseq)
	function new(string name="myseq");
		super.new(name);
	endfunction
	rand int num;
	constraint c1 { num inside {[10:20]}; }
	virtual task body();
		repeat(num)
			begin
				seq_item seq_item1;
				seq_item1=seq_item::type_id::create("seq_item1");
				start_item(seq_item1);
				assert(seq_item1.randomize());
				finish_item(seq_item1);
			end
	endtask
endclass

//Sequencer
class seqr extends uvm_sequencer#(seq_item);
	`uvm_component_utils(seqr)
	function new(string name="seqr",uvm_component parent);
		super.new(name,parent);
	endfunction
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass

//driver
class driver extends uvm_driver#(seq_item);
	`uvm_component_utils(driver)
	virtual intf vif;
	function new(string name="driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(! uvm_config_db#(virtual intf)::get(this,"","vif",vif)) 
			`uvm_error(get_type_name(),"Error get virtual intf Failed\n");
	endfunction
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
		seq_item seq_item1;
		seq_item1=seq_item::type_id::create("seq_item1",this);
		seq_item_port.get_next_item(seq_item1);
		drive_signals(seq_item1);
		seq_item_port.item_done();
		end
	endtask

	task drive_signals(seq_item seq_item1);
//WRITE YOUR DRIVER LOGIC HERE
	endtask
endclass

//monitor
class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)
	virtual intf vif;
	uvm_analysis_port#(seq_item) a_port;
	function new ( string name="monitor", uvm_component parent);
		super.new(name,parent);
		a_port=new("a_port",this);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(! uvm_config_db#(virtual intf)::get(this,"","vif",vif)) 
			`uvm_error(get_type_name(),"Error get virtual intf Failed\n");
	endfunction
	task run_phase(uvm_phase phase);
		forever begin
			seq_item seq_item1;
			seq_item1=seq_item::type_id::create("seq_item1",this);
			@(posedge vif.clk);
			//monitor signals
			a_port.write(seq_item1);
		end
	endtask
endclass

//Agent
class agent extends uvm_agent;
	`uvm_component_utils(agent)
	seqr seqr1;
	driver driver1;
	monitor monitor1;
	function new(string name="agent", uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active()==UVM_ACTIVE) begin
			seqr1=seqr::type_id::create("seqr",this);
			driver1=driver::type_id::create("driver",this);
		end
		monitor1=monitor::type_id::create("monitor1",this);		
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver1.seq_item_port.connect(seqr1.seq_item_export);
	endfunction
endclass

//scoreboard
class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	uvm_analysis_imp#(seq_item, scoreboard) a_imp;
	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a_imp=new("a_imp",this);
	endfunction
    virtual function void write(seq_item seq_item1);
		//SCOREBOARD LOGIC
	endfunction	
endclass

//env
class env extends uvm_env;
	`uvm_component_utils(env)
	scoreboard scoreboard1;
	agent agent1;
	function new(string name="env",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);	
		super.build_phase(phase);
		agent1=agent::type_id::create("agent1",this);
		scoreboard1=scoreboard::type_id::create("scoreboard1",this);
	endfunction	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent1.monitor1.a_port.connect(scoreboard1.a_imp);
	endfunction	
endclass

//test
class basic_test extends uvm_test;
	`uvm_component_utils(basic_test)
	env env1;
	function new(string name="basic_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);	
		super.build_phase(phase);
		env1=env::type_id::create("env1",this);
	endfunction	
	task run_phase(uvm_phase phase);
		myseq myseq1;
		phase.raise_objection("this");
		myseq1=myseq::type_id::create("myseq1",this);
		myseq1.start(env1.agent1.seqr1);
		phase.drop_objection("this");	
    endtask
endclass
endpackage

`timescale 1ns/1ps
import uvm_pkg::*;
import tb_pkg::*;
`include "uvm_macros.svh"

//tb_top
module tb_top;

//clock
logic clk;

// Interface
intf vif (clk);

//DUT INSTANCE

// Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;   // 100 MHz
  end

//Reset generation

  // UVM configuration and test start
  initial begin
    // Make virtual interface visible to UVM
    uvm_config_db#(virtual intf)::set(null, "*", "vif", vif);
    // Start UVM
    run_test("test");  
  end

  initial begin
    $dumpvars;
    $dumpfile ("dump.vcd");
  end
initial begin
  #1000;
  $finish;
end  

endmodule


