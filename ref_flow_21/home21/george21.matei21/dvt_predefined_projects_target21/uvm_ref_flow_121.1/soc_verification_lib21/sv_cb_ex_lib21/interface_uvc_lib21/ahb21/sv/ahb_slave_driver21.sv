// IVB21 checksum21: 519799952
/*-----------------------------------------------------------------
File21 name     : ahb_slave_driver21.sv
Created21       : Wed21 May21 19 15:42:21 2010
Description21   : This21 file implements21 the slave21 driver functionality
Notes21         : 
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV21
`define AHB_SLAVE_DRIVER_SV21

//------------------------------------------------------------------------------
//
// CLASS21: ahb_slave_driver21
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB21-NOTE21 : REQUIRED21 : slave21 DRIVER21 functionality : DRIVER21
   -------------------------------------------------------------------------
   Modify21 the following21 methods21 to match your21 protocol21:
     o respond_transfer21() - response driving21
     o reset_signals21() - slave21 signals21 reset values
   Note21 that if you change/add signals21 to the physical interface, you must
   also change these21 methods21.
   ***************************************************************************/

class ahb_slave_driver21 extends uvm_driver #(ahb_transfer21);

  // The virtual interface used to drive21 and view21 HDL signals21.
  virtual interface ahb_if21 vif21;
    
  // Count21 transfer_responses21 sent21
  int num_sent21;

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver21)

  // Constructor21 - required21 syntax21 for UVM automation21 and utilities21
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional21 class methods21
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive21();
  extern virtual protected task reset_signals21();
  extern virtual protected task send_response21(ahb_transfer21 response);
  extern virtual function void report();

endclass : ahb_slave_driver21

//UVM connect_phase
function void ahb_slave_driver21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if21)::get(this, "", "vif21", vif21))
   `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver21::run_phase(uvm_phase phase);
    fork
      get_and_drive21();
      reset_signals21();
    join
  endtask : run_phase

  // Continually21 detects21 transfers21
  task ahb_slave_driver21::get_and_drive21();
    @(posedge vif21.ahb_resetn21);
    `uvm_info(get_type_name(), "Reset21 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif21.ahb_clock21 iff vif21.AHB_HREADY21===1'b1);
      // Get21 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive21 the response
      send_response21(rsp);
      // Communicate21 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive21

  // Reset21 all signals21
  task ahb_slave_driver21::reset_signals21();
    forever begin
      @(negedge vif21.ahb_resetn21);
      `uvm_info(get_type_name(), "Reset21 observed21", UVM_MEDIUM)
      vif21.AHB_HREADY21      <= 0;
    end
  endtask : reset_signals21

  // Response21 to a transfer21 from the DUT
  task ahb_slave_driver21::send_response21(ahb_transfer21 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving21 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif21.AHB_HWDATA21;
    vif21.AHB_HREADY21  <= 1;
    @(posedge vif21.ahb_clock21);
    vif21.AHB_HREADY21 <= 0;
    @(posedge vif21.ahb_clock21);
    num_sent21++;
  endtask : send_response21

  // UVM report() phase
  function void ahb_slave_driver21::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport21: AHB21 slave21 driver sent21 %0d transfer21 responses21",
      num_sent21), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV21

