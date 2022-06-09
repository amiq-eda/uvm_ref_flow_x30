/*******************************************************************************
  FILE : apb_master_driver17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV17
`define APB_MASTER_DRIVER_SV17

//------------------------------------------------------------------------------
// CLASS17: apb_master_driver17 declaration17
//------------------------------------------------------------------------------

class apb_master_driver17 extends uvm_driver #(apb_transfer17);

  // The virtual interface used to drive17 and view17 HDL signals17.
  virtual apb_if17 vif17;
  
  // A pointer17 to the configuration unit17 of the agent17
  apb_config17 cfg;
  
  // Provide17 implementations17 of virtual methods17 such17 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver17)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor17 which calls super.new() with appropriate17 parameters17.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive17();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer17 (apb_transfer17 trans17);
  extern virtual protected task drive_address_phase17 (apb_transfer17 trans17);
  extern virtual protected task drive_data_phase17 (apb_transfer17 trans17);

endclass : apb_master_driver17

// UVM build_phase
function void apb_master_driver17::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config17)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG17", "apb_config17 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets17 the vif17 as a config property
function void apb_master_driver17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if17)::get(this, "", "vif17", vif17))
    `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

// Declaration17 of the UVM run_phase method.
task apb_master_driver17::run_phase(uvm_phase phase);
  get_and_drive17();
endtask : run_phase

// This17 task manages17 the interaction17 between the sequencer and driver
task apb_master_driver17::get_and_drive17();
  while (1) begin
    reset();
    fork 
      @(negedge vif17.preset17)
        // APB_MASTER_DRIVER17 tag17 required17 for Debug17 Labs17
        `uvm_info("APB_MASTER_DRIVER17", "get_and_drive17: Reset17 dropped", UVM_MEDIUM)
      begin
        // This17 thread17 will be killed at reset
        forever begin
          @(posedge vif17.pclock17 iff (vif17.preset17))
          seq_item_port.get_next_item(req);
          drive_transfer17(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If17 we17 are in the middle17 of a transfer17, need to end the tx17. Also17,
      //do any reset cleanup17 here17. The only way17 we17 got17 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive17

// Drive17 all signals17 to reset state 
task apb_master_driver17::reset();
  // If17 the reset is not active, then17 wait for it to become17 active before
  // resetting17 the interface.
  wait(!vif17.preset17);
  // APB_MASTER_DRIVER17 tag17 required17 for Debug17 Labs17
  `uvm_info("APB_MASTER_DRIVER17", $psprintf("Reset17 observed17"), UVM_MEDIUM)
  vif17.paddr17     <= 'h0;
  vif17.pwdata17    <= 'h0;
  vif17.prwd17      <= 'b0;
  vif17.psel17      <= 'b0;
  vif17.penable17   <= 'b0;
endtask : reset

// Drives17 a transfer17 when an item is ready to be sent17.
task apb_master_driver17::drive_transfer17 (apb_transfer17 trans17);
  void'(this.begin_tr(trans17, "apb17 master17 driver", "UVM Debug17",
       "APB17 master17 driver transaction from get_and_drive17"));
  if (trans17.transmit_delay17 > 0) begin
    repeat(trans17.transmit_delay17) @(posedge vif17.pclock17);
  end
  drive_address_phase17(trans17);
  drive_data_phase17(trans17);
  // APB_MASTER_DRIVER_TR17 tag17 required17 for Debug17 Labs17
  `uvm_info("APB_MASTER_DRIVER_TR17", $psprintf("APB17 Finished Driving17 Transfer17 \n%s",
            trans17.sprint()), UVM_HIGH)
  this.end_tr(trans17);
endtask : drive_transfer17

// Drive17 the address phase of the transfer17
task apb_master_driver17::drive_address_phase17 (apb_transfer17 trans17);
  int slave_indx17;
  slave_indx17 = cfg.get_slave_psel_by_addr17(trans17.addr);
  vif17.paddr17 <= trans17.addr;
  vif17.psel17 <= (1<<slave_indx17);
  vif17.penable17 <= 0;
  if (trans17.direction17 == APB_READ17) begin
    vif17.prwd17 <= 1'b0;
  end    
  else begin
    vif17.prwd17 <= 1'b1;
    vif17.pwdata17 <= trans17.data;
  end
  @(posedge vif17.pclock17);
endtask : drive_address_phase17

// Drive17 the data phase of the transfer17
task apb_master_driver17::drive_data_phase17 (apb_transfer17 trans17);
  vif17.penable17 <= 1;
  @(posedge vif17.pclock17 iff vif17.pready17); 
  if (trans17.direction17 == APB_READ17) begin
    trans17.data = vif17.prdata17;
  end
  vif17.penable17 <= 0;
  vif17.psel17    <= 0;
endtask : drive_data_phase17

`endif // APB_MASTER_DRIVER_SV17
