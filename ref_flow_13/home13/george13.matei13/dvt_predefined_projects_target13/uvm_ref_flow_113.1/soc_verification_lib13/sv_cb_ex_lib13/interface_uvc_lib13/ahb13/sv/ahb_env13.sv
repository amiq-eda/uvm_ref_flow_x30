// IVB13 checksum13: 2064975656
/*-----------------------------------------------------------------
File13 name     : ahb_env13.sv
Created13       : Wed13 May13 19 15:42:20 2010
Description13   : This13 file implements13 the OVC13 env13.
Notes13         :
-----------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV13
`define AHB_ENV_SV13

//------------------------------------------------------------------------------
//
// CLASS13: ahb_env13
//
//------------------------------------------------------------------------------

class ahb_env13 extends uvm_env;

  // Virtual Interface13 variable
  protected virtual interface ahb_if13 vif13;
 
  // The following13 two13 bits are used to control13 whether13 checks13 and coverage13 are
  // done both in the bus monitor13 class and the interface.
  bit checks_enable13 = 1; 
  bit coverage_enable13 = 1;

  // Components of the environment13
  ahb_master_agent13 master_agent13;
  ahb_slave_agent13 slave_agent13;

  // Provide13 implementations13 of virtual methods13 such13 as get_type_name and create
  `uvm_component_utils_begin(ahb_env13)
    `uvm_field_int(checks_enable13, UVM_ALL_ON)
    `uvm_field_int(coverage_enable13, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor13 - required13 syntax13 for UVM automation13 and utilities13
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables13();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env13

  // UVM build() phase
  function void ahb_env13::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent13 = ahb_master_agent13::type_id::create("master_agent13", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if13)::get(this, "", "vif13", vif13))
   `uvm_fatal("NOVIF13",{"virtual interface must be set for: ",get_full_name(),".vif13"})
endfunction : connect_phase

  // Function13 to assign the checks13 and coverage13 bits
  task ahb_env13::update_vif_enables13();
    // Make13 assignments13 at time zero based upon13 config
    vif13.has_checks13 <= checks_enable13;
    vif13.has_coverage <= coverage_enable13;
    forever begin
      // Make13 assignments13 whenever13 enables13 change after time zero
      @(checks_enable13 || coverage_enable13);
      vif13.has_checks13 <= checks_enable13;
      vif13.has_coverage <= coverage_enable13;
    end
  endtask : update_vif_enables13

  // UVM run() phase
  task ahb_env13::run_phase(uvm_phase phase);
    fork
      update_vif_enables13();
    join_none
  endtask

`endif // AHB_ENV_SV13

