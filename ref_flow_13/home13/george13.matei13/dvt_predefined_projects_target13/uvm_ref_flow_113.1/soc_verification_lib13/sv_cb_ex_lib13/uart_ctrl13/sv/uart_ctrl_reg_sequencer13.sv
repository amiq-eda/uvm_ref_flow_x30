/*-----------------------------------------------------------------
File13 name     : uart_ctrl_reg_sequencer13.sv
Created13       : Fri13 Mar13 9 2012
Description13   :
Notes13         : 
-------------------------------------------------------------------
Copyright13 2012 (c) Cadence13 Design13 Systems13
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS13: uart_ctrl_reg_sequencer13
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer13 extends uvm_sequencer;

  uart_ctrl_reg_model_c13 reg_model13;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer13)
     `uvm_field_object(reg_model13, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer13
