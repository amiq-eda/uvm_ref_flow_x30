/*-----------------------------------------------------------------
File3 name     : uart_ctrl_reg_sequencer3.sv
Created3       : Fri3 Mar3 9 2012
Description3   :
Notes3         : 
-------------------------------------------------------------------
Copyright3 2012 (c) Cadence3 Design3 Systems3
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS3: uart_ctrl_reg_sequencer3
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer3 extends uvm_sequencer;

  uart_ctrl_reg_model_c3 reg_model3;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer3)
     `uvm_field_object(reg_model3, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer3
