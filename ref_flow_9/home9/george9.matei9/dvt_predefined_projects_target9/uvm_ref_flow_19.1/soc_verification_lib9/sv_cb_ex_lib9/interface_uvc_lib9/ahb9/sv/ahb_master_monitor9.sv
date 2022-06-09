// IVB9 checksum9: 3251807609
/*-----------------------------------------------------------------
File9 name     : ahb_master_monitor9.sv
Created9       : Wed9 May9 19 15:42:21 2010
Description9   : This9 file implements9 the master9 monitor9.
              : The master9 monitor9 monitors9 the activity9 of
              : its interface bus.
Notes9         :
-----------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV9
`define AHB_MASTER_MONITOR_SV9

//------------------------------------------------------------------------------
//
// CLASS9: ahb_master_monitor9
//
//------------------------------------------------------------------------------

class ahb_master_monitor9 extends uvm_monitor;

  // Virtual Interface9 for monitoring9 DUT signals9
  virtual interface ahb_if9 vif9;

  // Count9 transfers9 collected9
  int num_col9;
  event transaction_ended9;
 
  // The following9 two9 bits are used to control9 whether9 checks9 and coverage9 are
  // done in the monitor9
  bit checks_enable9 = 1;
  bit coverage_enable9 = 1;

  // This9 TLM port is used to connect the monitor9 to the scoreboard9
  uvm_analysis_port #(ahb_transfer9) item_collected_port9;

  // Current9 monitored9 transfer9
  protected ahb_transfer9 transfer9;

  // Covergroup9 for transfer9
  covergroup master_transfer_cg9;
    option.per_instance = 1;
    direction9 : coverpoint transfer9.direction9;
  endgroup : master_transfer_cg9
 
  // Provide9 UVM automation9 and utility9 methods9
  `uvm_component_utils_begin(ahb_master_monitor9)
    `uvm_field_int(checks_enable9, UVM_ALL_ON)
    `uvm_field_int(coverage_enable9, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor9 - required9 syntax9 for UVM automation9 and utilities9
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create9 the covergroup
    master_transfer_cg9 = new();
    master_transfer_cg9.set_inst_name("master_transfer_cg9");
    // Create9 the TLM port
    item_collected_port9 = new("item_collected_port9", this);
  endfunction : new

  // Additional9 class methods9
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer9();
  extern virtual protected function void perform_checks9();
  extern virtual protected function void perform_coverage9();
  extern virtual function void report();

endclass : ahb_master_monitor9

//UVM connect_phase
function void ahb_master_monitor9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if9)::get(this, "", "vif9", vif9))
   `uvm_error("NOVIF9",{"virtual interface must be set for: ",get_full_name(),".vif9"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor9::run_phase(uvm_phase phase);
    fork
      collect_transfer9();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB9-NOTE9 : REQUIRED9 : master9 Monitor9 : Monitors9
   -------------------------------------------------------------------------
   Modify9 the collect_transfers9() method to match your9 protocol9.
   Note9 that if you change/add signals9 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor9::collect_transfer9();
    // This9 monitor9 re-uses its data items for ALL9 transfers9
    transfer9 = ahb_transfer9::type_id::create("transfer9", this);
    forever begin
      @(posedge vif9.ahb_clock9 iff vif9.AHB_HTRANS9 === NONSEQ9);
      // Begin9 transaction recording9
      void'(begin_tr(transfer9, "AHB9 MASTER9 Monitor9"));
      transfer9.address = vif9.AHB_HADDR9;
      transfer9.direction9 = ahb_direction9'(vif9.AHB_HWRITE9);
      transfer9.hsize9 = ahb_transfer_size9'(0);  //Not used - hance9 assign dummy
      transfer9.burst = ahb_burst_kind9'(0);     //Not used - hance9 assign dummy
      @(posedge vif9.ahb_clock9 iff vif9.AHB_HREADY9 === 1);
      // End9 transaction recording9
        if(transfer9.direction9 == WRITE) 
          transfer9.data = vif9.AHB_HWDATA9;
        else
          transfer9.data = vif9.AHB_HRDATA9;
        ;
      @(posedge vif9.ahb_clock9 iff vif9.AHB_HREADY9 === 1);
    end_tr(transfer9);
      `uvm_info(get_type_name(), 
        $psprintf("master9 transfer9 collected9 :\n%s", 
        transfer9.sprint()), UVM_HIGH)
      if (checks_enable9)
         perform_checks9();
      if (coverage_enable9)
         perform_coverage9();
      // Send9 transfer9 to scoreboard9 via TLM write()
      item_collected_port9.write(transfer9);
      -> transaction_ended9;
      num_col9++;
    end
  endtask : collect_transfer9
  
  /***************************************************************************
   IVB9-NOTE9 : OPTIONAL9 : master9 Monitor9 Protocol9 Checks9 : Checks9
   -------------------------------------------------------------------------
   Add protocol9 checks9 within the perform_checks9() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks9
  function void ahb_master_monitor9::perform_checks9();
    // Add checks9 here9
  endfunction : perform_checks9
  
 /***************************************************************************
  IVB9-NOTE9 : OPTIONAL9 : master9 Monitor9 Coverage9 : Coverage9
  -------------------------------------------------------------------------
  Modify9 the master_transfer_cg9 coverage9 group9 to match your9 protocol9.
  Add new coverage9 groups9, and edit9 the perform_coverage9() method to sample 
  them9.
  ***************************************************************************/

  // Triggers9 coverage9 events
  function void ahb_master_monitor9::perform_coverage9();
    master_transfer_cg9.sample();
  endfunction : perform_coverage9

  // UVM report() phase
  function void ahb_master_monitor9::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport9: AHB9 master9 monitor9 collected9 %0d transfers9", num_col9),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV9

