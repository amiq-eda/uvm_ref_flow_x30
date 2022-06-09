/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_test5.sv
Title5       : Test5 Case5
Project5     :
Created5     :
Description5 : One5 test case for the APB5 Subsystem5 Environment5
Notes5       : The test creates5 a apb_subsystem_tb5 and sets5 the default
            : sequence for the sequencer as apb_subsystem_vseq5
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

class apb_subsystem_test5 extends uvm_test;

  apb_subsystem_tb5 ve5;

  `uvm_component_utils(apb_subsystem_test5)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor5", "ahb_monitor5");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve5.virtual_sequencer5.run_phase",
          "default_sequence", apb_subsystem_vseq5::type_id::get());
    ve5 = apb_subsystem_tb5::type_id::create("ve5", this);
  endfunction : build_phase

endclass : apb_subsystem_test5

