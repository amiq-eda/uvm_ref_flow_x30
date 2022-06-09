// IVB6 checksum6: 223843813
/*-----------------------------------------------------------------
File6 name     : ahb_slave_monitor6.sv
Created6       : Wed6 May6 19 15:42:21 2010
Description6   : This6 file implements6 the slave6 monitor6.
              : The slave6 monitor6 monitors6 the activity6 of
              : its interface bus.
Notes6         :
-----------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV6
`define AHB_SLAVE_MONITOR_SV6

//------------------------------------------------------------------------------
//
// CLASS6: ahb_slave_monitor6
//
//------------------------------------------------------------------------------

class ahb_slave_monitor6 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive6
  // and view6 HDL signals6.
  virtual interface ahb_if6 vif6;

  // Count6 transfer6 responses6 collected6
  int num_col6;

  // The following6 two6 bits are used to control6 whether6 checks6 and coverage6 are
  // done in the monitor6
  bit checks_enable6 = 1;
  bit coverage_enable6 = 1;
  
  // This6 TLM port is used to connect the monitor6 to the scoreboard6
  uvm_analysis_port#(ahb_transfer6) item_collected_port6;

  // Current6 monitored6 transfer6 
  protected ahb_transfer6 transfer6;
 
  // Covergroup6 for transfer6
  covergroup slave_transfer_cg6;
    option.per_instance = 1;
    direction6: coverpoint transfer6.direction6;
  endgroup : slave_transfer_cg6

  // Provide6 UVM automation6 and utility6 methods6
  `uvm_component_utils_begin(ahb_slave_monitor6)
    `uvm_field_int(checks_enable6, UVM_ALL_ON)
    `uvm_field_int(coverage_enable6, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor6 - required6 syntax6 for UVM automation6 and utilities6
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create6 the covergroup
    slave_transfer_cg6 = new();
    slave_transfer_cg6.set_inst_name("slave_transfer_cg6");
    // Create6 the TLM port
    item_collected_port6 = new("item_collected_port6", this);
  endfunction : new

  // Additional6 class methods6
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response6();
  extern virtual protected function void perform_checks6();
  extern virtual protected function void perform_coverage6();
  extern virtual function void report();

endclass : ahb_slave_monitor6

//UVM connect_phase
function void ahb_slave_monitor6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if6)::get(this, "", "vif6", vif6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor6::run_phase(uvm_phase phase);
    fork
      collect_response6();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB6-NOTE6 : REQUIRED6 : slave6 Monitor6 : Monitors6
   -------------------------------------------------------------------------
   Modify6 the collect_response6() method to match your6 protocol6.
   Note6 that if you change/add signals6 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect6 slave6 transfer6 (response)
  task ahb_slave_monitor6::collect_response6();
    // This6 monitor6 re-uses its data item for ALL6 transfers6
    transfer6 = ahb_transfer6::type_id::create("transfer6", this);
    forever begin
      @(posedge vif6.ahb_clock6 iff vif6.AHB_HREADY6 === 1);
      // Enable6 transfer6 recording6
      void'(begin_tr(transfer6, "AHB6 SLAVE6 Monitor6"));
      transfer6.data = vif6.AHB_HWDATA6;
      @(posedge vif6.ahb_clock6);
      end_tr(transfer6);
      `uvm_info(get_type_name(),
        $psprintf("slave6 transfer6 collected6 :\n%s",
        transfer6.sprint()), UVM_HIGH)
      if (checks_enable6)
        perform_checks6();
      if (coverage_enable6)
        perform_coverage6();
      // Send6 transfer6 to scoreboard6 via TLM write()
      item_collected_port6.write(transfer6);
      num_col6++;
    end
  endtask : collect_response6
  
  /***************************************************************************
  IVB6-NOTE6 : OPTIONAL6 : slave6 Monitor6 Protocol6 Checks6 : Checks6
  -------------------------------------------------------------------------
  Add protocol6 checks6 within the perform_checks6() method. 
  ***************************************************************************/
  // perform__checks6
  function void ahb_slave_monitor6::perform_checks6();
    // Add checks6 here6
  endfunction : perform_checks6
  
 /***************************************************************************
  IVB6-NOTE6 : OPTIONAL6 : slave6 Monitor6 Coverage6 : Coverage6
  -------------------------------------------------------------------------
  Modify6 the slave_transfer_cg6 coverage6 group6 to match your6 protocol6.
  Add new coverage6 groups6, and edit6 the perform_coverage6() method to sample them6
  ***************************************************************************/

  // Triggers6 coverage6 events
  function void ahb_slave_monitor6::perform_coverage6();
    slave_transfer_cg6.sample();
  endfunction : perform_coverage6

  // UVM report() phase
  function void ahb_slave_monitor6::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport6: AHB6 slave6 monitor6 collected6 %0d transfer6 responses6",
      num_col6), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV6

