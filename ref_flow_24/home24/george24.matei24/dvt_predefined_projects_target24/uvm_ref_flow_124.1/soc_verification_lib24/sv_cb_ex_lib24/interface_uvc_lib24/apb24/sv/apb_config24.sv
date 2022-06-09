/*******************************************************************************
  FILE : apb_config24.sv
  This24 file contains24 multiple configuration classes24:
    apb_slave_config24 - for configuring24 an APB24 slave24 device24
    apb_master_config24 - for configuring24 an APB24 master24 device24
    apb_config24 - has 1 master24 config and N slave24 config's
    default_apb_config24 - configures24 for 1 master24 and 2 slaves24
*******************************************************************************/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV24
`define APB_CONFIG_SV24

// APB24 Slave24 Configuration24 Information24
class apb_slave_config24 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address24;
  rand int end_address24;
  rand int psel_index24;

  constraint addr_cst24 { start_address24 <= end_address24; }
  constraint psel_cst24 { psel_index24 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config24)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address24, UVM_DEFAULT)
    `uvm_field_int(end_address24, UVM_DEFAULT)
    `uvm_field_int(psel_index24, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor24 - UVM required24 syntax24
  function new (string name = "apb_slave_config24");
    super.new(name);
  endfunction

  // Checks24 to see24 if an address is in the configured24 range
  function bit check_address_range24(int unsigned addr);
    return (!((start_address24 > addr) || (end_address24 < addr)));
  endfunction

endclass : apb_slave_config24

// APB24 Master24 Configuration24 Information24
class apb_master_config24 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed24-apb_master_config24");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config24)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config24

// APB24 Configuration24 Information24 
class apb_config24 extends uvm_object;

  // APB24 has one master24 and N slaves24
  apb_master_config24 master_config24;
  apb_slave_config24 slave_configs24[$];
  int num_slaves24;

  `uvm_object_utils_begin(apb_config24)
    `uvm_field_queue_object(slave_configs24, UVM_DEFAULT)
    `uvm_field_object(master_config24, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed24-apb_config24");
    super.new(name);
  endfunction

  // Additional24 class methods24
  extern function void add_slave24(string name, int start_addr24, int end_addr24,
            int psel_indx24, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master24(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr24(int addr);
  extern function string get_slave_name_by_addr24(int addr);
endclass  : apb_config24

// apb_config24 - Creates24 and configures24 a slave24 agent24 config and adds24 to a queue
function void apb_config24::add_slave24(string name, int start_addr24, int end_addr24,
            int psel_indx24, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config24 tmp_slave_cfg24;
  num_slaves24++;
  tmp_slave_cfg24 = apb_slave_config24::type_id::create("slave_config24");
  tmp_slave_cfg24.name = name;
  tmp_slave_cfg24.start_address24 = start_addr24;
  tmp_slave_cfg24.end_address24 = end_addr24;
  tmp_slave_cfg24.psel_index24 = psel_indx24;
  tmp_slave_cfg24.is_active = is_active;
  
  slave_configs24.push_back(tmp_slave_cfg24);
endfunction : add_slave24

// apb_config24 - Creates24 and configures24 a master24 agent24 configuration
function void apb_config24::add_master24(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config24 = apb_master_config24::type_id::create("master_config24");
  master_config24.name = name;
  master_config24.is_active = is_active;
endfunction : add_master24

// apb_config24 - Returns24 the slave24 psel24 index
function int apb_config24::get_slave_psel_by_addr24(int addr);
  for (int i = 0; i < slave_configs24.size(); i++)
    if(slave_configs24[i].check_address_range24(addr)) begin
      return slave_configs24[i].psel_index24;
    end
endfunction : get_slave_psel_by_addr24

// apb_config24 - Return24 the name of the slave24
function string apb_config24::get_slave_name_by_addr24(int addr);
  for (int i = 0; i < slave_configs24.size(); i++)
    if(slave_configs24[i].check_address_range24(addr)) begin
      return slave_configs24[i].name;
    end
endfunction : get_slave_name_by_addr24

//================================================================
// Default APB24 configuration - One24 Master24, Two24 slaves24
//================================================================
class default_apb_config24 extends apb_config24;

  `uvm_object_utils(default_apb_config24)

  function new(string name = "default_apb_config24-S0S124-master24");
    super.new(name);
    add_slave24("slave024", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave24("slave124", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master24("master24", UVM_ACTIVE);
  endfunction

endclass : default_apb_config24

`endif // APB_CONFIG_SV24
