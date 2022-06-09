// IVB29 checksum29: 519799952
/*-----------------------------------------------------------------
File29 name     : ahb_slave_driver29.sv
Created29       : Wed29 May29 19 15:42:21 2010
Description29   : This29 file implements29 the slave29 driver functionality
Notes29         : 
-----------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV29
`define AHB_SLAVE_DRIVER_SV29

//------------------------------------------------------------------------------
//
// CLASS29: ahb_slave_driver29
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB29-NOTE29 : REQUIRED29 : slave29 DRIVER29 functionality : DRIVER29
   -------------------------------------------------------------------------
   Modify29 the following29 methods29 to match your29 protocol29:
     o respond_transfer29() - response driving29
     o reset_signals29() - slave29 signals29 reset values
   Note29 that if you change/add signals29 to the physical interface, you must
   also change these29 methods29.
   ***************************************************************************/

class ahb_slave_driver29 extends uvm_driver #(ahb_transfer29);

  // The virtual interface used to drive29 and view29 HDL signals29.
  virtual interface ahb_if29 vif29;
    
  // Count29 transfer_responses29 sent29
  int num_sent29;

  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver29)

  // Constructor29 - required29 syntax29 for UVM automation29 and utilities29
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional29 class methods29
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive29();
  extern virtual protected task reset_signals29();
  extern virtual protected task send_response29(ahb_transfer29 response);
  extern virtual function void report();

endclass : ahb_slave_driver29

//UVM connect_phase
function void ahb_slave_driver29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if29)::get(this, "", "vif29", vif29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver29::run_phase(uvm_phase phase);
    fork
      get_and_drive29();
      reset_signals29();
    join
  endtask : run_phase

  // Continually29 detects29 transfers29
  task ahb_slave_driver29::get_and_drive29();
    @(posedge vif29.ahb_resetn29);
    `uvm_info(get_type_name(), "Reset29 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif29.ahb_clock29 iff vif29.AHB_HREADY29===1'b1);
      // Get29 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive29 the response
      send_response29(rsp);
      // Communicate29 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive29

  // Reset29 all signals29
  task ahb_slave_driver29::reset_signals29();
    forever begin
      @(negedge vif29.ahb_resetn29);
      `uvm_info(get_type_name(), "Reset29 observed29", UVM_MEDIUM)
      vif29.AHB_HREADY29      <= 0;
    end
  endtask : reset_signals29

  // Response29 to a transfer29 from the DUT
  task ahb_slave_driver29::send_response29(ahb_transfer29 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving29 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif29.AHB_HWDATA29;
    vif29.AHB_HREADY29  <= 1;
    @(posedge vif29.ahb_clock29);
    vif29.AHB_HREADY29 <= 0;
    @(posedge vif29.ahb_clock29);
    num_sent29++;
  endtask : send_response29

  // UVM report() phase
  function void ahb_slave_driver29::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport29: AHB29 slave29 driver sent29 %0d transfer29 responses29",
      num_sent29), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV29

