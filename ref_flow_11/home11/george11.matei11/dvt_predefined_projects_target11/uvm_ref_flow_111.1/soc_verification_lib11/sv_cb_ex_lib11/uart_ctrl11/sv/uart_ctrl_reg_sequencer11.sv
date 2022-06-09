/*-----------------------------------------------------------------
File11 name     : uart_ctrl_reg_sequencer11.sv
Created11       : Fri11 Mar11 9 2012
Description11   :
Notes11         : 
-------------------------------------------------------------------
Copyright11 2012 (c) Cadence11 Design11 Systems11
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS11: uart_ctrl_reg_sequencer11
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer11 extends uvm_sequencer;

  uart_ctrl_reg_model_c11 reg_model11;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer11)
     `uvm_field_object(reg_model11, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer11
