// IVB7 checksum7: 2064975656
/*-----------------------------------------------------------------
File7 name     : ahb_env7.sv
Created7       : Wed7 May7 19 15:42:20 2010
Description7   : This7 file implements7 the OVC7 env7.
Notes7         :
-----------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef AHB_ENV_SV7
`define AHB_ENV_SV7

//------------------------------------------------------------------------------
//
// CLASS7: ahb_env7
//
//------------------------------------------------------------------------------

class ahb_env7 extends uvm_env;

  // Virtual Interface7 variable
  protected virtual interface ahb_if7 vif7;
 
  // The following7 two7 bits are used to control7 whether7 checks7 and coverage7 are
  // done both in the bus monitor7 class and the interface.
  bit checks_enable7 = 1; 
  bit coverage_enable7 = 1;

  // Components of the environment7
  ahb_master_agent7 master_agent7;
  ahb_slave_agent7 slave_agent7;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(ahb_env7)
    `uvm_field_int(checks_enable7, UVM_ALL_ON)
    `uvm_field_int(coverage_enable7, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor7 - required7 syntax7 for UVM automation7 and utilities7
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables7();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env7

  // UVM build() phase
  function void ahb_env7::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent7 = ahb_master_agent7::type_id::create("master_agent7", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if7)::get(this, "", "vif7", vif7))
   `uvm_fatal("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

  // Function7 to assign the checks7 and coverage7 bits
  task ahb_env7::update_vif_enables7();
    // Make7 assignments7 at time zero based upon7 config
    vif7.has_checks7 <= checks_enable7;
    vif7.has_coverage <= coverage_enable7;
    forever begin
      // Make7 assignments7 whenever7 enables7 change after time zero
      @(checks_enable7 || coverage_enable7);
      vif7.has_checks7 <= checks_enable7;
      vif7.has_coverage <= coverage_enable7;
    end
  endtask : update_vif_enables7

  // UVM run() phase
  task ahb_env7::run_phase(uvm_phase phase);
    fork
      update_vif_enables7();
    join_none
  endtask

`endif // AHB_ENV_SV7

