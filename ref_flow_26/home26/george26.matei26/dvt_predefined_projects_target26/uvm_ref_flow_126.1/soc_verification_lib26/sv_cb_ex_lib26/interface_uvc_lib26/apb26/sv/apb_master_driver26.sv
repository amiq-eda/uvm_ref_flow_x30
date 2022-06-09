/*******************************************************************************
  FILE : apb_master_driver26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV26
`define APB_MASTER_DRIVER_SV26

//------------------------------------------------------------------------------
// CLASS26: apb_master_driver26 declaration26
//------------------------------------------------------------------------------

class apb_master_driver26 extends uvm_driver #(apb_transfer26);

  // The virtual interface used to drive26 and view26 HDL signals26.
  virtual apb_if26 vif26;
  
  // A pointer26 to the configuration unit26 of the agent26
  apb_config26 cfg;
  
  // Provide26 implementations26 of virtual methods26 such26 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver26)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor26 which calls super.new() with appropriate26 parameters26.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive26();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer26 (apb_transfer26 trans26);
  extern virtual protected task drive_address_phase26 (apb_transfer26 trans26);
  extern virtual protected task drive_data_phase26 (apb_transfer26 trans26);

endclass : apb_master_driver26

// UVM build_phase
function void apb_master_driver26::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config26)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG26", "apb_config26 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets26 the vif26 as a config property
function void apb_master_driver26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if26)::get(this, "", "vif26", vif26))
    `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

// Declaration26 of the UVM run_phase method.
task apb_master_driver26::run_phase(uvm_phase phase);
  get_and_drive26();
endtask : run_phase

// This26 task manages26 the interaction26 between the sequencer and driver
task apb_master_driver26::get_and_drive26();
  while (1) begin
    reset();
    fork 
      @(negedge vif26.preset26)
        // APB_MASTER_DRIVER26 tag26 required26 for Debug26 Labs26
        `uvm_info("APB_MASTER_DRIVER26", "get_and_drive26: Reset26 dropped", UVM_MEDIUM)
      begin
        // This26 thread26 will be killed at reset
        forever begin
          @(posedge vif26.pclock26 iff (vif26.preset26))
          seq_item_port.get_next_item(req);
          drive_transfer26(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If26 we26 are in the middle26 of a transfer26, need to end the tx26. Also26,
      //do any reset cleanup26 here26. The only way26 we26 got26 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive26

// Drive26 all signals26 to reset state 
task apb_master_driver26::reset();
  // If26 the reset is not active, then26 wait for it to become26 active before
  // resetting26 the interface.
  wait(!vif26.preset26);
  // APB_MASTER_DRIVER26 tag26 required26 for Debug26 Labs26
  `uvm_info("APB_MASTER_DRIVER26", $psprintf("Reset26 observed26"), UVM_MEDIUM)
  vif26.paddr26     <= 'h0;
  vif26.pwdata26    <= 'h0;
  vif26.prwd26      <= 'b0;
  vif26.psel26      <= 'b0;
  vif26.penable26   <= 'b0;
endtask : reset

// Drives26 a transfer26 when an item is ready to be sent26.
task apb_master_driver26::drive_transfer26 (apb_transfer26 trans26);
  void'(this.begin_tr(trans26, "apb26 master26 driver", "UVM Debug26",
       "APB26 master26 driver transaction from get_and_drive26"));
  if (trans26.transmit_delay26 > 0) begin
    repeat(trans26.transmit_delay26) @(posedge vif26.pclock26);
  end
  drive_address_phase26(trans26);
  drive_data_phase26(trans26);
  // APB_MASTER_DRIVER_TR26 tag26 required26 for Debug26 Labs26
  `uvm_info("APB_MASTER_DRIVER_TR26", $psprintf("APB26 Finished Driving26 Transfer26 \n%s",
            trans26.sprint()), UVM_HIGH)
  this.end_tr(trans26);
endtask : drive_transfer26

// Drive26 the address phase of the transfer26
task apb_master_driver26::drive_address_phase26 (apb_transfer26 trans26);
  int slave_indx26;
  slave_indx26 = cfg.get_slave_psel_by_addr26(trans26.addr);
  vif26.paddr26 <= trans26.addr;
  vif26.psel26 <= (1<<slave_indx26);
  vif26.penable26 <= 0;
  if (trans26.direction26 == APB_READ26) begin
    vif26.prwd26 <= 1'b0;
  end    
  else begin
    vif26.prwd26 <= 1'b1;
    vif26.pwdata26 <= trans26.data;
  end
  @(posedge vif26.pclock26);
endtask : drive_address_phase26

// Drive26 the data phase of the transfer26
task apb_master_driver26::drive_data_phase26 (apb_transfer26 trans26);
  vif26.penable26 <= 1;
  @(posedge vif26.pclock26 iff vif26.pready26); 
  if (trans26.direction26 == APB_READ26) begin
    trans26.data = vif26.prdata26;
  end
  vif26.penable26 <= 0;
  vif26.psel26    <= 0;
endtask : drive_data_phase26

`endif // APB_MASTER_DRIVER_SV26
