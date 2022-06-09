`ifndef SPI_RDB_SV28
`define SPI_RDB_SV28

// Input28 File28: spi_rgm28.spirit28

// Number28 of addrMaps28 = 1
// Number28 of regFiles28 = 1
// Number28 of registers = 3
// Number28 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 23


class spi_ctrl_c28 extends uvm_reg;

  rand uvm_reg_field char_len28;
  rand uvm_reg_field go_bsy28;
  rand uvm_reg_field rx_neg28;
  rand uvm_reg_field tx_neg28;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie28;
  rand uvm_reg_field ass28;

  constraint c_char_len28 { char_len28.value == 7'b0001000; }
  constraint c_tx_neg28 { tx_neg28.value == 1'b1; }
  constraint c_rx_neg28 { rx_neg28.value == 1'b1; }
  constraint c_lsb28 { lsb.value == 1'b1; }
  constraint c_ie28 { ie28.value == 1'b1; }
  constraint c_ass28 { ass28.value == 1'b1; }
  virtual function void build();
    char_len28 = uvm_reg_field::type_id::create("char_len28");
    char_len28.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy28 = uvm_reg_field::type_id::create("go_bsy28");
    go_bsy28.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg28 = uvm_reg_field::type_id::create("rx_neg28");
    rx_neg28.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg28 = uvm_reg_field::type_id::create("tx_neg28");
    tx_neg28.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie28 = uvm_reg_field::type_id::create("ie28");
    ie28.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass28 = uvm_reg_field::type_id::create("ass28");
    ass28.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint char_len28.value[6:0];
    coverpoint go_bsy28.value[0:0];
    coverpoint rx_neg28.value[0:0];
    coverpoint tx_neg28.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie28.value[0:0];
    coverpoint ass28.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c28, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c28, uvm_reg)
  `uvm_object_utils(spi_ctrl_c28)
  function new(input string name="unnamed28-spi_ctrl_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : spi_ctrl_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 99


class spi_divider_c28 extends uvm_reg;

  rand uvm_reg_field divider28;

  constraint c_divider28 { divider28.value == 16'b1; }
  virtual function void build();
    divider28 = uvm_reg_field::type_id::create("divider28");
    divider28.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint divider28.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(spi_divider_c28, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c28, uvm_reg)
  `uvm_object_utils(spi_divider_c28)
  function new(input string name="unnamed28-spi_divider_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : spi_divider_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 122


class spi_ss_c28 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss28 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg28;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg28.sample();
  endfunction

  `uvm_register_cb(spi_ss_c28, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c28, uvm_reg)
  `uvm_object_utils(spi_ss_c28)
  function new(input string name="unnamed28-spi_ss_c28");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg28=new;
  endfunction : new
endclass : spi_ss_c28

class spi_regfile28 extends uvm_reg_block;

  rand spi_ctrl_c28 spi_ctrl28;
  rand spi_divider_c28 spi_divider28;
  rand spi_ss_c28 spi_ss28;

  virtual function void build();

    // Now28 create all registers

    spi_ctrl28 = spi_ctrl_c28::type_id::create("spi_ctrl28", , get_full_name());
    spi_divider28 = spi_divider_c28::type_id::create("spi_divider28", , get_full_name());
    spi_ss28 = spi_ss_c28::type_id::create("spi_ss28", , get_full_name());

    // Now28 build the registers. Set parent and hdl_paths

    spi_ctrl28.configure(this, null, "spi_ctrl_reg28");
    spi_ctrl28.build();
    spi_divider28.configure(this, null, "spi_divider_reg28");
    spi_divider28.build();
    spi_ss28.configure(this, null, "spi_ss_reg28");
    spi_ss28.build();
    // Now28 define address mappings28
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl28, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider28, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss28, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile28)
  function new(input string name="unnamed28-spi_rf28");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile28

//////////////////////////////////////////////////////////////////////////////
// Address_map28 definition28
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c28 extends uvm_reg_block;

  rand spi_regfile28 spi_rf28;

  function void build();
    // Now28 define address mappings28
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf28 = spi_regfile28::type_id::create("spi_rf28", , get_full_name());
    spi_rf28.configure(this, "rf228");
    spi_rf28.build();
    spi_rf28.lock_model();
    default_map.add_submap(spi_rf28.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c28");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c28)
  function new(input string name="unnamed28-spi_reg_model_c28");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c28

`endif // SPI_RDB_SV28
