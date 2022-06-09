// IVB8 checksum8: 2692815514
/*-----------------------------------------------------------------
File8 name     : ahb_master_sequencer8.sv
Created8       : Wed8 May8 19 15:42:20 2010
Description8   : This8 file declares8 the sequencer the master8.
Notes8         : 
-----------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV8
`define AHB_MASTER_SEQUENCER_SV8

//------------------------------------------------------------------------------
//
// CLASS8: ahb_master_sequencer8
//
//------------------------------------------------------------------------------

class ahb_master_sequencer8 extends uvm_sequencer #(ahb_transfer8);

  // The virtual interface is used to drive8 and view8 HDL signals8.
  // This8 OPTIONAL8 connection is only needed if the sequencer needs8
  // access to the interface directly8.
  // If8 you remove it - you will need to modify the agent8 as well8
  virtual interface ahb_if8 vif8;

  `uvm_component_utils(ahb_master_sequencer8)

  // Constructor8 - required8 syntax8 for UVM automation8 and utilities8
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer8

`endif // AHB_MASTER_SEQUENCER_SV8

