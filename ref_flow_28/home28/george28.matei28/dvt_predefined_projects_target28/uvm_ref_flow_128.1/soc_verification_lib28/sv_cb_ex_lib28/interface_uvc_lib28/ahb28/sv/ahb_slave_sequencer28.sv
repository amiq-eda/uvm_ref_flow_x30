// IVB28 checksum28: 2834038605
/*-----------------------------------------------------------------
File28 name     : ahb_slave_sequencer28.sv
Created28       : Wed28 May28 19 15:42:21 2010
Description28   : This28 file declares28 the sequencer the slave28.
Notes28         : 
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV28
`define AHB_SLAVE_SEQUENCER_SV28

//------------------------------------------------------------------------------
//
// CLASS28: ahb_slave_sequencer28
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer28 extends uvm_sequencer #(ahb_transfer28);

  // The virtual interface used to drive28 and view28 HDL signals28.
  // This28 OPTIONAL28 connection is only needed if the sequencer needs28
  // access to the interface directly28.
  // If28 you remove it - you will need to modify the agent28 as well28
  virtual interface ahb_if28 vif28;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer28)

  // Constructor28 - required28 syntax28 for UVM automation28 and utilities28
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer28

`endif // AHB_SLAVE_SEQUENCER_SV28

