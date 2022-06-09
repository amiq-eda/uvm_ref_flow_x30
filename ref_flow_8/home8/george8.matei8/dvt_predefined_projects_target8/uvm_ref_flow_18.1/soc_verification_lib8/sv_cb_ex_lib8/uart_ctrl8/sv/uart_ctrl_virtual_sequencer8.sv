/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_virtual_sequencer8.sv
Title8       : Virtual sequencer
Project8     :
Created8     :
Description8 : This8 file implements8 the Virtual sequencer for APB8-UART8 environment8
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer8 extends uvm_sequencer;

    apb_pkg8::apb_master_sequencer8 apb_seqr8;
    uart_pkg8::uart_sequencer8 uart_seqr8;
    uart_ctrl_reg_sequencer8 reg_seqr;

    // UVM_REG: Pointer8 to the register model
    uart_ctrl_reg_model_c8 reg_model8;
   
    // Uart8 Controller8 configuration object
    uart_ctrl_config8 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer8", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer8)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model8, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer8
