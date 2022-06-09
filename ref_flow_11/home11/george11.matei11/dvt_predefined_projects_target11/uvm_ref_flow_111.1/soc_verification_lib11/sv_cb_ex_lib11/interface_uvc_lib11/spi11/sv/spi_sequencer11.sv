/*-------------------------------------------------------------------------
File11 name   : spi_sequencer11.sv
Title11       : SPI11 SystemVerilog11 UVM UVC11
Project11     : SystemVerilog11 UVM Cluster11 Level11 Verification11
Created11     :
Description11 : 
Notes11       :  
---------------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef SPI_SEQUENCER_SV11
`define SPI_SEQUENCER_SV11

class spi_sequencer11 extends uvm_sequencer #(spi_transfer11);

  `uvm_component_utils(spi_sequencer11)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : spi_sequencer11

`endif // SPI_SEQUENCER_SV11

