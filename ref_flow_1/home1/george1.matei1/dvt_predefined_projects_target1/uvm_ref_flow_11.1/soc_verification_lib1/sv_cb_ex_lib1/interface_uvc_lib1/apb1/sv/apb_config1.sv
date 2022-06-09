/*******************************************************************************
  FILE : apb_config1.sv
  This1 file contains1 multiple configuration classes1:
    apb_slave_config1 - for configuring1 an APB1 slave1 device1
    apb_master_config1 - for configuring1 an APB1 master1 device1
    apb_config1 - has 1 master1 config and N slave1 config's
    default_apb_config1 - configures1 for 1 master1 and 2 slaves1
*******************************************************************************/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV1
`define APB_CONFIG_SV1

// APB1 Slave1 Configuration1 Information1
class apb_slave_config1 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address1;
  rand int end_address1;
  rand int psel_index1;

  constraint addr_cst1 { start_address1 <= end_address1; }
  constraint psel_cst1 { psel_index1 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config1)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address1, UVM_DEFAULT)
    `uvm_field_int(end_address1, UVM_DEFAULT)
    `uvm_field_int(psel_index1, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor1 - UVM required1 syntax1
  function new (string name = "apb_slave_config1");
    super.new(name);
  endfunction

  // Checks1 to see1 if an address is in the configured1 range
  function bit check_address_range1(int unsigned addr);
    return (!((start_address1 > addr) || (end_address1 < addr)));
  endfunction

endclass : apb_slave_config1

// APB1 Master1 Configuration1 Information1
class apb_master_config1 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed1-apb_master_config1");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config1)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config1

// APB1 Configuration1 Information1 
class apb_config1 extends uvm_object;

  // APB1 has one master1 and N slaves1
  apb_master_config1 master_config1;
  apb_slave_config1 slave_configs1[$];
  int num_slaves1;

  `uvm_object_utils_begin(apb_config1)
    `uvm_field_queue_object(slave_configs1, UVM_DEFAULT)
    `uvm_field_object(master_config1, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed1-apb_config1");
    super.new(name);
  endfunction

  // Additional1 class methods1
  extern function void add_slave1(string name, int start_addr1, int end_addr1,
            int psel_indx1, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master1(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr1(int addr);
  extern function string get_slave_name_by_addr1(int addr);
endclass  : apb_config1

// apb_config1 - Creates1 and configures1 a slave1 agent1 config and adds1 to a queue
function void apb_config1::add_slave1(string name, int start_addr1, int end_addr1,
            int psel_indx1, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config1 tmp_slave_cfg1;
  num_slaves1++;
  tmp_slave_cfg1 = apb_slave_config1::type_id::create("slave_config1");
  tmp_slave_cfg1.name = name;
  tmp_slave_cfg1.start_address1 = start_addr1;
  tmp_slave_cfg1.end_address1 = end_addr1;
  tmp_slave_cfg1.psel_index1 = psel_indx1;
  tmp_slave_cfg1.is_active = is_active;
  
  slave_configs1.push_back(tmp_slave_cfg1);
endfunction : add_slave1

// apb_config1 - Creates1 and configures1 a master1 agent1 configuration
function void apb_config1::add_master1(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config1 = apb_master_config1::type_id::create("master_config1");
  master_config1.name = name;
  master_config1.is_active = is_active;
endfunction : add_master1

// apb_config1 - Returns1 the slave1 psel1 index
function int apb_config1::get_slave_psel_by_addr1(int addr);
  for (int i = 0; i < slave_configs1.size(); i++)
    if(slave_configs1[i].check_address_range1(addr)) begin
      return slave_configs1[i].psel_index1;
    end
endfunction : get_slave_psel_by_addr1

// apb_config1 - Return1 the name of the slave1
function string apb_config1::get_slave_name_by_addr1(int addr);
  for (int i = 0; i < slave_configs1.size(); i++)
    if(slave_configs1[i].check_address_range1(addr)) begin
      return slave_configs1[i].name;
    end
endfunction : get_slave_name_by_addr1

//================================================================
// Default APB1 configuration - One1 Master1, Two1 slaves1
//================================================================
class default_apb_config1 extends apb_config1;

  `uvm_object_utils(default_apb_config1)

  function new(string name = "default_apb_config1-S0S11-master1");
    super.new(name);
    add_slave1("slave01", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave1("slave11", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master1("master1", UVM_ACTIVE);
  endfunction

endclass : default_apb_config1

`endif // APB_CONFIG_SV1
