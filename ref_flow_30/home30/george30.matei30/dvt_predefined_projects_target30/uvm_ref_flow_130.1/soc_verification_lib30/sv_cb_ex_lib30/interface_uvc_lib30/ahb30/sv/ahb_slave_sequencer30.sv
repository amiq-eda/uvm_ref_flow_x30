// IVB30 checksum30: 2834038605
/*-----------------------------------------------------------------
File30 name     : ahb_slave_sequencer30.sv
Created30       : Wed30 May30 19 15:42:21 2010
Description30   : This30 file declares30 the sequencer the slave30.
Notes30         : 
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV30
`define AHB_SLAVE_SEQUENCER_SV30

//------------------------------------------------------------------------------
//
// CLASS30: ahb_slave_sequencer30
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer30 extends uvm_sequencer #(ahb_transfer30);

  // The virtual interface used to drive30 and view30 HDL signals30.
  // This30 OPTIONAL30 connection is only needed if the sequencer needs30
  // access to the interface directly30.
  // If30 you remove it - you will need to modify the agent30 as well30
  virtual interface ahb_if30 vif30;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer30)

  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer30

`endif // AHB_SLAVE_SEQUENCER_SV30

