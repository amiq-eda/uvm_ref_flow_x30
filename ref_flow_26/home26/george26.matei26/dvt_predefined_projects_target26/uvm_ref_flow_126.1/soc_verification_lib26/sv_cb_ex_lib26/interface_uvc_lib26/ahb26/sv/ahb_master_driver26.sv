// IVB26 checksum26: 1563143146
/*-----------------------------------------------------------------
File26 name     : ahb_master_driver26.sv
Created26       : Wed26 May26 19 15:42:20 2010
Description26   : This26 files implements26 the master26 driver functionality.
Notes26         : 
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV26
`define AHB_MASTER_DRIVER_SV26

//------------------------------------------------------------------------------
//
// CLASS26: ahb_master_driver26
//
//------------------------------------------------------------------------------

class ahb_master_driver26 extends uvm_driver #(ahb_transfer26);

 /***************************************************************************
  IVB26-NOTE26 : REQUIRED26 : master26 DRIVER26 functionality : DRIVER26
  -------------------------------------------------------------------------
  Modify26 the following26 methods26 to match your26 protocol26:
    o drive_transfer26() - Handshake26 and transfer26 driving26 process
    o reset_signals26() - master26 signal26 reset values
  Note26 that if you change/add signals26 to the physical interface, you must
  also change these26 methods26.
  ***************************************************************************/

  // The virtual interface used to drive26 and view26 HDL signals26.
  virtual interface ahb_if26 vif26;
 
  // Count26 transfers26 sent26
  int num_sent26;

  // Provide26 implmentations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils(ahb_master_driver26)

  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive26();
  extern virtual protected task reset_signals26();
  extern virtual protected task drive_transfer26(ahb_transfer26 transfer26);
  extern virtual function void report();

endclass : ahb_master_driver26

//UVM connect_phase
function void ahb_master_driver26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if26)::get(this, "", "vif26", vif26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver26::run_phase(uvm_phase phase);
    fork
      get_and_drive26();
      reset_signals26();
    join
  endtask : run_phase

  // Gets26 transfers26 from the sequencer and passes26 them26 to the driver. 
  task ahb_master_driver26::get_and_drive26();
    @(posedge vif26.ahb_resetn26);
    `uvm_info(get_type_name(), "Reset26 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif26.ahb_clock26 iff vif26.AHB_HREADY26 === 1);
      // Get26 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive26 the item
      drive_transfer26(req);
      // Communicate26 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive26

  // Reset26 all master26 signals26
  task ahb_master_driver26::reset_signals26();
    forever begin
      @(negedge vif26.ahb_resetn26);
      `uvm_info(get_type_name(), "Reset26 observed26", UVM_MEDIUM)
      vif26.AHB_HWDATA26 <= 'hz;
      vif26.AHB_HTRANS26 <= IDLE26;
    end
  endtask : reset_signals26

  // Gets26 a transfer26 and drive26 it into the DUT
  task ahb_master_driver26::drive_transfer26(ahb_transfer26 transfer26);
    @(posedge vif26.ahb_clock26 iff vif26.AHB_HREADY26 === 1);
        vif26.AHB_HTRANS26 <= NONSEQ26;  
        vif26.AHB_HWRITE26 <= transfer26.direction26;
        vif26.AHB_HSIZE26 <=  transfer26.hsize26;  
        vif26.AHB_HPROT26 <=  transfer26.prot26;  
        vif26.AHB_HBURST26 <= transfer26.burst ;  
        vif26.AHB_HADDR26 <=  transfer26.address;  

    @(posedge vif26.ahb_clock26 iff vif26.AHB_HREADY26 === 1);
        if(transfer26.direction26 == WRITE) 
          vif26.AHB_HWDATA26 <= transfer26.data;
        vif26.AHB_HTRANS26 <= IDLE26;  
    num_sent26++;
    `uvm_info(get_type_name(), $psprintf("Item26 %0d Sent26 ...", num_sent26),
      UVM_HIGH)
  endtask : drive_transfer26

  // UVM report() phase
  function void ahb_master_driver26::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport26: AHB26 master26 driver sent26 %0d transfers26",
      num_sent26), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV26

