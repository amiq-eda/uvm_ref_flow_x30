/*******************************************************************************
  FILE : apb_master_driver15.sv
*******************************************************************************/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV15
`define APB_MASTER_DRIVER_SV15

//------------------------------------------------------------------------------
// CLASS15: apb_master_driver15 declaration15
//------------------------------------------------------------------------------

class apb_master_driver15 extends uvm_driver #(apb_transfer15);

  // The virtual interface used to drive15 and view15 HDL signals15.
  virtual apb_if15 vif15;
  
  // A pointer15 to the configuration unit15 of the agent15
  apb_config15 cfg;
  
  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver15)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor15 which calls super.new() with appropriate15 parameters15.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive15();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer15 (apb_transfer15 trans15);
  extern virtual protected task drive_address_phase15 (apb_transfer15 trans15);
  extern virtual protected task drive_data_phase15 (apb_transfer15 trans15);

endclass : apb_master_driver15

// UVM build_phase
function void apb_master_driver15::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config15)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG15", "apb_config15 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets15 the vif15 as a config property
function void apb_master_driver15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if15)::get(this, "", "vif15", vif15))
    `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

// Declaration15 of the UVM run_phase method.
task apb_master_driver15::run_phase(uvm_phase phase);
  get_and_drive15();
endtask : run_phase

// This15 task manages15 the interaction15 between the sequencer and driver
task apb_master_driver15::get_and_drive15();
  while (1) begin
    reset();
    fork 
      @(negedge vif15.preset15)
        // APB_MASTER_DRIVER15 tag15 required15 for Debug15 Labs15
        `uvm_info("APB_MASTER_DRIVER15", "get_and_drive15: Reset15 dropped", UVM_MEDIUM)
      begin
        // This15 thread15 will be killed at reset
        forever begin
          @(posedge vif15.pclock15 iff (vif15.preset15))
          seq_item_port.get_next_item(req);
          drive_transfer15(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If15 we15 are in the middle15 of a transfer15, need to end the tx15. Also15,
      //do any reset cleanup15 here15. The only way15 we15 got15 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive15

// Drive15 all signals15 to reset state 
task apb_master_driver15::reset();
  // If15 the reset is not active, then15 wait for it to become15 active before
  // resetting15 the interface.
  wait(!vif15.preset15);
  // APB_MASTER_DRIVER15 tag15 required15 for Debug15 Labs15
  `uvm_info("APB_MASTER_DRIVER15", $psprintf("Reset15 observed15"), UVM_MEDIUM)
  vif15.paddr15     <= 'h0;
  vif15.pwdata15    <= 'h0;
  vif15.prwd15      <= 'b0;
  vif15.psel15      <= 'b0;
  vif15.penable15   <= 'b0;
endtask : reset

// Drives15 a transfer15 when an item is ready to be sent15.
task apb_master_driver15::drive_transfer15 (apb_transfer15 trans15);
  void'(this.begin_tr(trans15, "apb15 master15 driver", "UVM Debug15",
       "APB15 master15 driver transaction from get_and_drive15"));
  if (trans15.transmit_delay15 > 0) begin
    repeat(trans15.transmit_delay15) @(posedge vif15.pclock15);
  end
  drive_address_phase15(trans15);
  drive_data_phase15(trans15);
  // APB_MASTER_DRIVER_TR15 tag15 required15 for Debug15 Labs15
  `uvm_info("APB_MASTER_DRIVER_TR15", $psprintf("APB15 Finished Driving15 Transfer15 \n%s",
            trans15.sprint()), UVM_HIGH)
  this.end_tr(trans15);
endtask : drive_transfer15

// Drive15 the address phase of the transfer15
task apb_master_driver15::drive_address_phase15 (apb_transfer15 trans15);
  int slave_indx15;
  slave_indx15 = cfg.get_slave_psel_by_addr15(trans15.addr);
  vif15.paddr15 <= trans15.addr;
  vif15.psel15 <= (1<<slave_indx15);
  vif15.penable15 <= 0;
  if (trans15.direction15 == APB_READ15) begin
    vif15.prwd15 <= 1'b0;
  end    
  else begin
    vif15.prwd15 <= 1'b1;
    vif15.pwdata15 <= trans15.data;
  end
  @(posedge vif15.pclock15);
endtask : drive_address_phase15

// Drive15 the data phase of the transfer15
task apb_master_driver15::drive_data_phase15 (apb_transfer15 trans15);
  vif15.penable15 <= 1;
  @(posedge vif15.pclock15 iff vif15.pready15); 
  if (trans15.direction15 == APB_READ15) begin
    trans15.data = vif15.prdata15;
  end
  vif15.penable15 <= 0;
  vif15.psel15    <= 0;
endtask : drive_data_phase15

`endif // APB_MASTER_DRIVER_SV15
