/*-------------------------------------------------------------------------
File10 name   : uart_sequencer10.sv
Title10       : Sequencer file for the UART10 UVC10
Project10     :
Created10     :
Description10 : The sequencer generates10 stream in transaction in term10 of items 
              and sequences of item
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH10
`define UART_SEQUENCER_SVH10

class uart_sequencer10 extends uvm_sequencer #(uart_frame10);

  virtual interface uart_if10 vif10;

  uart_config10 cfg;

  `uvm_component_utils_begin(uart_sequencer10)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config10)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG10", "uart_config10 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer10
`endif // UART_SEQUENCER_SVH10
