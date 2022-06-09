/*******************************************************************************
  FILE : apb_master_driver24.sv
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV24
`define APB_MASTER_DRIVER_SV24

//------------------------------------------------------------------------------
// CLASS24: apb_master_driver24 declaration24
//------------------------------------------------------------------------------

class apb_master_driver24 extends uvm_driver #(apb_transfer24);

  // The virtual interface used to drive24 and view24 HDL signals24.
  virtual apb_if24 vif24;
  
  // A pointer24 to the configuration unit24 of the agent24
  apb_config24 cfg;
  
  // Provide24 implementations24 of virtual methods24 such24 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver24)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor24 which calls super.new() with appropriate24 parameters24.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive24();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer24 (apb_transfer24 trans24);
  extern virtual protected task drive_address_phase24 (apb_transfer24 trans24);
  extern virtual protected task drive_data_phase24 (apb_transfer24 trans24);

endclass : apb_master_driver24

// UVM build_phase
function void apb_master_driver24::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config24)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG24", "apb_config24 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets24 the vif24 as a config property
function void apb_master_driver24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if24)::get(this, "", "vif24", vif24))
    `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

// Declaration24 of the UVM run_phase method.
task apb_master_driver24::run_phase(uvm_phase phase);
  get_and_drive24();
endtask : run_phase

// This24 task manages24 the interaction24 between the sequencer and driver
task apb_master_driver24::get_and_drive24();
  while (1) begin
    reset();
    fork 
      @(negedge vif24.preset24)
        // APB_MASTER_DRIVER24 tag24 required24 for Debug24 Labs24
        `uvm_info("APB_MASTER_DRIVER24", "get_and_drive24: Reset24 dropped", UVM_MEDIUM)
      begin
        // This24 thread24 will be killed at reset
        forever begin
          @(posedge vif24.pclock24 iff (vif24.preset24))
          seq_item_port.get_next_item(req);
          drive_transfer24(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If24 we24 are in the middle24 of a transfer24, need to end the tx24. Also24,
      //do any reset cleanup24 here24. The only way24 we24 got24 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive24

// Drive24 all signals24 to reset state 
task apb_master_driver24::reset();
  // If24 the reset is not active, then24 wait for it to become24 active before
  // resetting24 the interface.
  wait(!vif24.preset24);
  // APB_MASTER_DRIVER24 tag24 required24 for Debug24 Labs24
  `uvm_info("APB_MASTER_DRIVER24", $psprintf("Reset24 observed24"), UVM_MEDIUM)
  vif24.paddr24     <= 'h0;
  vif24.pwdata24    <= 'h0;
  vif24.prwd24      <= 'b0;
  vif24.psel24      <= 'b0;
  vif24.penable24   <= 'b0;
endtask : reset

// Drives24 a transfer24 when an item is ready to be sent24.
task apb_master_driver24::drive_transfer24 (apb_transfer24 trans24);
  void'(this.begin_tr(trans24, "apb24 master24 driver", "UVM Debug24",
       "APB24 master24 driver transaction from get_and_drive24"));
  if (trans24.transmit_delay24 > 0) begin
    repeat(trans24.transmit_delay24) @(posedge vif24.pclock24);
  end
  drive_address_phase24(trans24);
  drive_data_phase24(trans24);
  // APB_MASTER_DRIVER_TR24 tag24 required24 for Debug24 Labs24
  `uvm_info("APB_MASTER_DRIVER_TR24", $psprintf("APB24 Finished Driving24 Transfer24 \n%s",
            trans24.sprint()), UVM_HIGH)
  this.end_tr(trans24);
endtask : drive_transfer24

// Drive24 the address phase of the transfer24
task apb_master_driver24::drive_address_phase24 (apb_transfer24 trans24);
  int slave_indx24;
  slave_indx24 = cfg.get_slave_psel_by_addr24(trans24.addr);
  vif24.paddr24 <= trans24.addr;
  vif24.psel24 <= (1<<slave_indx24);
  vif24.penable24 <= 0;
  if (trans24.direction24 == APB_READ24) begin
    vif24.prwd24 <= 1'b0;
  end    
  else begin
    vif24.prwd24 <= 1'b1;
    vif24.pwdata24 <= trans24.data;
  end
  @(posedge vif24.pclock24);
endtask : drive_address_phase24

// Drive24 the data phase of the transfer24
task apb_master_driver24::drive_data_phase24 (apb_transfer24 trans24);
  vif24.penable24 <= 1;
  @(posedge vif24.pclock24 iff vif24.pready24); 
  if (trans24.direction24 == APB_READ24) begin
    trans24.data = vif24.prdata24;
  end
  vif24.penable24 <= 0;
  vif24.psel24    <= 0;
endtask : drive_data_phase24

`endif // APB_MASTER_DRIVER_SV24
