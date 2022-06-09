// IVB4 checksum4: 2692815514
/*-----------------------------------------------------------------
File4 name     : ahb_master_sequencer4.sv
Created4       : Wed4 May4 19 15:42:20 2010
Description4   : This4 file declares4 the sequencer the master4.
Notes4         : 
-----------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV4
`define AHB_MASTER_SEQUENCER_SV4

//------------------------------------------------------------------------------
//
// CLASS4: ahb_master_sequencer4
//
//------------------------------------------------------------------------------

class ahb_master_sequencer4 extends uvm_sequencer #(ahb_transfer4);

  // The virtual interface is used to drive4 and view4 HDL signals4.
  // This4 OPTIONAL4 connection is only needed if the sequencer needs4
  // access to the interface directly4.
  // If4 you remove it - you will need to modify the agent4 as well4
  virtual interface ahb_if4 vif4;

  `uvm_component_utils(ahb_master_sequencer4)

  // Constructor4 - required4 syntax4 for UVM automation4 and utilities4
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer4

`endif // AHB_MASTER_SEQUENCER_SV4

