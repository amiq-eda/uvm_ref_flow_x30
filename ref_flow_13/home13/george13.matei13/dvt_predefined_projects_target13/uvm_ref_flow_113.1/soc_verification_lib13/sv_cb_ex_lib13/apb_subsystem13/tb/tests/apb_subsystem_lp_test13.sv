/*-------------------------------------------------------------------------
File13 name   : lp_shutdown_urt113.sv
Title13       : Test13 Case13
Project13     :
Created13     :
Description13 : One13 test case for the APB13-UART13 Environment13
Notes13       : The test creates13 a apb_subsystem_tb13 and sets13 the default
            : sequence for the sequencer as lp_shutdown_uart113
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

class apb_subsystem_lp_test13 extends uvm_test;

  apb_subsystem_tb13 ve13;

  `uvm_component_utils(apb_subsystem_lp_test13)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor13", "ahb_monitor13");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve13.virtual_sequencer13.run_phase",
          "default_sequence", lp_shutdown_rand13::type_id::get());
    ve13 = apb_subsystem_tb13::type_id::create("ve13", this);
  endfunction : build_phase

endclass : apb_subsystem_lp_test13
