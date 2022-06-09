/*******************************************************************************
  FILE : apb_master_driver5.sv
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV5
`define APB_MASTER_DRIVER_SV5

//------------------------------------------------------------------------------
// CLASS5: apb_master_driver5 declaration5
//------------------------------------------------------------------------------

class apb_master_driver5 extends uvm_driver #(apb_transfer5);

  // The virtual interface used to drive5 and view5 HDL signals5.
  virtual apb_if5 vif5;
  
  // A pointer5 to the configuration unit5 of the agent5
  apb_config5 cfg;
  
  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver5)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor5 which calls super.new() with appropriate5 parameters5.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive5();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer5 (apb_transfer5 trans5);
  extern virtual protected task drive_address_phase5 (apb_transfer5 trans5);
  extern virtual protected task drive_data_phase5 (apb_transfer5 trans5);

endclass : apb_master_driver5

// UVM build_phase
function void apb_master_driver5::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config5)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG5", "apb_config5 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets5 the vif5 as a config property
function void apb_master_driver5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if5)::get(this, "", "vif5", vif5))
    `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

// Declaration5 of the UVM run_phase method.
task apb_master_driver5::run_phase(uvm_phase phase);
  get_and_drive5();
endtask : run_phase

// This5 task manages5 the interaction5 between the sequencer and driver
task apb_master_driver5::get_and_drive5();
  while (1) begin
    reset();
    fork 
      @(negedge vif5.preset5)
        // APB_MASTER_DRIVER5 tag5 required5 for Debug5 Labs5
        `uvm_info("APB_MASTER_DRIVER5", "get_and_drive5: Reset5 dropped", UVM_MEDIUM)
      begin
        // This5 thread5 will be killed at reset
        forever begin
          @(posedge vif5.pclock5 iff (vif5.preset5))
          seq_item_port.get_next_item(req);
          drive_transfer5(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If5 we5 are in the middle5 of a transfer5, need to end the tx5. Also5,
      //do any reset cleanup5 here5. The only way5 we5 got5 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive5

// Drive5 all signals5 to reset state 
task apb_master_driver5::reset();
  // If5 the reset is not active, then5 wait for it to become5 active before
  // resetting5 the interface.
  wait(!vif5.preset5);
  // APB_MASTER_DRIVER5 tag5 required5 for Debug5 Labs5
  `uvm_info("APB_MASTER_DRIVER5", $psprintf("Reset5 observed5"), UVM_MEDIUM)
  vif5.paddr5     <= 'h0;
  vif5.pwdata5    <= 'h0;
  vif5.prwd5      <= 'b0;
  vif5.psel5      <= 'b0;
  vif5.penable5   <= 'b0;
endtask : reset

// Drives5 a transfer5 when an item is ready to be sent5.
task apb_master_driver5::drive_transfer5 (apb_transfer5 trans5);
  void'(this.begin_tr(trans5, "apb5 master5 driver", "UVM Debug5",
       "APB5 master5 driver transaction from get_and_drive5"));
  if (trans5.transmit_delay5 > 0) begin
    repeat(trans5.transmit_delay5) @(posedge vif5.pclock5);
  end
  drive_address_phase5(trans5);
  drive_data_phase5(trans5);
  // APB_MASTER_DRIVER_TR5 tag5 required5 for Debug5 Labs5
  `uvm_info("APB_MASTER_DRIVER_TR5", $psprintf("APB5 Finished Driving5 Transfer5 \n%s",
            trans5.sprint()), UVM_HIGH)
  this.end_tr(trans5);
endtask : drive_transfer5

// Drive5 the address phase of the transfer5
task apb_master_driver5::drive_address_phase5 (apb_transfer5 trans5);
  int slave_indx5;
  slave_indx5 = cfg.get_slave_psel_by_addr5(trans5.addr);
  vif5.paddr5 <= trans5.addr;
  vif5.psel5 <= (1<<slave_indx5);
  vif5.penable5 <= 0;
  if (trans5.direction5 == APB_READ5) begin
    vif5.prwd5 <= 1'b0;
  end    
  else begin
    vif5.prwd5 <= 1'b1;
    vif5.pwdata5 <= trans5.data;
  end
  @(posedge vif5.pclock5);
endtask : drive_address_phase5

// Drive5 the data phase of the transfer5
task apb_master_driver5::drive_data_phase5 (apb_transfer5 trans5);
  vif5.penable5 <= 1;
  @(posedge vif5.pclock5 iff vif5.pready5); 
  if (trans5.direction5 == APB_READ5) begin
    trans5.data = vif5.prdata5;
  end
  vif5.penable5 <= 0;
  vif5.psel5    <= 0;
endtask : drive_data_phase5

`endif // APB_MASTER_DRIVER_SV5
