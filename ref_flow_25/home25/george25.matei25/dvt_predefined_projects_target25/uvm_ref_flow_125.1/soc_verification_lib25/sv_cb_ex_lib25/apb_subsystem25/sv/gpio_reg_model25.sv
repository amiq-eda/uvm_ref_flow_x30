`ifndef GPIO_RDB_SV25
`define GPIO_RDB_SV25

// Input25 File25: gpio_rgm25.spirit25

// Number25 of addrMaps25 = 1
// Number25 of regFiles25 = 1
// Number25 of registers = 5
// Number25 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 23


class bypass_mode_c25 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c25, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c25, uvm_reg)
  `uvm_object_utils(bypass_mode_c25)
  function new(input string name="unnamed25-bypass_mode_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : bypass_mode_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 38


class direction_mode_c25 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(direction_mode_c25, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c25, uvm_reg)
  `uvm_object_utils(direction_mode_c25)
  function new(input string name="unnamed25-direction_mode_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : direction_mode_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 53


class output_enable_c25 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(output_enable_c25, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c25, uvm_reg)
  `uvm_object_utils(output_enable_c25)
  function new(input string name="unnamed25-output_enable_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : output_enable_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 68


class output_value_c25 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(output_value_c25, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c25, uvm_reg)
  `uvm_object_utils(output_value_c25)
  function new(input string name="unnamed25-output_value_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : output_value_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 83


class input_value_c25 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg25;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg25.sample();
  endfunction

  `uvm_register_cb(input_value_c25, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c25, uvm_reg)
  `uvm_object_utils(input_value_c25)
  function new(input string name="unnamed25-input_value_c25");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg25=new;
  endfunction : new
endclass : input_value_c25

class gpio_regfile25 extends uvm_reg_block;

  rand bypass_mode_c25 bypass_mode25;
  rand direction_mode_c25 direction_mode25;
  rand output_enable_c25 output_enable25;
  rand output_value_c25 output_value25;
  rand input_value_c25 input_value25;

  virtual function void build();

    // Now25 create all registers

    bypass_mode25 = bypass_mode_c25::type_id::create("bypass_mode25", , get_full_name());
    direction_mode25 = direction_mode_c25::type_id::create("direction_mode25", , get_full_name());
    output_enable25 = output_enable_c25::type_id::create("output_enable25", , get_full_name());
    output_value25 = output_value_c25::type_id::create("output_value25", , get_full_name());
    input_value25 = input_value_c25::type_id::create("input_value25", , get_full_name());

    // Now25 build the registers. Set parent and hdl_paths

    bypass_mode25.configure(this, null, "bypass_mode_reg25");
    bypass_mode25.build();
    direction_mode25.configure(this, null, "direction_mode_reg25");
    direction_mode25.build();
    output_enable25.configure(this, null, "output_enable_reg25");
    output_enable25.build();
    output_value25.configure(this, null, "output_value_reg25");
    output_value25.build();
    input_value25.configure(this, null, "input_value_reg25");
    input_value25.build();
    // Now25 define address mappings25
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode25, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode25, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable25, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value25, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value25, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile25)
  function new(input string name="unnamed25-gpio_rf25");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile25

//////////////////////////////////////////////////////////////////////////////
// Address_map25 definition25
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c25 extends uvm_reg_block;

  rand gpio_regfile25 gpio_rf25;

  function void build();
    // Now25 define address mappings25
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf25 = gpio_regfile25::type_id::create("gpio_rf25", , get_full_name());
    gpio_rf25.configure(this, "rf325");
    gpio_rf25.build();
    gpio_rf25.lock_model();
    default_map.add_submap(gpio_rf25.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c25");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c25)
  function new(input string name="unnamed25-gpio_reg_model_c25");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c25

`endif // GPIO_RDB_SV25
