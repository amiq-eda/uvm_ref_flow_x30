// This11 file is generated11 using Cadence11 iregGen11 version11 1.05

`ifndef UART_CTRL_REGS_SV11
`define UART_CTRL_REGS_SV11

// Input11 File11: uart_ctrl_regs11.xml11

// Number11 of AddrMaps11 = 1
// Number11 of RegFiles11 = 1
// Number11 of Registers11 = 6
// Number11 of Memories11 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 262


class ua_div_latch0_c11 extends uvm_reg;

  rand uvm_reg_field div_val11;

  constraint c_div_val11 { div_val11.value == 1; }
  virtual function void build();
    div_val11 = uvm_reg_field::type_id::create("div_val11");
    div_val11.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg11.set_inst_name($sformatf("%s.wcov11", get_full_name()));
    rd_cg11.set_inst_name($sformatf("%s.rcov11", get_full_name()));
  endfunction

  covergroup wr_cg11;
    option.per_instance=1;
    div_val11 : coverpoint div_val11.value[7:0];
  endgroup
  covergroup rd_cg11;
    option.per_instance=1;
    div_val11 : coverpoint div_val11.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg11.sample();
    if(is_read) rd_cg11.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c11, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c11, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c11)
  function new(input string name="unnamed11-ua_div_latch0_c11");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg11=new;
    rd_cg11=new;
  endfunction : new
endclass : ua_div_latch0_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 287


class ua_div_latch1_c11 extends uvm_reg;

  rand uvm_reg_field div_val11;

  constraint c_div_val11 { div_val11.value == 0; }
  virtual function void build();
    div_val11 = uvm_reg_field::type_id::create("div_val11");
    div_val11.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg11.set_inst_name($sformatf("%s.wcov11", get_full_name()));
    rd_cg11.set_inst_name($sformatf("%s.rcov11", get_full_name()));
  endfunction

  covergroup wr_cg11;
    option.per_instance=1;
    div_val11 : coverpoint div_val11.value[7:0];
  endgroup
  covergroup rd_cg11;
    option.per_instance=1;
    div_val11 : coverpoint div_val11.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg11.sample();
    if(is_read) rd_cg11.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c11, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c11, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c11)
  function new(input string name="unnamed11-ua_div_latch1_c11");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg11=new;
    rd_cg11=new;
  endfunction : new
endclass : ua_div_latch1_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 82


class ua_int_id_c11 extends uvm_reg;

  uvm_reg_field priority_bit11;
  uvm_reg_field bit111;
  uvm_reg_field bit211;
  uvm_reg_field bit311;

  virtual function void build();
    priority_bit11 = uvm_reg_field::type_id::create("priority_bit11");
    priority_bit11.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit111 = uvm_reg_field::type_id::create("bit111");
    bit111.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit211 = uvm_reg_field::type_id::create("bit211");
    bit211.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit311 = uvm_reg_field::type_id::create("bit311");
    bit311.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg11.set_inst_name($sformatf("%s.rcov11", get_full_name()));
  endfunction

  covergroup rd_cg11;
    option.per_instance=1;
    priority_bit11 : coverpoint priority_bit11.value[0:0];
    bit111 : coverpoint bit111.value[0:0];
    bit211 : coverpoint bit211.value[0:0];
    bit311 : coverpoint bit311.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg11.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c11, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c11, uvm_reg)
  `uvm_object_utils(ua_int_id_c11)
  function new(input string name="unnamed11-ua_int_id_c11");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg11=new;
  endfunction : new
endclass : ua_int_id_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 139


class ua_fifo_ctrl_c11 extends uvm_reg;

  rand uvm_reg_field rx_clear11;
  rand uvm_reg_field tx_clear11;
  rand uvm_reg_field rx_fifo_int_trig_level11;

  virtual function void build();
    rx_clear11 = uvm_reg_field::type_id::create("rx_clear11");
    rx_clear11.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear11 = uvm_reg_field::type_id::create("tx_clear11");
    tx_clear11.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level11 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level11");
    rx_fifo_int_trig_level11.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg11.set_inst_name($sformatf("%s.wcov11", get_full_name()));
  endfunction

  covergroup wr_cg11;
    option.per_instance=1;
    rx_clear11 : coverpoint rx_clear11.value[0:0];
    tx_clear11 : coverpoint tx_clear11.value[0:0];
    rx_fifo_int_trig_level11 : coverpoint rx_fifo_int_trig_level11.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg11.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c11, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c11, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c11)
  function new(input string name="unnamed11-ua_fifo_ctrl_c11");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg11=new;
  endfunction : new
endclass : ua_fifo_ctrl_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 188


class ua_lcr_c11 extends uvm_reg;

  rand uvm_reg_field char_lngth11;
  rand uvm_reg_field num_stop_bits11;
  rand uvm_reg_field p_en11;
  rand uvm_reg_field parity_even11;
  rand uvm_reg_field parity_sticky11;
  rand uvm_reg_field break_ctrl11;
  rand uvm_reg_field div_latch_access11;

  constraint c_char_lngth11 { char_lngth11.value != 2'b00; }
  constraint c_break_ctrl11 { break_ctrl11.value == 1'b0; }
  virtual function void build();
    char_lngth11 = uvm_reg_field::type_id::create("char_lngth11");
    char_lngth11.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits11 = uvm_reg_field::type_id::create("num_stop_bits11");
    num_stop_bits11.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en11 = uvm_reg_field::type_id::create("p_en11");
    p_en11.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even11 = uvm_reg_field::type_id::create("parity_even11");
    parity_even11.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky11 = uvm_reg_field::type_id::create("parity_sticky11");
    parity_sticky11.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl11 = uvm_reg_field::type_id::create("break_ctrl11");
    break_ctrl11.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access11 = uvm_reg_field::type_id::create("div_latch_access11");
    div_latch_access11.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg11.set_inst_name($sformatf("%s.wcov11", get_full_name()));
    rd_cg11.set_inst_name($sformatf("%s.rcov11", get_full_name()));
  endfunction

  covergroup wr_cg11;
    option.per_instance=1;
    char_lngth11 : coverpoint char_lngth11.value[1:0];
    num_stop_bits11 : coverpoint num_stop_bits11.value[0:0];
    p_en11 : coverpoint p_en11.value[0:0];
    parity_even11 : coverpoint parity_even11.value[0:0];
    parity_sticky11 : coverpoint parity_sticky11.value[0:0];
    break_ctrl11 : coverpoint break_ctrl11.value[0:0];
    div_latch_access11 : coverpoint div_latch_access11.value[0:0];
  endgroup
  covergroup rd_cg11;
    option.per_instance=1;
    char_lngth11 : coverpoint char_lngth11.value[1:0];
    num_stop_bits11 : coverpoint num_stop_bits11.value[0:0];
    p_en11 : coverpoint p_en11.value[0:0];
    parity_even11 : coverpoint parity_even11.value[0:0];
    parity_sticky11 : coverpoint parity_sticky11.value[0:0];
    break_ctrl11 : coverpoint break_ctrl11.value[0:0];
    div_latch_access11 : coverpoint div_latch_access11.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg11.sample();
    if(is_read) rd_cg11.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c11, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c11, uvm_reg)
  `uvm_object_utils(ua_lcr_c11)
  function new(input string name="unnamed11-ua_lcr_c11");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg11=new;
    rd_cg11=new;
  endfunction : new
endclass : ua_lcr_c11

//////////////////////////////////////////////////////////////////////////////
// Register definition11
//////////////////////////////////////////////////////////////////////////////
// Line11 Number11: 25


class ua_ier_c11 extends uvm_reg;

  rand uvm_reg_field rx_data11;
  rand uvm_reg_field tx_data11;
  rand uvm_reg_field rx_line_sts11;
  rand uvm_reg_field mdm_sts11;

  virtual function void build();
    rx_data11 = uvm_reg_field::type_id::create("rx_data11");
    rx_data11.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data11 = uvm_reg_field::type_id::create("tx_data11");
    tx_data11.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts11 = uvm_reg_field::type_id::create("rx_line_sts11");
    rx_line_sts11.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts11 = uvm_reg_field::type_id::create("mdm_sts11");
    mdm_sts11.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg11.set_inst_name($sformatf("%s.wcov11", get_full_name()));
    rd_cg11.set_inst_name($sformatf("%s.rcov11", get_full_name()));
  endfunction

  covergroup wr_cg11;
    option.per_instance=1;
    rx_data11 : coverpoint rx_data11.value[0:0];
    tx_data11 : coverpoint tx_data11.value[0:0];
    rx_line_sts11 : coverpoint rx_line_sts11.value[0:0];
    mdm_sts11 : coverpoint mdm_sts11.value[0:0];
  endgroup
  covergroup rd_cg11;
    option.per_instance=1;
    rx_data11 : coverpoint rx_data11.value[0:0];
    tx_data11 : coverpoint tx_data11.value[0:0];
    rx_line_sts11 : coverpoint rx_line_sts11.value[0:0];
    mdm_sts11 : coverpoint mdm_sts11.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg11.sample();
    if(is_read) rd_cg11.sample();
  endfunction

  `uvm_register_cb(ua_ier_c11, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c11, uvm_reg)
  `uvm_object_utils(ua_ier_c11)
  function new(input string name="unnamed11-ua_ier_c11");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg11=new;
    rd_cg11=new;
  endfunction : new
endclass : ua_ier_c11

class uart_ctrl_rf_c11 extends uvm_reg_block;

  rand ua_div_latch0_c11 ua_div_latch011;
  rand ua_div_latch1_c11 ua_div_latch111;
  rand ua_int_id_c11 ua_int_id11;
  rand ua_fifo_ctrl_c11 ua_fifo_ctrl11;
  rand ua_lcr_c11 ua_lcr11;
  rand ua_ier_c11 ua_ier11;

  virtual function void build();

    // Now11 create all registers

    ua_div_latch011 = ua_div_latch0_c11::type_id::create("ua_div_latch011", , get_full_name());
    ua_div_latch111 = ua_div_latch1_c11::type_id::create("ua_div_latch111", , get_full_name());
    ua_int_id11 = ua_int_id_c11::type_id::create("ua_int_id11", , get_full_name());
    ua_fifo_ctrl11 = ua_fifo_ctrl_c11::type_id::create("ua_fifo_ctrl11", , get_full_name());
    ua_lcr11 = ua_lcr_c11::type_id::create("ua_lcr11", , get_full_name());
    ua_ier11 = ua_ier_c11::type_id::create("ua_ier11", , get_full_name());

    // Now11 build the registers. Set parent and hdl_paths

    ua_div_latch011.configure(this, null, "dl11[7:0]");
    ua_div_latch011.build();
    ua_div_latch111.configure(this, null, "dl11[15;8]");
    ua_div_latch111.build();
    ua_int_id11.configure(this, null, "iir11");
    ua_int_id11.build();
    ua_fifo_ctrl11.configure(this, null, "fcr11");
    ua_fifo_ctrl11.build();
    ua_lcr11.configure(this, null, "lcr11");
    ua_lcr11.build();
    ua_ier11.configure(this, null, "ier11");
    ua_ier11.build();
    // Now11 define address mappings11
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch011, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch111, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id11, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl11, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr11, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier11, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c11)
  function new(input string name="unnamed11-uart_ctrl_rf11");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c11

//////////////////////////////////////////////////////////////////////////////
// Address_map11 definition11
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c11 extends uvm_reg_block;

  rand uart_ctrl_rf_c11 uart_ctrl_rf11;

  function void build();
    // Now11 define address mappings11
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf11 = uart_ctrl_rf_c11::type_id::create("uart_ctrl_rf11", , get_full_name());
    uart_ctrl_rf11.configure(this, "regs");
    uart_ctrl_rf11.build();
    uart_ctrl_rf11.lock_model();
    default_map.add_submap(uart_ctrl_rf11.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top11.uart_dut11");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c11)
  function new(input string name="unnamed11-uart_ctrl_reg_model_c11");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c11

`endif // UART_CTRL_REGS_SV11
