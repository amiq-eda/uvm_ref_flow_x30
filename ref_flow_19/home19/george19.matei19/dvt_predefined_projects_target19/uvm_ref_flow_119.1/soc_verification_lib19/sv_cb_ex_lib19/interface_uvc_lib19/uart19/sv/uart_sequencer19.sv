/*-------------------------------------------------------------------------
File19 name   : uart_sequencer19.sv
Title19       : Sequencer file for the UART19 UVC19
Project19     :
Created19     :
Description19 : The sequencer generates19 stream in transaction in term19 of items 
              and sequences of item
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH19
`define UART_SEQUENCER_SVH19

class uart_sequencer19 extends uvm_sequencer #(uart_frame19);

  virtual interface uart_if19 vif19;

  uart_config19 cfg;

  `uvm_component_utils_begin(uart_sequencer19)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config19)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG19", "uart_config19 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer19
`endif // UART_SEQUENCER_SVH19
