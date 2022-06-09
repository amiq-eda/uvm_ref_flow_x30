// This26 file is generated26 using Cadence26 iregGen26 version26 1.05

`ifndef UART_CTRL_REGS_SV26
`define UART_CTRL_REGS_SV26

// Input26 File26: uart_ctrl_regs26.xml26

// Number26 of AddrMaps26 = 1
// Number26 of RegFiles26 = 1
// Number26 of Registers26 = 6
// Number26 of Memories26 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 262


class ua_div_latch0_c26 extends uvm_reg;

  rand uvm_reg_field div_val26;

  constraint c_div_val26 { div_val26.value == 1; }
  virtual function void build();
    div_val26 = uvm_reg_field::type_id::create("div_val26");
    div_val26.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg26.set_inst_name($sformatf("%s.wcov26", get_full_name()));
    rd_cg26.set_inst_name($sformatf("%s.rcov26", get_full_name()));
  endfunction

  covergroup wr_cg26;
    option.per_instance=1;
    div_val26 : coverpoint div_val26.value[7:0];
  endgroup
  covergroup rd_cg26;
    option.per_instance=1;
    div_val26 : coverpoint div_val26.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg26.sample();
    if(is_read) rd_cg26.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c26, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c26, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c26)
  function new(input string name="unnamed26-ua_div_latch0_c26");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg26=new;
    rd_cg26=new;
  endfunction : new
endclass : ua_div_latch0_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 287


class ua_div_latch1_c26 extends uvm_reg;

  rand uvm_reg_field div_val26;

  constraint c_div_val26 { div_val26.value == 0; }
  virtual function void build();
    div_val26 = uvm_reg_field::type_id::create("div_val26");
    div_val26.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg26.set_inst_name($sformatf("%s.wcov26", get_full_name()));
    rd_cg26.set_inst_name($sformatf("%s.rcov26", get_full_name()));
  endfunction

  covergroup wr_cg26;
    option.per_instance=1;
    div_val26 : coverpoint div_val26.value[7:0];
  endgroup
  covergroup rd_cg26;
    option.per_instance=1;
    div_val26 : coverpoint div_val26.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg26.sample();
    if(is_read) rd_cg26.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c26, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c26, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c26)
  function new(input string name="unnamed26-ua_div_latch1_c26");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg26=new;
    rd_cg26=new;
  endfunction : new
endclass : ua_div_latch1_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 82


class ua_int_id_c26 extends uvm_reg;

  uvm_reg_field priority_bit26;
  uvm_reg_field bit126;
  uvm_reg_field bit226;
  uvm_reg_field bit326;

  virtual function void build();
    priority_bit26 = uvm_reg_field::type_id::create("priority_bit26");
    priority_bit26.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit126 = uvm_reg_field::type_id::create("bit126");
    bit126.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit226 = uvm_reg_field::type_id::create("bit226");
    bit226.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit326 = uvm_reg_field::type_id::create("bit326");
    bit326.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg26.set_inst_name($sformatf("%s.rcov26", get_full_name()));
  endfunction

  covergroup rd_cg26;
    option.per_instance=1;
    priority_bit26 : coverpoint priority_bit26.value[0:0];
    bit126 : coverpoint bit126.value[0:0];
    bit226 : coverpoint bit226.value[0:0];
    bit326 : coverpoint bit326.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg26.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c26, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c26, uvm_reg)
  `uvm_object_utils(ua_int_id_c26)
  function new(input string name="unnamed26-ua_int_id_c26");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg26=new;
  endfunction : new
endclass : ua_int_id_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 139


class ua_fifo_ctrl_c26 extends uvm_reg;

  rand uvm_reg_field rx_clear26;
  rand uvm_reg_field tx_clear26;
  rand uvm_reg_field rx_fifo_int_trig_level26;

  virtual function void build();
    rx_clear26 = uvm_reg_field::type_id::create("rx_clear26");
    rx_clear26.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear26 = uvm_reg_field::type_id::create("tx_clear26");
    tx_clear26.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level26 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level26");
    rx_fifo_int_trig_level26.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg26.set_inst_name($sformatf("%s.wcov26", get_full_name()));
  endfunction

  covergroup wr_cg26;
    option.per_instance=1;
    rx_clear26 : coverpoint rx_clear26.value[0:0];
    tx_clear26 : coverpoint tx_clear26.value[0:0];
    rx_fifo_int_trig_level26 : coverpoint rx_fifo_int_trig_level26.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg26.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c26, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c26, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c26)
  function new(input string name="unnamed26-ua_fifo_ctrl_c26");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg26=new;
  endfunction : new
endclass : ua_fifo_ctrl_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 188


class ua_lcr_c26 extends uvm_reg;

  rand uvm_reg_field char_lngth26;
  rand uvm_reg_field num_stop_bits26;
  rand uvm_reg_field p_en26;
  rand uvm_reg_field parity_even26;
  rand uvm_reg_field parity_sticky26;
  rand uvm_reg_field break_ctrl26;
  rand uvm_reg_field div_latch_access26;

  constraint c_char_lngth26 { char_lngth26.value != 2'b00; }
  constraint c_break_ctrl26 { break_ctrl26.value == 1'b0; }
  virtual function void build();
    char_lngth26 = uvm_reg_field::type_id::create("char_lngth26");
    char_lngth26.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits26 = uvm_reg_field::type_id::create("num_stop_bits26");
    num_stop_bits26.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en26 = uvm_reg_field::type_id::create("p_en26");
    p_en26.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even26 = uvm_reg_field::type_id::create("parity_even26");
    parity_even26.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky26 = uvm_reg_field::type_id::create("parity_sticky26");
    parity_sticky26.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl26 = uvm_reg_field::type_id::create("break_ctrl26");
    break_ctrl26.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access26 = uvm_reg_field::type_id::create("div_latch_access26");
    div_latch_access26.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg26.set_inst_name($sformatf("%s.wcov26", get_full_name()));
    rd_cg26.set_inst_name($sformatf("%s.rcov26", get_full_name()));
  endfunction

  covergroup wr_cg26;
    option.per_instance=1;
    char_lngth26 : coverpoint char_lngth26.value[1:0];
    num_stop_bits26 : coverpoint num_stop_bits26.value[0:0];
    p_en26 : coverpoint p_en26.value[0:0];
    parity_even26 : coverpoint parity_even26.value[0:0];
    parity_sticky26 : coverpoint parity_sticky26.value[0:0];
    break_ctrl26 : coverpoint break_ctrl26.value[0:0];
    div_latch_access26 : coverpoint div_latch_access26.value[0:0];
  endgroup
  covergroup rd_cg26;
    option.per_instance=1;
    char_lngth26 : coverpoint char_lngth26.value[1:0];
    num_stop_bits26 : coverpoint num_stop_bits26.value[0:0];
    p_en26 : coverpoint p_en26.value[0:0];
    parity_even26 : coverpoint parity_even26.value[0:0];
    parity_sticky26 : coverpoint parity_sticky26.value[0:0];
    break_ctrl26 : coverpoint break_ctrl26.value[0:0];
    div_latch_access26 : coverpoint div_latch_access26.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg26.sample();
    if(is_read) rd_cg26.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c26, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c26, uvm_reg)
  `uvm_object_utils(ua_lcr_c26)
  function new(input string name="unnamed26-ua_lcr_c26");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg26=new;
    rd_cg26=new;
  endfunction : new
endclass : ua_lcr_c26

//////////////////////////////////////////////////////////////////////////////
// Register definition26
//////////////////////////////////////////////////////////////////////////////
// Line26 Number26: 25


class ua_ier_c26 extends uvm_reg;

  rand uvm_reg_field rx_data26;
  rand uvm_reg_field tx_data26;
  rand uvm_reg_field rx_line_sts26;
  rand uvm_reg_field mdm_sts26;

  virtual function void build();
    rx_data26 = uvm_reg_field::type_id::create("rx_data26");
    rx_data26.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data26 = uvm_reg_field::type_id::create("tx_data26");
    tx_data26.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts26 = uvm_reg_field::type_id::create("rx_line_sts26");
    rx_line_sts26.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts26 = uvm_reg_field::type_id::create("mdm_sts26");
    mdm_sts26.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg26.set_inst_name($sformatf("%s.wcov26", get_full_name()));
    rd_cg26.set_inst_name($sformatf("%s.rcov26", get_full_name()));
  endfunction

  covergroup wr_cg26;
    option.per_instance=1;
    rx_data26 : coverpoint rx_data26.value[0:0];
    tx_data26 : coverpoint tx_data26.value[0:0];
    rx_line_sts26 : coverpoint rx_line_sts26.value[0:0];
    mdm_sts26 : coverpoint mdm_sts26.value[0:0];
  endgroup
  covergroup rd_cg26;
    option.per_instance=1;
    rx_data26 : coverpoint rx_data26.value[0:0];
    tx_data26 : coverpoint tx_data26.value[0:0];
    rx_line_sts26 : coverpoint rx_line_sts26.value[0:0];
    mdm_sts26 : coverpoint mdm_sts26.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg26.sample();
    if(is_read) rd_cg26.sample();
  endfunction

  `uvm_register_cb(ua_ier_c26, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c26, uvm_reg)
  `uvm_object_utils(ua_ier_c26)
  function new(input string name="unnamed26-ua_ier_c26");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg26=new;
    rd_cg26=new;
  endfunction : new
endclass : ua_ier_c26

class uart_ctrl_rf_c26 extends uvm_reg_block;

  rand ua_div_latch0_c26 ua_div_latch026;
  rand ua_div_latch1_c26 ua_div_latch126;
  rand ua_int_id_c26 ua_int_id26;
  rand ua_fifo_ctrl_c26 ua_fifo_ctrl26;
  rand ua_lcr_c26 ua_lcr26;
  rand ua_ier_c26 ua_ier26;

  virtual function void build();

    // Now26 create all registers

    ua_div_latch026 = ua_div_latch0_c26::type_id::create("ua_div_latch026", , get_full_name());
    ua_div_latch126 = ua_div_latch1_c26::type_id::create("ua_div_latch126", , get_full_name());
    ua_int_id26 = ua_int_id_c26::type_id::create("ua_int_id26", , get_full_name());
    ua_fifo_ctrl26 = ua_fifo_ctrl_c26::type_id::create("ua_fifo_ctrl26", , get_full_name());
    ua_lcr26 = ua_lcr_c26::type_id::create("ua_lcr26", , get_full_name());
    ua_ier26 = ua_ier_c26::type_id::create("ua_ier26", , get_full_name());

    // Now26 build the registers. Set parent and hdl_paths

    ua_div_latch026.configure(this, null, "dl26[7:0]");
    ua_div_latch026.build();
    ua_div_latch126.configure(this, null, "dl26[15;8]");
    ua_div_latch126.build();
    ua_int_id26.configure(this, null, "iir26");
    ua_int_id26.build();
    ua_fifo_ctrl26.configure(this, null, "fcr26");
    ua_fifo_ctrl26.build();
    ua_lcr26.configure(this, null, "lcr26");
    ua_lcr26.build();
    ua_ier26.configure(this, null, "ier26");
    ua_ier26.build();
    // Now26 define address mappings26
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch026, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch126, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id26, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl26, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr26, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier26, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c26)
  function new(input string name="unnamed26-uart_ctrl_rf26");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c26

//////////////////////////////////////////////////////////////////////////////
// Address_map26 definition26
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c26 extends uvm_reg_block;

  rand uart_ctrl_rf_c26 uart_ctrl_rf26;

  function void build();
    // Now26 define address mappings26
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf26 = uart_ctrl_rf_c26::type_id::create("uart_ctrl_rf26", , get_full_name());
    uart_ctrl_rf26.configure(this, "regs");
    uart_ctrl_rf26.build();
    uart_ctrl_rf26.lock_model();
    default_map.add_submap(uart_ctrl_rf26.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top26.uart_dut26");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c26)
  function new(input string name="unnamed26-uart_ctrl_reg_model_c26");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c26

`endif // UART_CTRL_REGS_SV26
