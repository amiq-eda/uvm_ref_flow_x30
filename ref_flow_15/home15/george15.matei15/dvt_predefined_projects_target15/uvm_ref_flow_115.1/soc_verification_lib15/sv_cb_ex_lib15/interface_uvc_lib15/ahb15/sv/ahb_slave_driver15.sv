// IVB15 checksum15: 519799952
/*-----------------------------------------------------------------
File15 name     : ahb_slave_driver15.sv
Created15       : Wed15 May15 19 15:42:21 2010
Description15   : This15 file implements15 the slave15 driver functionality
Notes15         : 
-----------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV15
`define AHB_SLAVE_DRIVER_SV15

//------------------------------------------------------------------------------
//
// CLASS15: ahb_slave_driver15
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB15-NOTE15 : REQUIRED15 : slave15 DRIVER15 functionality : DRIVER15
   -------------------------------------------------------------------------
   Modify15 the following15 methods15 to match your15 protocol15:
     o respond_transfer15() - response driving15
     o reset_signals15() - slave15 signals15 reset values
   Note15 that if you change/add signals15 to the physical interface, you must
   also change these15 methods15.
   ***************************************************************************/

class ahb_slave_driver15 extends uvm_driver #(ahb_transfer15);

  // The virtual interface used to drive15 and view15 HDL signals15.
  virtual interface ahb_if15 vif15;
    
  // Count15 transfer_responses15 sent15
  int num_sent15;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver15)

  // Constructor15 - required15 syntax15 for UVM automation15 and utilities15
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional15 class methods15
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive15();
  extern virtual protected task reset_signals15();
  extern virtual protected task send_response15(ahb_transfer15 response);
  extern virtual function void report();

endclass : ahb_slave_driver15

//UVM connect_phase
function void ahb_slave_driver15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if15)::get(this, "", "vif15", vif15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver15::run_phase(uvm_phase phase);
    fork
      get_and_drive15();
      reset_signals15();
    join
  endtask : run_phase

  // Continually15 detects15 transfers15
  task ahb_slave_driver15::get_and_drive15();
    @(posedge vif15.ahb_resetn15);
    `uvm_info(get_type_name(), "Reset15 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif15.ahb_clock15 iff vif15.AHB_HREADY15===1'b1);
      // Get15 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive15 the response
      send_response15(rsp);
      // Communicate15 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive15

  // Reset15 all signals15
  task ahb_slave_driver15::reset_signals15();
    forever begin
      @(negedge vif15.ahb_resetn15);
      `uvm_info(get_type_name(), "Reset15 observed15", UVM_MEDIUM)
      vif15.AHB_HREADY15      <= 0;
    end
  endtask : reset_signals15

  // Response15 to a transfer15 from the DUT
  task ahb_slave_driver15::send_response15(ahb_transfer15 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving15 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif15.AHB_HWDATA15;
    vif15.AHB_HREADY15  <= 1;
    @(posedge vif15.ahb_clock15);
    vif15.AHB_HREADY15 <= 0;
    @(posedge vif15.ahb_clock15);
    num_sent15++;
  endtask : send_response15

  // UVM report() phase
  function void ahb_slave_driver15::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport15: AHB15 slave15 driver sent15 %0d transfer15 responses15",
      num_sent15), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV15

