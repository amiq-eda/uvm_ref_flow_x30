// IVB13 checksum13: 223843813
/*-----------------------------------------------------------------
File13 name     : ahb_slave_monitor13.sv
Created13       : Wed13 May13 19 15:42:21 2010
Description13   : This13 file implements13 the slave13 monitor13.
              : The slave13 monitor13 monitors13 the activity13 of
              : its interface bus.
Notes13         :
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV13
`define AHB_SLAVE_MONITOR_SV13

//------------------------------------------------------------------------------
//
// CLASS13: ahb_slave_monitor13
//
//------------------------------------------------------------------------------

class ahb_slave_monitor13 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive13
  // and view13 HDL signals13.
  virtual interface ahb_if13 vif13;

  // Count13 transfer13 responses13 collected13
  int num_col13;

  // The following13 two13 bits are used to control13 whether13 checks13 and coverage13 are
  // done in the monitor13
  bit checks_enable13 = 1;
  bit coverage_enable13 = 1;
  
  // This13 TLM port is used to connect the monitor13 to the scoreboard13
  uvm_analysis_port#(ahb_transfer13) item_collected_port13;

  // Current13 monitored13 transfer13 
  protected ahb_transfer13 transfer13;
 
  // Covergroup13 for transfer13
  covergroup slave_transfer_cg13;
    option.per_instance = 1;
    direction13: coverpoint transfer13.direction13;
  endgroup : slave_transfer_cg13

  // Provide13 UVM automation13 and utility13 methods13
  `uvm_component_utils_begin(ahb_slave_monitor13)
    `uvm_field_int(checks_enable13, UVM_ALL_ON)
    `uvm_field_int(coverage_enable13, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create13 the covergroup
    slave_transfer_cg13 = new();
    slave_transfer_cg13.set_inst_name("slave_transfer_cg13");
    // Create13 the TLM port
    item_collected_port13 = new("item_collected_port13", this);
  endfunction : new

  // Additional13 class methods13
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response13();
  extern virtual protected function void perform_checks13();
  extern virtual protected function void perform_coverage13();
  extern virtual function void report();

endclass : ahb_slave_monitor13

//UVM connect_phase
function void ahb_slave_monitor13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if13)::get(this, "", "vif13", vif13))
   `uvm_error("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor13::run_phase(uvm_phase phase);
    fork
      collect_response13();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB13-NOTE13 : REQUIRED13 : slave13 Monitor13 : Monitors13
   -------------------------------------------------------------------------
   Modify13 the collect_response13() method to match your13 protocol13.
   Note13 that if you change/add signals13 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect13 slave13 transfer13 (response)
  task ahb_slave_monitor13::collect_response13();
    // This13 monitor13 re-uses its data item for ALL13 transfers13
    transfer13 = ahb_transfer13::type_id::create("transfer13", this);
    forever begin
      @(posedge vif13.ahb_clock13 iff vif13.AHB_HREADY13 === 1);
      // Enable13 transfer13 recording13
      void'(begin_tr(transfer13, "AHB13 SLAVE13 Monitor13"));
      transfer13.data = vif13.AHB_HWDATA13;
      @(posedge vif13.ahb_clock13);
      end_tr(transfer13);
      `uvm_info(get_type_name(),
        $psprintf("slave13 transfer13 collected13 :\n%s",
        transfer13.sprint()), UVM_HIGH)
      if (checks_enable13)
        perform_checks13();
      if (coverage_enable13)
        perform_coverage13();
      // Send13 transfer13 to scoreboard13 via TLM write()
      item_collected_port13.write(transfer13);
      num_col13++;
    end
  endtask : collect_response13
  
  /***************************************************************************
  IVB13-NOTE13 : OPTIONAL13 : slave13 Monitor13 Protocol13 Checks13 : Checks13
  -------------------------------------------------------------------------
  Add protocol13 checks13 within the perform_checks13() method. 
  ***************************************************************************/
  // perform__checks13
  function void ahb_slave_monitor13::perform_checks13();
    // Add checks13 here13
  endfunction : perform_checks13
  
 /***************************************************************************
  IVB13-NOTE13 : OPTIONAL13 : slave13 Monitor13 Coverage13 : Coverage13
  -------------------------------------------------------------------------
  Modify13 the slave_transfer_cg13 coverage13 group13 to match your13 protocol13.
  Add new coverage13 groups13, and edit13 the perform_coverage13() method to sample them13
  ***************************************************************************/

  // Triggers13 coverage13 events
  function void ahb_slave_monitor13::perform_coverage13();
    slave_transfer_cg13.sample();
  endfunction : perform_coverage13

  // UVM report() phase
  function void ahb_slave_monitor13::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport13: AHB13 slave13 monitor13 collected13 %0d transfer13 responses13",
      num_col13), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV13

