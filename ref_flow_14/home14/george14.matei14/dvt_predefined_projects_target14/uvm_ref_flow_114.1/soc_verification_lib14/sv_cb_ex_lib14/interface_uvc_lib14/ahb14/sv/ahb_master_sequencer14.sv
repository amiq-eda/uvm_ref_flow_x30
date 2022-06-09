// IVB14 checksum14: 2692815514
/*-----------------------------------------------------------------
File14 name     : ahb_master_sequencer14.sv
Created14       : Wed14 May14 19 15:42:20 2010
Description14   : This14 file declares14 the sequencer the master14.
Notes14         : 
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV14
`define AHB_MASTER_SEQUENCER_SV14

//------------------------------------------------------------------------------
//
// CLASS14: ahb_master_sequencer14
//
//------------------------------------------------------------------------------

class ahb_master_sequencer14 extends uvm_sequencer #(ahb_transfer14);

  // The virtual interface is used to drive14 and view14 HDL signals14.
  // This14 OPTIONAL14 connection is only needed if the sequencer needs14
  // access to the interface directly14.
  // If14 you remove it - you will need to modify the agent14 as well14
  virtual interface ahb_if14 vif14;

  `uvm_component_utils(ahb_master_sequencer14)

  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer14

`endif // AHB_MASTER_SEQUENCER_SV14

