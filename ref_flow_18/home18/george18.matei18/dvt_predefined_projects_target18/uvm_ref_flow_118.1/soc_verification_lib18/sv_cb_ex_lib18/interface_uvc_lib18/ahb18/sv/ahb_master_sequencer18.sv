// IVB18 checksum18: 2692815514
/*-----------------------------------------------------------------
File18 name     : ahb_master_sequencer18.sv
Created18       : Wed18 May18 19 15:42:20 2010
Description18   : This18 file declares18 the sequencer the master18.
Notes18         : 
-----------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV18
`define AHB_MASTER_SEQUENCER_SV18

//------------------------------------------------------------------------------
//
// CLASS18: ahb_master_sequencer18
//
//------------------------------------------------------------------------------

class ahb_master_sequencer18 extends uvm_sequencer #(ahb_transfer18);

  // The virtual interface is used to drive18 and view18 HDL signals18.
  // This18 OPTIONAL18 connection is only needed if the sequencer needs18
  // access to the interface directly18.
  // If18 you remove it - you will need to modify the agent18 as well18
  virtual interface ahb_if18 vif18;

  `uvm_component_utils(ahb_master_sequencer18)

  // Constructor18 - required18 syntax18 for UVM automation18 and utilities18
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer18

`endif // AHB_MASTER_SEQUENCER_SV18

