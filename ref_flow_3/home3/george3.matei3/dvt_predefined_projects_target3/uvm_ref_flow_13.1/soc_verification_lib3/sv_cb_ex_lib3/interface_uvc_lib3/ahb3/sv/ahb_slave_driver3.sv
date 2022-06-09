// IVB3 checksum3: 519799952
/*-----------------------------------------------------------------
File3 name     : ahb_slave_driver3.sv
Created3       : Wed3 May3 19 15:42:21 2010
Description3   : This3 file implements3 the slave3 driver functionality
Notes3         : 
-----------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV3
`define AHB_SLAVE_DRIVER_SV3

//------------------------------------------------------------------------------
//
// CLASS3: ahb_slave_driver3
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB3-NOTE3 : REQUIRED3 : slave3 DRIVER3 functionality : DRIVER3
   -------------------------------------------------------------------------
   Modify3 the following3 methods3 to match your3 protocol3:
     o respond_transfer3() - response driving3
     o reset_signals3() - slave3 signals3 reset values
   Note3 that if you change/add signals3 to the physical interface, you must
   also change these3 methods3.
   ***************************************************************************/

class ahb_slave_driver3 extends uvm_driver #(ahb_transfer3);

  // The virtual interface used to drive3 and view3 HDL signals3.
  virtual interface ahb_if3 vif3;
    
  // Count3 transfer_responses3 sent3
  int num_sent3;

  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver3)

  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional3 class methods3
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive3();
  extern virtual protected task reset_signals3();
  extern virtual protected task send_response3(ahb_transfer3 response);
  extern virtual function void report();

endclass : ahb_slave_driver3

//UVM connect_phase
function void ahb_slave_driver3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if3)::get(this, "", "vif3", vif3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver3::run_phase(uvm_phase phase);
    fork
      get_and_drive3();
      reset_signals3();
    join
  endtask : run_phase

  // Continually3 detects3 transfers3
  task ahb_slave_driver3::get_and_drive3();
    @(posedge vif3.ahb_resetn3);
    `uvm_info(get_type_name(), "Reset3 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif3.ahb_clock3 iff vif3.AHB_HREADY3===1'b1);
      // Get3 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive3 the response
      send_response3(rsp);
      // Communicate3 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive3

  // Reset3 all signals3
  task ahb_slave_driver3::reset_signals3();
    forever begin
      @(negedge vif3.ahb_resetn3);
      `uvm_info(get_type_name(), "Reset3 observed3", UVM_MEDIUM)
      vif3.AHB_HREADY3      <= 0;
    end
  endtask : reset_signals3

  // Response3 to a transfer3 from the DUT
  task ahb_slave_driver3::send_response3(ahb_transfer3 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving3 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif3.AHB_HWDATA3;
    vif3.AHB_HREADY3  <= 1;
    @(posedge vif3.ahb_clock3);
    vif3.AHB_HREADY3 <= 0;
    @(posedge vif3.ahb_clock3);
    num_sent3++;
  endtask : send_response3

  // UVM report() phase
  function void ahb_slave_driver3::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport3: AHB3 slave3 driver sent3 %0d transfer3 responses3",
      num_sent3), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV3

