// IVB29 checksum29: 3251807609
/*-----------------------------------------------------------------
File29 name     : ahb_master_monitor29.sv
Created29       : Wed29 May29 19 15:42:21 2010
Description29   : This29 file implements29 the master29 monitor29.
              : The master29 monitor29 monitors29 the activity29 of
              : its interface bus.
Notes29         :
-----------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV29
`define AHB_MASTER_MONITOR_SV29

//------------------------------------------------------------------------------
//
// CLASS29: ahb_master_monitor29
//
//------------------------------------------------------------------------------

class ahb_master_monitor29 extends uvm_monitor;

  // Virtual Interface29 for monitoring29 DUT signals29
  virtual interface ahb_if29 vif29;

  // Count29 transfers29 collected29
  int num_col29;
  event transaction_ended29;
 
  // The following29 two29 bits are used to control29 whether29 checks29 and coverage29 are
  // done in the monitor29
  bit checks_enable29 = 1;
  bit coverage_enable29 = 1;

  // This29 TLM port is used to connect the monitor29 to the scoreboard29
  uvm_analysis_port #(ahb_transfer29) item_collected_port29;

  // Current29 monitored29 transfer29
  protected ahb_transfer29 transfer29;

  // Covergroup29 for transfer29
  covergroup master_transfer_cg29;
    option.per_instance = 1;
    direction29 : coverpoint transfer29.direction29;
  endgroup : master_transfer_cg29
 
  // Provide29 UVM automation29 and utility29 methods29
  `uvm_component_utils_begin(ahb_master_monitor29)
    `uvm_field_int(checks_enable29, UVM_ALL_ON)
    `uvm_field_int(coverage_enable29, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor29 - required29 syntax29 for UVM automation29 and utilities29
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create29 the covergroup
    master_transfer_cg29 = new();
    master_transfer_cg29.set_inst_name("master_transfer_cg29");
    // Create29 the TLM port
    item_collected_port29 = new("item_collected_port29", this);
  endfunction : new

  // Additional29 class methods29
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer29();
  extern virtual protected function void perform_checks29();
  extern virtual protected function void perform_coverage29();
  extern virtual function void report();

endclass : ahb_master_monitor29

//UVM connect_phase
function void ahb_master_monitor29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if29)::get(this, "", "vif29", vif29))
   `uvm_error("NOVIF29",{"virtual interface must be set for: ",get_full_name(),".vif29"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor29::run_phase(uvm_phase phase);
    fork
      collect_transfer29();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB29-NOTE29 : REQUIRED29 : master29 Monitor29 : Monitors29
   -------------------------------------------------------------------------
   Modify29 the collect_transfers29() method to match your29 protocol29.
   Note29 that if you change/add signals29 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor29::collect_transfer29();
    // This29 monitor29 re-uses its data items for ALL29 transfers29
    transfer29 = ahb_transfer29::type_id::create("transfer29", this);
    forever begin
      @(posedge vif29.ahb_clock29 iff vif29.AHB_HTRANS29 === NONSEQ29);
      // Begin29 transaction recording29
      void'(begin_tr(transfer29, "AHB29 MASTER29 Monitor29"));
      transfer29.address = vif29.AHB_HADDR29;
      transfer29.direction29 = ahb_direction29'(vif29.AHB_HWRITE29);
      transfer29.hsize29 = ahb_transfer_size29'(0);  //Not used - hance29 assign dummy
      transfer29.burst = ahb_burst_kind29'(0);     //Not used - hance29 assign dummy
      @(posedge vif29.ahb_clock29 iff vif29.AHB_HREADY29 === 1);
      // End29 transaction recording29
        if(transfer29.direction29 == WRITE) 
          transfer29.data = vif29.AHB_HWDATA29;
        else
          transfer29.data = vif29.AHB_HRDATA29;
        ;
      @(posedge vif29.ahb_clock29 iff vif29.AHB_HREADY29 === 1);
    end_tr(transfer29);
      `uvm_info(get_type_name(), 
        $psprintf("master29 transfer29 collected29 :\n%s", 
        transfer29.sprint()), UVM_HIGH)
      if (checks_enable29)
         perform_checks29();
      if (coverage_enable29)
         perform_coverage29();
      // Send29 transfer29 to scoreboard29 via TLM write()
      item_collected_port29.write(transfer29);
      -> transaction_ended29;
      num_col29++;
    end
  endtask : collect_transfer29
  
  /***************************************************************************
   IVB29-NOTE29 : OPTIONAL29 : master29 Monitor29 Protocol29 Checks29 : Checks29
   -------------------------------------------------------------------------
   Add protocol29 checks29 within the perform_checks29() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks29
  function void ahb_master_monitor29::perform_checks29();
    // Add checks29 here29
  endfunction : perform_checks29
  
 /***************************************************************************
  IVB29-NOTE29 : OPTIONAL29 : master29 Monitor29 Coverage29 : Coverage29
  -------------------------------------------------------------------------
  Modify29 the master_transfer_cg29 coverage29 group29 to match your29 protocol29.
  Add new coverage29 groups29, and edit29 the perform_coverage29() method to sample 
  them29.
  ***************************************************************************/

  // Triggers29 coverage29 events
  function void ahb_master_monitor29::perform_coverage29();
    master_transfer_cg29.sample();
  endfunction : perform_coverage29

  // UVM report() phase
  function void ahb_master_monitor29::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport29: AHB29 master29 monitor29 collected29 %0d transfers29", num_col29),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV29

