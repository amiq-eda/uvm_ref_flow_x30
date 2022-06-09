// IVB3 checksum3: 1563143146
/*-----------------------------------------------------------------
File3 name     : ahb_master_driver3.sv
Created3       : Wed3 May3 19 15:42:20 2010
Description3   : This3 files implements3 the master3 driver functionality.
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


`ifndef AHB_MASTER_DRIVER_SV3
`define AHB_MASTER_DRIVER_SV3

//------------------------------------------------------------------------------
//
// CLASS3: ahb_master_driver3
//
//------------------------------------------------------------------------------

class ahb_master_driver3 extends uvm_driver #(ahb_transfer3);

 /***************************************************************************
  IVB3-NOTE3 : REQUIRED3 : master3 DRIVER3 functionality : DRIVER3
  -------------------------------------------------------------------------
  Modify3 the following3 methods3 to match your3 protocol3:
    o drive_transfer3() - Handshake3 and transfer3 driving3 process
    o reset_signals3() - master3 signal3 reset values
  Note3 that if you change/add signals3 to the physical interface, you must
  also change these3 methods3.
  ***************************************************************************/

  // The virtual interface used to drive3 and view3 HDL signals3.
  virtual interface ahb_if3 vif3;
 
  // Count3 transfers3 sent3
  int num_sent3;

  // Provide3 implmentations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils(ahb_master_driver3)

  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional3 class methods3
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive3();
  extern virtual protected task reset_signals3();
  extern virtual protected task drive_transfer3(ahb_transfer3 transfer3);
  extern virtual function void report();

endclass : ahb_master_driver3

//UVM connect_phase
function void ahb_master_driver3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if3)::get(this, "", "vif3", vif3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver3::run_phase(uvm_phase phase);
    fork
      get_and_drive3();
      reset_signals3();
    join
  endtask : run_phase

  // Gets3 transfers3 from the sequencer and passes3 them3 to the driver. 
  task ahb_master_driver3::get_and_drive3();
    @(posedge vif3.ahb_resetn3);
    `uvm_info(get_type_name(), "Reset3 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif3.ahb_clock3 iff vif3.AHB_HREADY3 === 1);
      // Get3 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive3 the item
      drive_transfer3(req);
      // Communicate3 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive3

  // Reset3 all master3 signals3
  task ahb_master_driver3::reset_signals3();
    forever begin
      @(negedge vif3.ahb_resetn3);
      `uvm_info(get_type_name(), "Reset3 observed3", UVM_MEDIUM)
      vif3.AHB_HWDATA3 <= 'hz;
      vif3.AHB_HTRANS3 <= IDLE3;
    end
  endtask : reset_signals3

  // Gets3 a transfer3 and drive3 it into the DUT
  task ahb_master_driver3::drive_transfer3(ahb_transfer3 transfer3);
    @(posedge vif3.ahb_clock3 iff vif3.AHB_HREADY3 === 1);
        vif3.AHB_HTRANS3 <= NONSEQ3;  
        vif3.AHB_HWRITE3 <= transfer3.direction3;
        vif3.AHB_HSIZE3 <=  transfer3.hsize3;  
        vif3.AHB_HPROT3 <=  transfer3.prot3;  
        vif3.AHB_HBURST3 <= transfer3.burst ;  
        vif3.AHB_HADDR3 <=  transfer3.address;  

    @(posedge vif3.ahb_clock3 iff vif3.AHB_HREADY3 === 1);
        if(transfer3.direction3 == WRITE) 
          vif3.AHB_HWDATA3 <= transfer3.data;
        vif3.AHB_HTRANS3 <= IDLE3;  
    num_sent3++;
    `uvm_info(get_type_name(), $psprintf("Item3 %0d Sent3 ...", num_sent3),
      UVM_HIGH)
  endtask : drive_transfer3

  // UVM report() phase
  function void ahb_master_driver3::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport3: AHB3 master3 driver sent3 %0d transfers3",
      num_sent3), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV3

