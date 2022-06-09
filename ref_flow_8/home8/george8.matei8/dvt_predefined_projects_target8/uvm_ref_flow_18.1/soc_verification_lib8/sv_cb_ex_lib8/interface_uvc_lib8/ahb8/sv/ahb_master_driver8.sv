// IVB8 checksum8: 1563143146
/*-----------------------------------------------------------------
File8 name     : ahb_master_driver8.sv
Created8       : Wed8 May8 19 15:42:20 2010
Description8   : This8 files implements8 the master8 driver functionality.
Notes8         : 
-----------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV8
`define AHB_MASTER_DRIVER_SV8

//------------------------------------------------------------------------------
//
// CLASS8: ahb_master_driver8
//
//------------------------------------------------------------------------------

class ahb_master_driver8 extends uvm_driver #(ahb_transfer8);

 /***************************************************************************
  IVB8-NOTE8 : REQUIRED8 : master8 DRIVER8 functionality : DRIVER8
  -------------------------------------------------------------------------
  Modify8 the following8 methods8 to match your8 protocol8:
    o drive_transfer8() - Handshake8 and transfer8 driving8 process
    o reset_signals8() - master8 signal8 reset values
  Note8 that if you change/add signals8 to the physical interface, you must
  also change these8 methods8.
  ***************************************************************************/

  // The virtual interface used to drive8 and view8 HDL signals8.
  virtual interface ahb_if8 vif8;
 
  // Count8 transfers8 sent8
  int num_sent8;

  // Provide8 implmentations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils(ahb_master_driver8)

  // Constructor8 - required8 syntax8 for UVM automation8 and utilities8
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional8 class methods8
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive8();
  extern virtual protected task reset_signals8();
  extern virtual protected task drive_transfer8(ahb_transfer8 transfer8);
  extern virtual function void report();

endclass : ahb_master_driver8

//UVM connect_phase
function void ahb_master_driver8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if8)::get(this, "", "vif8", vif8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver8::run_phase(uvm_phase phase);
    fork
      get_and_drive8();
      reset_signals8();
    join
  endtask : run_phase

  // Gets8 transfers8 from the sequencer and passes8 them8 to the driver. 
  task ahb_master_driver8::get_and_drive8();
    @(posedge vif8.ahb_resetn8);
    `uvm_info(get_type_name(), "Reset8 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif8.ahb_clock8 iff vif8.AHB_HREADY8 === 1);
      // Get8 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive8 the item
      drive_transfer8(req);
      // Communicate8 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive8

  // Reset8 all master8 signals8
  task ahb_master_driver8::reset_signals8();
    forever begin
      @(negedge vif8.ahb_resetn8);
      `uvm_info(get_type_name(), "Reset8 observed8", UVM_MEDIUM)
      vif8.AHB_HWDATA8 <= 'hz;
      vif8.AHB_HTRANS8 <= IDLE8;
    end
  endtask : reset_signals8

  // Gets8 a transfer8 and drive8 it into the DUT
  task ahb_master_driver8::drive_transfer8(ahb_transfer8 transfer8);
    @(posedge vif8.ahb_clock8 iff vif8.AHB_HREADY8 === 1);
        vif8.AHB_HTRANS8 <= NONSEQ8;  
        vif8.AHB_HWRITE8 <= transfer8.direction8;
        vif8.AHB_HSIZE8 <=  transfer8.hsize8;  
        vif8.AHB_HPROT8 <=  transfer8.prot8;  
        vif8.AHB_HBURST8 <= transfer8.burst ;  
        vif8.AHB_HADDR8 <=  transfer8.address;  

    @(posedge vif8.ahb_clock8 iff vif8.AHB_HREADY8 === 1);
        if(transfer8.direction8 == WRITE) 
          vif8.AHB_HWDATA8 <= transfer8.data;
        vif8.AHB_HTRANS8 <= IDLE8;  
    num_sent8++;
    `uvm_info(get_type_name(), $psprintf("Item8 %0d Sent8 ...", num_sent8),
      UVM_HIGH)
  endtask : drive_transfer8

  // UVM report() phase
  function void ahb_master_driver8::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport8: AHB8 master8 driver sent8 %0d transfers8",
      num_sent8), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV8

