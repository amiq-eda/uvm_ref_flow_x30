/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_test15.sv
Title15       : Test15 Case15
Project15     :
Created15     :
Description15 : One15 test case for the APB15 Subsystem15 Environment15
Notes15       : The test creates15 a apb_subsystem_tb15 and sets15 the default
            : sequence for the sequencer as apb_subsystem_vseq15
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

class apb_subsystem_test15 extends uvm_test;

  apb_subsystem_tb15 ve15;

  `uvm_component_utils(apb_subsystem_test15)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor15", "ahb_monitor15");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve15.virtual_sequencer15.run_phase",
          "default_sequence", apb_subsystem_vseq15::type_id::get());
    ve15 = apb_subsystem_tb15::type_id::create("ve15", this);
  endfunction : build_phase

endclass : apb_subsystem_test15

