// IVB12 checksum12: 223843813
/*-----------------------------------------------------------------
File12 name     : ahb_slave_monitor12.sv
Created12       : Wed12 May12 19 15:42:21 2010
Description12   : This12 file implements12 the slave12 monitor12.
              : The slave12 monitor12 monitors12 the activity12 of
              : its interface bus.
Notes12         :
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV12
`define AHB_SLAVE_MONITOR_SV12

//------------------------------------------------------------------------------
//
// CLASS12: ahb_slave_monitor12
//
//------------------------------------------------------------------------------

class ahb_slave_monitor12 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive12
  // and view12 HDL signals12.
  virtual interface ahb_if12 vif12;

  // Count12 transfer12 responses12 collected12
  int num_col12;

  // The following12 two12 bits are used to control12 whether12 checks12 and coverage12 are
  // done in the monitor12
  bit checks_enable12 = 1;
  bit coverage_enable12 = 1;
  
  // This12 TLM port is used to connect the monitor12 to the scoreboard12
  uvm_analysis_port#(ahb_transfer12) item_collected_port12;

  // Current12 monitored12 transfer12 
  protected ahb_transfer12 transfer12;
 
  // Covergroup12 for transfer12
  covergroup slave_transfer_cg12;
    option.per_instance = 1;
    direction12: coverpoint transfer12.direction12;
  endgroup : slave_transfer_cg12

  // Provide12 UVM automation12 and utility12 methods12
  `uvm_component_utils_begin(ahb_slave_monitor12)
    `uvm_field_int(checks_enable12, UVM_ALL_ON)
    `uvm_field_int(coverage_enable12, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor12 - required12 syntax12 for UVM automation12 and utilities12
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create12 the covergroup
    slave_transfer_cg12 = new();
    slave_transfer_cg12.set_inst_name("slave_transfer_cg12");
    // Create12 the TLM port
    item_collected_port12 = new("item_collected_port12", this);
  endfunction : new

  // Additional12 class methods12
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response12();
  extern virtual protected function void perform_checks12();
  extern virtual protected function void perform_coverage12();
  extern virtual function void report();

endclass : ahb_slave_monitor12

//UVM connect_phase
function void ahb_slave_monitor12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if12)::get(this, "", "vif12", vif12))
   `uvm_error("NOVIF12",{"virtual interface must be set for: ",get_full_name(),".vif12"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor12::run_phase(uvm_phase phase);
    fork
      collect_response12();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB12-NOTE12 : REQUIRED12 : slave12 Monitor12 : Monitors12
   -------------------------------------------------------------------------
   Modify12 the collect_response12() method to match your12 protocol12.
   Note12 that if you change/add signals12 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect12 slave12 transfer12 (response)
  task ahb_slave_monitor12::collect_response12();
    // This12 monitor12 re-uses its data item for ALL12 transfers12
    transfer12 = ahb_transfer12::type_id::create("transfer12", this);
    forever begin
      @(posedge vif12.ahb_clock12 iff vif12.AHB_HREADY12 === 1);
      // Enable12 transfer12 recording12
      void'(begin_tr(transfer12, "AHB12 SLAVE12 Monitor12"));
      transfer12.data = vif12.AHB_HWDATA12;
      @(posedge vif12.ahb_clock12);
      end_tr(transfer12);
      `uvm_info(get_type_name(),
        $psprintf("slave12 transfer12 collected12 :\n%s",
        transfer12.sprint()), UVM_HIGH)
      if (checks_enable12)
        perform_checks12();
      if (coverage_enable12)
        perform_coverage12();
      // Send12 transfer12 to scoreboard12 via TLM write()
      item_collected_port12.write(transfer12);
      num_col12++;
    end
  endtask : collect_response12
  
  /***************************************************************************
  IVB12-NOTE12 : OPTIONAL12 : slave12 Monitor12 Protocol12 Checks12 : Checks12
  -------------------------------------------------------------------------
  Add protocol12 checks12 within the perform_checks12() method. 
  ***************************************************************************/
  // perform__checks12
  function void ahb_slave_monitor12::perform_checks12();
    // Add checks12 here12
  endfunction : perform_checks12
  
 /***************************************************************************
  IVB12-NOTE12 : OPTIONAL12 : slave12 Monitor12 Coverage12 : Coverage12
  -------------------------------------------------------------------------
  Modify12 the slave_transfer_cg12 coverage12 group12 to match your12 protocol12.
  Add new coverage12 groups12, and edit12 the perform_coverage12() method to sample them12
  ***************************************************************************/

  // Triggers12 coverage12 events
  function void ahb_slave_monitor12::perform_coverage12();
    slave_transfer_cg12.sample();
  endfunction : perform_coverage12

  // UVM report() phase
  function void ahb_slave_monitor12::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport12: AHB12 slave12 monitor12 collected12 %0d transfer12 responses12",
      num_col12), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV12

