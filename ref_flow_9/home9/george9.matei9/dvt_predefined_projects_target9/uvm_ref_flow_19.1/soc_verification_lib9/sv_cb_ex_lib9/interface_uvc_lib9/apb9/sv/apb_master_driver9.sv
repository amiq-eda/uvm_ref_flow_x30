/*******************************************************************************
  FILE : apb_master_driver9.sv
*******************************************************************************/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef APB_MASTER_DRIVER_SV9
`define APB_MASTER_DRIVER_SV9

//------------------------------------------------------------------------------
// CLASS9: apb_master_driver9 declaration9
//------------------------------------------------------------------------------

class apb_master_driver9 extends uvm_driver #(apb_transfer9);

  // The virtual interface used to drive9 and view9 HDL signals9.
  virtual apb_if9 vif9;
  
  // A pointer9 to the configuration unit9 of the agent9
  apb_config9 cfg;
  
  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(apb_master_driver9)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  // Constructor9 which calls super.new() with appropriate9 parameters9.
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive9();
  extern virtual protected task reset();
  extern virtual protected task drive_transfer9 (apb_transfer9 trans9);
  extern virtual protected task drive_address_phase9 (apb_transfer9 trans9);
  extern virtual protected task drive_data_phase9 (apb_transfer9 trans9);

endclass : apb_master_driver9

// UVM build_phase
function void apb_master_driver9::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config9)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG9", "apb_config9 not set for this component")
endfunction : build_phase

// UVM connect_phase - gets9 the vif9 as a config property
function void apb_master_driver9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual apb_if9)::get(this, "", "vif9", vif9))
    `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

// Declaration9 of the UVM run_phase method.
task apb_master_driver9::run_phase(uvm_phase phase);
  get_and_drive9();
endtask : run_phase

// This9 task manages9 the interaction9 between the sequencer and driver
task apb_master_driver9::get_and_drive9();
  while (1) begin
    reset();
    fork 
      @(negedge vif9.preset9)
        // APB_MASTER_DRIVER9 tag9 required9 for Debug9 Labs9
        `uvm_info("APB_MASTER_DRIVER9", "get_and_drive9: Reset9 dropped", UVM_MEDIUM)
      begin
        // This9 thread9 will be killed at reset
        forever begin
          @(posedge vif9.pclock9 iff (vif9.preset9))
          seq_item_port.get_next_item(req);
          drive_transfer9(req);
          seq_item_port.item_done(req);
        end
      end
      join_any
      disable fork;
      //If9 we9 are in the middle9 of a transfer9, need to end the tx9. Also9,
      //do any reset cleanup9 here9. The only way9 we9 got9 to this point is via
      //a reset.
      if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive9

// Drive9 all signals9 to reset state 
task apb_master_driver9::reset();
  // If9 the reset is not active, then9 wait for it to become9 active before
  // resetting9 the interface.
  wait(!vif9.preset9);
  // APB_MASTER_DRIVER9 tag9 required9 for Debug9 Labs9
  `uvm_info("APB_MASTER_DRIVER9", $psprintf("Reset9 observed9"), UVM_MEDIUM)
  vif9.paddr9     <= 'h0;
  vif9.pwdata9    <= 'h0;
  vif9.prwd9      <= 'b0;
  vif9.psel9      <= 'b0;
  vif9.penable9   <= 'b0;
endtask : reset

// Drives9 a transfer9 when an item is ready to be sent9.
task apb_master_driver9::drive_transfer9 (apb_transfer9 trans9);
  void'(this.begin_tr(trans9, "apb9 master9 driver", "UVM Debug9",
       "APB9 master9 driver transaction from get_and_drive9"));
  if (trans9.transmit_delay9 > 0) begin
    repeat(trans9.transmit_delay9) @(posedge vif9.pclock9);
  end
  drive_address_phase9(trans9);
  drive_data_phase9(trans9);
  // APB_MASTER_DRIVER_TR9 tag9 required9 for Debug9 Labs9
  `uvm_info("APB_MASTER_DRIVER_TR9", $psprintf("APB9 Finished Driving9 Transfer9 \n%s",
            trans9.sprint()), UVM_HIGH)
  this.end_tr(trans9);
endtask : drive_transfer9

// Drive9 the address phase of the transfer9
task apb_master_driver9::drive_address_phase9 (apb_transfer9 trans9);
  int slave_indx9;
  slave_indx9 = cfg.get_slave_psel_by_addr9(trans9.addr);
  vif9.paddr9 <= trans9.addr;
  vif9.psel9 <= (1<<slave_indx9);
  vif9.penable9 <= 0;
  if (trans9.direction9 == APB_READ9) begin
    vif9.prwd9 <= 1'b0;
  end    
  else begin
    vif9.prwd9 <= 1'b1;
    vif9.pwdata9 <= trans9.data;
  end
  @(posedge vif9.pclock9);
endtask : drive_address_phase9

// Drive9 the data phase of the transfer9
task apb_master_driver9::drive_data_phase9 (apb_transfer9 trans9);
  vif9.penable9 <= 1;
  @(posedge vif9.pclock9 iff vif9.pready9); 
  if (trans9.direction9 == APB_READ9) begin
    trans9.data = vif9.prdata9;
  end
  vif9.penable9 <= 0;
  vif9.psel9    <= 0;
endtask : drive_data_phase9

`endif // APB_MASTER_DRIVER_SV9
