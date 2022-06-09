/*******************************************************************************
  FILE : apb_config10.sv
  This10 file contains10 multiple configuration classes10:
    apb_slave_config10 - for configuring10 an APB10 slave10 device10
    apb_master_config10 - for configuring10 an APB10 master10 device10
    apb_config10 - has 1 master10 config and N slave10 config's
    default_apb_config10 - configures10 for 1 master10 and 2 slaves10
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV10
`define APB_CONFIG_SV10

// APB10 Slave10 Configuration10 Information10
class apb_slave_config10 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address10;
  rand int end_address10;
  rand int psel_index10;

  constraint addr_cst10 { start_address10 <= end_address10; }
  constraint psel_cst10 { psel_index10 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config10)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address10, UVM_DEFAULT)
    `uvm_field_int(end_address10, UVM_DEFAULT)
    `uvm_field_int(psel_index10, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor10 - UVM required10 syntax10
  function new (string name = "apb_slave_config10");
    super.new(name);
  endfunction

  // Checks10 to see10 if an address is in the configured10 range
  function bit check_address_range10(int unsigned addr);
    return (!((start_address10 > addr) || (end_address10 < addr)));
  endfunction

endclass : apb_slave_config10

// APB10 Master10 Configuration10 Information10
class apb_master_config10 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed10-apb_master_config10");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config10)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config10

// APB10 Configuration10 Information10 
class apb_config10 extends uvm_object;

  // APB10 has one master10 and N slaves10
  apb_master_config10 master_config10;
  apb_slave_config10 slave_configs10[$];
  int num_slaves10;

  `uvm_object_utils_begin(apb_config10)
    `uvm_field_queue_object(slave_configs10, UVM_DEFAULT)
    `uvm_field_object(master_config10, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed10-apb_config10");
    super.new(name);
  endfunction

  // Additional10 class methods10
  extern function void add_slave10(string name, int start_addr10, int end_addr10,
            int psel_indx10, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master10(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr10(int addr);
  extern function string get_slave_name_by_addr10(int addr);
endclass  : apb_config10

// apb_config10 - Creates10 and configures10 a slave10 agent10 config and adds10 to a queue
function void apb_config10::add_slave10(string name, int start_addr10, int end_addr10,
            int psel_indx10, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config10 tmp_slave_cfg10;
  num_slaves10++;
  tmp_slave_cfg10 = apb_slave_config10::type_id::create("slave_config10");
  tmp_slave_cfg10.name = name;
  tmp_slave_cfg10.start_address10 = start_addr10;
  tmp_slave_cfg10.end_address10 = end_addr10;
  tmp_slave_cfg10.psel_index10 = psel_indx10;
  tmp_slave_cfg10.is_active = is_active;
  
  slave_configs10.push_back(tmp_slave_cfg10);
endfunction : add_slave10

// apb_config10 - Creates10 and configures10 a master10 agent10 configuration
function void apb_config10::add_master10(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config10 = apb_master_config10::type_id::create("master_config10");
  master_config10.name = name;
  master_config10.is_active = is_active;
endfunction : add_master10

// apb_config10 - Returns10 the slave10 psel10 index
function int apb_config10::get_slave_psel_by_addr10(int addr);
  for (int i = 0; i < slave_configs10.size(); i++)
    if(slave_configs10[i].check_address_range10(addr)) begin
      return slave_configs10[i].psel_index10;
    end
endfunction : get_slave_psel_by_addr10

// apb_config10 - Return10 the name of the slave10
function string apb_config10::get_slave_name_by_addr10(int addr);
  for (int i = 0; i < slave_configs10.size(); i++)
    if(slave_configs10[i].check_address_range10(addr)) begin
      return slave_configs10[i].name;
    end
endfunction : get_slave_name_by_addr10

//================================================================
// Default APB10 configuration - One10 Master10, Two10 slaves10
//================================================================
class default_apb_config10 extends apb_config10;

  `uvm_object_utils(default_apb_config10)

  function new(string name = "default_apb_config10-S0S110-master10");
    super.new(name);
    add_slave10("slave010", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave10("slave110", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master10("master10", UVM_ACTIVE);
  endfunction

endclass : default_apb_config10

`endif // APB_CONFIG_SV10
