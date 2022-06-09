/*-------------------------------------------------------------------------
File7 name   : apb_uart_simple_test7.sv
Title7       : Test7 Case7
Project7     :
Created7     :
Description7 : One7 test case for the APB7-UART7 Environment7
Notes7       : The test creates7 a apb_subsystem_tb7 and sets7 the default
            : sequence for the sequencer as u2a_incr_payload7
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

class apb_uart_simple_test7 extends uvm_test;

  apb_subsystem_tb7 ve7;

  `uvm_component_utils(apb_uart_simple_test7)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor7", "ahb_monitor7");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve7.virtual_sequencer7.run_phase",
          "default_sequence", u2a_incr_payload7::type_id::get());
    ve7 = apb_subsystem_tb7::type_id::create("ve7", this);
  endfunction : build_phase

endclass : apb_uart_simple_test7

