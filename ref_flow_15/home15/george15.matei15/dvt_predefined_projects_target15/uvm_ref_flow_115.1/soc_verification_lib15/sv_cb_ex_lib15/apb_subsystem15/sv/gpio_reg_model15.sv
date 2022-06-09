`ifndef GPIO_RDB_SV15
`define GPIO_RDB_SV15

// Input15 File15: gpio_rgm15.spirit15

// Number15 of addrMaps15 = 1
// Number15 of regFiles15 = 1
// Number15 of registers = 5
// Number15 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 23


class bypass_mode_c15 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c15, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c15, uvm_reg)
  `uvm_object_utils(bypass_mode_c15)
  function new(input string name="unnamed15-bypass_mode_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : bypass_mode_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 38


class direction_mode_c15 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(direction_mode_c15, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c15, uvm_reg)
  `uvm_object_utils(direction_mode_c15)
  function new(input string name="unnamed15-direction_mode_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : direction_mode_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 53


class output_enable_c15 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(output_enable_c15, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c15, uvm_reg)
  `uvm_object_utils(output_enable_c15)
  function new(input string name="unnamed15-output_enable_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : output_enable_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 68


class output_value_c15 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(output_value_c15, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c15, uvm_reg)
  `uvm_object_utils(output_value_c15)
  function new(input string name="unnamed15-output_value_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : output_value_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 83


class input_value_c15 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(input_value_c15, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c15, uvm_reg)
  `uvm_object_utils(input_value_c15)
  function new(input string name="unnamed15-input_value_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : input_value_c15

class gpio_regfile15 extends uvm_reg_block;

  rand bypass_mode_c15 bypass_mode15;
  rand direction_mode_c15 direction_mode15;
  rand output_enable_c15 output_enable15;
  rand output_value_c15 output_value15;
  rand input_value_c15 input_value15;

  virtual function void build();

    // Now15 create all registers

    bypass_mode15 = bypass_mode_c15::type_id::create("bypass_mode15", , get_full_name());
    direction_mode15 = direction_mode_c15::type_id::create("direction_mode15", , get_full_name());
    output_enable15 = output_enable_c15::type_id::create("output_enable15", , get_full_name());
    output_value15 = output_value_c15::type_id::create("output_value15", , get_full_name());
    input_value15 = input_value_c15::type_id::create("input_value15", , get_full_name());

    // Now15 build the registers. Set parent and hdl_paths

    bypass_mode15.configure(this, null, "bypass_mode_reg15");
    bypass_mode15.build();
    direction_mode15.configure(this, null, "direction_mode_reg15");
    direction_mode15.build();
    output_enable15.configure(this, null, "output_enable_reg15");
    output_enable15.build();
    output_value15.configure(this, null, "output_value_reg15");
    output_value15.build();
    input_value15.configure(this, null, "input_value_reg15");
    input_value15.build();
    // Now15 define address mappings15
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode15, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode15, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable15, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value15, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value15, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile15)
  function new(input string name="unnamed15-gpio_rf15");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile15

//////////////////////////////////////////////////////////////////////////////
// Address_map15 definition15
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c15 extends uvm_reg_block;

  rand gpio_regfile15 gpio_rf15;

  function void build();
    // Now15 define address mappings15
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf15 = gpio_regfile15::type_id::create("gpio_rf15", , get_full_name());
    gpio_rf15.configure(this, "rf315");
    gpio_rf15.build();
    gpio_rf15.lock_model();
    default_map.add_submap(gpio_rf15.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c15");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c15)
  function new(input string name="unnamed15-gpio_reg_model_c15");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c15

`endif // GPIO_RDB_SV15
