/*******************************************************************************
  FILE : apb_master_driver21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV21
`define APB_MASTER_DRIVER_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_master_driver21 declaration21
//------------------------------------------------------------------------------

class apb_master_driver21 extends uvm_driver #(apb_transfer21);

  // The virtual interface used to drive21 and view21 HDL signals21.
  virtual apb_if21 vif21;
  
  // A pointer21 to the configuration unit21 of the agent21
  apb_config21 cfg;
  
  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver21)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor21 which calls super.new() with appropriate21 parameters21.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive21();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer21 (apb_transfer21 trans21);
  extern virtual protected task drive_address_phase21 (apb_transfer21 trans21);
  extern virtual protected task drive_data_phase21 (apb_transfer21 trans21);

endclass : apb_master_driver21

// UVM build_phase
function void apb_master_driver21::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config21)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG21", "apb_config21 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets21 the vif21 as a config property
function void apb_master_driver21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if21)::get(this, "", "vif21", vif21))
    `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

// Declaration21 of the UVM run_phase method.
task apb_master_driver21::run_phase(uvm_phase phase);
  get_and_drive21();
endtask : run_phase

// This21 task manages21 the interaction21 between the sequencer and driver
task apb_master_driver21::get_and_drive21();
  while (1) begin
    reset();
    fork 
      @(negedge vif21.preset21)
        // APB_MASTER_DRIVER21 tag21 required21 for Debug21 Labs21
        `uvm_info("APB_MASTER_DRIVER21", "get_and_drive21: Reset21 dropped", UVM_MEDIUM)
      begin
        // This21 thread21 will be killed at reset
        forever begin
          @(posedge vif21.pclock21 iff (vif21.preset21))
          seq_item_port.get_next_item(req);
          drive_transfer21(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If21 we21 are in the middle21 of a transfer21, need to end the tx21. Also21,
      //do any reset cleanup21 here21. The only way21 we21 got21 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive21

// Drive21 all signals21 to reset state 
task apb_master_driver21::reset();
  // If21 the reset is not active, then21 wait for it to become21 active before
  // resetting21 the interface.
  wait(!vif21.preset21);
  // APB_MASTER_DRIVER21 tag21 required21 for Debug21 Labs21
  `uvm_info("APB_MASTER_DRIVER21", $psprintf("Reset21 observed21"), UVM_MEDIUM)
  vif21.paddr21     <= 'h0;
  vif21.pwdata21    <= 'h0;
  vif21.prwd21      <= 'b0;
  vif21.psel21      <= 'b0;
  vif21.penable21   <= 'b0;
endtask : reset

// Drives21 a transfer21 when an item is ready to be sent21.
task apb_master_driver21::drive_transfer21 (apb_transfer21 trans21);
  void'(this.begin_tr(trans21, "apb21 master21 driver", "UVM Debug21",
       "APB21 master21 driver transaction from get_and_drive21"));
  if (trans21.transmit_delay21 > 0) begin
    repeat(trans21.transmit_delay21) @(posedge vif21.pclock21);
  end
  drive_address_phase21(trans21);
  drive_data_phase21(trans21);
  // APB_MASTER_DRIVER_TR21 tag21 required21 for Debug21 Labs21
  `uvm_info("APB_MASTER_DRIVER_TR21", $psprintf("APB21 Finished Driving21 Transfer21 \n%s",
            trans21.sprint()), UVM_HIGH)
  this.end_tr(trans21);
endtask : drive_transfer21

// Drive21 the address phase of the transfer21
task apb_master_driver21::drive_address_phase21 (apb_transfer21 trans21);
  int slave_indx21;
  slave_indx21 = cfg.get_slave_psel_by_addr21(trans21.addr);
  vif21.paddr21 <= trans21.addr;
  vif21.psel21 <= (1<<slave_indx21);
  vif21.penable21 <= 0;
  if (trans21.direction21 == APB_READ21) begin
    vif21.prwd21 <= 1'b0;
  end    
  else begin
    vif21.prwd21 <= 1'b1;
    vif21.pwdata21 <= trans21.data;
  end
  @(posedge vif21.pclock21);
endtask : drive_address_phase21

// Drive21 the data phase of the transfer21
task apb_master_driver21::drive_data_phase21 (apb_transfer21 trans21);
  vif21.penable21 <= 1;
  @(posedge vif21.pclock21 iff vif21.pready21); 
  if (trans21.direction21 == APB_READ21) begin
    trans21.data = vif21.prdata21;
  end
  vif21.penable21 <= 0;
  vif21.psel21    <= 0;
endtask : drive_data_phase21

`endif // APB_MASTER_DRIVER_SV21
