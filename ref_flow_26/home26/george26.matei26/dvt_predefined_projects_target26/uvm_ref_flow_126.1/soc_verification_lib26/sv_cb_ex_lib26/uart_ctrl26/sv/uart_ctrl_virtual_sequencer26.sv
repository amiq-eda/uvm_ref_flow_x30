/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_virtual_sequencer26.sv
Title26       : Virtual sequencer
Project26     :
Created26     :
Description26 : This26 file implements26 the Virtual sequencer for APB26-UART26 environment26
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer26 extends uvm_sequencer;

    apb_pkg26::apb_master_sequencer26 apb_seqr26;
    uart_pkg26::uart_sequencer26 uart_seqr26;
    uart_ctrl_reg_sequencer26 reg_seqr;

    // UVM_REG: Pointer26 to the register model
    uart_ctrl_reg_model_c26 reg_model26;
   
    // Uart26 Controller26 configuration object
    uart_ctrl_config26 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer26", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer26)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model26, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer26
