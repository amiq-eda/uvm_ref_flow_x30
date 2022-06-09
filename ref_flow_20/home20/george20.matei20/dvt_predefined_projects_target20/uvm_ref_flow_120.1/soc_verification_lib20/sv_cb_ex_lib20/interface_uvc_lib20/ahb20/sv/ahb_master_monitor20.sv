// IVB20 checksum20: 3251807609
/*-----------------------------------------------------------------
File20 name     : ahb_master_monitor20.sv
Created20       : Wed20 May20 19 15:42:21 2010
Description20   : This20 file implements20 the master20 monitor20.
              : The master20 monitor20 monitors20 the activity20 of
              : its interface bus.
Notes20         :
-----------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV20
`define AHB_MASTER_MONITOR_SV20

//------------------------------------------------------------------------------
//
// CLASS20: ahb_master_monitor20
//
//------------------------------------------------------------------------------

class ahb_master_monitor20 extends uvm_monitor;

  // Virtual Interface20 for monitoring20 DUT signals20
  virtual interface ahb_if20 vif20;

  // Count20 transfers20 collected20
  int num_col20;
  event transaction_ended20;
 
  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done in the monitor20
  bit checks_enable20 = 1;
  bit coverage_enable20 = 1;

  // This20 TLM port is used to connect the monitor20 to the scoreboard20
  uvm_analysis_port #(ahb_transfer20) item_collected_port20;

  // Current20 monitored20 transfer20
  protected ahb_transfer20 transfer20;

  // Covergroup20 for transfer20
  covergroup master_transfer_cg20;
    option.per_instance = 1;
    direction20 : coverpoint transfer20.direction20;
  endgroup : master_transfer_cg20
 
  // Provide20 UVM automation20 and utility20 methods20
  `uvm_component_utils_begin(ahb_master_monitor20)
    `uvm_field_int(checks_enable20, UVM_ALL_ON)
    `uvm_field_int(coverage_enable20, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create20 the covergroup
    master_transfer_cg20 = new();
    master_transfer_cg20.set_inst_name("master_transfer_cg20");
    // Create20 the TLM port
    item_collected_port20 = new("item_collected_port20", this);
  endfunction : new

  // Additional20 class methods20
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer20();
  extern virtual protected function void perform_checks20();
  extern virtual protected function void perform_coverage20();
  extern virtual function void report();

endclass : ahb_master_monitor20

//UVM connect_phase
function void ahb_master_monitor20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if20)::get(this, "", "vif20", vif20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor20::run_phase(uvm_phase phase);
    fork
      collect_transfer20();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB20-NOTE20 : REQUIRED20 : master20 Monitor20 : Monitors20
   -------------------------------------------------------------------------
   Modify20 the collect_transfers20() method to match your20 protocol20.
   Note20 that if you change/add signals20 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor20::collect_transfer20();
    // This20 monitor20 re-uses its data items for ALL20 transfers20
    transfer20 = ahb_transfer20::type_id::create("transfer20", this);
    forever begin
      @(posedge vif20.ahb_clock20 iff vif20.AHB_HTRANS20 === NONSEQ20);
      // Begin20 transaction recording20
      void'(begin_tr(transfer20, "AHB20 MASTER20 Monitor20"));
      transfer20.address = vif20.AHB_HADDR20;
      transfer20.direction20 = ahb_direction20'(vif20.AHB_HWRITE20);
      transfer20.hsize20 = ahb_transfer_size20'(0);  //Not used - hance20 assign dummy
      transfer20.burst = ahb_burst_kind20'(0);     //Not used - hance20 assign dummy
      @(posedge vif20.ahb_clock20 iff vif20.AHB_HREADY20 === 1);
      // End20 transaction recording20
        if(transfer20.direction20 == WRITE) 
          transfer20.data = vif20.AHB_HWDATA20;
        else
          transfer20.data = vif20.AHB_HRDATA20;
        ;
      @(posedge vif20.ahb_clock20 iff vif20.AHB_HREADY20 === 1);
    end_tr(transfer20);
      `uvm_info(get_type_name(), 
        $psprintf("master20 transfer20 collected20 :\n%s", 
        transfer20.sprint()), UVM_HIGH)
      if (checks_enable20)
         perform_checks20();
      if (coverage_enable20)
         perform_coverage20();
      // Send20 transfer20 to scoreboard20 via TLM write()
      item_collected_port20.write(transfer20);
      -> transaction_ended20;
      num_col20++;
    end
  endtask : collect_transfer20
  
  /***************************************************************************
   IVB20-NOTE20 : OPTIONAL20 : master20 Monitor20 Protocol20 Checks20 : Checks20
   -------------------------------------------------------------------------
   Add protocol20 checks20 within the perform_checks20() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks20
  function void ahb_master_monitor20::perform_checks20();
    // Add checks20 here20
  endfunction : perform_checks20
  
 /***************************************************************************
  IVB20-NOTE20 : OPTIONAL20 : master20 Monitor20 Coverage20 : Coverage20
  -------------------------------------------------------------------------
  Modify20 the master_transfer_cg20 coverage20 group20 to match your20 protocol20.
  Add new coverage20 groups20, and edit20 the perform_coverage20() method to sample 
  them20.
  ***************************************************************************/

  // Triggers20 coverage20 events
  function void ahb_master_monitor20::perform_coverage20();
    master_transfer_cg20.sample();
  endfunction : perform_coverage20

  // UVM report() phase
  function void ahb_master_monitor20::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport20: AHB20 master20 monitor20 collected20 %0d transfers20", num_col20),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV20

