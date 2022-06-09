/*******************************************************************************
  FILE : apb_master_driver7.sv
*******************************************************************************/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV7
`define APB_MASTER_DRIVER_SV7

//------------------------------------------------------------------------------
// CLASS7: apb_master_driver7 declaration7
//------------------------------------------------------------------------------

class apb_master_driver7 extends uvm_driver #(apb_transfer7);

  // The virtual interface used to drive7 and view7 HDL signals7.
  virtual apb_if7 vif7;
  
  // A pointer7 to the configuration unit7 of the agent7
  apb_config7 cfg;
  
  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver7)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor7 which calls super.new() with appropriate7 parameters7.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive7();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer7 (apb_transfer7 trans7);
  extern virtual protected task drive_address_phase7 (apb_transfer7 trans7);
  extern virtual protected task drive_data_phase7 (apb_transfer7 trans7);

endclass : apb_master_driver7

// UVM build_phase
function void apb_master_driver7::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config7)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG7", "apb_config7 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets7 the vif7 as a config property
function void apb_master_driver7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if7)::get(this, "", "vif7", vif7))
    `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

// Declaration7 of the UVM run_phase method.
task apb_master_driver7::run_phase(uvm_phase phase);
  get_and_drive7();
endtask : run_phase

// This7 task manages7 the interaction7 between the sequencer and driver
task apb_master_driver7::get_and_drive7();
  while (1) begin
    reset();
    fork 
      @(negedge vif7.preset7)
        // APB_MASTER_DRIVER7 tag7 required7 for Debug7 Labs7
        `uvm_info("APB_MASTER_DRIVER7", "get_and_drive7: Reset7 dropped", UVM_MEDIUM)
      begin
        // This7 thread7 will be killed at reset
        forever begin
          @(posedge vif7.pclock7 iff (vif7.preset7))
          seq_item_port.get_next_item(req);
          drive_transfer7(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If7 we7 are in the middle7 of a transfer7, need to end the tx7. Also7,
      //do any reset cleanup7 here7. The only way7 we7 got7 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive7

// Drive7 all signals7 to reset state 
task apb_master_driver7::reset();
  // If7 the reset is not active, then7 wait for it to become7 active before
  // resetting7 the interface.
  wait(!vif7.preset7);
  // APB_MASTER_DRIVER7 tag7 required7 for Debug7 Labs7
  `uvm_info("APB_MASTER_DRIVER7", $psprintf("Reset7 observed7"), UVM_MEDIUM)
  vif7.paddr7     <= 'h0;
  vif7.pwdata7    <= 'h0;
  vif7.prwd7      <= 'b0;
  vif7.psel7      <= 'b0;
  vif7.penable7   <= 'b0;
endtask : reset

// Drives7 a transfer7 when an item is ready to be sent7.
task apb_master_driver7::drive_transfer7 (apb_transfer7 trans7);
  void'(this.begin_tr(trans7, "apb7 master7 driver", "UVM Debug7",
       "APB7 master7 driver transaction from get_and_drive7"));
  if (trans7.transmit_delay7 > 0) begin
    repeat(trans7.transmit_delay7) @(posedge vif7.pclock7);
  end
  drive_address_phase7(trans7);
  drive_data_phase7(trans7);
  // APB_MASTER_DRIVER_TR7 tag7 required7 for Debug7 Labs7
  `uvm_info("APB_MASTER_DRIVER_TR7", $psprintf("APB7 Finished Driving7 Transfer7 \n%s",
            trans7.sprint()), UVM_HIGH)
  this.end_tr(trans7);
endtask : drive_transfer7

// Drive7 the address phase of the transfer7
task apb_master_driver7::drive_address_phase7 (apb_transfer7 trans7);
  int slave_indx7;
  slave_indx7 = cfg.get_slave_psel_by_addr7(trans7.addr);
  vif7.paddr7 <= trans7.addr;
  vif7.psel7 <= (1<<slave_indx7);
  vif7.penable7 <= 0;
  if (trans7.direction7 == APB_READ7) begin
    vif7.prwd7 <= 1'b0;
  end    
  else begin
    vif7.prwd7 <= 1'b1;
    vif7.pwdata7 <= trans7.data;
  end
  @(posedge vif7.pclock7);
endtask : drive_address_phase7

// Drive7 the data phase of the transfer7
task apb_master_driver7::drive_data_phase7 (apb_transfer7 trans7);
  vif7.penable7 <= 1;
  @(posedge vif7.pclock7 iff vif7.pready7); 
  if (trans7.direction7 == APB_READ7) begin
    trans7.data = vif7.prdata7;
  end
  vif7.penable7 <= 0;
  vif7.psel7    <= 0;
endtask : drive_data_phase7

`endif // APB_MASTER_DRIVER_SV7
