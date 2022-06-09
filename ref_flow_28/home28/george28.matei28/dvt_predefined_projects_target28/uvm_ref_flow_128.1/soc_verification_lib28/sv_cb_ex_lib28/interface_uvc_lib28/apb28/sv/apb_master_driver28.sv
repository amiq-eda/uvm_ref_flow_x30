/*******************************************************************************
  FILE : apb_master_driver28.sv
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV28
`define APB_MASTER_DRIVER_SV28

//------------------------------------------------------------------------------
// CLASS28: apb_master_driver28 declaration28
//------------------------------------------------------------------------------

class apb_master_driver28 extends uvm_driver #(apb_transfer28);

  // The virtual interface used to drive28 and view28 HDL signals28.
  virtual apb_if28 vif28;
  
  // A pointer28 to the configuration unit28 of the agent28
  apb_config28 cfg;
  
  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver28)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor28 which calls super.new() with appropriate28 parameters28.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive28();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer28 (apb_transfer28 trans28);
  extern virtual protected task drive_address_phase28 (apb_transfer28 trans28);
  extern virtual protected task drive_data_phase28 (apb_transfer28 trans28);

endclass : apb_master_driver28

// UVM build_phase
function void apb_master_driver28::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config28)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG28", "apb_config28 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets28 the vif28 as a config property
function void apb_master_driver28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if28)::get(this, "", "vif28", vif28))
    `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

// Declaration28 of the UVM run_phase method.
task apb_master_driver28::run_phase(uvm_phase phase);
  get_and_drive28();
endtask : run_phase

// This28 task manages28 the interaction28 between the sequencer and driver
task apb_master_driver28::get_and_drive28();
  while (1) begin
    reset();
    fork 
      @(negedge vif28.preset28)
        // APB_MASTER_DRIVER28 tag28 required28 for Debug28 Labs28
        `uvm_info("APB_MASTER_DRIVER28", "get_and_drive28: Reset28 dropped", UVM_MEDIUM)
      begin
        // This28 thread28 will be killed at reset
        forever begin
          @(posedge vif28.pclock28 iff (vif28.preset28))
          seq_item_port.get_next_item(req);
          drive_transfer28(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If28 we28 are in the middle28 of a transfer28, need to end the tx28. Also28,
      //do any reset cleanup28 here28. The only way28 we28 got28 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive28

// Drive28 all signals28 to reset state 
task apb_master_driver28::reset();
  // If28 the reset is not active, then28 wait for it to become28 active before
  // resetting28 the interface.
  wait(!vif28.preset28);
  // APB_MASTER_DRIVER28 tag28 required28 for Debug28 Labs28
  `uvm_info("APB_MASTER_DRIVER28", $psprintf("Reset28 observed28"), UVM_MEDIUM)
  vif28.paddr28     <= 'h0;
  vif28.pwdata28    <= 'h0;
  vif28.prwd28      <= 'b0;
  vif28.psel28      <= 'b0;
  vif28.penable28   <= 'b0;
endtask : reset

// Drives28 a transfer28 when an item is ready to be sent28.
task apb_master_driver28::drive_transfer28 (apb_transfer28 trans28);
  void'(this.begin_tr(trans28, "apb28 master28 driver", "UVM Debug28",
       "APB28 master28 driver transaction from get_and_drive28"));
  if (trans28.transmit_delay28 > 0) begin
    repeat(trans28.transmit_delay28) @(posedge vif28.pclock28);
  end
  drive_address_phase28(trans28);
  drive_data_phase28(trans28);
  // APB_MASTER_DRIVER_TR28 tag28 required28 for Debug28 Labs28
  `uvm_info("APB_MASTER_DRIVER_TR28", $psprintf("APB28 Finished Driving28 Transfer28 \n%s",
            trans28.sprint()), UVM_HIGH)
  this.end_tr(trans28);
endtask : drive_transfer28

// Drive28 the address phase of the transfer28
task apb_master_driver28::drive_address_phase28 (apb_transfer28 trans28);
  int slave_indx28;
  slave_indx28 = cfg.get_slave_psel_by_addr28(trans28.addr);
  vif28.paddr28 <= trans28.addr;
  vif28.psel28 <= (1<<slave_indx28);
  vif28.penable28 <= 0;
  if (trans28.direction28 == APB_READ28) begin
    vif28.prwd28 <= 1'b0;
  end    
  else begin
    vif28.prwd28 <= 1'b1;
    vif28.pwdata28 <= trans28.data;
  end
  @(posedge vif28.pclock28);
endtask : drive_address_phase28

// Drive28 the data phase of the transfer28
task apb_master_driver28::drive_data_phase28 (apb_transfer28 trans28);
  vif28.penable28 <= 1;
  @(posedge vif28.pclock28 iff vif28.pready28); 
  if (trans28.direction28 == APB_READ28) begin
    trans28.data = vif28.prdata28;
  end
  vif28.penable28 <= 0;
  vif28.psel28    <= 0;
endtask : drive_data_phase28

`endif // APB_MASTER_DRIVER_SV28
