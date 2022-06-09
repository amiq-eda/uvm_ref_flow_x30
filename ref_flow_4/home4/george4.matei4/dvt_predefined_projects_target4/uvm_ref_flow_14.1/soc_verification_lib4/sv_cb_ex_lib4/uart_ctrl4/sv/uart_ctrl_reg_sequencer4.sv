/*-----------------------------------------------------------------
File4 name     : uart_ctrl_reg_sequencer4.sv
Created4       : Fri4 Mar4 9 2012
Description4   :
Notes4         : 
-------------------------------------------------------------------
Copyright4 2012 (c) Cadence4 Design4 Systems4
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS4: uart_ctrl_reg_sequencer4
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer4 extends uvm_sequencer;

  uart_ctrl_reg_model_c4 reg_model4;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer4)
     `uvm_field_object(reg_model4, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer4
