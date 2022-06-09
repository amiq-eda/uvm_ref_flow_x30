// IVB22 checksum22: 3251807609
/*-----------------------------------------------------------------
File22 name     : ahb_master_monitor22.sv
Created22       : Wed22 May22 19 15:42:21 2010
Description22   : This22 file implements22 the master22 monitor22.
              : The master22 monitor22 monitors22 the activity22 of
              : its interface bus.
Notes22         :
-----------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV22
`define AHB_MASTER_MONITOR_SV22

//------------------------------------------------------------------------------
//
// CLASS22: ahb_master_monitor22
//
//------------------------------------------------------------------------------

class ahb_master_monitor22 extends uvm_monitor;

  // Virtual Interface22 for monitoring22 DUT signals22
  virtual interface ahb_if22 vif22;

  // Count22 transfers22 collected22
  int num_col22;
  event transaction_ended22;
 
  // The following22 two22 bits are used to control22 whether22 checks22 and coverage22 are
  // done in the monitor22
  bit checks_enable22 = 1;
  bit coverage_enable22 = 1;

  // This22 TLM port is used to connect the monitor22 to the scoreboard22
  uvm_analysis_port #(ahb_transfer22) item_collected_port22;

  // Current22 monitored22 transfer22
  protected ahb_transfer22 transfer22;

  // Covergroup22 for transfer22
  covergroup master_transfer_cg22;
    option.per_instance = 1;
    direction22 : coverpoint transfer22.direction22;
  endgroup : master_transfer_cg22
 
  // Provide22 UVM automation22 and utility22 methods22
  `uvm_component_utils_begin(ahb_master_monitor22)
    `uvm_field_int(checks_enable22, UVM_ALL_ON)
    `uvm_field_int(coverage_enable22, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor22 - required22 syntax22 for UVM automation22 and utilities22
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create22 the covergroup
    master_transfer_cg22 = new();
    master_transfer_cg22.set_inst_name("master_transfer_cg22");
    // Create22 the TLM port
    item_collected_port22 = new("item_collected_port22", this);
  endfunction : new

  // Additional22 class methods22
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer22();
  extern virtual protected function void perform_checks22();
  extern virtual protected function void perform_coverage22();
  extern virtual function void report();

endclass : ahb_master_monitor22

//UVM connect_phase
function void ahb_master_monitor22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if22)::get(this, "", "vif22", vif22))
   `uvm_error("NOVIF22",{"virtual interface must be set for: ",get_full_name(),".vif22"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor22::run_phase(uvm_phase phase);
    fork
      collect_transfer22();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB22-NOTE22 : REQUIRED22 : master22 Monitor22 : Monitors22
   -------------------------------------------------------------------------
   Modify22 the collect_transfers22() method to match your22 protocol22.
   Note22 that if you change/add signals22 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor22::collect_transfer22();
    // This22 monitor22 re-uses its data items for ALL22 transfers22
    transfer22 = ahb_transfer22::type_id::create("transfer22", this);
    forever begin
      @(posedge vif22.ahb_clock22 iff vif22.AHB_HTRANS22 === NONSEQ22);
      // Begin22 transaction recording22
      void'(begin_tr(transfer22, "AHB22 MASTER22 Monitor22"));
      transfer22.address = vif22.AHB_HADDR22;
      transfer22.direction22 = ahb_direction22'(vif22.AHB_HWRITE22);
      transfer22.hsize22 = ahb_transfer_size22'(0);  //Not used - hance22 assign dummy
      transfer22.burst = ahb_burst_kind22'(0);     //Not used - hance22 assign dummy
      @(posedge vif22.ahb_clock22 iff vif22.AHB_HREADY22 === 1);
      // End22 transaction recording22
        if(transfer22.direction22 == WRITE) 
          transfer22.data = vif22.AHB_HWDATA22;
        else
          transfer22.data = vif22.AHB_HRDATA22;
        ;
      @(posedge vif22.ahb_clock22 iff vif22.AHB_HREADY22 === 1);
    end_tr(transfer22);
      `uvm_info(get_type_name(), 
        $psprintf("master22 transfer22 collected22 :\n%s", 
        transfer22.sprint()), UVM_HIGH)
      if (checks_enable22)
         perform_checks22();
      if (coverage_enable22)
         perform_coverage22();
      // Send22 transfer22 to scoreboard22 via TLM write()
      item_collected_port22.write(transfer22);
      -> transaction_ended22;
      num_col22++;
    end
  endtask : collect_transfer22
  
  /***************************************************************************
   IVB22-NOTE22 : OPTIONAL22 : master22 Monitor22 Protocol22 Checks22 : Checks22
   -------------------------------------------------------------------------
   Add protocol22 checks22 within the perform_checks22() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks22
  function void ahb_master_monitor22::perform_checks22();
    // Add checks22 here22
  endfunction : perform_checks22
  
 /***************************************************************************
  IVB22-NOTE22 : OPTIONAL22 : master22 Monitor22 Coverage22 : Coverage22
  -------------------------------------------------------------------------
  Modify22 the master_transfer_cg22 coverage22 group22 to match your22 protocol22.
  Add new coverage22 groups22, and edit22 the perform_coverage22() method to sample 
  them22.
  ***************************************************************************/

  // Triggers22 coverage22 events
  function void ahb_master_monitor22::perform_coverage22();
    master_transfer_cg22.sample();
  endfunction : perform_coverage22

  // UVM report() phase
  function void ahb_master_monitor22::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport22: AHB22 master22 monitor22 collected22 %0d transfers22", num_col22),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV22

