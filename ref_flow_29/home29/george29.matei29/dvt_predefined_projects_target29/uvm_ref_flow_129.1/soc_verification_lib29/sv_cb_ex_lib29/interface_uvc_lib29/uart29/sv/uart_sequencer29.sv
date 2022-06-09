/*-------------------------------------------------------------------------
File29 name   : uart_sequencer29.sv
Title29       : Sequencer file for the UART29 UVC29
Project29     :
Created29     :
Description29 : The sequencer generates29 stream in transaction in term29 of items 
              and sequences of item
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH29
`define UART_SEQUENCER_SVH29

class uart_sequencer29 extends uvm_sequencer #(uart_frame29);

  virtual interface uart_if29 vif29;

  uart_config29 cfg;

  `uvm_component_utils_begin(uart_sequencer29)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config29)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG29", "uart_config29 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer29
`endif // UART_SEQUENCER_SVH29
