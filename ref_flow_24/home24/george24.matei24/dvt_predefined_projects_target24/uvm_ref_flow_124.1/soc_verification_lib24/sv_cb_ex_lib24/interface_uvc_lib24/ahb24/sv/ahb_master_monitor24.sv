// IVB24 checksum24: 3251807609
/*-----------------------------------------------------------------
File24 name     : ahb_master_monitor24.sv
Created24       : Wed24 May24 19 15:42:21 2010
Description24   : This24 file implements24 the master24 monitor24.
              : The master24 monitor24 monitors24 the activity24 of
              : its interface bus.
Notes24         :
-----------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV24
`define AHB_MASTER_MONITOR_SV24

//------------------------------------------------------------------------------
//
// CLASS24: ahb_master_monitor24
//
//------------------------------------------------------------------------------

class ahb_master_monitor24 extends uvm_monitor;

  // Virtual Interface24 for monitoring24 DUT signals24
  virtual interface ahb_if24 vif24;

  // Count24 transfers24 collected24
  int num_col24;
  event transaction_ended24;
 
  // The following24 two24 bits are used to control24 whether24 checks24 and coverage24 are
  // done in the monitor24
  bit checks_enable24 = 1;
  bit coverage_enable24 = 1;

  // This24 TLM port is used to connect the monitor24 to the scoreboard24
  uvm_analysis_port #(ahb_transfer24) item_collected_port24;

  // Current24 monitored24 transfer24
  protected ahb_transfer24 transfer24;

  // Covergroup24 for transfer24
  covergroup master_transfer_cg24;
    option.per_instance = 1;
    direction24 : coverpoint transfer24.direction24;
  endgroup : master_transfer_cg24
 
  // Provide24 UVM automation24 and utility24 methods24
  `uvm_component_utils_begin(ahb_master_monitor24)
    `uvm_field_int(checks_enable24, UVM_ALL_ON)
    `uvm_field_int(coverage_enable24, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor24 - required24 syntax24 for UVM automation24 and utilities24
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create24 the covergroup
    master_transfer_cg24 = new();
    master_transfer_cg24.set_inst_name("master_transfer_cg24");
    // Create24 the TLM port
    item_collected_port24 = new("item_collected_port24", this);
  endfunction : new

  // Additional24 class methods24
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer24();
  extern virtual protected function void perform_checks24();
  extern virtual protected function void perform_coverage24();
  extern virtual function void report();

endclass : ahb_master_monitor24

//UVM connect_phase
function void ahb_master_monitor24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if24)::get(this, "", "vif24", vif24))
   `uvm_error("NOVIF24",{"virtual interface must be set for: ",get_full_name(),".vif24"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor24::run_phase(uvm_phase phase);
    fork
      collect_transfer24();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB24-NOTE24 : REQUIRED24 : master24 Monitor24 : Monitors24
   -------------------------------------------------------------------------
   Modify24 the collect_transfers24() method to match your24 protocol24.
   Note24 that if you change/add signals24 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor24::collect_transfer24();
    // This24 monitor24 re-uses its data items for ALL24 transfers24
    transfer24 = ahb_transfer24::type_id::create("transfer24", this);
    forever begin
      @(posedge vif24.ahb_clock24 iff vif24.AHB_HTRANS24 === NONSEQ24);
      // Begin24 transaction recording24
      void'(begin_tr(transfer24, "AHB24 MASTER24 Monitor24"));
      transfer24.address = vif24.AHB_HADDR24;
      transfer24.direction24 = ahb_direction24'(vif24.AHB_HWRITE24);
      transfer24.hsize24 = ahb_transfer_size24'(0);  //Not used - hance24 assign dummy
      transfer24.burst = ahb_burst_kind24'(0);     //Not used - hance24 assign dummy
      @(posedge vif24.ahb_clock24 iff vif24.AHB_HREADY24 === 1);
      // End24 transaction recording24
        if(transfer24.direction24 == WRITE) 
          transfer24.data = vif24.AHB_HWDATA24;
        else
          transfer24.data = vif24.AHB_HRDATA24;
        ;
      @(posedge vif24.ahb_clock24 iff vif24.AHB_HREADY24 === 1);
    end_tr(transfer24);
      `uvm_info(get_type_name(), 
        $psprintf("master24 transfer24 collected24 :\n%s", 
        transfer24.sprint()), UVM_HIGH)
      if (checks_enable24)
         perform_checks24();
      if (coverage_enable24)
         perform_coverage24();
      // Send24 transfer24 to scoreboard24 via TLM write()
      item_collected_port24.write(transfer24);
      -> transaction_ended24;
      num_col24++;
    end
  endtask : collect_transfer24
  
  /***************************************************************************
   IVB24-NOTE24 : OPTIONAL24 : master24 Monitor24 Protocol24 Checks24 : Checks24
   -------------------------------------------------------------------------
   Add protocol24 checks24 within the perform_checks24() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks24
  function void ahb_master_monitor24::perform_checks24();
    // Add checks24 here24
  endfunction : perform_checks24
  
 /***************************************************************************
  IVB24-NOTE24 : OPTIONAL24 : master24 Monitor24 Coverage24 : Coverage24
  -------------------------------------------------------------------------
  Modify24 the master_transfer_cg24 coverage24 group24 to match your24 protocol24.
  Add new coverage24 groups24, and edit24 the perform_coverage24() method to sample 
  them24.
  ***************************************************************************/

  // Triggers24 coverage24 events
  function void ahb_master_monitor24::perform_coverage24();
    master_transfer_cg24.sample();
  endfunction : perform_coverage24

  // UVM report() phase
  function void ahb_master_monitor24::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport24: AHB24 master24 monitor24 collected24 %0d transfers24", num_col24),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV24

