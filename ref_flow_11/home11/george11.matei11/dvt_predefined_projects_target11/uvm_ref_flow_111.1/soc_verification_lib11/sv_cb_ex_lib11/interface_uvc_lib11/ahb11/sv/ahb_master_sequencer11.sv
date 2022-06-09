// IVB11 checksum11: 2692815514
/*-----------------------------------------------------------------
File11 name     : ahb_master_sequencer11.sv
Created11       : Wed11 May11 19 15:42:20 2010
Description11   : This11 file declares11 the sequencer the master11.
Notes11         : 
-----------------------------------------------------------------*/
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


`ifndef AHB_MASTER_SEQUENCER_SV11
`define AHB_MASTER_SEQUENCER_SV11

//------------------------------------------------------------------------------
//
// CLASS11: ahb_master_sequencer11
//
//------------------------------------------------------------------------------

class ahb_master_sequencer11 extends uvm_sequencer #(ahb_transfer11);

  // The virtual interface is used to drive11 and view11 HDL signals11.
  // This11 OPTIONAL11 connection is only needed if the sequencer needs11
  // access to the interface directly11.
  // If11 you remove it - you will need to modify the agent11 as well11
  virtual interface ahb_if11 vif11;

  `uvm_component_utils(ahb_master_sequencer11)

  // Constructor11 - required11 syntax11 for UVM automation11 and utilities11
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer11

`endif // AHB_MASTER_SEQUENCER_SV11

