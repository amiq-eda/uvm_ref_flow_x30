/*-----------------------------------------------------------------
File24 name     : uart_ctrl_reg_sequencer24.sv
Created24       : Fri24 Mar24 9 2012
Description24   :
Notes24         : 
-------------------------------------------------------------------
Copyright24 2012 (c) Cadence24 Design24 Systems24
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS24: uart_ctrl_reg_sequencer24
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer24 extends uvm_sequencer;

  uart_ctrl_reg_model_c24 reg_model24;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer24)
     `uvm_field_object(reg_model24, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer24
