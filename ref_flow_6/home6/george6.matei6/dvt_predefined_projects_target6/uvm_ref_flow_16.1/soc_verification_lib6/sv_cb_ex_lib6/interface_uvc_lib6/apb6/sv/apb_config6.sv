/*******************************************************************************
  FILE : apb_config6.sv
  This6 file contains6 multiple configuration classes6:
    apb_slave_config6 - for configuring6 an APB6 slave6 device6
    apb_master_config6 - for configuring6 an APB6 master6 device6
    apb_config6 - has 1 master6 config and N slave6 config's
    default_apb_config6 - configures6 for 1 master6 and 2 slaves6
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV6
`define APB_CONFIG_SV6

// APB6 Slave6 Configuration6 Information6
class apb_slave_config6 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address6;
  rand int end_address6;
  rand int psel_index6;

  constraint addr_cst6 { start_address6 <= end_address6; }
  constraint psel_cst6 { psel_index6 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config6)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address6, UVM_DEFAULT)
    `uvm_field_int(end_address6, UVM_DEFAULT)
    `uvm_field_int(psel_index6, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor6 - UVM required6 syntax6
  function new (string name = "apb_slave_config6");
    super.new(name);
  endfunction

  // Checks6 to see6 if an address is in the configured6 range
  function bit check_address_range6(int unsigned addr);
    return (!((start_address6 > addr) || (end_address6 < addr)));
  endfunction

endclass : apb_slave_config6

// APB6 Master6 Configuration6 Information6
class apb_master_config6 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed6-apb_master_config6");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config6)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config6

// APB6 Configuration6 Information6 
class apb_config6 extends uvm_object;

  // APB6 has one master6 and N slaves6
  apb_master_config6 master_config6;
  apb_slave_config6 slave_configs6[$];
  int num_slaves6;

  `uvm_object_utils_begin(apb_config6)
    `uvm_field_queue_object(slave_configs6, UVM_DEFAULT)
    `uvm_field_object(master_config6, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed6-apb_config6");
    super.new(name);
  endfunction

  // Additional6 class methods6
  extern function void add_slave6(string name, int start_addr6, int end_addr6,
            int psel_indx6, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master6(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr6(int addr);
  extern function string get_slave_name_by_addr6(int addr);
endclass  : apb_config6

// apb_config6 - Creates6 and configures6 a slave6 agent6 config and adds6 to a queue
function void apb_config6::add_slave6(string name, int start_addr6, int end_addr6,
            int psel_indx6, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config6 tmp_slave_cfg6;
  num_slaves6++;
  tmp_slave_cfg6 = apb_slave_config6::type_id::create("slave_config6");
  tmp_slave_cfg6.name = name;
  tmp_slave_cfg6.start_address6 = start_addr6;
  tmp_slave_cfg6.end_address6 = end_addr6;
  tmp_slave_cfg6.psel_index6 = psel_indx6;
  tmp_slave_cfg6.is_active = is_active;
  
  slave_configs6.push_back(tmp_slave_cfg6);
endfunction : add_slave6

// apb_config6 - Creates6 and configures6 a master6 agent6 configuration
function void apb_config6::add_master6(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config6 = apb_master_config6::type_id::create("master_config6");
  master_config6.name = name;
  master_config6.is_active = is_active;
endfunction : add_master6

// apb_config6 - Returns6 the slave6 psel6 index
function int apb_config6::get_slave_psel_by_addr6(int addr);
  for (int i = 0; i < slave_configs6.size(); i++)
    if(slave_configs6[i].check_address_range6(addr)) begin
      return slave_configs6[i].psel_index6;
    end
endfunction : get_slave_psel_by_addr6

// apb_config6 - Return6 the name of the slave6
function string apb_config6::get_slave_name_by_addr6(int addr);
  for (int i = 0; i < slave_configs6.size(); i++)
    if(slave_configs6[i].check_address_range6(addr)) begin
      return slave_configs6[i].name;
    end
endfunction : get_slave_name_by_addr6

//================================================================
// Default APB6 configuration - One6 Master6, Two6 slaves6
//================================================================
class default_apb_config6 extends apb_config6;

  `uvm_object_utils(default_apb_config6)

  function new(string name = "default_apb_config6-S0S16-master6");
    super.new(name);
    add_slave6("slave06", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave6("slave16", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master6("master6", UVM_ACTIVE);
  endfunction

endclass : default_apb_config6

`endif // APB_CONFIG_SV6
