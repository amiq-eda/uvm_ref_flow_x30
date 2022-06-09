/*-----------------------------------------------------------------
File8 name     : uart_ctrl_reg_sequencer8.sv
Created8       : Fri8 Mar8 9 2012
Description8   :
Notes8         : 
-------------------------------------------------------------------
Copyright8 2012 (c) Cadence8 Design8 Systems8
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS8: uart_ctrl_reg_sequencer8
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer8 extends uvm_sequencer;

  uart_ctrl_reg_model_c8 reg_model8;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer8)
     `uvm_field_object(reg_model8, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer8
