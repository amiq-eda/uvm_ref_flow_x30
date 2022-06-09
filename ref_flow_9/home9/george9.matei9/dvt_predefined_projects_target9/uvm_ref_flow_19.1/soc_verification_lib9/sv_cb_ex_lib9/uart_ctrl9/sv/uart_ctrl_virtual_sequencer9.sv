/*-------------------------------------------------------------------------
File9 name   : uart_ctrl_virtual_sequencer9.sv
Title9       : Virtual sequencer
Project9     :
Created9     :
Description9 : This9 file implements9 the Virtual sequencer for APB9-UART9 environment9
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer9 extends uvm_sequencer;

    apb_pkg9::apb_master_sequencer9 apb_seqr9;
    uart_pkg9::uart_sequencer9 uart_seqr9;
    uart_ctrl_reg_sequencer9 reg_seqr;

    // UVM_REG: Pointer9 to the register model
    uart_ctrl_reg_model_c9 reg_model9;
   
    // Uart9 Controller9 configuration object
    uart_ctrl_config9 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer9", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer9)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model9, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer9
