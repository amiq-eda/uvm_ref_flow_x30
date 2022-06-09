/*-----------------------------------------------------------------
File2 name     : uart_ctrl_reg_sequencer2.sv
Created2       : Fri2 Mar2 9 2012
Description2   :
Notes2         : 
-------------------------------------------------------------------
Copyright2 2012 (c) Cadence2 Design2 Systems2
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS2: uart_ctrl_reg_sequencer2
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer2 extends uvm_sequencer;

  uart_ctrl_reg_model_c2 reg_model2;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer2)
     `uvm_field_object(reg_model2, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer2
