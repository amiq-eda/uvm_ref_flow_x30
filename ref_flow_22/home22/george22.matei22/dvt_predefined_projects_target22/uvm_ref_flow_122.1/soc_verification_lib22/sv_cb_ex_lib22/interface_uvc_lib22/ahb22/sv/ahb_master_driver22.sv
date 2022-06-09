// IVB22 checksum22: 1563143146
/*-----------------------------------------------------------------
File22 name     : ahb_master_driver22.sv
Created22       : Wed22 May22 19 15:42:20 2010
Description22   : This22 files implements22 the master22 driver functionality.
Notes22         : 
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV22
`define AHB_MASTER_DRIVER_SV22

//------------------------------------------------------------------------------
//
// CLASS22: ahb_master_driver22
//
//------------------------------------------------------------------------------

class ahb_master_driver22 extends uvm_driver #(ahb_transfer22);

 /***************************************************************************
  IVB22-NOTE22 : REQUIRED22 : master22 DRIVER22 functionality : DRIVER22
  -------------------------------------------------------------------------
  Modify22 the following22 methods22 to match your22 protocol22:
    o drive_transfer22() - Handshake22 and transfer22 driving22 process
    o reset_signals22() - master22 signal22 reset values
  Note22 that if you change/add signals22 to the physical interface, you must
  also change these22 methods22.
  ***************************************************************************/

  // The virtual interface used to drive22 and view22 HDL signals22.
  virtual interface ahb_if22 vif22;
 
  // Count22 transfers22 sent22
  int num_sent22;

  // Provide22 implmentations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils(ahb_master_driver22)

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional22 class methods22
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive22();
  extern virtual protected task reset_signals22();
  extern virtual protected task drive_transfer22(ahb_transfer22 transfer22);
  extern virtual function void report();

endclass : ahb_master_driver22

//UVM connect_phase
function void ahb_master_driver22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if22)::get(this, "", "vif22", vif22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver22::run_phase(uvm_phase phase);
    fork
      get_and_drive22();
      reset_signals22();
    join
  endtask : run_phase

  // Gets22 transfers22 from the sequencer and passes22 them22 to the driver. 
  task ahb_master_driver22::get_and_drive22();
    @(posedge vif22.ahb_resetn22);
    `uvm_info(get_type_name(), "Reset22 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif22.ahb_clock22 iff vif22.AHB_HREADY22 === 1);
      // Get22 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive22 the item
      drive_transfer22(req);
      // Communicate22 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive22

  // Reset22 all master22 signals22
  task ahb_master_driver22::reset_signals22();
    forever begin
      @(negedge vif22.ahb_resetn22);
      `uvm_info(get_type_name(), "Reset22 observed22", UVM_MEDIUM)
      vif22.AHB_HWDATA22 <= 'hz;
      vif22.AHB_HTRANS22 <= IDLE22;
    end
  endtask : reset_signals22

  // Gets22 a transfer22 and drive22 it into the DUT
  task ahb_master_driver22::drive_transfer22(ahb_transfer22 transfer22);
    @(posedge vif22.ahb_clock22 iff vif22.AHB_HREADY22 === 1);
        vif22.AHB_HTRANS22 <= NONSEQ22;  
        vif22.AHB_HWRITE22 <= transfer22.direction22;
        vif22.AHB_HSIZE22 <=  transfer22.hsize22;  
        vif22.AHB_HPROT22 <=  transfer22.prot22;  
        vif22.AHB_HBURST22 <= transfer22.burst ;  
        vif22.AHB_HADDR22 <=  transfer22.address;  

    @(posedge vif22.ahb_clock22 iff vif22.AHB_HREADY22 === 1);
        if(transfer22.direction22 == WRITE) 
          vif22.AHB_HWDATA22 <= transfer22.data;
        vif22.AHB_HTRANS22 <= IDLE22;  
    num_sent22++;
    `uvm_info(get_type_name(), $psprintf("Item22 %0d Sent22 ...", num_sent22),
      UVM_HIGH)
  endtask : drive_transfer22

  // UVM report() phase
  function void ahb_master_driver22::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport22: AHB22 master22 driver sent22 %0d transfers22",
      num_sent22), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV22

