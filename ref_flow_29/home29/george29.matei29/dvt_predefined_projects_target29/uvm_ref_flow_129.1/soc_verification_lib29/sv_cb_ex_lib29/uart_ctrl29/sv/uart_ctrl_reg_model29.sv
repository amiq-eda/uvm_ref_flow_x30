// This29 file is generated29 using Cadence29 iregGen29 version29 1.05

`ifndef UART_CTRL_REGS_SV29
`define UART_CTRL_REGS_SV29

// Input29 File29: uart_ctrl_regs29.xml29

// Number29 of AddrMaps29 = 1
// Number29 of RegFiles29 = 1
// Number29 of Registers29 = 6
// Number29 of Memories29 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 262


class ua_div_latch0_c29 extends uvm_reg;

  rand uvm_reg_field div_val29;

  constraint c_div_val29 { div_val29.value == 1; }
  virtual function void build();
    div_val29 = uvm_reg_field::type_id::create("div_val29");
    div_val29.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg29.set_inst_name($sformatf("%s.wcov29", get_full_name()));
    rd_cg29.set_inst_name($sformatf("%s.rcov29", get_full_name()));
  endfunction

  covergroup wr_cg29;
    option.per_instance=1;
    div_val29 : coverpoint div_val29.value[7:0];
  endgroup
  covergroup rd_cg29;
    option.per_instance=1;
    div_val29 : coverpoint div_val29.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg29.sample();
    if(is_read) rd_cg29.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c29, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c29, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c29)
  function new(input string name="unnamed29-ua_div_latch0_c29");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg29=new;
    rd_cg29=new;
  endfunction : new
endclass : ua_div_latch0_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 287


class ua_div_latch1_c29 extends uvm_reg;

  rand uvm_reg_field div_val29;

  constraint c_div_val29 { div_val29.value == 0; }
  virtual function void build();
    div_val29 = uvm_reg_field::type_id::create("div_val29");
    div_val29.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg29.set_inst_name($sformatf("%s.wcov29", get_full_name()));
    rd_cg29.set_inst_name($sformatf("%s.rcov29", get_full_name()));
  endfunction

  covergroup wr_cg29;
    option.per_instance=1;
    div_val29 : coverpoint div_val29.value[7:0];
  endgroup
  covergroup rd_cg29;
    option.per_instance=1;
    div_val29 : coverpoint div_val29.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg29.sample();
    if(is_read) rd_cg29.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c29, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c29, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c29)
  function new(input string name="unnamed29-ua_div_latch1_c29");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg29=new;
    rd_cg29=new;
  endfunction : new
endclass : ua_div_latch1_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 82


class ua_int_id_c29 extends uvm_reg;

  uvm_reg_field priority_bit29;
  uvm_reg_field bit129;
  uvm_reg_field bit229;
  uvm_reg_field bit329;

  virtual function void build();
    priority_bit29 = uvm_reg_field::type_id::create("priority_bit29");
    priority_bit29.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit129 = uvm_reg_field::type_id::create("bit129");
    bit129.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit229 = uvm_reg_field::type_id::create("bit229");
    bit229.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit329 = uvm_reg_field::type_id::create("bit329");
    bit329.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg29.set_inst_name($sformatf("%s.rcov29", get_full_name()));
  endfunction

  covergroup rd_cg29;
    option.per_instance=1;
    priority_bit29 : coverpoint priority_bit29.value[0:0];
    bit129 : coverpoint bit129.value[0:0];
    bit229 : coverpoint bit229.value[0:0];
    bit329 : coverpoint bit329.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg29.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c29, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c29, uvm_reg)
  `uvm_object_utils(ua_int_id_c29)
  function new(input string name="unnamed29-ua_int_id_c29");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg29=new;
  endfunction : new
endclass : ua_int_id_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 139


class ua_fifo_ctrl_c29 extends uvm_reg;

  rand uvm_reg_field rx_clear29;
  rand uvm_reg_field tx_clear29;
  rand uvm_reg_field rx_fifo_int_trig_level29;

  virtual function void build();
    rx_clear29 = uvm_reg_field::type_id::create("rx_clear29");
    rx_clear29.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear29 = uvm_reg_field::type_id::create("tx_clear29");
    tx_clear29.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level29 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level29");
    rx_fifo_int_trig_level29.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg29.set_inst_name($sformatf("%s.wcov29", get_full_name()));
  endfunction

  covergroup wr_cg29;
    option.per_instance=1;
    rx_clear29 : coverpoint rx_clear29.value[0:0];
    tx_clear29 : coverpoint tx_clear29.value[0:0];
    rx_fifo_int_trig_level29 : coverpoint rx_fifo_int_trig_level29.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg29.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c29, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c29, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c29)
  function new(input string name="unnamed29-ua_fifo_ctrl_c29");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg29=new;
  endfunction : new
endclass : ua_fifo_ctrl_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 188


class ua_lcr_c29 extends uvm_reg;

  rand uvm_reg_field char_lngth29;
  rand uvm_reg_field num_stop_bits29;
  rand uvm_reg_field p_en29;
  rand uvm_reg_field parity_even29;
  rand uvm_reg_field parity_sticky29;
  rand uvm_reg_field break_ctrl29;
  rand uvm_reg_field div_latch_access29;

  constraint c_char_lngth29 { char_lngth29.value != 2'b00; }
  constraint c_break_ctrl29 { break_ctrl29.value == 1'b0; }
  virtual function void build();
    char_lngth29 = uvm_reg_field::type_id::create("char_lngth29");
    char_lngth29.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits29 = uvm_reg_field::type_id::create("num_stop_bits29");
    num_stop_bits29.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en29 = uvm_reg_field::type_id::create("p_en29");
    p_en29.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even29 = uvm_reg_field::type_id::create("parity_even29");
    parity_even29.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky29 = uvm_reg_field::type_id::create("parity_sticky29");
    parity_sticky29.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl29 = uvm_reg_field::type_id::create("break_ctrl29");
    break_ctrl29.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access29 = uvm_reg_field::type_id::create("div_latch_access29");
    div_latch_access29.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg29.set_inst_name($sformatf("%s.wcov29", get_full_name()));
    rd_cg29.set_inst_name($sformatf("%s.rcov29", get_full_name()));
  endfunction

  covergroup wr_cg29;
    option.per_instance=1;
    char_lngth29 : coverpoint char_lngth29.value[1:0];
    num_stop_bits29 : coverpoint num_stop_bits29.value[0:0];
    p_en29 : coverpoint p_en29.value[0:0];
    parity_even29 : coverpoint parity_even29.value[0:0];
    parity_sticky29 : coverpoint parity_sticky29.value[0:0];
    break_ctrl29 : coverpoint break_ctrl29.value[0:0];
    div_latch_access29 : coverpoint div_latch_access29.value[0:0];
  endgroup
  covergroup rd_cg29;
    option.per_instance=1;
    char_lngth29 : coverpoint char_lngth29.value[1:0];
    num_stop_bits29 : coverpoint num_stop_bits29.value[0:0];
    p_en29 : coverpoint p_en29.value[0:0];
    parity_even29 : coverpoint parity_even29.value[0:0];
    parity_sticky29 : coverpoint parity_sticky29.value[0:0];
    break_ctrl29 : coverpoint break_ctrl29.value[0:0];
    div_latch_access29 : coverpoint div_latch_access29.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg29.sample();
    if(is_read) rd_cg29.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c29, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c29, uvm_reg)
  `uvm_object_utils(ua_lcr_c29)
  function new(input string name="unnamed29-ua_lcr_c29");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg29=new;
    rd_cg29=new;
  endfunction : new
endclass : ua_lcr_c29

//////////////////////////////////////////////////////////////////////////////
// Register definition29
//////////////////////////////////////////////////////////////////////////////
// Line29 Number29: 25


class ua_ier_c29 extends uvm_reg;

  rand uvm_reg_field rx_data29;
  rand uvm_reg_field tx_data29;
  rand uvm_reg_field rx_line_sts29;
  rand uvm_reg_field mdm_sts29;

  virtual function void build();
    rx_data29 = uvm_reg_field::type_id::create("rx_data29");
    rx_data29.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data29 = uvm_reg_field::type_id::create("tx_data29");
    tx_data29.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts29 = uvm_reg_field::type_id::create("rx_line_sts29");
    rx_line_sts29.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts29 = uvm_reg_field::type_id::create("mdm_sts29");
    mdm_sts29.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg29.set_inst_name($sformatf("%s.wcov29", get_full_name()));
    rd_cg29.set_inst_name($sformatf("%s.rcov29", get_full_name()));
  endfunction

  covergroup wr_cg29;
    option.per_instance=1;
    rx_data29 : coverpoint rx_data29.value[0:0];
    tx_data29 : coverpoint tx_data29.value[0:0];
    rx_line_sts29 : coverpoint rx_line_sts29.value[0:0];
    mdm_sts29 : coverpoint mdm_sts29.value[0:0];
  endgroup
  covergroup rd_cg29;
    option.per_instance=1;
    rx_data29 : coverpoint rx_data29.value[0:0];
    tx_data29 : coverpoint tx_data29.value[0:0];
    rx_line_sts29 : coverpoint rx_line_sts29.value[0:0];
    mdm_sts29 : coverpoint mdm_sts29.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg29.sample();
    if(is_read) rd_cg29.sample();
  endfunction

  `uvm_register_cb(ua_ier_c29, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c29, uvm_reg)
  `uvm_object_utils(ua_ier_c29)
  function new(input string name="unnamed29-ua_ier_c29");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg29=new;
    rd_cg29=new;
  endfunction : new
endclass : ua_ier_c29

class uart_ctrl_rf_c29 extends uvm_reg_block;

  rand ua_div_latch0_c29 ua_div_latch029;
  rand ua_div_latch1_c29 ua_div_latch129;
  rand ua_int_id_c29 ua_int_id29;
  rand ua_fifo_ctrl_c29 ua_fifo_ctrl29;
  rand ua_lcr_c29 ua_lcr29;
  rand ua_ier_c29 ua_ier29;

  virtual function void build();

    // Now29 create all registers

    ua_div_latch029 = ua_div_latch0_c29::type_id::create("ua_div_latch029", , get_full_name());
    ua_div_latch129 = ua_div_latch1_c29::type_id::create("ua_div_latch129", , get_full_name());
    ua_int_id29 = ua_int_id_c29::type_id::create("ua_int_id29", , get_full_name());
    ua_fifo_ctrl29 = ua_fifo_ctrl_c29::type_id::create("ua_fifo_ctrl29", , get_full_name());
    ua_lcr29 = ua_lcr_c29::type_id::create("ua_lcr29", , get_full_name());
    ua_ier29 = ua_ier_c29::type_id::create("ua_ier29", , get_full_name());

    // Now29 build the registers. Set parent and hdl_paths

    ua_div_latch029.configure(this, null, "dl29[7:0]");
    ua_div_latch029.build();
    ua_div_latch129.configure(this, null, "dl29[15;8]");
    ua_div_latch129.build();
    ua_int_id29.configure(this, null, "iir29");
    ua_int_id29.build();
    ua_fifo_ctrl29.configure(this, null, "fcr29");
    ua_fifo_ctrl29.build();
    ua_lcr29.configure(this, null, "lcr29");
    ua_lcr29.build();
    ua_ier29.configure(this, null, "ier29");
    ua_ier29.build();
    // Now29 define address mappings29
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch029, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch129, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id29, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl29, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr29, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier29, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c29)
  function new(input string name="unnamed29-uart_ctrl_rf29");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c29

//////////////////////////////////////////////////////////////////////////////
// Address_map29 definition29
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c29 extends uvm_reg_block;

  rand uart_ctrl_rf_c29 uart_ctrl_rf29;

  function void build();
    // Now29 define address mappings29
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf29 = uart_ctrl_rf_c29::type_id::create("uart_ctrl_rf29", , get_full_name());
    uart_ctrl_rf29.configure(this, "regs");
    uart_ctrl_rf29.build();
    uart_ctrl_rf29.lock_model();
    default_map.add_submap(uart_ctrl_rf29.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top29.uart_dut29");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c29)
  function new(input string name="unnamed29-uart_ctrl_reg_model_c29");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c29

`endif // UART_CTRL_REGS_SV29
