/*******************************************************************************
  FILE : apb_config11.sv
  This11 file contains11 multiple configuration classes11:
    apb_slave_config11 - for configuring11 an APB11 slave11 device11
    apb_master_config11 - for configuring11 an APB11 master11 device11
    apb_config11 - has 1 master11 config and N slave11 config's
    default_apb_config11 - configures11 for 1 master11 and 2 slaves11
*******************************************************************************/
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


`ifndef APB_CONFIG_SV11
`define APB_CONFIG_SV11

// APB11 Slave11 Configuration11 Information11
class apb_slave_config11 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address11;
  rand int end_address11;
  rand int psel_index11;

  constraint addr_cst11 { start_address11 <= end_address11; }
  constraint psel_cst11 { psel_index11 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config11)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address11, UVM_DEFAULT)
    `uvm_field_int(end_address11, UVM_DEFAULT)
    `uvm_field_int(psel_index11, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor11 - UVM required11 syntax11
  function new (string name = "apb_slave_config11");
    super.new(name);
  endfunction

  // Checks11 to see11 if an address is in the configured11 range
  function bit check_address_range11(int unsigned addr);
    return (!((start_address11 > addr) || (end_address11 < addr)));
  endfunction

endclass : apb_slave_config11

// APB11 Master11 Configuration11 Information11
class apb_master_config11 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed11-apb_master_config11");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config11)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config11

// APB11 Configuration11 Information11 
class apb_config11 extends uvm_object;

  // APB11 has one master11 and N slaves11
  apb_master_config11 master_config11;
  apb_slave_config11 slave_configs11[$];
  int num_slaves11;

  `uvm_object_utils_begin(apb_config11)
    `uvm_field_queue_object(slave_configs11, UVM_DEFAULT)
    `uvm_field_object(master_config11, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed11-apb_config11");
    super.new(name);
  endfunction

  // Additional11 class methods11
  extern function void add_slave11(string name, int start_addr11, int end_addr11,
            int psel_indx11, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master11(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr11(int addr);
  extern function string get_slave_name_by_addr11(int addr);
endclass  : apb_config11

// apb_config11 - Creates11 and configures11 a slave11 agent11 config and adds11 to a queue
function void apb_config11::add_slave11(string name, int start_addr11, int end_addr11,
            int psel_indx11, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config11 tmp_slave_cfg11;
  num_slaves11++;
  tmp_slave_cfg11 = apb_slave_config11::type_id::create("slave_config11");
  tmp_slave_cfg11.name = name;
  tmp_slave_cfg11.start_address11 = start_addr11;
  tmp_slave_cfg11.end_address11 = end_addr11;
  tmp_slave_cfg11.psel_index11 = psel_indx11;
  tmp_slave_cfg11.is_active = is_active;
  
  slave_configs11.push_back(tmp_slave_cfg11);
endfunction : add_slave11

// apb_config11 - Creates11 and configures11 a master11 agent11 configuration
function void apb_config11::add_master11(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config11 = apb_master_config11::type_id::create("master_config11");
  master_config11.name = name;
  master_config11.is_active = is_active;
endfunction : add_master11

// apb_config11 - Returns11 the slave11 psel11 index
function int apb_config11::get_slave_psel_by_addr11(int addr);
  for (int i = 0; i < slave_configs11.size(); i++)
    if(slave_configs11[i].check_address_range11(addr)) begin
      return slave_configs11[i].psel_index11;
    end
endfunction : get_slave_psel_by_addr11

// apb_config11 - Return11 the name of the slave11
function string apb_config11::get_slave_name_by_addr11(int addr);
  for (int i = 0; i < slave_configs11.size(); i++)
    if(slave_configs11[i].check_address_range11(addr)) begin
      return slave_configs11[i].name;
    end
endfunction : get_slave_name_by_addr11

//================================================================
// Default APB11 configuration - One11 Master11, Two11 slaves11
//================================================================
class default_apb_config11 extends apb_config11;

  `uvm_object_utils(default_apb_config11)

  function new(string name = "default_apb_config11-S0S111-master11");
    super.new(name);
    add_slave11("slave011", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave11("slave111", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master11("master11", UVM_ACTIVE);
  endfunction

endclass : default_apb_config11

`endif // APB_CONFIG_SV11
