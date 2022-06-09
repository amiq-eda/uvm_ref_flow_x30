// IVB15 checksum15: 223843813
/*-----------------------------------------------------------------
File15 name     : ahb_slave_monitor15.sv
Created15       : Wed15 May15 19 15:42:21 2010
Description15   : This15 file implements15 the slave15 monitor15.
              : The slave15 monitor15 monitors15 the activity15 of
              : its interface bus.
Notes15         :
-----------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV15
`define AHB_SLAVE_MONITOR_SV15

//------------------------------------------------------------------------------
//
// CLASS15: ahb_slave_monitor15
//
//------------------------------------------------------------------------------

class ahb_slave_monitor15 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive15
  // and view15 HDL signals15.
  virtual interface ahb_if15 vif15;

  // Count15 transfer15 responses15 collected15
  int num_col15;

  // The following15 two15 bits are used to control15 whether15 checks15 and coverage15 are
  // done in the monitor15
  bit checks_enable15 = 1;
  bit coverage_enable15 = 1;
  
  // This15 TLM port is used to connect the monitor15 to the scoreboard15
  uvm_analysis_port#(ahb_transfer15) item_collected_port15;

  // Current15 monitored15 transfer15 
  protected ahb_transfer15 transfer15;
 
  // Covergroup15 for transfer15
  covergroup slave_transfer_cg15;
    option.per_instance = 1;
    direction15: coverpoint transfer15.direction15;
  endgroup : slave_transfer_cg15

  // Provide15 UVM automation15 and utility15 methods15
  `uvm_component_utils_begin(ahb_slave_monitor15)
    `uvm_field_int(checks_enable15, UVM_ALL_ON)
    `uvm_field_int(coverage_enable15, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor15 - required15 syntax15 for UVM automation15 and utilities15
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create15 the covergroup
    slave_transfer_cg15 = new();
    slave_transfer_cg15.set_inst_name("slave_transfer_cg15");
    // Create15 the TLM port
    item_collected_port15 = new("item_collected_port15", this);
  endfunction : new

  // Additional15 class methods15
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response15();
  extern virtual protected function void perform_checks15();
  extern virtual protected function void perform_coverage15();
  extern virtual function void report();

endclass : ahb_slave_monitor15

//UVM connect_phase
function void ahb_slave_monitor15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if15)::get(this, "", "vif15", vif15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor15::run_phase(uvm_phase phase);
    fork
      collect_response15();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB15-NOTE15 : REQUIRED15 : slave15 Monitor15 : Monitors15
   -------------------------------------------------------------------------
   Modify15 the collect_response15() method to match your15 protocol15.
   Note15 that if you change/add signals15 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect15 slave15 transfer15 (response)
  task ahb_slave_monitor15::collect_response15();
    // This15 monitor15 re-uses its data item for ALL15 transfers15
    transfer15 = ahb_transfer15::type_id::create("transfer15", this);
    forever begin
      @(posedge vif15.ahb_clock15 iff vif15.AHB_HREADY15 === 1);
      // Enable15 transfer15 recording15
      void'(begin_tr(transfer15, "AHB15 SLAVE15 Monitor15"));
      transfer15.data = vif15.AHB_HWDATA15;
      @(posedge vif15.ahb_clock15);
      end_tr(transfer15);
      `uvm_info(get_type_name(),
        $psprintf("slave15 transfer15 collected15 :\n%s",
        transfer15.sprint()), UVM_HIGH)
      if (checks_enable15)
        perform_checks15();
      if (coverage_enable15)
        perform_coverage15();
      // Send15 transfer15 to scoreboard15 via TLM write()
      item_collected_port15.write(transfer15);
      num_col15++;
    end
  endtask : collect_response15
  
  /***************************************************************************
  IVB15-NOTE15 : OPTIONAL15 : slave15 Monitor15 Protocol15 Checks15 : Checks15
  -------------------------------------------------------------------------
  Add protocol15 checks15 within the perform_checks15() method. 
  ***************************************************************************/
  // perform__checks15
  function void ahb_slave_monitor15::perform_checks15();
    // Add checks15 here15
  endfunction : perform_checks15
  
 /***************************************************************************
  IVB15-NOTE15 : OPTIONAL15 : slave15 Monitor15 Coverage15 : Coverage15
  -------------------------------------------------------------------------
  Modify15 the slave_transfer_cg15 coverage15 group15 to match your15 protocol15.
  Add new coverage15 groups15, and edit15 the perform_coverage15() method to sample them15
  ***************************************************************************/

  // Triggers15 coverage15 events
  function void ahb_slave_monitor15::perform_coverage15();
    slave_transfer_cg15.sample();
  endfunction : perform_coverage15

  // UVM report() phase
  function void ahb_slave_monitor15::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport15: AHB15 slave15 monitor15 collected15 %0d transfer15 responses15",
      num_col15), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV15

