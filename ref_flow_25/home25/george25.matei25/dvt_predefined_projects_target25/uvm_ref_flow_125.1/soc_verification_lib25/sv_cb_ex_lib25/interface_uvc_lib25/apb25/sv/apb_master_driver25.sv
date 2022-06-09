/*******************************************************************************
  FILE : apb_master_driver25.sv
*******************************************************************************/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV25
`define APB_MASTER_DRIVER_SV25

//------------------------------------------------------------------------------
// CLASS25: apb_master_driver25 declaration25
//------------------------------------------------------------------------------

class apb_master_driver25 extends uvm_driver #(apb_transfer25);

  // The virtual interface used to drive25 and view25 HDL signals25.
  virtual apb_if25 vif25;
  
  // A pointer25 to the configuration unit25 of the agent25
  apb_config25 cfg;
  
  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver25)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor25 which calls super.new() with appropriate25 parameters25.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive25();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer25 (apb_transfer25 trans25);
  extern virtual protected task drive_address_phase25 (apb_transfer25 trans25);
  extern virtual protected task drive_data_phase25 (apb_transfer25 trans25);

endclass : apb_master_driver25

// UVM build_phase
function void apb_master_driver25::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config25)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG25", "apb_config25 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets25 the vif25 as a config property
function void apb_master_driver25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if25)::get(this, "", "vif25", vif25))
    `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

// Declaration25 of the UVM run_phase method.
task apb_master_driver25::run_phase(uvm_phase phase);
  get_and_drive25();
endtask : run_phase

// This25 task manages25 the interaction25 between the sequencer and driver
task apb_master_driver25::get_and_drive25();
  while (1) begin
    reset();
    fork 
      @(negedge vif25.preset25)
        // APB_MASTER_DRIVER25 tag25 required25 for Debug25 Labs25
        `uvm_info("APB_MASTER_DRIVER25", "get_and_drive25: Reset25 dropped", UVM_MEDIUM)
      begin
        // This25 thread25 will be killed at reset
        forever begin
          @(posedge vif25.pclock25 iff (vif25.preset25))
          seq_item_port.get_next_item(req);
          drive_transfer25(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If25 we25 are in the middle25 of a transfer25, need to end the tx25. Also25,
      //do any reset cleanup25 here25. The only way25 we25 got25 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive25

// Drive25 all signals25 to reset state 
task apb_master_driver25::reset();
  // If25 the reset is not active, then25 wait for it to become25 active before
  // resetting25 the interface.
  wait(!vif25.preset25);
  // APB_MASTER_DRIVER25 tag25 required25 for Debug25 Labs25
  `uvm_info("APB_MASTER_DRIVER25", $psprintf("Reset25 observed25"), UVM_MEDIUM)
  vif25.paddr25     <= 'h0;
  vif25.pwdata25    <= 'h0;
  vif25.prwd25      <= 'b0;
  vif25.psel25      <= 'b0;
  vif25.penable25   <= 'b0;
endtask : reset

// Drives25 a transfer25 when an item is ready to be sent25.
task apb_master_driver25::drive_transfer25 (apb_transfer25 trans25);
  void'(this.begin_tr(trans25, "apb25 master25 driver", "UVM Debug25",
       "APB25 master25 driver transaction from get_and_drive25"));
  if (trans25.transmit_delay25 > 0) begin
    repeat(trans25.transmit_delay25) @(posedge vif25.pclock25);
  end
  drive_address_phase25(trans25);
  drive_data_phase25(trans25);
  // APB_MASTER_DRIVER_TR25 tag25 required25 for Debug25 Labs25
  `uvm_info("APB_MASTER_DRIVER_TR25", $psprintf("APB25 Finished Driving25 Transfer25 \n%s",
            trans25.sprint()), UVM_HIGH)
  this.end_tr(trans25);
endtask : drive_transfer25

// Drive25 the address phase of the transfer25
task apb_master_driver25::drive_address_phase25 (apb_transfer25 trans25);
  int slave_indx25;
  slave_indx25 = cfg.get_slave_psel_by_addr25(trans25.addr);
  vif25.paddr25 <= trans25.addr;
  vif25.psel25 <= (1<<slave_indx25);
  vif25.penable25 <= 0;
  if (trans25.direction25 == APB_READ25) begin
    vif25.prwd25 <= 1'b0;
  end    
  else begin
    vif25.prwd25 <= 1'b1;
    vif25.pwdata25 <= trans25.data;
  end
  @(posedge vif25.pclock25);
endtask : drive_address_phase25

// Drive25 the data phase of the transfer25
task apb_master_driver25::drive_data_phase25 (apb_transfer25 trans25);
  vif25.penable25 <= 1;
  @(posedge vif25.pclock25 iff vif25.pready25); 
  if (trans25.direction25 == APB_READ25) begin
    trans25.data = vif25.prdata25;
  end
  vif25.penable25 <= 0;
  vif25.psel25    <= 0;
endtask : drive_data_phase25

`endif // APB_MASTER_DRIVER_SV25
