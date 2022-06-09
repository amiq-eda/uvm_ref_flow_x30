/*******************************************************************************
  FILE : apb_master_driver23.sv
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV23
`define APB_MASTER_DRIVER_SV23

//------------------------------------------------------------------------------
// CLASS23: apb_master_driver23 declaration23
//------------------------------------------------------------------------------

class apb_master_driver23 extends uvm_driver #(apb_transfer23);

  // The virtual interface used to drive23 and view23 HDL signals23.
  virtual apb_if23 vif23;
  
  // A pointer23 to the configuration unit23 of the agent23
  apb_config23 cfg;
  
  // Provide23 implementations23 of virtual methods23 such23 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver23)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor23 which calls super.new() with appropriate23 parameters23.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive23();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer23 (apb_transfer23 trans23);
  extern virtual protected task drive_address_phase23 (apb_transfer23 trans23);
  extern virtual protected task drive_data_phase23 (apb_transfer23 trans23);

endclass : apb_master_driver23

// UVM build_phase
function void apb_master_driver23::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config23)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG23", "apb_config23 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets23 the vif23 as a config property
function void apb_master_driver23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if23)::get(this, "", "vif23", vif23))
    `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

// Declaration23 of the UVM run_phase method.
task apb_master_driver23::run_phase(uvm_phase phase);
  get_and_drive23();
endtask : run_phase

// This23 task manages23 the interaction23 between the sequencer and driver
task apb_master_driver23::get_and_drive23();
  while (1) begin
    reset();
    fork 
      @(negedge vif23.preset23)
        // APB_MASTER_DRIVER23 tag23 required23 for Debug23 Labs23
        `uvm_info("APB_MASTER_DRIVER23", "get_and_drive23: Reset23 dropped", UVM_MEDIUM)
      begin
        // This23 thread23 will be killed at reset
        forever begin
          @(posedge vif23.pclock23 iff (vif23.preset23))
          seq_item_port.get_next_item(req);
          drive_transfer23(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If23 we23 are in the middle23 of a transfer23, need to end the tx23. Also23,
      //do any reset cleanup23 here23. The only way23 we23 got23 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive23

// Drive23 all signals23 to reset state 
task apb_master_driver23::reset();
  // If23 the reset is not active, then23 wait for it to become23 active before
  // resetting23 the interface.
  wait(!vif23.preset23);
  // APB_MASTER_DRIVER23 tag23 required23 for Debug23 Labs23
  `uvm_info("APB_MASTER_DRIVER23", $psprintf("Reset23 observed23"), UVM_MEDIUM)
  vif23.paddr23     <= 'h0;
  vif23.pwdata23    <= 'h0;
  vif23.prwd23      <= 'b0;
  vif23.psel23      <= 'b0;
  vif23.penable23   <= 'b0;
endtask : reset

// Drives23 a transfer23 when an item is ready to be sent23.
task apb_master_driver23::drive_transfer23 (apb_transfer23 trans23);
  void'(this.begin_tr(trans23, "apb23 master23 driver", "UVM Debug23",
       "APB23 master23 driver transaction from get_and_drive23"));
  if (trans23.transmit_delay23 > 0) begin
    repeat(trans23.transmit_delay23) @(posedge vif23.pclock23);
  end
  drive_address_phase23(trans23);
  drive_data_phase23(trans23);
  // APB_MASTER_DRIVER_TR23 tag23 required23 for Debug23 Labs23
  `uvm_info("APB_MASTER_DRIVER_TR23", $psprintf("APB23 Finished Driving23 Transfer23 \n%s",
            trans23.sprint()), UVM_HIGH)
  this.end_tr(trans23);
endtask : drive_transfer23

// Drive23 the address phase of the transfer23
task apb_master_driver23::drive_address_phase23 (apb_transfer23 trans23);
  int slave_indx23;
  slave_indx23 = cfg.get_slave_psel_by_addr23(trans23.addr);
  vif23.paddr23 <= trans23.addr;
  vif23.psel23 <= (1<<slave_indx23);
  vif23.penable23 <= 0;
  if (trans23.direction23 == APB_READ23) begin
    vif23.prwd23 <= 1'b0;
  end    
  else begin
    vif23.prwd23 <= 1'b1;
    vif23.pwdata23 <= trans23.data;
  end
  @(posedge vif23.pclock23);
endtask : drive_address_phase23

// Drive23 the data phase of the transfer23
task apb_master_driver23::drive_data_phase23 (apb_transfer23 trans23);
  vif23.penable23 <= 1;
  @(posedge vif23.pclock23 iff vif23.pready23); 
  if (trans23.direction23 == APB_READ23) begin
    trans23.data = vif23.prdata23;
  end
  vif23.penable23 <= 0;
  vif23.psel23    <= 0;
endtask : drive_data_phase23

`endif // APB_MASTER_DRIVER_SV23
