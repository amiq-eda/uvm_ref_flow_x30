/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_test29.sv
Title29       : Test29 Case29
Project29     :
Created29     :
Description29 : One29 test case for the APB29 Subsystem29 Environment29
Notes29       : The test creates29 a apb_subsystem_tb29 and sets29 the default
            : sequence for the sequencer as apb_subsystem_vseq29
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

class apb_subsystem_test29 extends uvm_test;

  apb_subsystem_tb29 ve29;

  `uvm_component_utils(apb_subsystem_test29)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor29", "ahb_monitor29");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve29.virtual_sequencer29.run_phase",
          "default_sequence", apb_subsystem_vseq29::type_id::get());
    ve29 = apb_subsystem_tb29::type_id::create("ve29", this);
  endfunction : build_phase

endclass : apb_subsystem_test29

