// This17 file is generated17 using Cadence17 iregGen17 version17 1.05

`ifndef UART_CTRL_REGS_SV17
`define UART_CTRL_REGS_SV17

// Input17 File17: uart_ctrl_regs17.xml17

// Number17 of AddrMaps17 = 1
// Number17 of RegFiles17 = 1
// Number17 of Registers17 = 6
// Number17 of Memories17 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 262


class ua_div_latch0_c17 extends uvm_reg;

  rand uvm_reg_field div_val17;

  constraint c_div_val17 { div_val17.value == 1; }
  virtual function void build();
    div_val17 = uvm_reg_field::type_id::create("div_val17");
    div_val17.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg17.set_inst_name($sformatf("%s.wcov17", get_full_name()));
    rd_cg17.set_inst_name($sformatf("%s.rcov17", get_full_name()));
  endfunction

  covergroup wr_cg17;
    option.per_instance=1;
    div_val17 : coverpoint div_val17.value[7:0];
  endgroup
  covergroup rd_cg17;
    option.per_instance=1;
    div_val17 : coverpoint div_val17.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg17.sample();
    if(is_read) rd_cg17.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c17, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c17, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c17)
  function new(input string name="unnamed17-ua_div_latch0_c17");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg17=new;
    rd_cg17=new;
  endfunction : new
endclass : ua_div_latch0_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 287


class ua_div_latch1_c17 extends uvm_reg;

  rand uvm_reg_field div_val17;

  constraint c_div_val17 { div_val17.value == 0; }
  virtual function void build();
    div_val17 = uvm_reg_field::type_id::create("div_val17");
    div_val17.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg17.set_inst_name($sformatf("%s.wcov17", get_full_name()));
    rd_cg17.set_inst_name($sformatf("%s.rcov17", get_full_name()));
  endfunction

  covergroup wr_cg17;
    option.per_instance=1;
    div_val17 : coverpoint div_val17.value[7:0];
  endgroup
  covergroup rd_cg17;
    option.per_instance=1;
    div_val17 : coverpoint div_val17.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg17.sample();
    if(is_read) rd_cg17.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c17, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c17, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c17)
  function new(input string name="unnamed17-ua_div_latch1_c17");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg17=new;
    rd_cg17=new;
  endfunction : new
endclass : ua_div_latch1_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 82


class ua_int_id_c17 extends uvm_reg;

  uvm_reg_field priority_bit17;
  uvm_reg_field bit117;
  uvm_reg_field bit217;
  uvm_reg_field bit317;

  virtual function void build();
    priority_bit17 = uvm_reg_field::type_id::create("priority_bit17");
    priority_bit17.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit117 = uvm_reg_field::type_id::create("bit117");
    bit117.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit217 = uvm_reg_field::type_id::create("bit217");
    bit217.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit317 = uvm_reg_field::type_id::create("bit317");
    bit317.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg17.set_inst_name($sformatf("%s.rcov17", get_full_name()));
  endfunction

  covergroup rd_cg17;
    option.per_instance=1;
    priority_bit17 : coverpoint priority_bit17.value[0:0];
    bit117 : coverpoint bit117.value[0:0];
    bit217 : coverpoint bit217.value[0:0];
    bit317 : coverpoint bit317.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg17.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c17, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c17, uvm_reg)
  `uvm_object_utils(ua_int_id_c17)
  function new(input string name="unnamed17-ua_int_id_c17");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg17=new;
  endfunction : new
endclass : ua_int_id_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 139


class ua_fifo_ctrl_c17 extends uvm_reg;

  rand uvm_reg_field rx_clear17;
  rand uvm_reg_field tx_clear17;
  rand uvm_reg_field rx_fifo_int_trig_level17;

  virtual function void build();
    rx_clear17 = uvm_reg_field::type_id::create("rx_clear17");
    rx_clear17.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear17 = uvm_reg_field::type_id::create("tx_clear17");
    tx_clear17.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level17 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level17");
    rx_fifo_int_trig_level17.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg17.set_inst_name($sformatf("%s.wcov17", get_full_name()));
  endfunction

  covergroup wr_cg17;
    option.per_instance=1;
    rx_clear17 : coverpoint rx_clear17.value[0:0];
    tx_clear17 : coverpoint tx_clear17.value[0:0];
    rx_fifo_int_trig_level17 : coverpoint rx_fifo_int_trig_level17.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg17.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c17, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c17, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c17)
  function new(input string name="unnamed17-ua_fifo_ctrl_c17");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg17=new;
  endfunction : new
endclass : ua_fifo_ctrl_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 188


class ua_lcr_c17 extends uvm_reg;

  rand uvm_reg_field char_lngth17;
  rand uvm_reg_field num_stop_bits17;
  rand uvm_reg_field p_en17;
  rand uvm_reg_field parity_even17;
  rand uvm_reg_field parity_sticky17;
  rand uvm_reg_field break_ctrl17;
  rand uvm_reg_field div_latch_access17;

  constraint c_char_lngth17 { char_lngth17.value != 2'b00; }
  constraint c_break_ctrl17 { break_ctrl17.value == 1'b0; }
  virtual function void build();
    char_lngth17 = uvm_reg_field::type_id::create("char_lngth17");
    char_lngth17.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits17 = uvm_reg_field::type_id::create("num_stop_bits17");
    num_stop_bits17.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en17 = uvm_reg_field::type_id::create("p_en17");
    p_en17.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even17 = uvm_reg_field::type_id::create("parity_even17");
    parity_even17.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky17 = uvm_reg_field::type_id::create("parity_sticky17");
    parity_sticky17.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl17 = uvm_reg_field::type_id::create("break_ctrl17");
    break_ctrl17.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access17 = uvm_reg_field::type_id::create("div_latch_access17");
    div_latch_access17.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg17.set_inst_name($sformatf("%s.wcov17", get_full_name()));
    rd_cg17.set_inst_name($sformatf("%s.rcov17", get_full_name()));
  endfunction

  covergroup wr_cg17;
    option.per_instance=1;
    char_lngth17 : coverpoint char_lngth17.value[1:0];
    num_stop_bits17 : coverpoint num_stop_bits17.value[0:0];
    p_en17 : coverpoint p_en17.value[0:0];
    parity_even17 : coverpoint parity_even17.value[0:0];
    parity_sticky17 : coverpoint parity_sticky17.value[0:0];
    break_ctrl17 : coverpoint break_ctrl17.value[0:0];
    div_latch_access17 : coverpoint div_latch_access17.value[0:0];
  endgroup
  covergroup rd_cg17;
    option.per_instance=1;
    char_lngth17 : coverpoint char_lngth17.value[1:0];
    num_stop_bits17 : coverpoint num_stop_bits17.value[0:0];
    p_en17 : coverpoint p_en17.value[0:0];
    parity_even17 : coverpoint parity_even17.value[0:0];
    parity_sticky17 : coverpoint parity_sticky17.value[0:0];
    break_ctrl17 : coverpoint break_ctrl17.value[0:0];
    div_latch_access17 : coverpoint div_latch_access17.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg17.sample();
    if(is_read) rd_cg17.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c17, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c17, uvm_reg)
  `uvm_object_utils(ua_lcr_c17)
  function new(input string name="unnamed17-ua_lcr_c17");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg17=new;
    rd_cg17=new;
  endfunction : new
endclass : ua_lcr_c17

//////////////////////////////////////////////////////////////////////////////
// Register definition17
//////////////////////////////////////////////////////////////////////////////
// Line17 Number17: 25


class ua_ier_c17 extends uvm_reg;

  rand uvm_reg_field rx_data17;
  rand uvm_reg_field tx_data17;
  rand uvm_reg_field rx_line_sts17;
  rand uvm_reg_field mdm_sts17;

  virtual function void build();
    rx_data17 = uvm_reg_field::type_id::create("rx_data17");
    rx_data17.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data17 = uvm_reg_field::type_id::create("tx_data17");
    tx_data17.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts17 = uvm_reg_field::type_id::create("rx_line_sts17");
    rx_line_sts17.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts17 = uvm_reg_field::type_id::create("mdm_sts17");
    mdm_sts17.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg17.set_inst_name($sformatf("%s.wcov17", get_full_name()));
    rd_cg17.set_inst_name($sformatf("%s.rcov17", get_full_name()));
  endfunction

  covergroup wr_cg17;
    option.per_instance=1;
    rx_data17 : coverpoint rx_data17.value[0:0];
    tx_data17 : coverpoint tx_data17.value[0:0];
    rx_line_sts17 : coverpoint rx_line_sts17.value[0:0];
    mdm_sts17 : coverpoint mdm_sts17.value[0:0];
  endgroup
  covergroup rd_cg17;
    option.per_instance=1;
    rx_data17 : coverpoint rx_data17.value[0:0];
    tx_data17 : coverpoint tx_data17.value[0:0];
    rx_line_sts17 : coverpoint rx_line_sts17.value[0:0];
    mdm_sts17 : coverpoint mdm_sts17.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg17.sample();
    if(is_read) rd_cg17.sample();
  endfunction

  `uvm_register_cb(ua_ier_c17, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c17, uvm_reg)
  `uvm_object_utils(ua_ier_c17)
  function new(input string name="unnamed17-ua_ier_c17");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg17=new;
    rd_cg17=new;
  endfunction : new
endclass : ua_ier_c17

class uart_ctrl_rf_c17 extends uvm_reg_block;

  rand ua_div_latch0_c17 ua_div_latch017;
  rand ua_div_latch1_c17 ua_div_latch117;
  rand ua_int_id_c17 ua_int_id17;
  rand ua_fifo_ctrl_c17 ua_fifo_ctrl17;
  rand ua_lcr_c17 ua_lcr17;
  rand ua_ier_c17 ua_ier17;

  virtual function void build();

    // Now17 create all registers

    ua_div_latch017 = ua_div_latch0_c17::type_id::create("ua_div_latch017", , get_full_name());
    ua_div_latch117 = ua_div_latch1_c17::type_id::create("ua_div_latch117", , get_full_name());
    ua_int_id17 = ua_int_id_c17::type_id::create("ua_int_id17", , get_full_name());
    ua_fifo_ctrl17 = ua_fifo_ctrl_c17::type_id::create("ua_fifo_ctrl17", , get_full_name());
    ua_lcr17 = ua_lcr_c17::type_id::create("ua_lcr17", , get_full_name());
    ua_ier17 = ua_ier_c17::type_id::create("ua_ier17", , get_full_name());

    // Now17 build the registers. Set parent and hdl_paths

    ua_div_latch017.configure(this, null, "dl17[7:0]");
    ua_div_latch017.build();
    ua_div_latch117.configure(this, null, "dl17[15;8]");
    ua_div_latch117.build();
    ua_int_id17.configure(this, null, "iir17");
    ua_int_id17.build();
    ua_fifo_ctrl17.configure(this, null, "fcr17");
    ua_fifo_ctrl17.build();
    ua_lcr17.configure(this, null, "lcr17");
    ua_lcr17.build();
    ua_ier17.configure(this, null, "ier17");
    ua_ier17.build();
    // Now17 define address mappings17
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch017, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch117, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id17, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl17, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr17, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier17, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c17)
  function new(input string name="unnamed17-uart_ctrl_rf17");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c17

//////////////////////////////////////////////////////////////////////////////
// Address_map17 definition17
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c17 extends uvm_reg_block;

  rand uart_ctrl_rf_c17 uart_ctrl_rf17;

  function void build();
    // Now17 define address mappings17
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf17 = uart_ctrl_rf_c17::type_id::create("uart_ctrl_rf17", , get_full_name());
    uart_ctrl_rf17.configure(this, "regs");
    uart_ctrl_rf17.build();
    uart_ctrl_rf17.lock_model();
    default_map.add_submap(uart_ctrl_rf17.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top17.uart_dut17");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c17)
  function new(input string name="unnamed17-uart_ctrl_reg_model_c17");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c17

`endif // UART_CTRL_REGS_SV17
