/*-------------------------------------------------------------------------
File4 name   : apb_uart_simple_test4.sv
Title4       : Test4 Case4
Project4     :
Created4     :
Description4 : One4 test case for the APB4-UART4 Environment4
Notes4       : The test creates4 a apb_subsystem_tb4 and sets4 the default
            : sequence for the sequencer as u2a_incr_payload4
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

class apb_uart_simple_test4 extends uvm_test;

  apb_subsystem_tb4 ve4;

  `uvm_component_utils(apb_uart_simple_test4)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor4", "ahb_monitor4");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve4.virtual_sequencer4.run_phase",
          "default_sequence", u2a_incr_payload4::type_id::get());
    ve4 = apb_subsystem_tb4::type_id::create("ve4", this);
  endfunction : build_phase

endclass : apb_uart_simple_test4

