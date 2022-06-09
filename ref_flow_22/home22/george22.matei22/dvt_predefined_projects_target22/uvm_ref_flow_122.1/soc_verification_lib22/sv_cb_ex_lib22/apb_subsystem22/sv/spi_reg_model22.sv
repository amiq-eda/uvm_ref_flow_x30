`ifndef SPI_RDB_SV22
`define SPI_RDB_SV22

// Input22 File22: spi_rgm22.spirit22

// Number22 of addrMaps22 = 1
// Number22 of regFiles22 = 1
// Number22 of registers = 3
// Number22 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 23


class spi_ctrl_c22 extends uvm_reg;

  rand uvm_reg_field char_len22;
  rand uvm_reg_field go_bsy22;
  rand uvm_reg_field rx_neg22;
  rand uvm_reg_field tx_neg22;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie22;
  rand uvm_reg_field ass22;

  constraint c_char_len22 { char_len22.value == 7'b0001000; }
  constraint c_tx_neg22 { tx_neg22.value == 1'b1; }
  constraint c_rx_neg22 { rx_neg22.value == 1'b1; }
  constraint c_lsb22 { lsb.value == 1'b1; }
  constraint c_ie22 { ie22.value == 1'b1; }
  constraint c_ass22 { ass22.value == 1'b1; }
  virtual function void build();
    char_len22 = uvm_reg_field::type_id::create("char_len22");
    char_len22.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy22 = uvm_reg_field::type_id::create("go_bsy22");
    go_bsy22.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg22 = uvm_reg_field::type_id::create("rx_neg22");
    rx_neg22.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg22 = uvm_reg_field::type_id::create("tx_neg22");
    tx_neg22.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie22 = uvm_reg_field::type_id::create("ie22");
    ie22.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass22 = uvm_reg_field::type_id::create("ass22");
    ass22.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint char_len22.value[6:0];
    coverpoint go_bsy22.value[0:0];
    coverpoint rx_neg22.value[0:0];
    coverpoint tx_neg22.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie22.value[0:0];
    coverpoint ass22.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c22, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c22, uvm_reg)
  `uvm_object_utils(spi_ctrl_c22)
  function new(input string name="unnamed22-spi_ctrl_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : spi_ctrl_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 99


class spi_divider_c22 extends uvm_reg;

  rand uvm_reg_field divider22;

  constraint c_divider22 { divider22.value == 16'b1; }
  virtual function void build();
    divider22 = uvm_reg_field::type_id::create("divider22");
    divider22.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint divider22.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(spi_divider_c22, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c22, uvm_reg)
  `uvm_object_utils(spi_divider_c22)
  function new(input string name="unnamed22-spi_divider_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : spi_divider_c22

//////////////////////////////////////////////////////////////////////////////
// Register definition22
//////////////////////////////////////////////////////////////////////////////
// Line22 Number22: 122


class spi_ss_c22 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss22 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg22;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg22.sample();
  endfunction

  `uvm_register_cb(spi_ss_c22, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c22, uvm_reg)
  `uvm_object_utils(spi_ss_c22)
  function new(input string name="unnamed22-spi_ss_c22");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg22=new;
  endfunction : new
endclass : spi_ss_c22

class spi_regfile22 extends uvm_reg_block;

  rand spi_ctrl_c22 spi_ctrl22;
  rand spi_divider_c22 spi_divider22;
  rand spi_ss_c22 spi_ss22;

  virtual function void build();

    // Now22 create all registers

    spi_ctrl22 = spi_ctrl_c22::type_id::create("spi_ctrl22", , get_full_name());
    spi_divider22 = spi_divider_c22::type_id::create("spi_divider22", , get_full_name());
    spi_ss22 = spi_ss_c22::type_id::create("spi_ss22", , get_full_name());

    // Now22 build the registers. Set parent and hdl_paths

    spi_ctrl22.configure(this, null, "spi_ctrl_reg22");
    spi_ctrl22.build();
    spi_divider22.configure(this, null, "spi_divider_reg22");
    spi_divider22.build();
    spi_ss22.configure(this, null, "spi_ss_reg22");
    spi_ss22.build();
    // Now22 define address mappings22
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl22, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider22, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss22, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile22)
  function new(input string name="unnamed22-spi_rf22");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile22

//////////////////////////////////////////////////////////////////////////////
// Address_map22 definition22
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c22 extends uvm_reg_block;

  rand spi_regfile22 spi_rf22;

  function void build();
    // Now22 define address mappings22
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf22 = spi_regfile22::type_id::create("spi_rf22", , get_full_name());
    spi_rf22.configure(this, "rf222");
    spi_rf22.build();
    spi_rf22.lock_model();
    default_map.add_submap(spi_rf22.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c22");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c22)
  function new(input string name="unnamed22-spi_reg_model_c22");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c22

`endif // SPI_RDB_SV22
