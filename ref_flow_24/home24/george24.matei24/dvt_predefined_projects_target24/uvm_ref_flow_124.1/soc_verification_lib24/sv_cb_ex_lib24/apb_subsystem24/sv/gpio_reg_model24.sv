`ifndef GPIO_RDB_SV24
`define GPIO_RDB_SV24

// Input24 File24: gpio_rgm24.spirit24

// Number24 of addrMaps24 = 1
// Number24 of regFiles24 = 1
// Number24 of registers = 5
// Number24 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 23


class bypass_mode_c24 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c24, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c24, uvm_reg)
  `uvm_object_utils(bypass_mode_c24)
  function new(input string name="unnamed24-bypass_mode_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : bypass_mode_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 38


class direction_mode_c24 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(direction_mode_c24, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c24, uvm_reg)
  `uvm_object_utils(direction_mode_c24)
  function new(input string name="unnamed24-direction_mode_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : direction_mode_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 53


class output_enable_c24 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(output_enable_c24, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c24, uvm_reg)
  `uvm_object_utils(output_enable_c24)
  function new(input string name="unnamed24-output_enable_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : output_enable_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 68


class output_value_c24 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(output_value_c24, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c24, uvm_reg)
  `uvm_object_utils(output_value_c24)
  function new(input string name="unnamed24-output_value_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : output_value_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 83


class input_value_c24 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(input_value_c24, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c24, uvm_reg)
  `uvm_object_utils(input_value_c24)
  function new(input string name="unnamed24-input_value_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : input_value_c24

class gpio_regfile24 extends uvm_reg_block;

  rand bypass_mode_c24 bypass_mode24;
  rand direction_mode_c24 direction_mode24;
  rand output_enable_c24 output_enable24;
  rand output_value_c24 output_value24;
  rand input_value_c24 input_value24;

  virtual function void build();

    // Now24 create all registers

    bypass_mode24 = bypass_mode_c24::type_id::create("bypass_mode24", , get_full_name());
    direction_mode24 = direction_mode_c24::type_id::create("direction_mode24", , get_full_name());
    output_enable24 = output_enable_c24::type_id::create("output_enable24", , get_full_name());
    output_value24 = output_value_c24::type_id::create("output_value24", , get_full_name());
    input_value24 = input_value_c24::type_id::create("input_value24", , get_full_name());

    // Now24 build the registers. Set parent and hdl_paths

    bypass_mode24.configure(this, null, "bypass_mode_reg24");
    bypass_mode24.build();
    direction_mode24.configure(this, null, "direction_mode_reg24");
    direction_mode24.build();
    output_enable24.configure(this, null, "output_enable_reg24");
    output_enable24.build();
    output_value24.configure(this, null, "output_value_reg24");
    output_value24.build();
    input_value24.configure(this, null, "input_value_reg24");
    input_value24.build();
    // Now24 define address mappings24
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode24, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode24, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable24, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value24, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value24, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile24)
  function new(input string name="unnamed24-gpio_rf24");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile24

//////////////////////////////////////////////////////////////////////////////
// Address_map24 definition24
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c24 extends uvm_reg_block;

  rand gpio_regfile24 gpio_rf24;

  function void build();
    // Now24 define address mappings24
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf24 = gpio_regfile24::type_id::create("gpio_rf24", , get_full_name());
    gpio_rf24.configure(this, "rf324");
    gpio_rf24.build();
    gpio_rf24.lock_model();
    default_map.add_submap(gpio_rf24.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c24");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c24)
  function new(input string name="unnamed24-gpio_reg_model_c24");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c24

`endif // GPIO_RDB_SV24
