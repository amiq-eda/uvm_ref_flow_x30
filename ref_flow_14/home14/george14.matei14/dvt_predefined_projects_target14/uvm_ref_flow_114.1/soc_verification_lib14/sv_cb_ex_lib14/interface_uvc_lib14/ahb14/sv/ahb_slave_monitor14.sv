// IVB14 checksum14: 223843813
/*-----------------------------------------------------------------
File14 name     : ahb_slave_monitor14.sv
Created14       : Wed14 May14 19 15:42:21 2010
Description14   : This14 file implements14 the slave14 monitor14.
              : The slave14 monitor14 monitors14 the activity14 of
              : its interface bus.
Notes14         :
-----------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV14
`define AHB_SLAVE_MONITOR_SV14

//------------------------------------------------------------------------------
//
// CLASS14: ahb_slave_monitor14
//
//------------------------------------------------------------------------------

class ahb_slave_monitor14 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive14
  // and view14 HDL signals14.
  virtual interface ahb_if14 vif14;

  // Count14 transfer14 responses14 collected14
  int num_col14;

  // The following14 two14 bits are used to control14 whether14 checks14 and coverage14 are
  // done in the monitor14
  bit checks_enable14 = 1;
  bit coverage_enable14 = 1;
  
  // This14 TLM port is used to connect the monitor14 to the scoreboard14
  uvm_analysis_port#(ahb_transfer14) item_collected_port14;

  // Current14 monitored14 transfer14 
  protected ahb_transfer14 transfer14;
 
  // Covergroup14 for transfer14
  covergroup slave_transfer_cg14;
    option.per_instance = 1;
    direction14: coverpoint transfer14.direction14;
  endgroup : slave_transfer_cg14

  // Provide14 UVM automation14 and utility14 methods14
  `uvm_component_utils_begin(ahb_slave_monitor14)
    `uvm_field_int(checks_enable14, UVM_ALL_ON)
    `uvm_field_int(coverage_enable14, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor14 - required14 syntax14 for UVM automation14 and utilities14
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create14 the covergroup
    slave_transfer_cg14 = new();
    slave_transfer_cg14.set_inst_name("slave_transfer_cg14");
    // Create14 the TLM port
    item_collected_port14 = new("item_collected_port14", this);
  endfunction : new

  // Additional14 class methods14
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response14();
  extern virtual protected function void perform_checks14();
  extern virtual protected function void perform_coverage14();
  extern virtual function void report();

endclass : ahb_slave_monitor14

//UVM connect_phase
function void ahb_slave_monitor14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if14)::get(this, "", "vif14", vif14))
   `uvm_error("NOVIF14",{"virtual interface must be set for: ",get_full_name(),".vif14"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor14::run_phase(uvm_phase phase);
    fork
      collect_response14();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB14-NOTE14 : REQUIRED14 : slave14 Monitor14 : Monitors14
   -------------------------------------------------------------------------
   Modify14 the collect_response14() method to match your14 protocol14.
   Note14 that if you change/add signals14 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect14 slave14 transfer14 (response)
  task ahb_slave_monitor14::collect_response14();
    // This14 monitor14 re-uses its data item for ALL14 transfers14
    transfer14 = ahb_transfer14::type_id::create("transfer14", this);
    forever begin
      @(posedge vif14.ahb_clock14 iff vif14.AHB_HREADY14 === 1);
      // Enable14 transfer14 recording14
      void'(begin_tr(transfer14, "AHB14 SLAVE14 Monitor14"));
      transfer14.data = vif14.AHB_HWDATA14;
      @(posedge vif14.ahb_clock14);
      end_tr(transfer14);
      `uvm_info(get_type_name(),
        $psprintf("slave14 transfer14 collected14 :\n%s",
        transfer14.sprint()), UVM_HIGH)
      if (checks_enable14)
        perform_checks14();
      if (coverage_enable14)
        perform_coverage14();
      // Send14 transfer14 to scoreboard14 via TLM write()
      item_collected_port14.write(transfer14);
      num_col14++;
    end
  endtask : collect_response14
  
  /***************************************************************************
  IVB14-NOTE14 : OPTIONAL14 : slave14 Monitor14 Protocol14 Checks14 : Checks14
  -------------------------------------------------------------------------
  Add protocol14 checks14 within the perform_checks14() method. 
  ***************************************************************************/
  // perform__checks14
  function void ahb_slave_monitor14::perform_checks14();
    // Add checks14 here14
  endfunction : perform_checks14
  
 /***************************************************************************
  IVB14-NOTE14 : OPTIONAL14 : slave14 Monitor14 Coverage14 : Coverage14
  -------------------------------------------------------------------------
  Modify14 the slave_transfer_cg14 coverage14 group14 to match your14 protocol14.
  Add new coverage14 groups14, and edit14 the perform_coverage14() method to sample them14
  ***************************************************************************/

  // Triggers14 coverage14 events
  function void ahb_slave_monitor14::perform_coverage14();
    slave_transfer_cg14.sample();
  endfunction : perform_coverage14

  // UVM report() phase
  function void ahb_slave_monitor14::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport14: AHB14 slave14 monitor14 collected14 %0d transfer14 responses14",
      num_col14), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV14

