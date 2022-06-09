/*-----------------------------------------------------------------
File19 name     : uart_ctrl_reg_sequencer19.sv
Created19       : Fri19 Mar19 9 2012
Description19   :
Notes19         : 
-------------------------------------------------------------------
Copyright19 2012 (c) Cadence19 Design19 Systems19
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS19: uart_ctrl_reg_sequencer19
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer19 extends uvm_sequencer;

  uart_ctrl_reg_model_c19 reg_model19;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer19)
     `uvm_field_object(reg_model19, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer19
