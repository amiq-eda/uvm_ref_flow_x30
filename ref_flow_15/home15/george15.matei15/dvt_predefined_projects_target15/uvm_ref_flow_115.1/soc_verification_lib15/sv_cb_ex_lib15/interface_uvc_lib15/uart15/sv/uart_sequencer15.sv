/*-------------------------------------------------------------------------
File15 name   : uart_sequencer15.sv
Title15       : Sequencer file for the UART15 UVC15
Project15     :
Created15     :
Description15 : The sequencer generates15 stream in transaction in term15 of items 
              and sequences of item
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH15
`define UART_SEQUENCER_SVH15

class uart_sequencer15 extends uvm_sequencer #(uart_frame15);

  virtual interface uart_if15 vif15;

  uart_config15 cfg;

  `uvm_component_utils_begin(uart_sequencer15)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config15)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG15", "uart_config15 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer15
`endif // UART_SEQUENCER_SVH15
