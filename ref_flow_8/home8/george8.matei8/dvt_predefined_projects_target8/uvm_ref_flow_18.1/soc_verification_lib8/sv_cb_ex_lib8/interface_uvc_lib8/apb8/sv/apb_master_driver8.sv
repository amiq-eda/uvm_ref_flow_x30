/*******************************************************************************
  FILE : apb_master_driver8.sv
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV8
`define APB_MASTER_DRIVER_SV8

//------------------------------------------------------------------------------
// CLASS8: apb_master_driver8 declaration8
//------------------------------------------------------------------------------

class apb_master_driver8 extends uvm_driver #(apb_transfer8);

  // The virtual interface used to drive8 and view8 HDL signals8.
  virtual apb_if8 vif8;
  
  // A pointer8 to the configuration unit8 of the agent8
  apb_config8 cfg;
  
  // Provide8 implementations8 of virtual methods8 such8 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver8)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor8 which calls super.new() with appropriate8 parameters8.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive8();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer8 (apb_transfer8 trans8);
  extern virtual protected task drive_address_phase8 (apb_transfer8 trans8);
  extern virtual protected task drive_data_phase8 (apb_transfer8 trans8);

endclass : apb_master_driver8

// UVM build_phase
function void apb_master_driver8::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config8)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG8", "apb_config8 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets8 the vif8 as a config property
function void apb_master_driver8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if8)::get(this, "", "vif8", vif8))
    `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

// Declaration8 of the UVM run_phase method.
task apb_master_driver8::run_phase(uvm_phase phase);
  get_and_drive8();
endtask : run_phase

// This8 task manages8 the interaction8 between the sequencer and driver
task apb_master_driver8::get_and_drive8();
  while (1) begin
    reset();
    fork 
      @(negedge vif8.preset8)
        // APB_MASTER_DRIVER8 tag8 required8 for Debug8 Labs8
        `uvm_info("APB_MASTER_DRIVER8", "get_and_drive8: Reset8 dropped", UVM_MEDIUM)
      begin
        // This8 thread8 will be killed at reset
        forever begin
          @(posedge vif8.pclock8 iff (vif8.preset8))
          seq_item_port.get_next_item(req);
          drive_transfer8(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If8 we8 are in the middle8 of a transfer8, need to end the tx8. Also8,
      //do any reset cleanup8 here8. The only way8 we8 got8 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive8

// Drive8 all signals8 to reset state 
task apb_master_driver8::reset();
  // If8 the reset is not active, then8 wait for it to become8 active before
  // resetting8 the interface.
  wait(!vif8.preset8);
  // APB_MASTER_DRIVER8 tag8 required8 for Debug8 Labs8
  `uvm_info("APB_MASTER_DRIVER8", $psprintf("Reset8 observed8"), UVM_MEDIUM)
  vif8.paddr8     <= 'h0;
  vif8.pwdata8    <= 'h0;
  vif8.prwd8      <= 'b0;
  vif8.psel8      <= 'b0;
  vif8.penable8   <= 'b0;
endtask : reset

// Drives8 a transfer8 when an item is ready to be sent8.
task apb_master_driver8::drive_transfer8 (apb_transfer8 trans8);
  void'(this.begin_tr(trans8, "apb8 master8 driver", "UVM Debug8",
       "APB8 master8 driver transaction from get_and_drive8"));
  if (trans8.transmit_delay8 > 0) begin
    repeat(trans8.transmit_delay8) @(posedge vif8.pclock8);
  end
  drive_address_phase8(trans8);
  drive_data_phase8(trans8);
  // APB_MASTER_DRIVER_TR8 tag8 required8 for Debug8 Labs8
  `uvm_info("APB_MASTER_DRIVER_TR8", $psprintf("APB8 Finished Driving8 Transfer8 \n%s",
            trans8.sprint()), UVM_HIGH)
  this.end_tr(trans8);
endtask : drive_transfer8

// Drive8 the address phase of the transfer8
task apb_master_driver8::drive_address_phase8 (apb_transfer8 trans8);
  int slave_indx8;
  slave_indx8 = cfg.get_slave_psel_by_addr8(trans8.addr);
  vif8.paddr8 <= trans8.addr;
  vif8.psel8 <= (1<<slave_indx8);
  vif8.penable8 <= 0;
  if (trans8.direction8 == APB_READ8) begin
    vif8.prwd8 <= 1'b0;
  end    
  else begin
    vif8.prwd8 <= 1'b1;
    vif8.pwdata8 <= trans8.data;
  end
  @(posedge vif8.pclock8);
endtask : drive_address_phase8

// Drive8 the data phase of the transfer8
task apb_master_driver8::drive_data_phase8 (apb_transfer8 trans8);
  vif8.penable8 <= 1;
  @(posedge vif8.pclock8 iff vif8.pready8); 
  if (trans8.direction8 == APB_READ8) begin
    trans8.data = vif8.prdata8;
  end
  vif8.penable8 <= 0;
  vif8.psel8    <= 0;
endtask : drive_data_phase8

`endif // APB_MASTER_DRIVER_SV8
