/*******************************************************************************
  FILE : apb_master_driver3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV3
`define APB_MASTER_DRIVER_SV3

//------------------------------------------------------------------------------
// CLASS3: apb_master_driver3 declaration3
//------------------------------------------------------------------------------

class apb_master_driver3 extends uvm_driver #(apb_transfer3);

  // The virtual interface used to drive3 and view3 HDL signals3.
  virtual apb_if3 vif3;
  
  // A pointer3 to the configuration unit3 of the agent3
  apb_config3 cfg;
  
  // Provide3 implementations3 of virtual methods3 such3 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver3)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor3 which calls super.new() with appropriate3 parameters3.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive3();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer3 (apb_transfer3 trans3);
  extern virtual protected task drive_address_phase3 (apb_transfer3 trans3);
  extern virtual protected task drive_data_phase3 (apb_transfer3 trans3);

endclass : apb_master_driver3

// UVM build_phase
function void apb_master_driver3::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config3)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG3", "apb_config3 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets3 the vif3 as a config property
function void apb_master_driver3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if3)::get(this, "", "vif3", vif3))
    `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

// Declaration3 of the UVM run_phase method.
task apb_master_driver3::run_phase(uvm_phase phase);
  get_and_drive3();
endtask : run_phase

// This3 task manages3 the interaction3 between the sequencer and driver
task apb_master_driver3::get_and_drive3();
  while (1) begin
    reset();
    fork 
      @(negedge vif3.preset3)
        // APB_MASTER_DRIVER3 tag3 required3 for Debug3 Labs3
        `uvm_info("APB_MASTER_DRIVER3", "get_and_drive3: Reset3 dropped", UVM_MEDIUM)
      begin
        // This3 thread3 will be killed at reset
        forever begin
          @(posedge vif3.pclock3 iff (vif3.preset3))
          seq_item_port.get_next_item(req);
          drive_transfer3(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If3 we3 are in the middle3 of a transfer3, need to end the tx3. Also3,
      //do any reset cleanup3 here3. The only way3 we3 got3 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive3

// Drive3 all signals3 to reset state 
task apb_master_driver3::reset();
  // If3 the reset is not active, then3 wait for it to become3 active before
  // resetting3 the interface.
  wait(!vif3.preset3);
  // APB_MASTER_DRIVER3 tag3 required3 for Debug3 Labs3
  `uvm_info("APB_MASTER_DRIVER3", $psprintf("Reset3 observed3"), UVM_MEDIUM)
  vif3.paddr3     <= 'h0;
  vif3.pwdata3    <= 'h0;
  vif3.prwd3      <= 'b0;
  vif3.psel3      <= 'b0;
  vif3.penable3   <= 'b0;
endtask : reset

// Drives3 a transfer3 when an item is ready to be sent3.
task apb_master_driver3::drive_transfer3 (apb_transfer3 trans3);
  void'(this.begin_tr(trans3, "apb3 master3 driver", "UVM Debug3",
       "APB3 master3 driver transaction from get_and_drive3"));
  if (trans3.transmit_delay3 > 0) begin
    repeat(trans3.transmit_delay3) @(posedge vif3.pclock3);
  end
  drive_address_phase3(trans3);
  drive_data_phase3(trans3);
  // APB_MASTER_DRIVER_TR3 tag3 required3 for Debug3 Labs3
  `uvm_info("APB_MASTER_DRIVER_TR3", $psprintf("APB3 Finished Driving3 Transfer3 \n%s",
            trans3.sprint()), UVM_HIGH)
  this.end_tr(trans3);
endtask : drive_transfer3

// Drive3 the address phase of the transfer3
task apb_master_driver3::drive_address_phase3 (apb_transfer3 trans3);
  int slave_indx3;
  slave_indx3 = cfg.get_slave_psel_by_addr3(trans3.addr);
  vif3.paddr3 <= trans3.addr;
  vif3.psel3 <= (1<<slave_indx3);
  vif3.penable3 <= 0;
  if (trans3.direction3 == APB_READ3) begin
    vif3.prwd3 <= 1'b0;
  end    
  else begin
    vif3.prwd3 <= 1'b1;
    vif3.pwdata3 <= trans3.data;
  end
  @(posedge vif3.pclock3);
endtask : drive_address_phase3

// Drive3 the data phase of the transfer3
task apb_master_driver3::drive_data_phase3 (apb_transfer3 trans3);
  vif3.penable3 <= 1;
  @(posedge vif3.pclock3 iff vif3.pready3); 
  if (trans3.direction3 == APB_READ3) begin
    trans3.data = vif3.prdata3;
  end
  vif3.penable3 <= 0;
  vif3.psel3    <= 0;
endtask : drive_data_phase3

`endif // APB_MASTER_DRIVER_SV3
