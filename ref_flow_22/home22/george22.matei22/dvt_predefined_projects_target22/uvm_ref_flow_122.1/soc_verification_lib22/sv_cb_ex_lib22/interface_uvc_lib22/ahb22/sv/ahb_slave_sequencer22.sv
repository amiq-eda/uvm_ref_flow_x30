// IVB22 checksum22: 2834038605
/*-----------------------------------------------------------------
File22 name     : ahb_slave_sequencer22.sv
Created22       : Wed22 May22 19 15:42:21 2010
Description22   : This22 file declares22 the sequencer the slave22.
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


`ifndef AHB_SLAVE_SEQUENCER_SV22
`define AHB_SLAVE_SEQUENCER_SV22

//------------------------------------------------------------------------------
//
// CLASS22: ahb_slave_sequencer22
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer22 extends uvm_sequencer #(ahb_transfer22);

  // The virtual interface used to drive22 and view22 HDL signals22.
  // This22 OPTIONAL22 connection is only needed if the sequencer needs22
  // access to the interface directly22.
  // If22 you remove it - you will need to modify the agent22 as well22
  virtual interface ahb_if22 vif22;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer22)

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer22

`endif // AHB_SLAVE_SEQUENCER_SV22

