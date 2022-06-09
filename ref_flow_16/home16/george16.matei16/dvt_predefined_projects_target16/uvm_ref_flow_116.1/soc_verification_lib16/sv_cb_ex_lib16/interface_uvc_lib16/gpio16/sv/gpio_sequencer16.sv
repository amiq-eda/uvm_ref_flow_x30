/*-------------------------------------------------------------------------
File16 name   : gpio_sequencer16.sv
Title16       : GPIO16 SystemVerilog16 UVM UVC16
Project16     : SystemVerilog16 UVM Cluster16 Level16 Verification16
Created16     :
Description16 : 
Notes16       :  
---------------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef GPIO_SEQUENCER_SV16
`define GPIO_SEQUENCER_SV16

class gpio_sequencer16 extends uvm_sequencer #(gpio_transfer16);

  `uvm_component_utils(gpio_sequencer16)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : gpio_sequencer16

`endif // GPIO_SEQUENCER_SV16

