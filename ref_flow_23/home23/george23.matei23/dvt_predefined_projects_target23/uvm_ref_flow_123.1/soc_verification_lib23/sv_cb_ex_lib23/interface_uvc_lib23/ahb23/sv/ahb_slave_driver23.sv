// IVB23 checksum23: 519799952
/*-----------------------------------------------------------------
File23 name     : ahb_slave_driver23.sv
Created23       : Wed23 May23 19 15:42:21 2010
Description23   : This23 file implements23 the slave23 driver functionality
Notes23         : 
-----------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV23
`define AHB_SLAVE_DRIVER_SV23

//------------------------------------------------------------------------------
//
// CLASS23: ahb_slave_driver23
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB23-NOTE23 : REQUIRED23 : slave23 DRIVER23 functionality : DRIVER23
   -------------------------------------------------------------------------
   Modify23 the following23 methods23 to match your23 protocol23:
     o respond_transfer23() - response driving23
     o reset_signals23() - slave23 signals23 reset values
   Note23 that if you change/add signals23 to the physical interface, you must
   also change these23 methods23.
   ***************************************************************************/

class ahb_slave_driver23 extends uvm_driver #(ahb_transfer23);

  // The virtual interface used to drive23 and view23 HDL signals23.
  virtual interface ahb_if23 vif23;
    
  // Count23 transfer_responses23 sent23
  int num_sent23;

  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver23)

  // Constructor23 - required23 syntax23 for UVM automation23 and utilities23
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional23 class methods23
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive23();
  extern virtual protected task reset_signals23();
  extern virtual protected task send_response23(ahb_transfer23 response);
  extern virtual function void report();

endclass : ahb_slave_driver23

//UVM connect_phase
function void ahb_slave_driver23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if23)::get(this, "", "vif23", vif23))
   `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver23::run_phase(uvm_phase phase);
    fork
      get_and_drive23();
      reset_signals23();
    join
  endtask : run_phase

  // Continually23 detects23 transfers23
  task ahb_slave_driver23::get_and_drive23();
    @(posedge vif23.ahb_resetn23);
    `uvm_info(get_type_name(), "Reset23 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif23.ahb_clock23 iff vif23.AHB_HREADY23===1'b1);
      // Get23 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive23 the response
      send_response23(rsp);
      // Communicate23 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive23

  // Reset23 all signals23
  task ahb_slave_driver23::reset_signals23();
    forever begin
      @(negedge vif23.ahb_resetn23);
      `uvm_info(get_type_name(), "Reset23 observed23", UVM_MEDIUM)
      vif23.AHB_HREADY23      <= 0;
    end
  endtask : reset_signals23

  // Response23 to a transfer23 from the DUT
  task ahb_slave_driver23::send_response23(ahb_transfer23 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving23 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif23.AHB_HWDATA23;
    vif23.AHB_HREADY23  <= 1;
    @(posedge vif23.ahb_clock23);
    vif23.AHB_HREADY23 <= 0;
    @(posedge vif23.ahb_clock23);
    num_sent23++;
  endtask : send_response23

  // UVM report() phase
  function void ahb_slave_driver23::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport23: AHB23 slave23 driver sent23 %0d transfer23 responses23",
      num_sent23), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV23

