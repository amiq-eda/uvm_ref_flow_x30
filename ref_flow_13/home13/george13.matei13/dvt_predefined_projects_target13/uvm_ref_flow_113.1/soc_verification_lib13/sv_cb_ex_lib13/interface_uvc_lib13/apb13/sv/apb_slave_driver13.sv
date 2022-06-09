/*******************************************************************************
  FILE : apb_slave_driver13.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_DRIVER_SV13
`define APB_SLAVE_DRIVER_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_slave_driver13 declaration13
//------------------------------------------------------------------------------

class apb_slave_driver13 extends uvm_driver #(apb_transfer13);

  // The virtual interface used to drive13 and view13 HDL signals13.
  virtual apb_if13 vif13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils(apb_slave_driver13)

  // Constructor13
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive13();
  extern virtual task reset_signals13();
  extern virtual task respond_to_transfer13(apb_transfer13 resp13);

endclass : apb_slave_driver13

// UVM connect_phase - gets13 the vif13 as a config property
function void apb_slave_driver13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if13)::get(this, "", "vif13", vif13))
      `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

// Externed13 virtual declaration13 of the run_phase method.  This13 method
// fork/join_none's the get_and_drive13() and reset_signals13() methods13.
task apb_slave_driver13::run_phase(uvm_phase phase);
  fork
    get_and_drive13();
    reset_signals13();
  join
endtask : run_phase

// Function13 that manages13 the interaction13 between the slave13
// sequence sequencer and this slave13 driver.
task apb_slave_driver13::get_and_drive13();
  @(posedge vif13.preset13);
  `uvm_info(get_type_name(), "Reset13 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer13(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive13

// Process13 task that assigns13 signals13 to reset state when reset signal13 set
task apb_slave_driver13::reset_signals13();
  forever begin
    @(negedge vif13.preset13);
    `uvm_info(get_type_name(), "Reset13 observed13",  UVM_MEDIUM)
    vif13.prdata13 <= 32'hzzzz_zzzz;
    vif13.pready13 <= 0;
    vif13.pslverr13 <= 0;
  end
endtask : reset_signals13

  // This13 task drives13 the response phases of a transfer13.
task apb_slave_driver13::respond_to_transfer13(apb_transfer13 resp13);
  begin
    vif13.pready13 <= 1'b1;
    if (resp13.direction13 == APB_READ13)
      vif13.prdata13 <= resp13.data;
    @(posedge vif13.pclock13);
    vif13.prdata13 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer13

`endif // APB_SLAVE_DRIVER_SV13
