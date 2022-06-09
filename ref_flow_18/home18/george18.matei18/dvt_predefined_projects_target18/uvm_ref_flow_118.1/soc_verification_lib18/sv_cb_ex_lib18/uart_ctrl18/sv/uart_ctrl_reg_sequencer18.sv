/*-----------------------------------------------------------------
File18 name     : uart_ctrl_reg_sequencer18.sv
Created18       : Fri18 Mar18 9 2012
Description18   :
Notes18         : 
-------------------------------------------------------------------
Copyright18 2012 (c) Cadence18 Design18 Systems18
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS18: uart_ctrl_reg_sequencer18
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer18 extends uvm_sequencer;

  uart_ctrl_reg_model_c18 reg_model18;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer18)
     `uvm_field_object(reg_model18, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer18
