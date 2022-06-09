/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_virtual_sequencer28.sv
Title28       : Virtual sequencer
Project28     :
Created28     :
Description28 : This28 file implements28 the Virtual sequencer for APB28-UART28 environment28
Notes28       : 
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


class uart_ctrl_virtual_sequencer28 extends uvm_sequencer;

    apb_pkg28::apb_master_sequencer28 apb_seqr28;
    uart_pkg28::uart_sequencer28 uart_seqr28;
    uart_ctrl_reg_sequencer28 reg_seqr;

    // UVM_REG: Pointer28 to the register model
    uart_ctrl_reg_model_c28 reg_model28;
   
    // Uart28 Controller28 configuration object
    uart_ctrl_config28 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer28", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer28)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model28, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer28
