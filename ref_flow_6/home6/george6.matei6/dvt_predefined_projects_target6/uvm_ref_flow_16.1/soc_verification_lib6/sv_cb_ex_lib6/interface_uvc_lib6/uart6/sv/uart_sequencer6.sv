/*-------------------------------------------------------------------------
File6 name   : uart_sequencer6.sv
Title6       : Sequencer file for the UART6 UVC6
Project6     :
Created6     :
Description6 : The sequencer generates6 stream in transaction in term6 of items 
              and sequences of item
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH6
`define UART_SEQUENCER_SVH6

class uart_sequencer6 extends uvm_sequencer #(uart_frame6);

  virtual interface uart_if6 vif6;

  uart_config6 cfg;

  `uvm_component_utils_begin(uart_sequencer6)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config6)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG6", "uart_config6 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer6
`endif // UART_SEQUENCER_SVH6
