// IVB20 checksum20: 1563143146
/*-----------------------------------------------------------------
File20 name     : ahb_master_driver20.sv
Created20       : Wed20 May20 19 15:42:20 2010
Description20   : This20 files implements20 the master20 driver functionality.
Notes20         : 
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV20
`define AHB_MASTER_DRIVER_SV20

//------------------------------------------------------------------------------
//
// CLASS20: ahb_master_driver20
//
//------------------------------------------------------------------------------

class ahb_master_driver20 extends uvm_driver #(ahb_transfer20);

 /***************************************************************************
  IVB20-NOTE20 : REQUIRED20 : master20 DRIVER20 functionality : DRIVER20
  -------------------------------------------------------------------------
  Modify20 the following20 methods20 to match your20 protocol20:
    o drive_transfer20() - Handshake20 and transfer20 driving20 process
    o reset_signals20() - master20 signal20 reset values
  Note20 that if you change/add signals20 to the physical interface, you must
  also change these20 methods20.
  ***************************************************************************/

  // The virtual interface used to drive20 and view20 HDL signals20.
  virtual interface ahb_if20 vif20;
 
  // Count20 transfers20 sent20
  int num_sent20;

  // Provide20 implmentations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils(ahb_master_driver20)

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive20();
  extern virtual protected task reset_signals20();
  extern virtual protected task drive_transfer20(ahb_transfer20 transfer20);
  extern virtual function void report();

endclass : ahb_master_driver20

//UVM connect_phase
function void ahb_master_driver20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if20)::get(this, "", "vif20", vif20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver20::run_phase(uvm_phase phase);
    fork
      get_and_drive20();
      reset_signals20();
    join
  endtask : run_phase

  // Gets20 transfers20 from the sequencer and passes20 them20 to the driver. 
  task ahb_master_driver20::get_and_drive20();
    @(posedge vif20.ahb_resetn20);
    `uvm_info(get_type_name(), "Reset20 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif20.ahb_clock20 iff vif20.AHB_HREADY20 === 1);
      // Get20 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive20 the item
      drive_transfer20(req);
      // Communicate20 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive20

  // Reset20 all master20 signals20
  task ahb_master_driver20::reset_signals20();
    forever begin
      @(negedge vif20.ahb_resetn20);
      `uvm_info(get_type_name(), "Reset20 observed20", UVM_MEDIUM)
      vif20.AHB_HWDATA20 <= 'hz;
      vif20.AHB_HTRANS20 <= IDLE20;
    end
  endtask : reset_signals20

  // Gets20 a transfer20 and drive20 it into the DUT
  task ahb_master_driver20::drive_transfer20(ahb_transfer20 transfer20);
    @(posedge vif20.ahb_clock20 iff vif20.AHB_HREADY20 === 1);
        vif20.AHB_HTRANS20 <= NONSEQ20;  
        vif20.AHB_HWRITE20 <= transfer20.direction20;
        vif20.AHB_HSIZE20 <=  transfer20.hsize20;  
        vif20.AHB_HPROT20 <=  transfer20.prot20;  
        vif20.AHB_HBURST20 <= transfer20.burst ;  
        vif20.AHB_HADDR20 <=  transfer20.address;  

    @(posedge vif20.ahb_clock20 iff vif20.AHB_HREADY20 === 1);
        if(transfer20.direction20 == WRITE) 
          vif20.AHB_HWDATA20 <= transfer20.data;
        vif20.AHB_HTRANS20 <= IDLE20;  
    num_sent20++;
    `uvm_info(get_type_name(), $psprintf("Item20 %0d Sent20 ...", num_sent20),
      UVM_HIGH)
  endtask : drive_transfer20

  // UVM report() phase
  function void ahb_master_driver20::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport20: AHB20 master20 driver sent20 %0d transfers20",
      num_sent20), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV20

