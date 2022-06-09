/*******************************************************************************
  FILE : apb_master_driver20.sv
*******************************************************************************/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV20
`define APB_MASTER_DRIVER_SV20

//------------------------------------------------------------------------------
// CLASS20: apb_master_driver20 declaration20
//------------------------------------------------------------------------------

class apb_master_driver20 extends uvm_driver #(apb_transfer20);

  // The virtual interface used to drive20 and view20 HDL signals20.
  virtual apb_if20 vif20;
  
  // A pointer20 to the configuration unit20 of the agent20
  apb_config20 cfg;
  
  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver20)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor20 which calls super.new() with appropriate20 parameters20.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive20();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer20 (apb_transfer20 trans20);
  extern virtual protected task drive_address_phase20 (apb_transfer20 trans20);
  extern virtual protected task drive_data_phase20 (apb_transfer20 trans20);

endclass : apb_master_driver20

// UVM build_phase
function void apb_master_driver20::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config20)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG20", "apb_config20 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets20 the vif20 as a config property
function void apb_master_driver20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if20)::get(this, "", "vif20", vif20))
    `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

// Declaration20 of the UVM run_phase method.
task apb_master_driver20::run_phase(uvm_phase phase);
  get_and_drive20();
endtask : run_phase

// This20 task manages20 the interaction20 between the sequencer and driver
task apb_master_driver20::get_and_drive20();
  while (1) begin
    reset();
    fork 
      @(negedge vif20.preset20)
        // APB_MASTER_DRIVER20 tag20 required20 for Debug20 Labs20
        `uvm_info("APB_MASTER_DRIVER20", "get_and_drive20: Reset20 dropped", UVM_MEDIUM)
      begin
        // This20 thread20 will be killed at reset
        forever begin
          @(posedge vif20.pclock20 iff (vif20.preset20))
          seq_item_port.get_next_item(req);
          drive_transfer20(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If20 we20 are in the middle20 of a transfer20, need to end the tx20. Also20,
      //do any reset cleanup20 here20. The only way20 we20 got20 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive20

// Drive20 all signals20 to reset state 
task apb_master_driver20::reset();
  // If20 the reset is not active, then20 wait for it to become20 active before
  // resetting20 the interface.
  wait(!vif20.preset20);
  // APB_MASTER_DRIVER20 tag20 required20 for Debug20 Labs20
  `uvm_info("APB_MASTER_DRIVER20", $psprintf("Reset20 observed20"), UVM_MEDIUM)
  vif20.paddr20     <= 'h0;
  vif20.pwdata20    <= 'h0;
  vif20.prwd20      <= 'b0;
  vif20.psel20      <= 'b0;
  vif20.penable20   <= 'b0;
endtask : reset

// Drives20 a transfer20 when an item is ready to be sent20.
task apb_master_driver20::drive_transfer20 (apb_transfer20 trans20);
  void'(this.begin_tr(trans20, "apb20 master20 driver", "UVM Debug20",
       "APB20 master20 driver transaction from get_and_drive20"));
  if (trans20.transmit_delay20 > 0) begin
    repeat(trans20.transmit_delay20) @(posedge vif20.pclock20);
  end
  drive_address_phase20(trans20);
  drive_data_phase20(trans20);
  // APB_MASTER_DRIVER_TR20 tag20 required20 for Debug20 Labs20
  `uvm_info("APB_MASTER_DRIVER_TR20", $psprintf("APB20 Finished Driving20 Transfer20 \n%s",
            trans20.sprint()), UVM_HIGH)
  this.end_tr(trans20);
endtask : drive_transfer20

// Drive20 the address phase of the transfer20
task apb_master_driver20::drive_address_phase20 (apb_transfer20 trans20);
  int slave_indx20;
  slave_indx20 = cfg.get_slave_psel_by_addr20(trans20.addr);
  vif20.paddr20 <= trans20.addr;
  vif20.psel20 <= (1<<slave_indx20);
  vif20.penable20 <= 0;
  if (trans20.direction20 == APB_READ20) begin
    vif20.prwd20 <= 1'b0;
  end    
  else begin
    vif20.prwd20 <= 1'b1;
    vif20.pwdata20 <= trans20.data;
  end
  @(posedge vif20.pclock20);
endtask : drive_address_phase20

// Drive20 the data phase of the transfer20
task apb_master_driver20::drive_data_phase20 (apb_transfer20 trans20);
  vif20.penable20 <= 1;
  @(posedge vif20.pclock20 iff vif20.pready20); 
  if (trans20.direction20 == APB_READ20) begin
    trans20.data = vif20.prdata20;
  end
  vif20.penable20 <= 0;
  vif20.psel20    <= 0;
endtask : drive_data_phase20

`endif // APB_MASTER_DRIVER_SV20
