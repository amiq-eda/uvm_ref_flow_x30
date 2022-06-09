// IVB4 checksum4: 223843813
/*-----------------------------------------------------------------
File4 name     : ahb_slave_monitor4.sv
Created4       : Wed4 May4 19 15:42:21 2010
Description4   : This4 file implements4 the slave4 monitor4.
              : The slave4 monitor4 monitors4 the activity4 of
              : its interface bus.
Notes4         :
-----------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV4
`define AHB_SLAVE_MONITOR_SV4

//------------------------------------------------------------------------------
//
// CLASS4: ahb_slave_monitor4
//
//------------------------------------------------------------------------------

class ahb_slave_monitor4 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive4
  // and view4 HDL signals4.
  virtual interface ahb_if4 vif4;

  // Count4 transfer4 responses4 collected4
  int num_col4;

  // The following4 two4 bits are used to control4 whether4 checks4 and coverage4 are
  // done in the monitor4
  bit checks_enable4 = 1;
  bit coverage_enable4 = 1;
  
  // This4 TLM port is used to connect the monitor4 to the scoreboard4
  uvm_analysis_port#(ahb_transfer4) item_collected_port4;

  // Current4 monitored4 transfer4 
  protected ahb_transfer4 transfer4;
 
  // Covergroup4 for transfer4
  covergroup slave_transfer_cg4;
    option.per_instance = 1;
    direction4: coverpoint transfer4.direction4;
  endgroup : slave_transfer_cg4

  // Provide4 UVM automation4 and utility4 methods4
  `uvm_component_utils_begin(ahb_slave_monitor4)
    `uvm_field_int(checks_enable4, UVM_ALL_ON)
    `uvm_field_int(coverage_enable4, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor4 - required4 syntax4 for UVM automation4 and utilities4
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create4 the covergroup
    slave_transfer_cg4 = new();
    slave_transfer_cg4.set_inst_name("slave_transfer_cg4");
    // Create4 the TLM port
    item_collected_port4 = new("item_collected_port4", this);
  endfunction : new

  // Additional4 class methods4
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response4();
  extern virtual protected function void perform_checks4();
  extern virtual protected function void perform_coverage4();
  extern virtual function void report();

endclass : ahb_slave_monitor4

//UVM connect_phase
function void ahb_slave_monitor4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if4)::get(this, "", "vif4", vif4))
   `uvm_error("NOVIF4",{"virtual interface must be set for: ",get_full_name(),".vif4"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor4::run_phase(uvm_phase phase);
    fork
      collect_response4();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB4-NOTE4 : REQUIRED4 : slave4 Monitor4 : Monitors4
   -------------------------------------------------------------------------
   Modify4 the collect_response4() method to match your4 protocol4.
   Note4 that if you change/add signals4 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect4 slave4 transfer4 (response)
  task ahb_slave_monitor4::collect_response4();
    // This4 monitor4 re-uses its data item for ALL4 transfers4
    transfer4 = ahb_transfer4::type_id::create("transfer4", this);
    forever begin
      @(posedge vif4.ahb_clock4 iff vif4.AHB_HREADY4 === 1);
      // Enable4 transfer4 recording4
      void'(begin_tr(transfer4, "AHB4 SLAVE4 Monitor4"));
      transfer4.data = vif4.AHB_HWDATA4;
      @(posedge vif4.ahb_clock4);
      end_tr(transfer4);
      `uvm_info(get_type_name(),
        $psprintf("slave4 transfer4 collected4 :\n%s",
        transfer4.sprint()), UVM_HIGH)
      if (checks_enable4)
        perform_checks4();
      if (coverage_enable4)
        perform_coverage4();
      // Send4 transfer4 to scoreboard4 via TLM write()
      item_collected_port4.write(transfer4);
      num_col4++;
    end
  endtask : collect_response4
  
  /***************************************************************************
  IVB4-NOTE4 : OPTIONAL4 : slave4 Monitor4 Protocol4 Checks4 : Checks4
  -------------------------------------------------------------------------
  Add protocol4 checks4 within the perform_checks4() method. 
  ***************************************************************************/
  // perform__checks4
  function void ahb_slave_monitor4::perform_checks4();
    // Add checks4 here4
  endfunction : perform_checks4
  
 /***************************************************************************
  IVB4-NOTE4 : OPTIONAL4 : slave4 Monitor4 Coverage4 : Coverage4
  -------------------------------------------------------------------------
  Modify4 the slave_transfer_cg4 coverage4 group4 to match your4 protocol4.
  Add new coverage4 groups4, and edit4 the perform_coverage4() method to sample them4
  ***************************************************************************/

  // Triggers4 coverage4 events
  function void ahb_slave_monitor4::perform_coverage4();
    slave_transfer_cg4.sample();
  endfunction : perform_coverage4

  // UVM report() phase
  function void ahb_slave_monitor4::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport4: AHB4 slave4 monitor4 collected4 %0d transfer4 responses4",
      num_col4), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV4

