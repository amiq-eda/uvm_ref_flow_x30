/*-------------------------------------------------------------------------
File13 name   : uart_ctrl_virtual_sequencer13.sv
Title13       : Virtual sequencer
Project13     :
Created13     :
Description13 : This13 file implements13 the Virtual sequencer for APB13-UART13 environment13
Notes13       : 
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


class uart_ctrl_virtual_sequencer13 extends uvm_sequencer;

    apb_pkg13::apb_master_sequencer13 apb_seqr13;
    uart_pkg13::uart_sequencer13 uart_seqr13;
    uart_ctrl_reg_sequencer13 reg_seqr;

    // UVM_REG: Pointer13 to the register model
    uart_ctrl_reg_model_c13 reg_model13;
   
    // Uart13 Controller13 configuration object
    uart_ctrl_config13 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer13", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer13)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer13
