/*-------------------------------------------------------------------------
File7 name   : uart_ctrl_virtual_sequencer7.sv
Title7       : Virtual sequencer
Project7     :
Created7     :
Description7 : This7 file implements7 the Virtual sequencer for APB7-UART7 environment7
Notes7       : 
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


class uart_ctrl_virtual_sequencer7 extends uvm_sequencer;

    apb_pkg7::apb_master_sequencer7 apb_seqr7;
    uart_pkg7::uart_sequencer7 uart_seqr7;
    uart_ctrl_reg_sequencer7 reg_seqr;

    // UVM_REG: Pointer7 to the register model
    uart_ctrl_reg_model_c7 reg_model7;
   
    // Uart7 Controller7 configuration object
    uart_ctrl_config7 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer7", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer7)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model7, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer7
