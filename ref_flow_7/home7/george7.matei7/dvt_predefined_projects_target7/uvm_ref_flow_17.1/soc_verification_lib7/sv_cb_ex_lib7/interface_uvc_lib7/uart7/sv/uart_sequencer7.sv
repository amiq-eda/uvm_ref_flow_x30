/*-------------------------------------------------------------------------
File7 name   : uart_sequencer7.sv
Title7       : Sequencer file for the UART7 UVC7
Project7     :
Created7     :
Description7 : The sequencer generates7 stream in transaction in term7 of items 
              and sequences of item
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH7
`define UART_SEQUENCER_SVH7

class uart_sequencer7 extends uvm_sequencer #(uart_frame7);

  virtual interface uart_if7 vif7;

  uart_config7 cfg;

  `uvm_component_utils_begin(uart_sequencer7)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config7)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG7", "uart_config7 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer7
`endif // UART_SEQUENCER_SVH7
