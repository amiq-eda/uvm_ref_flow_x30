/*-----------------------------------------------------------------
File30 name     : uart_ctrl_reg_sequencer30.sv
Created30       : Fri30 Mar30 9 2012
Description30   :
Notes30         : 
-------------------------------------------------------------------
Copyright30 2012 (c) Cadence30 Design30 Systems30
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS30: uart_ctrl_reg_sequencer30
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer30 extends uvm_sequencer;

  uart_ctrl_reg_model_c30 reg_model30;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer30)
     `uvm_field_object(reg_model30, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer30
