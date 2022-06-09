/*-------------------------------------------------------------------------
File13 name   : uart_sequencer13.sv
Title13       : Sequencer file for the UART13 UVC13
Project13     :
Created13     :
Description13 : The sequencer generates13 stream in transaction in term13 of items 
              and sequences of item
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH13
`define UART_SEQUENCER_SVH13

class uart_sequencer13 extends uvm_sequencer #(uart_frame13);

  virtual interface uart_if13 vif13;

  uart_config13 cfg;

  `uvm_component_utils_begin(uart_sequencer13)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config13)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG13", "uart_config13 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer13
`endif // UART_SEQUENCER_SVH13
