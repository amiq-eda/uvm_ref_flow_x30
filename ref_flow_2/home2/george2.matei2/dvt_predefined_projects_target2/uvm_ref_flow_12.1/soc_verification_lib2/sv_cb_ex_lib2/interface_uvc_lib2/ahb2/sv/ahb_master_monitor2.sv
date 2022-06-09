// IVB2 checksum2: 3251807609
/*-----------------------------------------------------------------
File2 name     : ahb_master_monitor2.sv
Created2       : Wed2 May2 19 15:42:21 2010
Description2   : This2 file implements2 the master2 monitor2.
              : The master2 monitor2 monitors2 the activity2 of
              : its interface bus.
Notes2         :
-----------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV2
`define AHB_MASTER_MONITOR_SV2

//------------------------------------------------------------------------------
//
// CLASS2: ahb_master_monitor2
//
//------------------------------------------------------------------------------

class ahb_master_monitor2 extends uvm_monitor;

  // Virtual Interface2 for monitoring2 DUT signals2
  virtual interface ahb_if2 vif2;

  // Count2 transfers2 collected2
  int num_col2;
  event transaction_ended2;
 
  // The following2 two2 bits are used to control2 whether2 checks2 and coverage2 are
  // done in the monitor2
  bit checks_enable2 = 1;
  bit coverage_enable2 = 1;

  // This2 TLM port is used to connect the monitor2 to the scoreboard2
  uvm_analysis_port #(ahb_transfer2) item_collected_port2;

  // Current2 monitored2 transfer2
  protected ahb_transfer2 transfer2;

  // Covergroup2 for transfer2
  covergroup master_transfer_cg2;
    option.per_instance = 1;
    direction2 : coverpoint transfer2.direction2;
  endgroup : master_transfer_cg2
 
  // Provide2 UVM automation2 and utility2 methods2
  `uvm_component_utils_begin(ahb_master_monitor2)
    `uvm_field_int(checks_enable2, UVM_ALL_ON)
    `uvm_field_int(coverage_enable2, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor2 - required2 syntax2 for UVM automation2 and utilities2
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create2 the covergroup
    master_transfer_cg2 = new();
    master_transfer_cg2.set_inst_name("master_transfer_cg2");
    // Create2 the TLM port
    item_collected_port2 = new("item_collected_port2", this);
  endfunction : new

  // Additional2 class methods2
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer2();
  extern virtual protected function void perform_checks2();
  extern virtual protected function void perform_coverage2();
  extern virtual function void report();

endclass : ahb_master_monitor2

//UVM connect_phase
function void ahb_master_monitor2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if2)::get(this, "", "vif2", vif2))
   `uvm_error("NOVIF2",{"virtual interface must be set for: ",get_full_name(),".vif2"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor2::run_phase(uvm_phase phase);
    fork
      collect_transfer2();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB2-NOTE2 : REQUIRED2 : master2 Monitor2 : Monitors2
   -------------------------------------------------------------------------
   Modify2 the collect_transfers2() method to match your2 protocol2.
   Note2 that if you change/add signals2 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor2::collect_transfer2();
    // This2 monitor2 re-uses its data items for ALL2 transfers2
    transfer2 = ahb_transfer2::type_id::create("transfer2", this);
    forever begin
      @(posedge vif2.ahb_clock2 iff vif2.AHB_HTRANS2 === NONSEQ2);
      // Begin2 transaction recording2
      void'(begin_tr(transfer2, "AHB2 MASTER2 Monitor2"));
      transfer2.address = vif2.AHB_HADDR2;
      transfer2.direction2 = ahb_direction2'(vif2.AHB_HWRITE2);
      transfer2.hsize2 = ahb_transfer_size2'(0);  //Not used - hance2 assign dummy
      transfer2.burst = ahb_burst_kind2'(0);     //Not used - hance2 assign dummy
      @(posedge vif2.ahb_clock2 iff vif2.AHB_HREADY2 === 1);
      // End2 transaction recording2
        if(transfer2.direction2 == WRITE) 
          transfer2.data = vif2.AHB_HWDATA2;
        else
          transfer2.data = vif2.AHB_HRDATA2;
        ;
      @(posedge vif2.ahb_clock2 iff vif2.AHB_HREADY2 === 1);
    end_tr(transfer2);
      `uvm_info(get_type_name(), 
        $psprintf("master2 transfer2 collected2 :\n%s", 
        transfer2.sprint()), UVM_HIGH)
      if (checks_enable2)
         perform_checks2();
      if (coverage_enable2)
         perform_coverage2();
      // Send2 transfer2 to scoreboard2 via TLM write()
      item_collected_port2.write(transfer2);
      -> transaction_ended2;
      num_col2++;
    end
  endtask : collect_transfer2
  
  /***************************************************************************
   IVB2-NOTE2 : OPTIONAL2 : master2 Monitor2 Protocol2 Checks2 : Checks2
   -------------------------------------------------------------------------
   Add protocol2 checks2 within the perform_checks2() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks2
  function void ahb_master_monitor2::perform_checks2();
    // Add checks2 here2
  endfunction : perform_checks2
  
 /***************************************************************************
  IVB2-NOTE2 : OPTIONAL2 : master2 Monitor2 Coverage2 : Coverage2
  -------------------------------------------------------------------------
  Modify2 the master_transfer_cg2 coverage2 group2 to match your2 protocol2.
  Add new coverage2 groups2, and edit2 the perform_coverage2() method to sample 
  them2.
  ***************************************************************************/

  // Triggers2 coverage2 events
  function void ahb_master_monitor2::perform_coverage2();
    master_transfer_cg2.sample();
  endfunction : perform_coverage2

  // UVM report() phase
  function void ahb_master_monitor2::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport2: AHB2 master2 monitor2 collected2 %0d transfers2", num_col2),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV2

