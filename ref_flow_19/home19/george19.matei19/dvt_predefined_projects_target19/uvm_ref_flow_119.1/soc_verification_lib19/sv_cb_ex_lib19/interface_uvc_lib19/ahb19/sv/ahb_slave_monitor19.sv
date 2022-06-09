// IVB19 checksum19: 223843813
/*-----------------------------------------------------------------
File19 name     : ahb_slave_monitor19.sv
Created19       : Wed19 May19 19 15:42:21 2010
Description19   : This19 file implements19 the slave19 monitor19.
              : The slave19 monitor19 monitors19 the activity19 of
              : its interface bus.
Notes19         :
-----------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV19
`define AHB_SLAVE_MONITOR_SV19

//------------------------------------------------------------------------------
//
// CLASS19: ahb_slave_monitor19
//
//------------------------------------------------------------------------------

class ahb_slave_monitor19 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive19
  // and view19 HDL signals19.
  virtual interface ahb_if19 vif19;

  // Count19 transfer19 responses19 collected19
  int num_col19;

  // The following19 two19 bits are used to control19 whether19 checks19 and coverage19 are
  // done in the monitor19
  bit checks_enable19 = 1;
  bit coverage_enable19 = 1;
  
  // This19 TLM port is used to connect the monitor19 to the scoreboard19
  uvm_analysis_port#(ahb_transfer19) item_collected_port19;

  // Current19 monitored19 transfer19 
  protected ahb_transfer19 transfer19;
 
  // Covergroup19 for transfer19
  covergroup slave_transfer_cg19;
    option.per_instance = 1;
    direction19: coverpoint transfer19.direction19;
  endgroup : slave_transfer_cg19

  // Provide19 UVM automation19 and utility19 methods19
  `uvm_component_utils_begin(ahb_slave_monitor19)
    `uvm_field_int(checks_enable19, UVM_ALL_ON)
    `uvm_field_int(coverage_enable19, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create19 the covergroup
    slave_transfer_cg19 = new();
    slave_transfer_cg19.set_inst_name("slave_transfer_cg19");
    // Create19 the TLM port
    item_collected_port19 = new("item_collected_port19", this);
  endfunction : new

  // Additional19 class methods19
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response19();
  extern virtual protected function void perform_checks19();
  extern virtual protected function void perform_coverage19();
  extern virtual function void report();

endclass : ahb_slave_monitor19

//UVM connect_phase
function void ahb_slave_monitor19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if19)::get(this, "", "vif19", vif19))
   `uvm_error("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor19::run_phase(uvm_phase phase);
    fork
      collect_response19();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB19-NOTE19 : REQUIRED19 : slave19 Monitor19 : Monitors19
   -------------------------------------------------------------------------
   Modify19 the collect_response19() method to match your19 protocol19.
   Note19 that if you change/add signals19 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect19 slave19 transfer19 (response)
  task ahb_slave_monitor19::collect_response19();
    // This19 monitor19 re-uses its data item for ALL19 transfers19
    transfer19 = ahb_transfer19::type_id::create("transfer19", this);
    forever begin
      @(posedge vif19.ahb_clock19 iff vif19.AHB_HREADY19 === 1);
      // Enable19 transfer19 recording19
      void'(begin_tr(transfer19, "AHB19 SLAVE19 Monitor19"));
      transfer19.data = vif19.AHB_HWDATA19;
      @(posedge vif19.ahb_clock19);
      end_tr(transfer19);
      `uvm_info(get_type_name(),
        $psprintf("slave19 transfer19 collected19 :\n%s",
        transfer19.sprint()), UVM_HIGH)
      if (checks_enable19)
        perform_checks19();
      if (coverage_enable19)
        perform_coverage19();
      // Send19 transfer19 to scoreboard19 via TLM write()
      item_collected_port19.write(transfer19);
      num_col19++;
    end
  endtask : collect_response19
  
  /***************************************************************************
  IVB19-NOTE19 : OPTIONAL19 : slave19 Monitor19 Protocol19 Checks19 : Checks19
  -------------------------------------------------------------------------
  Add protocol19 checks19 within the perform_checks19() method. 
  ***************************************************************************/
  // perform__checks19
  function void ahb_slave_monitor19::perform_checks19();
    // Add checks19 here19
  endfunction : perform_checks19
  
 /***************************************************************************
  IVB19-NOTE19 : OPTIONAL19 : slave19 Monitor19 Coverage19 : Coverage19
  -------------------------------------------------------------------------
  Modify19 the slave_transfer_cg19 coverage19 group19 to match your19 protocol19.
  Add new coverage19 groups19, and edit19 the perform_coverage19() method to sample them19
  ***************************************************************************/

  // Triggers19 coverage19 events
  function void ahb_slave_monitor19::perform_coverage19();
    slave_transfer_cg19.sample();
  endfunction : perform_coverage19

  // UVM report() phase
  function void ahb_slave_monitor19::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport19: AHB19 slave19 monitor19 collected19 %0d transfer19 responses19",
      num_col19), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV19

