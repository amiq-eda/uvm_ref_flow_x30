/*-------------------------------------------------------------------------
File26 name   : gpio_sequencer26.sv
Title26       : GPIO26 SystemVerilog26 UVM UVC26
Project26     : SystemVerilog26 UVM Cluster26 Level26 Verification26
Created26     :
Description26 : 
Notes26       :  
---------------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef GPIO_SEQUENCER_SV26
`define GPIO_SEQUENCER_SV26

class gpio_sequencer26 extends uvm_sequencer #(gpio_transfer26);

  `uvm_component_utils(gpio_sequencer26)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : gpio_sequencer26

`endif // GPIO_SEQUENCER_SV26

