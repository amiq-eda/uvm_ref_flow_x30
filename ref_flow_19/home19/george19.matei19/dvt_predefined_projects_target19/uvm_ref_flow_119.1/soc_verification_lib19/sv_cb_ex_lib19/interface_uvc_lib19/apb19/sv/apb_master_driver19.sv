/*******************************************************************************
  FILE : apb_master_driver19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV19
`define APB_MASTER_DRIVER_SV19

//------------------------------------------------------------------------------
// CLASS19: apb_master_driver19 declaration19
//------------------------------------------------------------------------------

class apb_master_driver19 extends uvm_driver #(apb_transfer19);

  // The virtual interface used to drive19 and view19 HDL signals19.
  virtual apb_if19 vif19;
  
  // A pointer19 to the configuration unit19 of the agent19
  apb_config19 cfg;
  
  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver19)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor19 which calls super.new() with appropriate19 parameters19.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive19();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer19 (apb_transfer19 trans19);
  extern virtual protected task drive_address_phase19 (apb_transfer19 trans19);
  extern virtual protected task drive_data_phase19 (apb_transfer19 trans19);

endclass : apb_master_driver19

// UVM build_phase
function void apb_master_driver19::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config19)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG19", "apb_config19 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets19 the vif19 as a config property
function void apb_master_driver19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if19)::get(this, "", "vif19", vif19))
    `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

// Declaration19 of the UVM run_phase method.
task apb_master_driver19::run_phase(uvm_phase phase);
  get_and_drive19();
endtask : run_phase

// This19 task manages19 the interaction19 between the sequencer and driver
task apb_master_driver19::get_and_drive19();
  while (1) begin
    reset();
    fork 
      @(negedge vif19.preset19)
        // APB_MASTER_DRIVER19 tag19 required19 for Debug19 Labs19
        `uvm_info("APB_MASTER_DRIVER19", "get_and_drive19: Reset19 dropped", UVM_MEDIUM)
      begin
        // This19 thread19 will be killed at reset
        forever begin
          @(posedge vif19.pclock19 iff (vif19.preset19))
          seq_item_port.get_next_item(req);
          drive_transfer19(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If19 we19 are in the middle19 of a transfer19, need to end the tx19. Also19,
      //do any reset cleanup19 here19. The only way19 we19 got19 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive19

// Drive19 all signals19 to reset state 
task apb_master_driver19::reset();
  // If19 the reset is not active, then19 wait for it to become19 active before
  // resetting19 the interface.
  wait(!vif19.preset19);
  // APB_MASTER_DRIVER19 tag19 required19 for Debug19 Labs19
  `uvm_info("APB_MASTER_DRIVER19", $psprintf("Reset19 observed19"), UVM_MEDIUM)
  vif19.paddr19     <= 'h0;
  vif19.pwdata19    <= 'h0;
  vif19.prwd19      <= 'b0;
  vif19.psel19      <= 'b0;
  vif19.penable19   <= 'b0;
endtask : reset

// Drives19 a transfer19 when an item is ready to be sent19.
task apb_master_driver19::drive_transfer19 (apb_transfer19 trans19);
  void'(this.begin_tr(trans19, "apb19 master19 driver", "UVM Debug19",
       "APB19 master19 driver transaction from get_and_drive19"));
  if (trans19.transmit_delay19 > 0) begin
    repeat(trans19.transmit_delay19) @(posedge vif19.pclock19);
  end
  drive_address_phase19(trans19);
  drive_data_phase19(trans19);
  // APB_MASTER_DRIVER_TR19 tag19 required19 for Debug19 Labs19
  `uvm_info("APB_MASTER_DRIVER_TR19", $psprintf("APB19 Finished Driving19 Transfer19 \n%s",
            trans19.sprint()), UVM_HIGH)
  this.end_tr(trans19);
endtask : drive_transfer19

// Drive19 the address phase of the transfer19
task apb_master_driver19::drive_address_phase19 (apb_transfer19 trans19);
  int slave_indx19;
  slave_indx19 = cfg.get_slave_psel_by_addr19(trans19.addr);
  vif19.paddr19 <= trans19.addr;
  vif19.psel19 <= (1<<slave_indx19);
  vif19.penable19 <= 0;
  if (trans19.direction19 == APB_READ19) begin
    vif19.prwd19 <= 1'b0;
  end    
  else begin
    vif19.prwd19 <= 1'b1;
    vif19.pwdata19 <= trans19.data;
  end
  @(posedge vif19.pclock19);
endtask : drive_address_phase19

// Drive19 the data phase of the transfer19
task apb_master_driver19::drive_data_phase19 (apb_transfer19 trans19);
  vif19.penable19 <= 1;
  @(posedge vif19.pclock19 iff vif19.pready19); 
  if (trans19.direction19 == APB_READ19) begin
    trans19.data = vif19.prdata19;
  end
  vif19.penable19 <= 0;
  vif19.psel19    <= 0;
endtask : drive_data_phase19

`endif // APB_MASTER_DRIVER_SV19
