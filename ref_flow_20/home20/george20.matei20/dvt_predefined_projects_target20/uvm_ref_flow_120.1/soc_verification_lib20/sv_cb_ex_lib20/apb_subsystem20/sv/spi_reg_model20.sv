`ifndef SPI_RDB_SV20
`define SPI_RDB_SV20

// Input20 File20: spi_rgm20.spirit20

// Number20 of addrMaps20 = 1
// Number20 of regFiles20 = 1
// Number20 of registers = 3
// Number20 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 23


class spi_ctrl_c20 extends uvm_reg;

  rand uvm_reg_field char_len20;
  rand uvm_reg_field go_bsy20;
  rand uvm_reg_field rx_neg20;
  rand uvm_reg_field tx_neg20;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie20;
  rand uvm_reg_field ass20;

  constraint c_char_len20 { char_len20.value == 7'b0001000; }
  constraint c_tx_neg20 { tx_neg20.value == 1'b1; }
  constraint c_rx_neg20 { rx_neg20.value == 1'b1; }
  constraint c_lsb20 { lsb.value == 1'b1; }
  constraint c_ie20 { ie20.value == 1'b1; }
  constraint c_ass20 { ass20.value == 1'b1; }
  virtual function void build();
    char_len20 = uvm_reg_field::type_id::create("char_len20");
    char_len20.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy20 = uvm_reg_field::type_id::create("go_bsy20");
    go_bsy20.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg20 = uvm_reg_field::type_id::create("rx_neg20");
    rx_neg20.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg20 = uvm_reg_field::type_id::create("tx_neg20");
    tx_neg20.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie20 = uvm_reg_field::type_id::create("ie20");
    ie20.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass20 = uvm_reg_field::type_id::create("ass20");
    ass20.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint char_len20.value[6:0];
    coverpoint go_bsy20.value[0:0];
    coverpoint rx_neg20.value[0:0];
    coverpoint tx_neg20.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie20.value[0:0];
    coverpoint ass20.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c20, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c20, uvm_reg)
  `uvm_object_utils(spi_ctrl_c20)
  function new(input string name="unnamed20-spi_ctrl_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : spi_ctrl_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 99


class spi_divider_c20 extends uvm_reg;

  rand uvm_reg_field divider20;

  constraint c_divider20 { divider20.value == 16'b1; }
  virtual function void build();
    divider20 = uvm_reg_field::type_id::create("divider20");
    divider20.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint divider20.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(spi_divider_c20, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c20, uvm_reg)
  `uvm_object_utils(spi_divider_c20)
  function new(input string name="unnamed20-spi_divider_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : spi_divider_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 122


class spi_ss_c20 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss20 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg20;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg20.sample();
  endfunction

  `uvm_register_cb(spi_ss_c20, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c20, uvm_reg)
  `uvm_object_utils(spi_ss_c20)
  function new(input string name="unnamed20-spi_ss_c20");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg20=new;
  endfunction : new
endclass : spi_ss_c20

class spi_regfile20 extends uvm_reg_block;

  rand spi_ctrl_c20 spi_ctrl20;
  rand spi_divider_c20 spi_divider20;
  rand spi_ss_c20 spi_ss20;

  virtual function void build();

    // Now20 create all registers

    spi_ctrl20 = spi_ctrl_c20::type_id::create("spi_ctrl20", , get_full_name());
    spi_divider20 = spi_divider_c20::type_id::create("spi_divider20", , get_full_name());
    spi_ss20 = spi_ss_c20::type_id::create("spi_ss20", , get_full_name());

    // Now20 build the registers. Set parent and hdl_paths

    spi_ctrl20.configure(this, null, "spi_ctrl_reg20");
    spi_ctrl20.build();
    spi_divider20.configure(this, null, "spi_divider_reg20");
    spi_divider20.build();
    spi_ss20.configure(this, null, "spi_ss_reg20");
    spi_ss20.build();
    // Now20 define address mappings20
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl20, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider20, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss20, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile20)
  function new(input string name="unnamed20-spi_rf20");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile20

//////////////////////////////////////////////////////////////////////////////
// Address_map20 definition20
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c20 extends uvm_reg_block;

  rand spi_regfile20 spi_rf20;

  function void build();
    // Now20 define address mappings20
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf20 = spi_regfile20::type_id::create("spi_rf20", , get_full_name());
    spi_rf20.configure(this, "rf220");
    spi_rf20.build();
    spi_rf20.lock_model();
    default_map.add_submap(spi_rf20.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c20");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c20)
  function new(input string name="unnamed20-spi_reg_model_c20");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c20

`endif // SPI_RDB_SV20
