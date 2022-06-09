/*-------------------------------------------------------------------------
File4 name   : uart_ctrl_virtual_sequencer4.sv
Title4       : Virtual sequencer
Project4     :
Created4     :
Description4 : This4 file implements4 the Virtual sequencer for APB4-UART4 environment4
Notes4       : 
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


class uart_ctrl_virtual_sequencer4 extends uvm_sequencer;

    apb_pkg4::apb_master_sequencer4 apb_seqr4;
    uart_pkg4::uart_sequencer4 uart_seqr4;
    uart_ctrl_reg_sequencer4 reg_seqr;

    // UVM_REG: Pointer4 to the register model
    uart_ctrl_reg_model_c4 reg_model4;
   
    // Uart4 Controller4 configuration object
    uart_ctrl_config4 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer4", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer4)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer4
