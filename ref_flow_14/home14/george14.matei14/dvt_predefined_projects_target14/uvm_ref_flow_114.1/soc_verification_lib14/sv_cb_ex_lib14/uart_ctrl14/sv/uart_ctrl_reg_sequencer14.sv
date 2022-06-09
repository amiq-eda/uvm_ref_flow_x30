/*-----------------------------------------------------------------
File14 name     : uart_ctrl_reg_sequencer14.sv
Created14       : Fri14 Mar14 9 2012
Description14   :
Notes14         : 
-------------------------------------------------------------------
Copyright14 2012 (c) Cadence14 Design14 Systems14
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS14: uart_ctrl_reg_sequencer14
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer14 extends uvm_sequencer;

  uart_ctrl_reg_model_c14 reg_model14;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer14)
     `uvm_field_object(reg_model14, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer14
