/*-------------------------------------------------------------------------
File30 name   : uart_sequencer30.sv
Title30       : Sequencer file for the UART30 UVC30
Project30     :
Created30     :
Description30 : The sequencer generates30 stream in transaction in term30 of items 
              and sequences of item
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH30
`define UART_SEQUENCER_SVH30

class uart_sequencer30 extends uvm_sequencer #(uart_frame30);

  virtual interface uart_if30 vif30;

  uart_config30 cfg;

  `uvm_component_utils_begin(uart_sequencer30)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config30)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG30", "uart_config30 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer30
`endif // UART_SEQUENCER_SVH30
