// IVB10 checksum10: 223843813
/*-----------------------------------------------------------------
File10 name     : ahb_slave_monitor10.sv
Created10       : Wed10 May10 19 15:42:21 2010
Description10   : This10 file implements10 the slave10 monitor10.
              : The slave10 monitor10 monitors10 the activity10 of
              : its interface bus.
Notes10         :
-----------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV10
`define AHB_SLAVE_MONITOR_SV10

//------------------------------------------------------------------------------
//
// CLASS10: ahb_slave_monitor10
//
//------------------------------------------------------------------------------

class ahb_slave_monitor10 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive10
  // and view10 HDL signals10.
  virtual interface ahb_if10 vif10;

  // Count10 transfer10 responses10 collected10
  int num_col10;

  // The following10 two10 bits are used to control10 whether10 checks10 and coverage10 are
  // done in the monitor10
  bit checks_enable10 = 1;
  bit coverage_enable10 = 1;
  
  // This10 TLM port is used to connect the monitor10 to the scoreboard10
  uvm_analysis_port#(ahb_transfer10) item_collected_port10;

  // Current10 monitored10 transfer10 
  protected ahb_transfer10 transfer10;
 
  // Covergroup10 for transfer10
  covergroup slave_transfer_cg10;
    option.per_instance = 1;
    direction10: coverpoint transfer10.direction10;
  endgroup : slave_transfer_cg10

  // Provide10 UVM automation10 and utility10 methods10
  `uvm_component_utils_begin(ahb_slave_monitor10)
    `uvm_field_int(checks_enable10, UVM_ALL_ON)
    `uvm_field_int(coverage_enable10, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor10 - required10 syntax10 for UVM automation10 and utilities10
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create10 the covergroup
    slave_transfer_cg10 = new();
    slave_transfer_cg10.set_inst_name("slave_transfer_cg10");
    // Create10 the TLM port
    item_collected_port10 = new("item_collected_port10", this);
  endfunction : new

  // Additional10 class methods10
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response10();
  extern virtual protected function void perform_checks10();
  extern virtual protected function void perform_coverage10();
  extern virtual function void report();

endclass : ahb_slave_monitor10

//UVM connect_phase
function void ahb_slave_monitor10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if10)::get(this, "", "vif10", vif10))
   `uvm_error("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor10::run_phase(uvm_phase phase);
    fork
      collect_response10();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB10-NOTE10 : REQUIRED10 : slave10 Monitor10 : Monitors10
   -------------------------------------------------------------------------
   Modify10 the collect_response10() method to match your10 protocol10.
   Note10 that if you change/add signals10 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect10 slave10 transfer10 (response)
  task ahb_slave_monitor10::collect_response10();
    // This10 monitor10 re-uses its data item for ALL10 transfers10
    transfer10 = ahb_transfer10::type_id::create("transfer10", this);
    forever begin
      @(posedge vif10.ahb_clock10 iff vif10.AHB_HREADY10 === 1);
      // Enable10 transfer10 recording10
      void'(begin_tr(transfer10, "AHB10 SLAVE10 Monitor10"));
      transfer10.data = vif10.AHB_HWDATA10;
      @(posedge vif10.ahb_clock10);
      end_tr(transfer10);
      `uvm_info(get_type_name(),
        $psprintf("slave10 transfer10 collected10 :\n%s",
        transfer10.sprint()), UVM_HIGH)
      if (checks_enable10)
        perform_checks10();
      if (coverage_enable10)
        perform_coverage10();
      // Send10 transfer10 to scoreboard10 via TLM write()
      item_collected_port10.write(transfer10);
      num_col10++;
    end
  endtask : collect_response10
  
  /***************************************************************************
  IVB10-NOTE10 : OPTIONAL10 : slave10 Monitor10 Protocol10 Checks10 : Checks10
  -------------------------------------------------------------------------
  Add protocol10 checks10 within the perform_checks10() method. 
  ***************************************************************************/
  // perform__checks10
  function void ahb_slave_monitor10::perform_checks10();
    // Add checks10 here10
  endfunction : perform_checks10
  
 /***************************************************************************
  IVB10-NOTE10 : OPTIONAL10 : slave10 Monitor10 Coverage10 : Coverage10
  -------------------------------------------------------------------------
  Modify10 the slave_transfer_cg10 coverage10 group10 to match your10 protocol10.
  Add new coverage10 groups10, and edit10 the perform_coverage10() method to sample them10
  ***************************************************************************/

  // Triggers10 coverage10 events
  function void ahb_slave_monitor10::perform_coverage10();
    slave_transfer_cg10.sample();
  endfunction : perform_coverage10

  // UVM report() phase
  function void ahb_slave_monitor10::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport10: AHB10 slave10 monitor10 collected10 %0d transfer10 responses10",
      num_col10), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV10

