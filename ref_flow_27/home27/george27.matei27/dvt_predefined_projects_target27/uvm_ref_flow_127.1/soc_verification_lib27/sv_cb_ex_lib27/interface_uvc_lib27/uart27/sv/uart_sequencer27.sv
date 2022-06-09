/*-------------------------------------------------------------------------
File27 name   : uart_sequencer27.sv
Title27       : Sequencer file for the UART27 UVC27
Project27     :
Created27     :
Description27 : The sequencer generates27 stream in transaction in term27 of items 
              and sequences of item
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH27
`define UART_SEQUENCER_SVH27

class uart_sequencer27 extends uvm_sequencer #(uart_frame27);

  virtual interface uart_if27 vif27;

  uart_config27 cfg;

  `uvm_component_utils_begin(uart_sequencer27)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config27)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG27", "uart_config27 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer27
`endif // UART_SEQUENCER_SVH27
