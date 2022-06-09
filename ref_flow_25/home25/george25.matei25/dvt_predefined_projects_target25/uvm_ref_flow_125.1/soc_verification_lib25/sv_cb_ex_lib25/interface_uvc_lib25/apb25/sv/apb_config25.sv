/*******************************************************************************
  FILE : apb_config25.sv
  This25 file contains25 multiple configuration classes25:
    apb_slave_config25 - for configuring25 an APB25 slave25 device25
    apb_master_config25 - for configuring25 an APB25 master25 device25
    apb_config25 - has 1 master25 config and N slave25 config's
    default_apb_config25 - configures25 for 1 master25 and 2 slaves25
*******************************************************************************/
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


`ifndef APB_CONFIG_SV25
`define APB_CONFIG_SV25

// APB25 Slave25 Configuration25 Information25
class apb_slave_config25 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address25;
  rand int end_address25;
  rand int psel_index25;

  constraint addr_cst25 { start_address25 <= end_address25; }
  constraint psel_cst25 { psel_index25 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config25)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address25, UVM_DEFAULT)
    `uvm_field_int(end_address25, UVM_DEFAULT)
    `uvm_field_int(psel_index25, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor25 - UVM required25 syntax25
  function new (string name = "apb_slave_config25");
    super.new(name);
  endfunction

  // Checks25 to see25 if an address is in the configured25 range
  function bit check_address_range25(int unsigned addr);
    return (!((start_address25 > addr) || (end_address25 < addr)));
  endfunction

endclass : apb_slave_config25

// APB25 Master25 Configuration25 Information25
class apb_master_config25 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed25-apb_master_config25");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config25)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config25

// APB25 Configuration25 Information25 
class apb_config25 extends uvm_object;

  // APB25 has one master25 and N slaves25
  apb_master_config25 master_config25;
  apb_slave_config25 slave_configs25[$];
  int num_slaves25;

  `uvm_object_utils_begin(apb_config25)
    `uvm_field_queue_object(slave_configs25, UVM_DEFAULT)
    `uvm_field_object(master_config25, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed25-apb_config25");
    super.new(name);
  endfunction

  // Additional25 class methods25
  extern function void add_slave25(string name, int start_addr25, int end_addr25,
            int psel_indx25, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master25(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr25(int addr);
  extern function string get_slave_name_by_addr25(int addr);
endclass  : apb_config25

// apb_config25 - Creates25 and configures25 a slave25 agent25 config and adds25 to a queue
function void apb_config25::add_slave25(string name, int start_addr25, int end_addr25,
            int psel_indx25, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config25 tmp_slave_cfg25;
  num_slaves25++;
  tmp_slave_cfg25 = apb_slave_config25::type_id::create("slave_config25");
  tmp_slave_cfg25.name = name;
  tmp_slave_cfg25.start_address25 = start_addr25;
  tmp_slave_cfg25.end_address25 = end_addr25;
  tmp_slave_cfg25.psel_index25 = psel_indx25;
  tmp_slave_cfg25.is_active = is_active;
  
  slave_configs25.push_back(tmp_slave_cfg25);
endfunction : add_slave25

// apb_config25 - Creates25 and configures25 a master25 agent25 configuration
function void apb_config25::add_master25(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config25 = apb_master_config25::type_id::create("master_config25");
  master_config25.name = name;
  master_config25.is_active = is_active;
endfunction : add_master25

// apb_config25 - Returns25 the slave25 psel25 index
function int apb_config25::get_slave_psel_by_addr25(int addr);
  for (int i = 0; i < slave_configs25.size(); i++)
    if(slave_configs25[i].check_address_range25(addr)) begin
      return slave_configs25[i].psel_index25;
    end
endfunction : get_slave_psel_by_addr25

// apb_config25 - Return25 the name of the slave25
function string apb_config25::get_slave_name_by_addr25(int addr);
  for (int i = 0; i < slave_configs25.size(); i++)
    if(slave_configs25[i].check_address_range25(addr)) begin
      return slave_configs25[i].name;
    end
endfunction : get_slave_name_by_addr25

//================================================================
// Default APB25 configuration - One25 Master25, Two25 slaves25
//================================================================
class default_apb_config25 extends apb_config25;

  `uvm_object_utils(default_apb_config25)

  function new(string name = "default_apb_config25-S0S125-master25");
    super.new(name);
    add_slave25("slave025", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave25("slave125", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master25("master25", UVM_ACTIVE);
  endfunction

endclass : default_apb_config25

`endif // APB_CONFIG_SV25
