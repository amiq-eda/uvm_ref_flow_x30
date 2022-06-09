// IVB25 checksum25: 519799952
/*-----------------------------------------------------------------
File25 name     : ahb_slave_driver25.sv
Created25       : Wed25 May25 19 15:42:21 2010
Description25   : This25 file implements25 the slave25 driver functionality
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


`ifndef AHB_SLAVE_DRIVER_SV25
`define AHB_SLAVE_DRIVER_SV25

//------------------------------------------------------------------------------
//
// CLASS25: ahb_slave_driver25
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB25-NOTE25 : REQUIRED25 : slave25 DRIVER25 functionality : DRIVER25
   -------------------------------------------------------------------------
   Modify25 the following25 methods25 to match your25 protocol25:
     o respond_transfer25() - response driving25
     o reset_signals25() - slave25 signals25 reset values
   Note25 that if you change/add signals25 to the physical interface, you must
   also change these25 methods25.
   ***************************************************************************/

class ahb_slave_driver25 extends uvm_driver #(ahb_transfer25);

  // The virtual interface used to drive25 and view25 HDL signals25.
  virtual interface ahb_if25 vif25;
    
  // Count25 transfer_responses25 sent25
  int num_sent25;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver25)

  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive25();
  extern virtual protected task reset_signals25();
  extern virtual protected task send_response25(ahb_transfer25 response);
  extern virtual function void report();

endclass : ahb_slave_driver25

//UVM connect_phase
function void ahb_slave_driver25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if25)::get(this, "", "vif25", vif25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver25::run_phase(uvm_phase phase);
    fork
      get_and_drive25();
      reset_signals25();
    join
  endtask : run_phase

  // Continually25 detects25 transfers25
  task ahb_slave_driver25::get_and_drive25();
    @(posedge vif25.ahb_resetn25);
    `uvm_info(get_type_name(), "Reset25 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif25.ahb_clock25 iff vif25.AHB_HREADY25===1'b1);
      // Get25 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive25 the response
      send_response25(rsp);
      // Communicate25 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive25

  // Reset25 all signals25
  task ahb_slave_driver25::reset_signals25();
    forever begin
      @(negedge vif25.ahb_resetn25);
      `uvm_info(get_type_name(), "Reset25 observed25", UVM_MEDIUM)
      vif25.AHB_HREADY25      <= 0;
    end
  endtask : reset_signals25

  // Response25 to a transfer25 from the DUT
  task ahb_slave_driver25::send_response25(ahb_transfer25 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving25 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif25.AHB_HWDATA25;
    vif25.AHB_HREADY25  <= 1;
    @(posedge vif25.ahb_clock25);
    vif25.AHB_HREADY25 <= 0;
    @(posedge vif25.ahb_clock25);
    num_sent25++;
  endtask : send_response25

  // UVM report() phase
  function void ahb_slave_driver25::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport25: AHB25 slave25 driver sent25 %0d transfer25 responses25",
      num_sent25), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV25

