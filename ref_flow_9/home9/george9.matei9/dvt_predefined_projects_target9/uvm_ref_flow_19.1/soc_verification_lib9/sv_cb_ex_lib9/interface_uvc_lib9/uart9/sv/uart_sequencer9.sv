/*-------------------------------------------------------------------------
File9 name   : uart_sequencer9.sv
Title9       : Sequencer file for the UART9 UVC9
Project9     :
Created9     :
Description9 : The sequencer generates9 stream in transaction in term9 of items 
              and sequences of item
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH9
`define UART_SEQUENCER_SVH9

class uart_sequencer9 extends uvm_sequencer #(uart_frame9);

  virtual interface uart_if9 vif9;

  uart_config9 cfg;

  `uvm_component_utils_begin(uart_sequencer9)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config9)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG9", "uart_config9 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer9
`endif // UART_SEQUENCER_SVH9
