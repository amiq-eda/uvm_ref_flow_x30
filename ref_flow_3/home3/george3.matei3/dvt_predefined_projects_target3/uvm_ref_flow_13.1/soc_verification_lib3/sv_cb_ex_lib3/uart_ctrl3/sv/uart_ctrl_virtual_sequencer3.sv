/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_virtual_sequencer3.sv
Title3       : Virtual sequencer
Project3     :
Created3     :
Description3 : This3 file implements3 the Virtual sequencer for APB3-UART3 environment3
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer3 extends uvm_sequencer;

    apb_pkg3::apb_master_sequencer3 apb_seqr3;
    uart_pkg3::uart_sequencer3 uart_seqr3;
    uart_ctrl_reg_sequencer3 reg_seqr;

    // UVM_REG: Pointer3 to the register model
    uart_ctrl_reg_model_c3 reg_model3;
   
    // Uart3 Controller3 configuration object
    uart_ctrl_config3 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer3", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer3)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model3, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer3
