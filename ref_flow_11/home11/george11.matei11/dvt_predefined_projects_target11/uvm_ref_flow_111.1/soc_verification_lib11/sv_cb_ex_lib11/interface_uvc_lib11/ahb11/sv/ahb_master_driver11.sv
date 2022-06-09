// IVB11 checksum11: 1563143146
/*-----------------------------------------------------------------
File11 name     : ahb_master_driver11.sv
Created11       : Wed11 May11 19 15:42:20 2010
Description11   : This11 files implements11 the master11 driver functionality.
Notes11         : 
-----------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV11
`define AHB_MASTER_DRIVER_SV11

//------------------------------------------------------------------------------
//
// CLASS11: ahb_master_driver11
//
//------------------------------------------------------------------------------

class ahb_master_driver11 extends uvm_driver #(ahb_transfer11);

 /***************************************************************************
  IVB11-NOTE11 : REQUIRED11 : master11 DRIVER11 functionality : DRIVER11
  -------------------------------------------------------------------------
  Modify11 the following11 methods11 to match your11 protocol11:
    o drive_transfer11() - Handshake11 and transfer11 driving11 process
    o reset_signals11() - master11 signal11 reset values
  Note11 that if you change/add signals11 to the physical interface, you must
  also change these11 methods11.
  ***************************************************************************/

  // The virtual interface used to drive11 and view11 HDL signals11.
  virtual interface ahb_if11 vif11;
 
  // Count11 transfers11 sent11
  int num_sent11;

  // Provide11 implmentations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils(ahb_master_driver11)

  // Constructor11 - required11 syntax11 for UVM automation11 and utilities11
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional11 class methods11
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive11();
  extern virtual protected task reset_signals11();
  extern virtual protected task drive_transfer11(ahb_transfer11 transfer11);
  extern virtual function void report();

endclass : ahb_master_driver11

//UVM connect_phase
function void ahb_master_driver11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if11)::get(this, "", "vif11", vif11))
   `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver11::run_phase(uvm_phase phase);
    fork
      get_and_drive11();
      reset_signals11();
    join
  endtask : run_phase

  // Gets11 transfers11 from the sequencer and passes11 them11 to the driver. 
  task ahb_master_driver11::get_and_drive11();
    @(posedge vif11.ahb_resetn11);
    `uvm_info(get_type_name(), "Reset11 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif11.ahb_clock11 iff vif11.AHB_HREADY11 === 1);
      // Get11 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive11 the item
      drive_transfer11(req);
      // Communicate11 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive11

  // Reset11 all master11 signals11
  task ahb_master_driver11::reset_signals11();
    forever begin
      @(negedge vif11.ahb_resetn11);
      `uvm_info(get_type_name(), "Reset11 observed11", UVM_MEDIUM)
      vif11.AHB_HWDATA11 <= 'hz;
      vif11.AHB_HTRANS11 <= IDLE11;
    end
  endtask : reset_signals11

  // Gets11 a transfer11 and drive11 it into the DUT
  task ahb_master_driver11::drive_transfer11(ahb_transfer11 transfer11);
    @(posedge vif11.ahb_clock11 iff vif11.AHB_HREADY11 === 1);
        vif11.AHB_HTRANS11 <= NONSEQ11;  
        vif11.AHB_HWRITE11 <= transfer11.direction11;
        vif11.AHB_HSIZE11 <=  transfer11.hsize11;  
        vif11.AHB_HPROT11 <=  transfer11.prot11;  
        vif11.AHB_HBURST11 <= transfer11.burst ;  
        vif11.AHB_HADDR11 <=  transfer11.address;  

    @(posedge vif11.ahb_clock11 iff vif11.AHB_HREADY11 === 1);
        if(transfer11.direction11 == WRITE) 
          vif11.AHB_HWDATA11 <= transfer11.data;
        vif11.AHB_HTRANS11 <= IDLE11;  
    num_sent11++;
    `uvm_info(get_type_name(), $psprintf("Item11 %0d Sent11 ...", num_sent11),
      UVM_HIGH)
  endtask : drive_transfer11

  // UVM report() phase
  function void ahb_master_driver11::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport11: AHB11 master11 driver sent11 %0d transfers11",
      num_sent11), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV11

