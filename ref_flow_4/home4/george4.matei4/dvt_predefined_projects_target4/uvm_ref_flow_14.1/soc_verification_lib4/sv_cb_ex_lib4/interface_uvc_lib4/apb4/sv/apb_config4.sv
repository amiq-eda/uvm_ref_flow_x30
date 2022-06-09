/*******************************************************************************
  FILE : apb_config4.sv
  This4 file contains4 multiple configuration classes4:
    apb_slave_config4 - for configuring4 an APB4 slave4 device4
    apb_master_config4 - for configuring4 an APB4 master4 device4
    apb_config4 - has 1 master4 config and N slave4 config's
    default_apb_config4 - configures4 for 1 master4 and 2 slaves4
*******************************************************************************/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV4
`define APB_CONFIG_SV4

// APB4 Slave4 Configuration4 Information4
class apb_slave_config4 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address4;
  rand int end_address4;
  rand int psel_index4;

  constraint addr_cst4 { start_address4 <= end_address4; }
  constraint psel_cst4 { psel_index4 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config4)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address4, UVM_DEFAULT)
    `uvm_field_int(end_address4, UVM_DEFAULT)
    `uvm_field_int(psel_index4, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor4 - UVM required4 syntax4
  function new (string name = "apb_slave_config4");
    super.new(name);
  endfunction

  // Checks4 to see4 if an address is in the configured4 range
  function bit check_address_range4(int unsigned addr);
    return (!((start_address4 > addr) || (end_address4 < addr)));
  endfunction

endclass : apb_slave_config4

// APB4 Master4 Configuration4 Information4
class apb_master_config4 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed4-apb_master_config4");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config4)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config4

// APB4 Configuration4 Information4 
class apb_config4 extends uvm_object;

  // APB4 has one master4 and N slaves4
  apb_master_config4 master_config4;
  apb_slave_config4 slave_configs4[$];
  int num_slaves4;

  `uvm_object_utils_begin(apb_config4)
    `uvm_field_queue_object(slave_configs4, UVM_DEFAULT)
    `uvm_field_object(master_config4, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed4-apb_config4");
    super.new(name);
  endfunction

  // Additional4 class methods4
  extern function void add_slave4(string name, int start_addr4, int end_addr4,
            int psel_indx4, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master4(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr4(int addr);
  extern function string get_slave_name_by_addr4(int addr);
endclass  : apb_config4

// apb_config4 - Creates4 and configures4 a slave4 agent4 config and adds4 to a queue
function void apb_config4::add_slave4(string name, int start_addr4, int end_addr4,
            int psel_indx4, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config4 tmp_slave_cfg4;
  num_slaves4++;
  tmp_slave_cfg4 = apb_slave_config4::type_id::create("slave_config4");
  tmp_slave_cfg4.name = name;
  tmp_slave_cfg4.start_address4 = start_addr4;
  tmp_slave_cfg4.end_address4 = end_addr4;
  tmp_slave_cfg4.psel_index4 = psel_indx4;
  tmp_slave_cfg4.is_active = is_active;
  
  slave_configs4.push_back(tmp_slave_cfg4);
endfunction : add_slave4

// apb_config4 - Creates4 and configures4 a master4 agent4 configuration
function void apb_config4::add_master4(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config4 = apb_master_config4::type_id::create("master_config4");
  master_config4.name = name;
  master_config4.is_active = is_active;
endfunction : add_master4

// apb_config4 - Returns4 the slave4 psel4 index
function int apb_config4::get_slave_psel_by_addr4(int addr);
  for (int i = 0; i < slave_configs4.size(); i++)
    if(slave_configs4[i].check_address_range4(addr)) begin
      return slave_configs4[i].psel_index4;
    end
endfunction : get_slave_psel_by_addr4

// apb_config4 - Return4 the name of the slave4
function string apb_config4::get_slave_name_by_addr4(int addr);
  for (int i = 0; i < slave_configs4.size(); i++)
    if(slave_configs4[i].check_address_range4(addr)) begin
      return slave_configs4[i].name;
    end
endfunction : get_slave_name_by_addr4

//================================================================
// Default APB4 configuration - One4 Master4, Two4 slaves4
//================================================================
class default_apb_config4 extends apb_config4;

  `uvm_object_utils(default_apb_config4)

  function new(string name = "default_apb_config4-S0S14-master4");
    super.new(name);
    add_slave4("slave04", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave4("slave14", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master4("master4", UVM_ACTIVE);
  endfunction

endclass : default_apb_config4

`endif // APB_CONFIG_SV4
