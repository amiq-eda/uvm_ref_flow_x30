// IVB9 checksum9: 1563143146
/*-----------------------------------------------------------------
File9 name     : ahb_master_driver9.sv
Created9       : Wed9 May9 19 15:42:20 2010
Description9   : This9 files implements9 the master9 driver functionality.
Notes9         : 
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV9
`define AHB_MASTER_DRIVER_SV9

//------------------------------------------------------------------------------
//
// CLASS9: ahb_master_driver9
//
//------------------------------------------------------------------------------

class ahb_master_driver9 extends uvm_driver #(ahb_transfer9);

 /***************************************************************************
  IVB9-NOTE9 : REQUIRED9 : master9 DRIVER9 functionality : DRIVER9
  -------------------------------------------------------------------------
  Modify9 the following9 methods9 to match your9 protocol9:
    o drive_transfer9() - Handshake9 and transfer9 driving9 process
    o reset_signals9() - master9 signal9 reset values
  Note9 that if you change/add signals9 to the physical interface, you must
  also change these9 methods9.
  ***************************************************************************/

  // The virtual interface used to drive9 and view9 HDL signals9.
  virtual interface ahb_if9 vif9;
 
  // Count9 transfers9 sent9
  int num_sent9;

  // Provide9 implmentations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils(ahb_master_driver9)

  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive9();
  extern virtual protected task reset_signals9();
  extern virtual protected task drive_transfer9(ahb_transfer9 transfer9);
  extern virtual function void report();

endclass : ahb_master_driver9

//UVM connect_phase
function void ahb_master_driver9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if9)::get(this, "", "vif9", vif9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver9::run_phase(uvm_phase phase);
    fork
      get_and_drive9();
      reset_signals9();
    join
  endtask : run_phase

  // Gets9 transfers9 from the sequencer and passes9 them9 to the driver. 
  task ahb_master_driver9::get_and_drive9();
    @(posedge vif9.ahb_resetn9);
    `uvm_info(get_type_name(), "Reset9 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif9.ahb_clock9 iff vif9.AHB_HREADY9 === 1);
      // Get9 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive9 the item
      drive_transfer9(req);
      // Communicate9 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive9

  // Reset9 all master9 signals9
  task ahb_master_driver9::reset_signals9();
    forever begin
      @(negedge vif9.ahb_resetn9);
      `uvm_info(get_type_name(), "Reset9 observed9", UVM_MEDIUM)
      vif9.AHB_HWDATA9 <= 'hz;
      vif9.AHB_HTRANS9 <= IDLE9;
    end
  endtask : reset_signals9

  // Gets9 a transfer9 and drive9 it into the DUT
  task ahb_master_driver9::drive_transfer9(ahb_transfer9 transfer9);
    @(posedge vif9.ahb_clock9 iff vif9.AHB_HREADY9 === 1);
        vif9.AHB_HTRANS9 <= NONSEQ9;  
        vif9.AHB_HWRITE9 <= transfer9.direction9;
        vif9.AHB_HSIZE9 <=  transfer9.hsize9;  
        vif9.AHB_HPROT9 <=  transfer9.prot9;  
        vif9.AHB_HBURST9 <= transfer9.burst ;  
        vif9.AHB_HADDR9 <=  transfer9.address;  

    @(posedge vif9.ahb_clock9 iff vif9.AHB_HREADY9 === 1);
        if(transfer9.direction9 == WRITE) 
          vif9.AHB_HWDATA9 <= transfer9.data;
        vif9.AHB_HTRANS9 <= IDLE9;  
    num_sent9++;
    `uvm_info(get_type_name(), $psprintf("Item9 %0d Sent9 ...", num_sent9),
      UVM_HIGH)
  endtask : drive_transfer9

  // UVM report() phase
  function void ahb_master_driver9::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport9: AHB9 master9 driver sent9 %0d transfers9",
      num_sent9), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV9

