/*******************************************************************************
  FILE : apb_config12.sv
  This12 file contains12 multiple configuration classes12:
    apb_slave_config12 - for configuring12 an APB12 slave12 device12
    apb_master_config12 - for configuring12 an APB12 master12 device12
    apb_config12 - has 1 master12 config and N slave12 config's
    default_apb_config12 - configures12 for 1 master12 and 2 slaves12
*******************************************************************************/
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


`ifndef APB_CONFIG_SV12
`define APB_CONFIG_SV12

// APB12 Slave12 Configuration12 Information12
class apb_slave_config12 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address12;
  rand int end_address12;
  rand int psel_index12;

  constraint addr_cst12 { start_address12 <= end_address12; }
  constraint psel_cst12 { psel_index12 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config12)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address12, UVM_DEFAULT)
    `uvm_field_int(end_address12, UVM_DEFAULT)
    `uvm_field_int(psel_index12, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor12 - UVM required12 syntax12
  function new (string name = "apb_slave_config12");
    super.new(name);
  endfunction

  // Checks12 to see12 if an address is in the configured12 range
  function bit check_address_range12(int unsigned addr);
    return (!((start_address12 > addr) || (end_address12 < addr)));
  endfunction

endclass : apb_slave_config12

// APB12 Master12 Configuration12 Information12
class apb_master_config12 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed12-apb_master_config12");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config12)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config12

// APB12 Configuration12 Information12 
class apb_config12 extends uvm_object;

  // APB12 has one master12 and N slaves12
  apb_master_config12 master_config12;
  apb_slave_config12 slave_configs12[$];
  int num_slaves12;

  `uvm_object_utils_begin(apb_config12)
    `uvm_field_queue_object(slave_configs12, UVM_DEFAULT)
    `uvm_field_object(master_config12, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed12-apb_config12");
    super.new(name);
  endfunction

  // Additional12 class methods12
  extern function void add_slave12(string name, int start_addr12, int end_addr12,
            int psel_indx12, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master12(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr12(int addr);
  extern function string get_slave_name_by_addr12(int addr);
endclass  : apb_config12

// apb_config12 - Creates12 and configures12 a slave12 agent12 config and adds12 to a queue
function void apb_config12::add_slave12(string name, int start_addr12, int end_addr12,
            int psel_indx12, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config12 tmp_slave_cfg12;
  num_slaves12++;
  tmp_slave_cfg12 = apb_slave_config12::type_id::create("slave_config12");
  tmp_slave_cfg12.name = name;
  tmp_slave_cfg12.start_address12 = start_addr12;
  tmp_slave_cfg12.end_address12 = end_addr12;
  tmp_slave_cfg12.psel_index12 = psel_indx12;
  tmp_slave_cfg12.is_active = is_active;
  
  slave_configs12.push_back(tmp_slave_cfg12);
endfunction : add_slave12

// apb_config12 - Creates12 and configures12 a master12 agent12 configuration
function void apb_config12::add_master12(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config12 = apb_master_config12::type_id::create("master_config12");
  master_config12.name = name;
  master_config12.is_active = is_active;
endfunction : add_master12

// apb_config12 - Returns12 the slave12 psel12 index
function int apb_config12::get_slave_psel_by_addr12(int addr);
  for (int i = 0; i < slave_configs12.size(); i++)
    if(slave_configs12[i].check_address_range12(addr)) begin
      return slave_configs12[i].psel_index12;
    end
endfunction : get_slave_psel_by_addr12

// apb_config12 - Return12 the name of the slave12
function string apb_config12::get_slave_name_by_addr12(int addr);
  for (int i = 0; i < slave_configs12.size(); i++)
    if(slave_configs12[i].check_address_range12(addr)) begin
      return slave_configs12[i].name;
    end
endfunction : get_slave_name_by_addr12

//================================================================
// Default APB12 configuration - One12 Master12, Two12 slaves12
//================================================================
class default_apb_config12 extends apb_config12;

  `uvm_object_utils(default_apb_config12)

  function new(string name = "default_apb_config12-S0S112-master12");
    super.new(name);
    add_slave12("slave012", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave12("slave112", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master12("master12", UVM_ACTIVE);
  endfunction

endclass : default_apb_config12

`endif // APB_CONFIG_SV12
