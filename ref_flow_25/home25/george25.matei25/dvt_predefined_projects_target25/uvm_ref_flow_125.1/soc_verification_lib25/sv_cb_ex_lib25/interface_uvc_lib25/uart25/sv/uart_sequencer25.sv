/*-------------------------------------------------------------------------
File25 name   : uart_sequencer25.sv
Title25       : Sequencer file for the UART25 UVC25
Project25     :
Created25     :
Description25 : The sequencer generates25 stream in transaction in term25 of items 
              and sequences of item
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH25
`define UART_SEQUENCER_SVH25

class uart_sequencer25 extends uvm_sequencer #(uart_frame25);

  virtual interface uart_if25 vif25;

  uart_config25 cfg;

  `uvm_component_utils_begin(uart_sequencer25)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config25)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG25", "uart_config25 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer25
`endif // UART_SEQUENCER_SVH25
