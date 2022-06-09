// IVB15 checksum15: 1563143146
/*-----------------------------------------------------------------
File15 name     : ahb_master_driver15.sv
Created15       : Wed15 May15 19 15:42:20 2010
Description15   : This15 files implements15 the master15 driver functionality.
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


`ifndef AHB_MASTER_DRIVER_SV15
`define AHB_MASTER_DRIVER_SV15

//------------------------------------------------------------------------------
//
// CLASS15: ahb_master_driver15
//
//------------------------------------------------------------------------------

class ahb_master_driver15 extends uvm_driver #(ahb_transfer15);

 /***************************************************************************
  IVB15-NOTE15 : REQUIRED15 : master15 DRIVER15 functionality : DRIVER15
  -------------------------------------------------------------------------
  Modify15 the following15 methods15 to match your15 protocol15:
    o drive_transfer15() - Handshake15 and transfer15 driving15 process
    o reset_signals15() - master15 signal15 reset values
  Note15 that if you change/add signals15 to the physical interface, you must
  also change these15 methods15.
  ***************************************************************************/

  // The virtual interface used to drive15 and view15 HDL signals15.
  virtual interface ahb_if15 vif15;
 
  // Count15 transfers15 sent15
  int num_sent15;

  // Provide15 implmentations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils(ahb_master_driver15)

  // Constructor15 - required15 syntax15 for UVM automation15 and utilities15
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional15 class methods15
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive15();
  extern virtual protected task reset_signals15();
  extern virtual protected task drive_transfer15(ahb_transfer15 transfer15);
  extern virtual function void report();

endclass : ahb_master_driver15

//UVM connect_phase
function void ahb_master_driver15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if15)::get(this, "", "vif15", vif15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver15::run_phase(uvm_phase phase);
    fork
      get_and_drive15();
      reset_signals15();
    join
  endtask : run_phase

  // Gets15 transfers15 from the sequencer and passes15 them15 to the driver. 
  task ahb_master_driver15::get_and_drive15();
    @(posedge vif15.ahb_resetn15);
    `uvm_info(get_type_name(), "Reset15 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif15.ahb_clock15 iff vif15.AHB_HREADY15 === 1);
      // Get15 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive15 the item
      drive_transfer15(req);
      // Communicate15 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive15

  // Reset15 all master15 signals15
  task ahb_master_driver15::reset_signals15();
    forever begin
      @(negedge vif15.ahb_resetn15);
      `uvm_info(get_type_name(), "Reset15 observed15", UVM_MEDIUM)
      vif15.AHB_HWDATA15 <= 'hz;
      vif15.AHB_HTRANS15 <= IDLE15;
    end
  endtask : reset_signals15

  // Gets15 a transfer15 and drive15 it into the DUT
  task ahb_master_driver15::drive_transfer15(ahb_transfer15 transfer15);
    @(posedge vif15.ahb_clock15 iff vif15.AHB_HREADY15 === 1);
        vif15.AHB_HTRANS15 <= NONSEQ15;  
        vif15.AHB_HWRITE15 <= transfer15.direction15;
        vif15.AHB_HSIZE15 <=  transfer15.hsize15;  
        vif15.AHB_HPROT15 <=  transfer15.prot15;  
        vif15.AHB_HBURST15 <= transfer15.burst ;  
        vif15.AHB_HADDR15 <=  transfer15.address;  

    @(posedge vif15.ahb_clock15 iff vif15.AHB_HREADY15 === 1);
        if(transfer15.direction15 == WRITE) 
          vif15.AHB_HWDATA15 <= transfer15.data;
        vif15.AHB_HTRANS15 <= IDLE15;  
    num_sent15++;
    `uvm_info(get_type_name(), $psprintf("Item15 %0d Sent15 ...", num_sent15),
      UVM_HIGH)
  endtask : drive_transfer15

  // UVM report() phase
  function void ahb_master_driver15::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport15: AHB15 master15 driver sent15 %0d transfers15",
      num_sent15), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV15

