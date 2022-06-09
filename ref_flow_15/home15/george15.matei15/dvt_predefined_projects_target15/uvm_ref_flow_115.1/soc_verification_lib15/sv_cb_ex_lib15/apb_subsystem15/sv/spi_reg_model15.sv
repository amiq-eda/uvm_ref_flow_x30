`ifndef SPI_RDB_SV15
`define SPI_RDB_SV15

// Input15 File15: spi_rgm15.spirit15

// Number15 of addrMaps15 = 1
// Number15 of regFiles15 = 1
// Number15 of registers = 3
// Number15 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 23


class spi_ctrl_c15 extends uvm_reg;

  rand uvm_reg_field char_len15;
  rand uvm_reg_field go_bsy15;
  rand uvm_reg_field rx_neg15;
  rand uvm_reg_field tx_neg15;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie15;
  rand uvm_reg_field ass15;

  constraint c_char_len15 { char_len15.value == 7'b0001000; }
  constraint c_tx_neg15 { tx_neg15.value == 1'b1; }
  constraint c_rx_neg15 { rx_neg15.value == 1'b1; }
  constraint c_lsb15 { lsb.value == 1'b1; }
  constraint c_ie15 { ie15.value == 1'b1; }
  constraint c_ass15 { ass15.value == 1'b1; }
  virtual function void build();
    char_len15 = uvm_reg_field::type_id::create("char_len15");
    char_len15.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy15 = uvm_reg_field::type_id::create("go_bsy15");
    go_bsy15.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg15 = uvm_reg_field::type_id::create("rx_neg15");
    rx_neg15.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg15 = uvm_reg_field::type_id::create("tx_neg15");
    tx_neg15.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie15 = uvm_reg_field::type_id::create("ie15");
    ie15.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass15 = uvm_reg_field::type_id::create("ass15");
    ass15.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint char_len15.value[6:0];
    coverpoint go_bsy15.value[0:0];
    coverpoint rx_neg15.value[0:0];
    coverpoint tx_neg15.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie15.value[0:0];
    coverpoint ass15.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c15, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c15, uvm_reg)
  `uvm_object_utils(spi_ctrl_c15)
  function new(input string name="unnamed15-spi_ctrl_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : spi_ctrl_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 99


class spi_divider_c15 extends uvm_reg;

  rand uvm_reg_field divider15;

  constraint c_divider15 { divider15.value == 16'b1; }
  virtual function void build();
    divider15 = uvm_reg_field::type_id::create("divider15");
    divider15.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint divider15.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(spi_divider_c15, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c15, uvm_reg)
  `uvm_object_utils(spi_divider_c15)
  function new(input string name="unnamed15-spi_divider_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : spi_divider_c15

//////////////////////////////////////////////////////////////////////////////
// Register definition15
//////////////////////////////////////////////////////////////////////////////
// Line15 Number15: 122


class spi_ss_c15 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss15 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg15;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg15.sample();
  endfunction

  `uvm_register_cb(spi_ss_c15, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c15, uvm_reg)
  `uvm_object_utils(spi_ss_c15)
  function new(input string name="unnamed15-spi_ss_c15");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg15=new;
  endfunction : new
endclass : spi_ss_c15

class spi_regfile15 extends uvm_reg_block;

  rand spi_ctrl_c15 spi_ctrl15;
  rand spi_divider_c15 spi_divider15;
  rand spi_ss_c15 spi_ss15;

  virtual function void build();

    // Now15 create all registers

    spi_ctrl15 = spi_ctrl_c15::type_id::create("spi_ctrl15", , get_full_name());
    spi_divider15 = spi_divider_c15::type_id::create("spi_divider15", , get_full_name());
    spi_ss15 = spi_ss_c15::type_id::create("spi_ss15", , get_full_name());

    // Now15 build the registers. Set parent and hdl_paths

    spi_ctrl15.configure(this, null, "spi_ctrl_reg15");
    spi_ctrl15.build();
    spi_divider15.configure(this, null, "spi_divider_reg15");
    spi_divider15.build();
    spi_ss15.configure(this, null, "spi_ss_reg15");
    spi_ss15.build();
    // Now15 define address mappings15
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl15, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider15, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss15, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile15)
  function new(input string name="unnamed15-spi_rf15");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile15

//////////////////////////////////////////////////////////////////////////////
// Address_map15 definition15
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c15 extends uvm_reg_block;

  rand spi_regfile15 spi_rf15;

  function void build();
    // Now15 define address mappings15
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf15 = spi_regfile15::type_id::create("spi_rf15", , get_full_name());
    spi_rf15.configure(this, "rf215");
    spi_rf15.build();
    spi_rf15.lock_model();
    default_map.add_submap(spi_rf15.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c15");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c15)
  function new(input string name="unnamed15-spi_reg_model_c15");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c15

`endif // SPI_RDB_SV15
