/*-----------------------------------------------------------------
File15 name     : uart_ctrl_reg_sequencer15.sv
Created15       : Fri15 Mar15 9 2012
Description15   :
Notes15         : 
-------------------------------------------------------------------
Copyright15 2012 (c) Cadence15 Design15 Systems15
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS15: uart_ctrl_reg_sequencer15
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer15 extends uvm_sequencer;

  uart_ctrl_reg_model_c15 reg_model15;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer15)
     `uvm_field_object(reg_model15, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer15
