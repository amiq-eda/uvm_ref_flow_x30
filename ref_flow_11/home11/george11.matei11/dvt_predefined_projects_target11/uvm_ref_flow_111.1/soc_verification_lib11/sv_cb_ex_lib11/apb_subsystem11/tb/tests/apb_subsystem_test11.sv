/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_test11.sv
Title11       : Test11 Case11
Project11     :
Created11     :
Description11 : One11 test case for the APB11 Subsystem11 Environment11
Notes11       : The test creates11 a apb_subsystem_tb11 and sets11 the default
            : sequence for the sequencer as apb_subsystem_vseq11
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

class apb_subsystem_test11 extends uvm_test;

  apb_subsystem_tb11 ve11;

  `uvm_component_utils(apb_subsystem_test11)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor11", "ahb_monitor11");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve11.virtual_sequencer11.run_phase",
          "default_sequence", apb_subsystem_vseq11::type_id::get());
    ve11 = apb_subsystem_tb11::type_id::create("ve11", this);
  endfunction : build_phase

endclass : apb_subsystem_test11

