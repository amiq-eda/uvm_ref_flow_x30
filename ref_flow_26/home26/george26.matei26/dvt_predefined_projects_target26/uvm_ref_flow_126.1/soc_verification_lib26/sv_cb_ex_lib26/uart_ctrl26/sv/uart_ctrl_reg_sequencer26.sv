/*-----------------------------------------------------------------
File26 name     : uart_ctrl_reg_sequencer26.sv
Created26       : Fri26 Mar26 9 2012
Description26   :
Notes26         : 
-------------------------------------------------------------------
Copyright26 2012 (c) Cadence26 Design26 Systems26
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS26: uart_ctrl_reg_sequencer26
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer26 extends uvm_sequencer;

  uart_ctrl_reg_model_c26 reg_model26;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer26)
     `uvm_field_object(reg_model26, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer26
