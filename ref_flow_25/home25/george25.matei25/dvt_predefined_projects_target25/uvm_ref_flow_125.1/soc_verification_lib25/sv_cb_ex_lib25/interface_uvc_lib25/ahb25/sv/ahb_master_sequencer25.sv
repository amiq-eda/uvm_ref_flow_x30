// IVB25 checksum25: 2692815514
/*-----------------------------------------------------------------
File25 name     : ahb_master_sequencer25.sv
Created25       : Wed25 May25 19 15:42:20 2010
Description25   : This25 file declares25 the sequencer the master25.
Notes25         : 
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV25
`define AHB_MASTER_SEQUENCER_SV25

//------------------------------------------------------------------------------
//
// CLASS25: ahb_master_sequencer25
//
//------------------------------------------------------------------------------

class ahb_master_sequencer25 extends uvm_sequencer #(ahb_transfer25);

  // The virtual interface is used to drive25 and view25 HDL signals25.
  // This25 OPTIONAL25 connection is only needed if the sequencer needs25
  // access to the interface directly25.
  // If25 you remove it - you will need to modify the agent25 as well25
  virtual interface ahb_if25 vif25;

  `uvm_component_utils(ahb_master_sequencer25)

  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer25

`endif // AHB_MASTER_SEQUENCER_SV25

