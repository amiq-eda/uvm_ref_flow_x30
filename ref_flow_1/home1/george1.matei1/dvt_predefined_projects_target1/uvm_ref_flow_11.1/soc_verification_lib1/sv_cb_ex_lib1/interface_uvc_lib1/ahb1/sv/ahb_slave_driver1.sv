// IVB1 checksum1: 519799952
/*-----------------------------------------------------------------
File1 name     : ahb_slave_driver1.sv
Created1       : Wed1 May1 19 15:42:21 2010
Description1   : This1 file implements1 the slave1 driver functionality
Notes1         : 
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV1
`define AHB_SLAVE_DRIVER_SV1

//------------------------------------------------------------------------------
//
// CLASS1: ahb_slave_driver1
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB1-NOTE1 : REQUIRED1 : slave1 DRIVER1 functionality : DRIVER1
   -------------------------------------------------------------------------
   Modify1 the following1 methods1 to match your1 protocol1:
     o respond_transfer1() - response driving1
     o reset_signals1() - slave1 signals1 reset values
   Note1 that if you change/add signals1 to the physical interface, you must
   also change these1 methods1.
   ***************************************************************************/

class ahb_slave_driver1 extends uvm_driver #(ahb_transfer1);

  // The virtual interface used to drive1 and view1 HDL signals1.
  virtual interface ahb_if1 vif1;
    
  // Count1 transfer_responses1 sent1
  int num_sent1;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver1)

  // Constructor1 - required1 syntax1 for UVM automation1 and utilities1
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional1 class methods1
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive1();
  extern virtual protected task reset_signals1();
  extern virtual protected task send_response1(ahb_transfer1 response);
  extern virtual function void report();

endclass : ahb_slave_driver1

//UVM connect_phase
function void ahb_slave_driver1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if1)::get(this, "", "vif1", vif1))
   `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver1::run_phase(uvm_phase phase);
    fork
      get_and_drive1();
      reset_signals1();
    join
  endtask : run_phase

  // Continually1 detects1 transfers1
  task ahb_slave_driver1::get_and_drive1();
    @(posedge vif1.ahb_resetn1);
    `uvm_info(get_type_name(), "Reset1 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif1.ahb_clock1 iff vif1.AHB_HREADY1===1'b1);
      // Get1 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive1 the response
      send_response1(rsp);
      // Communicate1 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive1

  // Reset1 all signals1
  task ahb_slave_driver1::reset_signals1();
    forever begin
      @(negedge vif1.ahb_resetn1);
      `uvm_info(get_type_name(), "Reset1 observed1", UVM_MEDIUM)
      vif1.AHB_HREADY1      <= 0;
    end
  endtask : reset_signals1

  // Response1 to a transfer1 from the DUT
  task ahb_slave_driver1::send_response1(ahb_transfer1 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving1 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif1.AHB_HWDATA1;
    vif1.AHB_HREADY1  <= 1;
    @(posedge vif1.ahb_clock1);
    vif1.AHB_HREADY1 <= 0;
    @(posedge vif1.ahb_clock1);
    num_sent1++;
  endtask : send_response1

  // UVM report() phase
  function void ahb_slave_driver1::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport1: AHB1 slave1 driver sent1 %0d transfer1 responses1",
      num_sent1), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV1

