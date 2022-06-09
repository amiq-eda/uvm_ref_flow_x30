/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_test28.sv
Title28       : Test28 Case28
Project28     :
Created28     :
Description28 : One28 test case for the APB28 Subsystem28 Environment28
Notes28       : The test creates28 a apb_subsystem_tb28 and sets28 the default
            : sequence for the sequencer as apb_subsystem_vseq28
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

class apb_subsystem_test28 extends uvm_test;

  apb_subsystem_tb28 ve28;

  `uvm_component_utils(apb_subsystem_test28)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor28", "ahb_monitor28");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve28.virtual_sequencer28.run_phase",
          "default_sequence", apb_subsystem_vseq28::type_id::get());
    ve28 = apb_subsystem_tb28::type_id::create("ve28", this);
  endfunction : build_phase

endclass : apb_subsystem_test28

