`ifndef GPIO_RDB_SV20
`define GPIO_RDB_SV20

// Input20 File20: gpio_rgm20.spirit20

// Number20 of addrMaps20 = 1
// Number20 of regFiles20 = 1
// Number20 of registers = 5
// Number20 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 23


class bypass_mode_c20 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c20, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c20, uvm_reg)
  `uvm_object_utils(bypass_mode_c20)
  function new(input string name="unnamed20-bypass_mode_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : bypass_mode_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 38


class direction_mode_c20 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(direction_mode_c20, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c20, uvm_reg)
  `uvm_object_utils(direction_mode_c20)
  function new(input string name="unnamed20-direction_mode_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : direction_mode_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 53


class output_enable_c20 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(output_enable_c20, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c20, uvm_reg)
  `uvm_object_utils(output_enable_c20)
  function new(input string name="unnamed20-output_enable_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : output_enable_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 68


class output_value_c20 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(output_value_c20, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c20, uvm_reg)
  `uvm_object_utils(output_value_c20)
  function new(input string name="unnamed20-output_value_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : output_value_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 83


class input_value_c20 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(input_value_c20, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c20, uvm_reg)
  `uvm_object_utils(input_value_c20)
  function new(input string name="unnamed20-input_value_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : input_value_c20

class gpio_regfile20 extends uvm_reg_block;

  rand bypass_mode_c20 bypass_mode20;
  rand direction_mode_c20 direction_mode20;
  rand output_enable_c20 output_enable20;
  rand output_value_c20 output_value20;
  rand input_value_c20 input_value20;

  virtual function void build();

    // Now20 create all registers

    bypass_mode20 = bypass_mode_c20::type_id::create("bypass_mode20", , get_full_name());
    direction_mode20 = direction_mode_c20::type_id::create("direction_mode20", , get_full_name());
    output_enable20 = output_enable_c20::type_id::create("output_enable20", , get_full_name());
    output_value20 = output_value_c20::type_id::create("output_value20", , get_full_name());
    input_value20 = input_value_c20::type_id::create("input_value20", , get_full_name());

    // Now20 build the registers. Set parent and hdl_paths

    bypass_mode20.configure(this, null, "bypass_mode_reg20");
    bypass_mode20.build();
    direction_mode20.configure(this, null, "direction_mode_reg20");
    direction_mode20.build();
    output_enable20.configure(this, null, "output_enable_reg20");
    output_enable20.build();
    output_value20.configure(this, null, "output_value_reg20");
    output_value20.build();
    input_value20.configure(this, null, "input_value_reg20");
    input_value20.build();
    // Now20 define address mappings20
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode20, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode20, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable20, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value20, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value20, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile20)
  function new(input string name="unnamed20-gpio_rf20");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile20

//////////////////////////////////////////////////////////////////////////////
// Address_map20 definition20
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c20 extends uvm_reg_block;

  rand gpio_regfile20 gpio_rf20;

  function void build();
    // Now20 define address mappings20
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf20 = gpio_regfile20::type_id::create("gpio_rf20", , get_full_name());
    gpio_rf20.configure(this, "rf320");
    gpio_rf20.build();
    gpio_rf20.lock_model();
    default_map.add_submap(gpio_rf20.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c20");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c20)
  function new(input string name="unnamed20-gpio_reg_model_c20");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c20

`endif // GPIO_RDB_SV20
