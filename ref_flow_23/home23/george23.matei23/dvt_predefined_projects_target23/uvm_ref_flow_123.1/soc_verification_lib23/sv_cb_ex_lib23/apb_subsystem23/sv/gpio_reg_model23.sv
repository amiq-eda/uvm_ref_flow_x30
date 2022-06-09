`ifndef GPIO_RDB_SV23
`define GPIO_RDB_SV23

// Input23 File23: gpio_rgm23.spirit23

// Number23 of addrMaps23 = 1
// Number23 of regFiles23 = 1
// Number23 of registers = 5
// Number23 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 23


class bypass_mode_c23 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(bypass_mode_c23, uvm_reg_cbs) 
  `uvm_set_super_type(bypass_mode_c23, uvm_reg)
  `uvm_object_utils(bypass_mode_c23)
  function new(input string name="unnamed23-bypass_mode_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : bypass_mode_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 38


class direction_mode_c23 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(direction_mode_c23, uvm_reg_cbs) 
  `uvm_set_super_type(direction_mode_c23, uvm_reg)
  `uvm_object_utils(direction_mode_c23)
  function new(input string name="unnamed23-direction_mode_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : direction_mode_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 53


class output_enable_c23 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(output_enable_c23, uvm_reg_cbs) 
  `uvm_set_super_type(output_enable_c23, uvm_reg)
  `uvm_object_utils(output_enable_c23)
  function new(input string name="unnamed23-output_enable_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : output_enable_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 68


class output_value_c23 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(output_value_c23, uvm_reg_cbs) 
  `uvm_set_super_type(output_value_c23, uvm_reg)
  `uvm_object_utils(output_value_c23)
  function new(input string name="unnamed23-output_value_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : output_value_c23

//////////////////////////////////////////////////////////////////////////////
// Register definition23
//////////////////////////////////////////////////////////////////////////////
// Line23 Number23: 83


class input_value_c23 extends uvm_reg;

  rand uvm_reg_field data;

  virtual function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg23;
    option.per_instance=1;
    coverpoint data.value[31:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg23.sample();
  endfunction

  `uvm_register_cb(input_value_c23, uvm_reg_cbs) 
  `uvm_set_super_type(input_value_c23, uvm_reg)
  `uvm_object_utils(input_value_c23)
  function new(input string name="unnamed23-input_value_c23");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg23=new;
  endfunction : new
endclass : input_value_c23

class gpio_regfile23 extends uvm_reg_block;

  rand bypass_mode_c23 bypass_mode23;
  rand direction_mode_c23 direction_mode23;
  rand output_enable_c23 output_enable23;
  rand output_value_c23 output_value23;
  rand input_value_c23 input_value23;

  virtual function void build();

    // Now23 create all registers

    bypass_mode23 = bypass_mode_c23::type_id::create("bypass_mode23", , get_full_name());
    direction_mode23 = direction_mode_c23::type_id::create("direction_mode23", , get_full_name());
    output_enable23 = output_enable_c23::type_id::create("output_enable23", , get_full_name());
    output_value23 = output_value_c23::type_id::create("output_value23", , get_full_name());
    input_value23 = input_value_c23::type_id::create("input_value23", , get_full_name());

    // Now23 build the registers. Set parent and hdl_paths

    bypass_mode23.configure(this, null, "bypass_mode_reg23");
    bypass_mode23.build();
    direction_mode23.configure(this, null, "direction_mode_reg23");
    direction_mode23.build();
    output_enable23.configure(this, null, "output_enable_reg23");
    output_enable23.build();
    output_value23.configure(this, null, "output_value_reg23");
    output_value23.build();
    input_value23.configure(this, null, "input_value_reg23");
    input_value23.build();
    // Now23 define address mappings23
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(bypass_mode23, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(direction_mode23, `UVM_REG_ADDR_WIDTH'h4, "RW");
    default_map.add_reg(output_enable23, `UVM_REG_ADDR_WIDTH'h8, "RW");
    default_map.add_reg(output_value23, `UVM_REG_ADDR_WIDTH'hc, "RW");
    default_map.add_reg(input_value23, `UVM_REG_ADDR_WIDTH'h10, "RO");
  endfunction

  `uvm_object_utils(gpio_regfile23)
  function new(input string name="unnamed23-gpio_rf23");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : gpio_regfile23

//////////////////////////////////////////////////////////////////////////////
// Address_map23 definition23
//////////////////////////////////////////////////////////////////////////////
class gpio_reg_model_c23 extends uvm_reg_block;

  rand gpio_regfile23 gpio_rf23;

  function void build();
    // Now23 define address mappings23
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    gpio_rf23 = gpio_regfile23::type_id::create("gpio_rf23", , get_full_name());
    gpio_rf23.configure(this, "rf323");
    gpio_rf23.build();
    gpio_rf23.lock_model();
    default_map.add_submap(gpio_rf23.default_map, `UVM_REG_ADDR_WIDTH'h820000);
    set_hdl_path_root("apb_gpio_addr_map_c23");
    this.lock_model();
  endfunction
  `uvm_object_utils(gpio_reg_model_c23)
  function new(input string name="unnamed23-gpio_reg_model_c23");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : gpio_reg_model_c23

`endif // GPIO_RDB_SV23
