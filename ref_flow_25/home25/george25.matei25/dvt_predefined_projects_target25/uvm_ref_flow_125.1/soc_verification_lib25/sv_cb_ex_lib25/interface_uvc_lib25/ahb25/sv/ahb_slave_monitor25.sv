// IVB25 checksum25: 223843813
/*-----------------------------------------------------------------
File25 name     : ahb_slave_monitor25.sv
Created25       : Wed25 May25 19 15:42:21 2010
Description25   : This25 file implements25 the slave25 monitor25.
              : The slave25 monitor25 monitors25 the activity25 of
              : its interface bus.
Notes25         :
-----------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef AHB_SLAVE_MONITOR_SV25
`define AHB_SLAVE_MONITOR_SV25

//------------------------------------------------------------------------------
//
// CLASS25: ahb_slave_monitor25
//
//------------------------------------------------------------------------------

class ahb_slave_monitor25 extends uvm_monitor;
  
  // The virtual interface needed for this component to drive25
  // and view25 HDL signals25.
  virtual interface ahb_if25 vif25;

  // Count25 transfer25 responses25 collected25
  int num_col25;

  // The following25 two25 bits are used to control25 whether25 checks25 and coverage25 are
  // done in the monitor25
  bit checks_enable25 = 1;
  bit coverage_enable25 = 1;
  
  // This25 TLM port is used to connect the monitor25 to the scoreboard25
  uvm_analysis_port#(ahb_transfer25) item_collected_port25;

  // Current25 monitored25 transfer25 
  protected ahb_transfer25 transfer25;
 
  // Covergroup25 for transfer25
  covergroup slave_transfer_cg25;
    option.per_instance = 1;
    direction25: coverpoint transfer25.direction25;
  endgroup : slave_transfer_cg25

  // Provide25 UVM automation25 and utility25 methods25
  `uvm_component_utils_begin(ahb_slave_monitor25)
    `uvm_field_int(checks_enable25, UVM_ALL_ON)
    `uvm_field_int(coverage_enable25, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor25 - required25 syntax25 for UVM automation25 and utilities25
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create25 the covergroup
    slave_transfer_cg25 = new();
    slave_transfer_cg25.set_inst_name("slave_transfer_cg25");
    // Create25 the TLM port
    item_collected_port25 = new("item_collected_port25", this);
  endfunction : new

  // Additional25 class methods25
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual protected task collect_response25();
  extern virtual protected function void perform_checks25();
  extern virtual protected function void perform_coverage25();
  extern virtual function void report();

endclass : ahb_slave_monitor25

//UVM connect_phase
function void ahb_slave_monitor25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if25)::get(this, "", "vif25", vif25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

  // UVM run() phase
  task ahb_slave_monitor25::run_phase(uvm_phase phase);
    fork
      collect_response25();
    join_none
  endtask : run_phase

  /***************************************************************************
   IVB25-NOTE25 : REQUIRED25 : slave25 Monitor25 : Monitors25
   -------------------------------------------------------------------------
   Modify25 the collect_response25() method to match your25 protocol25.
   Note25 that if you change/add signals25 to the physical interface, you must
   also change this method. 
   ***************************************************************************/
  
  // Collect25 slave25 transfer25 (response)
  task ahb_slave_monitor25::collect_response25();
    // This25 monitor25 re-uses its data item for ALL25 transfers25
    transfer25 = ahb_transfer25::type_id::create("transfer25", this);
    forever begin
      @(posedge vif25.ahb_clock25 iff vif25.AHB_HREADY25 === 1);
      // Enable25 transfer25 recording25
      void'(begin_tr(transfer25, "AHB25 SLAVE25 Monitor25"));
      transfer25.data = vif25.AHB_HWDATA25;
      @(posedge vif25.ahb_clock25);
      end_tr(transfer25);
      `uvm_info(get_type_name(),
        $psprintf("slave25 transfer25 collected25 :\n%s",
        transfer25.sprint()), UVM_HIGH)
      if (checks_enable25)
        perform_checks25();
      if (coverage_enable25)
        perform_coverage25();
      // Send25 transfer25 to scoreboard25 via TLM write()
      item_collected_port25.write(transfer25);
      num_col25++;
    end
  endtask : collect_response25
  
  /***************************************************************************
  IVB25-NOTE25 : OPTIONAL25 : slave25 Monitor25 Protocol25 Checks25 : Checks25
  -------------------------------------------------------------------------
  Add protocol25 checks25 within the perform_checks25() method. 
  ***************************************************************************/
  // perform__checks25
  function void ahb_slave_monitor25::perform_checks25();
    // Add checks25 here25
  endfunction : perform_checks25
  
 /***************************************************************************
  IVB25-NOTE25 : OPTIONAL25 : slave25 Monitor25 Coverage25 : Coverage25
  -------------------------------------------------------------------------
  Modify25 the slave_transfer_cg25 coverage25 group25 to match your25 protocol25.
  Add new coverage25 groups25, and edit25 the perform_coverage25() method to sample them25
  ***************************************************************************/

  // Triggers25 coverage25 events
  function void ahb_slave_monitor25::perform_coverage25();
    slave_transfer_cg25.sample();
  endfunction : perform_coverage25

  // UVM report() phase
  function void ahb_slave_monitor25::report();
    `uvm_info(get_type_name(), 
      $psprintf("\nReport25: AHB25 slave25 monitor25 collected25 %0d transfer25 responses25",
      num_col25), UVM_LOW)
  endfunction : report

`endif // AHB_SLAVE_MONITOR_SV25

