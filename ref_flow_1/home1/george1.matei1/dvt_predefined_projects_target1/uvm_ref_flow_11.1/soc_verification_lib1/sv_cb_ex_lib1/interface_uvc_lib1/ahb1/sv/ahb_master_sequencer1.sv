// IVB1 checksum1: 2692815514
/*-----------------------------------------------------------------
File1 name     : ahb_master_sequencer1.sv
Created1       : Wed1 May1 19 15:42:20 2010
Description1   : This1 file declares1 the sequencer the master1.
Notes1         : 
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV1
`define AHB_MASTER_SEQUENCER_SV1

//------------------------------------------------------------------------------
//
// CLASS1: ahb_master_sequencer1
//
//------------------------------------------------------------------------------

class ahb_master_sequencer1 extends uvm_sequencer #(ahb_transfer1);

  // The virtual interface is used to drive1 and view1 HDL signals1.
  // This1 OPTIONAL1 connection is only needed if the sequencer needs1
  // access to the interface directly1.
  // If1 you remove it - you will need to modify the agent1 as well1
  virtual interface ahb_if1 vif1;

  `uvm_component_utils(ahb_master_sequencer1)

  // Constructor1 - required1 syntax1 for UVM automation1 and utilities1
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer1

`endif // AHB_MASTER_SEQUENCER_SV1

