/*******************************************************************************
  FILE : apb_master_driver22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV22
`define APB_MASTER_DRIVER_SV22

//------------------------------------------------------------------------------
// CLASS22: apb_master_driver22 declaration22
//------------------------------------------------------------------------------

class apb_master_driver22 extends uvm_driver #(apb_transfer22);

  // The virtual interface used to drive22 and view22 HDL signals22.
  virtual apb_if22 vif22;
  
  // A pointer22 to the configuration unit22 of the agent22
  apb_config22 cfg;
  
  // Provide22 implementations22 of virtual methods22 such22 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver22)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor22 which calls super.new() with appropriate22 parameters22.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive22();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer22 (apb_transfer22 trans22);
  extern virtual protected task drive_address_phase22 (apb_transfer22 trans22);
  extern virtual protected task drive_data_phase22 (apb_transfer22 trans22);

endclass : apb_master_driver22

// UVM build_phase
function void apb_master_driver22::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config22)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG22", "apb_config22 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets22 the vif22 as a config property
function void apb_master_driver22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if22)::get(this, "", "vif22", vif22))
    `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

// Declaration22 of the UVM run_phase method.
task apb_master_driver22::run_phase(uvm_phase phase);
  get_and_drive22();
endtask : run_phase

// This22 task manages22 the interaction22 between the sequencer and driver
task apb_master_driver22::get_and_drive22();
  while (1) begin
    reset();
    fork 
      @(negedge vif22.preset22)
        // APB_MASTER_DRIVER22 tag22 required22 for Debug22 Labs22
        `uvm_info("APB_MASTER_DRIVER22", "get_and_drive22: Reset22 dropped", UVM_MEDIUM)
      begin
        // This22 thread22 will be killed at reset
        forever begin
          @(posedge vif22.pclock22 iff (vif22.preset22))
          seq_item_port.get_next_item(req);
          drive_transfer22(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If22 we22 are in the middle22 of a transfer22, need to end the tx22. Also22,
      //do any reset cleanup22 here22. The only way22 we22 got22 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive22

// Drive22 all signals22 to reset state 
task apb_master_driver22::reset();
  // If22 the reset is not active, then22 wait for it to become22 active before
  // resetting22 the interface.
  wait(!vif22.preset22);
  // APB_MASTER_DRIVER22 tag22 required22 for Debug22 Labs22
  `uvm_info("APB_MASTER_DRIVER22", $psprintf("Reset22 observed22"), UVM_MEDIUM)
  vif22.paddr22     <= 'h0;
  vif22.pwdata22    <= 'h0;
  vif22.prwd22      <= 'b0;
  vif22.psel22      <= 'b0;
  vif22.penable22   <= 'b0;
endtask : reset

// Drives22 a transfer22 when an item is ready to be sent22.
task apb_master_driver22::drive_transfer22 (apb_transfer22 trans22);
  void'(this.begin_tr(trans22, "apb22 master22 driver", "UVM Debug22",
       "APB22 master22 driver transaction from get_and_drive22"));
  if (trans22.transmit_delay22 > 0) begin
    repeat(trans22.transmit_delay22) @(posedge vif22.pclock22);
  end
  drive_address_phase22(trans22);
  drive_data_phase22(trans22);
  // APB_MASTER_DRIVER_TR22 tag22 required22 for Debug22 Labs22
  `uvm_info("APB_MASTER_DRIVER_TR22", $psprintf("APB22 Finished Driving22 Transfer22 \n%s",
            trans22.sprint()), UVM_HIGH)
  this.end_tr(trans22);
endtask : drive_transfer22

// Drive22 the address phase of the transfer22
task apb_master_driver22::drive_address_phase22 (apb_transfer22 trans22);
  int slave_indx22;
  slave_indx22 = cfg.get_slave_psel_by_addr22(trans22.addr);
  vif22.paddr22 <= trans22.addr;
  vif22.psel22 <= (1<<slave_indx22);
  vif22.penable22 <= 0;
  if (trans22.direction22 == APB_READ22) begin
    vif22.prwd22 <= 1'b0;
  end    
  else begin
    vif22.prwd22 <= 1'b1;
    vif22.pwdata22 <= trans22.data;
  end
  @(posedge vif22.pclock22);
endtask : drive_address_phase22

// Drive22 the data phase of the transfer22
task apb_master_driver22::drive_data_phase22 (apb_transfer22 trans22);
  vif22.penable22 <= 1;
  @(posedge vif22.pclock22 iff vif22.pready22); 
  if (trans22.direction22 == APB_READ22) begin
    trans22.data = vif22.prdata22;
  end
  vif22.penable22 <= 0;
  vif22.psel22    <= 0;
endtask : drive_data_phase22

`endif // APB_MASTER_DRIVER_SV22
