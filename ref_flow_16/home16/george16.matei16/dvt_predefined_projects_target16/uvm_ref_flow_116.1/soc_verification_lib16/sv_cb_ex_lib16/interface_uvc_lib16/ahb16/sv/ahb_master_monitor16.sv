// IVB16 checksum16: 3251807609
/*-----------------------------------------------------------------
File16 name     : ahb_master_monitor16.sv
Created16       : Wed16 May16 19 15:42:21 2010
Description16   : This16 file implements16 the master16 monitor16.
              : The master16 monitor16 monitors16 the activity16 of
              : its interface bus.
Notes16         :
-----------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV16
`define AHB_MASTER_MONITOR_SV16

//------------------------------------------------------------------------------
//
// CLASS16: ahb_master_monitor16
//
//------------------------------------------------------------------------------

class ahb_master_monitor16 extends uvm_monitor;

  // Virtual Interface16 for monitoring16 DUT signals16
  virtual interface ahb_if16 vif16;

  // Count16 transfers16 collected16
  int num_col16;
  event transaction_ended16;
 
  // The following16 two16 bits are used to control16 whether16 checks16 and coverage16 are
  // done in the monitor16
  bit checks_enable16 = 1;
  bit coverage_enable16 = 1;

  // This16 TLM port is used to connect the monitor16 to the scoreboard16
  uvm_analysis_port #(ahb_transfer16) item_collected_port16;

  // Current16 monitored16 transfer16
  protected ahb_transfer16 transfer16;

  // Covergroup16 for transfer16
  covergroup master_transfer_cg16;
    option.per_instance = 1;
    direction16 : coverpoint transfer16.direction16;
  endgroup : master_transfer_cg16
 
  // Provide16 UVM automation16 and utility16 methods16
  `uvm_component_utils_begin(ahb_master_monitor16)
    `uvm_field_int(checks_enable16, UVM_ALL_ON)
    `uvm_field_int(coverage_enable16, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor16 - required16 syntax16 for UVM automation16 and utilities16
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create16 the covergroup
    master_transfer_cg16 = new();
    master_transfer_cg16.set_inst_name("master_transfer_cg16");
    // Create16 the TLM port
    item_collected_port16 = new("item_collected_port16", this);
  endfunction : new

  // Additional16 class methods16
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer16();
  extern virtual protected function void perform_checks16();
  extern virtual protected function void perform_coverage16();
  extern virtual function void report();

endclass : ahb_master_monitor16

//UVM connect_phase
function void ahb_master_monitor16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if16)::get(this, "", "vif16", vif16))
   `uvm_error("NOVIF16",{"virtual interface must be set for: ",get_full_name(),".vif16"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor16::run_phase(uvm_phase phase);
    fork
      collect_transfer16();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB16-NOTE16 : REQUIRED16 : master16 Monitor16 : Monitors16
   -------------------------------------------------------------------------
   Modify16 the collect_transfers16() method to match your16 protocol16.
   Note16 that if you change/add signals16 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor16::collect_transfer16();
    // This16 monitor16 re-uses its data items for ALL16 transfers16
    transfer16 = ahb_transfer16::type_id::create("transfer16", this);
    forever begin
      @(posedge vif16.ahb_clock16 iff vif16.AHB_HTRANS16 === NONSEQ16);
      // Begin16 transaction recording16
      void'(begin_tr(transfer16, "AHB16 MASTER16 Monitor16"));
      transfer16.address = vif16.AHB_HADDR16;
      transfer16.direction16 = ahb_direction16'(vif16.AHB_HWRITE16);
      transfer16.hsize16 = ahb_transfer_size16'(0);  //Not used - hance16 assign dummy
      transfer16.burst = ahb_burst_kind16'(0);     //Not used - hance16 assign dummy
      @(posedge vif16.ahb_clock16 iff vif16.AHB_HREADY16 === 1);
      // End16 transaction recording16
        if(transfer16.direction16 == WRITE) 
          transfer16.data = vif16.AHB_HWDATA16;
        else
          transfer16.data = vif16.AHB_HRDATA16;
        ;
      @(posedge vif16.ahb_clock16 iff vif16.AHB_HREADY16 === 1);
    end_tr(transfer16);
      `uvm_info(get_type_name(), 
        $psprintf("master16 transfer16 collected16 :\n%s", 
        transfer16.sprint()), UVM_HIGH)
      if (checks_enable16)
         perform_checks16();
      if (coverage_enable16)
         perform_coverage16();
      // Send16 transfer16 to scoreboard16 via TLM write()
      item_collected_port16.write(transfer16);
      -> transaction_ended16;
      num_col16++;
    end
  endtask : collect_transfer16
  
  /***************************************************************************
   IVB16-NOTE16 : OPTIONAL16 : master16 Monitor16 Protocol16 Checks16 : Checks16
   -------------------------------------------------------------------------
   Add protocol16 checks16 within the perform_checks16() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks16
  function void ahb_master_monitor16::perform_checks16();
    // Add checks16 here16
  endfunction : perform_checks16
  
 /***************************************************************************
  IVB16-NOTE16 : OPTIONAL16 : master16 Monitor16 Coverage16 : Coverage16
  -------------------------------------------------------------------------
  Modify16 the master_transfer_cg16 coverage16 group16 to match your16 protocol16.
  Add new coverage16 groups16, and edit16 the perform_coverage16() method to sample 
  them16.
  ***************************************************************************/

  // Triggers16 coverage16 events
  function void ahb_master_monitor16::perform_coverage16();
    master_transfer_cg16.sample();
  endfunction : perform_coverage16

  // UVM report() phase
  function void ahb_master_monitor16::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport16: AHB16 master16 monitor16 collected16 %0d transfers16", num_col16),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV16

