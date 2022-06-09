/*-------------------------------------------------------------------------
File5 name   : uart_sequencer5.sv
Title5       : Sequencer file for the UART5 UVC5
Project5     :
Created5     :
Description5 : The sequencer generates5 stream in transaction in term5 of items 
              and sequences of item
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH5
`define UART_SEQUENCER_SVH5

class uart_sequencer5 extends uvm_sequencer #(uart_frame5);

  virtual interface uart_if5 vif5;

  uart_config5 cfg;

  `uvm_component_utils_begin(uart_sequencer5)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config5)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG5", "uart_config5 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer5
`endif // UART_SEQUENCER_SVH5
