/*******************************************************************************
  FILE : apb_slave_driver1.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_DRIVER_SV1
`define APB_SLAVE_DRIVER_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_slave_driver1 declaration1
//------------------------------------------------------------------------------

class apb_slave_driver1 extends uvm_driver #(apb_transfer1);

  // The virtual interface used to drive1 and view1 HDL signals1.
  virtual apb_if1 vif1;

  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils(apb_slave_driver1)

  // Constructor1
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional1 class methods1
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive1();
  extern virtual task reset_signals1();
  extern virtual task respond_to_transfer1(apb_transfer1 resp1);

endclass : apb_slave_driver1

// UVM connect_phase - gets1 the vif1 as a config property
function void apb_slave_driver1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if1)::get(this, "", "vif1", vif1))
      `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

// Externed1 virtual declaration1 of the run_phase method.  This1 method
// fork/join_none's the get_and_drive1() and reset_signals1() methods1.
task apb_slave_driver1::run_phase(uvm_phase phase);
  fork
    get_and_drive1();
    reset_signals1();
  join
endtask : run_phase

// Function1 that manages1 the interaction1 between the slave1
// sequence sequencer and this slave1 driver.
task apb_slave_driver1::get_and_drive1();
  @(posedge vif1.preset1);
  `uvm_info(get_type_name(), "Reset1 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer1(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive1

// Process1 task that assigns1 signals1 to reset state when reset signal1 set
task apb_slave_driver1::reset_signals1();
  forever begin
    @(negedge vif1.preset1);
    `uvm_info(get_type_name(), "Reset1 observed1",  UVM_MEDIUM)
    vif1.prdata1 <= 32'hzzzz_zzzz;
    vif1.pready1 <= 0;
    vif1.pslverr1 <= 0;
  end
endtask : reset_signals1

  // This1 task drives1 the response phases of a transfer1.
task apb_slave_driver1::respond_to_transfer1(apb_transfer1 resp1);
  begin
    vif1.pready1 <= 1'b1;
    if (resp1.direction1 == APB_READ1)
      vif1.prdata1 <= resp1.data;
    @(posedge vif1.pclock1);
    vif1.prdata1 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer1

`endif // APB_SLAVE_DRIVER_SV1
