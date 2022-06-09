// IVB22 checksum22: 2692815514
/*-----------------------------------------------------------------
File22 name     : ahb_master_sequencer22.sv
Created22       : Wed22 May22 19 15:42:20 2010
Description22   : This22 file declares22 the sequencer the master22.
Notes22         : 
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV22
`define AHB_MASTER_SEQUENCER_SV22

//------------------------------------------------------------------------------
//
// CLASS22: ahb_master_sequencer22
//
//------------------------------------------------------------------------------

class ahb_master_sequencer22 extends uvm_sequencer #(ahb_transfer22);

  // The virtual interface is used to drive22 and view22 HDL signals22.
  // This22 OPTIONAL22 connection is only needed if the sequencer needs22
  // access to the interface directly22.
  // If22 you remove it - you will need to modify the agent22 as well22
  virtual interface ahb_if22 vif22;

  `uvm_component_utils(ahb_master_sequencer22)

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer22

`endif // AHB_MASTER_SEQUENCER_SV22

