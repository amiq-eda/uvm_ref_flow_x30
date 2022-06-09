/*-----------------------------------------------------------------
File1 name     : uart_ctrl_reg_sequencer1.sv
Created1       : Fri1 Mar1 9 2012
Description1   :
Notes1         : 
-------------------------------------------------------------------
Copyright1 2012 (c) Cadence1 Design1 Systems1
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS1: uart_ctrl_reg_sequencer1
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer1 extends uvm_sequencer;

  uart_ctrl_reg_model_c1 reg_model1;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer1)
     `uvm_field_object(reg_model1, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer1
