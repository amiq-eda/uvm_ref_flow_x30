/*******************************************************************************
  FILE : apb_master_driver6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV6
`define APB_MASTER_DRIVER_SV6

//------------------------------------------------------------------------------
// CLASS6: apb_master_driver6 declaration6
//------------------------------------------------------------------------------

class apb_master_driver6 extends uvm_driver #(apb_transfer6);

  // The virtual interface used to drive6 and view6 HDL signals6.
  virtual apb_if6 vif6;
  
  // A pointer6 to the configuration unit6 of the agent6
  apb_config6 cfg;
  
  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver6)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor6 which calls super.new() with appropriate6 parameters6.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive6();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer6 (apb_transfer6 trans6);
  extern virtual protected task drive_address_phase6 (apb_transfer6 trans6);
  extern virtual protected task drive_data_phase6 (apb_transfer6 trans6);

endclass : apb_master_driver6

// UVM build_phase
function void apb_master_driver6::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config6)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG6", "apb_config6 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets6 the vif6 as a config property
function void apb_master_driver6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if6)::get(this, "", "vif6", vif6))
    `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

// Declaration6 of the UVM run_phase method.
task apb_master_driver6::run_phase(uvm_phase phase);
  get_and_drive6();
endtask : run_phase

// This6 task manages6 the interaction6 between the sequencer and driver
task apb_master_driver6::get_and_drive6();
  while (1) begin
    reset();
    fork 
      @(negedge vif6.preset6)
        // APB_MASTER_DRIVER6 tag6 required6 for Debug6 Labs6
        `uvm_info("APB_MASTER_DRIVER6", "get_and_drive6: Reset6 dropped", UVM_MEDIUM)
      begin
        // This6 thread6 will be killed at reset
        forever begin
          @(posedge vif6.pclock6 iff (vif6.preset6))
          seq_item_port.get_next_item(req);
          drive_transfer6(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If6 we6 are in the middle6 of a transfer6, need to end the tx6. Also6,
      //do any reset cleanup6 here6. The only way6 we6 got6 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive6

// Drive6 all signals6 to reset state 
task apb_master_driver6::reset();
  // If6 the reset is not active, then6 wait for it to become6 active before
  // resetting6 the interface.
  wait(!vif6.preset6);
  // APB_MASTER_DRIVER6 tag6 required6 for Debug6 Labs6
  `uvm_info("APB_MASTER_DRIVER6", $psprintf("Reset6 observed6"), UVM_MEDIUM)
  vif6.paddr6     <= 'h0;
  vif6.pwdata6    <= 'h0;
  vif6.prwd6      <= 'b0;
  vif6.psel6      <= 'b0;
  vif6.penable6   <= 'b0;
endtask : reset

// Drives6 a transfer6 when an item is ready to be sent6.
task apb_master_driver6::drive_transfer6 (apb_transfer6 trans6);
  void'(this.begin_tr(trans6, "apb6 master6 driver", "UVM Debug6",
       "APB6 master6 driver transaction from get_and_drive6"));
  if (trans6.transmit_delay6 > 0) begin
    repeat(trans6.transmit_delay6) @(posedge vif6.pclock6);
  end
  drive_address_phase6(trans6);
  drive_data_phase6(trans6);
  // APB_MASTER_DRIVER_TR6 tag6 required6 for Debug6 Labs6
  `uvm_info("APB_MASTER_DRIVER_TR6", $psprintf("APB6 Finished Driving6 Transfer6 \n%s",
            trans6.sprint()), UVM_HIGH)
  this.end_tr(trans6);
endtask : drive_transfer6

// Drive6 the address phase of the transfer6
task apb_master_driver6::drive_address_phase6 (apb_transfer6 trans6);
  int slave_indx6;
  slave_indx6 = cfg.get_slave_psel_by_addr6(trans6.addr);
  vif6.paddr6 <= trans6.addr;
  vif6.psel6 <= (1<<slave_indx6);
  vif6.penable6 <= 0;
  if (trans6.direction6 == APB_READ6) begin
    vif6.prwd6 <= 1'b0;
  end    
  else begin
    vif6.prwd6 <= 1'b1;
    vif6.pwdata6 <= trans6.data;
  end
  @(posedge vif6.pclock6);
endtask : drive_address_phase6

// Drive6 the data phase of the transfer6
task apb_master_driver6::drive_data_phase6 (apb_transfer6 trans6);
  vif6.penable6 <= 1;
  @(posedge vif6.pclock6 iff vif6.pready6); 
  if (trans6.direction6 == APB_READ6) begin
    trans6.data = vif6.prdata6;
  end
  vif6.penable6 <= 0;
  vif6.psel6    <= 0;
endtask : drive_data_phase6

`endif // APB_MASTER_DRIVER_SV6
