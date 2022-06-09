/*-------------------------------------------------------------------------
File16 name   : uart_sequencer16.sv
Title16       : Sequencer file for the UART16 UVC16
Project16     :
Created16     :
Description16 : The sequencer generates16 stream in transaction in term16 of items 
              and sequences of item
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH16
`define UART_SEQUENCER_SVH16

class uart_sequencer16 extends uvm_sequencer #(uart_frame16);

  virtual interface uart_if16 vif16;

  uart_config16 cfg;

  `uvm_component_utils_begin(uart_sequencer16)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config16)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG16", "uart_config16 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer16
`endif // UART_SEQUENCER_SVH16
