/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_virtual_sequencer24.sv
Title24       : Virtual sequencer
Project24     :
Created24     :
Description24 : This24 file implements24 the Virtual sequencer for APB24-UART24 environment24
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer24 extends uvm_sequencer;

    apb_pkg24::apb_master_sequencer24 apb_seqr24;
    uart_pkg24::uart_sequencer24 uart_seqr24;
    uart_ctrl_reg_sequencer24 reg_seqr;

    // UVM_REG: Pointer24 to the register model
    uart_ctrl_reg_model_c24 reg_model24;
   
    // Uart24 Controller24 configuration object
    uart_ctrl_config24 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer24", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer24)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model24, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer24
