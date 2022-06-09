/*-------------------------------------------------------------------------
File15 name   : uart_ctrl_virtual_sequencer15.sv
Title15       : Virtual sequencer
Project15     :
Created15     :
Description15 : This15 file implements15 the Virtual sequencer for APB15-UART15 environment15
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer15 extends uvm_sequencer;

    apb_pkg15::apb_master_sequencer15 apb_seqr15;
    uart_pkg15::uart_sequencer15 uart_seqr15;
    uart_ctrl_reg_sequencer15 reg_seqr;

    // UVM_REG: Pointer15 to the register model
    uart_ctrl_reg_model_c15 reg_model15;
   
    // Uart15 Controller15 configuration object
    uart_ctrl_config15 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer15", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer15)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model15, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer15
