/*-----------------------------------------------------------------
File9 name     : uart_ctrl_reg_sequencer9.sv
Created9       : Fri9 Mar9 9 2012
Description9   :
Notes9         : 
-------------------------------------------------------------------
Copyright9 2012 (c) Cadence9 Design9 Systems9
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS9: uart_ctrl_reg_sequencer9
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer9 extends uvm_sequencer;

  uart_ctrl_reg_model_c9 reg_model9;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer9)
     `uvm_field_object(reg_model9, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer9
