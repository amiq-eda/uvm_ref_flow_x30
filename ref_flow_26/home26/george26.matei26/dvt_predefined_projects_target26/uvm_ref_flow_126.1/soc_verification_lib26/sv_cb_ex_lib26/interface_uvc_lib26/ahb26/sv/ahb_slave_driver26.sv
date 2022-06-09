// IVB26 checksum26: 519799952
/*-----------------------------------------------------------------
File26 name     : ahb_slave_driver26.sv
Created26       : Wed26 May26 19 15:42:21 2010
Description26   : This26 file implements26 the slave26 driver functionality
Notes26         : 
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV26
`define AHB_SLAVE_DRIVER_SV26

//------------------------------------------------------------------------------
//
// CLASS26: ahb_slave_driver26
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB26-NOTE26 : REQUIRED26 : slave26 DRIVER26 functionality : DRIVER26
   -------------------------------------------------------------------------
   Modify26 the following26 methods26 to match your26 protocol26:
     o respond_transfer26() - response driving26
     o reset_signals26() - slave26 signals26 reset values
   Note26 that if you change/add signals26 to the physical interface, you must
   also change these26 methods26.
   ***************************************************************************/

class ahb_slave_driver26 extends uvm_driver #(ahb_transfer26);

  // The virtual interface used to drive26 and view26 HDL signals26.
  virtual interface ahb_if26 vif26;
    
  // Count26 transfer_responses26 sent26
  int num_sent26;

  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver26)

  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive26();
  extern virtual protected task reset_signals26();
  extern virtual protected task send_response26(ahb_transfer26 response);
  extern virtual function void report();

endclass : ahb_slave_driver26

//UVM connect_phase
function void ahb_slave_driver26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if26)::get(this, "", "vif26", vif26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver26::run_phase(uvm_phase phase);
    fork
      get_and_drive26();
      reset_signals26();
    join
  endtask : run_phase

  // Continually26 detects26 transfers26
  task ahb_slave_driver26::get_and_drive26();
    @(posedge vif26.ahb_resetn26);
    `uvm_info(get_type_name(), "Reset26 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif26.ahb_clock26 iff vif26.AHB_HREADY26===1'b1);
      // Get26 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive26 the response
      send_response26(rsp);
      // Communicate26 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive26

  // Reset26 all signals26
  task ahb_slave_driver26::reset_signals26();
    forever begin
      @(negedge vif26.ahb_resetn26);
      `uvm_info(get_type_name(), "Reset26 observed26", UVM_MEDIUM)
      vif26.AHB_HREADY26      <= 0;
    end
  endtask : reset_signals26

  // Response26 to a transfer26 from the DUT
  task ahb_slave_driver26::send_response26(ahb_transfer26 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving26 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif26.AHB_HWDATA26;
    vif26.AHB_HREADY26  <= 1;
    @(posedge vif26.ahb_clock26);
    vif26.AHB_HREADY26 <= 0;
    @(posedge vif26.ahb_clock26);
    num_sent26++;
  endtask : send_response26

  // UVM report() phase
  function void ahb_slave_driver26::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport26: AHB26 slave26 driver sent26 %0d transfer26 responses26",
      num_sent26), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV26

