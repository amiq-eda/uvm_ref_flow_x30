/*******************************************************************************
  FILE : apb_config18.sv
  This18 file contains18 multiple configuration classes18:
    apb_slave_config18 - for configuring18 an APB18 slave18 device18
    apb_master_config18 - for configuring18 an APB18 master18 device18
    apb_config18 - has 1 master18 config and N slave18 config's
    default_apb_config18 - configures18 for 1 master18 and 2 slaves18
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV18
`define APB_CONFIG_SV18

// APB18 Slave18 Configuration18 Information18
class apb_slave_config18 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address18;
  rand int end_address18;
  rand int psel_index18;

  constraint addr_cst18 { start_address18 <= end_address18; }
  constraint psel_cst18 { psel_index18 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config18)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address18, UVM_DEFAULT)
    `uvm_field_int(end_address18, UVM_DEFAULT)
    `uvm_field_int(psel_index18, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor18 - UVM required18 syntax18
  function new (string name = "apb_slave_config18");
    super.new(name);
  endfunction

  // Checks18 to see18 if an address is in the configured18 range
  function bit check_address_range18(int unsigned addr);
    return (!((start_address18 > addr) || (end_address18 < addr)));
  endfunction

endclass : apb_slave_config18

// APB18 Master18 Configuration18 Information18
class apb_master_config18 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed18-apb_master_config18");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config18)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config18

// APB18 Configuration18 Information18 
class apb_config18 extends uvm_object;

  // APB18 has one master18 and N slaves18
  apb_master_config18 master_config18;
  apb_slave_config18 slave_configs18[$];
  int num_slaves18;

  `uvm_object_utils_begin(apb_config18)
    `uvm_field_queue_object(slave_configs18, UVM_DEFAULT)
    `uvm_field_object(master_config18, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed18-apb_config18");
    super.new(name);
  endfunction

  // Additional18 class methods18
  extern function void add_slave18(string name, int start_addr18, int end_addr18,
            int psel_indx18, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master18(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr18(int addr);
  extern function string get_slave_name_by_addr18(int addr);
endclass  : apb_config18

// apb_config18 - Creates18 and configures18 a slave18 agent18 config and adds18 to a queue
function void apb_config18::add_slave18(string name, int start_addr18, int end_addr18,
            int psel_indx18, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config18 tmp_slave_cfg18;
  num_slaves18++;
  tmp_slave_cfg18 = apb_slave_config18::type_id::create("slave_config18");
  tmp_slave_cfg18.name = name;
  tmp_slave_cfg18.start_address18 = start_addr18;
  tmp_slave_cfg18.end_address18 = end_addr18;
  tmp_slave_cfg18.psel_index18 = psel_indx18;
  tmp_slave_cfg18.is_active = is_active;
  
  slave_configs18.push_back(tmp_slave_cfg18);
endfunction : add_slave18

// apb_config18 - Creates18 and configures18 a master18 agent18 configuration
function void apb_config18::add_master18(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config18 = apb_master_config18::type_id::create("master_config18");
  master_config18.name = name;
  master_config18.is_active = is_active;
endfunction : add_master18

// apb_config18 - Returns18 the slave18 psel18 index
function int apb_config18::get_slave_psel_by_addr18(int addr);
  for (int i = 0; i < slave_configs18.size(); i++)
    if(slave_configs18[i].check_address_range18(addr)) begin
      return slave_configs18[i].psel_index18;
    end
endfunction : get_slave_psel_by_addr18

// apb_config18 - Return18 the name of the slave18
function string apb_config18::get_slave_name_by_addr18(int addr);
  for (int i = 0; i < slave_configs18.size(); i++)
    if(slave_configs18[i].check_address_range18(addr)) begin
      return slave_configs18[i].name;
    end
endfunction : get_slave_name_by_addr18

//================================================================
// Default APB18 configuration - One18 Master18, Two18 slaves18
//================================================================
class default_apb_config18 extends apb_config18;

  `uvm_object_utils(default_apb_config18)

  function new(string name = "default_apb_config18-S0S118-master18");
    super.new(name);
    add_slave18("slave018", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave18("slave118", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master18("master18", UVM_ACTIVE);
  endfunction

endclass : default_apb_config18

`endif // APB_CONFIG_SV18
