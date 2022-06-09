`ifndef SPI_RDB_SV12
`define SPI_RDB_SV12

// Input12 File12: spi_rgm12.spirit12

// Number12 of addrMaps12 = 1
// Number12 of regFiles12 = 1
// Number12 of registers = 3
// Number12 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 23


class spi_ctrl_c12 extends uvm_reg;

  rand uvm_reg_field char_len12;
  rand uvm_reg_field go_bsy12;
  rand uvm_reg_field rx_neg12;
  rand uvm_reg_field tx_neg12;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie12;
  rand uvm_reg_field ass12;

  constraint c_char_len12 { char_len12.value == 7'b0001000; }
  constraint c_tx_neg12 { tx_neg12.value == 1'b1; }
  constraint c_rx_neg12 { rx_neg12.value == 1'b1; }
  constraint c_lsb12 { lsb.value == 1'b1; }
  constraint c_ie12 { ie12.value == 1'b1; }
  constraint c_ass12 { ass12.value == 1'b1; }
  virtual function void build();
    char_len12 = uvm_reg_field::type_id::create("char_len12");
    char_len12.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy12 = uvm_reg_field::type_id::create("go_bsy12");
    go_bsy12.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg12 = uvm_reg_field::type_id::create("rx_neg12");
    rx_neg12.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg12 = uvm_reg_field::type_id::create("tx_neg12");
    tx_neg12.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie12 = uvm_reg_field::type_id::create("ie12");
    ie12.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass12 = uvm_reg_field::type_id::create("ass12");
    ass12.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint char_len12.value[6:0];
    coverpoint go_bsy12.value[0:0];
    coverpoint rx_neg12.value[0:0];
    coverpoint tx_neg12.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie12.value[0:0];
    coverpoint ass12.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c12, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c12, uvm_reg)
  `uvm_object_utils(spi_ctrl_c12)
  function new(input string name="unnamed12-spi_ctrl_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : spi_ctrl_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 99


class spi_divider_c12 extends uvm_reg;

  rand uvm_reg_field divider12;

  constraint c_divider12 { divider12.value == 16'b1; }
  virtual function void build();
    divider12 = uvm_reg_field::type_id::create("divider12");
    divider12.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint divider12.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(spi_divider_c12, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c12, uvm_reg)
  `uvm_object_utils(spi_divider_c12)
  function new(input string name="unnamed12-spi_divider_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : spi_divider_c12

//////////////////////////////////////////////////////////////////////////////
// Register definition12
//////////////////////////////////////////////////////////////////////////////
// Line12 Number12: 122


class spi_ss_c12 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss12 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg12;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg12.sample();
  endfunction

  `uvm_register_cb(spi_ss_c12, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c12, uvm_reg)
  `uvm_object_utils(spi_ss_c12)
  function new(input string name="unnamed12-spi_ss_c12");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg12=new;
  endfunction : new
endclass : spi_ss_c12

class spi_regfile12 extends uvm_reg_block;

  rand spi_ctrl_c12 spi_ctrl12;
  rand spi_divider_c12 spi_divider12;
  rand spi_ss_c12 spi_ss12;

  virtual function void build();

    // Now12 create all registers

    spi_ctrl12 = spi_ctrl_c12::type_id::create("spi_ctrl12", , get_full_name());
    spi_divider12 = spi_divider_c12::type_id::create("spi_divider12", , get_full_name());
    spi_ss12 = spi_ss_c12::type_id::create("spi_ss12", , get_full_name());

    // Now12 build the registers. Set parent and hdl_paths

    spi_ctrl12.configure(this, null, "spi_ctrl_reg12");
    spi_ctrl12.build();
    spi_divider12.configure(this, null, "spi_divider_reg12");
    spi_divider12.build();
    spi_ss12.configure(this, null, "spi_ss_reg12");
    spi_ss12.build();
    // Now12 define address mappings12
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl12, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider12, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss12, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile12)
  function new(input string name="unnamed12-spi_rf12");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile12

//////////////////////////////////////////////////////////////////////////////
// Address_map12 definition12
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c12 extends uvm_reg_block;

  rand spi_regfile12 spi_rf12;

  function void build();
    // Now12 define address mappings12
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf12 = spi_regfile12::type_id::create("spi_rf12", , get_full_name());
    spi_rf12.configure(this, "rf212");
    spi_rf12.build();
    spi_rf12.lock_model();
    default_map.add_submap(spi_rf12.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c12");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c12)
  function new(input string name="unnamed12-spi_reg_model_c12");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c12

`endif // SPI_RDB_SV12
