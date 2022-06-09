// This30 file is generated30 using Cadence30 iregGen30 version30 1.05

`ifndef UART_CTRL_REGS_SV30
`define UART_CTRL_REGS_SV30

// Input30 File30: uart_ctrl_regs30.xml30

// Number30 of AddrMaps30 = 1
// Number30 of RegFiles30 = 1
// Number30 of Registers30 = 6
// Number30 of Memories30 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 262


class ua_div_latch0_c30 extends uvm_reg;

  rand uvm_reg_field div_val30;

  constraint c_div_val30 { div_val30.value == 1; }
  virtual function void build();
    div_val30 = uvm_reg_field::type_id::create("div_val30");
    div_val30.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg30.set_inst_name($sformatf("%s.wcov30", get_full_name()));
    rd_cg30.set_inst_name($sformatf("%s.rcov30", get_full_name()));
  endfunction

  covergroup wr_cg30;
    option.per_instance=1;
    div_val30 : coverpoint div_val30.value[7:0];
  endgroup
  covergroup rd_cg30;
    option.per_instance=1;
    div_val30 : coverpoint div_val30.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg30.sample();
    if(is_read) rd_cg30.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c30, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c30, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c30)
  function new(input string name="unnamed30-ua_div_latch0_c30");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg30=new;
    rd_cg30=new;
  endfunction : new
endclass : ua_div_latch0_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 287


class ua_div_latch1_c30 extends uvm_reg;

  rand uvm_reg_field div_val30;

  constraint c_div_val30 { div_val30.value == 0; }
  virtual function void build();
    div_val30 = uvm_reg_field::type_id::create("div_val30");
    div_val30.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg30.set_inst_name($sformatf("%s.wcov30", get_full_name()));
    rd_cg30.set_inst_name($sformatf("%s.rcov30", get_full_name()));
  endfunction

  covergroup wr_cg30;
    option.per_instance=1;
    div_val30 : coverpoint div_val30.value[7:0];
  endgroup
  covergroup rd_cg30;
    option.per_instance=1;
    div_val30 : coverpoint div_val30.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg30.sample();
    if(is_read) rd_cg30.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c30, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c30, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c30)
  function new(input string name="unnamed30-ua_div_latch1_c30");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg30=new;
    rd_cg30=new;
  endfunction : new
endclass : ua_div_latch1_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 82


class ua_int_id_c30 extends uvm_reg;

  uvm_reg_field priority_bit30;
  uvm_reg_field bit130;
  uvm_reg_field bit230;
  uvm_reg_field bit330;

  virtual function void build();
    priority_bit30 = uvm_reg_field::type_id::create("priority_bit30");
    priority_bit30.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit130 = uvm_reg_field::type_id::create("bit130");
    bit130.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit230 = uvm_reg_field::type_id::create("bit230");
    bit230.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit330 = uvm_reg_field::type_id::create("bit330");
    bit330.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg30.set_inst_name($sformatf("%s.rcov30", get_full_name()));
  endfunction

  covergroup rd_cg30;
    option.per_instance=1;
    priority_bit30 : coverpoint priority_bit30.value[0:0];
    bit130 : coverpoint bit130.value[0:0];
    bit230 : coverpoint bit230.value[0:0];
    bit330 : coverpoint bit330.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg30.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c30, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c30, uvm_reg)
  `uvm_object_utils(ua_int_id_c30)
  function new(input string name="unnamed30-ua_int_id_c30");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg30=new;
  endfunction : new
endclass : ua_int_id_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 139


class ua_fifo_ctrl_c30 extends uvm_reg;

  rand uvm_reg_field rx_clear30;
  rand uvm_reg_field tx_clear30;
  rand uvm_reg_field rx_fifo_int_trig_level30;

  virtual function void build();
    rx_clear30 = uvm_reg_field::type_id::create("rx_clear30");
    rx_clear30.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear30 = uvm_reg_field::type_id::create("tx_clear30");
    tx_clear30.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level30 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level30");
    rx_fifo_int_trig_level30.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg30.set_inst_name($sformatf("%s.wcov30", get_full_name()));
  endfunction

  covergroup wr_cg30;
    option.per_instance=1;
    rx_clear30 : coverpoint rx_clear30.value[0:0];
    tx_clear30 : coverpoint tx_clear30.value[0:0];
    rx_fifo_int_trig_level30 : coverpoint rx_fifo_int_trig_level30.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg30.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c30, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c30, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c30)
  function new(input string name="unnamed30-ua_fifo_ctrl_c30");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg30=new;
  endfunction : new
endclass : ua_fifo_ctrl_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 188


class ua_lcr_c30 extends uvm_reg;

  rand uvm_reg_field char_lngth30;
  rand uvm_reg_field num_stop_bits30;
  rand uvm_reg_field p_en30;
  rand uvm_reg_field parity_even30;
  rand uvm_reg_field parity_sticky30;
  rand uvm_reg_field break_ctrl30;
  rand uvm_reg_field div_latch_access30;

  constraint c_char_lngth30 { char_lngth30.value != 2'b00; }
  constraint c_break_ctrl30 { break_ctrl30.value == 1'b0; }
  virtual function void build();
    char_lngth30 = uvm_reg_field::type_id::create("char_lngth30");
    char_lngth30.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits30 = uvm_reg_field::type_id::create("num_stop_bits30");
    num_stop_bits30.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en30 = uvm_reg_field::type_id::create("p_en30");
    p_en30.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even30 = uvm_reg_field::type_id::create("parity_even30");
    parity_even30.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky30 = uvm_reg_field::type_id::create("parity_sticky30");
    parity_sticky30.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl30 = uvm_reg_field::type_id::create("break_ctrl30");
    break_ctrl30.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access30 = uvm_reg_field::type_id::create("div_latch_access30");
    div_latch_access30.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg30.set_inst_name($sformatf("%s.wcov30", get_full_name()));
    rd_cg30.set_inst_name($sformatf("%s.rcov30", get_full_name()));
  endfunction

  covergroup wr_cg30;
    option.per_instance=1;
    char_lngth30 : coverpoint char_lngth30.value[1:0];
    num_stop_bits30 : coverpoint num_stop_bits30.value[0:0];
    p_en30 : coverpoint p_en30.value[0:0];
    parity_even30 : coverpoint parity_even30.value[0:0];
    parity_sticky30 : coverpoint parity_sticky30.value[0:0];
    break_ctrl30 : coverpoint break_ctrl30.value[0:0];
    div_latch_access30 : coverpoint div_latch_access30.value[0:0];
  endgroup
  covergroup rd_cg30;
    option.per_instance=1;
    char_lngth30 : coverpoint char_lngth30.value[1:0];
    num_stop_bits30 : coverpoint num_stop_bits30.value[0:0];
    p_en30 : coverpoint p_en30.value[0:0];
    parity_even30 : coverpoint parity_even30.value[0:0];
    parity_sticky30 : coverpoint parity_sticky30.value[0:0];
    break_ctrl30 : coverpoint break_ctrl30.value[0:0];
    div_latch_access30 : coverpoint div_latch_access30.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg30.sample();
    if(is_read) rd_cg30.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c30, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c30, uvm_reg)
  `uvm_object_utils(ua_lcr_c30)
  function new(input string name="unnamed30-ua_lcr_c30");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg30=new;
    rd_cg30=new;
  endfunction : new
endclass : ua_lcr_c30

//////////////////////////////////////////////////////////////////////////////
// Register definition30
//////////////////////////////////////////////////////////////////////////////
// Line30 Number30: 25


class ua_ier_c30 extends uvm_reg;

  rand uvm_reg_field rx_data30;
  rand uvm_reg_field tx_data30;
  rand uvm_reg_field rx_line_sts30;
  rand uvm_reg_field mdm_sts30;

  virtual function void build();
    rx_data30 = uvm_reg_field::type_id::create("rx_data30");
    rx_data30.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data30 = uvm_reg_field::type_id::create("tx_data30");
    tx_data30.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts30 = uvm_reg_field::type_id::create("rx_line_sts30");
    rx_line_sts30.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts30 = uvm_reg_field::type_id::create("mdm_sts30");
    mdm_sts30.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg30.set_inst_name($sformatf("%s.wcov30", get_full_name()));
    rd_cg30.set_inst_name($sformatf("%s.rcov30", get_full_name()));
  endfunction

  covergroup wr_cg30;
    option.per_instance=1;
    rx_data30 : coverpoint rx_data30.value[0:0];
    tx_data30 : coverpoint tx_data30.value[0:0];
    rx_line_sts30 : coverpoint rx_line_sts30.value[0:0];
    mdm_sts30 : coverpoint mdm_sts30.value[0:0];
  endgroup
  covergroup rd_cg30;
    option.per_instance=1;
    rx_data30 : coverpoint rx_data30.value[0:0];
    tx_data30 : coverpoint tx_data30.value[0:0];
    rx_line_sts30 : coverpoint rx_line_sts30.value[0:0];
    mdm_sts30 : coverpoint mdm_sts30.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg30.sample();
    if(is_read) rd_cg30.sample();
  endfunction

  `uvm_register_cb(ua_ier_c30, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c30, uvm_reg)
  `uvm_object_utils(ua_ier_c30)
  function new(input string name="unnamed30-ua_ier_c30");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg30=new;
    rd_cg30=new;
  endfunction : new
endclass : ua_ier_c30

class uart_ctrl_rf_c30 extends uvm_reg_block;

  rand ua_div_latch0_c30 ua_div_latch030;
  rand ua_div_latch1_c30 ua_div_latch130;
  rand ua_int_id_c30 ua_int_id30;
  rand ua_fifo_ctrl_c30 ua_fifo_ctrl30;
  rand ua_lcr_c30 ua_lcr30;
  rand ua_ier_c30 ua_ier30;

  virtual function void build();

    // Now30 create all registers

    ua_div_latch030 = ua_div_latch0_c30::type_id::create("ua_div_latch030", , get_full_name());
    ua_div_latch130 = ua_div_latch1_c30::type_id::create("ua_div_latch130", , get_full_name());
    ua_int_id30 = ua_int_id_c30::type_id::create("ua_int_id30", , get_full_name());
    ua_fifo_ctrl30 = ua_fifo_ctrl_c30::type_id::create("ua_fifo_ctrl30", , get_full_name());
    ua_lcr30 = ua_lcr_c30::type_id::create("ua_lcr30", , get_full_name());
    ua_ier30 = ua_ier_c30::type_id::create("ua_ier30", , get_full_name());

    // Now30 build the registers. Set parent and hdl_paths

    ua_div_latch030.configure(this, null, "dl30[7:0]");
    ua_div_latch030.build();
    ua_div_latch130.configure(this, null, "dl30[15;8]");
    ua_div_latch130.build();
    ua_int_id30.configure(this, null, "iir30");
    ua_int_id30.build();
    ua_fifo_ctrl30.configure(this, null, "fcr30");
    ua_fifo_ctrl30.build();
    ua_lcr30.configure(this, null, "lcr30");
    ua_lcr30.build();
    ua_ier30.configure(this, null, "ier30");
    ua_ier30.build();
    // Now30 define address mappings30
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch030, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch130, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id30, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl30, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr30, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier30, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c30)
  function new(input string name="unnamed30-uart_ctrl_rf30");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c30

//////////////////////////////////////////////////////////////////////////////
// Address_map30 definition30
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c30 extends uvm_reg_block;

  rand uart_ctrl_rf_c30 uart_ctrl_rf30;

  function void build();
    // Now30 define address mappings30
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf30 = uart_ctrl_rf_c30::type_id::create("uart_ctrl_rf30", , get_full_name());
    uart_ctrl_rf30.configure(this, "regs");
    uart_ctrl_rf30.build();
    uart_ctrl_rf30.lock_model();
    default_map.add_submap(uart_ctrl_rf30.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top30.uart_dut30");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c30)
  function new(input string name="unnamed30-uart_ctrl_reg_model_c30");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c30

`endif // UART_CTRL_REGS_SV30
