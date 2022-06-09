/*-------------------------------------------------------------------------
File18 name   : uart_sequencer18.sv
Title18       : Sequencer file for the UART18 UVC18
Project18     :
Created18     :
Description18 : The sequencer generates18 stream in transaction in term18 of items 
              and sequences of item
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH18
`define UART_SEQUENCER_SVH18

class uart_sequencer18 extends uvm_sequencer #(uart_frame18);

  virtual interface uart_if18 vif18;

  uart_config18 cfg;

  `uvm_component_utils_begin(uart_sequencer18)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config18)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG18", "uart_config18 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer18
`endif // UART_SEQUENCER_SVH18
