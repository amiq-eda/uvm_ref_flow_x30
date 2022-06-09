/*-----------------------------------------------------------------
File28 name     : uart_ctrl_reg_sequencer28.sv
Created28       : Fri28 Mar28 9 2012
Description28   :
Notes28         : 
-------------------------------------------------------------------
Copyright28 2012 (c) Cadence28 Design28 Systems28
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS28: uart_ctrl_reg_sequencer28
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer28 extends uvm_sequencer;

  uart_ctrl_reg_model_c28 reg_model28;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer28)
     `uvm_field_object(reg_model28, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer28
