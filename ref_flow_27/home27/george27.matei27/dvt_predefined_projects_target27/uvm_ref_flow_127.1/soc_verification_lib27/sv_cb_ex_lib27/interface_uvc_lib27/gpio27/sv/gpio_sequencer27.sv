/*-------------------------------------------------------------------------
File27 name   : gpio_sequencer27.sv
Title27       : GPIO27 SystemVerilog27 UVM UVC27
Project27     : SystemVerilog27 UVM Cluster27 Level27 Verification27
Created27     :
Description27 : 
Notes27       :  
---------------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef GPIO_SEQUENCER_SV27
`define GPIO_SEQUENCER_SV27

class gpio_sequencer27 extends uvm_sequencer #(gpio_transfer27);

  `uvm_component_utils(gpio_sequencer27)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : gpio_sequencer27

`endif // GPIO_SEQUENCER_SV27

