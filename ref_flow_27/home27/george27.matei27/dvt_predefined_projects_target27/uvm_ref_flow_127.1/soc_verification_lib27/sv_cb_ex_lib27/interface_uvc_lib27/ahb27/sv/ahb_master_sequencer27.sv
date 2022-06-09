// IVB27 checksum27: 2692815514
/*-----------------------------------------------------------------
File27 name     : ahb_master_sequencer27.sv
Created27       : Wed27 May27 19 15:42:20 2010
Description27   : This27 file declares27 the sequencer the master27.
Notes27         : 
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV27
`define AHB_MASTER_SEQUENCER_SV27

//------------------------------------------------------------------------------
//
// CLASS27: ahb_master_sequencer27
//
//------------------------------------------------------------------------------

class ahb_master_sequencer27 extends uvm_sequencer #(ahb_transfer27);

  // The virtual interface is used to drive27 and view27 HDL signals27.
  // This27 OPTIONAL27 connection is only needed if the sequencer needs27
  // access to the interface directly27.
  // If27 you remove it - you will need to modify the agent27 as well27
  virtual interface ahb_if27 vif27;

  `uvm_component_utils(ahb_master_sequencer27)

  // Constructor27 - required27 syntax27 for UVM automation27 and utilities27
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer27

`endif // AHB_MASTER_SEQUENCER_SV27

