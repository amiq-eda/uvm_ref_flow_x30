/*-------------------------------------------------------------------------
File12 name   : gpio_sequencer12.sv
Title12       : GPIO12 SystemVerilog12 UVM UVC12
Project12     : SystemVerilog12 UVM Cluster12 Level12 Verification12
Created12     :
Description12 : 
Notes12       :  
---------------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef GPIO_SEQUENCER_SV12
`define GPIO_SEQUENCER_SV12

class gpio_sequencer12 extends uvm_sequencer #(gpio_transfer12);

  `uvm_component_utils(gpio_sequencer12)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : gpio_sequencer12

`endif // GPIO_SEQUENCER_SV12

