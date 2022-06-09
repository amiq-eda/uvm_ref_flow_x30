/*-----------------------------------------------------------------
File6 name     : uart_ctrl_reg_sequencer6.sv
Created6       : Fri6 Mar6 9 2012
Description6   :
Notes6         : 
-------------------------------------------------------------------
Copyright6 2012 (c) Cadence6 Design6 Systems6
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS6: uart_ctrl_reg_sequencer6
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer6 extends uvm_sequencer;

  uart_ctrl_reg_model_c6 reg_model6;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer6)
     `uvm_field_object(reg_model6, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer6
