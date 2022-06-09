// IVB20 checksum20: 519799952
/*-----------------------------------------------------------------
File20 name     : ahb_slave_driver20.sv
Created20       : Wed20 May20 19 15:42:21 2010
Description20   : This20 file implements20 the slave20 driver functionality
Notes20         : 
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV20
`define AHB_SLAVE_DRIVER_SV20

//------------------------------------------------------------------------------
//
// CLASS20: ahb_slave_driver20
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB20-NOTE20 : REQUIRED20 : slave20 DRIVER20 functionality : DRIVER20
   -------------------------------------------------------------------------
   Modify20 the following20 methods20 to match your20 protocol20:
     o respond_transfer20() - response driving20
     o reset_signals20() - slave20 signals20 reset values
   Note20 that if you change/add signals20 to the physical interface, you must
   also change these20 methods20.
   ***************************************************************************/

class ahb_slave_driver20 extends uvm_driver #(ahb_transfer20);

  // The virtual interface used to drive20 and view20 HDL signals20.
  virtual interface ahb_if20 vif20;
    
  // Count20 transfer_responses20 sent20
  int num_sent20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver20)

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive20();
  extern virtual protected task reset_signals20();
  extern virtual protected task send_response20(ahb_transfer20 response);
  extern virtual function void report();

endclass : ahb_slave_driver20

//UVM connect_phase
function void ahb_slave_driver20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if20)::get(this, "", "vif20", vif20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver20::run_phase(uvm_phase phase);
    fork
      get_and_drive20();
      reset_signals20();
    join
  endtask : run_phase

  // Continually20 detects20 transfers20
  task ahb_slave_driver20::get_and_drive20();
    @(posedge vif20.ahb_resetn20);
    `uvm_info(get_type_name(), "Reset20 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif20.ahb_clock20 iff vif20.AHB_HREADY20===1'b1);
      // Get20 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive20 the response
      send_response20(rsp);
      // Communicate20 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive20

  // Reset20 all signals20
  task ahb_slave_driver20::reset_signals20();
    forever begin
      @(negedge vif20.ahb_resetn20);
      `uvm_info(get_type_name(), "Reset20 observed20", UVM_MEDIUM)
      vif20.AHB_HREADY20      <= 0;
    end
  endtask : reset_signals20

  // Response20 to a transfer20 from the DUT
  task ahb_slave_driver20::send_response20(ahb_transfer20 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving20 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif20.AHB_HWDATA20;
    vif20.AHB_HREADY20  <= 1;
    @(posedge vif20.ahb_clock20);
    vif20.AHB_HREADY20 <= 0;
    @(posedge vif20.ahb_clock20);
    num_sent20++;
  endtask : send_response20

  // UVM report() phase
  function void ahb_slave_driver20::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport20: AHB20 slave20 driver sent20 %0d transfer20 responses20",
      num_sent20), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV20

