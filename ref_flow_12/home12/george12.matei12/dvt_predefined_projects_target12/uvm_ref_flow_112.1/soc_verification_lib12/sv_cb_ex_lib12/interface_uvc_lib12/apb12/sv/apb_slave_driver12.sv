/*******************************************************************************
  FILE : apb_slave_driver12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_DRIVER_SV12
`define APB_SLAVE_DRIVER_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_slave_driver12 declaration12
//------------------------------------------------------------------------------

class apb_slave_driver12 extends uvm_driver #(apb_transfer12);

  // The virtual interface used to drive12 and view12 HDL signals12.
  virtual apb_if12 vif12;

  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils(apb_slave_driver12)

  // Constructor12
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive12();
  extern virtual task reset_signals12();
  extern virtual task respond_to_transfer12(apb_transfer12 resp12);

endclass : apb_slave_driver12

// UVM connect_phase - gets12 the vif12 as a config property
function void apb_slave_driver12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if12)::get(this, "", "vif12", vif12))
      `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

// Externed12 virtual declaration12 of the run_phase method.  This12 method
// fork/join_none's the get_and_drive12() and reset_signals12() methods12.
task apb_slave_driver12::run_phase(uvm_phase phase);
  fork
    get_and_drive12();
    reset_signals12();
  join
endtask : run_phase

// Function12 that manages12 the interaction12 between the slave12
// sequence sequencer and this slave12 driver.
task apb_slave_driver12::get_and_drive12();
  @(posedge vif12.preset12);
  `uvm_info(get_type_name(), "Reset12 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer12(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive12

// Process12 task that assigns12 signals12 to reset state when reset signal12 set
task apb_slave_driver12::reset_signals12();
  forever begin
    @(negedge vif12.preset12);
    `uvm_info(get_type_name(), "Reset12 observed12",  UVM_MEDIUM)
    vif12.prdata12 <= 32'hzzzz_zzzz;
    vif12.pready12 <= 0;
    vif12.pslverr12 <= 0;
  end
endtask : reset_signals12

  // This12 task drives12 the response phases of a transfer12.
task apb_slave_driver12::respond_to_transfer12(apb_transfer12 resp12);
  begin
    vif12.pready12 <= 1'b1;
    if (resp12.direction12 == APB_READ12)
      vif12.prdata12 <= resp12.data;
    @(posedge vif12.pclock12);
    vif12.prdata12 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer12

`endif // APB_SLAVE_DRIVER_SV12
