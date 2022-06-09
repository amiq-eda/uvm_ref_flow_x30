// IVB13 checksum13: 519799952
/*-----------------------------------------------------------------
File13 name     : ahb_slave_driver13.sv
Created13       : Wed13 May13 19 15:42:21 2010
Description13   : This13 file implements13 the slave13 driver functionality
Notes13         : 
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV13
`define AHB_SLAVE_DRIVER_SV13

//------------------------------------------------------------------------------
//
// CLASS13: ahb_slave_driver13
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB13-NOTE13 : REQUIRED13 : slave13 DRIVER13 functionality : DRIVER13
   -------------------------------------------------------------------------
   Modify13 the following13 methods13 to match your13 protocol13:
     o respond_transfer13() - response driving13
     o reset_signals13() - slave13 signals13 reset values
   Note13 that if you change/add signals13 to the physical interface, you must
   also change these13 methods13.
   ***************************************************************************/

class ahb_slave_driver13 extends uvm_driver #(ahb_transfer13);

  // The virtual interface used to drive13 and view13 HDL signals13.
  virtual interface ahb_if13 vif13;
    
  // Count13 transfer_responses13 sent13
  int num_sent13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver13)

  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive13();
  extern virtual protected task reset_signals13();
  extern virtual protected task send_response13(ahb_transfer13 response);
  extern virtual function void report();

endclass : ahb_slave_driver13

//UVM connect_phase
function void ahb_slave_driver13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if13)::get(this, "", "vif13", vif13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver13::run_phase(uvm_phase phase);
    fork
      get_and_drive13();
      reset_signals13();
    join
  endtask : run_phase

  // Continually13 detects13 transfers13
  task ahb_slave_driver13::get_and_drive13();
    @(posedge vif13.ahb_resetn13);
    `uvm_info(get_type_name(), "Reset13 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif13.ahb_clock13 iff vif13.AHB_HREADY13===1'b1);
      // Get13 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive13 the response
      send_response13(rsp);
      // Communicate13 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive13

  // Reset13 all signals13
  task ahb_slave_driver13::reset_signals13();
    forever begin
      @(negedge vif13.ahb_resetn13);
      `uvm_info(get_type_name(), "Reset13 observed13", UVM_MEDIUM)
      vif13.AHB_HREADY13      <= 0;
    end
  endtask : reset_signals13

  // Response13 to a transfer13 from the DUT
  task ahb_slave_driver13::send_response13(ahb_transfer13 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving13 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif13.AHB_HWDATA13;
    vif13.AHB_HREADY13  <= 1;
    @(posedge vif13.ahb_clock13);
    vif13.AHB_HREADY13 <= 0;
    @(posedge vif13.ahb_clock13);
    num_sent13++;
  endtask : send_response13

  // UVM report() phase
  function void ahb_slave_driver13::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport13: AHB13 slave13 driver sent13 %0d transfer13 responses13",
      num_sent13), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV13

