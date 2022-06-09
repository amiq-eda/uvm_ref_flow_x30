/*******************************************************************************
  FILE : apb_config30.sv
  This30 file contains30 multiple configuration classes30:
    apb_slave_config30 - for configuring30 an APB30 slave30 device30
    apb_master_config30 - for configuring30 an APB30 master30 device30
    apb_config30 - has 1 master30 config and N slave30 config's
    default_apb_config30 - configures30 for 1 master30 and 2 slaves30
*******************************************************************************/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_CONFIG_SV30
`define APB_CONFIG_SV30

// APB30 Slave30 Configuration30 Information30
class apb_slave_config30 extends uvm_object;
  string name;
  rand uvm_active_passive_enum is_active = UVM_ACTIVE;
  rand int start_address30;
  rand int end_address30;
  rand int psel_index30;

  constraint addr_cst30 { start_address30 <= end_address30; }
  constraint psel_cst30 { psel_index30 inside {[0:15]}; }

  `uvm_object_utils_begin(apb_slave_config30)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(start_address30, UVM_DEFAULT)
    `uvm_field_int(end_address30, UVM_DEFAULT)
    `uvm_field_int(psel_index30, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor30 - UVM required30 syntax30
  function new (string name = "apb_slave_config30");
    super.new(name);
  endfunction

  // Checks30 to see30 if an address is in the configured30 range
  function bit check_address_range30(int unsigned addr);
    return (!((start_address30 > addr) || (end_address30 < addr)));
  endfunction

endclass : apb_slave_config30

// APB30 Master30 Configuration30 Information30
class apb_master_config30 extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new (string name = "unnamed30-apb_master_config30");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_master_config30)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : apb_master_config30

// APB30 Configuration30 Information30 
class apb_config30 extends uvm_object;

  // APB30 has one master30 and N slaves30
  apb_master_config30 master_config30;
  apb_slave_config30 slave_configs30[$];
  int num_slaves30;

  `uvm_object_utils_begin(apb_config30)
    `uvm_field_queue_object(slave_configs30, UVM_DEFAULT)
    `uvm_field_object(master_config30, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed30-apb_config30");
    super.new(name);
  endfunction

  // Additional30 class methods30
  extern function void add_slave30(string name, int start_addr30, int end_addr30,
            int psel_indx30, uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function void add_master30(string name,
            uvm_active_passive_enum is_active = UVM_ACTIVE);
  extern function int get_slave_psel_by_addr30(int addr);
  extern function string get_slave_name_by_addr30(int addr);
endclass  : apb_config30

// apb_config30 - Creates30 and configures30 a slave30 agent30 config and adds30 to a queue
function void apb_config30::add_slave30(string name, int start_addr30, int end_addr30,
            int psel_indx30, uvm_active_passive_enum is_active = UVM_ACTIVE);
  apb_slave_config30 tmp_slave_cfg30;
  num_slaves30++;
  tmp_slave_cfg30 = apb_slave_config30::type_id::create("slave_config30");
  tmp_slave_cfg30.name = name;
  tmp_slave_cfg30.start_address30 = start_addr30;
  tmp_slave_cfg30.end_address30 = end_addr30;
  tmp_slave_cfg30.psel_index30 = psel_indx30;
  tmp_slave_cfg30.is_active = is_active;
  
  slave_configs30.push_back(tmp_slave_cfg30);
endfunction : add_slave30

// apb_config30 - Creates30 and configures30 a master30 agent30 configuration
function void apb_config30::add_master30(string name, uvm_active_passive_enum is_active = UVM_ACTIVE);
  master_config30 = apb_master_config30::type_id::create("master_config30");
  master_config30.name = name;
  master_config30.is_active = is_active;
endfunction : add_master30

// apb_config30 - Returns30 the slave30 psel30 index
function int apb_config30::get_slave_psel_by_addr30(int addr);
  for (int i = 0; i < slave_configs30.size(); i++)
    if(slave_configs30[i].check_address_range30(addr)) begin
      return slave_configs30[i].psel_index30;
    end
endfunction : get_slave_psel_by_addr30

// apb_config30 - Return30 the name of the slave30
function string apb_config30::get_slave_name_by_addr30(int addr);
  for (int i = 0; i < slave_configs30.size(); i++)
    if(slave_configs30[i].check_address_range30(addr)) begin
      return slave_configs30[i].name;
    end
endfunction : get_slave_name_by_addr30

//================================================================
// Default APB30 configuration - One30 Master30, Two30 slaves30
//================================================================
class default_apb_config30 extends apb_config30;

  `uvm_object_utils(default_apb_config30)

  function new(string name = "default_apb_config30-S0S130-master30");
    super.new(name);
    add_slave30("slave030", 32'h0000_0000, 32'h7FFF_FFFF, 0, UVM_ACTIVE);
    add_slave30("slave130", 32'h8000_0000, 32'hFFFF_FFFF, 1, UVM_ACTIVE);
    add_master30("master30", UVM_ACTIVE);
  endfunction

endclass : default_apb_config30

`endif // APB_CONFIG_SV30
