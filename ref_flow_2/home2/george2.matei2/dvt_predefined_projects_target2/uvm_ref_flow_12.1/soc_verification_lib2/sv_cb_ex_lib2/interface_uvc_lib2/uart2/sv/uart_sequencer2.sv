/*-------------------------------------------------------------------------
File2 name   : uart_sequencer2.sv
Title2       : Sequencer file for the UART2 UVC2
Project2     :
Created2     :
Description2 : The sequencer generates2 stream in transaction in term2 of items 
              and sequences of item
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`ifndef UART_SEQUENCER_SVH2
`define UART_SEQUENCER_SVH2

class uart_sequencer2 extends uvm_sequencer #(uart_frame2);

  virtual interface uart_if2 vif2;

  uart_config2 cfg;

  `uvm_component_utils_begin(uart_sequencer2)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

  // UVM build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(cfg == null)
        if (!uvm_config_db#(uart_config2)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG2", "uart_config2 not set for this component")
  endfunction : build_phase

endclass : uart_sequencer2
`endif // UART_SEQUENCER_SVH2
