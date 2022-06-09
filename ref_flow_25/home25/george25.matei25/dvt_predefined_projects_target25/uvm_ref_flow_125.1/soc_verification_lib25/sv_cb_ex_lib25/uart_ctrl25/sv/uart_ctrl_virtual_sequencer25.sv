/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_virtual_sequencer25.sv
Title25       : Virtual sequencer
Project25     :
Created25     :
Description25 : This25 file implements25 the Virtual sequencer for APB25-UART25 environment25
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer25 extends uvm_sequencer;

    apb_pkg25::apb_master_sequencer25 apb_seqr25;
    uart_pkg25::uart_sequencer25 uart_seqr25;
    uart_ctrl_reg_sequencer25 reg_seqr;

    // UVM_REG: Pointer25 to the register model
    uart_ctrl_reg_model_c25 reg_model25;
   
    // Uart25 Controller25 configuration object
    uart_ctrl_config25 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer25", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer25)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model25, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer25
