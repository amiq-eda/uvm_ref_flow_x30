// IVB17 checksum17: 3251807609
/*-----------------------------------------------------------------
File17 name     : ahb_master_monitor17.sv
Created17       : Wed17 May17 19 15:42:21 2010
Description17   : This17 file implements17 the master17 monitor17.
              : The master17 monitor17 monitors17 the activity17 of
              : its interface bus.
Notes17         :
-----------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV17
`define AHB_MASTER_MONITOR_SV17

//------------------------------------------------------------------------------
//
// CLASS17: ahb_master_monitor17
//
//------------------------------------------------------------------------------

class ahb_master_monitor17 extends uvm_monitor;

  // Virtual Interface17 for monitoring17 DUT signals17
  virtual interface ahb_if17 vif17;

  // Count17 transfers17 collected17
  int num_col17;
  event transaction_ended17;
 
  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done in the monitor17
  bit checks_enable17 = 1;
  bit coverage_enable17 = 1;

  // This17 TLM port is used to connect the monitor17 to the scoreboard17
  uvm_analysis_port #(ahb_transfer17) item_collected_port17;

  // Current17 monitored17 transfer17
  protected ahb_transfer17 transfer17;

  // Covergroup17 for transfer17
  covergroup master_transfer_cg17;
    option.per_instance = 1;
    direction17 : coverpoint transfer17.direction17;
  endgroup : master_transfer_cg17
 
  // Provide17 UVM automation17 and utility17 methods17
  `uvm_component_utils_begin(ahb_master_monitor17)
    `uvm_field_int(checks_enable17, UVM_ALL_ON)
    `uvm_field_int(coverage_enable17, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create17 the covergroup
    master_transfer_cg17 = new();
    master_transfer_cg17.set_inst_name("master_transfer_cg17");
    // Create17 the TLM port
    item_collected_port17 = new("item_collected_port17", this);
  endfunction : new

  // Additional17 class methods17
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer17();
  extern virtual protected function void perform_checks17();
  extern virtual protected function void perform_coverage17();
  extern virtual function void report();

endclass : ahb_master_monitor17

//UVM connect_phase
function void ahb_master_monitor17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if17)::get(this, "", "vif17", vif17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor17::run_phase(uvm_phase phase);
    fork
      collect_transfer17();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB17-NOTE17 : REQUIRED17 : master17 Monitor17 : Monitors17
   -------------------------------------------------------------------------
   Modify17 the collect_transfers17() method to match your17 protocol17.
   Note17 that if you change/add signals17 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor17::collect_transfer17();
    // This17 monitor17 re-uses its data items for ALL17 transfers17
    transfer17 = ahb_transfer17::type_id::create("transfer17", this);
    forever begin
      @(posedge vif17.ahb_clock17 iff vif17.AHB_HTRANS17 === NONSEQ17);
      // Begin17 transaction recording17
      void'(begin_tr(transfer17, "AHB17 MASTER17 Monitor17"));
      transfer17.address = vif17.AHB_HADDR17;
      transfer17.direction17 = ahb_direction17'(vif17.AHB_HWRITE17);
      transfer17.hsize17 = ahb_transfer_size17'(0);  //Not used - hance17 assign dummy
      transfer17.burst = ahb_burst_kind17'(0);     //Not used - hance17 assign dummy
      @(posedge vif17.ahb_clock17 iff vif17.AHB_HREADY17 === 1);
      // End17 transaction recording17
        if(transfer17.direction17 == WRITE) 
          transfer17.data = vif17.AHB_HWDATA17;
        else
          transfer17.data = vif17.AHB_HRDATA17;
        ;
      @(posedge vif17.ahb_clock17 iff vif17.AHB_HREADY17 === 1);
    end_tr(transfer17);
      `uvm_info(get_type_name(), 
        $psprintf("master17 transfer17 collected17 :\n%s", 
        transfer17.sprint()), UVM_HIGH)
      if (checks_enable17)
         perform_checks17();
      if (coverage_enable17)
         perform_coverage17();
      // Send17 transfer17 to scoreboard17 via TLM write()
      item_collected_port17.write(transfer17);
      -> transaction_ended17;
      num_col17++;
    end
  endtask : collect_transfer17
  
  /***************************************************************************
   IVB17-NOTE17 : OPTIONAL17 : master17 Monitor17 Protocol17 Checks17 : Checks17
   -------------------------------------------------------------------------
   Add protocol17 checks17 within the perform_checks17() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks17
  function void ahb_master_monitor17::perform_checks17();
    // Add checks17 here17
  endfunction : perform_checks17
  
 /***************************************************************************
  IVB17-NOTE17 : OPTIONAL17 : master17 Monitor17 Coverage17 : Coverage17
  -------------------------------------------------------------------------
  Modify17 the master_transfer_cg17 coverage17 group17 to match your17 protocol17.
  Add new coverage17 groups17, and edit17 the perform_coverage17() method to sample 
  them17.
  ***************************************************************************/

  // Triggers17 coverage17 events
  function void ahb_master_monitor17::perform_coverage17();
    master_transfer_cg17.sample();
  endfunction : perform_coverage17

  // UVM report() phase
  function void ahb_master_monitor17::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport17: AHB17 master17 monitor17 collected17 %0d transfers17", num_col17),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV17

