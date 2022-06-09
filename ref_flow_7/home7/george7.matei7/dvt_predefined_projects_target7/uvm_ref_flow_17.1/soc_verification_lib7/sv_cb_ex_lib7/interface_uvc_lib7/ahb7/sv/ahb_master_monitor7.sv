// IVB7 checksum7: 3251807609
/*-----------------------------------------------------------------
File7 name     : ahb_master_monitor7.sv
Created7       : Wed7 May7 19 15:42:21 2010
Description7   : This7 file implements7 the master7 monitor7.
              : The master7 monitor7 monitors7 the activity7 of
              : its interface bus.
Notes7         :
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV7
`define AHB_MASTER_MONITOR_SV7

//------------------------------------------------------------------------------
//
// CLASS7: ahb_master_monitor7
//
//------------------------------------------------------------------------------

class ahb_master_monitor7 extends uvm_monitor;

  // Virtual Interface7 for monitoring7 DUT signals7
  virtual interface ahb_if7 vif7;

  // Count7 transfers7 collected7
  int num_col7;
  event transaction_ended7;
 
  // The following7 two7 bits are used to control7 whether7 checks7 and coverage7 are
  // done in the monitor7
  bit checks_enable7 = 1;
  bit coverage_enable7 = 1;

  // This7 TLM port is used to connect the monitor7 to the scoreboard7
  uvm_analysis_port #(ahb_transfer7) item_collected_port7;

  // Current7 monitored7 transfer7
  protected ahb_transfer7 transfer7;

  // Covergroup7 for transfer7
  covergroup master_transfer_cg7;
    option.per_instance = 1;
    direction7 : coverpoint transfer7.direction7;
  endgroup : master_transfer_cg7
 
  // Provide7 UVM automation7 and utility7 methods7
  `uvm_component_utils_begin(ahb_master_monitor7)
    `uvm_field_int(checks_enable7, UVM_ALL_ON)
    `uvm_field_int(coverage_enable7, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor7 - required7 syntax7 for UVM automation7 and utilities7
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create7 the covergroup
    master_transfer_cg7 = new();
    master_transfer_cg7.set_inst_name("master_transfer_cg7");
    // Create7 the TLM port
    item_collected_port7 = new("item_collected_port7", this);
  endfunction : new

  // Additional7 class methods7
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer7();
  extern virtual protected function void perform_checks7();
  extern virtual protected function void perform_coverage7();
  extern virtual function void report();

endclass : ahb_master_monitor7

//UVM connect_phase
function void ahb_master_monitor7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if7)::get(this, "", "vif7", vif7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor7::run_phase(uvm_phase phase);
    fork
      collect_transfer7();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB7-NOTE7 : REQUIRED7 : master7 Monitor7 : Monitors7
   -------------------------------------------------------------------------
   Modify7 the collect_transfers7() method to match your7 protocol7.
   Note7 that if you change/add signals7 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor7::collect_transfer7();
    // This7 monitor7 re-uses its data items for ALL7 transfers7
    transfer7 = ahb_transfer7::type_id::create("transfer7", this);
    forever begin
      @(posedge vif7.ahb_clock7 iff vif7.AHB_HTRANS7 === NONSEQ7);
      // Begin7 transaction recording7
      void'(begin_tr(transfer7, "AHB7 MASTER7 Monitor7"));
      transfer7.address = vif7.AHB_HADDR7;
      transfer7.direction7 = ahb_direction7'(vif7.AHB_HWRITE7);
      transfer7.hsize7 = ahb_transfer_size7'(0);  //Not used - hance7 assign dummy
      transfer7.burst = ahb_burst_kind7'(0);     //Not used - hance7 assign dummy
      @(posedge vif7.ahb_clock7 iff vif7.AHB_HREADY7 === 1);
      // End7 transaction recording7
        if(transfer7.direction7 == WRITE) 
          transfer7.data = vif7.AHB_HWDATA7;
        else
          transfer7.data = vif7.AHB_HRDATA7;
        ;
      @(posedge vif7.ahb_clock7 iff vif7.AHB_HREADY7 === 1);
    end_tr(transfer7);
      `uvm_info(get_type_name(), 
        $psprintf("master7 transfer7 collected7 :\n%s", 
        transfer7.sprint()), UVM_HIGH)
      if (checks_enable7)
         perform_checks7();
      if (coverage_enable7)
         perform_coverage7();
      // Send7 transfer7 to scoreboard7 via TLM write()
      item_collected_port7.write(transfer7);
      -> transaction_ended7;
      num_col7++;
    end
  endtask : collect_transfer7
  
  /***************************************************************************
   IVB7-NOTE7 : OPTIONAL7 : master7 Monitor7 Protocol7 Checks7 : Checks7
   -------------------------------------------------------------------------
   Add protocol7 checks7 within the perform_checks7() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks7
  function void ahb_master_monitor7::perform_checks7();
    // Add checks7 here7
  endfunction : perform_checks7
  
 /***************************************************************************
  IVB7-NOTE7 : OPTIONAL7 : master7 Monitor7 Coverage7 : Coverage7
  -------------------------------------------------------------------------
  Modify7 the master_transfer_cg7 coverage7 group7 to match your7 protocol7.
  Add new coverage7 groups7, and edit7 the perform_coverage7() method to sample 
  them7.
  ***************************************************************************/

  // Triggers7 coverage7 events
  function void ahb_master_monitor7::perform_coverage7();
    master_transfer_cg7.sample();
  endfunction : perform_coverage7

  // UVM report() phase
  function void ahb_master_monitor7::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport7: AHB7 master7 monitor7 collected7 %0d transfers7", num_col7),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV7

