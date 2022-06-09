/*******************************************************************************
  FILE : apb_master_driver29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV29
`define APB_MASTER_DRIVER_SV29

//------------------------------------------------------------------------------
// CLASS29: apb_master_driver29 declaration29
//------------------------------------------------------------------------------

class apb_master_driver29 extends uvm_driver #(apb_transfer29);

  // The virtual interface used to drive29 and view29 HDL signals29.
  virtual apb_if29 vif29;
  
  // A pointer29 to the configuration unit29 of the agent29
  apb_config29 cfg;
  
  // Provide29 implementations29 of virtual methods29 such29 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver29)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor29 which calls super.new() with appropriate29 parameters29.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive29();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer29 (apb_transfer29 trans29);
  extern virtual protected task drive_address_phase29 (apb_transfer29 trans29);
  extern virtual protected task drive_data_phase29 (apb_transfer29 trans29);

endclass : apb_master_driver29

// UVM build_phase
function void apb_master_driver29::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config29)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG29", "apb_config29 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets29 the vif29 as a config property
function void apb_master_driver29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if29)::get(this, "", "vif29", vif29))
    `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

// Declaration29 of the UVM run_phase method.
task apb_master_driver29::run_phase(uvm_phase phase);
  get_and_drive29();
endtask : run_phase

// This29 task manages29 the interaction29 between the sequencer and driver
task apb_master_driver29::get_and_drive29();
  while (1) begin
    reset();
    fork 
      @(negedge vif29.preset29)
        // APB_MASTER_DRIVER29 tag29 required29 for Debug29 Labs29
        `uvm_info("APB_MASTER_DRIVER29", "get_and_drive29: Reset29 dropped", UVM_MEDIUM)
      begin
        // This29 thread29 will be killed at reset
        forever begin
          @(posedge vif29.pclock29 iff (vif29.preset29))
          seq_item_port.get_next_item(req);
          drive_transfer29(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If29 we29 are in the middle29 of a transfer29, need to end the tx29. Also29,
      //do any reset cleanup29 here29. The only way29 we29 got29 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive29

// Drive29 all signals29 to reset state 
task apb_master_driver29::reset();
  // If29 the reset is not active, then29 wait for it to become29 active before
  // resetting29 the interface.
  wait(!vif29.preset29);
  // APB_MASTER_DRIVER29 tag29 required29 for Debug29 Labs29
  `uvm_info("APB_MASTER_DRIVER29", $psprintf("Reset29 observed29"), UVM_MEDIUM)
  vif29.paddr29     <= 'h0;
  vif29.pwdata29    <= 'h0;
  vif29.prwd29      <= 'b0;
  vif29.psel29      <= 'b0;
  vif29.penable29   <= 'b0;
endtask : reset

// Drives29 a transfer29 when an item is ready to be sent29.
task apb_master_driver29::drive_transfer29 (apb_transfer29 trans29);
  void'(this.begin_tr(trans29, "apb29 master29 driver", "UVM Debug29",
       "APB29 master29 driver transaction from get_and_drive29"));
  if (trans29.transmit_delay29 > 0) begin
    repeat(trans29.transmit_delay29) @(posedge vif29.pclock29);
  end
  drive_address_phase29(trans29);
  drive_data_phase29(trans29);
  // APB_MASTER_DRIVER_TR29 tag29 required29 for Debug29 Labs29
  `uvm_info("APB_MASTER_DRIVER_TR29", $psprintf("APB29 Finished Driving29 Transfer29 \n%s",
            trans29.sprint()), UVM_HIGH)
  this.end_tr(trans29);
endtask : drive_transfer29

// Drive29 the address phase of the transfer29
task apb_master_driver29::drive_address_phase29 (apb_transfer29 trans29);
  int slave_indx29;
  slave_indx29 = cfg.get_slave_psel_by_addr29(trans29.addr);
  vif29.paddr29 <= trans29.addr;
  vif29.psel29 <= (1<<slave_indx29);
  vif29.penable29 <= 0;
  if (trans29.direction29 == APB_READ29) begin
    vif29.prwd29 <= 1'b0;
  end    
  else begin
    vif29.prwd29 <= 1'b1;
    vif29.pwdata29 <= trans29.data;
  end
  @(posedge vif29.pclock29);
endtask : drive_address_phase29

// Drive29 the data phase of the transfer29
task apb_master_driver29::drive_data_phase29 (apb_transfer29 trans29);
  vif29.penable29 <= 1;
  @(posedge vif29.pclock29 iff vif29.pready29); 
  if (trans29.direction29 == APB_READ29) begin
    trans29.data = vif29.prdata29;
  end
  vif29.penable29 <= 0;
  vif29.psel29    <= 0;
endtask : drive_data_phase29

`endif // APB_MASTER_DRIVER_SV29
