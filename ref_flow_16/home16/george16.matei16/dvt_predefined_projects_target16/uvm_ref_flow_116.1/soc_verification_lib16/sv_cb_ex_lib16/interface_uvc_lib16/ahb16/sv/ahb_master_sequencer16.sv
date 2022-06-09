// IVB16 checksum16: 2692815514
/*-----------------------------------------------------------------
File16 name     : ahb_master_sequencer16.sv
Created16       : Wed16 May16 19 15:42:20 2010
Description16   : This16 file declares16 the sequencer the master16.
Notes16         : 
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV16
`define AHB_MASTER_SEQUENCER_SV16

//------------------------------------------------------------------------------
//
// CLASS16: ahb_master_sequencer16
//
//------------------------------------------------------------------------------

class ahb_master_sequencer16 extends uvm_sequencer #(ahb_transfer16);

  // The virtual interface is used to drive16 and view16 HDL signals16.
  // This16 OPTIONAL16 connection is only needed if the sequencer needs16
  // access to the interface directly16.
  // If16 you remove it - you will need to modify the agent16 as well16
  virtual interface ahb_if16 vif16;

  `uvm_component_utils(ahb_master_sequencer16)

  // Constructor16 - required16 syntax16 for UVM automation16 and utilities16
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer16

`endif // AHB_MASTER_SEQUENCER_SV16

