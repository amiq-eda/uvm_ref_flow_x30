// IVB13 checksum13: 1563143146
/*-----------------------------------------------------------------
File13 name     : ahb_master_driver13.sv
Created13       : Wed13 May13 19 15:42:20 2010
Description13   : This13 files implements13 the master13 driver functionality.
Notes13         : 
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV13
`define AHB_MASTER_DRIVER_SV13

//------------------------------------------------------------------------------
//
// CLASS13: ahb_master_driver13
//
//------------------------------------------------------------------------------

class ahb_master_driver13 extends uvm_driver #(ahb_transfer13);

 /***************************************************************************
  IVB13-NOTE13 : REQUIRED13 : master13 DRIVER13 functionality : DRIVER13
  -------------------------------------------------------------------------
  Modify13 the following13 methods13 to match your13 protocol13:
    o drive_transfer13() - Handshake13 and transfer13 driving13 process
    o reset_signals13() - master13 signal13 reset values
  Note13 that if you change/add signals13 to the physical interface, you must
  also change these13 methods13.
  ***************************************************************************/

  // The virtual interface used to drive13 and view13 HDL signals13.
  virtual interface ahb_if13 vif13;
 
  // Count13 transfers13 sent13
  int num_sent13;

  // Provide13 implmentations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils(ahb_master_driver13)

  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive13();
  extern virtual protected task reset_signals13();
  extern virtual protected task drive_transfer13(ahb_transfer13 transfer13);
  extern virtual function void report();

endclass : ahb_master_driver13

//UVM connect_phase
function void ahb_master_driver13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if13)::get(this, "", "vif13", vif13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver13::run_phase(uvm_phase phase);
    fork
      get_and_drive13();
      reset_signals13();
    join
  endtask : run_phase

  // Gets13 transfers13 from the sequencer and passes13 them13 to the driver. 
  task ahb_master_driver13::get_and_drive13();
    @(posedge vif13.ahb_resetn13);
    `uvm_info(get_type_name(), "Reset13 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif13.ahb_clock13 iff vif13.AHB_HREADY13 === 1);
      // Get13 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive13 the item
      drive_transfer13(req);
      // Communicate13 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive13

  // Reset13 all master13 signals13
  task ahb_master_driver13::reset_signals13();
    forever begin
      @(negedge vif13.ahb_resetn13);
      `uvm_info(get_type_name(), "Reset13 observed13", UVM_MEDIUM)
      vif13.AHB_HWDATA13 <= 'hz;
      vif13.AHB_HTRANS13 <= IDLE13;
    end
  endtask : reset_signals13

  // Gets13 a transfer13 and drive13 it into the DUT
  task ahb_master_driver13::drive_transfer13(ahb_transfer13 transfer13);
    @(posedge vif13.ahb_clock13 iff vif13.AHB_HREADY13 === 1);
        vif13.AHB_HTRANS13 <= NONSEQ13;  
        vif13.AHB_HWRITE13 <= transfer13.direction13;
        vif13.AHB_HSIZE13 <=  transfer13.hsize13;  
        vif13.AHB_HPROT13 <=  transfer13.prot13;  
        vif13.AHB_HBURST13 <= transfer13.burst ;  
        vif13.AHB_HADDR13 <=  transfer13.address;  

    @(posedge vif13.ahb_clock13 iff vif13.AHB_HREADY13 === 1);
        if(transfer13.direction13 == WRITE) 
          vif13.AHB_HWDATA13 <= transfer13.data;
        vif13.AHB_HTRANS13 <= IDLE13;  
    num_sent13++;
    `uvm_info(get_type_name(), $psprintf("Item13 %0d Sent13 ...", num_sent13),
      UVM_HIGH)
  endtask : drive_transfer13

  // UVM report() phase
  function void ahb_master_driver13::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport13: AHB13 master13 driver sent13 %0d transfers13",
      num_sent13), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV13

