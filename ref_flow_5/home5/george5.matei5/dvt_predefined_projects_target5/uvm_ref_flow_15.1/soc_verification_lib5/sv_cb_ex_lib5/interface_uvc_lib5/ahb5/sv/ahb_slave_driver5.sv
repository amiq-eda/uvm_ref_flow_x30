// IVB5 checksum5: 519799952
/*-----------------------------------------------------------------
File5 name     : ahb_slave_driver5.sv
Created5       : Wed5 May5 19 15:42:21 2010
Description5   : This5 file implements5 the slave5 driver functionality
Notes5         : 
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV5
`define AHB_SLAVE_DRIVER_SV5

//------------------------------------------------------------------------------
//
// CLASS5: ahb_slave_driver5
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB5-NOTE5 : REQUIRED5 : slave5 DRIVER5 functionality : DRIVER5
   -------------------------------------------------------------------------
   Modify5 the following5 methods5 to match your5 protocol5:
     o respond_transfer5() - response driving5
     o reset_signals5() - slave5 signals5 reset values
   Note5 that if you change/add signals5 to the physical interface, you must
   also change these5 methods5.
   ***************************************************************************/

class ahb_slave_driver5 extends uvm_driver #(ahb_transfer5);

  // The virtual interface used to drive5 and view5 HDL signals5.
  virtual interface ahb_if5 vif5;
    
  // Count5 transfer_responses5 sent5
  int num_sent5;

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver5)

  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional5 class methods5
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive5();
  extern virtual protected task reset_signals5();
  extern virtual protected task send_response5(ahb_transfer5 response);
  extern virtual function void report();

endclass : ahb_slave_driver5

//UVM connect_phase
function void ahb_slave_driver5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if5)::get(this, "", "vif5", vif5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver5::run_phase(uvm_phase phase);
    fork
      get_and_drive5();
      reset_signals5();
    join
  endtask : run_phase

  // Continually5 detects5 transfers5
  task ahb_slave_driver5::get_and_drive5();
    @(posedge vif5.ahb_resetn5);
    `uvm_info(get_type_name(), "Reset5 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif5.ahb_clock5 iff vif5.AHB_HREADY5===1'b1);
      // Get5 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive5 the response
      send_response5(rsp);
      // Communicate5 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive5

  // Reset5 all signals5
  task ahb_slave_driver5::reset_signals5();
    forever begin
      @(negedge vif5.ahb_resetn5);
      `uvm_info(get_type_name(), "Reset5 observed5", UVM_MEDIUM)
      vif5.AHB_HREADY5      <= 0;
    end
  endtask : reset_signals5

  // Response5 to a transfer5 from the DUT
  task ahb_slave_driver5::send_response5(ahb_transfer5 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving5 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif5.AHB_HWDATA5;
    vif5.AHB_HREADY5  <= 1;
    @(posedge vif5.ahb_clock5);
    vif5.AHB_HREADY5 <= 0;
    @(posedge vif5.ahb_clock5);
    num_sent5++;
  endtask : send_response5

  // UVM report() phase
  function void ahb_slave_driver5::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport5: AHB5 slave5 driver sent5 %0d transfer5 responses5",
      num_sent5), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV5

