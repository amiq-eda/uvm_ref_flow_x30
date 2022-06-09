/*-----------------------------------------------------------------
File25 name     : uart_ctrl_reg_sequencer25.sv
Created25       : Fri25 Mar25 9 2012
Description25   :
Notes25         : 
-------------------------------------------------------------------
Copyright25 2012 (c) Cadence25 Design25 Systems25
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS25: uart_ctrl_reg_sequencer25
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer25 extends uvm_sequencer;

  uart_ctrl_reg_model_c25 reg_model25;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer25)
     `uvm_field_object(reg_model25, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer25
