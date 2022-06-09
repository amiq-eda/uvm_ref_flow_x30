// IVB26 checksum26: 2834038605
/*-----------------------------------------------------------------
File26 name     : ahb_slave_sequencer26.sv
Created26       : Wed26 May26 19 15:42:21 2010
Description26   : This26 file declares26 the sequencer the slave26.
Notes26         : 
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV26
`define AHB_SLAVE_SEQUENCER_SV26

//------------------------------------------------------------------------------
//
// CLASS26: ahb_slave_sequencer26
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer26 extends uvm_sequencer #(ahb_transfer26);

  // The virtual interface used to drive26 and view26 HDL signals26.
  // This26 OPTIONAL26 connection is only needed if the sequencer needs26
  // access to the interface directly26.
  // If26 you remove it - you will need to modify the agent26 as well26
  virtual interface ahb_if26 vif26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer26)

  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer26

`endif // AHB_SLAVE_SEQUENCER_SV26

