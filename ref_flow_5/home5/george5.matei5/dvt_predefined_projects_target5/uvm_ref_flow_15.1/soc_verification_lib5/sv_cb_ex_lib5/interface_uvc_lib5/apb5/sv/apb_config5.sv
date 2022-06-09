/*******************************************************************************
  FILE : apb_config5.sv
  This5 file contains5 multiple configuration classes5:
    apb_slave_config5 - for configuring5 an APB5 slave5 device5
    apb_master_config5 - for configuring5 an APB5 master5 device5
    apb_config5 - has 1 master5 config and N slave5 config's
    default_apb_config5 - configures5 for 1 master5 and 2 slaves5
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV5
`define APB_CONFIG_SV5

// APB5 Slave5 Configuration5 Information5
class apb_slave_config5 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address5;
  rand int end_address5;
  rand int psel_index5;

  constraint addr_cst5 { start_address5 <= end_address5; }
  constraint psel_cst5 { psel_index5 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config5)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address5, UVM_DEFAULT)
    `uvm_field_int(end_address5, UVM_DEFAULT)
    `uvm_field_int(psel_index5, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor5 - UVM required5 syntax5
  function new (string name = "apb_slave_config5");
    super.new(name);
  endfunction

  // Checks5 to see5 if an address is in the configured5 range
  function bit check_address_range5(int unsigned addr);
    return (!((start_address5 > addr) || (end_address5 < addr)));
  endfunction

endclass : apb_slave_config5

// APB5 Master5 Configuration5 Information5
class apb_master_config5 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed5-apb_master_config5");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config5)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config5

// APB5 Configuration5 Information5 
class apb_config5 extends uvm_object;

  // APB5 has one master5 and N slaves5
  apb_master_config5 master_config5;
  apb_slave_config5 slave_configs5[$];
  int num_slaves5;

  `uvm_object_utils_begin(apb_config5)
    `uvm_field_queue_object(slave_configs5, UVM_DEFAULT)
    `uvm_field_object(master_config5, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed5-apb_config5");
    super.new(name);
  endfunction

  // Additional5 class methods5
  extern function void add_slave5(string name, int start_addr5, int end_addr5,
            int psel_indx5, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master5(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr5(int addr);
  extern function string get_slave_name_by_addr5(int addr);
endclass  : apb_config5

// apb_config5 - Creates5 and configures5 a slave5 agent5 config and adds5 to a queue
function void apb_config5::add_slave5(string name, int start_addr5, int end_addr5,
            int psel_indx5, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config5 tmp_slave_cfg5;
  num_slaves5++;
  tmp_slave_cfg5 = apb_slave_config5::type_id::create("slave_config5");
  tmp_slave_cfg5.name = name;
  tmp_slave_cfg5.start_address5 = start_addr5;
  tmp_slave_cfg5.end_address5 = end_addr5;
  tmp_slave_cfg5.psel_index5 = psel_indx5;
  tmp_slave_cfg5.is_active = is_active;
  
  slave_configs5.push_back(tmp_slave_cfg5);
endfunction : add_slave5

// apb_config5 - Creates5 and configures5 a master5 agent5 configuration
function void apb_config5::add_master5(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config5 = apb_master_config5::type_id::create("master_config5");
  master_config5.name = name;
  master_config5.is_active = is_active;
endfunction : add_master5

// apb_config5 - Returns5 the slave5 psel5 index
function int apb_config5::get_slave_psel_by_addr5(int addr);
  for (int i = 0; i < slave_configs5.size(); i++)
    if(slave_configs5[i].check_address_range5(addr)) begin
      return slave_configs5[i].psel_index5;
    end
endfunction : get_slave_psel_by_addr5

// apb_config5 - Return5 the name of the slave5
function string apb_config5::get_slave_name_by_addr5(int addr);
  for (int i = 0; i < slave_configs5.size(); i++)
    if(slave_configs5[i].check_address_range5(addr)) begin
      return slave_configs5[i].name;
    end
endfunction : get_slave_name_by_addr5

//================================================================
// Default APB5 configuration - One5 Master5, Two5 slaves5
//================================================================
class default_apb_config5 extends apb_config5;

  `uvm_object_utils(default_apb_config5)

  function new(string name = "default_apb_config5-S0S15-master5");
    super.new(name);
    add_slave5("slave05", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave5("slave15", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master5("master5", UVM_ACTIVE);
  endfunction

endclass : default_apb_config5

`endif // APB_CONFIG_SV5
