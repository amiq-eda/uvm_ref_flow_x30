/*-----------------------------------------------------------------
File12 name     : uart_ctrl_reg_sequencer12.sv
Created12       : Fri12 Mar12 9 2012
Description12   :
Notes12         : 
-------------------------------------------------------------------
Copyright12 2012 (c) Cadence12 Design12 Systems12
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS12: uart_ctrl_reg_sequencer12
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer12 extends uvm_sequencer;

  uart_ctrl_reg_model_c12 reg_model12;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer12)
     `uvm_field_object(reg_model12, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer12
