`ifndef GPIO_RDB_SV6
`define GPIO_RDB_SV6

// Input6 File6: gpio_rgm6.spirit6

// Number6 of addrMaps6 = 1
// Number6 of regFiles6 = 1
// Number6 of registers = 5
// Number6 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 23


class bypass_mode_c6 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c6, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c6, uvm_reg)
  `uvm_object_utils(bypass_mode_c6)
  function new(input string name="unnamed6-bypass_mode_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : bypass_mode_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 38


class direction_mode_c6 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(direction_mode_c6, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c6, uvm_reg)
  `uvm_object_utils(direction_mode_c6)
  function new(input string name="unnamed6-direction_mode_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : direction_mode_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 53


class output_enable_c6 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(output_enable_c6, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c6, uvm_reg)
  `uvm_object_utils(output_enable_c6)
  function new(input string name="unnamed6-output_enable_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : output_enable_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 68


class output_value_c6 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(output_value_c6, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c6, uvm_reg)
  `uvm_object_utils(output_value_c6)
  function new(input string name="unnamed6-output_value_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : output_value_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 83


class input_value_c6 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(input_value_c6, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c6, uvm_reg)
  `uvm_object_utils(input_value_c6)
  function new(input string name="unnamed6-input_value_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : input_value_c6

class gpio_regfile6 extends uvm_reg_block;

  rand bypass_mode_c6 bypass_mode6;
  rand direction_mode_c6 direction_mode6;
  rand output_enable_c6 output_enable6;
  rand output_value_c6 output_value6;
  rand input_value_c6 input_value6;

  virtual function void build();

    // Now6 create all registers

    bypass_mode6 = bypass_mode_c6::type_id::create("bypass_mode6", , get_full_name());
    direction_mode6 = direction_mode_c6::type_id::create("direction_mode6", , get_full_name());
    output_enable6 = output_enable_c6::type_id::create("output_enable6", , get_full_name());
    output_value6 = output_value_c6::type_id::create("output_value6", , get_full_name());
    input_value6 = input_value_c6::type_id::create("input_value6", , get_full_name());

    // Now6 build the registers. Set parent and hdl_paths

    bypass_mode6.configure(this, null, "bypass_mode_reg6");
    bypass_mode6.build();
    direction_mode6.configure(this, null, "direction_mode_reg6");
    direction_mode6.build();
    output_enable6.configure(this, null, "output_enable_reg6");
    output_enable6.build();
    output_value6.configure(this, null, "output_value_reg6");
    output_value6.build();
    input_value6.configure(this, null, "input_value_reg6");
    input_value6.build();
    // Now6 define address mappings6
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode6, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode6, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable6, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value6, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value6, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile6)
  function new(input string name="unnamed6-gpio_rf6");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile6

//////////////////////////////////////////////////////////////////////////////
// Address_map6 definition6
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c6 extends uvm_reg_block;

  rand gpio_regfile6 gpio_rf6;

  function void build();
    // Now6 define address mappings6
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf6 = gpio_regfile6::type_id::create("gpio_rf6", , get_full_name());
    gpio_rf6.configure(this, "rf36");
    gpio_rf6.build();
    gpio_rf6.lock_model();
    default_map.add_submap(gpio_rf6.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c6");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c6)
  function new(input string name="unnamed6-gpio_reg_model_c6");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c6

`endif // GPIO_RDB_SV6
