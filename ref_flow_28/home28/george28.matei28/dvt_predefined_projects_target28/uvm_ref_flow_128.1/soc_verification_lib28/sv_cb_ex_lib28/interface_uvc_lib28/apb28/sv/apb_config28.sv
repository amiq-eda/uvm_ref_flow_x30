/*******************************************************************************
  FILE : apb_config28.sv
  This28 file contains28 multiple configuration classes28:
    apb_slave_config28 - for configuring28 an APB28 slave28 device28
    apb_master_config28 - for configuring28 an APB28 master28 device28
    apb_config28 - has 1 master28 config and N slave28 config's
    default_apb_config28 - configures28 for 1 master28 and 2 slaves28
*******************************************************************************/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV28
`define APB_CONFIG_SV28

// APB28 Slave28 Configuration28 Information28
class apb_slave_config28 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address28;
  rand int end_address28;
  rand int psel_index28;

  constraint addr_cst28 { start_address28 <= end_address28; }
  constraint psel_cst28 { psel_index28 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config28)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address28, UVM_DEFAULT)
    `uvm_field_int(end_address28, UVM_DEFAULT)
    `uvm_field_int(psel_index28, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor28 - UVM required28 syntax28
  function new (string name = "apb_slave_config28");
    super.new(name);
  endfunction

  // Checks28 to see28 if an address is in the configured28 range
  function bit check_address_range28(int unsigned addr);
    return (!((start_address28 > addr) || (end_address28 < addr)));
  endfunction

endclass : apb_slave_config28

// APB28 Master28 Configuration28 Information28
class apb_master_config28 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed28-apb_master_config28");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config28)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config28

// APB28 Configuration28 Information28 
class apb_config28 extends uvm_object;

  // APB28 has one master28 and N slaves28
  apb_master_config28 master_config28;
  apb_slave_config28 slave_configs28[$];
  int num_slaves28;

  `uvm_object_utils_begin(apb_config28)
    `uvm_field_queue_object(slave_configs28, UVM_DEFAULT)
    `uvm_field_object(master_config28, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed28-apb_config28");
    super.new(name);
  endfunction

  // Additional28 class methods28
  extern function void add_slave28(string name, int start_addr28, int end_addr28,
            int psel_indx28, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master28(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr28(int addr);
  extern function string get_slave_name_by_addr28(int addr);
endclass  : apb_config28

// apb_config28 - Creates28 and configures28 a slave28 agent28 config and adds28 to a queue
function void apb_config28::add_slave28(string name, int start_addr28, int end_addr28,
            int psel_indx28, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config28 tmp_slave_cfg28;
  num_slaves28++;
  tmp_slave_cfg28 = apb_slave_config28::type_id::create("slave_config28");
  tmp_slave_cfg28.name = name;
  tmp_slave_cfg28.start_address28 = start_addr28;
  tmp_slave_cfg28.end_address28 = end_addr28;
  tmp_slave_cfg28.psel_index28 = psel_indx28;
  tmp_slave_cfg28.is_active = is_active;
  
  slave_configs28.push_back(tmp_slave_cfg28);
endfunction : add_slave28

// apb_config28 - Creates28 and configures28 a master28 agent28 configuration
function void apb_config28::add_master28(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config28 = apb_master_config28::type_id::create("master_config28");
  master_config28.name = name;
  master_config28.is_active = is_active;
endfunction : add_master28

// apb_config28 - Returns28 the slave28 psel28 index
function int apb_config28::get_slave_psel_by_addr28(int addr);
  for (int i = 0; i < slave_configs28.size(); i++)
    if(slave_configs28[i].check_address_range28(addr)) begin
      return slave_configs28[i].psel_index28;
    end
endfunction : get_slave_psel_by_addr28

// apb_config28 - Return28 the name of the slave28
function string apb_config28::get_slave_name_by_addr28(int addr);
  for (int i = 0; i < slave_configs28.size(); i++)
    if(slave_configs28[i].check_address_range28(addr)) begin
      return slave_configs28[i].name;
    end
endfunction : get_slave_name_by_addr28

//================================================================
// Default APB28 configuration - One28 Master28, Two28 slaves28
//================================================================
class default_apb_config28 extends apb_config28;

  `uvm_object_utils(default_apb_config28)

  function new(string name = "default_apb_config28-S0S128-master28");
    super.new(name);
    add_slave28("slave028", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave28("slave128", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master28("master28", UVM_ACTIVE);
  endfunction

endclass : default_apb_config28

`endif // APB_CONFIG_SV28
