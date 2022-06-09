/*******************************************************************************
  FILE : apb_master_driver2.sv
*******************************************************************************/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV2
`define APB_MASTER_DRIVER_SV2

//------------------------------------------------------------------------------
// CLASS2: apb_master_driver2 declaration2
//------------------------------------------------------------------------------

class apb_master_driver2 extends uvm_driver #(apb_transfer2);

  // The virtual interface used to drive2 and view2 HDL signals2.
  virtual apb_if2 vif2;
  
  // A pointer2 to the configuration unit2 of the agent2
  apb_config2 cfg;
  
  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver2)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor2 which calls super.new() with appropriate2 parameters2.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive2();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer2 (apb_transfer2 trans2);
  extern virtual protected task drive_address_phase2 (apb_transfer2 trans2);
  extern virtual protected task drive_data_phase2 (apb_transfer2 trans2);

endclass : apb_master_driver2

// UVM build_phase
function void apb_master_driver2::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config2)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG2", "apb_config2 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets2 the vif2 as a config property
function void apb_master_driver2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if2)::get(this, "", "vif2", vif2))
    `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

// Declaration2 of the UVM run_phase method.
task apb_master_driver2::run_phase(uvm_phase phase);
  get_and_drive2();
endtask : run_phase

// This2 task manages2 the interaction2 between the sequencer and driver
task apb_master_driver2::get_and_drive2();
  while (1) begin
    reset();
    fork 
      @(negedge vif2.preset2)
        // APB_MASTER_DRIVER2 tag2 required2 for Debug2 Labs2
        `uvm_info("APB_MASTER_DRIVER2", "get_and_drive2: Reset2 dropped", UVM_MEDIUM)
      begin
        // This2 thread2 will be killed at reset
        forever begin
          @(posedge vif2.pclock2 iff (vif2.preset2))
          seq_item_port.get_next_item(req);
          drive_transfer2(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If2 we2 are in the middle2 of a transfer2, need to end the tx2. Also2,
      //do any reset cleanup2 here2. The only way2 we2 got2 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive2

// Drive2 all signals2 to reset state 
task apb_master_driver2::reset();
  // If2 the reset is not active, then2 wait for it to become2 active before
  // resetting2 the interface.
  wait(!vif2.preset2);
  // APB_MASTER_DRIVER2 tag2 required2 for Debug2 Labs2
  `uvm_info("APB_MASTER_DRIVER2", $psprintf("Reset2 observed2"), UVM_MEDIUM)
  vif2.paddr2     <= 'h0;
  vif2.pwdata2    <= 'h0;
  vif2.prwd2      <= 'b0;
  vif2.psel2      <= 'b0;
  vif2.penable2   <= 'b0;
endtask : reset

// Drives2 a transfer2 when an item is ready to be sent2.
task apb_master_driver2::drive_transfer2 (apb_transfer2 trans2);
  void'(this.begin_tr(trans2, "apb2 master2 driver", "UVM Debug2",
       "APB2 master2 driver transaction from get_and_drive2"));
  if (trans2.transmit_delay2 > 0) begin
    repeat(trans2.transmit_delay2) @(posedge vif2.pclock2);
  end
  drive_address_phase2(trans2);
  drive_data_phase2(trans2);
  // APB_MASTER_DRIVER_TR2 tag2 required2 for Debug2 Labs2
  `uvm_info("APB_MASTER_DRIVER_TR2", $psprintf("APB2 Finished Driving2 Transfer2 \n%s",
            trans2.sprint()), UVM_HIGH)
  this.end_tr(trans2);
endtask : drive_transfer2

// Drive2 the address phase of the transfer2
task apb_master_driver2::drive_address_phase2 (apb_transfer2 trans2);
  int slave_indx2;
  slave_indx2 = cfg.get_slave_psel_by_addr2(trans2.addr);
  vif2.paddr2 <= trans2.addr;
  vif2.psel2 <= (1<<slave_indx2);
  vif2.penable2 <= 0;
  if (trans2.direction2 == APB_READ2) begin
    vif2.prwd2 <= 1'b0;
  end    
  else begin
    vif2.prwd2 <= 1'b1;
    vif2.pwdata2 <= trans2.data;
  end
  @(posedge vif2.pclock2);
endtask : drive_address_phase2

// Drive2 the data phase of the transfer2
task apb_master_driver2::drive_data_phase2 (apb_transfer2 trans2);
  vif2.penable2 <= 1;
  @(posedge vif2.pclock2 iff vif2.pready2); 
  if (trans2.direction2 == APB_READ2) begin
    trans2.data = vif2.prdata2;
  end
  vif2.penable2 <= 0;
  vif2.psel2    <= 0;
endtask : drive_data_phase2

`endif // APB_MASTER_DRIVER_SV2
