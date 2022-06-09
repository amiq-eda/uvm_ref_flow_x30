// IVB8 checksum8: 3251807609
/*-----------------------------------------------------------------
File8 name     : ahb_master_monitor8.sv
Created8       : Wed8 May8 19 15:42:21 2010
Description8   : This8 file implements8 the master8 monitor8.
              : The master8 monitor8 monitors8 the activity8 of
              : its interface bus.
Notes8         :
-----------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV8
`define AHB_MASTER_MONITOR_SV8

//------------------------------------------------------------------------------
//
// CLASS8: ahb_master_monitor8
//
//------------------------------------------------------------------------------

class ahb_master_monitor8 extends uvm_monitor;

  // Virtual Interface8 for monitoring8 DUT signals8
  virtual interface ahb_if8 vif8;

  // Count8 transfers8 collected8
  int num_col8;
  event transaction_ended8;
 
  // The following8 two8 bits are used to control8 whether8 checks8 and coverage8 are
  // done in the monitor8
  bit checks_enable8 = 1;
  bit coverage_enable8 = 1;

  // This8 TLM port is used to connect the monitor8 to the scoreboard8
  uvm_analysis_port #(ahb_transfer8) item_collected_port8;

  // Current8 monitored8 transfer8
  protected ahb_transfer8 transfer8;

  // Covergroup8 for transfer8
  covergroup master_transfer_cg8;
    option.per_instance = 1;
    direction8 : coverpoint transfer8.direction8;
  endgroup : master_transfer_cg8
 
  // Provide8 UVM automation8 and utility8 methods8
  `uvm_component_utils_begin(ahb_master_monitor8)
    `uvm_field_int(checks_enable8, UVM_ALL_ON)
    `uvm_field_int(coverage_enable8, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor8 - required8 syntax8 for UVM automation8 and utilities8
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create8 the covergroup
    master_transfer_cg8 = new();
    master_transfer_cg8.set_inst_name("master_transfer_cg8");
    // Create8 the TLM port
    item_collected_port8 = new("item_collected_port8", this);
  endfunction : new

  // Additional8 class methods8
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer8();
  extern virtual protected function void perform_checks8();
  extern virtual protected function void perform_coverage8();
  extern virtual function void report();

endclass : ahb_master_monitor8

//UVM connect_phase
function void ahb_master_monitor8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if8)::get(this, "", "vif8", vif8))
   `uvm_error("NOVIF8",{"virtual interface must be set for: ",get_full_name(),".vif8"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor8::run_phase(uvm_phase phase);
    fork
      collect_transfer8();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB8-NOTE8 : REQUIRED8 : master8 Monitor8 : Monitors8
   -------------------------------------------------------------------------
   Modify8 the collect_transfers8() method to match your8 protocol8.
   Note8 that if you change/add signals8 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor8::collect_transfer8();
    // This8 monitor8 re-uses its data items for ALL8 transfers8
    transfer8 = ahb_transfer8::type_id::create("transfer8", this);
    forever begin
      @(posedge vif8.ahb_clock8 iff vif8.AHB_HTRANS8 === NONSEQ8);
      // Begin8 transaction recording8
      void'(begin_tr(transfer8, "AHB8 MASTER8 Monitor8"));
      transfer8.address = vif8.AHB_HADDR8;
      transfer8.direction8 = ahb_direction8'(vif8.AHB_HWRITE8);
      transfer8.hsize8 = ahb_transfer_size8'(0);  //Not used - hance8 assign dummy
      transfer8.burst = ahb_burst_kind8'(0);     //Not used - hance8 assign dummy
      @(posedge vif8.ahb_clock8 iff vif8.AHB_HREADY8 === 1);
      // End8 transaction recording8
        if(transfer8.direction8 == WRITE) 
          transfer8.data = vif8.AHB_HWDATA8;
        else
          transfer8.data = vif8.AHB_HRDATA8;
        ;
      @(posedge vif8.ahb_clock8 iff vif8.AHB_HREADY8 === 1);
    end_tr(transfer8);
      `uvm_info(get_type_name(), 
        $psprintf("master8 transfer8 collected8 :\n%s", 
        transfer8.sprint()), UVM_HIGH)
      if (checks_enable8)
         perform_checks8();
      if (coverage_enable8)
         perform_coverage8();
      // Send8 transfer8 to scoreboard8 via TLM write()
      item_collected_port8.write(transfer8);
      -> transaction_ended8;
      num_col8++;
    end
  endtask : collect_transfer8
  
  /***************************************************************************
   IVB8-NOTE8 : OPTIONAL8 : master8 Monitor8 Protocol8 Checks8 : Checks8
   -------------------------------------------------------------------------
   Add protocol8 checks8 within the perform_checks8() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks8
  function void ahb_master_monitor8::perform_checks8();
    // Add checks8 here8
  endfunction : perform_checks8
  
 /***************************************************************************
  IVB8-NOTE8 : OPTIONAL8 : master8 Monitor8 Coverage8 : Coverage8
  -------------------------------------------------------------------------
  Modify8 the master_transfer_cg8 coverage8 group8 to match your8 protocol8.
  Add new coverage8 groups8, and edit8 the perform_coverage8() method to sample 
  them8.
  ***************************************************************************/

  // Triggers8 coverage8 events
  function void ahb_master_monitor8::perform_coverage8();
    master_transfer_cg8.sample();
  endfunction : perform_coverage8

  // UVM report() phase
  function void ahb_master_monitor8::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport8: AHB8 master8 monitor8 collected8 %0d transfers8", num_col8),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV8

