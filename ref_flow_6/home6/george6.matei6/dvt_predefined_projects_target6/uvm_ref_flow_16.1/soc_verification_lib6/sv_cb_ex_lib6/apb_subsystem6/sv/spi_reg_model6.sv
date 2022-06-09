`ifndef SPI_RDB_SV6
`define SPI_RDB_SV6

// Input6 File6: spi_rgm6.spirit6

// Number6 of addrMaps6 = 1
// Number6 of regFiles6 = 1
// Number6 of registers = 3
// Number6 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 23


class spi_ctrl_c6 extends uvm_reg;

  rand uvm_reg_field char_len6;
  rand uvm_reg_field go_bsy6;
  rand uvm_reg_field rx_neg6;
  rand uvm_reg_field tx_neg6;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie6;
  rand uvm_reg_field ass6;

  constraint c_char_len6 { char_len6.value == 7'b0001000; }
  constraint c_tx_neg6 { tx_neg6.value == 1'b1; }
  constraint c_rx_neg6 { rx_neg6.value == 1'b1; }
  constraint c_lsb6 { lsb.value == 1'b1; }
  constraint c_ie6 { ie6.value == 1'b1; }
  constraint c_ass6 { ass6.value == 1'b1; }
  virtual function void build();
    char_len6 = uvm_reg_field::type_id::create("char_len6");
    char_len6.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy6 = uvm_reg_field::type_id::create("go_bsy6");
    go_bsy6.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg6 = uvm_reg_field::type_id::create("rx_neg6");
    rx_neg6.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg6 = uvm_reg_field::type_id::create("tx_neg6");
    tx_neg6.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie6 = uvm_reg_field::type_id::create("ie6");
    ie6.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass6 = uvm_reg_field::type_id::create("ass6");
    ass6.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint char_len6.value[6:0];
    coverpoint go_bsy6.value[0:0];
    coverpoint rx_neg6.value[0:0];
    coverpoint tx_neg6.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie6.value[0:0];
    coverpoint ass6.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c6, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c6, uvm_reg)
  `uvm_object_utils(spi_ctrl_c6)
  function new(input string name="unnamed6-spi_ctrl_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : spi_ctrl_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 99


class spi_divider_c6 extends uvm_reg;

  rand uvm_reg_field divider6;

  constraint c_divider6 { divider6.value == 16'b1; }
  virtual function void build();
    divider6 = uvm_reg_field::type_id::create("divider6");
    divider6.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint divider6.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(spi_divider_c6, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c6, uvm_reg)
  `uvm_object_utils(spi_divider_c6)
  function new(input string name="unnamed6-spi_divider_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : spi_divider_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 122


class spi_ss_c6 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss6 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg6;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg6.sample();
  endfunction

  `uvm_register_cb(spi_ss_c6, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c6, uvm_reg)
  `uvm_object_utils(spi_ss_c6)
  function new(input string name="unnamed6-spi_ss_c6");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg6=new;
  endfunction : new
endclass : spi_ss_c6

class spi_regfile6 extends uvm_reg_block;

  rand spi_ctrl_c6 spi_ctrl6;
  rand spi_divider_c6 spi_divider6;
  rand spi_ss_c6 spi_ss6;

  virtual function void build();

    // Now6 create all registers

    spi_ctrl6 = spi_ctrl_c6::type_id::create("spi_ctrl6", , get_full_name());
    spi_divider6 = spi_divider_c6::type_id::create("spi_divider6", , get_full_name());
    spi_ss6 = spi_ss_c6::type_id::create("spi_ss6", , get_full_name());

    // Now6 build the registers. Set parent and hdl_paths

    spi_ctrl6.configure(this, null, "spi_ctrl_reg6");
    spi_ctrl6.build();
    spi_divider6.configure(this, null, "spi_divider_reg6");
    spi_divider6.build();
    spi_ss6.configure(this, null, "spi_ss_reg6");
    spi_ss6.build();
    // Now6 define address mappings6
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl6, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider6, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss6, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile6)
  function new(input string name="unnamed6-spi_rf6");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile6

//////////////////////////////////////////////////////////////////////////////
// Address_map6 definition6
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c6 extends uvm_reg_block;

  rand spi_regfile6 spi_rf6;

  function void build();
    // Now6 define address mappings6
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf6 = spi_regfile6::type_id::create("spi_rf6", , get_full_name());
    spi_rf6.configure(this, "rf26");
    spi_rf6.build();
    spi_rf6.lock_model();
    default_map.add_submap(spi_rf6.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c6");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c6)
  function new(input string name="unnamed6-spi_reg_model_c6");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c6

`endif // SPI_RDB_SV6
