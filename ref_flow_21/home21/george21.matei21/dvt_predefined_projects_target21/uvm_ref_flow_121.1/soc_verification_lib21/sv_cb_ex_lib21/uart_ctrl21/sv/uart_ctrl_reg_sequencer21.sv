/*-----------------------------------------------------------------
File21 name     : uart_ctrl_reg_sequencer21.sv
Created21       : Fri21 Mar21 9 2012
Description21   :
Notes21         : 
-------------------------------------------------------------------
Copyright21 2012 (c) Cadence21 Design21 Systems21
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS21: uart_ctrl_reg_sequencer21
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer21 extends uvm_sequencer;

  uart_ctrl_reg_model_c21 reg_model21;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer21)
     `uvm_field_object(reg_model21, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer21
