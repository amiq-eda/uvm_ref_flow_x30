// This19 file is generated19 using Cadence19 iregGen19 version19 1.05

`ifndef UART_CTRL_REGS_SV19
`define UART_CTRL_REGS_SV19

// Input19 File19: uart_ctrl_regs19.xml19

// Number19 of AddrMaps19 = 1
// Number19 of RegFiles19 = 1
// Number19 of Registers19 = 6
// Number19 of Memories19 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 262


class ua_div_latch0_c19 extends uvm_reg;

  rand uvm_reg_field div_val19;

  constraint c_div_val19 { div_val19.value == 1; }
  virtual function void build();
    div_val19 = uvm_reg_field::type_id::create("div_val19");
    div_val19.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg19.set_inst_name($sformatf("%s.wcov19", get_full_name()));
    rd_cg19.set_inst_name($sformatf("%s.rcov19", get_full_name()));
  endfunction

  covergroup wr_cg19;
    option.per_instance=1;
    div_val19 : coverpoint div_val19.value[7:0];
  endgroup
  covergroup rd_cg19;
    option.per_instance=1;
    div_val19 : coverpoint div_val19.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg19.sample();
    if(is_read) rd_cg19.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c19, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c19, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c19)
  function new(input string name="unnamed19-ua_div_latch0_c19");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg19=new;
    rd_cg19=new;
  endfunction : new
endclass : ua_div_latch0_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 287


class ua_div_latch1_c19 extends uvm_reg;

  rand uvm_reg_field div_val19;

  constraint c_div_val19 { div_val19.value == 0; }
  virtual function void build();
    div_val19 = uvm_reg_field::type_id::create("div_val19");
    div_val19.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg19.set_inst_name($sformatf("%s.wcov19", get_full_name()));
    rd_cg19.set_inst_name($sformatf("%s.rcov19", get_full_name()));
  endfunction

  covergroup wr_cg19;
    option.per_instance=1;
    div_val19 : coverpoint div_val19.value[7:0];
  endgroup
  covergroup rd_cg19;
    option.per_instance=1;
    div_val19 : coverpoint div_val19.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg19.sample();
    if(is_read) rd_cg19.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c19, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c19, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c19)
  function new(input string name="unnamed19-ua_div_latch1_c19");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg19=new;
    rd_cg19=new;
  endfunction : new
endclass : ua_div_latch1_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 82


class ua_int_id_c19 extends uvm_reg;

  uvm_reg_field priority_bit19;
  uvm_reg_field bit119;
  uvm_reg_field bit219;
  uvm_reg_field bit319;

  virtual function void build();
    priority_bit19 = uvm_reg_field::type_id::create("priority_bit19");
    priority_bit19.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit119 = uvm_reg_field::type_id::create("bit119");
    bit119.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit219 = uvm_reg_field::type_id::create("bit219");
    bit219.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit319 = uvm_reg_field::type_id::create("bit319");
    bit319.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg19.set_inst_name($sformatf("%s.rcov19", get_full_name()));
  endfunction

  covergroup rd_cg19;
    option.per_instance=1;
    priority_bit19 : coverpoint priority_bit19.value[0:0];
    bit119 : coverpoint bit119.value[0:0];
    bit219 : coverpoint bit219.value[0:0];
    bit319 : coverpoint bit319.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg19.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c19, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c19, uvm_reg)
  `uvm_object_utils(ua_int_id_c19)
  function new(input string name="unnamed19-ua_int_id_c19");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg19=new;
  endfunction : new
endclass : ua_int_id_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 139


class ua_fifo_ctrl_c19 extends uvm_reg;

  rand uvm_reg_field rx_clear19;
  rand uvm_reg_field tx_clear19;
  rand uvm_reg_field rx_fifo_int_trig_level19;

  virtual function void build();
    rx_clear19 = uvm_reg_field::type_id::create("rx_clear19");
    rx_clear19.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear19 = uvm_reg_field::type_id::create("tx_clear19");
    tx_clear19.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level19 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level19");
    rx_fifo_int_trig_level19.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg19.set_inst_name($sformatf("%s.wcov19", get_full_name()));
  endfunction

  covergroup wr_cg19;
    option.per_instance=1;
    rx_clear19 : coverpoint rx_clear19.value[0:0];
    tx_clear19 : coverpoint tx_clear19.value[0:0];
    rx_fifo_int_trig_level19 : coverpoint rx_fifo_int_trig_level19.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg19.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c19, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c19, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c19)
  function new(input string name="unnamed19-ua_fifo_ctrl_c19");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg19=new;
  endfunction : new
endclass : ua_fifo_ctrl_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 188


class ua_lcr_c19 extends uvm_reg;

  rand uvm_reg_field char_lngth19;
  rand uvm_reg_field num_stop_bits19;
  rand uvm_reg_field p_en19;
  rand uvm_reg_field parity_even19;
  rand uvm_reg_field parity_sticky19;
  rand uvm_reg_field break_ctrl19;
  rand uvm_reg_field div_latch_access19;

  constraint c_char_lngth19 { char_lngth19.value != 2'b00; }
  constraint c_break_ctrl19 { break_ctrl19.value == 1'b0; }
  virtual function void build();
    char_lngth19 = uvm_reg_field::type_id::create("char_lngth19");
    char_lngth19.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits19 = uvm_reg_field::type_id::create("num_stop_bits19");
    num_stop_bits19.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en19 = uvm_reg_field::type_id::create("p_en19");
    p_en19.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even19 = uvm_reg_field::type_id::create("parity_even19");
    parity_even19.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky19 = uvm_reg_field::type_id::create("parity_sticky19");
    parity_sticky19.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl19 = uvm_reg_field::type_id::create("break_ctrl19");
    break_ctrl19.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access19 = uvm_reg_field::type_id::create("div_latch_access19");
    div_latch_access19.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg19.set_inst_name($sformatf("%s.wcov19", get_full_name()));
    rd_cg19.set_inst_name($sformatf("%s.rcov19", get_full_name()));
  endfunction

  covergroup wr_cg19;
    option.per_instance=1;
    char_lngth19 : coverpoint char_lngth19.value[1:0];
    num_stop_bits19 : coverpoint num_stop_bits19.value[0:0];
    p_en19 : coverpoint p_en19.value[0:0];
    parity_even19 : coverpoint parity_even19.value[0:0];
    parity_sticky19 : coverpoint parity_sticky19.value[0:0];
    break_ctrl19 : coverpoint break_ctrl19.value[0:0];
    div_latch_access19 : coverpoint div_latch_access19.value[0:0];
  endgroup
  covergroup rd_cg19;
    option.per_instance=1;
    char_lngth19 : coverpoint char_lngth19.value[1:0];
    num_stop_bits19 : coverpoint num_stop_bits19.value[0:0];
    p_en19 : coverpoint p_en19.value[0:0];
    parity_even19 : coverpoint parity_even19.value[0:0];
    parity_sticky19 : coverpoint parity_sticky19.value[0:0];
    break_ctrl19 : coverpoint break_ctrl19.value[0:0];
    div_latch_access19 : coverpoint div_latch_access19.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg19.sample();
    if(is_read) rd_cg19.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c19, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c19, uvm_reg)
  `uvm_object_utils(ua_lcr_c19)
  function new(input string name="unnamed19-ua_lcr_c19");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg19=new;
    rd_cg19=new;
  endfunction : new
endclass : ua_lcr_c19

//////////////////////////////////////////////////////////////////////////////
// Register definition19
//////////////////////////////////////////////////////////////////////////////
// Line19 Number19: 25


class ua_ier_c19 extends uvm_reg;

  rand uvm_reg_field rx_data19;
  rand uvm_reg_field tx_data19;
  rand uvm_reg_field rx_line_sts19;
  rand uvm_reg_field mdm_sts19;

  virtual function void build();
    rx_data19 = uvm_reg_field::type_id::create("rx_data19");
    rx_data19.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data19 = uvm_reg_field::type_id::create("tx_data19");
    tx_data19.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts19 = uvm_reg_field::type_id::create("rx_line_sts19");
    rx_line_sts19.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts19 = uvm_reg_field::type_id::create("mdm_sts19");
    mdm_sts19.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg19.set_inst_name($sformatf("%s.wcov19", get_full_name()));
    rd_cg19.set_inst_name($sformatf("%s.rcov19", get_full_name()));
  endfunction

  covergroup wr_cg19;
    option.per_instance=1;
    rx_data19 : coverpoint rx_data19.value[0:0];
    tx_data19 : coverpoint tx_data19.value[0:0];
    rx_line_sts19 : coverpoint rx_line_sts19.value[0:0];
    mdm_sts19 : coverpoint mdm_sts19.value[0:0];
  endgroup
  covergroup rd_cg19;
    option.per_instance=1;
    rx_data19 : coverpoint rx_data19.value[0:0];
    tx_data19 : coverpoint tx_data19.value[0:0];
    rx_line_sts19 : coverpoint rx_line_sts19.value[0:0];
    mdm_sts19 : coverpoint mdm_sts19.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg19.sample();
    if(is_read) rd_cg19.sample();
  endfunction

  `uvm_register_cb(ua_ier_c19, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c19, uvm_reg)
  `uvm_object_utils(ua_ier_c19)
  function new(input string name="unnamed19-ua_ier_c19");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg19=new;
    rd_cg19=new;
  endfunction : new
endclass : ua_ier_c19

class uart_ctrl_rf_c19 extends uvm_reg_block;

  rand ua_div_latch0_c19 ua_div_latch019;
  rand ua_div_latch1_c19 ua_div_latch119;
  rand ua_int_id_c19 ua_int_id19;
  rand ua_fifo_ctrl_c19 ua_fifo_ctrl19;
  rand ua_lcr_c19 ua_lcr19;
  rand ua_ier_c19 ua_ier19;

  virtual function void build();

    // Now19 create all registers

    ua_div_latch019 = ua_div_latch0_c19::type_id::create("ua_div_latch019", , get_full_name());
    ua_div_latch119 = ua_div_latch1_c19::type_id::create("ua_div_latch119", , get_full_name());
    ua_int_id19 = ua_int_id_c19::type_id::create("ua_int_id19", , get_full_name());
    ua_fifo_ctrl19 = ua_fifo_ctrl_c19::type_id::create("ua_fifo_ctrl19", , get_full_name());
    ua_lcr19 = ua_lcr_c19::type_id::create("ua_lcr19", , get_full_name());
    ua_ier19 = ua_ier_c19::type_id::create("ua_ier19", , get_full_name());

    // Now19 build the registers. Set parent and hdl_paths

    ua_div_latch019.configure(this, null, "dl19[7:0]");
    ua_div_latch019.build();
    ua_div_latch119.configure(this, null, "dl19[15;8]");
    ua_div_latch119.build();
    ua_int_id19.configure(this, null, "iir19");
    ua_int_id19.build();
    ua_fifo_ctrl19.configure(this, null, "fcr19");
    ua_fifo_ctrl19.build();
    ua_lcr19.configure(this, null, "lcr19");
    ua_lcr19.build();
    ua_ier19.configure(this, null, "ier19");
    ua_ier19.build();
    // Now19 define address mappings19
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch019, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch119, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id19, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl19, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr19, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier19, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c19)
  function new(input string name="unnamed19-uart_ctrl_rf19");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c19

//////////////////////////////////////////////////////////////////////////////
// Address_map19 definition19
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c19 extends uvm_reg_block;

  rand uart_ctrl_rf_c19 uart_ctrl_rf19;

  function void build();
    // Now19 define address mappings19
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf19 = uart_ctrl_rf_c19::type_id::create("uart_ctrl_rf19", , get_full_name());
    uart_ctrl_rf19.configure(this, "regs");
    uart_ctrl_rf19.build();
    uart_ctrl_rf19.lock_model();
    default_map.add_submap(uart_ctrl_rf19.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top19.uart_dut19");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c19)
  function new(input string name="unnamed19-uart_ctrl_reg_model_c19");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c19

`endif // UART_CTRL_REGS_SV19
