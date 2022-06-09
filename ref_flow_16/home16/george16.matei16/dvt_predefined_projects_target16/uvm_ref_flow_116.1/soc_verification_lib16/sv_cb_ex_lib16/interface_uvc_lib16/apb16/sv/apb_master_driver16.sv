/*******************************************************************************
  FILE : apb_master_driver16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV16
`define APB_MASTER_DRIVER_SV16

//------------------------------------------------------------------------------
// CLASS16: apb_master_driver16 declaration16
//------------------------------------------------------------------------------

class apb_master_driver16 extends uvm_driver #(apb_transfer16);

  // The virtual interface used to drive16 and view16 HDL signals16.
  virtual apb_if16 vif16;
  
  // A pointer16 to the configuration unit16 of the agent16
  apb_config16 cfg;
  
  // Provide16 implementations16 of virtual methods16 such16 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver16)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor16 which calls super.new() with appropriate16 parameters16.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive16();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer16 (apb_transfer16 trans16);
  extern virtual protected task drive_address_phase16 (apb_transfer16 trans16);
  extern virtual protected task drive_data_phase16 (apb_transfer16 trans16);

endclass : apb_master_driver16

// UVM build_phase
function void apb_master_driver16::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config16)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG16", "apb_config16 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets16 the vif16 as a config property
function void apb_master_driver16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if16)::get(this, "", "vif16", vif16))
    `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

// Declaration16 of the UVM run_phase method.
task apb_master_driver16::run_phase(uvm_phase phase);
  get_and_drive16();
endtask : run_phase

// This16 task manages16 the interaction16 between the sequencer and driver
task apb_master_driver16::get_and_drive16();
  while (1) begin
    reset();
    fork 
      @(negedge vif16.preset16)
        // APB_MASTER_DRIVER16 tag16 required16 for Debug16 Labs16
        `uvm_info("APB_MASTER_DRIVER16", "get_and_drive16: Reset16 dropped", UVM_MEDIUM)
      begin
        // This16 thread16 will be killed at reset
        forever begin
          @(posedge vif16.pclock16 iff (vif16.preset16))
          seq_item_port.get_next_item(req);
          drive_transfer16(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If16 we16 are in the middle16 of a transfer16, need to end the tx16. Also16,
      //do any reset cleanup16 here16. The only way16 we16 got16 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive16

// Drive16 all signals16 to reset state 
task apb_master_driver16::reset();
  // If16 the reset is not active, then16 wait for it to become16 active before
  // resetting16 the interface.
  wait(!vif16.preset16);
  // APB_MASTER_DRIVER16 tag16 required16 for Debug16 Labs16
  `uvm_info("APB_MASTER_DRIVER16", $psprintf("Reset16 observed16"), UVM_MEDIUM)
  vif16.paddr16     <= 'h0;
  vif16.pwdata16    <= 'h0;
  vif16.prwd16      <= 'b0;
  vif16.psel16      <= 'b0;
  vif16.penable16   <= 'b0;
endtask : reset

// Drives16 a transfer16 when an item is ready to be sent16.
task apb_master_driver16::drive_transfer16 (apb_transfer16 trans16);
  void'(this.begin_tr(trans16, "apb16 master16 driver", "UVM Debug16",
       "APB16 master16 driver transaction from get_and_drive16"));
  if (trans16.transmit_delay16 > 0) begin
    repeat(trans16.transmit_delay16) @(posedge vif16.pclock16);
  end
  drive_address_phase16(trans16);
  drive_data_phase16(trans16);
  // APB_MASTER_DRIVER_TR16 tag16 required16 for Debug16 Labs16
  `uvm_info("APB_MASTER_DRIVER_TR16", $psprintf("APB16 Finished Driving16 Transfer16 \n%s",
            trans16.sprint()), UVM_HIGH)
  this.end_tr(trans16);
endtask : drive_transfer16

// Drive16 the address phase of the transfer16
task apb_master_driver16::drive_address_phase16 (apb_transfer16 trans16);
  int slave_indx16;
  slave_indx16 = cfg.get_slave_psel_by_addr16(trans16.addr);
  vif16.paddr16 <= trans16.addr;
  vif16.psel16 <= (1<<slave_indx16);
  vif16.penable16 <= 0;
  if (trans16.direction16 == APB_READ16) begin
    vif16.prwd16 <= 1'b0;
  end    
  else begin
    vif16.prwd16 <= 1'b1;
    vif16.pwdata16 <= trans16.data;
  end
  @(posedge vif16.pclock16);
endtask : drive_address_phase16

// Drive16 the data phase of the transfer16
task apb_master_driver16::drive_data_phase16 (apb_transfer16 trans16);
  vif16.penable16 <= 1;
  @(posedge vif16.pclock16 iff vif16.pready16); 
  if (trans16.direction16 == APB_READ16) begin
    trans16.data = vif16.prdata16;
  end
  vif16.penable16 <= 0;
  vif16.psel16    <= 0;
endtask : drive_data_phase16

`endif // APB_MASTER_DRIVER_SV16
