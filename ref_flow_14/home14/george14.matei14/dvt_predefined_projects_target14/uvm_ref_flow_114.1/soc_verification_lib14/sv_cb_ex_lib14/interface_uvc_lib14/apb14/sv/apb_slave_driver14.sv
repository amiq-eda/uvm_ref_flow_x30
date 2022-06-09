/*******************************************************************************
  FILE : apb_slave_driver14.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_DRIVER_SV14
`define APB_SLAVE_DRIVER_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_slave_driver14 declaration14
//------------------------------------------------------------------------------

class apb_slave_driver14 extends uvm_driver #(apb_transfer14);

  // The virtual interface used to drive14 and view14 HDL signals14.
  virtual apb_if14 vif14;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils(apb_slave_driver14)

  // Constructor14
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task get_and_drive14();
  extern virtual task reset_signals14();
  extern virtual task respond_to_transfer14(apb_transfer14 resp14);

endclass : apb_slave_driver14

// UVM connect_phase - gets14 the vif14 as a config property
function void apb_slave_driver14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if14)::get(this, "", "vif14", vif14))
      `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

// Externed14 virtual declaration14 of the run_phase method.  This14 method
// fork/join_none's the get_and_drive14() and reset_signals14() methods14.
task apb_slave_driver14::run_phase(uvm_phase phase);
  fork
    get_and_drive14();
    reset_signals14();
  join
endtask : run_phase

// Function14 that manages14 the interaction14 between the slave14
// sequence sequencer and this slave14 driver.
task apb_slave_driver14::get_and_drive14();
  @(posedge vif14.preset14);
  `uvm_info(get_type_name(), "Reset14 dropped", UVM_MEDIUM)
  forever begin
    seq_item_port.get_next_item(req);
    respond_to_transfer14(req);
    seq_item_port.item_done();
  end
endtask : get_and_drive14

// Process14 task that assigns14 signals14 to reset state when reset signal14 set
task apb_slave_driver14::reset_signals14();
  forever begin
    @(negedge vif14.preset14);
    `uvm_info(get_type_name(), "Reset14 observed14",  UVM_MEDIUM)
    vif14.prdata14 <= 32'hzzzz_zzzz;
    vif14.pready14 <= 0;
    vif14.pslverr14 <= 0;
  end
endtask : reset_signals14

  // This14 task drives14 the response phases of a transfer14.
task apb_slave_driver14::respond_to_transfer14(apb_transfer14 resp14);
  begin
    vif14.pready14 <= 1'b1;
    if (resp14.direction14 == APB_READ14)
      vif14.prdata14 <= resp14.data;
    @(posedge vif14.pclock14);
    vif14.prdata14 <= 32'hzzzz_zzzz;
  end
endtask : respond_to_transfer14

`endif // APB_SLAVE_DRIVER_SV14
