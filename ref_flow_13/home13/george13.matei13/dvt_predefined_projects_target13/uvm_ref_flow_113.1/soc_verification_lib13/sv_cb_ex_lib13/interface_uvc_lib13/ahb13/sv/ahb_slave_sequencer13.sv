// IVB13 checksum13: 2834038605
/*-----------------------------------------------------------------
File13 name     : ahb_slave_sequencer13.sv
Created13       : Wed13 May13 19 15:42:21 2010
Description13   : This13 file declares13 the sequencer the slave13.
Notes13         : 
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV13
`define AHB_SLAVE_SEQUENCER_SV13

//------------------------------------------------------------------------------
//
// CLASS13: ahb_slave_sequencer13
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer13 extends uvm_sequencer #(ahb_transfer13);

  // The virtual interface used to drive13 and view13 HDL signals13.
  // This13 OPTIONAL13 connection is only needed if the sequencer needs13
  // access to the interface directly13.
  // If13 you remove it - you will need to modify the agent13 as well13
  virtual interface ahb_if13 vif13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer13)

  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer13

`endif // AHB_SLAVE_SEQUENCER_SV13

