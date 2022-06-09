/*-------------------------------------------------------------------------
File21 name   : uart_ctrl_virtual_sequencer21.sv
Title21       : Virtual sequencer
Project21     :
Created21     :
Description21 : This21 file implements21 the Virtual sequencer for APB21-UART21 environment21
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer21 extends uvm_sequencer;

    apb_pkg21::apb_master_sequencer21 apb_seqr21;
    uart_pkg21::uart_sequencer21 uart_seqr21;
    uart_ctrl_reg_sequencer21 reg_seqr;

    // UVM_REG: Pointer21 to the register model
    uart_ctrl_reg_model_c21 reg_model21;
   
    // Uart21 Controller21 configuration object
    uart_ctrl_config21 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer21", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer21)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer21
