`ifndef GPIO_RDB_SV11
`define GPIO_RDB_SV11

// Input11 File11: gpio_rgm11.spirit11

// Number11 of addrMaps11 = 1
// Number11 of regFiles11 = 1
// Number11 of registers = 5
// Number11 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 23


class bypass_mode_c11 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c11, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c11, uvm_reg)
  `uvm_object_utils(bypass_mode_c11)
  function new(input string name="unnamed11-bypass_mode_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : bypass_mode_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 38


class direction_mode_c11 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(direction_mode_c11, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c11, uvm_reg)
  `uvm_object_utils(direction_mode_c11)
  function new(input string name="unnamed11-direction_mode_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : direction_mode_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 53


class output_enable_c11 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(output_enable_c11, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c11, uvm_reg)
  `uvm_object_utils(output_enable_c11)
  function new(input string name="unnamed11-output_enable_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : output_enable_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 68


class output_value_c11 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(output_value_c11, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c11, uvm_reg)
  `uvm_object_utils(output_value_c11)
  function new(input string name="unnamed11-output_value_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : output_value_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 83


class input_value_c11 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg11;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg11.sample();
  endfunction

  `uvm_register_cb(input_value_c11, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c11, uvm_reg)
  `uvm_object_utils(input_value_c11)
  function new(input string name="unnamed11-input_value_c11");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg11=new;
  endfunction : new
endclass : input_value_c11

class gpio_regfile11 extends uvm_reg_block;

  rand bypass_mode_c11 bypass_mode11;
  rand direction_mode_c11 direction_mode11;
  rand output_enable_c11 output_enable11;
  rand output_value_c11 output_value11;
  rand input_value_c11 input_value11;

  virtual function void build();

    // Now11 create all registers

    bypass_mode11 = bypass_mode_c11::type_id::create("bypass_mode11", , get_full_name());
    direction_mode11 = direction_mode_c11::type_id::create("direction_mode11", , get_full_name());
    output_enable11 = output_enable_c11::type_id::create("output_enable11", , get_full_name());
    output_value11 = output_value_c11::type_id::create("output_value11", , get_full_name());
    input_value11 = input_value_c11::type_id::create("input_value11", , get_full_name());

    // Now11 build the registers. Set parent and hdl_paths

    bypass_mode11.configure(this, null, "bypass_mode_reg11");
    bypass_mode11.build();
    direction_mode11.configure(this, null, "direction_mode_reg11");
    direction_mode11.build();
    output_enable11.configure(this, null, "output_enable_reg11");
    output_enable11.build();
    output_value11.configure(this, null, "output_value_reg11");
    output_value11.build();
    input_value11.configure(this, null, "input_value_reg11");
    input_value11.build();
    // Now11 define address mappings11
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode11, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode11, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable11, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value11, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value11, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile11)
  function new(input string name="unnamed11-gpio_rf11");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile11

//////////////////////////////////////////////////////////////////////////////
// Address_map11 definition11
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c11 extends uvm_reg_block;

  rand gpio_regfile11 gpio_rf11;

  function void build();
    // Now11 define address mappings11
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf11 = gpio_regfile11::type_id::create("gpio_rf11", , get_full_name());
    gpio_rf11.configure(this, "rf311");
    gpio_rf11.build();
    gpio_rf11.lock_model();
    default_map.add_submap(gpio_rf11.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c11");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c11)
  function new(input string name="unnamed11-gpio_reg_model_c11");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c11

`endif // GPIO_RDB_SV11
