/*******************************************************************************
  FILE : apb_slave_driver4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV4
`define APB_SLAVE_DRIVER_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_slave_driver4 declaration4
//------------------------------------------------------------------------------

class apb_slave_driver4 extends uvm_driver #(apb_transfer4);

  // The virtual interface used to drive4 and view4 HDL signals4.
  virtual apb_if4 vif4;

  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils(apb_slave_driver4)

  // Constructor4
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive4();
  extern virtual task reset_signals4();
  extern virtual task respond_to_transfer4(apb_transfer4 resp4);

endclass : apb_slave_driver4

// UVM connect_phase - gets4 the vif4 as a config property
function void apb_slave_driver4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if4)::get(this, "", "vif4", vif4))
      `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

// Externed4 virtual declaration4 of the run_phase method.  This4 method
// fork/join_none's the get_and_drive4() and reset_signals4() methods4.
task apb_slave_driver4::run_phase(uvm_phase phase);
  fork
    get_and_drive4();
    reset_signals4();
  join
endtask : run_phase

// Function4 that manages4 the interaction4 between the slave4
// sequence sequencer and this slave4 driver.
task apb_slave_driver4::get_and_drive4();
  @(posedge vif4.preset4);
  `uvm_info(get_type_name(), "Reset4 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer4(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive4

// Process4 task that assigns4 signals4 to reset state when reset signal4 set
task apb_slave_driver4::reset_signals4();
  forever begin
    @(negedge vif4.preset4);
    `uvm_info(get_type_name(), "Reset4 observed4",  UVM_MEDIUM)
    vif4.prdata4 <= 32'hzzzz_zzzz;
    vif4.pready4 <= 0;
    vif4.pslverr4 <= 0;
  end
endtask : reset_signals4

  // This4 task drives4 the response phases of a transfer4.
task apb_slave_driver4::respond_to_transfer4(apb_transfer4 resp4);
  begin
    vif4.pready4 <= 1'b1;
    if (resp4.direction4 == APB_READ4)
      vif4.prdata4 <= resp4.data;
    @(posedge vif4.pclock4);
    vif4.prdata4 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer4

`endif // APB_SLAVE_DRIVER_SV4
