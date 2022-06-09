/*******************************************************************************
  FILE : apb_master_driver1.sv
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV1
`define APB_MASTER_DRIVER_SV1

//------------------------------------------------------------------------------
// CLASS1: apb_master_driver1 declaration1
//------------------------------------------------------------------------------

class apb_master_driver1 extends uvm_driver #(apb_transfer1);

  // The virtual interface used to drive1 and view1 HDL signals1.
  virtual apb_if1 vif1;
  
  // A pointer1 to the configuration unit1 of the agent1
  apb_config1 cfg;
  
  // Provide1 implementations1 of virtual methods1 such1 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver1)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor1 which calls super.new() with appropriate1 parameters1.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive1();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer1 (apb_transfer1 trans1);
  extern virtual protected task drive_address_phase1 (apb_transfer1 trans1);
  extern virtual protected task drive_data_phase1 (apb_transfer1 trans1);

endclass : apb_master_driver1

// UVM build_phase
function void apb_master_driver1::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config1)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG1", "apb_config1 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets1 the vif1 as a config property
function void apb_master_driver1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if1)::get(this, "", "vif1", vif1))
    `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

// Declaration1 of the UVM run_phase method.
task apb_master_driver1::run_phase(uvm_phase phase);
  get_and_drive1();
endtask : run_phase

// This1 task manages1 the interaction1 between the sequencer and driver
task apb_master_driver1::get_and_drive1();
  while (1) begin
    reset();
    fork 
      @(negedge vif1.preset1)
        // APB_MASTER_DRIVER1 tag1 required1 for Debug1 Labs1
        `uvm_info("APB_MASTER_DRIVER1", "get_and_drive1: Reset1 dropped", UVM_MEDIUM)
      begin
        // This1 thread1 will be killed at reset
        forever begin
          @(posedge vif1.pclock1 iff (vif1.preset1))
          seq_item_port.get_next_item(req);
          drive_transfer1(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If1 we1 are in the middle1 of a transfer1, need to end the tx1. Also1,
      //do any reset cleanup1 here1. The only way1 we1 got1 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive1

// Drive1 all signals1 to reset state 
task apb_master_driver1::reset();
  // If1 the reset is not active, then1 wait for it to become1 active before
  // resetting1 the interface.
  wait(!vif1.preset1);
  // APB_MASTER_DRIVER1 tag1 required1 for Debug1 Labs1
  `uvm_info("APB_MASTER_DRIVER1", $psprintf("Reset1 observed1"), UVM_MEDIUM)
  vif1.paddr1     <= 'h0;
  vif1.pwdata1    <= 'h0;
  vif1.prwd1      <= 'b0;
  vif1.psel1      <= 'b0;
  vif1.penable1   <= 'b0;
endtask : reset

// Drives1 a transfer1 when an item is ready to be sent1.
task apb_master_driver1::drive_transfer1 (apb_transfer1 trans1);
  void'(this.begin_tr(trans1, "apb1 master1 driver", "UVM Debug1",
       "APB1 master1 driver transaction from get_and_drive1"));
  if (trans1.transmit_delay1 > 0) begin
    repeat(trans1.transmit_delay1) @(posedge vif1.pclock1);
  end
  drive_address_phase1(trans1);
  drive_data_phase1(trans1);
  // APB_MASTER_DRIVER_TR1 tag1 required1 for Debug1 Labs1
  `uvm_info("APB_MASTER_DRIVER_TR1", $psprintf("APB1 Finished Driving1 Transfer1 \n%s",
            trans1.sprint()), UVM_HIGH)
  this.end_tr(trans1);
endtask : drive_transfer1

// Drive1 the address phase of the transfer1
task apb_master_driver1::drive_address_phase1 (apb_transfer1 trans1);
  int slave_indx1;
  slave_indx1 = cfg.get_slave_psel_by_addr1(trans1.addr);
  vif1.paddr1 <= trans1.addr;
  vif1.psel1 <= (1<<slave_indx1);
  vif1.penable1 <= 0;
  if (trans1.direction1 == APB_READ1) begin
    vif1.prwd1 <= 1'b0;
  end    
  else begin
    vif1.prwd1 <= 1'b1;
    vif1.pwdata1 <= trans1.data;
  end
  @(posedge vif1.pclock1);
endtask : drive_address_phase1

// Drive1 the data phase of the transfer1
task apb_master_driver1::drive_data_phase1 (apb_transfer1 trans1);
  vif1.penable1 <= 1;
  @(posedge vif1.pclock1 iff vif1.pready1); 
  if (trans1.direction1 == APB_READ1) begin
    trans1.data = vif1.prdata1;
  end
  vif1.penable1 <= 0;
  vif1.psel1    <= 0;
endtask : drive_data_phase1

`endif // APB_MASTER_DRIVER_SV1
