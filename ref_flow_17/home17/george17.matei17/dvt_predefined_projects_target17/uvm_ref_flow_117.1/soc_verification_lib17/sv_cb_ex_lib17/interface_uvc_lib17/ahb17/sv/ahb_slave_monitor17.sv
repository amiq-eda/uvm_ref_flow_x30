// IVB17 checksum17: 223843813
/*-----------------------------------------------------------------
File17 name     : ahb_slave_monitor17.sv
Created17       : Wed17 May17 19 15:42:21 2010
Description17   : This17 file implements17 the slave17 monitor17.
              : The slave17 monitor17 monitors17 the activity17 of
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


`ifndef AHB_SLAVE_MONITOR_SV17
`define AHB_SLAVE_MONITOR_SV17

//------------------------------------------------------------------------------
//
// CLASS17: ahb_slave_monitor17
//
//------------------------------------------------------------------------------

class ahb_slave_monitor17 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive17
  // and view17 HDL signals17.
  virtual interface ahb_if17 vif17;

  // Count17 transfer17 responses17 collected17
  int num_col17;

  // The following17 two17 bits are used to control17 whether17 checks17 and coverage17 are
  // done in the monitor17
  bit checks_enable17 = 1;
  bit coverage_enable17 = 1;
  
  // This17 TLM port is used to connect the monitor17 to the scoreboard17
  uvm_analysis_port#(ahb_transfer17) item_collected_port17;

  // Current17 monitored17 transfer17 
  protected ahb_transfer17 transfer17;
 
  // Covergroup17 for transfer17
  covergroup slave_transfer_cg17;
    option.per_instance = 1;
    direction17: coverpoint transfer17.direction17;
  endgroup : slave_transfer_cg17

  // Provide17 UVM automation17 and utility17 methods17
  `uvm_component_utils_begin(ahb_slave_monitor17)
    `uvm_field_int(checks_enable17, UVM_ALL_ON)
    `uvm_field_int(coverage_enable17, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor17 - required17 syntax17 for UVM automation17 and utilities17
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create17 the covergroup
    slave_transfer_cg17 = new();
    slave_transfer_cg17.set_inst_name("slave_transfer_cg17");
    // Create17 the TLM port
    item_collected_port17 = new("item_collected_port17", this);
  endfunction : new

  // Additional17 class methods17
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response17();
  extern virtual protected function void perform_checks17();
  extern virtual protected function void perform_coverage17();
  extern virtual function void report();

endclass : ahb_slave_monitor17

//UVM connect_phase
function void ahb_slave_monitor17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if17)::get(this, "", "vif17", vif17))
   `uvm_error("NOVIF17",{"virtual interface must be set for: ",get_full_name(),".vif17"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor17::run_phase(uvm_phase phase);
    fork
      collect_response17();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB17-NOTE17 : REQUIRED17 : slave17 Monitor17 : Monitors17
   -------------------------------------------------------------------------
   Modify17 the collect_response17() method to match your17 protocol17.
   Note17 that if you change/add signals17 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect17 slave17 transfer17 (response)
  task ahb_slave_monitor17::collect_response17();
    // This17 monitor17 re-uses its data item for ALL17 transfers17
    transfer17 = ahb_transfer17::type_id::create("transfer17", this);
    forever begin
      @(posedge vif17.ahb_clock17 iff vif17.AHB_HREADY17 === 1);
      // Enable17 transfer17 recording17
      void'(begin_tr(transfer17, "AHB17 SLAVE17 Monitor17"));
      transfer17.data = vif17.AHB_HWDATA17;
      @(posedge vif17.ahb_clock17);
      end_tr(transfer17);
      `uvm_info(get_type_name(),
        $psprintf("slave17 transfer17 collected17 :\n%s",
        transfer17.sprint()), UVM_HIGH)
      if (checks_enable17)
        perform_checks17();
      if (coverage_enable17)
        perform_coverage17();
      // Send17 transfer17 to scoreboard17 via TLM write()
      item_collected_port17.write(transfer17);
      num_col17++;
    end
  endtask : collect_response17
  
  /***************************************************************************
  IVB17-NOTE17 : OPTIONAL17 : slave17 Monitor17 Protocol17 Checks17 : Checks17
  -------------------------------------------------------------------------
  Add protocol17 checks17 within the perform_checks17() method. 
  ***************************************************************************/
  // perform__checks17
  function void ahb_slave_monitor17::perform_checks17();
    // Add checks17 here17
  endfunction : perform_checks17
  
 /***************************************************************************
  IVB17-NOTE17 : OPTIONAL17 : slave17 Monitor17 Coverage17 : Coverage17
  -------------------------------------------------------------------------
  Modify17 the slave_transfer_cg17 coverage17 group17 to match your17 protocol17.
  Add new coverage17 groups17, and edit17 the perform_coverage17() method to sample them17
  ***************************************************************************/

  // Triggers17 coverage17 events
  function void ahb_slave_monitor17::perform_coverage17();
    slave_transfer_cg17.sample();
  endfunction : perform_coverage17

  // UVM report() phase
  function void ahb_slave_monitor17::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport17: AHB17 slave17 monitor17 collected17 %0d transfer17 responses17",
      num_col17), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV17

