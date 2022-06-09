/*-----------------------------------------------------------------
File16 name     : uart_ctrl_reg_sequencer16.sv
Created16       : Fri16 Mar16 9 2012
Description16   :
Notes16         : 
-------------------------------------------------------------------
Copyright16 2012 (c) Cadence16 Design16 Systems16
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS16: uart_ctrl_reg_sequencer16
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer16 extends uvm_sequencer;

  uart_ctrl_reg_model_c16 reg_model16;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer16)
     `uvm_field_object(reg_model16, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer16
