// IVB6 checksum6: 2834038605
/*-----------------------------------------------------------------
File6 name     : ahb_slave_sequencer6.sv
Created6       : Wed6 May6 19 15:42:21 2010
Description6   : This6 file declares6 the sequencer the slave6.
Notes6         : 
-----------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_SEQUENCER_SV6
`define AHB_SLAVE_SEQUENCER_SV6

//------------------------------------------------------------------------------
//
// CLASS6: ahb_slave_sequencer6
//
//------------------------------------------------------------------------------

class ahb_slave_sequencer6 extends uvm_sequencer #(ahb_transfer6);

  // The virtual interface used to drive6 and view6 HDL signals6.
  // This6 OPTIONAL6 connection is only needed if the sequencer needs6
  // access to the interface directly6.
  // If6 you remove it - you will need to modify the agent6 as well6
  virtual interface ahb_if6 vif6;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils(ahb_slave_sequencer6)

  // Constructor6 - required6 syntax6 for UVM automation6 and utilities6
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer6

`endif // AHB_SLAVE_SEQUENCER_SV6

