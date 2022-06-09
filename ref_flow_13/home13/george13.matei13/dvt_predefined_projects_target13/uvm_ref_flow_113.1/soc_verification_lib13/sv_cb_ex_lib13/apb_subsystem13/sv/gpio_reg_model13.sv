`ifndef GPIO_RDB_SV13
`define GPIO_RDB_SV13

// Input13 File13: gpio_rgm13.spirit13

// Number13 of addrMaps13 = 1
// Number13 of regFiles13 = 1
// Number13 of registers = 5
// Number13 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 23


class bypass_mode_c13 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c13, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c13, uvm_reg)
  `uvm_object_utils(bypass_mode_c13)
  function new(input string name="unnamed13-bypass_mode_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : bypass_mode_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 38


class direction_mode_c13 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(direction_mode_c13, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c13, uvm_reg)
  `uvm_object_utils(direction_mode_c13)
  function new(input string name="unnamed13-direction_mode_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : direction_mode_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 53


class output_enable_c13 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(output_enable_c13, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c13, uvm_reg)
  `uvm_object_utils(output_enable_c13)
  function new(input string name="unnamed13-output_enable_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : output_enable_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 68


class output_value_c13 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(output_value_c13, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c13, uvm_reg)
  `uvm_object_utils(output_value_c13)
  function new(input string name="unnamed13-output_value_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : output_value_c13

//////////////////////////////////////////////////////////////////////////////
// Register definition13
//////////////////////////////////////////////////////////////////////////////
// Line13 Number13: 83


class input_value_c13 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg13;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg13.sample();
  endfunction

  `uvm_register_cb(input_value_c13, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c13, uvm_reg)
  `uvm_object_utils(input_value_c13)
  function new(input string name="unnamed13-input_value_c13");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg13=new;
  endfunction : new
endclass : input_value_c13

class gpio_regfile13 extends uvm_reg_block;

  rand bypass_mode_c13 bypass_mode13;
  rand direction_mode_c13 direction_mode13;
  rand output_enable_c13 output_enable13;
  rand output_value_c13 output_value13;
  rand input_value_c13 input_value13;

  virtual function void build();

    // Now13 create all registers

    bypass_mode13 = bypass_mode_c13::type_id::create("bypass_mode13", , get_full_name());
    direction_mode13 = direction_mode_c13::type_id::create("direction_mode13", , get_full_name());
    output_enable13 = output_enable_c13::type_id::create("output_enable13", , get_full_name());
    output_value13 = output_value_c13::type_id::create("output_value13", , get_full_name());
    input_value13 = input_value_c13::type_id::create("input_value13", , get_full_name());

    // Now13 build the registers. Set parent and hdl_paths

    bypass_mode13.configure(this, null, "bypass_mode_reg13");
    bypass_mode13.build();
    direction_mode13.configure(this, null, "direction_mode_reg13");
    direction_mode13.build();
    output_enable13.configure(this, null, "output_enable_reg13");
    output_enable13.build();
    output_value13.configure(this, null, "output_value_reg13");
    output_value13.build();
    input_value13.configure(this, null, "input_value_reg13");
    input_value13.build();
    // Now13 define address mappings13
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode13, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode13, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable13, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value13, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value13, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile13)
  function new(input string name="unnamed13-gpio_rf13");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile13

//////////////////////////////////////////////////////////////////////////////
// Address_map13 definition13
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c13 extends uvm_reg_block;

  rand gpio_regfile13 gpio_rf13;

  function void build();
    // Now13 define address mappings13
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf13 = gpio_regfile13::type_id::create("gpio_rf13", , get_full_name());
    gpio_rf13.configure(this, "rf313");
    gpio_rf13.build();
    gpio_rf13.lock_model();
    default_map.add_submap(gpio_rf13.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c13");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c13)
  function new(input string name="unnamed13-gpio_reg_model_c13");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c13

`endif // GPIO_RDB_SV13
