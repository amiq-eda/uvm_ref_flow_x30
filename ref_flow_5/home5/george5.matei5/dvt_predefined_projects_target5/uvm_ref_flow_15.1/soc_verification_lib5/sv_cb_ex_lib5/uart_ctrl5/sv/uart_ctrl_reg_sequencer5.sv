/*-----------------------------------------------------------------
File5 name     : uart_ctrl_reg_sequencer5.sv
Created5       : Fri5 Mar5 9 2012
Description5   :
Notes5         : 
-------------------------------------------------------------------
Copyright5 2012 (c) Cadence5 Design5 Systems5
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS5: uart_ctrl_reg_sequencer5
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer5 extends uvm_sequencer;

  uart_ctrl_reg_model_c5 reg_model5;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer5)
     `uvm_field_object(reg_model5, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer5
