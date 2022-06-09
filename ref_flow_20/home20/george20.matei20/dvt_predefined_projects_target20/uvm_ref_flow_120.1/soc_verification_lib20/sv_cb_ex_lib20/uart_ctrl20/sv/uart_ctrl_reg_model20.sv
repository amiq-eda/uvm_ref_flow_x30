// This20 file is generated20 using Cadence20 iregGen20 version20 1.05

`ifndef UART_CTRL_REGS_SV20
`define UART_CTRL_REGS_SV20

// Input20 File20: uart_ctrl_regs20.xml20

// Number20 of AddrMaps20 = 1
// Number20 of RegFiles20 = 1
// Number20 of Registers20 = 6
// Number20 of Memories20 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 262


class ua_div_latch0_c20 extends uvm_reg;

  rand uvm_reg_field div_val20;

  constraint c_div_val20 { div_val20.value == 1; }
  virtual function void build();
    div_val20 = uvm_reg_field::type_id::create("div_val20");
    div_val20.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg20.set_inst_name($sformatf("%s.wcov20", get_full_name()));
    rd_cg20.set_inst_name($sformatf("%s.rcov20", get_full_name()));
  endfunction

  covergroup wr_cg20;
    option.per_instance=1;
    div_val20 : coverpoint div_val20.value[7:0];
  endgroup
  covergroup rd_cg20;
    option.per_instance=1;
    div_val20 : coverpoint div_val20.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg20.sample();
    if(is_read) rd_cg20.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c20, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c20, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c20)
  function new(input string name="unnamed20-ua_div_latch0_c20");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg20=new;
    rd_cg20=new;
  endfunction : new
endclass : ua_div_latch0_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 287


class ua_div_latch1_c20 extends uvm_reg;

  rand uvm_reg_field div_val20;

  constraint c_div_val20 { div_val20.value == 0; }
  virtual function void build();
    div_val20 = uvm_reg_field::type_id::create("div_val20");
    div_val20.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg20.set_inst_name($sformatf("%s.wcov20", get_full_name()));
    rd_cg20.set_inst_name($sformatf("%s.rcov20", get_full_name()));
  endfunction

  covergroup wr_cg20;
    option.per_instance=1;
    div_val20 : coverpoint div_val20.value[7:0];
  endgroup
  covergroup rd_cg20;
    option.per_instance=1;
    div_val20 : coverpoint div_val20.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg20.sample();
    if(is_read) rd_cg20.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c20, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c20, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c20)
  function new(input string name="unnamed20-ua_div_latch1_c20");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg20=new;
    rd_cg20=new;
  endfunction : new
endclass : ua_div_latch1_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 82


class ua_int_id_c20 extends uvm_reg;

  uvm_reg_field priority_bit20;
  uvm_reg_field bit120;
  uvm_reg_field bit220;
  uvm_reg_field bit320;

  virtual function void build();
    priority_bit20 = uvm_reg_field::type_id::create("priority_bit20");
    priority_bit20.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit120 = uvm_reg_field::type_id::create("bit120");
    bit120.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit220 = uvm_reg_field::type_id::create("bit220");
    bit220.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit320 = uvm_reg_field::type_id::create("bit320");
    bit320.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg20.set_inst_name($sformatf("%s.rcov20", get_full_name()));
  endfunction

  covergroup rd_cg20;
    option.per_instance=1;
    priority_bit20 : coverpoint priority_bit20.value[0:0];
    bit120 : coverpoint bit120.value[0:0];
    bit220 : coverpoint bit220.value[0:0];
    bit320 : coverpoint bit320.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg20.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c20, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c20, uvm_reg)
  `uvm_object_utils(ua_int_id_c20)
  function new(input string name="unnamed20-ua_int_id_c20");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg20=new;
  endfunction : new
endclass : ua_int_id_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 139


class ua_fifo_ctrl_c20 extends uvm_reg;

  rand uvm_reg_field rx_clear20;
  rand uvm_reg_field tx_clear20;
  rand uvm_reg_field rx_fifo_int_trig_level20;

  virtual function void build();
    rx_clear20 = uvm_reg_field::type_id::create("rx_clear20");
    rx_clear20.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear20 = uvm_reg_field::type_id::create("tx_clear20");
    tx_clear20.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level20 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level20");
    rx_fifo_int_trig_level20.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg20.set_inst_name($sformatf("%s.wcov20", get_full_name()));
  endfunction

  covergroup wr_cg20;
    option.per_instance=1;
    rx_clear20 : coverpoint rx_clear20.value[0:0];
    tx_clear20 : coverpoint tx_clear20.value[0:0];
    rx_fifo_int_trig_level20 : coverpoint rx_fifo_int_trig_level20.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg20.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c20, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c20, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c20)
  function new(input string name="unnamed20-ua_fifo_ctrl_c20");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg20=new;
  endfunction : new
endclass : ua_fifo_ctrl_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 188


class ua_lcr_c20 extends uvm_reg;

  rand uvm_reg_field char_lngth20;
  rand uvm_reg_field num_stop_bits20;
  rand uvm_reg_field p_en20;
  rand uvm_reg_field parity_even20;
  rand uvm_reg_field parity_sticky20;
  rand uvm_reg_field break_ctrl20;
  rand uvm_reg_field div_latch_access20;

  constraint c_char_lngth20 { char_lngth20.value != 2'b00; }
  constraint c_break_ctrl20 { break_ctrl20.value == 1'b0; }
  virtual function void build();
    char_lngth20 = uvm_reg_field::type_id::create("char_lngth20");
    char_lngth20.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits20 = uvm_reg_field::type_id::create("num_stop_bits20");
    num_stop_bits20.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en20 = uvm_reg_field::type_id::create("p_en20");
    p_en20.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even20 = uvm_reg_field::type_id::create("parity_even20");
    parity_even20.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky20 = uvm_reg_field::type_id::create("parity_sticky20");
    parity_sticky20.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl20 = uvm_reg_field::type_id::create("break_ctrl20");
    break_ctrl20.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access20 = uvm_reg_field::type_id::create("div_latch_access20");
    div_latch_access20.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg20.set_inst_name($sformatf("%s.wcov20", get_full_name()));
    rd_cg20.set_inst_name($sformatf("%s.rcov20", get_full_name()));
  endfunction

  covergroup wr_cg20;
    option.per_instance=1;
    char_lngth20 : coverpoint char_lngth20.value[1:0];
    num_stop_bits20 : coverpoint num_stop_bits20.value[0:0];
    p_en20 : coverpoint p_en20.value[0:0];
    parity_even20 : coverpoint parity_even20.value[0:0];
    parity_sticky20 : coverpoint parity_sticky20.value[0:0];
    break_ctrl20 : coverpoint break_ctrl20.value[0:0];
    div_latch_access20 : coverpoint div_latch_access20.value[0:0];
  endgroup
  covergroup rd_cg20;
    option.per_instance=1;
    char_lngth20 : coverpoint char_lngth20.value[1:0];
    num_stop_bits20 : coverpoint num_stop_bits20.value[0:0];
    p_en20 : coverpoint p_en20.value[0:0];
    parity_even20 : coverpoint parity_even20.value[0:0];
    parity_sticky20 : coverpoint parity_sticky20.value[0:0];
    break_ctrl20 : coverpoint break_ctrl20.value[0:0];
    div_latch_access20 : coverpoint div_latch_access20.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg20.sample();
    if(is_read) rd_cg20.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c20, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c20, uvm_reg)
  `uvm_object_utils(ua_lcr_c20)
  function new(input string name="unnamed20-ua_lcr_c20");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg20=new;
    rd_cg20=new;
  endfunction : new
endclass : ua_lcr_c20

//////////////////////////////////////////////////////////////////////////////
// Register definition20
//////////////////////////////////////////////////////////////////////////////
// Line20 Number20: 25


class ua_ier_c20 extends uvm_reg;

  rand uvm_reg_field rx_data20;
  rand uvm_reg_field tx_data20;
  rand uvm_reg_field rx_line_sts20;
  rand uvm_reg_field mdm_sts20;

  virtual function void build();
    rx_data20 = uvm_reg_field::type_id::create("rx_data20");
    rx_data20.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data20 = uvm_reg_field::type_id::create("tx_data20");
    tx_data20.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts20 = uvm_reg_field::type_id::create("rx_line_sts20");
    rx_line_sts20.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts20 = uvm_reg_field::type_id::create("mdm_sts20");
    mdm_sts20.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg20.set_inst_name($sformatf("%s.wcov20", get_full_name()));
    rd_cg20.set_inst_name($sformatf("%s.rcov20", get_full_name()));
  endfunction

  covergroup wr_cg20;
    option.per_instance=1;
    rx_data20 : coverpoint rx_data20.value[0:0];
    tx_data20 : coverpoint tx_data20.value[0:0];
    rx_line_sts20 : coverpoint rx_line_sts20.value[0:0];
    mdm_sts20 : coverpoint mdm_sts20.value[0:0];
  endgroup
  covergroup rd_cg20;
    option.per_instance=1;
    rx_data20 : coverpoint rx_data20.value[0:0];
    tx_data20 : coverpoint tx_data20.value[0:0];
    rx_line_sts20 : coverpoint rx_line_sts20.value[0:0];
    mdm_sts20 : coverpoint mdm_sts20.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg20.sample();
    if(is_read) rd_cg20.sample();
  endfunction

  `uvm_register_cb(ua_ier_c20, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c20, uvm_reg)
  `uvm_object_utils(ua_ier_c20)
  function new(input string name="unnamed20-ua_ier_c20");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg20=new;
    rd_cg20=new;
  endfunction : new
endclass : ua_ier_c20

class uart_ctrl_rf_c20 extends uvm_reg_block;

  rand ua_div_latch0_c20 ua_div_latch020;
  rand ua_div_latch1_c20 ua_div_latch120;
  rand ua_int_id_c20 ua_int_id20;
  rand ua_fifo_ctrl_c20 ua_fifo_ctrl20;
  rand ua_lcr_c20 ua_lcr20;
  rand ua_ier_c20 ua_ier20;

  virtual function void build();

    // Now20 create all registers

    ua_div_latch020 = ua_div_latch0_c20::type_id::create("ua_div_latch020", , get_full_name());
    ua_div_latch120 = ua_div_latch1_c20::type_id::create("ua_div_latch120", , get_full_name());
    ua_int_id20 = ua_int_id_c20::type_id::create("ua_int_id20", , get_full_name());
    ua_fifo_ctrl20 = ua_fifo_ctrl_c20::type_id::create("ua_fifo_ctrl20", , get_full_name());
    ua_lcr20 = ua_lcr_c20::type_id::create("ua_lcr20", , get_full_name());
    ua_ier20 = ua_ier_c20::type_id::create("ua_ier20", , get_full_name());

    // Now20 build the registers. Set parent and hdl_paths

    ua_div_latch020.configure(this, null, "dl20[7:0]");
    ua_div_latch020.build();
    ua_div_latch120.configure(this, null, "dl20[15;8]");
    ua_div_latch120.build();
    ua_int_id20.configure(this, null, "iir20");
    ua_int_id20.build();
    ua_fifo_ctrl20.configure(this, null, "fcr20");
    ua_fifo_ctrl20.build();
    ua_lcr20.configure(this, null, "lcr20");
    ua_lcr20.build();
    ua_ier20.configure(this, null, "ier20");
    ua_ier20.build();
    // Now20 define address mappings20
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch020, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch120, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id20, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl20, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr20, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier20, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c20)
  function new(input string name="unnamed20-uart_ctrl_rf20");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c20

//////////////////////////////////////////////////////////////////////////////
// Address_map20 definition20
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c20 extends uvm_reg_block;

  rand uart_ctrl_rf_c20 uart_ctrl_rf20;

  function void build();
    // Now20 define address mappings20
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf20 = uart_ctrl_rf_c20::type_id::create("uart_ctrl_rf20", , get_full_name());
    uart_ctrl_rf20.configure(this, "regs");
    uart_ctrl_rf20.build();
    uart_ctrl_rf20.lock_model();
    default_map.add_submap(uart_ctrl_rf20.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top20.uart_dut20");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c20)
  function new(input string name="unnamed20-uart_ctrl_reg_model_c20");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c20

`endif // UART_CTRL_REGS_SV20
