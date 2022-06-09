// IVB19 checksum19: 519799952
/*-----------------------------------------------------------------
File19 name     : ahb_slave_driver19.sv
Created19       : Wed19 May19 19 15:42:21 2010
Description19   : This19 file implements19 the slave19 driver functionality
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


`ifndef AHB_SLAVE_DRIVER_SV19
`define AHB_SLAVE_DRIVER_SV19

//------------------------------------------------------------------------------
//
// CLASS19: ahb_slave_driver19
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB19-NOTE19 : REQUIRED19 : slave19 DRIVER19 functionality : DRIVER19
   -------------------------------------------------------------------------
   Modify19 the following19 methods19 to match your19 protocol19:
     o respond_transfer19() - response driving19
     o reset_signals19() - slave19 signals19 reset values
   Note19 that if you change/add signals19 to the physical interface, you must
   also change these19 methods19.
   ***************************************************************************/

class ahb_slave_driver19 extends uvm_driver #(ahb_transfer19);

  // The virtual interface used to drive19 and view19 HDL signals19.
  virtual interface ahb_if19 vif19;
    
  // Count19 transfer_responses19 sent19
  int num_sent19;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver19)

  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional19 class methods19
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive19();
  extern virtual protected task reset_signals19();
  extern virtual protected task send_response19(ahb_transfer19 response);
  extern virtual function void report();

endclass : ahb_slave_driver19

//UVM connect_phase
function void ahb_slave_driver19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if19)::get(this, "", "vif19", vif19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver19::run_phase(uvm_phase phase);
    fork
      get_and_drive19();
      reset_signals19();
    join
  endtask : run_phase

  // Continually19 detects19 transfers19
  task ahb_slave_driver19::get_and_drive19();
    @(posedge vif19.ahb_resetn19);
    `uvm_info(get_type_name(), "Reset19 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif19.ahb_clock19 iff vif19.AHB_HREADY19===1'b1);
      // Get19 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive19 the response
      send_response19(rsp);
      // Communicate19 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive19

  // Reset19 all signals19
  task ahb_slave_driver19::reset_signals19();
    forever begin
      @(negedge vif19.ahb_resetn19);
      `uvm_info(get_type_name(), "Reset19 observed19", UVM_MEDIUM)
      vif19.AHB_HREADY19      <= 0;
    end
  endtask : reset_signals19

  // Response19 to a transfer19 from the DUT
  task ahb_slave_driver19::send_response19(ahb_transfer19 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving19 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif19.AHB_HWDATA19;
    vif19.AHB_HREADY19  <= 1;
    @(posedge vif19.ahb_clock19);
    vif19.AHB_HREADY19 <= 0;
    @(posedge vif19.ahb_clock19);
    num_sent19++;
  endtask : send_response19

  // UVM report() phase
  function void ahb_slave_driver19::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport19: AHB19 slave19 driver sent19 %0d transfer19 responses19",
      num_sent19), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV19

