/*-----------------------------------------------------------------
File17 name     : uart_ctrl_reg_sequencer17.sv
Created17       : Fri17 Mar17 9 2012
Description17   :
Notes17         : 
-------------------------------------------------------------------
Copyright17 2012 (c) Cadence17 Design17 Systems17
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
// CLASS17: uart_ctrl_reg_sequencer17
//------------------------------------------------------------------------------
class uart_ctrl_reg_sequencer17 extends uvm_sequencer;

  uart_ctrl_reg_model_c17 reg_model17;

  `uvm_component_utils_begin(uart_ctrl_reg_sequencer17)
     `uvm_field_object(reg_model17, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_ctrl_reg_sequencer17
