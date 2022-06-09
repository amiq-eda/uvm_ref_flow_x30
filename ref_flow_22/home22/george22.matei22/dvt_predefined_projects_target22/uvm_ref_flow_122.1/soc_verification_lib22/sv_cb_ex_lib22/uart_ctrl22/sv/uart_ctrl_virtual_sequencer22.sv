/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_virtual_sequencer22.sv
Title22       : Virtual sequencer
Project22     :
Created22     :
Description22 : This22 file implements22 the Virtual sequencer for APB22-UART22 environment22
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer22 extends uvm_sequencer;

    apb_pkg22::apb_master_sequencer22 apb_seqr22;
    uart_pkg22::uart_sequencer22 uart_seqr22;
    uart_ctrl_reg_sequencer22 reg_seqr;

    // UVM_REG: Pointer22 to the register model
    uart_ctrl_reg_model_c22 reg_model22;
   
    // Uart22 Controller22 configuration object
    uart_ctrl_config22 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer22", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer22)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model22, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer22
