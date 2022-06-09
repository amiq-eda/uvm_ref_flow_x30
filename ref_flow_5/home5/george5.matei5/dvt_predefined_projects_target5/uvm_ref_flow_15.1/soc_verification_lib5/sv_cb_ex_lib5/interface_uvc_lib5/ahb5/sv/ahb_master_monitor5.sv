// IVB5 checksum5: 3251807609
/*-----------------------------------------------------------------
File5 name     : ahb_master_monitor5.sv
Created5       : Wed5 May5 19 15:42:21 2010
Description5   : This5 file implements5 the master5 monitor5.
              : The master5 monitor5 monitors5 the activity5 of
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


`ifndef AHB_MASTER_MONITOR_SV5
`define AHB_MASTER_MONITOR_SV5

//------------------------------------------------------------------------------
//
// CLASS5: ahb_master_monitor5
//
//------------------------------------------------------------------------------

class ahb_master_monitor5 extends uvm_monitor;

  // Virtual Interface5 for monitoring5 DUT signals5
  virtual interface ahb_if5 vif5;

  // Count5 transfers5 collected5
  int num_col5;
  event transaction_ended5;
 
  // The following5 two5 bits are used to control5 whether5 checks5 and coverage5 are
  // done in the monitor5
  bit checks_enable5 = 1;
  bit coverage_enable5 = 1;

  // This5 TLM port is used to connect the monitor5 to the scoreboard5
  uvm_analysis_port #(ahb_transfer5) item_collected_port5;

  // Current5 monitored5 transfer5
  protected ahb_transfer5 transfer5;

  // Covergroup5 for transfer5
  covergroup master_transfer_cg5;
    option.per_instance = 1;
    direction5 : coverpoint transfer5.direction5;
  endgroup : master_transfer_cg5
 
  // Provide5 UVM automation5 and utility5 methods5
  `uvm_component_utils_begin(ahb_master_monitor5)
    `uvm_field_int(checks_enable5, UVM_ALL_ON)
    `uvm_field_int(coverage_enable5, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor5 - required5 syntax5 for UVM automation5 and utilities5
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create5 the covergroup
    master_transfer_cg5 = new();
    master_transfer_cg5.set_inst_name("master_transfer_cg5");
    // Create5 the TLM port
    item_collected_port5 = new("item_collected_port5", this);
  endfunction : new

  // Additional5 class methods5
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer5();
  extern virtual protected function void perform_checks5();
  extern virtual protected function void perform_coverage5();
  extern virtual function void report();

endclass : ahb_master_monitor5

//UVM connect_phase
function void ahb_master_monitor5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if5)::get(this, "", "vif5", vif5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor5::run_phase(uvm_phase phase);
    fork
      collect_transfer5();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB5-NOTE5 : REQUIRED5 : master5 Monitor5 : Monitors5
   -------------------------------------------------------------------------
   Modify5 the collect_transfers5() method to match your5 protocol5.
   Note5 that if you change/add signals5 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor5::collect_transfer5();
    // This5 monitor5 re-uses its data items for ALL5 transfers5
    transfer5 = ahb_transfer5::type_id::create("transfer5", this);
    forever begin
      @(posedge vif5.ahb_clock5 iff vif5.AHB_HTRANS5 === NONSEQ5);
      // Begin5 transaction recording5
      void'(begin_tr(transfer5, "AHB5 MASTER5 Monitor5"));
      transfer5.address = vif5.AHB_HADDR5;
      transfer5.direction5 = ahb_direction5'(vif5.AHB_HWRITE5);
      transfer5.hsize5 = ahb_transfer_size5'(0);  //Not used - hance5 assign dummy
      transfer5.burst = ahb_burst_kind5'(0);     //Not used - hance5 assign dummy
      @(posedge vif5.ahb_clock5 iff vif5.AHB_HREADY5 === 1);
      // End5 transaction recording5
        if(transfer5.direction5 == WRITE) 
          transfer5.data = vif5.AHB_HWDATA5;
        else
          transfer5.data = vif5.AHB_HRDATA5;
        ;
      @(posedge vif5.ahb_clock5 iff vif5.AHB_HREADY5 === 1);
    end_tr(transfer5);
      `uvm_info(get_type_name(), 
        $psprintf("master5 transfer5 collected5 :\n%s", 
        transfer5.sprint()), UVM_HIGH)
      if (checks_enable5)
         perform_checks5();
      if (coverage_enable5)
         perform_coverage5();
      // Send5 transfer5 to scoreboard5 via TLM write()
      item_collected_port5.write(transfer5);
      -> transaction_ended5;
      num_col5++;
    end
  endtask : collect_transfer5
  
  /***************************************************************************
   IVB5-NOTE5 : OPTIONAL5 : master5 Monitor5 Protocol5 Checks5 : Checks5
   -------------------------------------------------------------------------
   Add protocol5 checks5 within the perform_checks5() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks5
  function void ahb_master_monitor5::perform_checks5();
    // Add checks5 here5
  endfunction : perform_checks5
  
 /***************************************************************************
  IVB5-NOTE5 : OPTIONAL5 : master5 Monitor5 Coverage5 : Coverage5
  -------------------------------------------------------------------------
  Modify5 the master_transfer_cg5 coverage5 group5 to match your5 protocol5.
  Add new coverage5 groups5, and edit5 the perform_coverage5() method to sample 
  them5.
  ***************************************************************************/

  // Triggers5 coverage5 events
  function void ahb_master_monitor5::perform_coverage5();
    master_transfer_cg5.sample();
  endfunction : perform_coverage5

  // UVM report() phase
  function void ahb_master_monitor5::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport5: AHB5 master5 monitor5 collected5 %0d transfers5", num_col5),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV5

