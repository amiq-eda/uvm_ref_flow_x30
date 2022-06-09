// IVB16 checksum16: 519799952
/*-----------------------------------------------------------------
File16 name     : ahb_slave_driver16.sv
Created16       : Wed16 May16 19 15:42:21 2010
Description16   : This16 file implements16 the slave16 driver functionality
Notes16         : 
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV16
`define AHB_SLAVE_DRIVER_SV16

//------------------------------------------------------------------------------
//
// CLASS16: ahb_slave_driver16
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB16-NOTE16 : REQUIRED16 : slave16 DRIVER16 functionality : DRIVER16
   -------------------------------------------------------------------------
   Modify16 the following16 methods16 to match your16 protocol16:
     o respond_transfer16() - response driving16
     o reset_signals16() - slave16 signals16 reset values
   Note16 that if you change/add signals16 to the physical interface, you must
   also change these16 methods16.
   ***************************************************************************/

class ahb_slave_driver16 extends uvm_driver #(ahb_transfer16);

  // The virtual interface used to drive16 and view16 HDL signals16.
  virtual interface ahb_if16 vif16;
    
  // Count16 transfer_responses16 sent16
  int num_sent16;

  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver16)

  // Constructor16 - required16 syntax16 for UVM automation16 and utilities16
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional16 class methods16
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive16();
  extern virtual protected task reset_signals16();
  extern virtual protected task send_response16(ahb_transfer16 response);
  extern virtual function void report();

endclass : ahb_slave_driver16

//UVM connect_phase
function void ahb_slave_driver16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if16)::get(this, "", "vif16", vif16))
   `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver16::run_phase(uvm_phase phase);
    fork
      get_and_drive16();
      reset_signals16();
    join
  endtask : run_phase

  // Continually16 detects16 transfers16
  task ahb_slave_driver16::get_and_drive16();
    @(posedge vif16.ahb_resetn16);
    `uvm_info(get_type_name(), "Reset16 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif16.ahb_clock16 iff vif16.AHB_HREADY16===1'b1);
      // Get16 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive16 the response
      send_response16(rsp);
      // Communicate16 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive16

  // Reset16 all signals16
  task ahb_slave_driver16::reset_signals16();
    forever begin
      @(negedge vif16.ahb_resetn16);
      `uvm_info(get_type_name(), "Reset16 observed16", UVM_MEDIUM)
      vif16.AHB_HREADY16      <= 0;
    end
  endtask : reset_signals16

  // Response16 to a transfer16 from the DUT
  task ahb_slave_driver16::send_response16(ahb_transfer16 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving16 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif16.AHB_HWDATA16;
    vif16.AHB_HREADY16  <= 1;
    @(posedge vif16.ahb_clock16);
    vif16.AHB_HREADY16 <= 0;
    @(posedge vif16.ahb_clock16);
    num_sent16++;
  endtask : send_response16

  // UVM report() phase
  function void ahb_slave_driver16::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport16: AHB16 slave16 driver sent16 %0d transfer16 responses16",
      num_sent16), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV16

