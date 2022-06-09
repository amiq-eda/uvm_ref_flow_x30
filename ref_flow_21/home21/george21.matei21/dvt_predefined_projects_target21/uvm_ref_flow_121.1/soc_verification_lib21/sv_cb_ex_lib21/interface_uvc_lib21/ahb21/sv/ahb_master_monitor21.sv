// IVB21 checksum21: 3251807609
/*-----------------------------------------------------------------
File21 name     : ahb_master_monitor21.sv
Created21       : Wed21 May21 19 15:42:21 2010
Description21   : This21 file implements21 the master21 monitor21.
              : The master21 monitor21 monitors21 the activity21 of
              : its interface bus.
Notes21         :
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef AHB_MASTER_MONITOR_SV21
`define AHB_MASTER_MONITOR_SV21

//------------------------------------------------------------------------------
//
// CLASS21: ahb_master_monitor21
//
//------------------------------------------------------------------------------

class ahb_master_monitor21 extends uvm_monitor;

  // Virtual Interface21 for monitoring21 DUT signals21
  virtual interface ahb_if21 vif21;

  // Count21 transfers21 collected21
  int num_col21;
  event transaction_ended21;
 
  // The following21 two21 bits are used to control21 whether21 checks21 and coverage21 are
  // done in the monitor21
  bit checks_enable21 = 1;
  bit coverage_enable21 = 1;

  // This21 TLM port is used to connect the monitor21 to the scoreboard21
  uvm_analysis_port #(ahb_transfer21) item_collected_port21;

  // Current21 monitored21 transfer21
  protected ahb_transfer21 transfer21;

  // Covergroup21 for transfer21
  covergroup master_transfer_cg21;
    option.per_instance = 1;
    direction21 : coverpoint transfer21.direction21;
  endgroup : master_transfer_cg21
 
  // Provide21 UVM automation21 and utility21 methods21
  `uvm_component_utils_begin(ahb_master_monitor21)
    `uvm_field_int(checks_enable21, UVM_ALL_ON)
    `uvm_field_int(coverage_enable21, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor21 - required21 syntax21 for UVM automation21 and utilities21
  function new (string name, uvm_component parent);
    super.new(name, parent);
    // Create21 the covergroup
    master_transfer_cg21 = new();
    master_transfer_cg21.set_inst_name("master_transfer_cg21");
    // Create21 the TLM port
    item_collected_port21 = new("item_collected_port21", this);
  endfunction : new

  // Additional21 class methods21
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_transfer21();
  extern virtual protected function void perform_checks21();
  extern virtual protected function void perform_coverage21();
  extern virtual function void report();

endclass : ahb_master_monitor21

//UVM connect_phase
function void ahb_master_monitor21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if21)::get(this, "", "vif21", vif21))
   `uvm_error("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_master_monitor21::run_phase(uvm_phase phase);
    fork
      collect_transfer21();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB21-NOTE21 : REQUIRED21 : master21 Monitor21 : Monitors21
   -------------------------------------------------------------------------
   Modify21 the collect_transfers21() method to match your21 protocol21.
   Note21 that if you change/add signals21 to the physical interface, you must
   also change this method. 
   ***************************************************************************/

  task ahb_master_monitor21::collect_transfer21();
    // This21 monitor21 re-uses its data items for ALL21 transfers21
    transfer21 = ahb_transfer21::type_id::create("transfer21", this);
    forever begin
      @(posedge vif21.ahb_clock21 iff vif21.AHB_HTRANS21 === NONSEQ21);
      // Begin21 transaction recording21
      void'(begin_tr(transfer21, "AHB21 MASTER21 Monitor21"));
      transfer21.address = vif21.AHB_HADDR21;
      transfer21.direction21 = ahb_direction21'(vif21.AHB_HWRITE21);
      transfer21.hsize21 = ahb_transfer_size21'(0);  //Not used - hance21 assign dummy
      transfer21.burst = ahb_burst_kind21'(0);     //Not used - hance21 assign dummy
      @(posedge vif21.ahb_clock21 iff vif21.AHB_HREADY21 === 1);
      // End21 transaction recording21
        if(transfer21.direction21 == WRITE) 
          transfer21.data = vif21.AHB_HWDATA21;
        else
          transfer21.data = vif21.AHB_HRDATA21;
        ;
      @(posedge vif21.ahb_clock21 iff vif21.AHB_HREADY21 === 1);
    end_tr(transfer21);
      `uvm_info(get_type_name(), 
        $psprintf("master21 transfer21 collected21 :\n%s", 
        transfer21.sprint()), UVM_HIGH)
      if (checks_enable21)
         perform_checks21();
      if (coverage_enable21)
         perform_coverage21();
      // Send21 transfer21 to scoreboard21 via TLM write()
      item_collected_port21.write(transfer21);
      -> transaction_ended21;
      num_col21++;
    end
  endtask : collect_transfer21
  
  /***************************************************************************
   IVB21-NOTE21 : OPTIONAL21 : master21 Monitor21 Protocol21 Checks21 : Checks21
   -------------------------------------------------------------------------
   Add protocol21 checks21 within the perform_checks21() method. 
   ***************************************************************************/

  // perform_ahb_transfer_checks21
  function void ahb_master_monitor21::perform_checks21();
    // Add checks21 here21
  endfunction : perform_checks21
  
 /***************************************************************************
  IVB21-NOTE21 : OPTIONAL21 : master21 Monitor21 Coverage21 : Coverage21
  -------------------------------------------------------------------------
  Modify21 the master_transfer_cg21 coverage21 group21 to match your21 protocol21.
  Add new coverage21 groups21, and edit21 the perform_coverage21() method to sample 
  them21.
  ***************************************************************************/

  // Triggers21 coverage21 events
  function void ahb_master_monitor21::perform_coverage21();
    master_transfer_cg21.sample();
  endfunction : perform_coverage21

  // UVM report() phase
  function void ahb_master_monitor21::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport21: AHB21 master21 monitor21 collected21 %0d transfers21", num_col21),
      UVM_LOW)
  endfunction : report

`endif // AHB_MASTER_MONITOR_SV21

