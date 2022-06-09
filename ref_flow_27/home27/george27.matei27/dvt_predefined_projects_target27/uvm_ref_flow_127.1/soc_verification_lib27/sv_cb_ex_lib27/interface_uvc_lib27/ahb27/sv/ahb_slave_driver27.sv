// IVB27 checksum27: 519799952
/*-----------------------------------------------------------------
File27 name     : ahb_slave_driver27.sv
Created27       : Wed27 May27 19 15:42:21 2010
Description27   : This27 file implements27 the slave27 driver functionality
Notes27         : 
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV27
`define AHB_SLAVE_DRIVER_SV27

//------------------------------------------------------------------------------
//
// CLASS27: ahb_slave_driver27
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB27-NOTE27 : REQUIRED27 : slave27 DRIVER27 functionality : DRIVER27
   -------------------------------------------------------------------------
   Modify27 the following27 methods27 to match your27 protocol27:
     o respond_transfer27() - response driving27
     o reset_signals27() - slave27 signals27 reset values
   Note27 that if you change/add signals27 to the physical interface, you must
   also change these27 methods27.
   ***************************************************************************/

class ahb_slave_driver27 extends uvm_driver #(ahb_transfer27);

  // The virtual interface used to drive27 and view27 HDL signals27.
  virtual interface ahb_if27 vif27;
    
  // Count27 transfer_responses27 sent27
  int num_sent27;

  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver27)

  // Constructor27 - required27 syntax27 for UVM automation27 and utilities27
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional27 class methods27
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive27();
  extern virtual protected task reset_signals27();
  extern virtual protected task send_response27(ahb_transfer27 response);
  extern virtual function void report();

endclass : ahb_slave_driver27

//UVM connect_phase
function void ahb_slave_driver27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if27)::get(this, "", "vif27", vif27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver27::run_phase(uvm_phase phase);
    fork
      get_and_drive27();
      reset_signals27();
    join
  endtask : run_phase

  // Continually27 detects27 transfers27
  task ahb_slave_driver27::get_and_drive27();
    @(posedge vif27.ahb_resetn27);
    `uvm_info(get_type_name(), "Reset27 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif27.ahb_clock27 iff vif27.AHB_HREADY27===1'b1);
      // Get27 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive27 the response
      send_response27(rsp);
      // Communicate27 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive27

  // Reset27 all signals27
  task ahb_slave_driver27::reset_signals27();
    forever begin
      @(negedge vif27.ahb_resetn27);
      `uvm_info(get_type_name(), "Reset27 observed27", UVM_MEDIUM)
      vif27.AHB_HREADY27      <= 0;
    end
  endtask : reset_signals27

  // Response27 to a transfer27 from the DUT
  task ahb_slave_driver27::send_response27(ahb_transfer27 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving27 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif27.AHB_HWDATA27;
    vif27.AHB_HREADY27  <= 1;
    @(posedge vif27.ahb_clock27);
    vif27.AHB_HREADY27 <= 0;
    @(posedge vif27.ahb_clock27);
    num_sent27++;
  endtask : send_response27

  // UVM report() phase
  function void ahb_slave_driver27::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport27: AHB27 slave27 driver sent27 %0d transfer27 responses27",
      num_sent27), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV27

