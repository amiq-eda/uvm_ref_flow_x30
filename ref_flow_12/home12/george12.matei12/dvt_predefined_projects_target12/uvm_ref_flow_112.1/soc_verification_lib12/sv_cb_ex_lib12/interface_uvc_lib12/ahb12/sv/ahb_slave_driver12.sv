// IVB12 checksum12: 519799952
/*-----------------------------------------------------------------
File12 name     : ahb_slave_driver12.sv
Created12       : Wed12 May12 19 15:42:21 2010
Description12   : This12 file implements12 the slave12 driver functionality
Notes12         : 
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV12
`define AHB_SLAVE_DRIVER_SV12

//------------------------------------------------------------------------------
//
// CLASS12: ahb_slave_driver12
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB12-NOTE12 : REQUIRED12 : slave12 DRIVER12 functionality : DRIVER12
   -------------------------------------------------------------------------
   Modify12 the following12 methods12 to match your12 protocol12:
     o respond_transfer12() - response driving12
     o reset_signals12() - slave12 signals12 reset values
   Note12 that if you change/add signals12 to the physical interface, you must
   also change these12 methods12.
   ***************************************************************************/

class ahb_slave_driver12 extends uvm_driver #(ahb_transfer12);

  // The virtual interface used to drive12 and view12 HDL signals12.
  virtual interface ahb_if12 vif12;
    
  // Count12 transfer_responses12 sent12
  int num_sent12;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver12)

  // Constructor12 - required12 syntax12 for UVM automation12 and utilities12
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional12 class methods12
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive12();
  extern virtual protected task reset_signals12();
  extern virtual protected task send_response12(ahb_transfer12 response);
  extern virtual function void report();

endclass : ahb_slave_driver12

//UVM connect_phase
function void ahb_slave_driver12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if12)::get(this, "", "vif12", vif12))
   `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver12::run_phase(uvm_phase phase);
    fork
      get_and_drive12();
      reset_signals12();
    join
  endtask : run_phase

  // Continually12 detects12 transfers12
  task ahb_slave_driver12::get_and_drive12();
    @(posedge vif12.ahb_resetn12);
    `uvm_info(get_type_name(), "Reset12 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif12.ahb_clock12 iff vif12.AHB_HREADY12===1'b1);
      // Get12 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive12 the response
      send_response12(rsp);
      // Communicate12 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive12

  // Reset12 all signals12
  task ahb_slave_driver12::reset_signals12();
    forever begin
      @(negedge vif12.ahb_resetn12);
      `uvm_info(get_type_name(), "Reset12 observed12", UVM_MEDIUM)
      vif12.AHB_HREADY12      <= 0;
    end
  endtask : reset_signals12

  // Response12 to a transfer12 from the DUT
  task ahb_slave_driver12::send_response12(ahb_transfer12 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving12 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif12.AHB_HWDATA12;
    vif12.AHB_HREADY12  <= 1;
    @(posedge vif12.ahb_clock12);
    vif12.AHB_HREADY12 <= 0;
    @(posedge vif12.ahb_clock12);
    num_sent12++;
  endtask : send_response12

  // UVM report() phase
  function void ahb_slave_driver12::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport12: AHB12 slave12 driver sent12 %0d transfer12 responses12",
      num_sent12), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV12

