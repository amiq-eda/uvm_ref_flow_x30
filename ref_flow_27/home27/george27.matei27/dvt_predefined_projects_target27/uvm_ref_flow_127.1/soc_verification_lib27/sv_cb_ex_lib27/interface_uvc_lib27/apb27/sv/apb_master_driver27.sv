/*******************************************************************************
  FILE : apb_master_driver27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV27
`define APB_MASTER_DRIVER_SV27

//------------------------------------------------------------------------------
// CLASS27: apb_master_driver27 declaration27
//------------------------------------------------------------------------------

class apb_master_driver27 extends uvm_driver #(apb_transfer27);

  // The virtual interface used to drive27 and view27 HDL signals27.
  virtual apb_if27 vif27;
  
  // A pointer27 to the configuration unit27 of the agent27
  apb_config27 cfg;
  
  // Provide27 implementations27 of virtual methods27 such27 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver27)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor27 which calls super.new() with appropriate27 parameters27.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive27();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer27 (apb_transfer27 trans27);
  extern virtual protected task drive_address_phase27 (apb_transfer27 trans27);
  extern virtual protected task drive_data_phase27 (apb_transfer27 trans27);

endclass : apb_master_driver27

// UVM build_phase
function void apb_master_driver27::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config27)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG27", "apb_config27 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets27 the vif27 as a config property
function void apb_master_driver27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if27)::get(this, "", "vif27", vif27))
    `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

// Declaration27 of the UVM run_phase method.
task apb_master_driver27::run_phase(uvm_phase phase);
  get_and_drive27();
endtask : run_phase

// This27 task manages27 the interaction27 between the sequencer and driver
task apb_master_driver27::get_and_drive27();
  while (1) begin
    reset();
    fork 
      @(negedge vif27.preset27)
        // APB_MASTER_DRIVER27 tag27 required27 for Debug27 Labs27
        `uvm_info("APB_MASTER_DRIVER27", "get_and_drive27: Reset27 dropped", UVM_MEDIUM)
      begin
        // This27 thread27 will be killed at reset
        forever begin
          @(posedge vif27.pclock27 iff (vif27.preset27))
          seq_item_port.get_next_item(req);
          drive_transfer27(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If27 we27 are in the middle27 of a transfer27, need to end the tx27. Also27,
      //do any reset cleanup27 here27. The only way27 we27 got27 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive27

// Drive27 all signals27 to reset state 
task apb_master_driver27::reset();
  // If27 the reset is not active, then27 wait for it to become27 active before
  // resetting27 the interface.
  wait(!vif27.preset27);
  // APB_MASTER_DRIVER27 tag27 required27 for Debug27 Labs27
  `uvm_info("APB_MASTER_DRIVER27", $psprintf("Reset27 observed27"), UVM_MEDIUM)
  vif27.paddr27     <= 'h0;
  vif27.pwdata27    <= 'h0;
  vif27.prwd27      <= 'b0;
  vif27.psel27      <= 'b0;
  vif27.penable27   <= 'b0;
endtask : reset

// Drives27 a transfer27 when an item is ready to be sent27.
task apb_master_driver27::drive_transfer27 (apb_transfer27 trans27);
  void'(this.begin_tr(trans27, "apb27 master27 driver", "UVM Debug27",
       "APB27 master27 driver transaction from get_and_drive27"));
  if (trans27.transmit_delay27 > 0) begin
    repeat(trans27.transmit_delay27) @(posedge vif27.pclock27);
  end
  drive_address_phase27(trans27);
  drive_data_phase27(trans27);
  // APB_MASTER_DRIVER_TR27 tag27 required27 for Debug27 Labs27
  `uvm_info("APB_MASTER_DRIVER_TR27", $psprintf("APB27 Finished Driving27 Transfer27 \n%s",
            trans27.sprint()), UVM_HIGH)
  this.end_tr(trans27);
endtask : drive_transfer27

// Drive27 the address phase of the transfer27
task apb_master_driver27::drive_address_phase27 (apb_transfer27 trans27);
  int slave_indx27;
  slave_indx27 = cfg.get_slave_psel_by_addr27(trans27.addr);
  vif27.paddr27 <= trans27.addr;
  vif27.psel27 <= (1<<slave_indx27);
  vif27.penable27 <= 0;
  if (trans27.direction27 == APB_READ27) begin
    vif27.prwd27 <= 1'b0;
  end    
  else begin
    vif27.prwd27 <= 1'b1;
    vif27.pwdata27 <= trans27.data;
  end
  @(posedge vif27.pclock27);
endtask : drive_address_phase27

// Drive27 the data phase of the transfer27
task apb_master_driver27::drive_data_phase27 (apb_transfer27 trans27);
  vif27.penable27 <= 1;
  @(posedge vif27.pclock27 iff vif27.pready27); 
  if (trans27.direction27 == APB_READ27) begin
    trans27.data = vif27.prdata27;
  end
  vif27.penable27 <= 0;
  vif27.psel27    <= 0;
endtask : drive_data_phase27

`endif // APB_MASTER_DRIVER_SV27
