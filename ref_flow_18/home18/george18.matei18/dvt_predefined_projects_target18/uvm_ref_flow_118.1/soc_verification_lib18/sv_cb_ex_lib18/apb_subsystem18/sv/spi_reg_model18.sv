`ifndef SPI_RDB_SV18
`define SPI_RDB_SV18

// Input18 File18: spi_rgm18.spirit18

// Number18 of addrMaps18 = 1
// Number18 of regFiles18 = 1
// Number18 of registers = 3
// Number18 of memories = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 23


class spi_ctrl_c18 extends uvm_reg;

  rand uvm_reg_field char_len18;
  rand uvm_reg_field go_bsy18;
  rand uvm_reg_field rx_neg18;
  rand uvm_reg_field tx_neg18;
  rand uvm_reg_field lsb;
  rand uvm_reg_field ie18;
  rand uvm_reg_field ass18;

  constraint c_char_len18 { char_len18.value == 7'b0001000; }
  constraint c_tx_neg18 { tx_neg18.value == 1'b1; }
  constraint c_rx_neg18 { rx_neg18.value == 1'b1; }
  constraint c_lsb18 { lsb.value == 1'b1; }
  constraint c_ie18 { ie18.value == 1'b1; }
  constraint c_ass18 { ass18.value == 1'b1; }
  virtual function void build();
    char_len18 = uvm_reg_field::type_id::create("char_len18");
    char_len18.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
    go_bsy18 = uvm_reg_field::type_id::create("go_bsy18");
    go_bsy18.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
    rx_neg18 = uvm_reg_field::type_id::create("rx_neg18");
    rx_neg18.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
    tx_neg18 = uvm_reg_field::type_id::create("tx_neg18");
    tx_neg18.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
    lsb = uvm_reg_field::type_id::create("lsb");
    lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
    ie18 = uvm_reg_field::type_id::create("ie18");
    ie18.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
    ass18 = uvm_reg_field::type_id::create("ass18");
    ass18.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint char_len18.value[6:0];
    coverpoint go_bsy18.value[0:0];
    coverpoint rx_neg18.value[0:0];
    coverpoint tx_neg18.value[0:0];
    coverpoint lsb.value[0:0];
    coverpoint ie18.value[0:0];
    coverpoint ass18.value[0:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(spi_ctrl_c18, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ctrl_c18, uvm_reg)
  `uvm_object_utils(spi_ctrl_c18)
  function new(input string name="unnamed18-spi_ctrl_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : spi_ctrl_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 99


class spi_divider_c18 extends uvm_reg;

  rand uvm_reg_field divider18;

  constraint c_divider18 { divider18.value == 16'b1; }
  virtual function void build();
    divider18 = uvm_reg_field::type_id::create("divider18");
    divider18.configure(this, 16, 0, "RW", 0, `UVM_REG_DATA_WIDTH'hffff>>0, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint divider18.value[15:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(spi_divider_c18, uvm_reg_cbs) 
  `uvm_set_super_type(spi_divider_c18, uvm_reg)
  `uvm_object_utils(spi_divider_c18)
  function new(input string name="unnamed18-spi_divider_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : spi_divider_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 122


class spi_ss_c18 extends uvm_reg;

  rand uvm_reg_field ss;

  constraint c_ss18 { ss.value == 8'b1; }
  virtual function void build();
    ss = uvm_reg_field::type_id::create("ss");
    ss.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
  endfunction

  covergroup value_cg18;
    option.per_instance=1;
    coverpoint ss.value[7:0];
  endgroup
  
  virtual function void sample_values();
    super.sample_values();
    value_cg18.sample();
  endfunction

  `uvm_register_cb(spi_ss_c18, uvm_reg_cbs) 
  `uvm_set_super_type(spi_ss_c18, uvm_reg)
  `uvm_object_utils(spi_ss_c18)
  function new(input string name="unnamed18-spi_ss_c18");
    super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
    if(has_coverage(UVM_CVR_FIELD_VALS)) value_cg18=new;
  endfunction : new
endclass : spi_ss_c18

class spi_regfile18 extends uvm_reg_block;

  rand spi_ctrl_c18 spi_ctrl18;
  rand spi_divider_c18 spi_divider18;
  rand spi_ss_c18 spi_ss18;

  virtual function void build();

    // Now18 create all registers

    spi_ctrl18 = spi_ctrl_c18::type_id::create("spi_ctrl18", , get_full_name());
    spi_divider18 = spi_divider_c18::type_id::create("spi_divider18", , get_full_name());
    spi_ss18 = spi_ss_c18::type_id::create("spi_ss18", , get_full_name());

    // Now18 build the registers. Set parent and hdl_paths

    spi_ctrl18.configure(this, null, "spi_ctrl_reg18");
    spi_ctrl18.build();
    spi_divider18.configure(this, null, "spi_divider_reg18");
    spi_divider18.build();
    spi_ss18.configure(this, null, "spi_ss_reg18");
    spi_ss18.build();
    // Now18 define address mappings18
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    default_map.add_reg(spi_ctrl18, `UVM_REG_ADDR_WIDTH'h10, "RW");
    default_map.add_reg(spi_divider18, `UVM_REG_ADDR_WIDTH'h14, "RW");
    default_map.add_reg(spi_ss18, `UVM_REG_ADDR_WIDTH'h18, "RW");
  endfunction

  `uvm_object_utils(spi_regfile18)
  function new(input string name="unnamed18-spi_rf18");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new
endclass : spi_regfile18

//////////////////////////////////////////////////////////////////////////////
// Address_map18 definition18
//////////////////////////////////////////////////////////////////////////////
class spi_reg_model_c18 extends uvm_reg_block;

  rand spi_regfile18 spi_rf18;

  function void build();
    // Now18 define address mappings18
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
    spi_rf18 = spi_regfile18::type_id::create("spi_rf18", , get_full_name());
    spi_rf18.configure(this, "rf218");
    spi_rf18.build();
    spi_rf18.lock_model();
    default_map.add_submap(spi_rf18.default_map, `UVM_REG_ADDR_WIDTH'h800000);
    set_hdl_path_root("apb_spi_addr_map_c18");
    this.lock_model();
  endfunction
  `uvm_object_utils(spi_reg_model_c18)
  function new(input string name="unnamed18-spi_reg_model_c18");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : spi_reg_model_c18

`endif // SPI_RDB_SV18
