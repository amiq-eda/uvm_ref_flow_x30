/*-----------------------------------------------------------------
File7 name     : uart_ctrl_reg_sequencer7.sv
Created7       : Fri7 Mar7 9 2012
Description7   :
Notes7         : 
-------------------------------------------------------------------
Copyright7 2012 (c) Cadence7 Design7 Systems7
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS7: uart_ctrl_reg_sequencer7
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer7 extends uvm_sequencer;

  uart_ctrl_reg_model_c7 reg_model7;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer7)
     `uvm_field_object(reg_model7, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer7
