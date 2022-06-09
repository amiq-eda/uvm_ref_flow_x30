`ifndef SPI_RDB_SV5
`define SPI_RDB_SV5

// Input5 File5: spi_rgm5.spirit5

// Number5 of addrMaps5 = 1
// Number5 of regFiles5 = 1
// Number5 of registers = 3
// Number5 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 23


class spi_ctrl_c5 extends uvm_reg;

  rand uvm_reg_field char_len5;
  rand uvm_reg_field go_bsy5;
  rand uvm_reg_field rx_neg5;
  rand uvm_reg_field tx_neg5;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie5;
  rand uvm_reg_field ass5;

  constraint c_char_len5 { char_len5.value == 7'b0001000; }
  constraint c_tx_neg5 { tx_neg5.value == 1'b1; }
  constraint c_rx_neg5 { rx_neg5.value == 1'b1; }
  constraint c_lsb5 { lsb.value == 1'b1; }
  constraint c_ie5 { ie5.value == 1'b1; }
  constraint c_ass5 { ass5.value == 1'b1; }
  virtual function void build();
    char_len5 = uvm_reg_field::type_id::create("char_len5");
    char_len5.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy5 = uvm_reg_field::type_id::create("go_bsy5");
    go_bsy5.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg5 = uvm_reg_field::type_id::create("rx_neg5");
    rx_neg5.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg5 = uvm_reg_field::type_id::create("tx_neg5");
    tx_neg5.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie5 = uvm_reg_field::type_id::create("ie5");
    ie5.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass5 = uvm_reg_field::type_id::create("ass5");
    ass5.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint char_len5.value[6:0];
    coverpoint go_bsy5.value[0:0];
    coverpoint rx_neg5.value[0:0];
    coverpoint tx_neg5.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie5.value[0:0];
    coverpoint ass5.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c5, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c5, uvm_reg)
  `uvm_object_utils(spi_ctrl_c5)
  function new(input string name="unnamed5-spi_ctrl_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : spi_ctrl_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 99


class spi_divider_c5 extends uvm_reg;

  rand uvm_reg_field divider5;

  constraint c_divider5 { divider5.value == 16'b1; }
  virtual function void build();
    divider5 = uvm_reg_field::type_id::create("divider5");
    divider5.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint divider5.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(spi_divider_c5, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c5, uvm_reg)
  `uvm_object_utils(spi_divider_c5)
  function new(input string name="unnamed5-spi_divider_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : spi_divider_c5

//////////////////////////////////////////////////////////////////////////////
// Register definition5
//////////////////////////////////////////////////////////////////////////////
// Line5 Number5: 122


class spi_ss_c5 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss5 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg5;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg5.sample();
  endfunction

  `uvm_register_cb(spi_ss_c5, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c5, uvm_reg)
  `uvm_object_utils(spi_ss_c5)
  function new(input string name="unnamed5-spi_ss_c5");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg5=new;
  endfunction : new
endclass : spi_ss_c5

class spi_regfile5 extends uvm_reg_block;

  rand spi_ctrl_c5 spi_ctrl5;
  rand spi_divider_c5 spi_divider5;
  rand spi_ss_c5 spi_ss5;

  virtual function void build();

    // Now5 create all registers

    spi_ctrl5 = spi_ctrl_c5::type_id::create("spi_ctrl5", , get_full_name());
    spi_divider5 = spi_divider_c5::type_id::create("spi_divider5", , get_full_name());
    spi_ss5 = spi_ss_c5::type_id::create("spi_ss5", , get_full_name());

    // Now5 build the registers. Set parent and hdl_paths

    spi_ctrl5.configure(this, null, "spi_ctrl_reg5");
    spi_ctrl5.build();
    spi_divider5.configure(this, null, "spi_divider_reg5");
    spi_divider5.build();
    spi_ss5.configure(this, null, "spi_ss_reg5");
    spi_ss5.build();
    // Now5 define address mappings5
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl5, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider5, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss5, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile5)
  function new(input string name="unnamed5-spi_rf5");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile5

//////////////////////////////////////////////////////////////////////////////
// Address_map5 definition5
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c5 extends uvm_reg_block;

  rand spi_regfile5 spi_rf5;

  function void build();
    // Now5 define address mappings5
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf5 = spi_regfile5::type_id::create("spi_rf5", , get_full_name());
    spi_rf5.configure(this, "rf25");
    spi_rf5.build();
    spi_rf5.lock_model();
    default_map.add_submap(spi_rf5.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c5");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c5)
  function new(input string name="unnamed5-spi_reg_model_c5");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c5

`endif // SPI_RDB_SV5
