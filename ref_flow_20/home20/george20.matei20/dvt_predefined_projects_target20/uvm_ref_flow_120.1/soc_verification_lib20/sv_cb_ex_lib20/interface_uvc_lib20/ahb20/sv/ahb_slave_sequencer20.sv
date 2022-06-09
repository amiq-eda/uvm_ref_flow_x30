// IVB20 checksum20: 2834038605
/*-----------------------------------------------------------------
File20 name     : ahb_slave_sequencer20.sv
Created20       : Wed20 May20 19 15:42:21 2010
Description20   : This20 file declares20 the sequencer the slave20.
Notes20         : 
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV20
`define AHB_SLAVE_SEQUENCER_SV20

//------------------------------------------------------------------------------
//
// CLASS20: ahb_slave_sequencer20
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer20 extends uvm_sequencer #(ahb_transfer20);

  // The virtual interface used to drive20 and view20 HDL signals20.
  // This20 OPTIONAL20 connection is only needed if the sequencer needs20
  // access to the interface directly20.
  // If20 you remove it - you will need to modify the agent20 as well20
  virtual interface ahb_if20 vif20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer20)

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer20

`endif // AHB_SLAVE_SEQUENCER_SV20

