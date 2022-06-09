/*-------------------------------------------------------------------------
File22 name   : uart_sequencer22.sv
Title22       : Sequencer file for the UART22 UVC22
Project22     :
Created22     :
Description22 : The sequencer generates22 stream in transaction in term22 of items 
              and sequences of item
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH22
`define UART_SEQUENCER_SVH22

class uart_sequencer22 extends uvm_sequencer #(uart_frame22);

  virtual interface uart_if22 vif22;

  uart_config22 cfg;

  `uvm_component_utils_begin(uart_sequencer22)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config22)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG22", "uart_config22 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer22
`endif // UART_SEQUENCER_SVH22
