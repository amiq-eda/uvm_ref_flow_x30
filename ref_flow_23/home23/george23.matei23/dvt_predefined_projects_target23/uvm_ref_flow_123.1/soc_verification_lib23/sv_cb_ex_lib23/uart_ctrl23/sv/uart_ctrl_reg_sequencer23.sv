/*-----------------------------------------------------------------
File23 name     : uart_ctrl_reg_sequencer23.sv
Created23       : Fri23 Mar23 9 2012
Description23   :
Notes23         : 
-------------------------------------------------------------------
Copyright23 2012 (c) Cadence23 Design23 Systems23
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS23: uart_ctrl_reg_sequencer23
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer23 extends uvm_sequencer;

  uart_ctrl_reg_model_c23 reg_model23;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer23)
     `uvm_field_object(reg_model23, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer23
