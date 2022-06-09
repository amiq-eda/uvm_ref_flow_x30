// IVB9 checksum9: 2692815514
/*-----------------------------------------------------------------
File9 name     : ahb_master_sequencer9.sv
Created9       : Wed9 May9 19 15:42:20 2010
Description9   : This9 file declares9 the sequencer the master9.
Notes9         : 
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_SEQUENCER_SV9
`define AHB_MASTER_SEQUENCER_SV9

//------------------------------------------------------------------------------
//
// CLASS9: ahb_master_sequencer9
//
//------------------------------------------------------------------------------

class ahb_master_sequencer9 extends uvm_sequencer #(ahb_transfer9);

  // The virtual interface is used to drive9 and view9 HDL signals9.
  // This9 OPTIONAL9 connection is only needed if the sequencer needs9
  // access to the interface directly9.
  // If9 you remove it - you will need to modify the agent9 as well9
  virtual interface ahb_if9 vif9;

  `uvm_component_utils(ahb_master_sequencer9)

  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_sequencer9

`endif // AHB_MASTER_SEQUENCER_SV9

