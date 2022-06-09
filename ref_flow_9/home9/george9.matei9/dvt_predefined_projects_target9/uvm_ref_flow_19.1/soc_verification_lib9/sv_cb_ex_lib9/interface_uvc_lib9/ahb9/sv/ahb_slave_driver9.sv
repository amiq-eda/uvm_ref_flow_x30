// IVB9 checksum9: 519799952
/*-----------------------------------------------------------------
File9 name     : ahb_slave_driver9.sv
Created9       : Wed9 May9 19 15:42:21 2010
Description9   : This9 file implements9 the slave9 driver functionality
Notes9         : 
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_DRIVER_SV9
`define AHB_SLAVE_DRIVER_SV9

//------------------------------------------------------------------------------
//
// CLASS9: ahb_slave_driver9
//
//------------------------------------------------------------------------------

  /***************************************************************************
   IVB9-NOTE9 : REQUIRED9 : slave9 DRIVER9 functionality : DRIVER9
   -------------------------------------------------------------------------
   Modify9 the following9 methods9 to match your9 protocol9:
     o respond_transfer9() - response driving9
     o reset_signals9() - slave9 signals9 reset values
   Note9 that if you change/add signals9 to the physical interface, you must
   also change these9 methods9.
   ***************************************************************************/

class ahb_slave_driver9 extends uvm_driver #(ahb_transfer9);

  // The virtual interface used to drive9 and view9 HDL signals9.
  virtual interface ahb_if9 vif9;
    
  // Count9 transfer_responses9 sent9
  int num_sent9;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils(ahb_slave_driver9)

  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task get_and_drive9();
  extern virtual protected task reset_signals9();
  extern virtual protected task send_response9(ahb_transfer9 response);
  extern virtual function void report();

endclass : ahb_slave_driver9

//UVM connect_phase
function void ahb_slave_driver9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if9)::get(this, "", "vif9", vif9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_driver9::run_phase(uvm_phase phase);
    fork
      get_and_drive9();
      reset_signals9();
    join
  endtask : run_phase

  // Continually9 detects9 transfers9
  task ahb_slave_driver9::get_and_drive9();
    @(posedge vif9.ahb_resetn9);
    `uvm_info(get_type_name(), "Reset9 dropped", UVM_MEDIUM)
    forever begin
      @(posedge vif9.ahb_clock9 iff vif9.AHB_HREADY9===1'b1);
      // Get9 new item from the sequencer
      seq_item_port.get_next_item(rsp);
      // Drive9 the response
      send_response9(rsp);
      // Communicate9 item done to the sequencer
      seq_item_port.item_done();
    end
  endtask : get_and_drive9

  // Reset9 all signals9
  task ahb_slave_driver9::reset_signals9();
    forever begin
      @(negedge vif9.ahb_resetn9);
      `uvm_info(get_type_name(), "Reset9 observed9", UVM_MEDIUM)
      vif9.AHB_HREADY9      <= 0;
    end
  endtask : reset_signals9

  // Response9 to a transfer9 from the DUT
  task ahb_slave_driver9::send_response9(ahb_transfer9 response);
    `uvm_info(get_type_name(),
      $psprintf("Driving9 response :\n%s",rsp.sprint()), UVM_HIGH)
    response.data = vif9.AHB_HWDATA9;
    vif9.AHB_HREADY9  <= 1;
    @(posedge vif9.ahb_clock9);
    vif9.AHB_HREADY9 <= 0;
    @(posedge vif9.ahb_clock9);
    num_sent9++;
  endtask : send_response9

  // UVM report() phase
  function void ahb_slave_driver9::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport9: AHB9 slave9 driver sent9 %0d transfer9 responses9",
      num_sent9), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_DRIVER_SV9

