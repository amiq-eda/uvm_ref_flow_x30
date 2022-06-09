// IVB19 checksum19: 2064975656
/*-----------------------------------------------------------------
File19 name     : ahb_env19.sv
Created19       : Wed19 May19 19 15:42:20 2010
Description19   : This19 file implements19 the OVC19 env19.
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


`ifndef AHB_ENV_SV19
`define AHB_ENV_SV19

//------------------------------------------------------------------------------
//
// CLASS19: ahb_env19
//
//------------------------------------------------------------------------------

class ahb_env19 extends uvm_env;

  // Virtual Interface19 variable
  protected virtual interface ahb_if19 vif19;
 
  // The following19 two19 bits are used to control19 whether19 checks19 and coverage19 are
  // done both in the bus monitor19 class and the interface.
  bit checks_enable19 = 1; 
  bit coverage_enable19 = 1;

  // Components of the environment19
  ahb_master_agent19 master_agent19;
  ahb_slave_agent19 slave_agent19;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(ahb_env19)
    `uvm_field_int(checks_enable19, UVM_ALL_ON)
    `uvm_field_int(coverage_enable19, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern protected task update_vif_enables19();
  extern virtual task run_phase(uvm_phase phase);

endclass : ahb_env19

  // UVM build() phase
  function void ahb_env19::build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent19 = ahb_master_agent19::type_id::create("master_agent19", this);
  endfunction : build_phase

//UVM connect_phase
function void ahb_env19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual ahb_if19)::get(this, "", "vif19", vif19))
   `uvm_fatal("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
endfunction : connect_phase

  // Function19 to assign the checks19 and coverage19 bits
  task ahb_env19::update_vif_enables19();
    // Make19 assignments19 at time zero based upon19 config
    vif19.has_checks19 <= checks_enable19;
    vif19.has_coverage <= coverage_enable19;
    forever begin
      // Make19 assignments19 whenever19 enables19 change after time zero
      @(checks_enable19 || coverage_enable19);
      vif19.has_checks19 <= checks_enable19;
      vif19.has_coverage <= coverage_enable19;
    end
  endtask : update_vif_enables19

  // UVM run() phase
  task ahb_env19::run_phase(uvm_phase phase);
    fork
      update_vif_enables19();
    join_none
  endtask

`endif // AHB_ENV_SV19

