// IVB18 checksum18: 519799952
/*-----------------------------------------------------------------
File18 name     : ahb_slave_driver18.sv
Created18       : Wed18 May18 19 15:42:21 2010
Description18   : This18 file implements18 the slave18 driver functionality
Notes18         : 
-----------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV18
`define AHB_SLAVE_DRIVER_SV18

//------------------------------------------------------------------------------
//
// CLASS18: ahb_slave_driver18
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB18-NOTE18 : REQUIRED18 : slave18 DRIVER18 functionality : DRIVER18
   -------------------------------------------------------------------------
   Modify18 the following18 methods18 to match your18 protocol18:
     o respond_transfer18() - response driving18
     o reset_signals18() - slave18 signals18 reset values
   Note18 that if you change/add signals18 to the physical interface, you must
   also change these18 methods18.
   ***************************************************************************/

class ahb_slave_driver18 extends uvm_driver #(ahb_transfer18);

  // The virtual interface used to drive18 and view18 HDL signals18.
  virtual interface ahb_if18 vif18;
    
  // Count18 transfer_responses18 sent18
  int num_sent18;

  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver18)

  // Constructor18 - required18 syntax18 for UVM automation18 and utilities18
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional18 class methods18
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive18();
  extern virtual protected task reset_signals18();
  extern virtual protected task send_response18(ahb_transfer18 response);
  extern virtual function void report();

endclass : ahb_slave_driver18

//UVM connect_phase
function void ahb_slave_driver18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if18)::get(this, "", "vif18", vif18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver18::run_phase(uvm_phase phase);
    fork
      get_and_drive18();
      reset_signals18();
    join
  endtask : run_phase

  // Continually18 detects18 transfers18
  task ahb_slave_driver18::get_and_drive18();
    @(posedge vif18.ahb_resetn18);
    `uvm_info(get_type_name(), "Reset18 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif18.ahb_clock18 iff vif18.AHB_HREADY18===1'b1);
      // Get18 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive18 the response
      send_response18(rsp);
      // Communicate18 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive18

  // Reset18 all signals18
  task ahb_slave_driver18::reset_signals18();
    forever begin
      @(negedge vif18.ahb_resetn18);
      `uvm_info(get_type_name(), "Reset18 observed18", UVM_MEDIUM)
      vif18.AHB_HREADY18      <= 0;
    end
  endtask : reset_signals18

  // Response18 to a transfer18 from the DUT
  task ahb_slave_driver18::send_response18(ahb_transfer18 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving18 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif18.AHB_HWDATA18;
    vif18.AHB_HREADY18  <= 1;
    @(posedge vif18.ahb_clock18);
    vif18.AHB_HREADY18 <= 0;
    @(posedge vif18.ahb_clock18);
    num_sent18++;
  endtask : send_response18

  // UVM report() phase
  function void ahb_slave_driver18::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport18: AHB18 slave18 driver sent18 %0d transfer18 responses18",
      num_sent18), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV18

