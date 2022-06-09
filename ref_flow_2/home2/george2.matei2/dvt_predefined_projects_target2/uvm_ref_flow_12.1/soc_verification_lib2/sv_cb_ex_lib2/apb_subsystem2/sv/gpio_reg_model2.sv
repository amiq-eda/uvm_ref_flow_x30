`ifndef GPIO_RDB_SV2
`define GPIO_RDB_SV2

// Input2 File2: gpio_rgm2.spirit2

// Number2 of addrMaps2 = 1
// Number2 of regFiles2 = 1
// Number2 of registers = 5
// Number2 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 23


class bypass_mode_c2 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c2, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c2, uvm_reg)
  `uvm_object_utils(bypass_mode_c2)
  function new(input string name="unnamed2-bypass_mode_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : bypass_mode_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 38


class direction_mode_c2 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(direction_mode_c2, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c2, uvm_reg)
  `uvm_object_utils(direction_mode_c2)
  function new(input string name="unnamed2-direction_mode_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : direction_mode_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 53


class output_enable_c2 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(output_enable_c2, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c2, uvm_reg)
  `uvm_object_utils(output_enable_c2)
  function new(input string name="unnamed2-output_enable_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : output_enable_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 68


class output_value_c2 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(output_value_c2, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c2, uvm_reg)
  `uvm_object_utils(output_value_c2)
  function new(input string name="unnamed2-output_value_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : output_value_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 83


class input_value_c2 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(input_value_c2, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c2, uvm_reg)
  `uvm_object_utils(input_value_c2)
  function new(input string name="unnamed2-input_value_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : input_value_c2

class gpio_regfile2 extends uvm_reg_block;

  rand bypass_mode_c2 bypass_mode2;
  rand direction_mode_c2 direction_mode2;
  rand output_enable_c2 output_enable2;
  rand output_value_c2 output_value2;
  rand input_value_c2 input_value2;

  virtual function void build();

    // Now2 create all registers

    bypass_mode2 = bypass_mode_c2::type_id::create("bypass_mode2", , get_full_name());
    direction_mode2 = direction_mode_c2::type_id::create("direction_mode2", , get_full_name());
    output_enable2 = output_enable_c2::type_id::create("output_enable2", , get_full_name());
    output_value2 = output_value_c2::type_id::create("output_value2", , get_full_name());
    input_value2 = input_value_c2::type_id::create("input_value2", , get_full_name());

    // Now2 build the registers. Set parent and hdl_paths

    bypass_mode2.configure(this, null, "bypass_mode_reg2");
    bypass_mode2.build();
    direction_mode2.configure(this, null, "direction_mode_reg2");
    direction_mode2.build();
    output_enable2.configure(this, null, "output_enable_reg2");
    output_enable2.build();
    output_value2.configure(this, null, "output_value_reg2");
    output_value2.build();
    input_value2.configure(this, null, "input_value_reg2");
    input_value2.build();
    // Now2 define address mappings2
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode2, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode2, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable2, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value2, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value2, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile2)
  function new(input string name="unnamed2-gpio_rf2");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile2

//////////////////////////////////////////////////////////////////////////////
// Address_map2 definition2
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c2 extends uvm_reg_block;

  rand gpio_regfile2 gpio_rf2;

  function void build();
    // Now2 define address mappings2
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf2 = gpio_regfile2::type_id::create("gpio_rf2", , get_full_name());
    gpio_rf2.configure(this, "rf32");
    gpio_rf2.build();
    gpio_rf2.lock_model();
    default_map.add_submap(gpio_rf2.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c2");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c2)
  function new(input string name="unnamed2-gpio_reg_model_c2");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c2

`endif // GPIO_RDB_SV2
