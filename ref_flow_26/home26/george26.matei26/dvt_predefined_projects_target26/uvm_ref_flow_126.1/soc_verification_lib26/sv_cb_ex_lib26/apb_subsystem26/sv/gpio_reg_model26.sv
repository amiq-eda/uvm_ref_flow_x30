`ifndef GPIO_RDB_SV26
`define GPIO_RDB_SV26

// Input26 File26: gpio_rgm26.spirit26

// Number26 of addrMaps26 = 1
// Number26 of regFiles26 = 1
// Number26 of registers = 5
// Number26 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 23


class bypass_mode_c26 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c26, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c26, uvm_reg)
  `uvm_object_utils(bypass_mode_c26)
  function new(input string name="unnamed26-bypass_mode_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : bypass_mode_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 38


class direction_mode_c26 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(direction_mode_c26, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c26, uvm_reg)
  `uvm_object_utils(direction_mode_c26)
  function new(input string name="unnamed26-direction_mode_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : direction_mode_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 53


class output_enable_c26 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(output_enable_c26, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c26, uvm_reg)
  `uvm_object_utils(output_enable_c26)
  function new(input string name="unnamed26-output_enable_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : output_enable_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 68


class output_value_c26 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(output_value_c26, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c26, uvm_reg)
  `uvm_object_utils(output_value_c26)
  function new(input string name="unnamed26-output_value_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : output_value_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 83


class input_value_c26 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(input_value_c26, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c26, uvm_reg)
  `uvm_object_utils(input_value_c26)
  function new(input string name="unnamed26-input_value_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : input_value_c26

class gpio_regfile26 extends uvm_reg_block;

  rand bypass_mode_c26 bypass_mode26;
  rand direction_mode_c26 direction_mode26;
  rand output_enable_c26 output_enable26;
  rand output_value_c26 output_value26;
  rand input_value_c26 input_value26;

  virtual function void build();

    // Now26 create all registers

    bypass_mode26 = bypass_mode_c26::type_id::create("bypass_mode26", , get_full_name());
    direction_mode26 = direction_mode_c26::type_id::create("direction_mode26", , get_full_name());
    output_enable26 = output_enable_c26::type_id::create("output_enable26", , get_full_name());
    output_value26 = output_value_c26::type_id::create("output_value26", , get_full_name());
    input_value26 = input_value_c26::type_id::create("input_value26", , get_full_name());

    // Now26 build the registers. Set parent and hdl_paths

    bypass_mode26.configure(this, null, "bypass_mode_reg26");
    bypass_mode26.build();
    direction_mode26.configure(this, null, "direction_mode_reg26");
    direction_mode26.build();
    output_enable26.configure(this, null, "output_enable_reg26");
    output_enable26.build();
    output_value26.configure(this, null, "output_value_reg26");
    output_value26.build();
    input_value26.configure(this, null, "input_value_reg26");
    input_value26.build();
    // Now26 define address mappings26
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode26, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode26, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable26, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value26, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value26, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile26)
  function new(input string name="unnamed26-gpio_rf26");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile26

//////////////////////////////////////////////////////////////////////////////
// Address_map26 definition26
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c26 extends uvm_reg_block;

  rand gpio_regfile26 gpio_rf26;

  function void build();
    // Now26 define address mappings26
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf26 = gpio_regfile26::type_id::create("gpio_rf26", , get_full_name());
    gpio_rf26.configure(this, "rf326");
    gpio_rf26.build();
    gpio_rf26.lock_model();
    default_map.add_submap(gpio_rf26.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c26");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c26)
  function new(input string name="unnamed26-gpio_reg_model_c26");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c26

`endif // GPIO_RDB_SV26
