/*-------------------------------------------------------------------------
File23 name   : uart_sequencer23.sv
Title23       : Sequencer file for the UART23 UVC23
Project23     :
Created23     :
Description23 : The sequencer generates23 stream in transaction in term23 of items 
              and sequences of item
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH23
`define UART_SEQUENCER_SVH23

class uart_sequencer23 extends uvm_sequencer #(uart_frame23);

  virtual interface uart_if23 vif23;

  uart_config23 cfg;

  `uvm_component_utils_begin(uart_sequencer23)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config23)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG23", "uart_config23 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer23
`endif // UART_SEQUENCER_SVH23
