// IVB14 checksum14: 1563143146
/*-----------------------------------------------------------------
File14 name     : ahb_master_driver14.sv
Created14       : Wed14 May14 19 15:42:20 2010
Description14   : This14 files implements14 the master14 driver functionality.
Notes14         : 
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV14
`define AHB_MASTER_DRIVER_SV14

//------------------------------------------------------------------------------
//
// CLASS14: ahb_master_driver14
//
//------------------------------------------------------------------------------

class ahb_master_driver14 extends uvm_driver #(ahb_transfer14);

 /***************************************************************************
  IVB14-NOTE14 : REQUIRED14 : master14 DRIVER14 functionality : DRIVER14
  -------------------------------------------------------------------------
  Modify14 the following14 methods14 to match your14 protocol14:
    o drive_transfer14() - Handshake14 and transfer14 driving14 process
    o reset_signals14() - master14 signal14 reset values
  Note14 that if you change/add signals14 to the physical interface, you must
  also change these14 methods14.
  ***************************************************************************/

  // The virtual interface used to drive14 and view14 HDL signals14.
  virtual interface ahb_if14 vif14;
 
  // Count14 transfers14 sent14
  int num_sent14;

  // Provide14 implmentations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils(ahb_master_driver14)

  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive14();
  extern virtual protected task reset_signals14();
  extern virtual protected task drive_transfer14(ahb_transfer14 transfer14);
  extern virtual function void report();

endclass : ahb_master_driver14

//UVM connect_phase
function void ahb_master_driver14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if14)::get(this, "", "vif14", vif14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver14::run_phase(uvm_phase phase);
    fork
      get_and_drive14();
      reset_signals14();
    join
  endtask : run_phase

  // Gets14 transfers14 from the sequencer and passes14 them14 to the driver. 
  task ahb_master_driver14::get_and_drive14();
    @(posedge vif14.ahb_resetn14);
    `uvm_info(get_type_name(), "Reset14 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif14.ahb_clock14 iff vif14.AHB_HREADY14 === 1);
      // Get14 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive14 the item
      drive_transfer14(req);
      // Communicate14 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive14

  // Reset14 all master14 signals14
  task ahb_master_driver14::reset_signals14();
    forever begin
      @(negedge vif14.ahb_resetn14);
      `uvm_info(get_type_name(), "Reset14 observed14", UVM_MEDIUM)
      vif14.AHB_HWDATA14 <= 'hz;
      vif14.AHB_HTRANS14 <= IDLE14;
    end
  endtask : reset_signals14

  // Gets14 a transfer14 and drive14 it into the DUT
  task ahb_master_driver14::drive_transfer14(ahb_transfer14 transfer14);
    @(posedge vif14.ahb_clock14 iff vif14.AHB_HREADY14 === 1);
        vif14.AHB_HTRANS14 <= NONSEQ14;  
        vif14.AHB_HWRITE14 <= transfer14.direction14;
        vif14.AHB_HSIZE14 <=  transfer14.hsize14;  
        vif14.AHB_HPROT14 <=  transfer14.prot14;  
        vif14.AHB_HBURST14 <= transfer14.burst ;  
        vif14.AHB_HADDR14 <=  transfer14.address;  

    @(posedge vif14.ahb_clock14 iff vif14.AHB_HREADY14 === 1);
        if(transfer14.direction14 == WRITE) 
          vif14.AHB_HWDATA14 <= transfer14.data;
        vif14.AHB_HTRANS14 <= IDLE14;  
    num_sent14++;
    `uvm_info(get_type_name(), $psprintf("Item14 %0d Sent14 ...", num_sent14),
      UVM_HIGH)
  endtask : drive_transfer14

  // UVM report() phase
  function void ahb_master_driver14::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport14: AHB14 master14 driver sent14 %0d transfers14",
      num_sent14), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV14

