/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_virtual_sequencer30.sv
Title30       : Virtual sequencer
Project30     :
Created30     :
Description30 : This30 file implements30 the Virtual sequencer for APB30-UART30 environment30
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer30 extends uvm_sequencer;

    apb_pkg30::apb_master_sequencer30 apb_seqr30;
    uart_pkg30::uart_sequencer30 uart_seqr30;
    uart_ctrl_reg_sequencer30 reg_seqr;

    // UVM_REG: Pointer30 to the register model
    uart_ctrl_reg_model_c30 reg_model30;
   
    // Uart30 Controller30 configuration object
    uart_ctrl_config30 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer30", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer30)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model30, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer30
