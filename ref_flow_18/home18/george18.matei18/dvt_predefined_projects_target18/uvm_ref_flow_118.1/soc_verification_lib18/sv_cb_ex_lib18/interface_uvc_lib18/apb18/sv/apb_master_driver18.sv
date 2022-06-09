/*******************************************************************************
  FILE : apb_master_driver18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV18
`define APB_MASTER_DRIVER_SV18

//------------------------------------------------------------------------------
// CLASS18: apb_master_driver18 declaration18
//------------------------------------------------------------------------------

class apb_master_driver18 extends uvm_driver #(apb_transfer18);

  // The virtual interface used to drive18 and view18 HDL signals18.
  virtual apb_if18 vif18;
  
  // A pointer18 to the configuration unit18 of the agent18
  apb_config18 cfg;
  
  // Provide18 implementations18 of virtual methods18 such18 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver18)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor18 which calls super.new() with appropriate18 parameters18.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive18();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer18 (apb_transfer18 trans18);
  extern virtual protected task drive_address_phase18 (apb_transfer18 trans18);
  extern virtual protected task drive_data_phase18 (apb_transfer18 trans18);

endclass : apb_master_driver18

// UVM build_phase
function void apb_master_driver18::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config18)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG18", "apb_config18 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets18 the vif18 as a config property
function void apb_master_driver18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if18)::get(this, "", "vif18", vif18))
    `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

// Declaration18 of the UVM run_phase method.
task apb_master_driver18::run_phase(uvm_phase phase);
  get_and_drive18();
endtask : run_phase

// This18 task manages18 the interaction18 between the sequencer and driver
task apb_master_driver18::get_and_drive18();
  while (1) begin
    reset();
    fork 
      @(negedge vif18.preset18)
        // APB_MASTER_DRIVER18 tag18 required18 for Debug18 Labs18
        `uvm_info("APB_MASTER_DRIVER18", "get_and_drive18: Reset18 dropped", UVM_MEDIUM)
      begin
        // This18 thread18 will be killed at reset
        forever begin
          @(posedge vif18.pclock18 iff (vif18.preset18))
          seq_item_port.get_next_item(req);
          drive_transfer18(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If18 we18 are in the middle18 of a transfer18, need to end the tx18. Also18,
      //do any reset cleanup18 here18. The only way18 we18 got18 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive18

// Drive18 all signals18 to reset state 
task apb_master_driver18::reset();
  // If18 the reset is not active, then18 wait for it to become18 active before
  // resetting18 the interface.
  wait(!vif18.preset18);
  // APB_MASTER_DRIVER18 tag18 required18 for Debug18 Labs18
  `uvm_info("APB_MASTER_DRIVER18", $psprintf("Reset18 observed18"), UVM_MEDIUM)
  vif18.paddr18     <= 'h0;
  vif18.pwdata18    <= 'h0;
  vif18.prwd18      <= 'b0;
  vif18.psel18      <= 'b0;
  vif18.penable18   <= 'b0;
endtask : reset

// Drives18 a transfer18 when an item is ready to be sent18.
task apb_master_driver18::drive_transfer18 (apb_transfer18 trans18);
  void'(this.begin_tr(trans18, "apb18 master18 driver", "UVM Debug18",
       "APB18 master18 driver transaction from get_and_drive18"));
  if (trans18.transmit_delay18 > 0) begin
    repeat(trans18.transmit_delay18) @(posedge vif18.pclock18);
  end
  drive_address_phase18(trans18);
  drive_data_phase18(trans18);
  // APB_MASTER_DRIVER_TR18 tag18 required18 for Debug18 Labs18
  `uvm_info("APB_MASTER_DRIVER_TR18", $psprintf("APB18 Finished Driving18 Transfer18 \n%s",
            trans18.sprint()), UVM_HIGH)
  this.end_tr(trans18);
endtask : drive_transfer18

// Drive18 the address phase of the transfer18
task apb_master_driver18::drive_address_phase18 (apb_transfer18 trans18);
  int slave_indx18;
  slave_indx18 = cfg.get_slave_psel_by_addr18(trans18.addr);
  vif18.paddr18 <= trans18.addr;
  vif18.psel18 <= (1<<slave_indx18);
  vif18.penable18 <= 0;
  if (trans18.direction18 == APB_READ18) begin
    vif18.prwd18 <= 1'b0;
  end    
  else begin
    vif18.prwd18 <= 1'b1;
    vif18.pwdata18 <= trans18.data;
  end
  @(posedge vif18.pclock18);
endtask : drive_address_phase18

// Drive18 the data phase of the transfer18
task apb_master_driver18::drive_data_phase18 (apb_transfer18 trans18);
  vif18.penable18 <= 1;
  @(posedge vif18.pclock18 iff vif18.pready18); 
  if (trans18.direction18 == APB_READ18) begin
    trans18.data = vif18.prdata18;
  end
  vif18.penable18 <= 0;
  vif18.psel18    <= 0;
endtask : drive_data_phase18

`endif // APB_MASTER_DRIVER_SV18
