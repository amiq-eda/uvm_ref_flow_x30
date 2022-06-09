/*-----------------------------------------------------------------
File22 name     : uart_ctrl_reg_sequencer22.sv
Created22       : Fri22 Mar22 9 2012
Description22   :
Notes22         : 
-------------------------------------------------------------------
Copyright22 2012 (c) Cadence22 Design22 Systems22
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS22: uart_ctrl_reg_sequencer22
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer22 extends uvm_sequencer;

  uart_ctrl_reg_model_c22 reg_model22;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer22)
     `uvm_field_object(reg_model22, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer22
