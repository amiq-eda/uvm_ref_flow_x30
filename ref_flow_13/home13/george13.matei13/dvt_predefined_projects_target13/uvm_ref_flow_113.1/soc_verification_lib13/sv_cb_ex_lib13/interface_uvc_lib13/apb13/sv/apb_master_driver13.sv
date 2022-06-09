/*******************************************************************************
  FILE : apb_master_driver13.sv
*******************************************************************************/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV13
`define APB_MASTER_DRIVER_SV13

//------------------------------------------------------------------------------
// CLASS13: apb_master_driver13 declaration13
//------------------------------------------------------------------------------

class apb_master_driver13 extends uvm_driver #(apb_transfer13);

  // The virtual interface used to drive13 and view13 HDL signals13.
  virtual apb_if13 vif13;
  
  // A pointer13 to the configuration unit13 of the agent13
  apb_config13 cfg;
  
  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver13)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor13 which calls super.new() with appropriate13 parameters13.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive13();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer13 (apb_transfer13 trans13);
  extern virtual protected task drive_address_phase13 (apb_transfer13 trans13);
  extern virtual protected task drive_data_phase13 (apb_transfer13 trans13);

endclass : apb_master_driver13

// UVM build_phase
function void apb_master_driver13::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config13)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG13", "apb_config13 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets13 the vif13 as a config property
function void apb_master_driver13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if13)::get(this, "", "vif13", vif13))
    `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

// Declaration13 of the UVM run_phase method.
task apb_master_driver13::run_phase(uvm_phase phase);
  get_and_drive13();
endtask : run_phase

// This13 task manages13 the interaction13 between the sequencer and driver
task apb_master_driver13::get_and_drive13();
  while (1) begin
    reset();
    fork 
      @(negedge vif13.preset13)
        // APB_MASTER_DRIVER13 tag13 required13 for Debug13 Labs13
        `uvm_info("APB_MASTER_DRIVER13", "get_and_drive13: Reset13 dropped", UVM_MEDIUM)
      begin
        // This13 thread13 will be killed at reset
        forever begin
          @(posedge vif13.pclock13 iff (vif13.preset13))
          seq_item_port.get_next_item(req);
          drive_transfer13(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If13 we13 are in the middle13 of a transfer13, need to end the tx13. Also13,
      //do any reset cleanup13 here13. The only way13 we13 got13 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive13

// Drive13 all signals13 to reset state 
task apb_master_driver13::reset();
  // If13 the reset is not active, then13 wait for it to become13 active before
  // resetting13 the interface.
  wait(!vif13.preset13);
  // APB_MASTER_DRIVER13 tag13 required13 for Debug13 Labs13
  `uvm_info("APB_MASTER_DRIVER13", $psprintf("Reset13 observed13"), UVM_MEDIUM)
  vif13.paddr13     <= 'h0;
  vif13.pwdata13    <= 'h0;
  vif13.prwd13      <= 'b0;
  vif13.psel13      <= 'b0;
  vif13.penable13   <= 'b0;
endtask : reset

// Drives13 a transfer13 when an item is ready to be sent13.
task apb_master_driver13::drive_transfer13 (apb_transfer13 trans13);
  void'(this.begin_tr(trans13, "apb13 master13 driver", "UVM Debug13",
       "APB13 master13 driver transaction from get_and_drive13"));
  if (trans13.transmit_delay13 > 0) begin
    repeat(trans13.transmit_delay13) @(posedge vif13.pclock13);
  end
  drive_address_phase13(trans13);
  drive_data_phase13(trans13);
  // APB_MASTER_DRIVER_TR13 tag13 required13 for Debug13 Labs13
  `uvm_info("APB_MASTER_DRIVER_TR13", $psprintf("APB13 Finished Driving13 Transfer13 \n%s",
            trans13.sprint()), UVM_HIGH)
  this.end_tr(trans13);
endtask : drive_transfer13

// Drive13 the address phase of the transfer13
task apb_master_driver13::drive_address_phase13 (apb_transfer13 trans13);
  int slave_indx13;
  slave_indx13 = cfg.get_slave_psel_by_addr13(trans13.addr);
  vif13.paddr13 <= trans13.addr;
  vif13.psel13 <= (1<<slave_indx13);
  vif13.penable13 <= 0;
  if (trans13.direction13 == APB_READ13) begin
    vif13.prwd13 <= 1'b0;
  end    
  else begin
    vif13.prwd13 <= 1'b1;
    vif13.pwdata13 <= trans13.data;
  end
  @(posedge vif13.pclock13);
endtask : drive_address_phase13

// Drive13 the data phase of the transfer13
task apb_master_driver13::drive_data_phase13 (apb_transfer13 trans13);
  vif13.penable13 <= 1;
  @(posedge vif13.pclock13 iff vif13.pready13); 
  if (trans13.direction13 == APB_READ13) begin
    trans13.data = vif13.prdata13;
  end
  vif13.penable13 <= 0;
  vif13.psel13    <= 0;
endtask : drive_data_phase13

`endif // APB_MASTER_DRIVER_SV13
