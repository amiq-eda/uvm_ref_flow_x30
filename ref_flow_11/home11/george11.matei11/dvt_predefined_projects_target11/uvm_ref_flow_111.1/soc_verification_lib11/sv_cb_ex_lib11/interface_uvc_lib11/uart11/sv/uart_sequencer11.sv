/*-------------------------------------------------------------------------
File11 name   : uart_sequencer11.sv
Title11       : Sequencer file for the UART11 UVC11
Project11     :
Created11     :
Description11 : The sequencer generates11 stream in transaction in term11 of items 
              and sequences of item
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH11
`define UART_SEQUENCER_SVH11

class uart_sequencer11 extends uvm_sequencer #(uart_frame11);

  virtual interface uart_if11 vif11;

  uart_config11 cfg;

  `uvm_component_utils_begin(uart_sequencer11)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config11)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG11", "uart_config11 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer11
`endif // UART_SEQUENCER_SVH11
