`ifndef GPIO_RDB_SV27
`define GPIO_RDB_SV27

// Input27 File27: gpio_rgm27.spirit27

// Number27 of addrMaps27 = 1
// Number27 of regFiles27 = 1
// Number27 of registers = 5
// Number27 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 23


class bypass_mode_c27 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c27, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c27, uvm_reg)
  `uvm_object_utils(bypass_mode_c27)
  function new(input string name="unnamed27-bypass_mode_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : bypass_mode_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 38


class direction_mode_c27 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(direction_mode_c27, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c27, uvm_reg)
  `uvm_object_utils(direction_mode_c27)
  function new(input string name="unnamed27-direction_mode_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : direction_mode_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 53


class output_enable_c27 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(output_enable_c27, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c27, uvm_reg)
  `uvm_object_utils(output_enable_c27)
  function new(input string name="unnamed27-output_enable_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : output_enable_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 68


class output_value_c27 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(output_value_c27, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c27, uvm_reg)
  `uvm_object_utils(output_value_c27)
  function new(input string name="unnamed27-output_value_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : output_value_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 83


class input_value_c27 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(input_value_c27, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c27, uvm_reg)
  `uvm_object_utils(input_value_c27)
  function new(input string name="unnamed27-input_value_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : input_value_c27

class gpio_regfile27 extends uvm_reg_block;

  rand bypass_mode_c27 bypass_mode27;
  rand direction_mode_c27 direction_mode27;
  rand output_enable_c27 output_enable27;
  rand output_value_c27 output_value27;
  rand input_value_c27 input_value27;

  virtual function void build();

    // Now27 create all registers

    bypass_mode27 = bypass_mode_c27::type_id::create("bypass_mode27", , get_full_name());
    direction_mode27 = direction_mode_c27::type_id::create("direction_mode27", , get_full_name());
    output_enable27 = output_enable_c27::type_id::create("output_enable27", , get_full_name());
    output_value27 = output_value_c27::type_id::create("output_value27", , get_full_name());
    input_value27 = input_value_c27::type_id::create("input_value27", , get_full_name());

    // Now27 build the registers. Set parent and hdl_paths

    bypass_mode27.configure(this, null, "bypass_mode_reg27");
    bypass_mode27.build();
    direction_mode27.configure(this, null, "direction_mode_reg27");
    direction_mode27.build();
    output_enable27.configure(this, null, "output_enable_reg27");
    output_enable27.build();
    output_value27.configure(this, null, "output_value_reg27");
    output_value27.build();
    input_value27.configure(this, null, "input_value_reg27");
    input_value27.build();
    // Now27 define address mappings27
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode27, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode27, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable27, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value27, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value27, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile27)
  function new(input string name="unnamed27-gpio_rf27");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile27

//////////////////////////////////////////////////////////////////////////////
// Address_map27 definition27
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c27 extends uvm_reg_block;

  rand gpio_regfile27 gpio_rf27;

  function void build();
    // Now27 define address mappings27
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf27 = gpio_regfile27::type_id::create("gpio_rf27", , get_full_name());
    gpio_rf27.configure(this, "rf327");
    gpio_rf27.build();
    gpio_rf27.lock_model();
    default_map.add_submap(gpio_rf27.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c27");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c27)
  function new(input string name="unnamed27-gpio_reg_model_c27");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c27

`endif // GPIO_RDB_SV27
