// IVB20 checksum20: 223843813
/*-----------------------------------------------------------------
File20 name     : ahb_slave_monitor20.sv
Created20       : Wed20 May20 19 15:42:21 2010
Description20   : This20 file implements20 the slave20 monitor20.
              : The slave20 monitor20 monitors20 the activity20 of
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


`ifndef AHB_SLAVE_MONITOR_SV20
`define AHB_SLAVE_MONITOR_SV20

//------------------------------------------------------------------------------
//
// CLASS20: ahb_slave_monitor20
//
//------------------------------------------------------------------------------

class ahb_slave_monitor20 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive20
  // and view20 HDL signals20.
  virtual interface ahb_if20 vif20;

  // Count20 transfer20 responses20 collected20
  int num_col20;

  // The following20 two20 bits are used to control20 whether20 checks20 and coverage20 are
  // done in the monitor20
  bit checks_enable20 = 1;
  bit coverage_enable20 = 1;
  
  // This20 TLM port is used to connect the monitor20 to the scoreboard20
  uvm_analysis_port#(ahb_transfer20) item_collected_port20;

  // Current20 monitored20 transfer20 
  protected ahb_transfer20 transfer20;
 
  // Covergroup20 for transfer20
  covergroup slave_transfer_cg20;
    option.per_instance = 1;
    direction20: coverpoint transfer20.direction20;
  endgroup : slave_transfer_cg20

  // Provide20 UVM automation20 and utility20 methods20
  `uvm_component_utils_begin(ahb_slave_monitor20)
    `uvm_field_int(checks_enable20, UVM_ALL_ON)
    `uvm_field_int(coverage_enable20, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor20 - required20 syntax20 for UVM automation20 and utilities20
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create20 the covergroup
    slave_transfer_cg20 = new();
    slave_transfer_cg20.set_inst_name("slave_transfer_cg20");
    // Create20 the TLM port
    item_collected_port20 = new("item_collected_port20", this);
  endfunction : new

  // Additional20 class methods20
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response20();
  extern virtual protected function void perform_checks20();
  extern virtual protected function void perform_coverage20();
  extern virtual function void report();

endclass : ahb_slave_monitor20

//UVM connect_phase
function void ahb_slave_monitor20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if20)::get(this, "", "vif20", vif20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor20::run_phase(uvm_phase phase);
    fork
      collect_response20();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB20-NOTE20 : REQUIRED20 : slave20 Monitor20 : Monitors20
   -------------------------------------------------------------------------
   Modify20 the collect_response20() method to match your20 protocol20.
   Note20 that if you change/add signals20 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect20 slave20 transfer20 (response)
  task ahb_slave_monitor20::collect_response20();
    // This20 monitor20 re-uses its data item for ALL20 transfers20
    transfer20 = ahb_transfer20::type_id::create("transfer20", this);
    forever begin
      @(posedge vif20.ahb_clock20 iff vif20.AHB_HREADY20 === 1);
      // Enable20 transfer20 recording20
      void'(begin_tr(transfer20, "AHB20 SLAVE20 Monitor20"));
      transfer20.data = vif20.AHB_HWDATA20;
      @(posedge vif20.ahb_clock20);
      end_tr(transfer20);
      `uvm_info(get_type_name(),
        $psprintf("slave20 transfer20 collected20 :\n%s",
        transfer20.sprint()), UVM_HIGH)
      if (checks_enable20)
        perform_checks20();
      if (coverage_enable20)
        perform_coverage20();
      // Send20 transfer20 to scoreboard20 via TLM write()
      item_collected_port20.write(transfer20);
      num_col20++;
    end
  endtask : collect_response20
  
  /***************************************************************************
  IVB20-NOTE20 : OPTIONAL20 : slave20 Monitor20 Protocol20 Checks20 : Checks20
  -------------------------------------------------------------------------
  Add protocol20 checks20 within the perform_checks20() method. 
  ***************************************************************************/
  // perform__checks20
  function void ahb_slave_monitor20::perform_checks20();
    // Add checks20 here20
  endfunction : perform_checks20
  
 /***************************************************************************
  IVB20-NOTE20 : OPTIONAL20 : slave20 Monitor20 Coverage20 : Coverage20
  -------------------------------------------------------------------------
  Modify20 the slave_transfer_cg20 coverage20 group20 to match your20 protocol20.
  Add new coverage20 groups20, and edit20 the perform_coverage20() method to sample them20
  ***************************************************************************/

  // Triggers20 coverage20 events
  function void ahb_slave_monitor20::perform_coverage20();
    slave_transfer_cg20.sample();
  endfunction : perform_coverage20

  // UVM report() phase
  function void ahb_slave_monitor20::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport20: AHB20 slave20 monitor20 collected20 %0d transfer20 responses20",
      num_col20), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV20

