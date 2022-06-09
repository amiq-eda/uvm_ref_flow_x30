/*******************************************************************************
  FILE : apb_master_driver10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV10
`define APB_MASTER_DRIVER_SV10

//------------------------------------------------------------------------------
// CLASS10: apb_master_driver10 declaration10
//------------------------------------------------------------------------------

class apb_master_driver10 extends uvm_driver #(apb_transfer10);

  // The virtual interface used to drive10 and view10 HDL signals10.
  virtual apb_if10 vif10;
  
  // A pointer10 to the configuration unit10 of the agent10
  apb_config10 cfg;
  
  // Provide10 implementations10 of virtual methods10 such10 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver10)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor10 which calls super.new() with appropriate10 parameters10.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive10();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer10 (apb_transfer10 trans10);
  extern virtual protected task drive_address_phase10 (apb_transfer10 trans10);
  extern virtual protected task drive_data_phase10 (apb_transfer10 trans10);

endclass : apb_master_driver10

// UVM build_phase
function void apb_master_driver10::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config10)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG10", "apb_config10 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets10 the vif10 as a config property
function void apb_master_driver10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if10)::get(this, "", "vif10", vif10))
    `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

// Declaration10 of the UVM run_phase method.
task apb_master_driver10::run_phase(uvm_phase phase);
  get_and_drive10();
endtask : run_phase

// This10 task manages10 the interaction10 between the sequencer and driver
task apb_master_driver10::get_and_drive10();
  while (1) begin
    reset();
    fork 
      @(negedge vif10.preset10)
        // APB_MASTER_DRIVER10 tag10 required10 for Debug10 Labs10
        `uvm_info("APB_MASTER_DRIVER10", "get_and_drive10: Reset10 dropped", UVM_MEDIUM)
      begin
        // This10 thread10 will be killed at reset
        forever begin
          @(posedge vif10.pclock10 iff (vif10.preset10))
          seq_item_port.get_next_item(req);
          drive_transfer10(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If10 we10 are in the middle10 of a transfer10, need to end the tx10. Also10,
      //do any reset cleanup10 here10. The only way10 we10 got10 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive10

// Drive10 all signals10 to reset state 
task apb_master_driver10::reset();
  // If10 the reset is not active, then10 wait for it to become10 active before
  // resetting10 the interface.
  wait(!vif10.preset10);
  // APB_MASTER_DRIVER10 tag10 required10 for Debug10 Labs10
  `uvm_info("APB_MASTER_DRIVER10", $psprintf("Reset10 observed10"), UVM_MEDIUM)
  vif10.paddr10     <= 'h0;
  vif10.pwdata10    <= 'h0;
  vif10.prwd10      <= 'b0;
  vif10.psel10      <= 'b0;
  vif10.penable10   <= 'b0;
endtask : reset

// Drives10 a transfer10 when an item is ready to be sent10.
task apb_master_driver10::drive_transfer10 (apb_transfer10 trans10);
  void'(this.begin_tr(trans10, "apb10 master10 driver", "UVM Debug10",
       "APB10 master10 driver transaction from get_and_drive10"));
  if (trans10.transmit_delay10 > 0) begin
    repeat(trans10.transmit_delay10) @(posedge vif10.pclock10);
  end
  drive_address_phase10(trans10);
  drive_data_phase10(trans10);
  // APB_MASTER_DRIVER_TR10 tag10 required10 for Debug10 Labs10
  `uvm_info("APB_MASTER_DRIVER_TR10", $psprintf("APB10 Finished Driving10 Transfer10 \n%s",
            trans10.sprint()), UVM_HIGH)
  this.end_tr(trans10);
endtask : drive_transfer10

// Drive10 the address phase of the transfer10
task apb_master_driver10::drive_address_phase10 (apb_transfer10 trans10);
  int slave_indx10;
  slave_indx10 = cfg.get_slave_psel_by_addr10(trans10.addr);
  vif10.paddr10 <= trans10.addr;
  vif10.psel10 <= (1<<slave_indx10);
  vif10.penable10 <= 0;
  if (trans10.direction10 == APB_READ10) begin
    vif10.prwd10 <= 1'b0;
  end    
  else begin
    vif10.prwd10 <= 1'b1;
    vif10.pwdata10 <= trans10.data;
  end
  @(posedge vif10.pclock10);
endtask : drive_address_phase10

// Drive10 the data phase of the transfer10
task apb_master_driver10::drive_data_phase10 (apb_transfer10 trans10);
  vif10.penable10 <= 1;
  @(posedge vif10.pclock10 iff vif10.pready10); 
  if (trans10.direction10 == APB_READ10) begin
    trans10.data = vif10.prdata10;
  end
  vif10.penable10 <= 0;
  vif10.psel10    <= 0;
endtask : drive_data_phase10

`endif // APB_MASTER_DRIVER_SV10
