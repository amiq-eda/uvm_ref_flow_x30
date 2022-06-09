// IVB30 checksum30: 1563143146
/*-----------------------------------------------------------------
File30 name     : ahb_master_driver30.sv
Created30       : Wed30 May30 19 15:42:20 2010
Description30   : This30 files implements30 the master30 driver functionality.
Notes30         : 
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV30
`define AHB_MASTER_DRIVER_SV30

//------------------------------------------------------------------------------
//
// CLASS30: ahb_master_driver30
//
//------------------------------------------------------------------------------

class ahb_master_driver30 extends uvm_driver #(ahb_transfer30);

 /***************************************************************************
  IVB30-NOTE30 : REQUIRED30 : master30 DRIVER30 functionality : DRIVER30
  -------------------------------------------------------------------------
  Modify30 the following30 methods30 to match your30 protocol30:
    o drive_transfer30() - Handshake30 and transfer30 driving30 process
    o reset_signals30() - master30 signal30 reset values
  Note30 that if you change/add signals30 to the physical interface, you must
  also change these30 methods30.
  ***************************************************************************/

  // The virtual interface used to drive30 and view30 HDL signals30.
  virtual interface ahb_if30 vif30;
 
  // Count30 transfers30 sent30
  int num_sent30;

  // Provide30 implmentations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils(ahb_master_driver30)

  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional30 class methods30
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive30();
  extern virtual protected task reset_signals30();
  extern virtual protected task drive_transfer30(ahb_transfer30 transfer30);
  extern virtual function void report();

endclass : ahb_master_driver30

//UVM connect_phase
function void ahb_master_driver30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if30)::get(this, "", "vif30", vif30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver30::run_phase(uvm_phase phase);
    fork
      get_and_drive30();
      reset_signals30();
    join
  endtask : run_phase

  // Gets30 transfers30 from the sequencer and passes30 them30 to the driver. 
  task ahb_master_driver30::get_and_drive30();
    @(posedge vif30.ahb_resetn30);
    `uvm_info(get_type_name(), "Reset30 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif30.ahb_clock30 iff vif30.AHB_HREADY30 === 1);
      // Get30 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive30 the item
      drive_transfer30(req);
      // Communicate30 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive30

  // Reset30 all master30 signals30
  task ahb_master_driver30::reset_signals30();
    forever begin
      @(negedge vif30.ahb_resetn30);
      `uvm_info(get_type_name(), "Reset30 observed30", UVM_MEDIUM)
      vif30.AHB_HWDATA30 <= 'hz;
      vif30.AHB_HTRANS30 <= IDLE30;
    end
  endtask : reset_signals30

  // Gets30 a transfer30 and drive30 it into the DUT
  task ahb_master_driver30::drive_transfer30(ahb_transfer30 transfer30);
    @(posedge vif30.ahb_clock30 iff vif30.AHB_HREADY30 === 1);
        vif30.AHB_HTRANS30 <= NONSEQ30;  
        vif30.AHB_HWRITE30 <= transfer30.direction30;
        vif30.AHB_HSIZE30 <=  transfer30.hsize30;  
        vif30.AHB_HPROT30 <=  transfer30.prot30;  
        vif30.AHB_HBURST30 <= transfer30.burst ;  
        vif30.AHB_HADDR30 <=  transfer30.address;  

    @(posedge vif30.ahb_clock30 iff vif30.AHB_HREADY30 === 1);
        if(transfer30.direction30 == WRITE) 
          vif30.AHB_HWDATA30 <= transfer30.data;
        vif30.AHB_HTRANS30 <= IDLE30;  
    num_sent30++;
    `uvm_info(get_type_name(), $psprintf("Item30 %0d Sent30 ...", num_sent30),
      UVM_HIGH)
  endtask : drive_transfer30

  // UVM report() phase
  function void ahb_master_driver30::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport30: AHB30 master30 driver sent30 %0d transfers30",
      num_sent30), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV30

