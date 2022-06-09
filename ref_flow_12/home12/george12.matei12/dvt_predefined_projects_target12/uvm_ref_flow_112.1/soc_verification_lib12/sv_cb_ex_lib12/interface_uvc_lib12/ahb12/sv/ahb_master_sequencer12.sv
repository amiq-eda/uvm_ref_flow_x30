// IVB12 checksum12: 2692815514
/*-----------------------------------------------------------------
File12 name     : ahb_master_sequencer12.sv
Created12       : Wed12 May12 19 15:42:20 2010
Description12   : This12 file declares12 the sequencer the master12.
Notes12         : 
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV12
`define AHB_MASTER_SEQUENCER_SV12

//------------------------------------------------------------------------------
//
// CLASS12: ahb_master_sequencer12
//
//------------------------------------------------------------------------------

class ahb_master_sequencer12 extends uvm_sequencer #(ahb_transfer12);

  // The virtual interface is used to drive12 and view12 HDL signals12.
  // This12 OPTIONAL12 connection is only needed if the sequencer needs12
  // access to the interface directly12.
  // If12 you remove it - you will need to modify the agent12 as well12
  virtual interface ahb_if12 vif12;

  `uvm_component_utils(ahb_master_sequencer12)

  // Constructor12 - required12 syntax12 for UVM automation12 and utilities12
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer12

`endif // AHB_MASTER_SEQUENCER_SV12

