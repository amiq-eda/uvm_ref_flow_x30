// IVB2 checksum2: 2834038605
/*-----------------------------------------------------------------
File2 name     : ahb_slave_sequencer2.sv
Created2       : Wed2 May2 19 15:42:21 2010
Description2   : This2 file declares2 the sequencer the slave2.
Notes2         : 
-----------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV2
`define AHB_SLAVE_SEQUENCER_SV2

//------------------------------------------------------------------------------
//
// CLASS2: ahb_slave_sequencer2
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer2 extends uvm_sequencer #(ahb_transfer2);

  // The virtual interface used to drive2 and view2 HDL signals2.
  // This2 OPTIONAL2 connection is only needed if the sequencer needs2
  // access to the interface directly2.
  // If2 you remove it - you will need to modify the agent2 as well2
  virtual interface ahb_if2 vif2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer2)

  // Constructor2 - required2 syntax2 for UVM automation2 and utilities2
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer2

`endif // AHB_SLAVE_SEQUENCER_SV2

