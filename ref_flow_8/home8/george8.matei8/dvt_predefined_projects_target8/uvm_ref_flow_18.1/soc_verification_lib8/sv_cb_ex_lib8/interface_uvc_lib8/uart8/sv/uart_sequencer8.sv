/*-------------------------------------------------------------------------
File8 name   : uart_sequencer8.sv
Title8       : Sequencer file for the UART8 UVC8
Project8     :
Created8     :
Description8 : The sequencer generates8 stream in transaction in term8 of items 
              and sequences of item
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH8
`define UART_SEQUENCER_SVH8

class uart_sequencer8 extends uvm_sequencer #(uart_frame8);

  virtual interface uart_if8 vif8;

  uart_config8 cfg;

  `uvm_component_utils_begin(uart_sequencer8)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config8)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG8", "uart_config8 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer8
`endif // UART_SEQUENCER_SVH8
