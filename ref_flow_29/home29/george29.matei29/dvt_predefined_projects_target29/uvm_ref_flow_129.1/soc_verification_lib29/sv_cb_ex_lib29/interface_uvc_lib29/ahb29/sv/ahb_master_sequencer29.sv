// IVB29 checksum29: 2692815514
/*-----------------------------------------------------------------
File29 name     : ahb_master_sequencer29.sv
Created29       : Wed29 May29 19 15:42:20 2010
Description29   : This29 file declares29 the sequencer the master29.
Notes29         : 
-----------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV29
`define AHB_MASTER_SEQUENCER_SV29

//------------------------------------------------------------------------------
//
// CLASS29: ahb_master_sequencer29
//
//------------------------------------------------------------------------------

class ahb_master_sequencer29 extends uvm_sequencer #(ahb_transfer29);

  // The virtual interface is used to drive29 and view29 HDL signals29.
  // This29 OPTIONAL29 connection is only needed if the sequencer needs29
  // access to the interface directly29.
  // If29 you remove it - you will need to modify the agent29 as well29
  virtual interface ahb_if29 vif29;

  `uvm_component_utils(ahb_master_sequencer29)

  // Constructor29 - required29 syntax29 for UVM automation29 and utilities29
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer29

`endif // AHB_MASTER_SEQUENCER_SV29

