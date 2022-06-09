/*******************************************************************************
  FILE : apb_config29.sv
  This29 file contains29 multiple configuration classes29:
    apb_slave_config29 - for configuring29 an APB29 slave29 device29
    apb_master_config29 - for configuring29 an APB29 master29 device29
    apb_config29 - has 1 master29 config and N slave29 config's
    default_apb_config29 - configures29 for 1 master29 and 2 slaves29
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV29
`define APB_CONFIG_SV29

// APB29 Slave29 Configuration29 Information29
class apb_slave_config29 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address29;
  rand int end_address29;
  rand int psel_index29;

  constraint addr_cst29 { start_address29 <= end_address29; }
  constraint psel_cst29 { psel_index29 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config29)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address29, UVM_DEFAULT)
    `uvm_field_int(end_address29, UVM_DEFAULT)
    `uvm_field_int(psel_index29, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor29 - UVM required29 syntax29
  function new (string name = "apb_slave_config29");
    super.new(name);
  endfunction

  // Checks29 to see29 if an address is in the configured29 range
  function bit check_address_range29(int unsigned addr);
    return (!((start_address29 > addr) || (end_address29 < addr)));
  endfunction

endclass : apb_slave_config29

// APB29 Master29 Configuration29 Information29
class apb_master_config29 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed29-apb_master_config29");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config29)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config29

// APB29 Configuration29 Information29 
class apb_config29 extends uvm_object;

  // APB29 has one master29 and N slaves29
  apb_master_config29 master_config29;
  apb_slave_config29 slave_configs29[$];
  int num_slaves29;

  `uvm_object_utils_begin(apb_config29)
    `uvm_field_queue_object(slave_configs29, UVM_DEFAULT)
    `uvm_field_object(master_config29, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed29-apb_config29");
    super.new(name);
  endfunction

  // Additional29 class methods29
  extern function void add_slave29(string name, int start_addr29, int end_addr29,
            int psel_indx29, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master29(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr29(int addr);
  extern function string get_slave_name_by_addr29(int addr);
endclass  : apb_config29

// apb_config29 - Creates29 and configures29 a slave29 agent29 config and adds29 to a queue
function void apb_config29::add_slave29(string name, int start_addr29, int end_addr29,
            int psel_indx29, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config29 tmp_slave_cfg29;
  num_slaves29++;
  tmp_slave_cfg29 = apb_slave_config29::type_id::create("slave_config29");
  tmp_slave_cfg29.name = name;
  tmp_slave_cfg29.start_address29 = start_addr29;
  tmp_slave_cfg29.end_address29 = end_addr29;
  tmp_slave_cfg29.psel_index29 = psel_indx29;
  tmp_slave_cfg29.is_active = is_active;
  
  slave_configs29.push_back(tmp_slave_cfg29);
endfunction : add_slave29

// apb_config29 - Creates29 and configures29 a master29 agent29 configuration
function void apb_config29::add_master29(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config29 = apb_master_config29::type_id::create("master_config29");
  master_config29.name = name;
  master_config29.is_active = is_active;
endfunction : add_master29

// apb_config29 - Returns29 the slave29 psel29 index
function int apb_config29::get_slave_psel_by_addr29(int addr);
  for (int i = 0; i < slave_configs29.size(); i++)
    if(slave_configs29[i].check_address_range29(addr)) begin
      return slave_configs29[i].psel_index29;
    end
endfunction : get_slave_psel_by_addr29

// apb_config29 - Return29 the name of the slave29
function string apb_config29::get_slave_name_by_addr29(int addr);
  for (int i = 0; i < slave_configs29.size(); i++)
    if(slave_configs29[i].check_address_range29(addr)) begin
      return slave_configs29[i].name;
    end
endfunction : get_slave_name_by_addr29

//================================================================
// Default APB29 configuration - One29 Master29, Two29 slaves29
//================================================================
class default_apb_config29 extends apb_config29;

  `uvm_object_utils(default_apb_config29)

  function new(string name = "default_apb_config29-S0S129-master29");
    super.new(name);
    add_slave29("slave029", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave29("slave129", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master29("master29", UVM_ACTIVE);
  endfunction

endclass : default_apb_config29

`endif // APB_CONFIG_SV29
