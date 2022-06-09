/*******************************************************************************
  FILE : apb_master_driver4.sv
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV4
`define APB_MASTER_DRIVER_SV4

//------------------------------------------------------------------------------
// CLASS4: apb_master_driver4 declaration4
//------------------------------------------------------------------------------

class apb_master_driver4 extends uvm_driver #(apb_transfer4);

  // The virtual interface used to drive4 and view4 HDL signals4.
  virtual apb_if4 vif4;
  
  // A pointer4 to the configuration unit4 of the agent4
  apb_config4 cfg;
  
  // Provide4 implementations4 of virtual methods4 such4 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver4)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor4 which calls super.new() with appropriate4 parameters4.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive4();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer4 (apb_transfer4 trans4);
  extern virtual protected task drive_address_phase4 (apb_transfer4 trans4);
  extern virtual protected task drive_data_phase4 (apb_transfer4 trans4);

endclass : apb_master_driver4

// UVM build_phase
function void apb_master_driver4::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config4)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG4", "apb_config4 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets4 the vif4 as a config property
function void apb_master_driver4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if4)::get(this, "", "vif4", vif4))
    `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

// Declaration4 of the UVM run_phase method.
task apb_master_driver4::run_phase(uvm_phase phase);
  get_and_drive4();
endtask : run_phase

// This4 task manages4 the interaction4 between the sequencer and driver
task apb_master_driver4::get_and_drive4();
  while (1) begin
    reset();
    fork 
      @(negedge vif4.preset4)
        // APB_MASTER_DRIVER4 tag4 required4 for Debug4 Labs4
        `uvm_info("APB_MASTER_DRIVER4", "get_and_drive4: Reset4 dropped", UVM_MEDIUM)
      begin
        // This4 thread4 will be killed at reset
        forever begin
          @(posedge vif4.pclock4 iff (vif4.preset4))
          seq_item_port.get_next_item(req);
          drive_transfer4(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If4 we4 are in the middle4 of a transfer4, need to end the tx4. Also4,
      //do any reset cleanup4 here4. The only way4 we4 got4 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive4

// Drive4 all signals4 to reset state 
task apb_master_driver4::reset();
  // If4 the reset is not active, then4 wait for it to become4 active before
  // resetting4 the interface.
  wait(!vif4.preset4);
  // APB_MASTER_DRIVER4 tag4 required4 for Debug4 Labs4
  `uvm_info("APB_MASTER_DRIVER4", $psprintf("Reset4 observed4"), UVM_MEDIUM)
  vif4.paddr4     <= 'h0;
  vif4.pwdata4    <= 'h0;
  vif4.prwd4      <= 'b0;
  vif4.psel4      <= 'b0;
  vif4.penable4   <= 'b0;
endtask : reset

// Drives4 a transfer4 when an item is ready to be sent4.
task apb_master_driver4::drive_transfer4 (apb_transfer4 trans4);
  void'(this.begin_tr(trans4, "apb4 master4 driver", "UVM Debug4",
       "APB4 master4 driver transaction from get_and_drive4"));
  if (trans4.transmit_delay4 > 0) begin
    repeat(trans4.transmit_delay4) @(posedge vif4.pclock4);
  end
  drive_address_phase4(trans4);
  drive_data_phase4(trans4);
  // APB_MASTER_DRIVER_TR4 tag4 required4 for Debug4 Labs4
  `uvm_info("APB_MASTER_DRIVER_TR4", $psprintf("APB4 Finished Driving4 Transfer4 \n%s",
            trans4.sprint()), UVM_HIGH)
  this.end_tr(trans4);
endtask : drive_transfer4

// Drive4 the address phase of the transfer4
task apb_master_driver4::drive_address_phase4 (apb_transfer4 trans4);
  int slave_indx4;
  slave_indx4 = cfg.get_slave_psel_by_addr4(trans4.addr);
  vif4.paddr4 <= trans4.addr;
  vif4.psel4 <= (1<<slave_indx4);
  vif4.penable4 <= 0;
  if (trans4.direction4 == APB_READ4) begin
    vif4.prwd4 <= 1'b0;
  end    
  else begin
    vif4.prwd4 <= 1'b1;
    vif4.pwdata4 <= trans4.data;
  end
  @(posedge vif4.pclock4);
endtask : drive_address_phase4

// Drive4 the data phase of the transfer4
task apb_master_driver4::drive_data_phase4 (apb_transfer4 trans4);
  vif4.penable4 <= 1;
  @(posedge vif4.pclock4 iff vif4.pready4); 
  if (trans4.direction4 == APB_READ4) begin
    trans4.data = vif4.prdata4;
  end
  vif4.penable4 <= 0;
  vif4.psel4    <= 0;
endtask : drive_data_phase4

`endif // APB_MASTER_DRIVER_SV4
