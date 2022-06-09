`ifndef SPI_RDB_SV2
`define SPI_RDB_SV2

// Input2 File2: spi_rgm2.spirit2

// Number2 of addrMaps2 = 1
// Number2 of regFiles2 = 1
// Number2 of registers = 3
// Number2 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 23


class spi_ctrl_c2 extends uvm_reg;

  rand uvm_reg_field char_len2;
  rand uvm_reg_field go_bsy2;
  rand uvm_reg_field rx_neg2;
  rand uvm_reg_field tx_neg2;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie2;
  rand uvm_reg_field ass2;

  constraint c_char_len2 { char_len2.value == 7'b0001000; }
  constraint c_tx_neg2 { tx_neg2.value == 1'b1; }
  constraint c_rx_neg2 { rx_neg2.value == 1'b1; }
  constraint c_lsb2 { lsb.value == 1'b1; }
  constraint c_ie2 { ie2.value == 1'b1; }
  constraint c_ass2 { ass2.value == 1'b1; }
  virtual function void build();
    char_len2 = uvm_reg_field::type_id::create("char_len2");
    char_len2.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy2 = uvm_reg_field::type_id::create("go_bsy2");
    go_bsy2.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg2 = uvm_reg_field::type_id::create("rx_neg2");
    rx_neg2.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg2 = uvm_reg_field::type_id::create("tx_neg2");
    tx_neg2.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie2 = uvm_reg_field::type_id::create("ie2");
    ie2.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass2 = uvm_reg_field::type_id::create("ass2");
    ass2.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint char_len2.value[6:0];
    coverpoint go_bsy2.value[0:0];
    coverpoint rx_neg2.value[0:0];
    coverpoint tx_neg2.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie2.value[0:0];
    coverpoint ass2.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c2, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c2, uvm_reg)
  `uvm_object_utils(spi_ctrl_c2)
  function new(input string name="unnamed2-spi_ctrl_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : spi_ctrl_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 99


class spi_divider_c2 extends uvm_reg;

  rand uvm_reg_field divider2;

  constraint c_divider2 { divider2.value == 16'b1; }
  virtual function void build();
    divider2 = uvm_reg_field::type_id::create("divider2");
    divider2.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint divider2.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(spi_divider_c2, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c2, uvm_reg)
  `uvm_object_utils(spi_divider_c2)
  function new(input string name="unnamed2-spi_divider_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : spi_divider_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 122


class spi_ss_c2 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss2 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg2;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg2.sample();
  endfunction

  `uvm_register_cb(spi_ss_c2, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c2, uvm_reg)
  `uvm_object_utils(spi_ss_c2)
  function new(input string name="unnamed2-spi_ss_c2");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg2=new;
  endfunction : new
endclass : spi_ss_c2

class spi_regfile2 extends uvm_reg_block;

  rand spi_ctrl_c2 spi_ctrl2;
  rand spi_divider_c2 spi_divider2;
  rand spi_ss_c2 spi_ss2;

  virtual function void build();

    // Now2 create all registers

    spi_ctrl2 = spi_ctrl_c2::type_id::create("spi_ctrl2", , get_full_name());
    spi_divider2 = spi_divider_c2::type_id::create("spi_divider2", , get_full_name());
    spi_ss2 = spi_ss_c2::type_id::create("spi_ss2", , get_full_name());

    // Now2 build the registers. Set parent and hdl_paths

    spi_ctrl2.configure(this, null, "spi_ctrl_reg2");
    spi_ctrl2.build();
    spi_divider2.configure(this, null, "spi_divider_reg2");
    spi_divider2.build();
    spi_ss2.configure(this, null, "spi_ss_reg2");
    spi_ss2.build();
    // Now2 define address mappings2
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl2, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider2, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss2, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile2)
  function new(input string name="unnamed2-spi_rf2");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile2

//////////////////////////////////////////////////////////////////////////////
// Address_map2 definition2
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c2 extends uvm_reg_block;

  rand spi_regfile2 spi_rf2;

  function void build();
    // Now2 define address mappings2
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf2 = spi_regfile2::type_id::create("spi_rf2", , get_full_name());
    spi_rf2.configure(this, "rf22");
    spi_rf2.build();
    spi_rf2.lock_model();
    default_map.add_submap(spi_rf2.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c2");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c2)
  function new(input string name="unnamed2-spi_reg_model_c2");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c2

`endif // SPI_RDB_SV2
