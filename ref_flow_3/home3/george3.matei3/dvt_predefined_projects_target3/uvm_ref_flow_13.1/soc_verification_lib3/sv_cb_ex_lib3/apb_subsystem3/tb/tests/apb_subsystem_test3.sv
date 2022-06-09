/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_test3.sv
Title3       : Test3 Case3
Project3     :
Created3     :
Description3 : One3 test case for the APB3 Subsystem3 Environment3
Notes3       : The test creates3 a apb_subsystem_tb3 and sets3 the default
            : sequence for the sequencer as apb_subsystem_vseq3
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

class apb_subsystem_test3 extends uvm_test;

  apb_subsystem_tb3 ve3;

  `uvm_component_utils(apb_subsystem_test3)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor3", "ahb_monitor3");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve3.virtual_sequencer3.run_phase",
          "default_sequence", apb_subsystem_vseq3::type_id::get());
    ve3 = apb_subsystem_tb3::type_id::create("ve3", this);
  endfunction : build_phase

endclass : apb_subsystem_test3

