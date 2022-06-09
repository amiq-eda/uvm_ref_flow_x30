/*******************************************************************************
  FILE : apb_master_driver12.sv
*******************************************************************************/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV12
`define APB_MASTER_DRIVER_SV12

//------------------------------------------------------------------------------
// CLASS12: apb_master_driver12 declaration12
//------------------------------------------------------------------------------

class apb_master_driver12 extends uvm_driver #(apb_transfer12);

  // The virtual interface used to drive12 and view12 HDL signals12.
  virtual apb_if12 vif12;
  
  // A pointer12 to the configuration unit12 of the agent12
  apb_config12 cfg;
  
  // Provide12 implementations12 of virtual methods12 such12 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver12)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor12 which calls super.new() with appropriate12 parameters12.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive12();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer12 (apb_transfer12 trans12);
  extern virtual protected task drive_address_phase12 (apb_transfer12 trans12);
  extern virtual protected task drive_data_phase12 (apb_transfer12 trans12);

endclass : apb_master_driver12

// UVM build_phase
function void apb_master_driver12::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config12)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG12", "apb_config12 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets12 the vif12 as a config property
function void apb_master_driver12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if12)::get(this, "", "vif12", vif12))
    `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

// Declaration12 of the UVM run_phase method.
task apb_master_driver12::run_phase(uvm_phase phase);
  get_and_drive12();
endtask : run_phase

// This12 task manages12 the interaction12 between the sequencer and driver
task apb_master_driver12::get_and_drive12();
  while (1) begin
    reset();
    fork 
      @(negedge vif12.preset12)
        // APB_MASTER_DRIVER12 tag12 required12 for Debug12 Labs12
        `uvm_info("APB_MASTER_DRIVER12", "get_and_drive12: Reset12 dropped", UVM_MEDIUM)
      begin
        // This12 thread12 will be killed at reset
        forever begin
          @(posedge vif12.pclock12 iff (vif12.preset12))
          seq_item_port.get_next_item(req);
          drive_transfer12(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If12 we12 are in the middle12 of a transfer12, need to end the tx12. Also12,
      //do any reset cleanup12 here12. The only way12 we12 got12 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive12

// Drive12 all signals12 to reset state 
task apb_master_driver12::reset();
  // If12 the reset is not active, then12 wait for it to become12 active before
  // resetting12 the interface.
  wait(!vif12.preset12);
  // APB_MASTER_DRIVER12 tag12 required12 for Debug12 Labs12
  `uvm_info("APB_MASTER_DRIVER12", $psprintf("Reset12 observed12"), UVM_MEDIUM)
  vif12.paddr12     <= 'h0;
  vif12.pwdata12    <= 'h0;
  vif12.prwd12      <= 'b0;
  vif12.psel12      <= 'b0;
  vif12.penable12   <= 'b0;
endtask : reset

// Drives12 a transfer12 when an item is ready to be sent12.
task apb_master_driver12::drive_transfer12 (apb_transfer12 trans12);
  void'(this.begin_tr(trans12, "apb12 master12 driver", "UVM Debug12",
       "APB12 master12 driver transaction from get_and_drive12"));
  if (trans12.transmit_delay12 > 0) begin
    repeat(trans12.transmit_delay12) @(posedge vif12.pclock12);
  end
  drive_address_phase12(trans12);
  drive_data_phase12(trans12);
  // APB_MASTER_DRIVER_TR12 tag12 required12 for Debug12 Labs12
  `uvm_info("APB_MASTER_DRIVER_TR12", $psprintf("APB12 Finished Driving12 Transfer12 \n%s",
            trans12.sprint()), UVM_HIGH)
  this.end_tr(trans12);
endtask : drive_transfer12

// Drive12 the address phase of the transfer12
task apb_master_driver12::drive_address_phase12 (apb_transfer12 trans12);
  int slave_indx12;
  slave_indx12 = cfg.get_slave_psel_by_addr12(trans12.addr);
  vif12.paddr12 <= trans12.addr;
  vif12.psel12 <= (1<<slave_indx12);
  vif12.penable12 <= 0;
  if (trans12.direction12 == APB_READ12) begin
    vif12.prwd12 <= 1'b0;
  end    
  else begin
    vif12.prwd12 <= 1'b1;
    vif12.pwdata12 <= trans12.data;
  end
  @(posedge vif12.pclock12);
endtask : drive_address_phase12

// Drive12 the data phase of the transfer12
task apb_master_driver12::drive_data_phase12 (apb_transfer12 trans12);
  vif12.penable12 <= 1;
  @(posedge vif12.pclock12 iff vif12.pready12); 
  if (trans12.direction12 == APB_READ12) begin
    trans12.data = vif12.prdata12;
  end
  vif12.penable12 <= 0;
  vif12.psel12    <= 0;
endtask : drive_data_phase12

`endif // APB_MASTER_DRIVER_SV12
