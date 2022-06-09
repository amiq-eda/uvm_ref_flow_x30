/*-----------------------------------------------------------------
File10 name     : uart_ctrl_reg_sequencer10.sv
Created10       : Fri10 Mar10 9 2012
Description10   :
Notes10         : 
-------------------------------------------------------------------
Copyright10 2012 (c) Cadence10 Design10 Systems10
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS10: uart_ctrl_reg_sequencer10
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer10 extends uvm_sequencer;

  uart_ctrl_reg_model_c10 reg_model10;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer10)
     `uvm_field_object(reg_model10, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer10
