// IVB17 checksum17: 2834038605
/*-----------------------------------------------------------------
File17 name     : ahb_slave_sequencer17.sv
Created17       : Wed17 May17 19 15:42:21 2010
Description17   : This17 file declares17 the sequencer the slave17.
Notes17         : 
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV17
`define AHB_SLAVE_SEQUENCER_SV17

//------------------------------------------------------------------------------
//
// CLASS17: ahb_slave_sequencer17
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer17 extends uvm_sequencer #(ahb_transfer17);

  // The virtual interface used to drive17 and view17 HDL signals17.
  // This17 OPTIONAL17 connection is only needed if the sequencer needs17
  // access to the interface directly17.
  // If17 you remove it - you will need to modify the agent17 as well17
  virtual interface ahb_if17 vif17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer17)

  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer17

`endif // AHB_SLAVE_SEQUENCER_SV17

