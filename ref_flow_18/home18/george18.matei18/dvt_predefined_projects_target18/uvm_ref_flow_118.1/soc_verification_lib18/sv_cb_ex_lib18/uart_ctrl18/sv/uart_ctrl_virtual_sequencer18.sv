/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_virtual_sequencer18.sv
Title18       : Virtual sequencer
Project18     :
Created18     :
Description18 : This18 file implements18 the Virtual sequencer for APB18-UART18 environment18
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


class uart_ctrl_virtual_sequencer18 extends uvm_sequencer;

    apb_pkg18::apb_master_sequencer18 apb_seqr18;
    uart_pkg18::uart_sequencer18 uart_seqr18;
    uart_ctrl_reg_sequencer18 reg_seqr;

    // UVM_REG: Pointer18 to the register model
    uart_ctrl_reg_model_c18 reg_model18;
   
    // Uart18 Controller18 configuration object
    uart_ctrl_config18 cfg;

    function new (input string name="uart_ctrl_virtual_sequencer18", input uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    `uvm_component_utils_begin(uart_ctrl_virtual_sequencer18)
       `uvm_field_object(cfg, UVM_DEFAULT | UVM_NOPRINT)
       `uvm_field_object(reg_model18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end

endclass : uart_ctrl_virtual_sequencer18
