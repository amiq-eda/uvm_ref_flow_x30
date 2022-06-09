// IVB11 checksum11: 223843813
/*-----------------------------------------------------------------
File11 name     : ahb_slave_monitor11.sv
Created11       : Wed11 May11 19 15:42:21 2010
Description11   : This11 file implements11 the slave11 monitor11.
              : The slave11 monitor11 monitors11 the activity11 of
              : its interface bus.
Notes11         :
-----------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV11
`define AHB_SLAVE_MONITOR_SV11

//------------------------------------------------------------------------------
//
// CLASS11: ahb_slave_monitor11
//
//------------------------------------------------------------------------------

class ahb_slave_monitor11 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive11
  // and view11 HDL signals11.
  virtual interface ahb_if11 vif11;

  // Count11 transfer11 responses11 collected11
  int num_col11;

  // The following11 two11 bits are used to control11 whether11 checks11 and coverage11 are
  // done in the monitor11
  bit checks_enable11 = 1;
  bit coverage_enable11 = 1;
  
  // This11 TLM port is used to connect the monitor11 to the scoreboard11
  uvm_analysis_port#(ahb_transfer11) item_collected_port11;

  // Current11 monitored11 transfer11 
  protected ahb_transfer11 transfer11;
 
  // Covergroup11 for transfer11
  covergroup slave_transfer_cg11;
    option.per_instance = 1;
    direction11: coverpoint transfer11.direction11;
  endgroup : slave_transfer_cg11

  // Provide11 UVM automation11 and utility11 methods11
  `uvm_component_utils_begin(ahb_slave_monitor11)
    `uvm_field_int(checks_enable11, UVM_ALL_ON)
    `uvm_field_int(coverage_enable11, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor11 - required11 syntax11 for UVM automation11 and utilities11
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create11 the covergroup
    slave_transfer_cg11 = new();
    slave_transfer_cg11.set_inst_name("slave_transfer_cg11");
    // Create11 the TLM port
    item_collected_port11 = new("item_collected_port11", this);
  endfunction : new

  // Additional11 class methods11
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response11();
  extern virtual protected function void perform_checks11();
  extern virtual protected function void perform_coverage11();
  extern virtual function void report();

endclass : ahb_slave_monitor11

//UVM connect_phase
function void ahb_slave_monitor11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if11)::get(this, "", "vif11", vif11))
   `uvm_error("NOVIF11",{"virtual interface must be set for: ",get_full_name(),".vif11"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor11::run_phase(uvm_phase phase);
    fork
      collect_response11();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB11-NOTE11 : REQUIRED11 : slave11 Monitor11 : Monitors11
   -------------------------------------------------------------------------
   Modify11 the collect_response11() method to match your11 protocol11.
   Note11 that if you change/add signals11 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect11 slave11 transfer11 (response)
  task ahb_slave_monitor11::collect_response11();
    // This11 monitor11 re-uses its data item for ALL11 transfers11
    transfer11 = ahb_transfer11::type_id::create("transfer11", this);
    forever begin
      @(posedge vif11.ahb_clock11 iff vif11.AHB_HREADY11 === 1);
      // Enable11 transfer11 recording11
      void'(begin_tr(transfer11, "AHB11 SLAVE11 Monitor11"));
      transfer11.data = vif11.AHB_HWDATA11;
      @(posedge vif11.ahb_clock11);
      end_tr(transfer11);
      `uvm_info(get_type_name(),
        $psprintf("slave11 transfer11 collected11 :\n%s",
        transfer11.sprint()), UVM_HIGH)
      if (checks_enable11)
        perform_checks11();
      if (coverage_enable11)
        perform_coverage11();
      // Send11 transfer11 to scoreboard11 via TLM write()
      item_collected_port11.write(transfer11);
      num_col11++;
    end
  endtask : collect_response11
  
  /***************************************************************************
  IVB11-NOTE11 : OPTIONAL11 : slave11 Monitor11 Protocol11 Checks11 : Checks11
  -------------------------------------------------------------------------
  Add protocol11 checks11 within the perform_checks11() method. 
  ***************************************************************************/
  // perform__checks11
  function void ahb_slave_monitor11::perform_checks11();
    // Add checks11 here11
  endfunction : perform_checks11
  
 /***************************************************************************
  IVB11-NOTE11 : OPTIONAL11 : slave11 Monitor11 Coverage11 : Coverage11
  -------------------------------------------------------------------------
  Modify11 the slave_transfer_cg11 coverage11 group11 to match your11 protocol11.
  Add new coverage11 groups11, and edit11 the perform_coverage11() method to sample them11
  ***************************************************************************/

  // Triggers11 coverage11 events
  function void ahb_slave_monitor11::perform_coverage11();
    slave_transfer_cg11.sample();
  endfunction : perform_coverage11

  // UVM report() phase
  function void ahb_slave_monitor11::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport11: AHB11 slave11 monitor11 collected11 %0d transfer11 responses11",
      num_col11), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV11

