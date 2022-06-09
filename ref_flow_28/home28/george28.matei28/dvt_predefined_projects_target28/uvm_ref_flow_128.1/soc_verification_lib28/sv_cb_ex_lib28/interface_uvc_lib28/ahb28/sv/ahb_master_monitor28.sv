// IVB28 checksum28: 3251807609
/*-----------------------------------------------------------------
File28 name     : ahb_master_monitor28.sv
Created28       : Wed28 May28 19 15:42:21 2010
Description28   : This28 file implements28 the master28 monitor28.
              : The master28 monitor28 monitors28 the activity28 of
              : its interface bus.
Notes28         :
-----------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV28
`define AHB_MASTER_MONITOR_SV28

//------------------------------------------------------------------------------
//
// CLASS28: ahb_master_monitor28
//
//------------------------------------------------------------------------------

class ahb_master_monitor28 extends uvm_monitor;

  // Virtual Interface28 for monitoring28 DUT signals28
  virtual interface ahb_if28 vif28;

  // Count28 transfers28 collected28
  int num_col28;
  event transaction_ended28;
 
  // The following28 two28 bits are used to control28 whether28 checks28 and coverage28 are
  // done in the monitor28
  bit checks_enable28 = 1;
  bit coverage_enable28 = 1;

  // This28 TLM port is used to connect the monitor28 to the scoreboard28
  uvm_analysis_port #(ahb_transfer28) item_collected_port28;

  // Current28 monitored28 transfer28
  protected ahb_transfer28 transfer28;

  // Covergroup28 for transfer28
  covergroup master_transfer_cg28;
    option.per_instance = 1;
    direction28 : coverpoint transfer28.direction28;
  endgroup : master_transfer_cg28
 
  // Provide28 UVM automation28 and utility28 methods28
  `uvm_component_utils_begin(ahb_master_monitor28)
    `uvm_field_int(checks_enable28, UVM_ALL_ON)
    `uvm_field_int(coverage_enable28, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor28 - required28 syntax28 for UVM automation28 and utilities28
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create28 the covergroup
    master_transfer_cg28 = new();
    master_transfer_cg28.set_inst_name("master_transfer_cg28");
    // Create28 the TLM port
    item_collected_port28 = new("item_collected_port28", this);
  endfunction : new

  // Additional28 class methods28
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer28();
  extern virtual protected function void perform_checks28();
  extern virtual protected function void perform_coverage28();
  extern virtual function void report();

endclass : ahb_master_monitor28

//UVM connect_phase
function void ahb_master_monitor28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if28)::get(this, "", "vif28", vif28))
   `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor28::run_phase(uvm_phase phase);
    fork
      collect_transfer28();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB28-NOTE28 : REQUIRED28 : master28 Monitor28 : Monitors28
   -------------------------------------------------------------------------
   Modify28 the collect_transfers28() method to match your28 protocol28.
   Note28 that if you change/add signals28 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor28::collect_transfer28();
    // This28 monitor28 re-uses its data items for ALL28 transfers28
    transfer28 = ahb_transfer28::type_id::create("transfer28", this);
    forever begin
      @(posedge vif28.ahb_clock28 iff vif28.AHB_HTRANS28 === NONSEQ28);
      // Begin28 transaction recording28
      void'(begin_tr(transfer28, "AHB28 MASTER28 Monitor28"));
      transfer28.address = vif28.AHB_HADDR28;
      transfer28.direction28 = ahb_direction28'(vif28.AHB_HWRITE28);
      transfer28.hsize28 = ahb_transfer_size28'(0);  //Not used - hance28 assign dummy
      transfer28.burst = ahb_burst_kind28'(0);     //Not used - hance28 assign dummy
      @(posedge vif28.ahb_clock28 iff vif28.AHB_HREADY28 === 1);
      // End28 transaction recording28
        if(transfer28.direction28 == WRITE) 
          transfer28.data = vif28.AHB_HWDATA28;
        else
          transfer28.data = vif28.AHB_HRDATA28;
        ;
      @(posedge vif28.ahb_clock28 iff vif28.AHB_HREADY28 === 1);
    end_tr(transfer28);
      `uvm_info(get_type_name(), 
        $psprintf("master28 transfer28 collected28 :\n%s", 
        transfer28.sprint()), UVM_HIGH)
      if (checks_enable28)
         perform_checks28();
      if (coverage_enable28)
         perform_coverage28();
      // Send28 transfer28 to scoreboard28 via TLM write()
      item_collected_port28.write(transfer28);
      -> transaction_ended28;
      num_col28++;
    end
  endtask : collect_transfer28
  
  /***************************************************************************
   IVB28-NOTE28 : OPTIONAL28 : master28 Monitor28 Protocol28 Checks28 : Checks28
   -------------------------------------------------------------------------
   Add protocol28 checks28 within the perform_checks28() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks28
  function void ahb_master_monitor28::perform_checks28();
    // Add checks28 here28
  endfunction : perform_checks28
  
 /***************************************************************************
  IVB28-NOTE28 : OPTIONAL28 : master28 Monitor28 Coverage28 : Coverage28
  -------------------------------------------------------------------------
  Modify28 the master_transfer_cg28 coverage28 group28 to match your28 protocol28.
  Add new coverage28 groups28, and edit28 the perform_coverage28() method to sample 
  them28.
  ***************************************************************************/

  // Triggers28 coverage28 events
  function void ahb_master_monitor28::perform_coverage28();
    master_transfer_cg28.sample();
  endfunction : perform_coverage28

  // UVM report() phase
  function void ahb_master_monitor28::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport28: AHB28 master28 monitor28 collected28 %0d transfers28", num_col28),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV28

