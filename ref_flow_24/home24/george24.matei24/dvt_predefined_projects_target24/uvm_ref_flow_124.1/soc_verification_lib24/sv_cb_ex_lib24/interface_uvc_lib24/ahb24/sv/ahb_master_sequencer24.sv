// IVB24 checksum24: 2692815514
/*-----------------------------------------------------------------
File24 name     : ahb_master_sequencer24.sv
Created24       : Wed24 May24 19 15:42:20 2010
Description24   : This24 file declares24 the sequencer the master24.
Notes24         : 
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV24
`define AHB_MASTER_SEQUENCER_SV24

//------------------------------------------------------------------------------
//
// CLASS24: ahb_master_sequencer24
//
//------------------------------------------------------------------------------

class ahb_master_sequencer24 extends uvm_sequencer #(ahb_transfer24);

  // The virtual interface is used to drive24 and view24 HDL signals24.
  // This24 OPTIONAL24 connection is only needed if the sequencer needs24
  // access to the interface directly24.
  // If24 you remove it - you will need to modify the agent24 as well24
  virtual interface ahb_if24 vif24;

  `uvm_component_utils(ahb_master_sequencer24)

  // Constructor24 - required24 syntax24 for UVM automation24 and utilities24
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer24

`endif // AHB_MASTER_SEQUENCER_SV24

