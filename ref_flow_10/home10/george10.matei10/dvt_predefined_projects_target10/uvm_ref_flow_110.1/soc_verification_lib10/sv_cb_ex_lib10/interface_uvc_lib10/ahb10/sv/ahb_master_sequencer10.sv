// IVB10 checksum10: 2692815514
/*-----------------------------------------------------------------
File10 name     : ahb_master_sequencer10.sv
Created10       : Wed10 May10 19 15:42:20 2010
Description10   : This10 file declares10 the sequencer the master10.
Notes10         : 
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV10
`define AHB_MASTER_SEQUENCER_SV10

//------------------------------------------------------------------------------
//
// CLASS10: ahb_master_sequencer10
//
//------------------------------------------------------------------------------

class ahb_master_sequencer10 extends uvm_sequencer #(ahb_transfer10);

  // The virtual interface is used to drive10 and view10 HDL signals10.
  // This10 OPTIONAL10 connection is only needed if the sequencer needs10
  // access to the interface directly10.
  // If10 you remove it - you will need to modify the agent10 as well10
  virtual interface ahb_if10 vif10;

  `uvm_component_utils(ahb_master_sequencer10)

  // Constructor10 - required10 syntax10 for UVM automation10 and utilities10
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer10

`endif // AHB_MASTER_SEQUENCER_SV10

