/*-------------------------------------------------------------------------
File10 name   : lp_shutdown_urt110.sv
Title10       : Test10 Case10
Project10     :
Created10     :
Description10 : One10 test case for the APB10-UART10 Environment10
Notes10       : The test creates10 a apb_subsystem_tb10 and sets10 the default
            : sequence for the sequencer as lp_shutdown_uart110
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

class lp_shutdown_urt110 extends uvm_test;

  apb_subsystem_tb10 ve10;

  `uvm_component_utils(lp_shutdown_urt110)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor10", "ahb_monitor10");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve10.virtual_sequencer10.run_phase",
          "default_sequence", lp_shutdown_uart110::type_id::get());
    ve10 = apb_subsystem_tb10::type_id::create("ve10", this);
  endfunction : build_phase

endclass : lp_shutdown_urt110
