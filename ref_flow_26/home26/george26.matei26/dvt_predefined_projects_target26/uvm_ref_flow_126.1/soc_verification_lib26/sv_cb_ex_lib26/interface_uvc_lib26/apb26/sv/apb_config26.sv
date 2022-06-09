/*******************************************************************************
  FILE : apb_config26.sv
  This26 file contains26 multiple configuration classes26:
    apb_slave_config26 - for configuring26 an APB26 slave26 device26
    apb_master_config26 - for configuring26 an APB26 master26 device26
    apb_config26 - has 1 master26 config and N slave26 config's
    default_apb_config26 - configures26 for 1 master26 and 2 slaves26
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV26
`define APB_CONFIG_SV26

// APB26 Slave26 Configuration26 Information26
class apb_slave_config26 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address26;
  rand int end_address26;
  rand int psel_index26;

  constraint addr_cst26 { start_address26 <= end_address26; }
  constraint psel_cst26 { psel_index26 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config26)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address26, UVM_DEFAULT)
    `uvm_field_int(end_address26, UVM_DEFAULT)
    `uvm_field_int(psel_index26, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor26 - UVM required26 syntax26
  function new (string name = "apb_slave_config26");
    super.new(name);
  endfunction

  // Checks26 to see26 if an address is in the configured26 range
  function bit check_address_range26(int unsigned addr);
    return (!((start_address26 > addr) || (end_address26 < addr)));
  endfunction

endclass : apb_slave_config26

// APB26 Master26 Configuration26 Information26
class apb_master_config26 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed26-apb_master_config26");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config26)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config26

// APB26 Configuration26 Information26 
class apb_config26 extends uvm_object;

  // APB26 has one master26 and N slaves26
  apb_master_config26 master_config26;
  apb_slave_config26 slave_configs26[$];
  int num_slaves26;

  `uvm_object_utils_begin(apb_config26)
    `uvm_field_queue_object(slave_configs26, UVM_DEFAULT)
    `uvm_field_object(master_config26, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed26-apb_config26");
    super.new(name);
  endfunction

  // Additional26 class methods26
  extern function void add_slave26(string name, int start_addr26, int end_addr26,
            int psel_indx26, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master26(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr26(int addr);
  extern function string get_slave_name_by_addr26(int addr);
endclass  : apb_config26

// apb_config26 - Creates26 and configures26 a slave26 agent26 config and adds26 to a queue
function void apb_config26::add_slave26(string name, int start_addr26, int end_addr26,
            int psel_indx26, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config26 tmp_slave_cfg26;
  num_slaves26++;
  tmp_slave_cfg26 = apb_slave_config26::type_id::create("slave_config26");
  tmp_slave_cfg26.name = name;
  tmp_slave_cfg26.start_address26 = start_addr26;
  tmp_slave_cfg26.end_address26 = end_addr26;
  tmp_slave_cfg26.psel_index26 = psel_indx26;
  tmp_slave_cfg26.is_active = is_active;
  
  slave_configs26.push_back(tmp_slave_cfg26);
endfunction : add_slave26

// apb_config26 - Creates26 and configures26 a master26 agent26 configuration
function void apb_config26::add_master26(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config26 = apb_master_config26::type_id::create("master_config26");
  master_config26.name = name;
  master_config26.is_active = is_active;
endfunction : add_master26

// apb_config26 - Returns26 the slave26 psel26 index
function int apb_config26::get_slave_psel_by_addr26(int addr);
  for (int i = 0; i < slave_configs26.size(); i++)
    if(slave_configs26[i].check_address_range26(addr)) begin
      return slave_configs26[i].psel_index26;
    end
endfunction : get_slave_psel_by_addr26

// apb_config26 - Return26 the name of the slave26
function string apb_config26::get_slave_name_by_addr26(int addr);
  for (int i = 0; i < slave_configs26.size(); i++)
    if(slave_configs26[i].check_address_range26(addr)) begin
      return slave_configs26[i].name;
    end
endfunction : get_slave_name_by_addr26

//================================================================
// Default APB26 configuration - One26 Master26, Two26 slaves26
//================================================================
class default_apb_config26 extends apb_config26;

  `uvm_object_utils(default_apb_config26)

  function new(string name = "default_apb_config26-S0S126-master26");
    super.new(name);
    add_slave26("slave026", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave26("slave126", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master26("master26", UVM_ACTIVE);
  endfunction

endclass : default_apb_config26

`endif // APB_CONFIG_SV26
