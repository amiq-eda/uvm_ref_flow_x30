// IVB23 checksum23: 2834038605
/*-----------------------------------------------------------------
File23 name     : ahb_slave_sequencer23.sv
Created23       : Wed23 May23 19 15:42:21 2010
Description23   : This23 file declares23 the sequencer the slave23.
Notes23         : 
-----------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV23
`define AHB_SLAVE_SEQUENCER_SV23

//------------------------------------------------------------------------------
//
// CLASS23: ahb_slave_sequencer23
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer23 extends uvm_sequencer #(ahb_transfer23);

  // The virtual interface used to drive23 and view23 HDL signals23.
  // This23 OPTIONAL23 connection is only needed if the sequencer needs23
  // access to the interface directly23.
  // If23 you remove it - you will need to modify the agent23 as well23
  virtual interface ahb_if23 vif23;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer23)

  // Constructor23 - required23 syntax23 for UVM automation23 and utilities23
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer23

`endif // AHB_SLAVE_SEQUENCER_SV23

