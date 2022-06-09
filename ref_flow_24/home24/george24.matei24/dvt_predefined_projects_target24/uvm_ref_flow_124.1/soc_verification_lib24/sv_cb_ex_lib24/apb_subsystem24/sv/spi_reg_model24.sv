`ifndef SPI_RDB_SV24
`define SPI_RDB_SV24

// Input24 File24: spi_rgm24.spirit24

// Number24 of addrMaps24 = 1
// Number24 of regFiles24 = 1
// Number24 of registers = 3
// Number24 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 23


class spi_ctrl_c24 extends uvm_reg;

  rand uvm_reg_field char_len24;
  rand uvm_reg_field go_bsy24;
  rand uvm_reg_field rx_neg24;
  rand uvm_reg_field tx_neg24;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie24;
  rand uvm_reg_field ass24;

  constraint c_char_len24 { char_len24.value == 7'b0001000; }
  constraint c_tx_neg24 { tx_neg24.value == 1'b1; }
  constraint c_rx_neg24 { rx_neg24.value == 1'b1; }
  constraint c_lsb24 { lsb.value == 1'b1; }
  constraint c_ie24 { ie24.value == 1'b1; }
  constraint c_ass24 { ass24.value == 1'b1; }
  virtual function void build();
    char_len24 = uvm_reg_field::type_id::create("char_len24");
    char_len24.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy24 = uvm_reg_field::type_id::create("go_bsy24");
    go_bsy24.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg24 = uvm_reg_field::type_id::create("rx_neg24");
    rx_neg24.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg24 = uvm_reg_field::type_id::create("tx_neg24");
    tx_neg24.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie24 = uvm_reg_field::type_id::create("ie24");
    ie24.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass24 = uvm_reg_field::type_id::create("ass24");
    ass24.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint char_len24.value[6:0];
    coverpoint go_bsy24.value[0:0];
    coverpoint rx_neg24.value[0:0];
    coverpoint tx_neg24.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie24.value[0:0];
    coverpoint ass24.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c24, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c24, uvm_reg)
  `uvm_object_utils(spi_ctrl_c24)
  function new(input string name="unnamed24-spi_ctrl_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : spi_ctrl_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 99


class spi_divider_c24 extends uvm_reg;

  rand uvm_reg_field divider24;

  constraint c_divider24 { divider24.value == 16'b1; }
  virtual function void build();
    divider24 = uvm_reg_field::type_id::create("divider24");
    divider24.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint divider24.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(spi_divider_c24, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c24, uvm_reg)
  `uvm_object_utils(spi_divider_c24)
  function new(input string name="unnamed24-spi_divider_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : spi_divider_c24

//////////////////////////////////////////////////////////////////////////////
// Register definition24
//////////////////////////////////////////////////////////////////////////////
// Line24 Number24: 122


class spi_ss_c24 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss24 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg24;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg24.sample();
  endfunction

  `uvm_register_cb(spi_ss_c24, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c24, uvm_reg)
  `uvm_object_utils(spi_ss_c24)
  function new(input string name="unnamed24-spi_ss_c24");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg24=new;
  endfunction : new
endclass : spi_ss_c24

class spi_regfile24 extends uvm_reg_block;

  rand spi_ctrl_c24 spi_ctrl24;
  rand spi_divider_c24 spi_divider24;
  rand spi_ss_c24 spi_ss24;

  virtual function void build();

    // Now24 create all registers

    spi_ctrl24 = spi_ctrl_c24::type_id::create("spi_ctrl24", , get_full_name());
    spi_divider24 = spi_divider_c24::type_id::create("spi_divider24", , get_full_name());
    spi_ss24 = spi_ss_c24::type_id::create("spi_ss24", , get_full_name());

    // Now24 build the registers. Set parent and hdl_paths

    spi_ctrl24.configure(this, null, "spi_ctrl_reg24");
    spi_ctrl24.build();
    spi_divider24.configure(this, null, "spi_divider_reg24");
    spi_divider24.build();
    spi_ss24.configure(this, null, "spi_ss_reg24");
    spi_ss24.build();
    // Now24 define address mappings24
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl24, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider24, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss24, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile24)
  function new(input string name="unnamed24-spi_rf24");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile24

//////////////////////////////////////////////////////////////////////////////
// Address_map24 definition24
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c24 extends uvm_reg_block;

  rand spi_regfile24 spi_rf24;

  function void build();
    // Now24 define address mappings24
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf24 = spi_regfile24::type_id::create("spi_rf24", , get_full_name());
    spi_rf24.configure(this, "rf224");
    spi_rf24.build();
    spi_rf24.lock_model();
    default_map.add_submap(spi_rf24.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c24");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c24)
  function new(input string name="unnamed24-spi_reg_model_c24");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c24

`endif // SPI_RDB_SV24
