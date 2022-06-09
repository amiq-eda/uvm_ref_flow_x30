/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_virtual_sequencer19.sv
Title19       : Virtual sequencer
Project19     :
Created19     :
Description19 : This19 file implements19 the Virtual sequencer for APB19-UART19 environment19
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer19 extends uvm_sequencer;

    apb_pkg19::apb_master_sequencer19 apb_seqr19;
    uart_pkg19::uart_sequencer19 uart_seqr19;
    uart_ctrl_reg_sequencer19 reg_seqr;

    // UVM_REG: Pointer19 to the register model
    uart_ctrl_reg_model_c19 reg_model19;
   
    // Uart19 Controller19 configuration object
    uart_ctrl_config19 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer19", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer19)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model19, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer19
