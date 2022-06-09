/*******************************************************************************
  FILE : apb_config19.sv
  This19 file contains19 multiple configuration classes19:
    apb_slave_config19 - for configuring19 an APB19 slave19 device19
    apb_master_config19 - for configuring19 an APB19 master19 device19
    apb_config19 - has 1 master19 config and N slave19 config's
    default_apb_config19 - configures19 for 1 master19 and 2 slaves19
*******************************************************************************/
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


`ifndef APB_CONFIG_SV19
`define APB_CONFIG_SV19

// APB19 Slave19 Configuration19 Information19
class apb_slave_config19 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address19;
  rand int end_address19;
  rand int psel_index19;

  constraint addr_cst19 { start_address19 <= end_address19; }
  constraint psel_cst19 { psel_index19 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config19)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address19, UVM_DEFAULT)
    `uvm_field_int(end_address19, UVM_DEFAULT)
    `uvm_field_int(psel_index19, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor19 - UVM required19 syntax19
  function new (string name = "apb_slave_config19");
    super.new(name);
  endfunction

  // Checks19 to see19 if an address is in the configured19 range
  function bit check_address_range19(int unsigned addr);
    return (!((start_address19 > addr) || (end_address19 < addr)));
  endfunction

endclass : apb_slave_config19

// APB19 Master19 Configuration19 Information19
class apb_master_config19 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed19-apb_master_config19");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config19)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config19

// APB19 Configuration19 Information19 
class apb_config19 extends uvm_object;

  // APB19 has one master19 and N slaves19
  apb_master_config19 master_config19;
  apb_slave_config19 slave_configs19[$];
  int num_slaves19;

  `uvm_object_utils_begin(apb_config19)
    `uvm_field_queue_object(slave_configs19, UVM_DEFAULT)
    `uvm_field_object(master_config19, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed19-apb_config19");
    super.new(name);
  endfunction

  // Additional19 class methods19
  extern function void add_slave19(string name, int start_addr19, int end_addr19,
            int psel_indx19, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master19(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr19(int addr);
  extern function string get_slave_name_by_addr19(int addr);
endclass  : apb_config19

// apb_config19 - Creates19 and configures19 a slave19 agent19 config and adds19 to a queue
function void apb_config19::add_slave19(string name, int start_addr19, int end_addr19,
            int psel_indx19, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config19 tmp_slave_cfg19;
  num_slaves19++;
  tmp_slave_cfg19 = apb_slave_config19::type_id::create("slave_config19");
  tmp_slave_cfg19.name = name;
  tmp_slave_cfg19.start_address19 = start_addr19;
  tmp_slave_cfg19.end_address19 = end_addr19;
  tmp_slave_cfg19.psel_index19 = psel_indx19;
  tmp_slave_cfg19.is_active = is_active;
  
  slave_configs19.push_back(tmp_slave_cfg19);
endfunction : add_slave19

// apb_config19 - Creates19 and configures19 a master19 agent19 configuration
function void apb_config19::add_master19(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config19 = apb_master_config19::type_id::create("master_config19");
  master_config19.name = name;
  master_config19.is_active = is_active;
endfunction : add_master19

// apb_config19 - Returns19 the slave19 psel19 index
function int apb_config19::get_slave_psel_by_addr19(int addr);
  for (int i = 0; i < slave_configs19.size(); i++)
    if(slave_configs19[i].check_address_range19(addr)) begin
      return slave_configs19[i].psel_index19;
    end
endfunction : get_slave_psel_by_addr19

// apb_config19 - Return19 the name of the slave19
function string apb_config19::get_slave_name_by_addr19(int addr);
  for (int i = 0; i < slave_configs19.size(); i++)
    if(slave_configs19[i].check_address_range19(addr)) begin
      return slave_configs19[i].name;
    end
endfunction : get_slave_name_by_addr19

//================================================================
// Default APB19 configuration - One19 Master19, Two19 slaves19
//================================================================
class default_apb_config19 extends apb_config19;

  `uvm_object_utils(default_apb_config19)

  function new(string name = "default_apb_config19-S0S119-master19");
    super.new(name);
    add_slave19("slave019", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave19("slave119", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master19("master19", UVM_ACTIVE);
  endfunction

endclass : default_apb_config19

`endif // APB_CONFIG_SV19
