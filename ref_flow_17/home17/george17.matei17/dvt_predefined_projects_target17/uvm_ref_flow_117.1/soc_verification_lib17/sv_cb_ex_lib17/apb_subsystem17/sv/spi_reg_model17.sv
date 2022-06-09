`ifndef SPI_RDB_SV17
`define SPI_RDB_SV17

// Input17 File17: spi_rgm17.spirit17

// Number17 of addrMaps17 = 1
// Number17 of regFiles17 = 1
// Number17 of registers = 3
// Number17 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 23


class spi_ctrl_c17 extends uvm_reg;

  rand uvm_reg_field char_len17;
  rand uvm_reg_field go_bsy17;
  rand uvm_reg_field rx_neg17;
  rand uvm_reg_field tx_neg17;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie17;
  rand uvm_reg_field ass17;

  constraint c_char_len17 { char_len17.value == 7'b0001000; }
  constraint c_tx_neg17 { tx_neg17.value == 1'b1; }
  constraint c_rx_neg17 { rx_neg17.value == 1'b1; }
  constraint c_lsb17 { lsb.value == 1'b1; }
  constraint c_ie17 { ie17.value == 1'b1; }
  constraint c_ass17 { ass17.value == 1'b1; }
  virtual function void build();
    char_len17 = uvm_reg_field::type_id::create("char_len17");
    char_len17.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy17 = uvm_reg_field::type_id::create("go_bsy17");
    go_bsy17.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg17 = uvm_reg_field::type_id::create("rx_neg17");
    rx_neg17.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg17 = uvm_reg_field::type_id::create("tx_neg17");
    tx_neg17.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie17 = uvm_reg_field::type_id::create("ie17");
    ie17.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass17 = uvm_reg_field::type_id::create("ass17");
    ass17.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint char_len17.value[6:0];
    coverpoint go_bsy17.value[0:0];
    coverpoint rx_neg17.value[0:0];
    coverpoint tx_neg17.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie17.value[0:0];
    coverpoint ass17.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c17, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c17, uvm_reg)
  `uvm_object_utils(spi_ctrl_c17)
  function new(input string name="unnamed17-spi_ctrl_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : spi_ctrl_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 99


class spi_divider_c17 extends uvm_reg;

  rand uvm_reg_field divider17;

  constraint c_divider17 { divider17.value == 16'b1; }
  virtual function void build();
    divider17 = uvm_reg_field::type_id::create("divider17");
    divider17.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint divider17.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(spi_divider_c17, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c17, uvm_reg)
  `uvm_object_utils(spi_divider_c17)
  function new(input string name="unnamed17-spi_divider_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : spi_divider_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 122


class spi_ss_c17 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss17 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg17;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg17.sample();
  endfunction

  `uvm_register_cb(spi_ss_c17, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c17, uvm_reg)
  `uvm_object_utils(spi_ss_c17)
  function new(input string name="unnamed17-spi_ss_c17");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg17=new;
  endfunction : new
endclass : spi_ss_c17

class spi_regfile17 extends uvm_reg_block;

  rand spi_ctrl_c17 spi_ctrl17;
  rand spi_divider_c17 spi_divider17;
  rand spi_ss_c17 spi_ss17;

  virtual function void build();

    // Now17 create all registers

    spi_ctrl17 = spi_ctrl_c17::type_id::create("spi_ctrl17", , get_full_name());
    spi_divider17 = spi_divider_c17::type_id::create("spi_divider17", , get_full_name());
    spi_ss17 = spi_ss_c17::type_id::create("spi_ss17", , get_full_name());

    // Now17 build the registers. Set parent and hdl_paths

    spi_ctrl17.configure(this, null, "spi_ctrl_reg17");
    spi_ctrl17.build();
    spi_divider17.configure(this, null, "spi_divider_reg17");
    spi_divider17.build();
    spi_ss17.configure(this, null, "spi_ss_reg17");
    spi_ss17.build();
    // Now17 define address mappings17
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl17, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider17, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss17, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile17)
  function new(input string name="unnamed17-spi_rf17");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile17

//////////////////////////////////////////////////////////////////////////////
// Address_map17 definition17
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c17 extends uvm_reg_block;

  rand spi_regfile17 spi_rf17;

  function void build();
    // Now17 define address mappings17
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf17 = spi_regfile17::type_id::create("spi_rf17", , get_full_name());
    spi_rf17.configure(this, "rf217");
    spi_rf17.build();
    spi_rf17.lock_model();
    default_map.add_submap(spi_rf17.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c17");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c17)
  function new(input string name="unnamed17-spi_reg_model_c17");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c17

`endif // SPI_RDB_SV17
