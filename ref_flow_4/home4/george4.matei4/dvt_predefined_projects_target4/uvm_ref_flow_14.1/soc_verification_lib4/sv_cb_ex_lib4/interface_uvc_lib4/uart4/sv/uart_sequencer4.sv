/*-------------------------------------------------------------------------
File4 name   : uart_sequencer4.sv
Title4       : Sequencer file for the UART4 UVC4
Project4     :
Created4     :
Description4 : The sequencer generates4 stream in transaction in term4 of items 
              and sequences of item
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH4
`define UART_SEQUENCER_SVH4

class uart_sequencer4 extends uvm_sequencer #(uart_frame4);

  virtual interface uart_if4 vif4;

  uart_config4 cfg;

  `uvm_component_utils_begin(uart_sequencer4)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config4)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG4", "uart_config4 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer4
`endif // UART_SEQUENCER_SVH4
