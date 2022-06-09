// IVB1 checksum1: 223843813
/*-----------------------------------------------------------------
File1 name     : ahb_slave_monitor1.sv
Created1       : Wed1 May1 19 15:42:21 2010
Description1   : This1 file implements1 the slave1 monitor1.
              : The slave1 monitor1 monitors1 the activity1 of
              : its interface bus.
Notes1         :
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV1
`define AHB_SLAVE_MONITOR_SV1

//------------------------------------------------------------------------------
//
// CLASS1: ahb_slave_monitor1
//
//------------------------------------------------------------------------------

class ahb_slave_monitor1 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive1
  // and view1 HDL signals1.
  virtual interface ahb_if1 vif1;

  // Count1 transfer1 responses1 collected1
  int num_col1;

  // The following1 two1 bits are used to control1 whether1 checks1 and coverage1 are
  // done in the monitor1
  bit checks_enable1 = 1;
  bit coverage_enable1 = 1;
  
  // This1 TLM port is used to connect the monitor1 to the scoreboard1
  uvm_analysis_port#(ahb_transfer1) item_collected_port1;

  // Current1 monitored1 transfer1 
  protected ahb_transfer1 transfer1;
 
  // Covergroup1 for transfer1
  covergroup slave_transfer_cg1;
    option.per_instance = 1;
    direction1: coverpoint transfer1.direction1;
  endgroup : slave_transfer_cg1

  // Provide1 UVM automation1 and utility1 methods1
  `uvm_component_utils_begin(ahb_slave_monitor1)
    `uvm_field_int(checks_enable1, UVM_ALL_ON)
    `uvm_field_int(coverage_enable1, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor1 - required1 syntax1 for UVM automation1 and utilities1
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create1 the covergroup
    slave_transfer_cg1 = new();
    slave_transfer_cg1.set_inst_name("slave_transfer_cg1");
    // Create1 the TLM port
    item_collected_port1 = new("item_collected_port1", this);
  endfunction : new

  // Additional1 class methods1
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response1();
  extern virtual protected function void perform_checks1();
  extern virtual protected function void perform_coverage1();
  extern virtual function void report();

endclass : ahb_slave_monitor1

//UVM connect_phase
function void ahb_slave_monitor1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if1)::get(this, "", "vif1", vif1))
   `uvm_error("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor1::run_phase(uvm_phase phase);
    fork
      collect_response1();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB1-NOTE1 : REQUIRED1 : slave1 Monitor1 : Monitors1
   -------------------------------------------------------------------------
   Modify1 the collect_response1() method to match your1 protocol1.
   Note1 that if you change/add signals1 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect1 slave1 transfer1 (response)
  task ahb_slave_monitor1::collect_response1();
    // This1 monitor1 re-uses its data item for ALL1 transfers1
    transfer1 = ahb_transfer1::type_id::create("transfer1", this);
    forever begin
      @(posedge vif1.ahb_clock1 iff vif1.AHB_HREADY1 === 1);
      // Enable1 transfer1 recording1
      void'(begin_tr(transfer1, "AHB1 SLAVE1 Monitor1"));
      transfer1.data = vif1.AHB_HWDATA1;
      @(posedge vif1.ahb_clock1);
      end_tr(transfer1);
      `uvm_info(get_type_name(),
        $psprintf("slave1 transfer1 collected1 :\n%s",
        transfer1.sprint()), UVM_HIGH)
      if (checks_enable1)
        perform_checks1();
      if (coverage_enable1)
        perform_coverage1();
      // Send1 transfer1 to scoreboard1 via TLM write()
      item_collected_port1.write(transfer1);
      num_col1++;
    end
  endtask : collect_response1
  
  /***************************************************************************
  IVB1-NOTE1 : OPTIONAL1 : slave1 Monitor1 Protocol1 Checks1 : Checks1
  -------------------------------------------------------------------------
  Add protocol1 checks1 within the perform_checks1() method. 
  ***************************************************************************/
  // perform__checks1
  function void ahb_slave_monitor1::perform_checks1();
    // Add checks1 here1
  endfunction : perform_checks1
  
 /***************************************************************************
  IVB1-NOTE1 : OPTIONAL1 : slave1 Monitor1 Coverage1 : Coverage1
  -------------------------------------------------------------------------
  Modify1 the slave_transfer_cg1 coverage1 group1 to match your1 protocol1.
  Add new coverage1 groups1, and edit1 the perform_coverage1() method to sample them1
  ***************************************************************************/

  // Triggers1 coverage1 events
  function void ahb_slave_monitor1::perform_coverage1();
    slave_transfer_cg1.sample();
  endfunction : perform_coverage1

  // UVM report() phase
  function void ahb_slave_monitor1::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport1: AHB1 slave1 monitor1 collected1 %0d transfer1 responses1",
      num_col1), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV1

