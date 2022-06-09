/*******************************************************************************
  FILE : apb_master_driver30.sv
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV30
`define APB_MASTER_DRIVER_SV30

//------------------------------------------------------------------------------
// CLASS30: apb_master_driver30 declaration30
//------------------------------------------------------------------------------

class apb_master_driver30 extends uvm_driver #(apb_transfer30);

  // The virtual interface used to drive30 and view30 HDL signals30.
  virtual apb_if30 vif30;
  
  // A pointer30 to the configuration unit30 of the agent30
  apb_config30 cfg;
  
  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver30)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor30 which calls super.new() with appropriate30 parameters30.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive30();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer30 (apb_transfer30 trans30);
  extern virtual protected task drive_address_phase30 (apb_transfer30 trans30);
  extern virtual protected task drive_data_phase30 (apb_transfer30 trans30);

endclass : apb_master_driver30

// UVM build_phase
function void apb_master_driver30::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config30)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG30", "apb_config30 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets30 the vif30 as a config property
function void apb_master_driver30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if30)::get(this, "", "vif30", vif30))
    `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

// Declaration30 of the UVM run_phase method.
task apb_master_driver30::run_phase(uvm_phase phase);
  get_and_drive30();
endtask : run_phase

// This30 task manages30 the interaction30 between the sequencer and driver
task apb_master_driver30::get_and_drive30();
  while (1) begin
    reset();
    fork 
      @(negedge vif30.preset30)
        // APB_MASTER_DRIVER30 tag30 required30 for Debug30 Labs30
        `uvm_info("APB_MASTER_DRIVER30", "get_and_drive30: Reset30 dropped", UVM_MEDIUM)
      begin
        // This30 thread30 will be killed at reset
        forever begin
          @(posedge vif30.pclock30 iff (vif30.preset30))
          seq_item_port.get_next_item(req);
          drive_transfer30(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If30 we30 are in the middle30 of a transfer30, need to end the tx30. Also30,
      //do any reset cleanup30 here30. The only way30 we30 got30 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive30

// Drive30 all signals30 to reset state 
task apb_master_driver30::reset();
  // If30 the reset is not active, then30 wait for it to become30 active before
  // resetting30 the interface.
  wait(!vif30.preset30);
  // APB_MASTER_DRIVER30 tag30 required30 for Debug30 Labs30
  `uvm_info("APB_MASTER_DRIVER30", $psprintf("Reset30 observed30"), UVM_MEDIUM)
  vif30.paddr30     <= 'h0;
  vif30.pwdata30    <= 'h0;
  vif30.prwd30      <= 'b0;
  vif30.psel30      <= 'b0;
  vif30.penable30   <= 'b0;
endtask : reset

// Drives30 a transfer30 when an item is ready to be sent30.
task apb_master_driver30::drive_transfer30 (apb_transfer30 trans30);
  void'(this.begin_tr(trans30, "apb30 master30 driver", "UVM Debug30",
       "APB30 master30 driver transaction from get_and_drive30"));
  if (trans30.transmit_delay30 > 0) begin
    repeat(trans30.transmit_delay30) @(posedge vif30.pclock30);
  end
  drive_address_phase30(trans30);
  drive_data_phase30(trans30);
  // APB_MASTER_DRIVER_TR30 tag30 required30 for Debug30 Labs30
  `uvm_info("APB_MASTER_DRIVER_TR30", $psprintf("APB30 Finished Driving30 Transfer30 \n%s",
            trans30.sprint()), UVM_HIGH)
  this.end_tr(trans30);
endtask : drive_transfer30

// Drive30 the address phase of the transfer30
task apb_master_driver30::drive_address_phase30 (apb_transfer30 trans30);
  int slave_indx30;
  slave_indx30 = cfg.get_slave_psel_by_addr30(trans30.addr);
  vif30.paddr30 <= trans30.addr;
  vif30.psel30 <= (1<<slave_indx30);
  vif30.penable30 <= 0;
  if (trans30.direction30 == APB_READ30) begin
    vif30.prwd30 <= 1'b0;
  end    
  else begin
    vif30.prwd30 <= 1'b1;
    vif30.pwdata30 <= trans30.data;
  end
  @(posedge vif30.pclock30);
endtask : drive_address_phase30

// Drive30 the data phase of the transfer30
task apb_master_driver30::drive_data_phase30 (apb_transfer30 trans30);
  vif30.penable30 <= 1;
  @(posedge vif30.pclock30 iff vif30.pready30); 
  if (trans30.direction30 == APB_READ30) begin
    trans30.data = vif30.prdata30;
  end
  vif30.penable30 <= 0;
  vif30.psel30    <= 0;
endtask : drive_data_phase30

`endif // APB_MASTER_DRIVER_SV30
