// IVB21 checksum21: 2692815514
/*-----------------------------------------------------------------
File21 name     : ahb_master_sequencer21.sv
Created21       : Wed21 May21 19 15:42:20 2010
Description21   : This21 file declares21 the sequencer the master21.
Notes21         : 
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV21
`define AHB_MASTER_SEQUENCER_SV21

//------------------------------------------------------------------------------
//
// CLASS21: ahb_master_sequencer21
//
//------------------------------------------------------------------------------

class ahb_master_sequencer21 extends uvm_sequencer #(ahb_transfer21);

  // The virtual interface is used to drive21 and view21 HDL signals21.
  // This21 OPTIONAL21 connection is only needed if the sequencer needs21
  // access to the interface directly21.
  // If21 you remove it - you will need to modify the agent21 as well21
  virtual interface ahb_if21 vif21;

  `uvm_component_utils(ahb_master_sequencer21)

  // Constructor21 - required21 syntax21 for UVM automation21 and utilities21
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer21

`endif // AHB_MASTER_SEQUENCER_SV21

