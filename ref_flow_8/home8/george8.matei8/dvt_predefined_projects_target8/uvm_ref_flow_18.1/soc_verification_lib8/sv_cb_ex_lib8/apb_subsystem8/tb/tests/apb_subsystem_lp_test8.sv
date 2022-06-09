/*-------------------------------------------------------------------------
File8 name   : lp_shutdown_urt18.sv
Title8       : Test8 Case8
Project8     :
Created8     :
Description8 : One8 test case for the APB8-UART8 Environment8
Notes8       : The test creates8 a apb_subsystem_tb8 and sets8 the default
            : sequence for the sequencer as lp_shutdown_uart18
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

class apb_subsystem_lp_test8 extends uvm_test;

  apb_subsystem_tb8 ve8;

  `uvm_component_utils(apb_subsystem_lp_test8)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor8", "ahb_monitor8");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve8.virtual_sequencer8.run_phase",
          "default_sequence", lp_shutdown_rand8::type_id::get());
    ve8 = apb_subsystem_tb8::type_id::create("ve8", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test8
