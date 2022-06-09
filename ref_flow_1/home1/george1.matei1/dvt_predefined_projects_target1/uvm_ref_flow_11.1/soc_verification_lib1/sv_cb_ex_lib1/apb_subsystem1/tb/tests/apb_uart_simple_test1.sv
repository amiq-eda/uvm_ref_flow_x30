/*-------------------------------------------------------------------------
File1 name   : apb_uart_simple_test1.sv
Title1       : Test1 Case1
Project1     :
Created1     :
Description1 : One1 test case for the APB1-UART1 Environment1
Notes1       : The test creates1 a apb_subsystem_tb1 and sets1 the default
            : sequence for the sequencer as u2a_incr_payload1
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

class apb_uart_simple_test1 extends uvm_test;

  apb_subsystem_tb1 ve1;

  `uvm_component_utils(apb_uart_simple_test1)

  function new(input string name, 
                input uvm_component parent=null);
      super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    set_type_override("ahb_master_monitor1", "ahb_monitor1");
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this, "ve1.virtual_sequencer1.run_phase",
          "default_sequence", u2a_incr_payload1::type_id::get());
    ve1 = apb_subsystem_tb1::type_id::create("ve1", this);
  endfunction : build_phase

endclass : apb_uart_simple_test1

