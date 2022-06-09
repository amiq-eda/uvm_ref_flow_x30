// IVB17 checksum17: 519799952
/*-----------------------------------------------------------------
File17 name     : ahb_slave_driver17.sv
Created17       : Wed17 May17 19 15:42:21 2010
Description17   : This17 file implements17 the slave17 driver functionality
Notes17         : 
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV17
`define AHB_SLAVE_DRIVER_SV17

//------------------------------------------------------------------------------
//
// CLASS17: ahb_slave_driver17
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB17-NOTE17 : REQUIRED17 : slave17 DRIVER17 functionality : DRIVER17
   -------------------------------------------------------------------------
   Modify17 the following17 methods17 to match your17 protocol17:
     o respond_transfer17() - response driving17
     o reset_signals17() - slave17 signals17 reset values
   Note17 that if you change/add signals17 to the physical interface, you must
   also change these17 methods17.
   ***************************************************************************/

class ahb_slave_driver17 extends uvm_driver #(ahb_transfer17);

  // The virtual interface used to drive17 and view17 HDL signals17.
  virtual interface ahb_if17 vif17;
    
  // Count17 transfer_responses17 sent17
  int num_sent17;

  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver17)

  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional17 class methods17
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive17();
  extern virtual protected task reset_signals17();
  extern virtual protected task send_response17(ahb_transfer17 response);
  extern virtual function void report();

endclass : ahb_slave_driver17

//UVM connect_phase
function void ahb_slave_driver17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if17)::get(this, "", "vif17", vif17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver17::run_phase(uvm_phase phase);
    fork
      get_and_drive17();
      reset_signals17();
    join
  endtask : run_phase

  // Continually17 detects17 transfers17
  task ahb_slave_driver17::get_and_drive17();
    @(posedge vif17.ahb_resetn17);
    `uvm_info(get_type_name(), "Reset17 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif17.ahb_clock17 iff vif17.AHB_HREADY17===1'b1);
      // Get17 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive17 the response
      send_response17(rsp);
      // Communicate17 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive17

  // Reset17 all signals17
  task ahb_slave_driver17::reset_signals17();
    forever begin
      @(negedge vif17.ahb_resetn17);
      `uvm_info(get_type_name(), "Reset17 observed17", UVM_MEDIUM)
      vif17.AHB_HREADY17      <= 0;
    end
  endtask : reset_signals17

  // Response17 to a transfer17 from the DUT
  task ahb_slave_driver17::send_response17(ahb_transfer17 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving17 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif17.AHB_HWDATA17;
    vif17.AHB_HREADY17  <= 1;
    @(posedge vif17.ahb_clock17);
    vif17.AHB_HREADY17 <= 0;
    @(posedge vif17.ahb_clock17);
    num_sent17++;
  endtask : send_response17

  // UVM report() phase
  function void ahb_slave_driver17::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport17: AHB17 slave17 driver sent17 %0d transfer17 responses17",
      num_sent17), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV17

