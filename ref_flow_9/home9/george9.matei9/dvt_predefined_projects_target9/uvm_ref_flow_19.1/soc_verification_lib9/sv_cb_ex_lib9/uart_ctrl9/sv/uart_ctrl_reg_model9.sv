// This9 file is generated9 using Cadence9 iregGen9 version9 1.05

`ifndef UART_CTRL_REGS_SV9
`define UART_CTRL_REGS_SV9

// Input9 File9: uart_ctrl_regs9.xml9

// Number9 of AddrMaps9 = 1
// Number9 of RegFiles9 = 1
// Number9 of Registers9 = 6
// Number9 of Memories9 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 262


class ua_div_latch0_c9 extends uvm_reg;

  rand uvm_reg_field div_val9;

  constraint c_div_val9 { div_val9.value == 1; }
  virtual function void build();
    div_val9 = uvm_reg_field::type_id::create("div_val9");
    div_val9.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg9.set_inst_name($sformatf("%s.wcov9", get_full_name()));
    rd_cg9.set_inst_name($sformatf("%s.rcov9", get_full_name()));
  endfunction

  covergroup wr_cg9;
    option.per_instance=1;
    div_val9 : coverpoint div_val9.value[7:0];
  endgroup
  covergroup rd_cg9;
    option.per_instance=1;
    div_val9 : coverpoint div_val9.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg9.sample();
    if(is_read) rd_cg9.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c9, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c9, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c9)
  function new(input string name="unnamed9-ua_div_latch0_c9");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg9=new;
    rd_cg9=new;
  endfunction : new
endclass : ua_div_latch0_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 287


class ua_div_latch1_c9 extends uvm_reg;

  rand uvm_reg_field div_val9;

  constraint c_div_val9 { div_val9.value == 0; }
  virtual function void build();
    div_val9 = uvm_reg_field::type_id::create("div_val9");
    div_val9.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg9.set_inst_name($sformatf("%s.wcov9", get_full_name()));
    rd_cg9.set_inst_name($sformatf("%s.rcov9", get_full_name()));
  endfunction

  covergroup wr_cg9;
    option.per_instance=1;
    div_val9 : coverpoint div_val9.value[7:0];
  endgroup
  covergroup rd_cg9;
    option.per_instance=1;
    div_val9 : coverpoint div_val9.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg9.sample();
    if(is_read) rd_cg9.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c9, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c9, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c9)
  function new(input string name="unnamed9-ua_div_latch1_c9");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg9=new;
    rd_cg9=new;
  endfunction : new
endclass : ua_div_latch1_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 82


class ua_int_id_c9 extends uvm_reg;

  uvm_reg_field priority_bit9;
  uvm_reg_field bit19;
  uvm_reg_field bit29;
  uvm_reg_field bit39;

  virtual function void build();
    priority_bit9 = uvm_reg_field::type_id::create("priority_bit9");
    priority_bit9.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit19 = uvm_reg_field::type_id::create("bit19");
    bit19.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit29 = uvm_reg_field::type_id::create("bit29");
    bit29.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit39 = uvm_reg_field::type_id::create("bit39");
    bit39.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg9.set_inst_name($sformatf("%s.rcov9", get_full_name()));
  endfunction

  covergroup rd_cg9;
    option.per_instance=1;
    priority_bit9 : coverpoint priority_bit9.value[0:0];
    bit19 : coverpoint bit19.value[0:0];
    bit29 : coverpoint bit29.value[0:0];
    bit39 : coverpoint bit39.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg9.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c9, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c9, uvm_reg)
  `uvm_object_utils(ua_int_id_c9)
  function new(input string name="unnamed9-ua_int_id_c9");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg9=new;
  endfunction : new
endclass : ua_int_id_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 139


class ua_fifo_ctrl_c9 extends uvm_reg;

  rand uvm_reg_field rx_clear9;
  rand uvm_reg_field tx_clear9;
  rand uvm_reg_field rx_fifo_int_trig_level9;

  virtual function void build();
    rx_clear9 = uvm_reg_field::type_id::create("rx_clear9");
    rx_clear9.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear9 = uvm_reg_field::type_id::create("tx_clear9");
    tx_clear9.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level9 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level9");
    rx_fifo_int_trig_level9.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg9.set_inst_name($sformatf("%s.wcov9", get_full_name()));
  endfunction

  covergroup wr_cg9;
    option.per_instance=1;
    rx_clear9 : coverpoint rx_clear9.value[0:0];
    tx_clear9 : coverpoint tx_clear9.value[0:0];
    rx_fifo_int_trig_level9 : coverpoint rx_fifo_int_trig_level9.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg9.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c9, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c9, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c9)
  function new(input string name="unnamed9-ua_fifo_ctrl_c9");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg9=new;
  endfunction : new
endclass : ua_fifo_ctrl_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 188


class ua_lcr_c9 extends uvm_reg;

  rand uvm_reg_field char_lngth9;
  rand uvm_reg_field num_stop_bits9;
  rand uvm_reg_field p_en9;
  rand uvm_reg_field parity_even9;
  rand uvm_reg_field parity_sticky9;
  rand uvm_reg_field break_ctrl9;
  rand uvm_reg_field div_latch_access9;

  constraint c_char_lngth9 { char_lngth9.value != 2'b00; }
  constraint c_break_ctrl9 { break_ctrl9.value == 1'b0; }
  virtual function void build();
    char_lngth9 = uvm_reg_field::type_id::create("char_lngth9");
    char_lngth9.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits9 = uvm_reg_field::type_id::create("num_stop_bits9");
    num_stop_bits9.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en9 = uvm_reg_field::type_id::create("p_en9");
    p_en9.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even9 = uvm_reg_field::type_id::create("parity_even9");
    parity_even9.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky9 = uvm_reg_field::type_id::create("parity_sticky9");
    parity_sticky9.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl9 = uvm_reg_field::type_id::create("break_ctrl9");
    break_ctrl9.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access9 = uvm_reg_field::type_id::create("div_latch_access9");
    div_latch_access9.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg9.set_inst_name($sformatf("%s.wcov9", get_full_name()));
    rd_cg9.set_inst_name($sformatf("%s.rcov9", get_full_name()));
  endfunction

  covergroup wr_cg9;
    option.per_instance=1;
    char_lngth9 : coverpoint char_lngth9.value[1:0];
    num_stop_bits9 : coverpoint num_stop_bits9.value[0:0];
    p_en9 : coverpoint p_en9.value[0:0];
    parity_even9 : coverpoint parity_even9.value[0:0];
    parity_sticky9 : coverpoint parity_sticky9.value[0:0];
    break_ctrl9 : coverpoint break_ctrl9.value[0:0];
    div_latch_access9 : coverpoint div_latch_access9.value[0:0];
  endgroup
  covergroup rd_cg9;
    option.per_instance=1;
    char_lngth9 : coverpoint char_lngth9.value[1:0];
    num_stop_bits9 : coverpoint num_stop_bits9.value[0:0];
    p_en9 : coverpoint p_en9.value[0:0];
    parity_even9 : coverpoint parity_even9.value[0:0];
    parity_sticky9 : coverpoint parity_sticky9.value[0:0];
    break_ctrl9 : coverpoint break_ctrl9.value[0:0];
    div_latch_access9 : coverpoint div_latch_access9.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg9.sample();
    if(is_read) rd_cg9.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c9, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c9, uvm_reg)
  `uvm_object_utils(ua_lcr_c9)
  function new(input string name="unnamed9-ua_lcr_c9");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg9=new;
    rd_cg9=new;
  endfunction : new
endclass : ua_lcr_c9

//////////////////////////////////////////////////////////////////////////////
// Register definition9
//////////////////////////////////////////////////////////////////////////////
// Line9 Number9: 25


class ua_ier_c9 extends uvm_reg;

  rand uvm_reg_field rx_data9;
  rand uvm_reg_field tx_data9;
  rand uvm_reg_field rx_line_sts9;
  rand uvm_reg_field mdm_sts9;

  virtual function void build();
    rx_data9 = uvm_reg_field::type_id::create("rx_data9");
    rx_data9.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data9 = uvm_reg_field::type_id::create("tx_data9");
    tx_data9.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts9 = uvm_reg_field::type_id::create("rx_line_sts9");
    rx_line_sts9.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts9 = uvm_reg_field::type_id::create("mdm_sts9");
    mdm_sts9.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg9.set_inst_name($sformatf("%s.wcov9", get_full_name()));
    rd_cg9.set_inst_name($sformatf("%s.rcov9", get_full_name()));
  endfunction

  covergroup wr_cg9;
    option.per_instance=1;
    rx_data9 : coverpoint rx_data9.value[0:0];
    tx_data9 : coverpoint tx_data9.value[0:0];
    rx_line_sts9 : coverpoint rx_line_sts9.value[0:0];
    mdm_sts9 : coverpoint mdm_sts9.value[0:0];
  endgroup
  covergroup rd_cg9;
    option.per_instance=1;
    rx_data9 : coverpoint rx_data9.value[0:0];
    tx_data9 : coverpoint tx_data9.value[0:0];
    rx_line_sts9 : coverpoint rx_line_sts9.value[0:0];
    mdm_sts9 : coverpoint mdm_sts9.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg9.sample();
    if(is_read) rd_cg9.sample();
  endfunction

  `uvm_register_cb(ua_ier_c9, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c9, uvm_reg)
  `uvm_object_utils(ua_ier_c9)
  function new(input string name="unnamed9-ua_ier_c9");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg9=new;
    rd_cg9=new;
  endfunction : new
endclass : ua_ier_c9

class uart_ctrl_rf_c9 extends uvm_reg_block;

  rand ua_div_latch0_c9 ua_div_latch09;
  rand ua_div_latch1_c9 ua_div_latch19;
  rand ua_int_id_c9 ua_int_id9;
  rand ua_fifo_ctrl_c9 ua_fifo_ctrl9;
  rand ua_lcr_c9 ua_lcr9;
  rand ua_ier_c9 ua_ier9;

  virtual function void build();

    // Now9 create all registers

    ua_div_latch09 = ua_div_latch0_c9::type_id::create("ua_div_latch09", , get_full_name());
    ua_div_latch19 = ua_div_latch1_c9::type_id::create("ua_div_latch19", , get_full_name());
    ua_int_id9 = ua_int_id_c9::type_id::create("ua_int_id9", , get_full_name());
    ua_fifo_ctrl9 = ua_fifo_ctrl_c9::type_id::create("ua_fifo_ctrl9", , get_full_name());
    ua_lcr9 = ua_lcr_c9::type_id::create("ua_lcr9", , get_full_name());
    ua_ier9 = ua_ier_c9::type_id::create("ua_ier9", , get_full_name());

    // Now9 build the registers. Set parent and hdl_paths

    ua_div_latch09.configure(this, null, "dl9[7:0]");
    ua_div_latch09.build();
    ua_div_latch19.configure(this, null, "dl9[15;8]");
    ua_div_latch19.build();
    ua_int_id9.configure(this, null, "iir9");
    ua_int_id9.build();
    ua_fifo_ctrl9.configure(this, null, "fcr9");
    ua_fifo_ctrl9.build();
    ua_lcr9.configure(this, null, "lcr9");
    ua_lcr9.build();
    ua_ier9.configure(this, null, "ier9");
    ua_ier9.build();
    // Now9 define address mappings9
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch09, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch19, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id9, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl9, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr9, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier9, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c9)
  function new(input string name="unnamed9-uart_ctrl_rf9");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c9

//////////////////////////////////////////////////////////////////////////////
// Address_map9 definition9
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c9 extends uvm_reg_block;

  rand uart_ctrl_rf_c9 uart_ctrl_rf9;

  function void build();
    // Now9 define address mappings9
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf9 = uart_ctrl_rf_c9::type_id::create("uart_ctrl_rf9", , get_full_name());
    uart_ctrl_rf9.configure(this, "regs");
    uart_ctrl_rf9.build();
    uart_ctrl_rf9.lock_model();
    default_map.add_submap(uart_ctrl_rf9.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top9.uart_dut9");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c9)
  function new(input string name="unnamed9-uart_ctrl_reg_model_c9");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c9

`endif // UART_CTRL_REGS_SV9
