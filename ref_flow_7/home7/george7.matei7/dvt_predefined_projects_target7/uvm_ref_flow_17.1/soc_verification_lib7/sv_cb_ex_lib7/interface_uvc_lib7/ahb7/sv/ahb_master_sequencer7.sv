// IVB7 checksum7: 2692815514
/*-----------------------------------------------------------------
File7 name     : ahb_master_sequencer7.sv
Created7       : Wed7 May7 19 15:42:20 2010
Description7   : This7 file declares7 the sequencer the master7.
Notes7         : 
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV7
`define AHB_MASTER_SEQUENCER_SV7

//------------------------------------------------------------------------------
//
// CLASS7: ahb_master_sequencer7
//
//------------------------------------------------------------------------------

class ahb_master_sequencer7 extends uvm_sequencer #(ahb_transfer7);

  // The virtual interface is used to drive7 and view7 HDL signals7.
  // This7 OPTIONAL7 connection is only needed if the sequencer needs7
  // access to the interface directly7.
  // If7 you remove it - you will need to modify the agent7 as well7
  virtual interface ahb_if7 vif7;

  `uvm_component_utils(ahb_master_sequencer7)

  // Constructor7 - required7 syntax7 for UVM automation7 and utilities7
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer7

`endif // AHB_MASTER_SEQUENCER_SV7

