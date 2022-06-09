// IVB18 checksum18: 3251807609
/*-----------------------------------------------------------------
File18 name     : ahb_master_monitor18.sv
Created18       : Wed18 May18 19 15:42:21 2010
Description18   : This18 file implements18 the master18 monitor18.
              : The master18 monitor18 monitors18 the activity18 of
              : its interface bus.
Notes18         :
-----------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV18
`define AHB_MASTER_MONITOR_SV18

//------------------------------------------------------------------------------
//
// CLASS18: ahb_master_monitor18
//
//------------------------------------------------------------------------------

class ahb_master_monitor18 extends uvm_monitor;

  // Virtual Interface18 for monitoring18 DUT signals18
  virtual interface ahb_if18 vif18;

  // Count18 transfers18 collected18
  int num_col18;
  event transaction_ended18;
 
  // The following18 two18 bits are used to control18 whether18 checks18 and coverage18 are
  // done in the monitor18
  bit checks_enable18 = 1;
  bit coverage_enable18 = 1;

  // This18 TLM port is used to connect the monitor18 to the scoreboard18
  uvm_analysis_port #(ahb_transfer18) item_collected_port18;

  // Current18 monitored18 transfer18
  protected ahb_transfer18 transfer18;

  // Covergroup18 for transfer18
  covergroup master_transfer_cg18;
    option.per_instance = 1;
    direction18 : coverpoint transfer18.direction18;
  endgroup : master_transfer_cg18
 
  // Provide18 UVM automation18 and utility18 methods18
  `uvm_component_utils_begin(ahb_master_monitor18)
    `uvm_field_int(checks_enable18, UVM_ALL_ON)
    `uvm_field_int(coverage_enable18, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor18 - required18 syntax18 for UVM automation18 and utilities18
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create18 the covergroup
    master_transfer_cg18 = new();
    master_transfer_cg18.set_inst_name("master_transfer_cg18");
    // Create18 the TLM port
    item_collected_port18 = new("item_collected_port18", this);
  endfunction : new

  // Additional18 class methods18
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer18();
  extern virtual protected function void perform_checks18();
  extern virtual protected function void perform_coverage18();
  extern virtual function void report();

endclass : ahb_master_monitor18

//UVM connect_phase
function void ahb_master_monitor18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if18)::get(this, "", "vif18", vif18))
   `uvm_error("NOVIF18",{"virtual interface must be set for: ",get_full_name(),".vif18"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor18::run_phase(uvm_phase phase);
    fork
      collect_transfer18();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB18-NOTE18 : REQUIRED18 : master18 Monitor18 : Monitors18
   -------------------------------------------------------------------------
   Modify18 the collect_transfers18() method to match your18 protocol18.
   Note18 that if you change/add signals18 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor18::collect_transfer18();
    // This18 monitor18 re-uses its data items for ALL18 transfers18
    transfer18 = ahb_transfer18::type_id::create("transfer18", this);
    forever begin
      @(posedge vif18.ahb_clock18 iff vif18.AHB_HTRANS18 === NONSEQ18);
      // Begin18 transaction recording18
      void'(begin_tr(transfer18, "AHB18 MASTER18 Monitor18"));
      transfer18.address = vif18.AHB_HADDR18;
      transfer18.direction18 = ahb_direction18'(vif18.AHB_HWRITE18);
      transfer18.hsize18 = ahb_transfer_size18'(0);  //Not used - hance18 assign dummy
      transfer18.burst = ahb_burst_kind18'(0);     //Not used - hance18 assign dummy
      @(posedge vif18.ahb_clock18 iff vif18.AHB_HREADY18 === 1);
      // End18 transaction recording18
        if(transfer18.direction18 == WRITE) 
          transfer18.data = vif18.AHB_HWDATA18;
        else
          transfer18.data = vif18.AHB_HRDATA18;
        ;
      @(posedge vif18.ahb_clock18 iff vif18.AHB_HREADY18 === 1);
    end_tr(transfer18);
      `uvm_info(get_type_name(), 
        $psprintf("master18 transfer18 collected18 :\n%s", 
        transfer18.sprint()), UVM_HIGH)
      if (checks_enable18)
         perform_checks18();
      if (coverage_enable18)
         perform_coverage18();
      // Send18 transfer18 to scoreboard18 via TLM write()
      item_collected_port18.write(transfer18);
      -> transaction_ended18;
      num_col18++;
    end
  endtask : collect_transfer18
  
  /***************************************************************************
   IVB18-NOTE18 : OPTIONAL18 : master18 Monitor18 Protocol18 Checks18 : Checks18
   -------------------------------------------------------------------------
   Add protocol18 checks18 within the perform_checks18() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks18
  function void ahb_master_monitor18::perform_checks18();
    // Add checks18 here18
  endfunction : perform_checks18
  
 /***************************************************************************
  IVB18-NOTE18 : OPTIONAL18 : master18 Monitor18 Coverage18 : Coverage18
  -------------------------------------------------------------------------
  Modify18 the master_transfer_cg18 coverage18 group18 to match your18 protocol18.
  Add new coverage18 groups18, and edit18 the perform_coverage18() method to sample 
  them18.
  ***************************************************************************/

  // Triggers18 coverage18 events
  function void ahb_master_monitor18::perform_coverage18();
    master_transfer_cg18.sample();
  endfunction : perform_coverage18

  // UVM report() phase
  function void ahb_master_monitor18::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport18: AHB18 master18 monitor18 collected18 %0d transfers18", num_col18),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV18

