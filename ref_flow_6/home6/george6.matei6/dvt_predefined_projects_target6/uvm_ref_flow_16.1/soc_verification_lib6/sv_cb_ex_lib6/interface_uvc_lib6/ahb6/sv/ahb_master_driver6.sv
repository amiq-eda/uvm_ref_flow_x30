// IVB6 checksum6: 1563143146
/*-----------------------------------------------------------------
File6 name     : ahb_master_driver6.sv
Created6       : Wed6 May6 19 15:42:20 2010
Description6   : This6 files implements6 the master6 driver functionality.
Notes6         : 
-----------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV6
`define AHB_MASTER_DRIVER_SV6

//------------------------------------------------------------------------------
//
// CLASS6: ahb_master_driver6
//
//------------------------------------------------------------------------------

class ahb_master_driver6 extends uvm_driver #(ahb_transfer6);

 /***************************************************************************
  IVB6-NOTE6 : REQUIRED6 : master6 DRIVER6 functionality : DRIVER6
  -------------------------------------------------------------------------
  Modify6 the following6 methods6 to match your6 protocol6:
    o drive_transfer6() - Handshake6 and transfer6 driving6 process
    o reset_signals6() - master6 signal6 reset values
  Note6 that if you change/add signals6 to the physical interface, you must
  also change these6 methods6.
  ***************************************************************************/

  // The virtual interface used to drive6 and view6 HDL signals6.
  virtual interface ahb_if6 vif6;
 
  // Count6 transfers6 sent6
  int num_sent6;

  // Provide6 implmentations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils(ahb_master_driver6)

  // Constructor6 - required6 syntax6 for UVM automation6 and utilities6
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional6 class methods6
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive6();
  extern virtual protected task reset_signals6();
  extern virtual protected task drive_transfer6(ahb_transfer6 transfer6);
  extern virtual function void report();

endclass : ahb_master_driver6

//UVM connect_phase
function void ahb_master_driver6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if6)::get(this, "", "vif6", vif6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver6::run_phase(uvm_phase phase);
    fork
      get_and_drive6();
      reset_signals6();
    join
  endtask : run_phase

  // Gets6 transfers6 from the sequencer and passes6 them6 to the driver. 
  task ahb_master_driver6::get_and_drive6();
    @(posedge vif6.ahb_resetn6);
    `uvm_info(get_type_name(), "Reset6 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif6.ahb_clock6 iff vif6.AHB_HREADY6 === 1);
      // Get6 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive6 the item
      drive_transfer6(req);
      // Communicate6 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive6

  // Reset6 all master6 signals6
  task ahb_master_driver6::reset_signals6();
    forever begin
      @(negedge vif6.ahb_resetn6);
      `uvm_info(get_type_name(), "Reset6 observed6", UVM_MEDIUM)
      vif6.AHB_HWDATA6 <= 'hz;
      vif6.AHB_HTRANS6 <= IDLE6;
    end
  endtask : reset_signals6

  // Gets6 a transfer6 and drive6 it into the DUT
  task ahb_master_driver6::drive_transfer6(ahb_transfer6 transfer6);
    @(posedge vif6.ahb_clock6 iff vif6.AHB_HREADY6 === 1);
        vif6.AHB_HTRANS6 <= NONSEQ6;  
        vif6.AHB_HWRITE6 <= transfer6.direction6;
        vif6.AHB_HSIZE6 <=  transfer6.hsize6;  
        vif6.AHB_HPROT6 <=  transfer6.prot6;  
        vif6.AHB_HBURST6 <= transfer6.burst ;  
        vif6.AHB_HADDR6 <=  transfer6.address;  

    @(posedge vif6.ahb_clock6 iff vif6.AHB_HREADY6 === 1);
        if(transfer6.direction6 == WRITE) 
          vif6.AHB_HWDATA6 <= transfer6.data;
        vif6.AHB_HTRANS6 <= IDLE6;  
    num_sent6++;
    `uvm_info(get_type_name(), $psprintf("Item6 %0d Sent6 ...", num_sent6),
      UVM_HIGH)
  endtask : drive_transfer6

  // UVM report() phase
  function void ahb_master_driver6::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport6: AHB6 master6 driver sent6 %0d transfers6",
      num_sent6), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV6

