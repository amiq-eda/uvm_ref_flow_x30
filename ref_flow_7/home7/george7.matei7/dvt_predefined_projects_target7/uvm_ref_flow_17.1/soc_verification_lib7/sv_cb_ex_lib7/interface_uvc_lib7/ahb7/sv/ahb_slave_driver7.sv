// IVB7 checksum7: 519799952
/*-----------------------------------------------------------------
File7 name     : ahb_slave_driver7.sv
Created7       : Wed7 May7 19 15:42:21 2010
Description7   : This7 file implements7 the slave7 driver functionality
Notes7         : 
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV7
`define AHB_SLAVE_DRIVER_SV7

//------------------------------------------------------------------------------
//
// CLASS7: ahb_slave_driver7
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB7-NOTE7 : REQUIRED7 : slave7 DRIVER7 functionality : DRIVER7
   -------------------------------------------------------------------------
   Modify7 the following7 methods7 to match your7 protocol7:
     o respond_transfer7() - response driving7
     o reset_signals7() - slave7 signals7 reset values
   Note7 that if you change/add signals7 to the physical interface, you must
   also change these7 methods7.
   ***************************************************************************/

class ahb_slave_driver7 extends uvm_driver #(ahb_transfer7);

  // The virtual interface used to drive7 and view7 HDL signals7.
  virtual interface ahb_if7 vif7;
    
  // Count7 transfer_responses7 sent7
  int num_sent7;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver7)

  // Constructor7 - required7 syntax7 for UVM automation7 and utilities7
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional7 class methods7
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive7();
  extern virtual protected task reset_signals7();
  extern virtual protected task send_response7(ahb_transfer7 response);
  extern virtual function void report();

endclass : ahb_slave_driver7

//UVM connect_phase
function void ahb_slave_driver7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if7)::get(this, "", "vif7", vif7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver7::run_phase(uvm_phase phase);
    fork
      get_and_drive7();
      reset_signals7();
    join
  endtask : run_phase

  // Continually7 detects7 transfers7
  task ahb_slave_driver7::get_and_drive7();
    @(posedge vif7.ahb_resetn7);
    `uvm_info(get_type_name(), "Reset7 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif7.ahb_clock7 iff vif7.AHB_HREADY7===1'b1);
      // Get7 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive7 the response
      send_response7(rsp);
      // Communicate7 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive7

  // Reset7 all signals7
  task ahb_slave_driver7::reset_signals7();
    forever begin
      @(negedge vif7.ahb_resetn7);
      `uvm_info(get_type_name(), "Reset7 observed7", UVM_MEDIUM)
      vif7.AHB_HREADY7      <= 0;
    end
  endtask : reset_signals7

  // Response7 to a transfer7 from the DUT
  task ahb_slave_driver7::send_response7(ahb_transfer7 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving7 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif7.AHB_HWDATA7;
    vif7.AHB_HREADY7  <= 1;
    @(posedge vif7.ahb_clock7);
    vif7.AHB_HREADY7 <= 0;
    @(posedge vif7.ahb_clock7);
    num_sent7++;
  endtask : send_response7

  // UVM report() phase
  function void ahb_slave_driver7::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport7: AHB7 slave7 driver sent7 %0d transfer7 responses7",
      num_sent7), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV7

