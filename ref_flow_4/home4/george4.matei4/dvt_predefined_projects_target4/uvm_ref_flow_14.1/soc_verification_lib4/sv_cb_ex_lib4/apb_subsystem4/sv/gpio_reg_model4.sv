`ifndef GPIO_RDB_SV4
`define GPIO_RDB_SV4

// Input4 File4: gpio_rgm4.spirit4

// Number4 of addrMaps4 = 1
// Number4 of regFiles4 = 1
// Number4 of registers = 5
// Number4 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 23


class bypass_mode_c4 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c4, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c4, uvm_reg)
  `uvm_object_utils(bypass_mode_c4)
  function new(input string name="unnamed4-bypass_mode_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : bypass_mode_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 38


class direction_mode_c4 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(direction_mode_c4, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c4, uvm_reg)
  `uvm_object_utils(direction_mode_c4)
  function new(input string name="unnamed4-direction_mode_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : direction_mode_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 53


class output_enable_c4 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(output_enable_c4, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c4, uvm_reg)
  `uvm_object_utils(output_enable_c4)
  function new(input string name="unnamed4-output_enable_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : output_enable_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 68


class output_value_c4 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(output_value_c4, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c4, uvm_reg)
  `uvm_object_utils(output_value_c4)
  function new(input string name="unnamed4-output_value_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : output_value_c4

//////////////////////////////////////////////////////////////////////////////
// Register definition4
//////////////////////////////////////////////////////////////////////////////
// Line4 Number4: 83


class input_value_c4 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg4;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg4.sample();
  endfunction

  `uvm_register_cb(input_value_c4, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c4, uvm_reg)
  `uvm_object_utils(input_value_c4)
  function new(input string name="unnamed4-input_value_c4");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg4=new;
  endfunction : new
endclass : input_value_c4

class gpio_regfile4 extends uvm_reg_block;

  rand bypass_mode_c4 bypass_mode4;
  rand direction_mode_c4 direction_mode4;
  rand output_enable_c4 output_enable4;
  rand output_value_c4 output_value4;
  rand input_value_c4 input_value4;

  virtual function void build();

    // Now4 create all registers

    bypass_mode4 = bypass_mode_c4::type_id::create("bypass_mode4", , get_full_name());
    direction_mode4 = direction_mode_c4::type_id::create("direction_mode4", , get_full_name());
    output_enable4 = output_enable_c4::type_id::create("output_enable4", , get_full_name());
    output_value4 = output_value_c4::type_id::create("output_value4", , get_full_name());
    input_value4 = input_value_c4::type_id::create("input_value4", , get_full_name());

    // Now4 build the registers. Set parent and hdl_paths

    bypass_mode4.configure(this, null, "bypass_mode_reg4");
    bypass_mode4.build();
    direction_mode4.configure(this, null, "direction_mode_reg4");
    direction_mode4.build();
    output_enable4.configure(this, null, "output_enable_reg4");
    output_enable4.build();
    output_value4.configure(this, null, "output_value_reg4");
    output_value4.build();
    input_value4.configure(this, null, "input_value_reg4");
    input_value4.build();
    // Now4 define address mappings4
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode4, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode4, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable4, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value4, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value4, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile4)
  function new(input string name="unnamed4-gpio_rf4");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile4

//////////////////////////////////////////////////////////////////////////////
// Address_map4 definition4
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c4 extends uvm_reg_block;

  rand gpio_regfile4 gpio_rf4;

  function void build();
    // Now4 define address mappings4
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf4 = gpio_regfile4::type_id::create("gpio_rf4", , get_full_name());
    gpio_rf4.configure(this, "rf34");
    gpio_rf4.build();
    gpio_rf4.lock_model();
    default_map.add_submap(gpio_rf4.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c4");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c4)
  function new(input string name="unnamed4-gpio_reg_model_c4");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c4

`endif // GPIO_RDB_SV4
