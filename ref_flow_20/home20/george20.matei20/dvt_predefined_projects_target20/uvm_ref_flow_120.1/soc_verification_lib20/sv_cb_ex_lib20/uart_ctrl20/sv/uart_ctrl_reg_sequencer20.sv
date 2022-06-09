/*-----------------------------------------------------------------
File20 name     : uart_ctrl_reg_sequencer20.sv
Created20       : Fri20 Mar20 9 2012
Description20   :
Notes20         : 
-------------------------------------------------------------------
Copyright20 2012 (c) Cadence20 Design20 Systems20
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS20: uart_ctrl_reg_sequencer20
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer20 extends uvm_sequencer;

  uart_ctrl_reg_model_c20 reg_model20;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer20)
     `uvm_field_object(reg_model20, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer20
