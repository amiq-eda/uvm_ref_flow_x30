`ifndef SPI_RDB_SV14
`define SPI_RDB_SV14

// Input14 File14: spi_rgm14.spirit14

// Number14 of addrMaps14 = 1
// Number14 of regFiles14 = 1
// Number14 of registers = 3
// Number14 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 23


class spi_ctrl_c14 extends uvm_reg;

  rand uvm_reg_field char_len14;
  rand uvm_reg_field go_bsy14;
  rand uvm_reg_field rx_neg14;
  rand uvm_reg_field tx_neg14;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie14;
  rand uvm_reg_field ass14;

  constraint c_char_len14 { char_len14.value == 7'b0001000; }
  constraint c_tx_neg14 { tx_neg14.value == 1'b1; }
  constraint c_rx_neg14 { rx_neg14.value == 1'b1; }
  constraint c_lsb14 { lsb.value == 1'b1; }
  constraint c_ie14 { ie14.value == 1'b1; }
  constraint c_ass14 { ass14.value == 1'b1; }
  virtual function void build();
    char_len14 = uvm_reg_field::type_id::create("char_len14");
    char_len14.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy14 = uvm_reg_field::type_id::create("go_bsy14");
    go_bsy14.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg14 = uvm_reg_field::type_id::create("rx_neg14");
    rx_neg14.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg14 = uvm_reg_field::type_id::create("tx_neg14");
    tx_neg14.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie14 = uvm_reg_field::type_id::create("ie14");
    ie14.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass14 = uvm_reg_field::type_id::create("ass14");
    ass14.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint char_len14.value[6:0];
    coverpoint go_bsy14.value[0:0];
    coverpoint rx_neg14.value[0:0];
    coverpoint tx_neg14.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie14.value[0:0];
    coverpoint ass14.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c14, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c14, uvm_reg)
  `uvm_object_utils(spi_ctrl_c14)
  function new(input string name="unnamed14-spi_ctrl_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : spi_ctrl_c14

//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 99


class spi_divider_c14 extends uvm_reg;

  rand uvm_reg_field divider14;

  constraint c_divider14 { divider14.value == 16'b1; }
  virtual function void build();
    divider14 = uvm_reg_field::type_id::create("divider14");
    divider14.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint divider14.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(spi_divider_c14, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c14, uvm_reg)
  `uvm_object_utils(spi_divider_c14)
  function new(input string name="unnamed14-spi_divider_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : spi_divider_c14

//////////////////////////////////////////////////////////////////////////////
// Register definition14
//////////////////////////////////////////////////////////////////////////////
// Line14 Number14: 122


class spi_ss_c14 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss14 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg14;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg14.sample();
  endfunction

  `uvm_register_cb(spi_ss_c14, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c14, uvm_reg)
  `uvm_object_utils(spi_ss_c14)
  function new(input string name="unnamed14-spi_ss_c14");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg14=new;
  endfunction : new
endclass : spi_ss_c14

class spi_regfile14 extends uvm_reg_block;

  rand spi_ctrl_c14 spi_ctrl14;
  rand spi_divider_c14 spi_divider14;
  rand spi_ss_c14 spi_ss14;

  virtual function void build();

    // Now14 create all registers

    spi_ctrl14 = spi_ctrl_c14::type_id::create("spi_ctrl14", , get_full_name());
    spi_divider14 = spi_divider_c14::type_id::create("spi_divider14", , get_full_name());
    spi_ss14 = spi_ss_c14::type_id::create("spi_ss14", , get_full_name());

    // Now14 build the registers. Set parent and hdl_paths

    spi_ctrl14.configure(this, null, "spi_ctrl_reg14");
    spi_ctrl14.build();
    spi_divider14.configure(this, null, "spi_divider_reg14");
    spi_divider14.build();
    spi_ss14.configure(this, null, "spi_ss_reg14");
    spi_ss14.build();
    // Now14 define address mappings14
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl14, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider14, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss14, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile14)
  function new(input string name="unnamed14-spi_rf14");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile14

//////////////////////////////////////////////////////////////////////////////
// Address_map14 definition14
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c14 extends uvm_reg_block;

  rand spi_regfile14 spi_rf14;

  function void build();
    // Now14 define address mappings14
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf14 = spi_regfile14::type_id::create("spi_rf14", , get_full_name());
    spi_rf14.configure(this, "rf214");
    spi_rf14.build();
    spi_rf14.lock_model();
    default_map.add_submap(spi_rf14.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c14");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c14)
  function new(input string name="unnamed14-spi_reg_model_c14");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c14

`endif // SPI_RDB_SV14
