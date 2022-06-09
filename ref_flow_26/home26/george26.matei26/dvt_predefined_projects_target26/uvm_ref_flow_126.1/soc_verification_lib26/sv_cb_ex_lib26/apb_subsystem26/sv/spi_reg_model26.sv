`ifndef SPI_RDB_SV26
`define SPI_RDB_SV26

// Input26 File26: spi_rgm26.spirit26

// Number26 of addrMaps26 = 1
// Number26 of regFiles26 = 1
// Number26 of registers = 3
// Number26 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 23


class spi_ctrl_c26 extends uvm_reg;

  rand uvm_reg_field char_len26;
  rand uvm_reg_field go_bsy26;
  rand uvm_reg_field rx_neg26;
  rand uvm_reg_field tx_neg26;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie26;
  rand uvm_reg_field ass26;

  constraint c_char_len26 { char_len26.value == 7'b0001000; }
  constraint c_tx_neg26 { tx_neg26.value == 1'b1; }
  constraint c_rx_neg26 { rx_neg26.value == 1'b1; }
  constraint c_lsb26 { lsb.value == 1'b1; }
  constraint c_ie26 { ie26.value == 1'b1; }
  constraint c_ass26 { ass26.value == 1'b1; }
  virtual function void build();
    char_len26 = uvm_reg_field::type_id::create("char_len26");
    char_len26.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy26 = uvm_reg_field::type_id::create("go_bsy26");
    go_bsy26.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg26 = uvm_reg_field::type_id::create("rx_neg26");
    rx_neg26.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg26 = uvm_reg_field::type_id::create("tx_neg26");
    tx_neg26.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie26 = uvm_reg_field::type_id::create("ie26");
    ie26.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass26 = uvm_reg_field::type_id::create("ass26");
    ass26.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint char_len26.value[6:0];
    coverpoint go_bsy26.value[0:0];
    coverpoint rx_neg26.value[0:0];
    coverpoint tx_neg26.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie26.value[0:0];
    coverpoint ass26.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c26, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c26, uvm_reg)
  `uvm_object_utils(spi_ctrl_c26)
  function new(input string name="unnamed26-spi_ctrl_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : spi_ctrl_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 99


class spi_divider_c26 extends uvm_reg;

  rand uvm_reg_field divider26;

  constraint c_divider26 { divider26.value == 16'b1; }
  virtual function void build();
    divider26 = uvm_reg_field::type_id::create("divider26");
    divider26.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint divider26.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(spi_divider_c26, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c26, uvm_reg)
  `uvm_object_utils(spi_divider_c26)
  function new(input string name="unnamed26-spi_divider_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : spi_divider_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 122


class spi_ss_c26 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss26 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg26;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg26.sample();
  endfunction

  `uvm_register_cb(spi_ss_c26, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c26, uvm_reg)
  `uvm_object_utils(spi_ss_c26)
  function new(input string name="unnamed26-spi_ss_c26");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg26=new;
  endfunction : new
endclass : spi_ss_c26

class spi_regfile26 extends uvm_reg_block;

  rand spi_ctrl_c26 spi_ctrl26;
  rand spi_divider_c26 spi_divider26;
  rand spi_ss_c26 spi_ss26;

  virtual function void build();

    // Now26 create all registers

    spi_ctrl26 = spi_ctrl_c26::type_id::create("spi_ctrl26", , get_full_name());
    spi_divider26 = spi_divider_c26::type_id::create("spi_divider26", , get_full_name());
    spi_ss26 = spi_ss_c26::type_id::create("spi_ss26", , get_full_name());

    // Now26 build the registers. Set parent and hdl_paths

    spi_ctrl26.configure(this, null, "spi_ctrl_reg26");
    spi_ctrl26.build();
    spi_divider26.configure(this, null, "spi_divider_reg26");
    spi_divider26.build();
    spi_ss26.configure(this, null, "spi_ss_reg26");
    spi_ss26.build();
    // Now26 define address mappings26
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl26, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider26, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss26, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile26)
  function new(input string name="unnamed26-spi_rf26");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile26

//////////////////////////////////////////////////////////////////////////////
// Address_map26 definition26
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c26 extends uvm_reg_block;

  rand spi_regfile26 spi_rf26;

  function void build();
    // Now26 define address mappings26
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf26 = spi_regfile26::type_id::create("spi_rf26", , get_full_name());
    spi_rf26.configure(this, "rf226");
    spi_rf26.build();
    spi_rf26.lock_model();
    default_map.add_submap(spi_rf26.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c26");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c26)
  function new(input string name="unnamed26-spi_reg_model_c26");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c26

`endif // SPI_RDB_SV26
