`ifndef GPIO_RDB_SV28
`define GPIO_RDB_SV28

// Input28 File28: gpio_rgm28.spirit28

// Number28 of addrMaps28 = 1
// Number28 of regFiles28 = 1
// Number28 of registers = 5
// Number28 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 23


class bypass_mode_c28 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c28, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c28, uvm_reg)
  `uvm_object_utils(bypass_mode_c28)
  function new(input string name="unnamed28-bypass_mode_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : bypass_mode_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 38


class direction_mode_c28 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(direction_mode_c28, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c28, uvm_reg)
  `uvm_object_utils(direction_mode_c28)
  function new(input string name="unnamed28-direction_mode_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : direction_mode_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 53


class output_enable_c28 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(output_enable_c28, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c28, uvm_reg)
  `uvm_object_utils(output_enable_c28)
  function new(input string name="unnamed28-output_enable_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : output_enable_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 68


class output_value_c28 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(output_value_c28, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c28, uvm_reg)
  `uvm_object_utils(output_value_c28)
  function new(input string name="unnamed28-output_value_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : output_value_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 83


class input_value_c28 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(input_value_c28, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c28, uvm_reg)
  `uvm_object_utils(input_value_c28)
  function new(input string name="unnamed28-input_value_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : input_value_c28

class gpio_regfile28 extends uvm_reg_block;

  rand bypass_mode_c28 bypass_mode28;
  rand direction_mode_c28 direction_mode28;
  rand output_enable_c28 output_enable28;
  rand output_value_c28 output_value28;
  rand input_value_c28 input_value28;

  virtual function void build();

    // Now28 create all registers

    bypass_mode28 = bypass_mode_c28::type_id::create("bypass_mode28", , get_full_name());
    direction_mode28 = direction_mode_c28::type_id::create("direction_mode28", , get_full_name());
    output_enable28 = output_enable_c28::type_id::create("output_enable28", , get_full_name());
    output_value28 = output_value_c28::type_id::create("output_value28", , get_full_name());
    input_value28 = input_value_c28::type_id::create("input_value28", , get_full_name());

    // Now28 build the registers. Set parent and hdl_paths

    bypass_mode28.configure(this, null, "bypass_mode_reg28");
    bypass_mode28.build();
    direction_mode28.configure(this, null, "direction_mode_reg28");
    direction_mode28.build();
    output_enable28.configure(this, null, "output_enable_reg28");
    output_enable28.build();
    output_value28.configure(this, null, "output_value_reg28");
    output_value28.build();
    input_value28.configure(this, null, "input_value_reg28");
    input_value28.build();
    // Now28 define address mappings28
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode28, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode28, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable28, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value28, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value28, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile28)
  function new(input string name="unnamed28-gpio_rf28");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile28

//////////////////////////////////////////////////////////////////////////////
// Address_map28 definition28
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c28 extends uvm_reg_block;

  rand gpio_regfile28 gpio_rf28;

  function void build();
    // Now28 define address mappings28
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf28 = gpio_regfile28::type_id::create("gpio_rf28", , get_full_name());
    gpio_rf28.configure(this, "rf328");
    gpio_rf28.build();
    gpio_rf28.lock_model();
    default_map.add_submap(gpio_rf28.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c28");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c28)
  function new(input string name="unnamed28-gpio_reg_model_c28");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c28

`endif // GPIO_RDB_SV28
