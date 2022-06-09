/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_virtual_sequencer23.sv
Title23       : Virtual sequencer
Project23     :
Created23     :
Description23 : This23 file implements23 the Virtual sequencer for APB23-UART23 environment23
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer23 extends uvm_sequencer;

    apb_pkg23::apb_master_sequencer23 apb_seqr23;
    uart_pkg23::uart_sequencer23 uart_seqr23;
    uart_ctrl_reg_sequencer23 reg_seqr;

    // UVM_REG: Pointer23 to the register model
    uart_ctrl_reg_model_c23 reg_model23;
   
    // Uart23 Controller23 configuration object
    uart_ctrl_config23 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer23", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer23)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model23, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer23
