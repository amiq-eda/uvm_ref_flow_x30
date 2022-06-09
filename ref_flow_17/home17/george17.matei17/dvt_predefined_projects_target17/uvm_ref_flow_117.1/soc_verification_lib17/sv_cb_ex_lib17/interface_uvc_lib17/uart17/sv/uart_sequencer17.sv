/*-------------------------------------------------------------------------
File17 name   : uart_sequencer17.sv
Title17       : Sequencer file for the UART17 UVC17
Project17     :
Created17     :
Description17 : The sequencer generates17 stream in transaction in term17 of items 
              and sequences of item
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH17
`define UART_SEQUENCER_SVH17

class uart_sequencer17 extends uvm_sequencer #(uart_frame17);

  virtual interface uart_if17 vif17;

  uart_config17 cfg;

  `uvm_component_utils_begin(uart_sequencer17)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config17)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG17", "uart_config17 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer17
`endif // UART_SEQUENCER_SVH17
