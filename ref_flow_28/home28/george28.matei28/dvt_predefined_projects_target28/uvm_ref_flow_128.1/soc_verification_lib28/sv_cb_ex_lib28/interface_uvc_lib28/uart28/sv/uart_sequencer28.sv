/*-------------------------------------------------------------------------
File28 name   : uart_sequencer28.sv
Title28       : Sequencer file for the UART28 UVC28
Project28     :
Created28     :
Description28 : The sequencer generates28 stream in transaction in term28 of items 
              and sequences of item
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH28
`define UART_SEQUENCER_SVH28

class uart_sequencer28 extends uvm_sequencer #(uart_frame28);

  virtual interface uart_if28 vif28;

  uart_config28 cfg;

  `uvm_component_utils_begin(uart_sequencer28)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config28)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG28", "uart_config28 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer28
`endif // UART_SEQUENCER_SVH28
