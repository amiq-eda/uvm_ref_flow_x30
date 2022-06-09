// IVB25 checksum25: 1563143146
/*-----------------------------------------------------------------
File25 name     : ahb_master_driver25.sv
Created25       : Wed25 May25 19 15:42:20 2010
Description25   : This25 files implements25 the master25 driver functionality.
Notes25         : 
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV25
`define AHB_MASTER_DRIVER_SV25

//------------------------------------------------------------------------------
//
// CLASS25: ahb_master_driver25
//
//------------------------------------------------------------------------------

class ahb_master_driver25 extends uvm_driver #(ahb_transfer25);

 /***************************************************************************
  IVB25-NOTE25 : REQUIRED25 : master25 DRIVER25 functionality : DRIVER25
  -------------------------------------------------------------------------
  Modify25 the following25 methods25 to match your25 protocol25:
    o drive_transfer25() - Handshake25 and transfer25 driving25 process
    o reset_signals25() - master25 signal25 reset values
  Note25 that if you change/add signals25 to the physical interface, you must
  also change these25 methods25.
  ***************************************************************************/

  // The virtual interface used to drive25 and view25 HDL signals25.
  virtual interface ahb_if25 vif25;
 
  // Count25 transfers25 sent25
  int num_sent25;

  // Provide25 implmentations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils(ahb_master_driver25)

  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive25();
  extern virtual protected task reset_signals25();
  extern virtual protected task drive_transfer25(ahb_transfer25 transfer25);
  extern virtual function void report();

endclass : ahb_master_driver25

//UVM connect_phase
function void ahb_master_driver25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if25)::get(this, "", "vif25", vif25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver25::run_phase(uvm_phase phase);
    fork
      get_and_drive25();
      reset_signals25();
    join
  endtask : run_phase

  // Gets25 transfers25 from the sequencer and passes25 them25 to the driver. 
  task ahb_master_driver25::get_and_drive25();
    @(posedge vif25.ahb_resetn25);
    `uvm_info(get_type_name(), "Reset25 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif25.ahb_clock25 iff vif25.AHB_HREADY25 === 1);
      // Get25 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive25 the item
      drive_transfer25(req);
      // Communicate25 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive25

  // Reset25 all master25 signals25
  task ahb_master_driver25::reset_signals25();
    forever begin
      @(negedge vif25.ahb_resetn25);
      `uvm_info(get_type_name(), "Reset25 observed25", UVM_MEDIUM)
      vif25.AHB_HWDATA25 <= 'hz;
      vif25.AHB_HTRANS25 <= IDLE25;
    end
  endtask : reset_signals25

  // Gets25 a transfer25 and drive25 it into the DUT
  task ahb_master_driver25::drive_transfer25(ahb_transfer25 transfer25);
    @(posedge vif25.ahb_clock25 iff vif25.AHB_HREADY25 === 1);
        vif25.AHB_HTRANS25 <= NONSEQ25;  
        vif25.AHB_HWRITE25 <= transfer25.direction25;
        vif25.AHB_HSIZE25 <=  transfer25.hsize25;  
        vif25.AHB_HPROT25 <=  transfer25.prot25;  
        vif25.AHB_HBURST25 <= transfer25.burst ;  
        vif25.AHB_HADDR25 <=  transfer25.address;  

    @(posedge vif25.ahb_clock25 iff vif25.AHB_HREADY25 === 1);
        if(transfer25.direction25 == WRITE) 
          vif25.AHB_HWDATA25 <= transfer25.data;
        vif25.AHB_HTRANS25 <= IDLE25;  
    num_sent25++;
    `uvm_info(get_type_name(), $psprintf("Item25 %0d Sent25 ...", num_sent25),
      UVM_HIGH)
  endtask : drive_transfer25

  // UVM report() phase
  function void ahb_master_driver25::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport25: AHB25 master25 driver sent25 %0d transfers25",
      num_sent25), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV25

