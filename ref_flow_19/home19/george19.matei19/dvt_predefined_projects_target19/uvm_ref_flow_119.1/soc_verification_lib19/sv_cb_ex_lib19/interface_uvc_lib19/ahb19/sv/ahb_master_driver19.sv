// IVB19 checksum19: 1563143146
/*-----------------------------------------------------------------
File19 name     : ahb_master_driver19.sv
Created19       : Wed19 May19 19 15:42:20 2010
Description19   : This19 files implements19 the master19 driver functionality.
Notes19         : 
-----------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_DRIVER_SV19
`define AHB_MASTER_DRIVER_SV19

//------------------------------------------------------------------------------
//
// CLASS19: ahb_master_driver19
//
//------------------------------------------------------------------------------

class ahb_master_driver19 extends uvm_driver #(ahb_transfer19);

 /***************************************************************************
  IVB19-NOTE19 : REQUIRED19 : master19 DRIVER19 functionality : DRIVER19
  -------------------------------------------------------------------------
  Modify19 the following19 methods19 to match your19 protocol19:
    o drive_transfer19() - Handshake19 and transfer19 driving19 process
    o reset_signals19() - master19 signal19 reset values
  Note19 that if you change/add signals19 to the physical interface, you must
  also change these19 methods19.
  ***************************************************************************/

  // The virtual interface used to drive19 and view19 HDL signals19.
  virtual interface ahb_if19 vif19;
 
  // Count19 transfers19 sent19
  int num_sent19;

  // Provide19 implmentations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils(ahb_master_driver19)

  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional19 class methods19
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive19();
  extern virtual protected task reset_signals19();
  extern virtual protected task drive_transfer19(ahb_transfer19 transfer19);
  extern virtual function void report();

endclass : ahb_master_driver19

//UVM connect_phase
function void ahb_master_driver19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if19)::get(this, "", "vif19", vif19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_driver19::run_phase(uvm_phase phase);
    fork
      get_and_drive19();
      reset_signals19();
    join
  endtask : run_phase

  // Gets19 transfers19 from the sequencer and passes19 them19 to the driver. 
  task ahb_master_driver19::get_and_drive19();
    @(posedge vif19.ahb_resetn19);
    `uvm_info(get_type_name(), "Reset19 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif19.ahb_clock19 iff vif19.AHB_HREADY19 === 1);
      // Get19 new item from the sequencer
      seq_item_port.get_next_item(req);
      // Drive19 the item
      drive_transfer19(req);
      // Communicate19 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive19

  // Reset19 all master19 signals19
  task ahb_master_driver19::reset_signals19();
    forever begin
      @(negedge vif19.ahb_resetn19);
      `uvm_info(get_type_name(), "Reset19 observed19", UVM_MEDIUM)
      vif19.AHB_HWDATA19 <= 'hz;
      vif19.AHB_HTRANS19 <= IDLE19;
    end
  endtask : reset_signals19

  // Gets19 a transfer19 and drive19 it into the DUT
  task ahb_master_driver19::drive_transfer19(ahb_transfer19 transfer19);
    @(posedge vif19.ahb_clock19 iff vif19.AHB_HREADY19 === 1);
        vif19.AHB_HTRANS19 <= NONSEQ19;  
        vif19.AHB_HWRITE19 <= transfer19.direction19;
        vif19.AHB_HSIZE19 <=  transfer19.hsize19;  
        vif19.AHB_HPROT19 <=  transfer19.prot19;  
        vif19.AHB_HBURST19 <= transfer19.burst ;  
        vif19.AHB_HADDR19 <=  transfer19.address;  

    @(posedge vif19.ahb_clock19 iff vif19.AHB_HREADY19 === 1);
        if(transfer19.direction19 == WRITE) 
          vif19.AHB_HWDATA19 <= transfer19.data;
        vif19.AHB_HTRANS19 <= IDLE19;  
    num_sent19++;
    `uvm_info(get_type_name(), $psprintf("Item19 %0d Sent19 ...", num_sent19),
      UVM_HIGH)
  endtask : drive_transfer19

  // UVM report() phase
  function void ahb_master_driver19::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport19: AHB19 master19 driver sent19 %0d transfers19",
      num_sent19), UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_DRIVER_SV19

