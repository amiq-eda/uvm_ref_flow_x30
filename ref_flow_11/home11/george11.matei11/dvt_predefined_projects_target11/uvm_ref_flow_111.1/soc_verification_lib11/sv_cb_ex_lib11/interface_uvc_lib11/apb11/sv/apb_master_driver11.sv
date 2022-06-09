/*******************************************************************************
  FILE : apb_master_driver11.sv
*******************************************************************************/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV11
`define APB_MASTER_DRIVER_SV11

//------------------------------------------------------------------------------
// CLASS11: apb_master_driver11 declaration11
//------------------------------------------------------------------------------

class apb_master_driver11 extends uvm_driver #(apb_transfer11);

  // The virtual interface used to drive11 and view11 HDL signals11.
  virtual apb_if11 vif11;
  
  // A pointer11 to the configuration unit11 of the agent11
  apb_config11 cfg;
  
  // Provide11 implementations11 of virtual methods11 such11 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver11)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor11 which calls super.new() with appropriate11 parameters11.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive11();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer11 (apb_transfer11 trans11);
  extern virtual protected task drive_address_phase11 (apb_transfer11 trans11);
  extern virtual protected task drive_data_phase11 (apb_transfer11 trans11);

endclass : apb_master_driver11

// UVM build_phase
function void apb_master_driver11::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config11)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG11", "apb_config11 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets11 the vif11 as a config property
function void apb_master_driver11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if11)::get(this, "", "vif11", vif11))
    `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

// Declaration11 of the UVM run_phase method.
task apb_master_driver11::run_phase(uvm_phase phase);
  get_and_drive11();
endtask : run_phase

// This11 task manages11 the interaction11 between the sequencer and driver
task apb_master_driver11::get_and_drive11();
  while (1) begin
    reset();
    fork 
      @(negedge vif11.preset11)
        // APB_MASTER_DRIVER11 tag11 required11 for Debug11 Labs11
        `uvm_info("APB_MASTER_DRIVER11", "get_and_drive11: Reset11 dropped", UVM_MEDIUM)
      begin
        // This11 thread11 will be killed at reset
        forever begin
          @(posedge vif11.pclock11 iff (vif11.preset11))
          seq_item_port.get_next_item(req);
          drive_transfer11(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If11 we11 are in the middle11 of a transfer11, need to end the tx11. Also11,
      //do any reset cleanup11 here11. The only way11 we11 got11 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive11

// Drive11 all signals11 to reset state 
task apb_master_driver11::reset();
  // If11 the reset is not active, then11 wait for it to become11 active before
  // resetting11 the interface.
  wait(!vif11.preset11);
  // APB_MASTER_DRIVER11 tag11 required11 for Debug11 Labs11
  `uvm_info("APB_MASTER_DRIVER11", $psprintf("Reset11 observed11"), UVM_MEDIUM)
  vif11.paddr11     <= 'h0;
  vif11.pwdata11    <= 'h0;
  vif11.prwd11      <= 'b0;
  vif11.psel11      <= 'b0;
  vif11.penable11   <= 'b0;
endtask : reset

// Drives11 a transfer11 when an item is ready to be sent11.
task apb_master_driver11::drive_transfer11 (apb_transfer11 trans11);
  void'(this.begin_tr(trans11, "apb11 master11 driver", "UVM Debug11",
       "APB11 master11 driver transaction from get_and_drive11"));
  if (trans11.transmit_delay11 > 0) begin
    repeat(trans11.transmit_delay11) @(posedge vif11.pclock11);
  end
  drive_address_phase11(trans11);
  drive_data_phase11(trans11);
  // APB_MASTER_DRIVER_TR11 tag11 required11 for Debug11 Labs11
  `uvm_info("APB_MASTER_DRIVER_TR11", $psprintf("APB11 Finished Driving11 Transfer11 \n%s",
            trans11.sprint()), UVM_HIGH)
  this.end_tr(trans11);
endtask : drive_transfer11

// Drive11 the address phase of the transfer11
task apb_master_driver11::drive_address_phase11 (apb_transfer11 trans11);
  int slave_indx11;
  slave_indx11 = cfg.get_slave_psel_by_addr11(trans11.addr);
  vif11.paddr11 <= trans11.addr;
  vif11.psel11 <= (1<<slave_indx11);
  vif11.penable11 <= 0;
  if (trans11.direction11 == APB_READ11) begin
    vif11.prwd11 <= 1'b0;
  end    
  else begin
    vif11.prwd11 <= 1'b1;
    vif11.pwdata11 <= trans11.data;
  end
  @(posedge vif11.pclock11);
endtask : drive_address_phase11

// Drive11 the data phase of the transfer11
task apb_master_driver11::drive_data_phase11 (apb_transfer11 trans11);
  vif11.penable11 <= 1;
  @(posedge vif11.pclock11 iff vif11.pready11); 
  if (trans11.direction11 == APB_READ11) begin
    trans11.data = vif11.prdata11;
  end
  vif11.penable11 <= 0;
  vif11.psel11    <= 0;
endtask : drive_data_phase11

`endif // APB_MASTER_DRIVER_SV11
