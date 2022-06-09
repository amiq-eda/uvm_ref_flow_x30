/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_virtual_sequencer29.sv
Title29       : Virtual sequencer
Project29     :
Created29     :
Description29 : This29 file implements29 the Virtual sequencer for APB29-UART29 environment29
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer29 extends uvm_sequencer;

    apb_pkg29::apb_master_sequencer29 apb_seqr29;
    uart_pkg29::uart_sequencer29 uart_seqr29;
    uart_ctrl_reg_sequencer29 reg_seqr;

    // UVM_REG: Pointer29 to the register model
    uart_ctrl_reg_model_c29 reg_model29;
   
    // Uart29 Controller29 configuration object
    uart_ctrl_config29 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer29", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer29)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model29, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer29
