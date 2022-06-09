// IVB23 checksum23: 223843813
/*-----------------------------------------------------------------
File23 name     : ahb_slave_monitor23.sv
Created23       : Wed23 May23 19 15:42:21 2010
Description23   : This23 file implements23 the slave23 monitor23.
              : The slave23 monitor23 monitors23 the activity23 of
              : its interface bus.
Notes23         :
-----------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV23
`define AHB_SLAVE_MONITOR_SV23

//------------------------------------------------------------------------------
//
// CLASS23: ahb_slave_monitor23
//
//------------------------------------------------------------------------------

class ahb_slave_monitor23 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive23
  // and view23 HDL signals23.
  virtual interface ahb_if23 vif23;

  // Count23 transfer23 responses23 collected23
  int num_col23;

  // The following23 two23 bits are used to control23 whether23 checks23 and coverage23 are
  // done in the monitor23
  bit checks_enable23 = 1;
  bit coverage_enable23 = 1;
  
  // This23 TLM port is used to connect the monitor23 to the scoreboard23
  uvm_analysis_port#(ahb_transfer23) item_collected_port23;

  // Current23 monitored23 transfer23 
  protected ahb_transfer23 transfer23;
 
  // Covergroup23 for transfer23
  covergroup slave_transfer_cg23;
    option.per_instance = 1;
    direction23: coverpoint transfer23.direction23;
  endgroup : slave_transfer_cg23

  // Provide23 UVM automation23 and utility23 methods23
  `uvm_component_utils_begin(ahb_slave_monitor23)
    `uvm_field_int(checks_enable23, UVM_ALL_ON)
    `uvm_field_int(coverage_enable23, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor23 - required23 syntax23 for UVM automation23 and utilities23
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create23 the covergroup
    slave_transfer_cg23 = new();
    slave_transfer_cg23.set_inst_name("slave_transfer_cg23");
    // Create23 the TLM port
    item_collected_port23 = new("item_collected_port23", this);
  endfunction : new

  // Additional23 class methods23
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response23();
  extern virtual protected function void perform_checks23();
  extern virtual protected function void perform_coverage23();
  extern virtual function void report();

endclass : ahb_slave_monitor23

//UVM connect_phase
function void ahb_slave_monitor23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if23)::get(this, "", "vif23", vif23))
   `uvm_error("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor23::run_phase(uvm_phase phase);
    fork
      collect_response23();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB23-NOTE23 : REQUIRED23 : slave23 Monitor23 : Monitors23
   -------------------------------------------------------------------------
   Modify23 the collect_response23() method to match your23 protocol23.
   Note23 that if you change/add signals23 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect23 slave23 transfer23 (response)
  task ahb_slave_monitor23::collect_response23();
    // This23 monitor23 re-uses its data item for ALL23 transfers23
    transfer23 = ahb_transfer23::type_id::create("transfer23", this);
    forever begin
      @(posedge vif23.ahb_clock23 iff vif23.AHB_HREADY23 === 1);
      // Enable23 transfer23 recording23
      void'(begin_tr(transfer23, "AHB23 SLAVE23 Monitor23"));
      transfer23.data = vif23.AHB_HWDATA23;
      @(posedge vif23.ahb_clock23);
      end_tr(transfer23);
      `uvm_info(get_type_name(),
        $psprintf("slave23 transfer23 collected23 :\n%s",
        transfer23.sprint()), UVM_HIGH)
      if (checks_enable23)
        perform_checks23();
      if (coverage_enable23)
        perform_coverage23();
      // Send23 transfer23 to scoreboard23 via TLM write()
      item_collected_port23.write(transfer23);
      num_col23++;
    end
  endtask : collect_response23
  
  /***************************************************************************
  IVB23-NOTE23 : OPTIONAL23 : slave23 Monitor23 Protocol23 Checks23 : Checks23
  -------------------------------------------------------------------------
  Add protocol23 checks23 within the perform_checks23() method. 
  ***************************************************************************/
  // perform__checks23
  function void ahb_slave_monitor23::perform_checks23();
    // Add checks23 here23
  endfunction : perform_checks23
  
 /***************************************************************************
  IVB23-NOTE23 : OPTIONAL23 : slave23 Monitor23 Coverage23 : Coverage23
  -------------------------------------------------------------------------
  Modify23 the slave_transfer_cg23 coverage23 group23 to match your23 protocol23.
  Add new coverage23 groups23, and edit23 the perform_coverage23() method to sample them23
  ***************************************************************************/

  // Triggers23 coverage23 events
  function void ahb_slave_monitor23::perform_coverage23();
    slave_transfer_cg23.sample();
  endfunction : perform_coverage23

  // UVM report() phase
  function void ahb_slave_monitor23::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport23: AHB23 slave23 monitor23 collected23 %0d transfer23 responses23",
      num_col23), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV23

