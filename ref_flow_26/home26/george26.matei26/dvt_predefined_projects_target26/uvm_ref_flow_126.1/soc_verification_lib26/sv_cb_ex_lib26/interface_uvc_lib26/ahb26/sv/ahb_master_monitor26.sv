// IVB26 checksum26: 3251807609
/*-----------------------------------------------------------------
File26 name     : ahb_master_monitor26.sv
Created26       : Wed26 May26 19 15:42:21 2010
Description26   : This26 file implements26 the master26 monitor26.
              : The master26 monitor26 monitors26 the activity26 of
              : its interface bus.
Notes26         :
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV26
`define AHB_MASTER_MONITOR_SV26

//------------------------------------------------------------------------------
//
// CLASS26: ahb_master_monitor26
//
//------------------------------------------------------------------------------

class ahb_master_monitor26 extends uvm_monitor;

  // Virtual Interface26 for monitoring26 DUT signals26
  virtual interface ahb_if26 vif26;

  // Count26 transfers26 collected26
  int num_col26;
  event transaction_ended26;
 
  // The following26 two26 bits are used to control26 whether26 checks26 and coverage26 are
  // done in the monitor26
  bit checks_enable26 = 1;
  bit coverage_enable26 = 1;

  // This26 TLM port is used to connect the monitor26 to the scoreboard26
  uvm_analysis_port #(ahb_transfer26) item_collected_port26;

  // Current26 monitored26 transfer26
  protected ahb_transfer26 transfer26;

  // Covergroup26 for transfer26
  covergroup master_transfer_cg26;
    option.per_instance = 1;
    direction26 : coverpoint transfer26.direction26;
  endgroup : master_transfer_cg26
 
  // Provide26 UVM automation26 and utility26 methods26
  `uvm_component_utils_begin(ahb_master_monitor26)
    `uvm_field_int(checks_enable26, UVM_ALL_ON)
    `uvm_field_int(coverage_enable26, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create26 the covergroup
    master_transfer_cg26 = new();
    master_transfer_cg26.set_inst_name("master_transfer_cg26");
    // Create26 the TLM port
    item_collected_port26 = new("item_collected_port26", this);
  endfunction : new

  // Additional26 class methods26
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer26();
  extern virtual protected function void perform_checks26();
  extern virtual protected function void perform_coverage26();
  extern virtual function void report();

endclass : ahb_master_monitor26

//UVM connect_phase
function void ahb_master_monitor26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if26)::get(this, "", "vif26", vif26))
   `uvm_error("NOVIF26",{"virtual interface must be set for: ",get_full_name(),".vif26"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor26::run_phase(uvm_phase phase);
    fork
      collect_transfer26();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB26-NOTE26 : REQUIRED26 : master26 Monitor26 : Monitors26
   -------------------------------------------------------------------------
   Modify26 the collect_transfers26() method to match your26 protocol26.
   Note26 that if you change/add signals26 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor26::collect_transfer26();
    // This26 monitor26 re-uses its data items for ALL26 transfers26
    transfer26 = ahb_transfer26::type_id::create("transfer26", this);
    forever begin
      @(posedge vif26.ahb_clock26 iff vif26.AHB_HTRANS26 === NONSEQ26);
      // Begin26 transaction recording26
      void'(begin_tr(transfer26, "AHB26 MASTER26 Monitor26"));
      transfer26.address = vif26.AHB_HADDR26;
      transfer26.direction26 = ahb_direction26'(vif26.AHB_HWRITE26);
      transfer26.hsize26 = ahb_transfer_size26'(0);  //Not used - hance26 assign dummy
      transfer26.burst = ahb_burst_kind26'(0);     //Not used - hance26 assign dummy
      @(posedge vif26.ahb_clock26 iff vif26.AHB_HREADY26 === 1);
      // End26 transaction recording26
        if(transfer26.direction26 == WRITE) 
          transfer26.data = vif26.AHB_HWDATA26;
        else
          transfer26.data = vif26.AHB_HRDATA26;
        ;
      @(posedge vif26.ahb_clock26 iff vif26.AHB_HREADY26 === 1);
    end_tr(transfer26);
      `uvm_info(get_type_name(), 
        $psprintf("master26 transfer26 collected26 :\n%s", 
        transfer26.sprint()), UVM_HIGH)
      if (checks_enable26)
         perform_checks26();
      if (coverage_enable26)
         perform_coverage26();
      // Send26 transfer26 to scoreboard26 via TLM write()
      item_collected_port26.write(transfer26);
      -> transaction_ended26;
      num_col26++;
    end
  endtask : collect_transfer26
  
  /***************************************************************************
   IVB26-NOTE26 : OPTIONAL26 : master26 Monitor26 Protocol26 Checks26 : Checks26
   -------------------------------------------------------------------------
   Add protocol26 checks26 within the perform_checks26() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks26
  function void ahb_master_monitor26::perform_checks26();
    // Add checks26 here26
  endfunction : perform_checks26
  
 /***************************************************************************
  IVB26-NOTE26 : OPTIONAL26 : master26 Monitor26 Coverage26 : Coverage26
  -------------------------------------------------------------------------
  Modify26 the master_transfer_cg26 coverage26 group26 to match your26 protocol26.
  Add new coverage26 groups26, and edit26 the perform_coverage26() method to sample 
  them26.
  ***************************************************************************/

  // Triggers26 coverage26 events
  function void ahb_master_monitor26::perform_coverage26();
    master_transfer_cg26.sample();
  endfunction : perform_coverage26

  // UVM report() phase
  function void ahb_master_monitor26::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport26: AHB26 master26 monitor26 collected26 %0d transfers26", num_col26),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV26

