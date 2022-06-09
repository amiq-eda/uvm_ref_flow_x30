// IVB14 checksum14: 519799952
/*-----------------------------------------------------------------
File14 name     : ahb_slave_driver14.sv
Created14       : Wed14 May14 19 15:42:21 2010
Description14   : This14 file implements14 the slave14 driver functionality
Notes14         : 
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV14
`define AHB_SLAVE_DRIVER_SV14

//------------------------------------------------------------------------------
//
// CLASS14: ahb_slave_driver14
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB14-NOTE14 : REQUIRED14 : slave14 DRIVER14 functionality : DRIVER14
   -------------------------------------------------------------------------
   Modify14 the following14 methods14 to match your14 protocol14:
     o respond_transfer14() - response driving14
     o reset_signals14() - slave14 signals14 reset values
   Note14 that if you change/add signals14 to the physical interface, you must
   also change these14 methods14.
   ***************************************************************************/

class ahb_slave_driver14 extends uvm_driver #(ahb_transfer14);

  // The virtual interface used to drive14 and view14 HDL signals14.
  virtual interface ahb_if14 vif14;
    
  // Count14 transfer_responses14 sent14
  int num_sent14;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver14)

  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive14();
  extern virtual protected task reset_signals14();
  extern virtual protected task send_response14(ahb_transfer14 response);
  extern virtual function void report();

endclass : ahb_slave_driver14

//UVM connect_phase
function void ahb_slave_driver14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if14)::get(this, "", "vif14", vif14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver14::run_phase(uvm_phase phase);
    fork
      get_and_drive14();
      reset_signals14();
    join
  endtask : run_phase

  // Continually14 detects14 transfers14
  task ahb_slave_driver14::get_and_drive14();
    @(posedge vif14.ahb_resetn14);
    `uvm_info(get_type_name(), "Reset14 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif14.ahb_clock14 iff vif14.AHB_HREADY14===1'b1);
      // Get14 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive14 the response
      send_response14(rsp);
      // Communicate14 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive14

  // Reset14 all signals14
  task ahb_slave_driver14::reset_signals14();
    forever begin
      @(negedge vif14.ahb_resetn14);
      `uvm_info(get_type_name(), "Reset14 observed14", UVM_MEDIUM)
      vif14.AHB_HREADY14      <= 0;
    end
  endtask : reset_signals14

  // Response14 to a transfer14 from the DUT
  task ahb_slave_driver14::send_response14(ahb_transfer14 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving14 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif14.AHB_HWDATA14;
    vif14.AHB_HREADY14  <= 1;
    @(posedge vif14.ahb_clock14);
    vif14.AHB_HREADY14 <= 0;
    @(posedge vif14.ahb_clock14);
    num_sent14++;
  endtask : send_response14

  // UVM report() phase
  function void ahb_slave_driver14::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport14: AHB14 slave14 driver sent14 %0d transfer14 responses14",
      num_sent14), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV14

