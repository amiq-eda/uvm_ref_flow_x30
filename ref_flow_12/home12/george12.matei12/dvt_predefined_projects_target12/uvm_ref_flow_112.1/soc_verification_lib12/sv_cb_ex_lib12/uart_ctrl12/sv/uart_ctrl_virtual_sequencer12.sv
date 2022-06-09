/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_virtual_sequencer12.sv
Title12       : Virtual sequencer
Project12     :
Created12     :
Description12 : This12 file implements12 the Virtual sequencer for APB12-UART12 environment12
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer12 extends uvm_sequencer;

    apb_pkg12::apb_master_sequencer12 apb_seqr12;
    uart_pkg12::uart_sequencer12 uart_seqr12;
    uart_ctrl_reg_sequencer12 reg_seqr;

    // UVM_REG: Pointer12 to the register model
    uart_ctrl_reg_model_c12 reg_model12;
   
    // Uart12 Controller12 configuration object
    uart_ctrl_config12 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer12", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer12)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model12, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer12
