/*-----------------------------------------------------------------
File27 name     : uart_ctrl_reg_sequencer27.sv
Created27       : Fri27 Mar27 9 2012
Description27   :
Notes27         : 
-------------------------------------------------------------------
Copyright27 2012 (c) Cadence27 Design27 Systems27
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS27: uart_ctrl_reg_sequencer27
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer27 extends uvm_sequencer;

  uart_ctrl_reg_model_c27 reg_model27;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer27)
     `uvm_field_object(reg_model27, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer27
