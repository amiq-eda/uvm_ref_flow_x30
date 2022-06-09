// IVB22 checksum22: 519799952
/*-----------------------------------------------------------------
File22 name     : ahb_slave_driver22.sv
Created22       : Wed22 May22 19 15:42:21 2010
Description22   : This22 file implements22 the slave22 driver functionality
Notes22         : 
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV22
`define AHB_SLAVE_DRIVER_SV22

//------------------------------------------------------------------------------
//
// CLASS22: ahb_slave_driver22
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB22-NOTE22 : REQUIRED22 : slave22 DRIVER22 functionality : DRIVER22
   -------------------------------------------------------------------------
   Modify22 the following22 methods22 to match your22 protocol22:
     o respond_transfer22() - response driving22
     o reset_signals22() - slave22 signals22 reset values
   Note22 that if you change/add signals22 to the physical interface, you must
   also change these22 methods22.
   ***************************************************************************/

class ahb_slave_driver22 extends uvm_driver #(ahb_transfer22);

  // The virtual interface used to drive22 and view22 HDL signals22.
  virtual interface ahb_if22 vif22;
    
  // Count22 transfer_responses22 sent22
  int num_sent22;

  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver22)

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional22 class methods22
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive22();
  extern virtual protected task reset_signals22();
  extern virtual protected task send_response22(ahb_transfer22 response);
  extern virtual function void report();

endclass : ahb_slave_driver22

//UVM connect_phase
function void ahb_slave_driver22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if22)::get(this, "", "vif22", vif22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver22::run_phase(uvm_phase phase);
    fork
      get_and_drive22();
      reset_signals22();
    join
  endtask : run_phase

  // Continually22 detects22 transfers22
  task ahb_slave_driver22::get_and_drive22();
    @(posedge vif22.ahb_resetn22);
    `uvm_info(get_type_name(), "Reset22 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif22.ahb_clock22 iff vif22.AHB_HREADY22===1'b1);
      // Get22 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive22 the response
      send_response22(rsp);
      // Communicate22 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive22

  // Reset22 all signals22
  task ahb_slave_driver22::reset_signals22();
    forever begin
      @(negedge vif22.ahb_resetn22);
      `uvm_info(get_type_name(), "Reset22 observed22", UVM_MEDIUM)
      vif22.AHB_HREADY22      <= 0;
    end
  endtask : reset_signals22

  // Response22 to a transfer22 from the DUT
  task ahb_slave_driver22::send_response22(ahb_transfer22 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving22 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif22.AHB_HWDATA22;
    vif22.AHB_HREADY22  <= 1;
    @(posedge vif22.ahb_clock22);
    vif22.AHB_HREADY22 <= 0;
    @(posedge vif22.ahb_clock22);
    num_sent22++;
  endtask : send_response22

  // UVM report() phase
  function void ahb_slave_driver22::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport22: AHB22 slave22 driver sent22 %0d transfer22 responses22",
      num_sent22), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV22

