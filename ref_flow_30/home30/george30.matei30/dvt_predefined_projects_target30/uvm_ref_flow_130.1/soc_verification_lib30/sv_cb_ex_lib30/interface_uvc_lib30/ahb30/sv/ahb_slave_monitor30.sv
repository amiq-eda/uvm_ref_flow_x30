// IVB30 checksum30: 223843813
/*-----------------------------------------------------------------
File30 name     : ahb_slave_monitor30.sv
Created30       : Wed30 May30 19 15:42:21 2010
Description30   : This30 file implements30 the slave30 monitor30.
              : The slave30 monitor30 monitors30 the activity30 of
              : its interface bus.
Notes30         :
-----------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV30
`define AHB_SLAVE_MONITOR_SV30

//------------------------------------------------------------------------------
//
// CLASS30: ahb_slave_monitor30
//
//------------------------------------------------------------------------------

class ahb_slave_monitor30 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive30
  // and view30 HDL signals30.
  virtual interface ahb_if30 vif30;

  // Count30 transfer30 responses30 collected30
  int num_col30;

  // The following30 two30 bits are used to control30 whether30 checks30 and coverage30 are
  // done in the monitor30
  bit checks_enable30 = 1;
  bit coverage_enable30 = 1;
  
  // This30 TLM port is used to connect the monitor30 to the scoreboard30
  uvm_analysis_port#(ahb_transfer30) item_collected_port30;

  // Current30 monitored30 transfer30 
  protected ahb_transfer30 transfer30;
 
  // Covergroup30 for transfer30
  covergroup slave_transfer_cg30;
    option.per_instance = 1;
    direction30: coverpoint transfer30.direction30;
  endgroup : slave_transfer_cg30

  // Provide30 UVM automation30 and utility30 methods30
  `uvm_component_utils_begin(ahb_slave_monitor30)
    `uvm_field_int(checks_enable30, UVM_ALL_ON)
    `uvm_field_int(coverage_enable30, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor30 - required30 syntax30 for UVM automation30 and utilities30
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create30 the covergroup
    slave_transfer_cg30 = new();
    slave_transfer_cg30.set_inst_name("slave_transfer_cg30");
    // Create30 the TLM port
    item_collected_port30 = new("item_collected_port30", this);
  endfunction : new

  // Additional30 class methods30
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response30();
  extern virtual protected function void perform_checks30();
  extern virtual protected function void perform_coverage30();
  extern virtual function void report();

endclass : ahb_slave_monitor30

//UVM connect_phase
function void ahb_slave_monitor30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if30)::get(this, "", "vif30", vif30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor30::run_phase(uvm_phase phase);
    fork
      collect_response30();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB30-NOTE30 : REQUIRED30 : slave30 Monitor30 : Monitors30
   -------------------------------------------------------------------------
   Modify30 the collect_response30() method to match your30 protocol30.
   Note30 that if you change/add signals30 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect30 slave30 transfer30 (response)
  task ahb_slave_monitor30::collect_response30();
    // This30 monitor30 re-uses its data item for ALL30 transfers30
    transfer30 = ahb_transfer30::type_id::create("transfer30", this);
    forever begin
      @(posedge vif30.ahb_clock30 iff vif30.AHB_HREADY30 === 1);
      // Enable30 transfer30 recording30
      void'(begin_tr(transfer30, "AHB30 SLAVE30 Monitor30"));
      transfer30.data = vif30.AHB_HWDATA30;
      @(posedge vif30.ahb_clock30);
      end_tr(transfer30);
      `uvm_info(get_type_name(),
        $psprintf("slave30 transfer30 collected30 :\n%s",
        transfer30.sprint()), UVM_HIGH)
      if (checks_enable30)
        perform_checks30();
      if (coverage_enable30)
        perform_coverage30();
      // Send30 transfer30 to scoreboard30 via TLM write()
      item_collected_port30.write(transfer30);
      num_col30++;
    end
  endtask : collect_response30
  
  /***************************************************************************
  IVB30-NOTE30 : OPTIONAL30 : slave30 Monitor30 Protocol30 Checks30 : Checks30
  -------------------------------------------------------------------------
  Add protocol30 checks30 within the perform_checks30() method. 
  ***************************************************************************/
  // perform__checks30
  function void ahb_slave_monitor30::perform_checks30();
    // Add checks30 here30
  endfunction : perform_checks30
  
 /***************************************************************************
  IVB30-NOTE30 : OPTIONAL30 : slave30 Monitor30 Coverage30 : Coverage30
  -------------------------------------------------------------------------
  Modify30 the slave_transfer_cg30 coverage30 group30 to match your30 protocol30.
  Add new coverage30 groups30, and edit30 the perform_coverage30() method to sample them30
  ***************************************************************************/

  // Triggers30 coverage30 events
  function void ahb_slave_monitor30::perform_coverage30();
    slave_transfer_cg30.sample();
  endfunction : perform_coverage30

  // UVM report() phase
  function void ahb_slave_monitor30::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport30: AHB30 slave30 monitor30 collected30 %0d transfer30 responses30",
      num_col30), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV30

