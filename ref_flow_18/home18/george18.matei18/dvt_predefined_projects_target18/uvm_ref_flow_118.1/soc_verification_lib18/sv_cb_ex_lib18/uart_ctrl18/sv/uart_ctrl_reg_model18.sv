// This18 file is generated18 using Cadence18 iregGen18 version18 1.05

`ifndef UART_CTRL_REGS_SV18
`define UART_CTRL_REGS_SV18

// Input18 File18: uart_ctrl_regs18.xml18

// Number18 of AddrMaps18 = 1
// Number18 of RegFiles18 = 1
// Number18 of Registers18 = 6
// Number18 of Memories18 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 262


class ua_div_latch0_c18 extends uvm_reg;

  rand uvm_reg_field div_val18;

  constraint c_div_val18 { div_val18.value == 1; }
  virtual function void build();
    div_val18 = uvm_reg_field::type_id::create("div_val18");
    div_val18.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg18.set_inst_name($sformatf("%s.wcov18", get_full_name()));
    rd_cg18.set_inst_name($sformatf("%s.rcov18", get_full_name()));
  endfunction

  covergroup wr_cg18;
    option.per_instance=1;
    div_val18 : coverpoint div_val18.value[7:0];
  endgroup
  covergroup rd_cg18;
    option.per_instance=1;
    div_val18 : coverpoint div_val18.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg18.sample();
    if(is_read) rd_cg18.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c18, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c18, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c18)
  function new(input string name="unnamed18-ua_div_latch0_c18");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg18=new;
    rd_cg18=new;
  endfunction : new
endclass : ua_div_latch0_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 287


class ua_div_latch1_c18 extends uvm_reg;

  rand uvm_reg_field div_val18;

  constraint c_div_val18 { div_val18.value == 0; }
  virtual function void build();
    div_val18 = uvm_reg_field::type_id::create("div_val18");
    div_val18.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg18.set_inst_name($sformatf("%s.wcov18", get_full_name()));
    rd_cg18.set_inst_name($sformatf("%s.rcov18", get_full_name()));
  endfunction

  covergroup wr_cg18;
    option.per_instance=1;
    div_val18 : coverpoint div_val18.value[7:0];
  endgroup
  covergroup rd_cg18;
    option.per_instance=1;
    div_val18 : coverpoint div_val18.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg18.sample();
    if(is_read) rd_cg18.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c18, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c18, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c18)
  function new(input string name="unnamed18-ua_div_latch1_c18");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg18=new;
    rd_cg18=new;
  endfunction : new
endclass : ua_div_latch1_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 82


class ua_int_id_c18 extends uvm_reg;

  uvm_reg_field priority_bit18;
  uvm_reg_field bit118;
  uvm_reg_field bit218;
  uvm_reg_field bit318;

  virtual function void build();
    priority_bit18 = uvm_reg_field::type_id::create("priority_bit18");
    priority_bit18.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit118 = uvm_reg_field::type_id::create("bit118");
    bit118.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit218 = uvm_reg_field::type_id::create("bit218");
    bit218.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit318 = uvm_reg_field::type_id::create("bit318");
    bit318.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg18.set_inst_name($sformatf("%s.rcov18", get_full_name()));
  endfunction

  covergroup rd_cg18;
    option.per_instance=1;
    priority_bit18 : coverpoint priority_bit18.value[0:0];
    bit118 : coverpoint bit118.value[0:0];
    bit218 : coverpoint bit218.value[0:0];
    bit318 : coverpoint bit318.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg18.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c18, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c18, uvm_reg)
  `uvm_object_utils(ua_int_id_c18)
  function new(input string name="unnamed18-ua_int_id_c18");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg18=new;
  endfunction : new
endclass : ua_int_id_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 139


class ua_fifo_ctrl_c18 extends uvm_reg;

  rand uvm_reg_field rx_clear18;
  rand uvm_reg_field tx_clear18;
  rand uvm_reg_field rx_fifo_int_trig_level18;

  virtual function void build();
    rx_clear18 = uvm_reg_field::type_id::create("rx_clear18");
    rx_clear18.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear18 = uvm_reg_field::type_id::create("tx_clear18");
    tx_clear18.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level18 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level18");
    rx_fifo_int_trig_level18.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg18.set_inst_name($sformatf("%s.wcov18", get_full_name()));
  endfunction

  covergroup wr_cg18;
    option.per_instance=1;
    rx_clear18 : coverpoint rx_clear18.value[0:0];
    tx_clear18 : coverpoint tx_clear18.value[0:0];
    rx_fifo_int_trig_level18 : coverpoint rx_fifo_int_trig_level18.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg18.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c18, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c18, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c18)
  function new(input string name="unnamed18-ua_fifo_ctrl_c18");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg18=new;
  endfunction : new
endclass : ua_fifo_ctrl_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 188


class ua_lcr_c18 extends uvm_reg;

  rand uvm_reg_field char_lngth18;
  rand uvm_reg_field num_stop_bits18;
  rand uvm_reg_field p_en18;
  rand uvm_reg_field parity_even18;
  rand uvm_reg_field parity_sticky18;
  rand uvm_reg_field break_ctrl18;
  rand uvm_reg_field div_latch_access18;

  constraint c_char_lngth18 { char_lngth18.value != 2'b00; }
  constraint c_break_ctrl18 { break_ctrl18.value == 1'b0; }
  virtual function void build();
    char_lngth18 = uvm_reg_field::type_id::create("char_lngth18");
    char_lngth18.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits18 = uvm_reg_field::type_id::create("num_stop_bits18");
    num_stop_bits18.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en18 = uvm_reg_field::type_id::create("p_en18");
    p_en18.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even18 = uvm_reg_field::type_id::create("parity_even18");
    parity_even18.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky18 = uvm_reg_field::type_id::create("parity_sticky18");
    parity_sticky18.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl18 = uvm_reg_field::type_id::create("break_ctrl18");
    break_ctrl18.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access18 = uvm_reg_field::type_id::create("div_latch_access18");
    div_latch_access18.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg18.set_inst_name($sformatf("%s.wcov18", get_full_name()));
    rd_cg18.set_inst_name($sformatf("%s.rcov18", get_full_name()));
  endfunction

  covergroup wr_cg18;
    option.per_instance=1;
    char_lngth18 : coverpoint char_lngth18.value[1:0];
    num_stop_bits18 : coverpoint num_stop_bits18.value[0:0];
    p_en18 : coverpoint p_en18.value[0:0];
    parity_even18 : coverpoint parity_even18.value[0:0];
    parity_sticky18 : coverpoint parity_sticky18.value[0:0];
    break_ctrl18 : coverpoint break_ctrl18.value[0:0];
    div_latch_access18 : coverpoint div_latch_access18.value[0:0];
  endgroup
  covergroup rd_cg18;
    option.per_instance=1;
    char_lngth18 : coverpoint char_lngth18.value[1:0];
    num_stop_bits18 : coverpoint num_stop_bits18.value[0:0];
    p_en18 : coverpoint p_en18.value[0:0];
    parity_even18 : coverpoint parity_even18.value[0:0];
    parity_sticky18 : coverpoint parity_sticky18.value[0:0];
    break_ctrl18 : coverpoint break_ctrl18.value[0:0];
    div_latch_access18 : coverpoint div_latch_access18.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg18.sample();
    if(is_read) rd_cg18.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c18, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c18, uvm_reg)
  `uvm_object_utils(ua_lcr_c18)
  function new(input string name="unnamed18-ua_lcr_c18");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg18=new;
    rd_cg18=new;
  endfunction : new
endclass : ua_lcr_c18

//////////////////////////////////////////////////////////////////////////////
// Register definition18
//////////////////////////////////////////////////////////////////////////////
// Line18 Number18: 25


class ua_ier_c18 extends uvm_reg;

  rand uvm_reg_field rx_data18;
  rand uvm_reg_field tx_data18;
  rand uvm_reg_field rx_line_sts18;
  rand uvm_reg_field mdm_sts18;

  virtual function void build();
    rx_data18 = uvm_reg_field::type_id::create("rx_data18");
    rx_data18.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data18 = uvm_reg_field::type_id::create("tx_data18");
    tx_data18.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts18 = uvm_reg_field::type_id::create("rx_line_sts18");
    rx_line_sts18.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts18 = uvm_reg_field::type_id::create("mdm_sts18");
    mdm_sts18.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg18.set_inst_name($sformatf("%s.wcov18", get_full_name()));
    rd_cg18.set_inst_name($sformatf("%s.rcov18", get_full_name()));
  endfunction

  covergroup wr_cg18;
    option.per_instance=1;
    rx_data18 : coverpoint rx_data18.value[0:0];
    tx_data18 : coverpoint tx_data18.value[0:0];
    rx_line_sts18 : coverpoint rx_line_sts18.value[0:0];
    mdm_sts18 : coverpoint mdm_sts18.value[0:0];
  endgroup
  covergroup rd_cg18;
    option.per_instance=1;
    rx_data18 : coverpoint rx_data18.value[0:0];
    tx_data18 : coverpoint tx_data18.value[0:0];
    rx_line_sts18 : coverpoint rx_line_sts18.value[0:0];
    mdm_sts18 : coverpoint mdm_sts18.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg18.sample();
    if(is_read) rd_cg18.sample();
  endfunction

  `uvm_register_cb(ua_ier_c18, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c18, uvm_reg)
  `uvm_object_utils(ua_ier_c18)
  function new(input string name="unnamed18-ua_ier_c18");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg18=new;
    rd_cg18=new;
  endfunction : new
endclass : ua_ier_c18

class uart_ctrl_rf_c18 extends uvm_reg_block;

  rand ua_div_latch0_c18 ua_div_latch018;
  rand ua_div_latch1_c18 ua_div_latch118;
  rand ua_int_id_c18 ua_int_id18;
  rand ua_fifo_ctrl_c18 ua_fifo_ctrl18;
  rand ua_lcr_c18 ua_lcr18;
  rand ua_ier_c18 ua_ier18;

  virtual function void build();

    // Now18 create all registers

    ua_div_latch018 = ua_div_latch0_c18::type_id::create("ua_div_latch018", , get_full_name());
    ua_div_latch118 = ua_div_latch1_c18::type_id::create("ua_div_latch118", , get_full_name());
    ua_int_id18 = ua_int_id_c18::type_id::create("ua_int_id18", , get_full_name());
    ua_fifo_ctrl18 = ua_fifo_ctrl_c18::type_id::create("ua_fifo_ctrl18", , get_full_name());
    ua_lcr18 = ua_lcr_c18::type_id::create("ua_lcr18", , get_full_name());
    ua_ier18 = ua_ier_c18::type_id::create("ua_ier18", , get_full_name());

    // Now18 build the registers. Set parent and hdl_paths

    ua_div_latch018.configure(this, null, "dl18[7:0]");
    ua_div_latch018.build();
    ua_div_latch118.configure(this, null, "dl18[15;8]");
    ua_div_latch118.build();
    ua_int_id18.configure(this, null, "iir18");
    ua_int_id18.build();
    ua_fifo_ctrl18.configure(this, null, "fcr18");
    ua_fifo_ctrl18.build();
    ua_lcr18.configure(this, null, "lcr18");
    ua_lcr18.build();
    ua_ier18.configure(this, null, "ier18");
    ua_ier18.build();
    // Now18 define address mappings18
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch018, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch118, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id18, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl18, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr18, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier18, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c18)
  function new(input string name="unnamed18-uart_ctrl_rf18");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c18

//////////////////////////////////////////////////////////////////////////////
// Address_map18 definition18
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c18 extends uvm_reg_block;

  rand uart_ctrl_rf_c18 uart_ctrl_rf18;

  function void build();
    // Now18 define address mappings18
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf18 = uart_ctrl_rf_c18::type_id::create("uart_ctrl_rf18", , get_full_name());
    uart_ctrl_rf18.configure(this, "regs");
    uart_ctrl_rf18.build();
    uart_ctrl_rf18.lock_model();
    default_map.add_submap(uart_ctrl_rf18.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top18.uart_dut18");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c18)
  function new(input string name="unnamed18-uart_ctrl_reg_model_c18");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c18

`endif // UART_CTRL_REGS_SV18
