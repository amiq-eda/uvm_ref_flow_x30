`ifndef GPIO_RDB_SV29
`define GPIO_RDB_SV29

// Input29 File29: gpio_rgm29.spirit29

// Number29 of addrMaps29 = 1
// Number29 of regFiles29 = 1
// Number29 of registers = 5
// Number29 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 23


class bypass_mode_c29 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c29, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c29, uvm_reg)
  `uvm_object_utils(bypass_mode_c29)
  function new(input string name="unnamed29-bypass_mode_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : bypass_mode_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 38


class direction_mode_c29 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(direction_mode_c29, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c29, uvm_reg)
  `uvm_object_utils(direction_mode_c29)
  function new(input string name="unnamed29-direction_mode_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : direction_mode_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 53


class output_enable_c29 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(output_enable_c29, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c29, uvm_reg)
  `uvm_object_utils(output_enable_c29)
  function new(input string name="unnamed29-output_enable_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : output_enable_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 68


class output_value_c29 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(output_value_c29, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c29, uvm_reg)
  `uvm_object_utils(output_value_c29)
  function new(input string name="unnamed29-output_value_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : output_value_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 83


class input_value_c29 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg29;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg29.sample();
  endfunction

  `uvm_register_cb(input_value_c29, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c29, uvm_reg)
  `uvm_object_utils(input_value_c29)
  function new(input string name="unnamed29-input_value_c29");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg29=new;
  endfunction : new
endclass : input_value_c29

class gpio_regfile29 extends uvm_reg_block;

  rand bypass_mode_c29 bypass_mode29;
  rand direction_mode_c29 direction_mode29;
  rand output_enable_c29 output_enable29;
  rand output_value_c29 output_value29;
  rand input_value_c29 input_value29;

  virtual function void build();

    // Now29 create all registers

    bypass_mode29 = bypass_mode_c29::type_id::create("bypass_mode29", , get_full_name());
    direction_mode29 = direction_mode_c29::type_id::create("direction_mode29", , get_full_name());
    output_enable29 = output_enable_c29::type_id::create("output_enable29", , get_full_name());
    output_value29 = output_value_c29::type_id::create("output_value29", , get_full_name());
    input_value29 = input_value_c29::type_id::create("input_value29", , get_full_name());

    // Now29 build the registers. Set parent and hdl_paths

    bypass_mode29.configure(this, null, "bypass_mode_reg29");
    bypass_mode29.build();
    direction_mode29.configure(this, null, "direction_mode_reg29");
    direction_mode29.build();
    output_enable29.configure(this, null, "output_enable_reg29");
    output_enable29.build();
    output_value29.configure(this, null, "output_value_reg29");
    output_value29.build();
    input_value29.configure(this, null, "input_value_reg29");
    input_value29.build();
    // Now29 define address mappings29
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode29, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode29, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable29, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value29, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value29, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile29)
  function new(input string name="unnamed29-gpio_rf29");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile29

//////////////////////////////////////////////////////////////////////////////
// Address_map29 definition29
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c29 extends uvm_reg_block;

  rand gpio_regfile29 gpio_rf29;

  function void build();
    // Now29 define address mappings29
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf29 = gpio_regfile29::type_id::create("gpio_rf29", , get_full_name());
    gpio_rf29.configure(this, "rf329");
    gpio_rf29.build();
    gpio_rf29.lock_model();
    default_map.add_submap(gpio_rf29.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c29");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c29)
  function new(input string name="unnamed29-gpio_reg_model_c29");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c29

`endif // GPIO_RDB_SV29
