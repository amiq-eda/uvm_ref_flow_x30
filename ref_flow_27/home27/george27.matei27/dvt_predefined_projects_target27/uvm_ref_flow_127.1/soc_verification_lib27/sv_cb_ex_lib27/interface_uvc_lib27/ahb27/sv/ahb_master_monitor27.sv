// IVB27 checksum27: 3251807609
/*-----------------------------------------------------------------
File27 name     : ahb_master_monitor27.sv
Created27       : Wed27 May27 19 15:42:21 2010
Description27   : This27 file implements27 the master27 monitor27.
              : The master27 monitor27 monitors27 the activity27 of
              : its interface bus.
Notes27         :
-----------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV27
`define AHB_MASTER_MONITOR_SV27

//------------------------------------------------------------------------------
//
// CLASS27: ahb_master_monitor27
//
//------------------------------------------------------------------------------

class ahb_master_monitor27 extends uvm_monitor;

  // Virtual Interface27 for monitoring27 DUT signals27
  virtual interface ahb_if27 vif27;

  // Count27 transfers27 collected27
  int num_col27;
  event transaction_ended27;
 
  // The following27 two27 bits are used to control27 whether27 checks27 and coverage27 are
  // done in the monitor27
  bit checks_enable27 = 1;
  bit coverage_enable27 = 1;

  // This27 TLM port is used to connect the monitor27 to the scoreboard27
  uvm_analysis_port #(ahb_transfer27) item_collected_port27;

  // Current27 monitored27 transfer27
  protected ahb_transfer27 transfer27;

  // Covergroup27 for transfer27
  covergroup master_transfer_cg27;
    option.per_instance = 1;
    direction27 : coverpoint transfer27.direction27;
  endgroup : master_transfer_cg27
 
  // Provide27 UVM automation27 and utility27 methods27
  `uvm_component_utils_begin(ahb_master_monitor27)
    `uvm_field_int(checks_enable27, UVM_ALL_ON)
    `uvm_field_int(coverage_enable27, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor27 - required27 syntax27 for UVM automation27 and utilities27
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create27 the covergroup
    master_transfer_cg27 = new();
    master_transfer_cg27.set_inst_name("master_transfer_cg27");
    // Create27 the TLM port
    item_collected_port27 = new("item_collected_port27", this);
  endfunction : new

  // Additional27 class methods27
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer27();
  extern virtual protected function void perform_checks27();
  extern virtual protected function void perform_coverage27();
  extern virtual function void report();

endclass : ahb_master_monitor27

//UVM connect_phase
function void ahb_master_monitor27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if27)::get(this, "", "vif27", vif27))
   `uvm_error("NOVIF27",{"virtual interface must be set for: ",get_full_name(),".vif27"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor27::run_phase(uvm_phase phase);
    fork
      collect_transfer27();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB27-NOTE27 : REQUIRED27 : master27 Monitor27 : Monitors27
   -------------------------------------------------------------------------
   Modify27 the collect_transfers27() method to match your27 protocol27.
   Note27 that if you change/add signals27 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor27::collect_transfer27();
    // This27 monitor27 re-uses its data items for ALL27 transfers27
    transfer27 = ahb_transfer27::type_id::create("transfer27", this);
    forever begin
      @(posedge vif27.ahb_clock27 iff vif27.AHB_HTRANS27 === NONSEQ27);
      // Begin27 transaction recording27
      void'(begin_tr(transfer27, "AHB27 MASTER27 Monitor27"));
      transfer27.address = vif27.AHB_HADDR27;
      transfer27.direction27 = ahb_direction27'(vif27.AHB_HWRITE27);
      transfer27.hsize27 = ahb_transfer_size27'(0);  //Not used - hance27 assign dummy
      transfer27.burst = ahb_burst_kind27'(0);     //Not used - hance27 assign dummy
      @(posedge vif27.ahb_clock27 iff vif27.AHB_HREADY27 === 1);
      // End27 transaction recording27
        if(transfer27.direction27 == WRITE) 
          transfer27.data = vif27.AHB_HWDATA27;
        else
          transfer27.data = vif27.AHB_HRDATA27;
        ;
      @(posedge vif27.ahb_clock27 iff vif27.AHB_HREADY27 === 1);
    end_tr(transfer27);
      `uvm_info(get_type_name(), 
        $psprintf("master27 transfer27 collected27 :\n%s", 
        transfer27.sprint()), UVM_HIGH)
      if (checks_enable27)
         perform_checks27();
      if (coverage_enable27)
         perform_coverage27();
      // Send27 transfer27 to scoreboard27 via TLM write()
      item_collected_port27.write(transfer27);
      -> transaction_ended27;
      num_col27++;
    end
  endtask : collect_transfer27
  
  /***************************************************************************
   IVB27-NOTE27 : OPTIONAL27 : master27 Monitor27 Protocol27 Checks27 : Checks27
   -------------------------------------------------------------------------
   Add protocol27 checks27 within the perform_checks27() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks27
  function void ahb_master_monitor27::perform_checks27();
    // Add checks27 here27
  endfunction : perform_checks27
  
 /***************************************************************************
  IVB27-NOTE27 : OPTIONAL27 : master27 Monitor27 Coverage27 : Coverage27
  -------------------------------------------------------------------------
  Modify27 the master_transfer_cg27 coverage27 group27 to match your27 protocol27.
  Add new coverage27 groups27, and edit27 the perform_coverage27() method to sample 
  them27.
  ***************************************************************************/

  // Triggers27 coverage27 events
  function void ahb_master_monitor27::perform_coverage27();
    master_transfer_cg27.sample();
  endfunction : perform_coverage27

  // UVM report() phase
  function void ahb_master_monitor27::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport27: AHB27 master27 monitor27 collected27 %0d transfers27", num_col27),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV27

