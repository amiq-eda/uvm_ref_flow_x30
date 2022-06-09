// IVB10 checksum10: 1563143146
/*-----------------------------------------------------------------
File10 name     : ahb_master_driver10.sv
Created10       : Wed10 May10 19 15:42:20 2010
Description10   : This10 files implements10 the master10 driver functionality.
Notes10         : 
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV10
`define AHB_MASTER_DRIVER_SV10

//------------------------------------------------------------------------------
//
// CLASS10: ahb_master_driver10
//
//------------------------------------------------------------------------------

class ahb_master_driver10 extends uvm_driver #(ahb_transfer10);

 /***************************************************************************
  IVB10-NOTE10 : REQUIRED10 : master10 DRIVER10 functionality : DRIVER10
  -------------------------------------------------------------------------
  Modify10 the following10 methods10 to match your10 protocol10:
    o drive_transfer10() - Handshake10 and transfer10 driving10 process
    o reset_signals10() - master10 signal10 reset values
  Note10 that if you change/add signals10 to the physical interface, you must
  also change these10 methods10.
  ***************************************************************************/

  // The virtual interface used to drive10 and view10 HDL signals10.
  virtual interface ahb_if10 vif10;
 
  // Count10 transfers10 sent10
  int num_sent10;

  // Provide10 implmentations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils(ahb_master_driver10)

  // Constructor10 - required10 syntax10 for UVM automation10 and utilities10
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional10 class methods10
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive10();
  extern virtual protected task reset_signals10();
  extern virtual protected task drive_transfer10(ahb_transfer10 transfer10);
  extern virtual function void report();

endclass : ahb_master_driver10

//UVM connect_phase
function void ahb_master_driver10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if10)::get(this, "", "vif10", vif10))
   `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver10::run_phase(uvm_phase phase);
    fork
      get_and_drive10();
      reset_signals10();
    join
  endtask : run_phase

  // Gets10 transfers10 from the sequencer and passes10 them10 to the driver. 
  task ahb_master_driver10::get_and_drive10();
    @(posedge vif10.ahb_resetn10);
    `uvm_info(get_type_name(), "Reset10 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif10.ahb_clock10 iff vif10.AHB_HREADY10 === 1);
      // Get10 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive10 the item
      drive_transfer10(req);
      // Communicate10 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive10

  // Reset10 all master10 signals10
  task ahb_master_driver10::reset_signals10();
    forever begin
      @(negedge vif10.ahb_resetn10);
      `uvm_info(get_type_name(), "Reset10 observed10", UVM_MEDIUM)
      vif10.AHB_HWDATA10 <= 'hz;
      vif10.AHB_HTRANS10 <= IDLE10;
    end
  endtask : reset_signals10

  // Gets10 a transfer10 and drive10 it into the DUT
  task ahb_master_driver10::drive_transfer10(ahb_transfer10 transfer10);
    @(posedge vif10.ahb_clock10 iff vif10.AHB_HREADY10 === 1);
        vif10.AHB_HTRANS10 <= NONSEQ10;  
        vif10.AHB_HWRITE10 <= transfer10.direction10;
        vif10.AHB_HSIZE10 <=  transfer10.hsize10;  
        vif10.AHB_HPROT10 <=  transfer10.prot10;  
        vif10.AHB_HBURST10 <= transfer10.burst ;  
        vif10.AHB_HADDR10 <=  transfer10.address;  

    @(posedge vif10.ahb_clock10 iff vif10.AHB_HREADY10 === 1);
        if(transfer10.direction10 == WRITE) 
          vif10.AHB_HWDATA10 <= transfer10.data;
        vif10.AHB_HTRANS10 <= IDLE10;  
    num_sent10++;
    `uvm_info(get_type_name(), $psprintf("Item10 %0d Sent10 ...", num_sent10),
      UVM_HIGH)
  endtask : drive_transfer10

  // UVM report() phase
  function void ahb_master_driver10::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport10: AHB10 master10 driver sent10 %0d transfers10",
      num_sent10), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV10

