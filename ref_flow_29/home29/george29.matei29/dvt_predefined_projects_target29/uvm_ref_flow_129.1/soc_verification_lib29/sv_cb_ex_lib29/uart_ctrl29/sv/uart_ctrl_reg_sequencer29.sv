/*-----------------------------------------------------------------
File29 name     : uart_ctrl_reg_sequencer29.sv
Created29       : Fri29 Mar29 9 2012
Description29   :
Notes29         : 
-------------------------------------------------------------------
Copyright29 2012 (c) Cadence29 Design29 Systems29
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS29: uart_ctrl_reg_sequencer29
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer29 extends uvm_sequencer;

  uart_ctrl_reg_model_c29 reg_model29;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer29)
     `uvm_field_object(reg_model29, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer29
