/*-------------------------------------------------------------------------
File11 name   : uart_ctrl_virtual_sequencer11.sv
Title11       : Virtual sequencer
Project11     :
Created11     :
Description11 : This11 file implements11 the Virtual sequencer for APB11-UART11 environment11
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer11 extends uvm_sequencer;

    apb_pkg11::apb_master_sequencer11 apb_seqr11;
    uart_pkg11::uart_sequencer11 uart_seqr11;
    uart_ctrl_reg_sequencer11 reg_seqr;

    // UVM_REG: Pointer11 to the register model
    uart_ctrl_reg_model_c11 reg_model11;
   
    // Uart11 Controller11 configuration object
    uart_ctrl_config11 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer11", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer11)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model11, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer11
