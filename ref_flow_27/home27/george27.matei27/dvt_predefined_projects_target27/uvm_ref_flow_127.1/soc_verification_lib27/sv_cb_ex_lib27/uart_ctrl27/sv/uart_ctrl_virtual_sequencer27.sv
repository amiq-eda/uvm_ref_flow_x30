/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_virtual_sequencer27.sv
Title27       : Virtual sequencer
Project27     :
Created27     :
Description27 : This27 file implements27 the Virtual sequencer for APB27-UART27 environment27
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer27 extends uvm_sequencer;

    apb_pkg27::apb_master_sequencer27 apb_seqr27;
    uart_pkg27::uart_sequencer27 uart_seqr27;
    uart_ctrl_reg_sequencer27 reg_seqr;

    // UVM_REG: Pointer27 to the register model
    uart_ctrl_reg_model_c27 reg_model27;
   
    // Uart27 Controller27 configuration object
    uart_ctrl_config27 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer27", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer27)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model27, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer27
