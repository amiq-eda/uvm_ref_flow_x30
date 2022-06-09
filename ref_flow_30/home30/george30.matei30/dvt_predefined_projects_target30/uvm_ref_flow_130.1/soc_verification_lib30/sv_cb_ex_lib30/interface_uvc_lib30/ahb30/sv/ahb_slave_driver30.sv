// IVB30 checksum30: 519799952
/*-----------------------------------------------------------------
File30 name     : ahb_slave_driver30.sv
Created30       : Wed30 May30 19 15:42:21 2010
Description30   : This30 file implements30 the slave30 driver functionality
Notes30         : 
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV30
`define AHB_SLAVE_DRIVER_SV30

//------------------------------------------------------------------------------
//
// CLASS30: ahb_slave_driver30
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB30-NOTE30 : REQUIRED30 : slave30 DRIVER30 functionality : DRIVER30
   -------------------------------------------------------------------------
   Modify30 the following30 methods30 to match your30 protocol30:
     o respond_transfer30() - response driving30
     o reset_signals30() - slave30 signals30 reset values
   Note30 that if you change/add signals30 to the physical interface, you must
   also change these30 methods30.
   ***************************************************************************/

class ahb_slave_driver30 extends uvm_driver #(ahb_transfer30);

  // The virtual interface used to drive30 and view30 HDL signals30.
  virtual interface ahb_if30 vif30;
    
  // Count30 transfer_responses30 sent30
  int num_sent30;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver30)

  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional30 class methods30
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive30();
  extern virtual protected task reset_signals30();
  extern virtual protected task send_response30(ahb_transfer30 response);
  extern virtual function void report();

endclass : ahb_slave_driver30

//UVM connect_phase
function void ahb_slave_driver30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if30)::get(this, "", "vif30", vif30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver30::run_phase(uvm_phase phase);
    fork
      get_and_drive30();
      reset_signals30();
    join
  endtask : run_phase

  // Continually30 detects30 transfers30
  task ahb_slave_driver30::get_and_drive30();
    @(posedge vif30.ahb_resetn30);
    `uvm_info(get_type_name(), "Reset30 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif30.ahb_clock30 iff vif30.AHB_HREADY30===1'b1);
      // Get30 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive30 the response
      send_response30(rsp);
      // Communicate30 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive30

  // Reset30 all signals30
  task ahb_slave_driver30::reset_signals30();
    forever begin
      @(negedge vif30.ahb_resetn30);
      `uvm_info(get_type_name(), "Reset30 observed30", UVM_MEDIUM)
      vif30.AHB_HREADY30      <= 0;
    end
  endtask : reset_signals30

  // Response30 to a transfer30 from the DUT
  task ahb_slave_driver30::send_response30(ahb_transfer30 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving30 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif30.AHB_HWDATA30;
    vif30.AHB_HREADY30  <= 1;
    @(posedge vif30.ahb_clock30);
    vif30.AHB_HREADY30 <= 0;
    @(posedge vif30.ahb_clock30);
    num_sent30++;
  endtask : send_response30

  // UVM report() phase
  function void ahb_slave_driver30::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport30: AHB30 slave30 driver sent30 %0d transfer30 responses30",
      num_sent30), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV30

