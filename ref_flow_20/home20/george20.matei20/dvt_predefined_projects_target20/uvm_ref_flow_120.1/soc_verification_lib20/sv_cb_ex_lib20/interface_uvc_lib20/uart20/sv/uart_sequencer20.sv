/*-------------------------------------------------------------------------
File20 name   : uart_sequencer20.sv
Title20       : Sequencer file for the UART20 UVC20
Project20     :
Created20     :
Description20 : The sequencer generates20 stream in transaction in term20 of items 
              and sequences of item
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH20
`define UART_SEQUENCER_SVH20

class uart_sequencer20 extends uvm_sequencer #(uart_frame20);

  virtual interface uart_if20 vif20;

  uart_config20 cfg;

  `uvm_component_utils_begin(uart_sequencer20)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config20)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG20", "uart_config20 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer20
`endif // UART_SEQUENCER_SVH20
