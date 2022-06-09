/*-------------------------------------------------------------------------
File14 name   : uart_sequencer14.sv
Title14       : Sequencer file for the UART14 UVC14
Project14     :
Created14     :
Description14 : The sequencer generates14 stream in transaction in term14 of items 
              and sequences of item
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH14
`define UART_SEQUENCER_SVH14

class uart_sequencer14 extends uvm_sequencer #(uart_frame14);

  virtual interface uart_if14 vif14;

  uart_config14 cfg;

  `uvm_component_utils_begin(uart_sequencer14)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config14)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG14", "uart_config14 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer14
`endif // UART_SEQUENCER_SVH14
