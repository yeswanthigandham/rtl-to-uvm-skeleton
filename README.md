RTL to UVM Testbench & Interface Automation Tool
================================================

A Perl-based Design Verification automation tool that parses SystemVerilog RTL
and automatically generates UVM testbench skeletons and SystemVerilog interfaces,
enabling faster and more consistent UVM-based verification environment bring-up.

This repository demonstrates verification infrastructure automation, UVM methodology,
and RTL-aware scripting, which are commonly used in semiconductor IP and SoC verification teams.

---

Features
--------

- Parses SystemVerilog RTL modules
- Extracts parameters and port definitions
- Generates SystemVerilog interface aligned with DUT ports
- Generates UVM testbench skeleton, including:
  - Sequence Item
  - Sequence
  - Sequencer
  - Driver
  - Monitor
  - Agent
  - Scoreboard
  - Environment
  - Test
  - tb_top
- Supports parameterized designs
- Reduces manual boilerplate code
- Encourages standardized and reusable UVM architecture

---

Repository Structure
-------------------
| Folder / File           | Description                                           |
|-------------------------|-------------------------------------------------------|
| `scripts/`              | Automation scripts                                    |
| `scripts/gen_uvm_tb.pl` | Perl script to generate UVM testbench skeleton       |
| `scripts/gen_interface.pl` | Perl script to generate SystemVerilog interface  |
| `examples/`             | Example RTL and generated files                       |
| `examples/input_design.sv` | Example RTL module                                 |
| `examples/output_tb_top.sv` | Generated UVM testbench example                   |
| `examples/interface_ex.sv`  | Generated interface example                        |
| `README.md`             | This documentation                                    |

---

Usage
-----
1. Generate UVM Testbench Skeleton:

  perl scripts/gen_uvm_tb.pl input_design.sv

2. Generate SystemVerilog Interface:

  perl scripts/gen_interface.pl input_design.sv

---

Requirements
------------

- Perl 5 or higher
- UVM 1.2 or compatible simulator
- SystemVerilog RTL source files

---

Future Enhancements / To-Do
---------------------------

- Develop Python-based version of the tool
- Improve RTL parsing for complex port declarations
- Add command-line options for output control
- Auto-generate basic scoreboard and coverage templates
- Add regression and unit test support
- Extend support for multi-clock and multi-interface designs

---

Why This Project
----------------

Manual UVM testbench setup is time-consuming and error-prone.
This tool automates interface and testbench generation, improving:

- Verification efficiency
- Consistency across projects
- Scalability for multiple designs
