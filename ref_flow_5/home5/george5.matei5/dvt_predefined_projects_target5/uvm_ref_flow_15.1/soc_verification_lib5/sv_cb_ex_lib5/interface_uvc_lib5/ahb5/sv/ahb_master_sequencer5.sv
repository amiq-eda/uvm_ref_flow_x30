// IVB5 checksum5: 2692815514
/*-----------------------------------------------------------------
File5 name     : ahb_master_sequencer5.sv
Created5       : Wed5 May5 19 15:42:20 2010
Description5   : This5 file declares5 the sequencer the master5.
Notes5         : 
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV5
`define AHB_MASTER_SEQUENCER_SV5

//------------------------------------------------------------------------------
//
// CLASS5: ahb_master_sequencer5
//
//------------------------------------------------------------------------------

class ahb_master_sequencer5 extends uvm_sequencer #(ahb_transfer5);

  // The virtual interface is used to drive5 and view5 HDL signals5.
  // This5 OPTIONAL5 connection is only needed if the sequencer needs5
  // access to the interface directly5.
  // If5 you remove it - you will need to modify the agent5 as well5
  virtual interface ahb_if5 vif5;

  `uvm_component_utils(ahb_master_sequencer5)

  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer5

`endif // AHB_MASTER_SEQUENCER_SV5

