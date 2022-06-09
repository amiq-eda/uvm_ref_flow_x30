`ifndef SPI_RDB_SV27
`define SPI_RDB_SV27

// Input27 File27: spi_rgm27.spirit27

// Number27 of addrMaps27 = 1
// Number27 of regFiles27 = 1
// Number27 of registers = 3
// Number27 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 23


class spi_ctrl_c27 extends uvm_reg;

  rand uvm_reg_field char_len27;
  rand uvm_reg_field go_bsy27;
  rand uvm_reg_field rx_neg27;
  rand uvm_reg_field tx_neg27;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie27;
  rand uvm_reg_field ass27;

  constraint c_char_len27 { char_len27.value == 7'b0001000; }
  constraint c_tx_neg27 { tx_neg27.value == 1'b1; }
  constraint c_rx_neg27 { rx_neg27.value == 1'b1; }
  constraint c_lsb27 { lsb.value == 1'b1; }
  constraint c_ie27 { ie27.value == 1'b1; }
  constraint c_ass27 { ass27.value == 1'b1; }
  virtual function void build();
    char_len27 = uvm_reg_field::type_id::create("char_len27");
    char_len27.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy27 = uvm_reg_field::type_id::create("go_bsy27");
    go_bsy27.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg27 = uvm_reg_field::type_id::create("rx_neg27");
    rx_neg27.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg27 = uvm_reg_field::type_id::create("tx_neg27");
    tx_neg27.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie27 = uvm_reg_field::type_id::create("ie27");
    ie27.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass27 = uvm_reg_field::type_id::create("ass27");
    ass27.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint char_len27.value[6:0];
    coverpoint go_bsy27.value[0:0];
    coverpoint rx_neg27.value[0:0];
    coverpoint tx_neg27.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie27.value[0:0];
    coverpoint ass27.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c27, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c27, uvm_reg)
  `uvm_object_utils(spi_ctrl_c27)
  function new(input string name="unnamed27-spi_ctrl_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : spi_ctrl_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 99


class spi_divider_c27 extends uvm_reg;

  rand uvm_reg_field divider27;

  constraint c_divider27 { divider27.value == 16'b1; }
  virtual function void build();
    divider27 = uvm_reg_field::type_id::create("divider27");
    divider27.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint divider27.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(spi_divider_c27, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c27, uvm_reg)
  `uvm_object_utils(spi_divider_c27)
  function new(input string name="unnamed27-spi_divider_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : spi_divider_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 122


class spi_ss_c27 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss27 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg27;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg27.sample();
  endfunction

  `uvm_register_cb(spi_ss_c27, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c27, uvm_reg)
  `uvm_object_utils(spi_ss_c27)
  function new(input string name="unnamed27-spi_ss_c27");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg27=new;
  endfunction : new
endclass : spi_ss_c27

class spi_regfile27 extends uvm_reg_block;

  rand spi_ctrl_c27 spi_ctrl27;
  rand spi_divider_c27 spi_divider27;
  rand spi_ss_c27 spi_ss27;

  virtual function void build();

    // Now27 create all registers

    spi_ctrl27 = spi_ctrl_c27::type_id::create("spi_ctrl27", , get_full_name());
    spi_divider27 = spi_divider_c27::type_id::create("spi_divider27", , get_full_name());
    spi_ss27 = spi_ss_c27::type_id::create("spi_ss27", , get_full_name());

    // Now27 build the registers. Set parent and hdl_paths

    spi_ctrl27.configure(this, null, "spi_ctrl_reg27");
    spi_ctrl27.build();
    spi_divider27.configure(this, null, "spi_divider_reg27");
    spi_divider27.build();
    spi_ss27.configure(this, null, "spi_ss_reg27");
    spi_ss27.build();
    // Now27 define address mappings27
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl27, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider27, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss27, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile27)
  function new(input string name="unnamed27-spi_rf27");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile27

//////////////////////////////////////////////////////////////////////////////
// Address_map27 definition27
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c27 extends uvm_reg_block;

  rand spi_regfile27 spi_rf27;

  function void build();
    // Now27 define address mappings27
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf27 = spi_regfile27::type_id::create("spi_rf27", , get_full_name());
    spi_rf27.configure(this, "rf227");
    spi_rf27.build();
    spi_rf27.lock_model();
    default_map.add_submap(spi_rf27.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c27");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c27)
  function new(input string name="unnamed27-spi_reg_model_c27");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c27

`endif // SPI_RDB_SV27
