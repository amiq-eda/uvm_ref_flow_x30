/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_virtual_sequencer6.sv
Title6       : Virtual sequencer
Project6     :
Created6     :
Description6 : This6 file implements6 the Virtual sequencer for APB6-UART6 environment6
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer6 extends uvm_sequencer;

    apb_pkg6::apb_master_sequencer6 apb_seqr6;
    uart_pkg6::uart_sequencer6 uart_seqr6;
    uart_ctrl_reg_sequencer6 reg_seqr;

    // UVM_REG: Pointer6 to the register model
    uart_ctrl_reg_model_c6 reg_model6;
   
    // Uart6 Controller6 configuration object
    uart_ctrl_config6 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer6", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer6)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer6
