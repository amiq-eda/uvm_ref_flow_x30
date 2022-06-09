// IVB3 checksum3: 223843813
/*-----------------------------------------------------------------
File3 name     : ahb_slave_monitor3.sv
Created3       : Wed3 May3 19 15:42:21 2010
Description3   : This3 file implements3 the slave3 monitor3.
              : The slave3 monitor3 monitors3 the activity3 of
              : its interface bus.
Notes3         :
-----------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV3
`define AHB_SLAVE_MONITOR_SV3

//------------------------------------------------------------------------------
//
// CLASS3: ahb_slave_monitor3
//
//------------------------------------------------------------------------------

class ahb_slave_monitor3 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive3
  // and view3 HDL signals3.
  virtual interface ahb_if3 vif3;

  // Count3 transfer3 responses3 collected3
  int num_col3;

  // The following3 two3 bits are used to control3 whether3 checks3 and coverage3 are
  // done in the monitor3
  bit checks_enable3 = 1;
  bit coverage_enable3 = 1;
  
  // This3 TLM port is used to connect the monitor3 to the scoreboard3
  uvm_analysis_port#(ahb_transfer3) item_collected_port3;

  // Current3 monitored3 transfer3 
  protected ahb_transfer3 transfer3;
 
  // Covergroup3 for transfer3
  covergroup slave_transfer_cg3;
    option.per_instance = 1;
    direction3: coverpoint transfer3.direction3;
  endgroup : slave_transfer_cg3

  // Provide3 UVM automation3 and utility3 methods3
  `uvm_component_utils_begin(ahb_slave_monitor3)
    `uvm_field_int(checks_enable3, UVM_ALL_ON)
    `uvm_field_int(coverage_enable3, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create3 the covergroup
    slave_transfer_cg3 = new();
    slave_transfer_cg3.set_inst_name("slave_transfer_cg3");
    // Create3 the TLM port
    item_collected_port3 = new("item_collected_port3", this);
  endfunction : new

  // Additional3 class methods3
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response3();
  extern virtual protected function void perform_checks3();
  extern virtual protected function void perform_coverage3();
  extern virtual function void report();

endclass : ahb_slave_monitor3

//UVM connect_phase
function void ahb_slave_monitor3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if3)::get(this, "", "vif3", vif3))
   `uvm_error("NOVIF3",{"virtual interface must be set for: ",get_full_name(),".vif3"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor3::run_phase(uvm_phase phase);
    fork
      collect_response3();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB3-NOTE3 : REQUIRED3 : slave3 Monitor3 : Monitors3
   -------------------------------------------------------------------------
   Modify3 the collect_response3() method to match your3 protocol3.
   Note3 that if you change/add signals3 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect3 slave3 transfer3 (response)
  task ahb_slave_monitor3::collect_response3();
    // This3 monitor3 re-uses its data item for ALL3 transfers3
    transfer3 = ahb_transfer3::type_id::create("transfer3", this);
    forever begin
      @(posedge vif3.ahb_clock3 iff vif3.AHB_HREADY3 === 1);
      // Enable3 transfer3 recording3
      void'(begin_tr(transfer3, "AHB3 SLAVE3 Monitor3"));
      transfer3.data = vif3.AHB_HWDATA3;
      @(posedge vif3.ahb_clock3);
      end_tr(transfer3);
      `uvm_info(get_type_name(),
        $psprintf("slave3 transfer3 collected3 :\n%s",
        transfer3.sprint()), UVM_HIGH)
      if (checks_enable3)
        perform_checks3();
      if (coverage_enable3)
        perform_coverage3();
      // Send3 transfer3 to scoreboard3 via TLM write()
      item_collected_port3.write(transfer3);
      num_col3++;
    end
  endtask : collect_response3
  
  /***************************************************************************
  IVB3-NOTE3 : OPTIONAL3 : slave3 Monitor3 Protocol3 Checks3 : Checks3
  -------------------------------------------------------------------------
  Add protocol3 checks3 within the perform_checks3() method. 
  ***************************************************************************/
  // perform__checks3
  function void ahb_slave_monitor3::perform_checks3();
    // Add checks3 here3
  endfunction : perform_checks3
  
 /***************************************************************************
  IVB3-NOTE3 : OPTIONAL3 : slave3 Monitor3 Coverage3 : Coverage3
  -------------------------------------------------------------------------
  Modify3 the slave_transfer_cg3 coverage3 group3 to match your3 protocol3.
  Add new coverage3 groups3, and edit3 the perform_coverage3() method to sample them3
  ***************************************************************************/

  // Triggers3 coverage3 events
  function void ahb_slave_monitor3::perform_coverage3();
    slave_transfer_cg3.sample();
  endfunction : perform_coverage3

  // UVM report() phase
  function void ahb_slave_monitor3::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport3: AHB3 slave3 monitor3 collected3 %0d transfer3 responses3",
      num_col3), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV3

