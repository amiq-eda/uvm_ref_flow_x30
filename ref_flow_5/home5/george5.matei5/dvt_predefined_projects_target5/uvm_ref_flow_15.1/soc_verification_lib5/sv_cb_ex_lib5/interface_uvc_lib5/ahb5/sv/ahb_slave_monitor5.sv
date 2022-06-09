// IVB5 checksum5: 223843813
/*-----------------------------------------------------------------
File5 name     : ahb_slave_monitor5.sv
Created5       : Wed5 May5 19 15:42:21 2010
Description5   : This5 file implements5 the slave5 monitor5.
              : The slave5 monitor5 monitors5 the activity5 of
              : its interface bus.
Notes5         :
-----------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV5
`define AHB_SLAVE_MONITOR_SV5

//------------------------------------------------------------------------------
//
// CLASS5: ahb_slave_monitor5
//
//------------------------------------------------------------------------------

class ahb_slave_monitor5 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive5
  // and view5 HDL signals5.
  virtual interface ahb_if5 vif5;

  // Count5 transfer5 responses5 collected5
  int num_col5;

  // The following5 two5 bits are used to control5 whether5 checks5 and coverage5 are
  // done in the monitor5
  bit checks_enable5 = 1;
  bit coverage_enable5 = 1;
  
  // This5 TLM port is used to connect the monitor5 to the scoreboard5
  uvm_analysis_port#(ahb_transfer5) item_collected_port5;

  // Current5 monitored5 transfer5 
  protected ahb_transfer5 transfer5;
 
  // Covergroup5 for transfer5
  covergroup slave_transfer_cg5;
    option.per_instance = 1;
    direction5: coverpoint transfer5.direction5;
  endgroup : slave_transfer_cg5

  // Provide5 UVM automation5 and utility5 methods5
  `uvm_component_utils_begin(ahb_slave_monitor5)
    `uvm_field_int(checks_enable5, UVM_ALL_ON)
    `uvm_field_int(coverage_enable5, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create5 the covergroup
    slave_transfer_cg5 = new();
    slave_transfer_cg5.set_inst_name("slave_transfer_cg5");
    // Create5 the TLM port
    item_collected_port5 = new("item_collected_port5", this);
  endfunction : new

  // Additional5 class methods5
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response5();
  extern virtual protected function void perform_checks5();
  extern virtual protected function void perform_coverage5();
  extern virtual function void report();

endclass : ahb_slave_monitor5

//UVM connect_phase
function void ahb_slave_monitor5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if5)::get(this, "", "vif5", vif5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor5::run_phase(uvm_phase phase);
    fork
      collect_response5();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB5-NOTE5 : REQUIRED5 : slave5 Monitor5 : Monitors5
   -------------------------------------------------------------------------
   Modify5 the collect_response5() method to match your5 protocol5.
   Note5 that if you change/add signals5 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect5 slave5 transfer5 (response)
  task ahb_slave_monitor5::collect_response5();
    // This5 monitor5 re-uses its data item for ALL5 transfers5
    transfer5 = ahb_transfer5::type_id::create("transfer5", this);
    forever begin
      @(posedge vif5.ahb_clock5 iff vif5.AHB_HREADY5 === 1);
      // Enable5 transfer5 recording5
      void'(begin_tr(transfer5, "AHB5 SLAVE5 Monitor5"));
      transfer5.data = vif5.AHB_HWDATA5;
      @(posedge vif5.ahb_clock5);
      end_tr(transfer5);
      `uvm_info(get_type_name(),
        $psprintf("slave5 transfer5 collected5 :\n%s",
        transfer5.sprint()), UVM_HIGH)
      if (checks_enable5)
        perform_checks5();
      if (coverage_enable5)
        perform_coverage5();
      // Send5 transfer5 to scoreboard5 via TLM write()
      item_collected_port5.write(transfer5);
      num_col5++;
    end
  endtask : collect_response5
  
  /***************************************************************************
  IVB5-NOTE5 : OPTIONAL5 : slave5 Monitor5 Protocol5 Checks5 : Checks5
  -------------------------------------------------------------------------
  Add protocol5 checks5 within the perform_checks5() method. 
  ***************************************************************************/
  // perform__checks5
  function void ahb_slave_monitor5::perform_checks5();
    // Add checks5 here5
  endfunction : perform_checks5
  
 /***************************************************************************
  IVB5-NOTE5 : OPTIONAL5 : slave5 Monitor5 Coverage5 : Coverage5
  -------------------------------------------------------------------------
  Modify5 the slave_transfer_cg5 coverage5 group5 to match your5 protocol5.
  Add new coverage5 groups5, and edit5 the perform_coverage5() method to sample them5
  ***************************************************************************/

  // Triggers5 coverage5 events
  function void ahb_slave_monitor5::perform_coverage5();
    slave_transfer_cg5.sample();
  endfunction : perform_coverage5

  // UVM report() phase
  function void ahb_slave_monitor5::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport5: AHB5 slave5 monitor5 collected5 %0d transfer5 responses5",
      num_col5), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV5

