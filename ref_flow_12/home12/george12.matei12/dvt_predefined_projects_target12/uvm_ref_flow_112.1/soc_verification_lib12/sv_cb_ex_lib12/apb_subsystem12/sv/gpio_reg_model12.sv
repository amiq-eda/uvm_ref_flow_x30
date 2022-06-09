`ifndef GPIO_RDB_SV12
`define GPIO_RDB_SV12

// Input12 File12: gpio_rgm12.spirit12

// Number12 of addrMaps12 = 1
// Number12 of regFiles12 = 1
// Number12 of registers = 5
// Number12 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 23


class bypass_mode_c12 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c12, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c12, uvm_reg)
  `uvm_object_utils(bypass_mode_c12)
  function new(input string name="unnamed12-bypass_mode_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : bypass_mode_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 38


class direction_mode_c12 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(direction_mode_c12, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c12, uvm_reg)
  `uvm_object_utils(direction_mode_c12)
  function new(input string name="unnamed12-direction_mode_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : direction_mode_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 53


class output_enable_c12 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(output_enable_c12, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c12, uvm_reg)
  `uvm_object_utils(output_enable_c12)
  function new(input string name="unnamed12-output_enable_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : output_enable_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 68


class output_value_c12 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(output_value_c12, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c12, uvm_reg)
  `uvm_object_utils(output_value_c12)
  function new(input string name="unnamed12-output_value_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : output_value_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 83


class input_value_c12 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(input_value_c12, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c12, uvm_reg)
  `uvm_object_utils(input_value_c12)
  function new(input string name="unnamed12-input_value_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : input_value_c12

class gpio_regfile12 extends uvm_reg_block;

  rand bypass_mode_c12 bypass_mode12;
  rand direction_mode_c12 direction_mode12;
  rand output_enable_c12 output_enable12;
  rand output_value_c12 output_value12;
  rand input_value_c12 input_value12;

  virtual function void build();

    // Now12 create all registers

    bypass_mode12 = bypass_mode_c12::type_id::create("bypass_mode12", , get_full_name());
    direction_mode12 = direction_mode_c12::type_id::create("direction_mode12", , get_full_name());
    output_enable12 = output_enable_c12::type_id::create("output_enable12", , get_full_name());
    output_value12 = output_value_c12::type_id::create("output_value12", , get_full_name());
    input_value12 = input_value_c12::type_id::create("input_value12", , get_full_name());

    // Now12 build the registers. Set parent and hdl_paths

    bypass_mode12.configure(this, null, "bypass_mode_reg12");
    bypass_mode12.build();
    direction_mode12.configure(this, null, "direction_mode_reg12");
    direction_mode12.build();
    output_enable12.configure(this, null, "output_enable_reg12");
    output_enable12.build();
    output_value12.configure(this, null, "output_value_reg12");
    output_value12.build();
    input_value12.configure(this, null, "input_value_reg12");
    input_value12.build();
    // Now12 define address mappings12
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode12, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode12, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable12, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value12, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value12, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile12)
  function new(input string name="unnamed12-gpio_rf12");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile12

//////////////////////////////////////////////////////////////////////////////
// Address_map12 definition12
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c12 extends uvm_reg_block;

  rand gpio_regfile12 gpio_rf12;

  function void build();
    // Now12 define address mappings12
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf12 = gpio_regfile12::type_id::create("gpio_rf12", , get_full_name());
    gpio_rf12.configure(this, "rf312");
    gpio_rf12.build();
    gpio_rf12.lock_model();
    default_map.add_submap(gpio_rf12.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c12");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c12)
  function new(input string name="unnamed12-gpio_reg_model_c12");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c12

`endif // GPIO_RDB_SV12
