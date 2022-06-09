// IVB28 checksum28: 1563143146
/*-----------------------------------------------------------------
File28 name     : ahb_master_driver28.sv
Created28       : Wed28 May28 19 15:42:20 2010
Description28   : This28 files implements28 the master28 driver functionality.
Notes28         : 
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV28
`define AHB_MASTER_DRIVER_SV28

//------------------------------------------------------------------------------
//
// CLASS28: ahb_master_driver28
//
//------------------------------------------------------------------------------

class ahb_master_driver28 extends uvm_driver #(ahb_transfer28);

 /***************************************************************************
  IVB28-NOTE28 : REQUIRED28 : master28 DRIVER28 functionality : DRIVER28
  -------------------------------------------------------------------------
  Modify28 the following28 methods28 to match your28 protocol28:
    o drive_transfer28() - Handshake28 and transfer28 driving28 process
    o reset_signals28() - master28 signal28 reset values
  Note28 that if you change/add signals28 to the physical interface, you must
  also change these28 methods28.
  ***************************************************************************/

  // The virtual interface used to drive28 and view28 HDL signals28.
  virtual interface ahb_if28 vif28;
 
  // Count28 transfers28 sent28
  int num_sent28;

  // Provide28 implmentations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils(ahb_master_driver28)

  // Constructor28 - required28 syntax28 for UVM automation28 and utilities28
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional28 class methods28
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive28();
  extern virtual protected task reset_signals28();
  extern virtual protected task drive_transfer28(ahb_transfer28 transfer28);
  extern virtual function void report();

endclass : ahb_master_driver28

//UVM connect_phase
function void ahb_master_driver28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if28)::get(this, "", "vif28", vif28))
   `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver28::run_phase(uvm_phase phase);
    fork
      get_and_drive28();
      reset_signals28();
    join
  endtask : run_phase

  // Gets28 transfers28 from the sequencer and passes28 them28 to the driver. 
  task ahb_master_driver28::get_and_drive28();
    @(posedge vif28.ahb_resetn28);
    `uvm_info(get_type_name(), "Reset28 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif28.ahb_clock28 iff vif28.AHB_HREADY28 === 1);
      // Get28 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive28 the item
      drive_transfer28(req);
      // Communicate28 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive28

  // Reset28 all master28 signals28
  task ahb_master_driver28::reset_signals28();
    forever begin
      @(negedge vif28.ahb_resetn28);
      `uvm_info(get_type_name(), "Reset28 observed28", UVM_MEDIUM)
      vif28.AHB_HWDATA28 <= 'hz;
      vif28.AHB_HTRANS28 <= IDLE28;
    end
  endtask : reset_signals28

  // Gets28 a transfer28 and drive28 it into the DUT
  task ahb_master_driver28::drive_transfer28(ahb_transfer28 transfer28);
    @(posedge vif28.ahb_clock28 iff vif28.AHB_HREADY28 === 1);
        vif28.AHB_HTRANS28 <= NONSEQ28;  
        vif28.AHB_HWRITE28 <= transfer28.direction28;
        vif28.AHB_HSIZE28 <=  transfer28.hsize28;  
        vif28.AHB_HPROT28 <=  transfer28.prot28;  
        vif28.AHB_HBURST28 <= transfer28.burst ;  
        vif28.AHB_HADDR28 <=  transfer28.address;  

    @(posedge vif28.ahb_clock28 iff vif28.AHB_HREADY28 === 1);
        if(transfer28.direction28 == WRITE) 
          vif28.AHB_HWDATA28 <= transfer28.data;
        vif28.AHB_HTRANS28 <= IDLE28;  
    num_sent28++;
    `uvm_info(get_type_name(), $psprintf("Item28 %0d Sent28 ...", num_sent28),
      UVM_HIGH)
  endtask : drive_transfer28

  // UVM report() phase
  function void ahb_master_driver28::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport28: AHB28 master28 driver sent28 %0d transfers28",
      num_sent28), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV28

