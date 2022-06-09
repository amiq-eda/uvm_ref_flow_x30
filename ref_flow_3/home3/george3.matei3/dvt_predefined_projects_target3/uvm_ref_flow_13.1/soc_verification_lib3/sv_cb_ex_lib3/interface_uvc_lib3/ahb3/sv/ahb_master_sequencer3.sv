// IVB3 checksum3: 2692815514
/*-----------------------------------------------------------------
File3 name     : ahb_master_sequencer3.sv
Created3       : Wed3 May3 19 15:42:20 2010
Description3   : This3 file declares3 the sequencer the master3.
Notes3         : 
-----------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV3
`define AHB_MASTER_SEQUENCER_SV3

//------------------------------------------------------------------------------
//
// CLASS3: ahb_master_sequencer3
//
//------------------------------------------------------------------------------

class ahb_master_sequencer3 extends uvm_sequencer #(ahb_transfer3);

  // The virtual interface is used to drive3 and view3 HDL signals3.
  // This3 OPTIONAL3 connection is only needed if the sequencer needs3
  // access to the interface directly3.
  // If3 you remove it - you will need to modify the agent3 as well3
  virtual interface ahb_if3 vif3;

  `uvm_component_utils(ahb_master_sequencer3)

  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer3

`endif // AHB_MASTER_SEQUENCER_SV3

