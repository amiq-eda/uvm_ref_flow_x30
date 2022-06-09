// IVB19 checksum19: 2834038605
/*-----------------------------------------------------------------
File19 name     : ahb_slave_sequencer19.sv
Created19       : Wed19 May19 19 15:42:21 2010
Description19   : This19 file declares19 the sequencer the slave19.
Notes19         : 
-----------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV19
`define AHB_SLAVE_SEQUENCER_SV19

//------------------------------------------------------------------------------
//
// CLASS19: ahb_slave_sequencer19
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer19 extends uvm_sequencer #(ahb_transfer19);

  // The virtual interface used to drive19 and view19 HDL signals19.
  // This19 OPTIONAL19 connection is only needed if the sequencer needs19
  // access to the interface directly19.
  // If19 you remove it - you will need to modify the agent19 as well19
  virtual interface ahb_if19 vif19;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer19)

  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer19

`endif // AHB_SLAVE_SEQUENCER_SV19

