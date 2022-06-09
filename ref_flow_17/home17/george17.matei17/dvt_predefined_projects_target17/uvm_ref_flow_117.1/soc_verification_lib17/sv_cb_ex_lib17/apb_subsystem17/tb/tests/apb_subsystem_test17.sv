/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_test17.sv
Title17       : Test17 Case17
Project17     :
Created17     :
Description17 : One17 test case for the APB17 Subsystem17 Environment17
Notes17       : The test creates17 a apb_subsystem_tb17 and sets17 the default
            : sequence for the sequencer as apb_subsystem_vseq17
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

class apb_subsystem_test17 extends uvm_test;

  apb_subsystem_tb17 ve17;

  `uvm_component_utils(apb_subsystem_test17)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor17", "ahb_monitor17");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve17.virtual_sequencer17.run_phase",
          "default_sequence", apb_subsystem_vseq17::type_id::get());
    ve17 = apb_subsystem_tb17::type_id::create("ve17", this);
  endfunction : build_phase

endclass : apb_subsystem_test17

