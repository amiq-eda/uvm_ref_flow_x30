/*******************************************************************************
  FILE : apb_master_driver14.sv
*******************************************************************************/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV14
`define APB_MASTER_DRIVER_SV14

//------------------------------------------------------------------------------
// CLASS14: apb_master_driver14 declaration14
//------------------------------------------------------------------------------

class apb_master_driver14 extends uvm_driver #(apb_transfer14);

  // The virtual interface used to drive14 and view14 HDL signals14.
  virtual apb_if14 vif14;
  
  // A pointer14 to the configuration unit14 of the agent14
  apb_config14 cfg;
  
  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver14)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor14 which calls super.new() with appropriate14 parameters14.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive14();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer14 (apb_transfer14 trans14);
  extern virtual protected task drive_address_phase14 (apb_transfer14 trans14);
  extern virtual protected task drive_data_phase14 (apb_transfer14 trans14);

endclass : apb_master_driver14

// UVM build_phase
function void apb_master_driver14::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config14)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG14", "apb_config14 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets14 the vif14 as a config property
function void apb_master_driver14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if14)::get(this, "", "vif14", vif14))
    `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

// Declaration14 of the UVM run_phase method.
task apb_master_driver14::run_phase(uvm_phase phase);
  get_and_drive14();
endtask : run_phase

// This14 task manages14 the interaction14 between the sequencer and driver
task apb_master_driver14::get_and_drive14();
  while (1) begin
    reset();
    fork 
      @(negedge vif14.preset14)
        // APB_MASTER_DRIVER14 tag14 required14 for Debug14 Labs14
        `uvm_info("APB_MASTER_DRIVER14", "get_and_drive14: Reset14 dropped", UVM_MEDIUM)
      begin
        // This14 thread14 will be killed at reset
        forever begin
          @(posedge vif14.pclock14 iff (vif14.preset14))
          seq_item_port.get_next_item(req);
          drive_transfer14(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If14 we14 are in the middle14 of a transfer14, need to end the tx14. Also14,
      //do any reset cleanup14 here14. The only way14 we14 got14 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive14

// Drive14 all signals14 to reset state 
task apb_master_driver14::reset();
  // If14 the reset is not active, then14 wait for it to become14 active before
  // resetting14 the interface.
  wait(!vif14.preset14);
  // APB_MASTER_DRIVER14 tag14 required14 for Debug14 Labs14
  `uvm_info("APB_MASTER_DRIVER14", $psprintf("Reset14 observed14"), UVM_MEDIUM)
  vif14.paddr14     <= 'h0;
  vif14.pwdata14    <= 'h0;
  vif14.prwd14      <= 'b0;
  vif14.psel14      <= 'b0;
  vif14.penable14   <= 'b0;
endtask : reset

// Drives14 a transfer14 when an item is ready to be sent14.
task apb_master_driver14::drive_transfer14 (apb_transfer14 trans14);
  void'(this.begin_tr(trans14, "apb14 master14 driver", "UVM Debug14",
       "APB14 master14 driver transaction from get_and_drive14"));
  if (trans14.transmit_delay14 > 0) begin
    repeat(trans14.transmit_delay14) @(posedge vif14.pclock14);
  end
  drive_address_phase14(trans14);
  drive_data_phase14(trans14);
  // APB_MASTER_DRIVER_TR14 tag14 required14 for Debug14 Labs14
  `uvm_info("APB_MASTER_DRIVER_TR14", $psprintf("APB14 Finished Driving14 Transfer14 \n%s",
            trans14.sprint()), UVM_HIGH)
  this.end_tr(trans14);
endtask : drive_transfer14

// Drive14 the address phase of the transfer14
task apb_master_driver14::drive_address_phase14 (apb_transfer14 trans14);
  int slave_indx14;
  slave_indx14 = cfg.get_slave_psel_by_addr14(trans14.addr);
  vif14.paddr14 <= trans14.addr;
  vif14.psel14 <= (1<<slave_indx14);
  vif14.penable14 <= 0;
  if (trans14.direction14 == APB_READ14) begin
    vif14.prwd14 <= 1'b0;
  end    
  else begin
    vif14.prwd14 <= 1'b1;
    vif14.pwdata14 <= trans14.data;
  end
  @(posedge vif14.pclock14);
endtask : drive_address_phase14

// Drive14 the data phase of the transfer14
task apb_master_driver14::drive_data_phase14 (apb_transfer14 trans14);
  vif14.penable14 <= 1;
  @(posedge vif14.pclock14 iff vif14.pready14); 
  if (trans14.direction14 == APB_READ14) begin
    trans14.data = vif14.prdata14;
  end
  vif14.penable14 <= 0;
  vif14.psel14    <= 0;
endtask : drive_data_phase14

`endif // APB_MASTER_DRIVER_SV14
