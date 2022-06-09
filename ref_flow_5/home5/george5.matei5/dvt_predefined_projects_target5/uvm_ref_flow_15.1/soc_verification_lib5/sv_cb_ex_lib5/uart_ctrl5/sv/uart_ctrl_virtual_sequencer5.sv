/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_virtual_sequencer5.sv
Title5       : Virtual sequencer
Project5     :
Created5     :
Description5 : This5 file implements5 the Virtual sequencer for APB5-UART5 environment5
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer5 extends uvm_sequencer;

    apb_pkg5::apb_master_sequencer5 apb_seqr5;
    uart_pkg5::uart_sequencer5 uart_seqr5;
    uart_ctrl_reg_sequencer5 reg_seqr;

    // UVM_REG: Pointer5 to the register model
    uart_ctrl_reg_model_c5 reg_model5;
   
    // Uart5 Controller5 configuration object
    uart_ctrl_config5 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer5", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer5)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model5, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer5
