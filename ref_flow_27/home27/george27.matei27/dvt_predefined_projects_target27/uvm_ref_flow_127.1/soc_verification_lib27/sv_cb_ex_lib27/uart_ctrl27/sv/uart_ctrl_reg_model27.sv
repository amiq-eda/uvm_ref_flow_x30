// This27 file is generated27 using Cadence27 iregGen27 version27 1.05

`ifndef UART_CTRL_REGS_SV27
`define UART_CTRL_REGS_SV27

// Input27 File27: uart_ctrl_regs27.xml27

// Number27 of AddrMaps27 = 1
// Number27 of RegFiles27 = 1
// Number27 of Registers27 = 6
// Number27 of Memories27 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 262


class ua_div_latch0_c27 extends uvm_reg;

  rand uvm_reg_field div_val27;

  constraint c_div_val27 { div_val27.value == 1; }
  virtual function void build();
    div_val27 = uvm_reg_field::type_id::create("div_val27");
    div_val27.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg27.set_inst_name($sformatf("%s.wcov27", get_full_name()));
    rd_cg27.set_inst_name($sformatf("%s.rcov27", get_full_name()));
  endfunction

  covergroup wr_cg27;
    option.per_instance=1;
    div_val27 : coverpoint div_val27.value[7:0];
  endgroup
  covergroup rd_cg27;
    option.per_instance=1;
    div_val27 : coverpoint div_val27.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg27.sample();
    if(is_read) rd_cg27.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c27, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c27, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c27)
  function new(input string name="unnamed27-ua_div_latch0_c27");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg27=new;
    rd_cg27=new;
  endfunction : new
endclass : ua_div_latch0_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 287


class ua_div_latch1_c27 extends uvm_reg;

  rand uvm_reg_field div_val27;

  constraint c_div_val27 { div_val27.value == 0; }
  virtual function void build();
    div_val27 = uvm_reg_field::type_id::create("div_val27");
    div_val27.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg27.set_inst_name($sformatf("%s.wcov27", get_full_name()));
    rd_cg27.set_inst_name($sformatf("%s.rcov27", get_full_name()));
  endfunction

  covergroup wr_cg27;
    option.per_instance=1;
    div_val27 : coverpoint div_val27.value[7:0];
  endgroup
  covergroup rd_cg27;
    option.per_instance=1;
    div_val27 : coverpoint div_val27.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg27.sample();
    if(is_read) rd_cg27.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c27, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c27, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c27)
  function new(input string name="unnamed27-ua_div_latch1_c27");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg27=new;
    rd_cg27=new;
  endfunction : new
endclass : ua_div_latch1_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 82


class ua_int_id_c27 extends uvm_reg;

  uvm_reg_field priority_bit27;
  uvm_reg_field bit127;
  uvm_reg_field bit227;
  uvm_reg_field bit327;

  virtual function void build();
    priority_bit27 = uvm_reg_field::type_id::create("priority_bit27");
    priority_bit27.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit127 = uvm_reg_field::type_id::create("bit127");
    bit127.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit227 = uvm_reg_field::type_id::create("bit227");
    bit227.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit327 = uvm_reg_field::type_id::create("bit327");
    bit327.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg27.set_inst_name($sformatf("%s.rcov27", get_full_name()));
  endfunction

  covergroup rd_cg27;
    option.per_instance=1;
    priority_bit27 : coverpoint priority_bit27.value[0:0];
    bit127 : coverpoint bit127.value[0:0];
    bit227 : coverpoint bit227.value[0:0];
    bit327 : coverpoint bit327.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg27.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c27, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c27, uvm_reg)
  `uvm_object_utils(ua_int_id_c27)
  function new(input string name="unnamed27-ua_int_id_c27");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg27=new;
  endfunction : new
endclass : ua_int_id_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 139


class ua_fifo_ctrl_c27 extends uvm_reg;

  rand uvm_reg_field rx_clear27;
  rand uvm_reg_field tx_clear27;
  rand uvm_reg_field rx_fifo_int_trig_level27;

  virtual function void build();
    rx_clear27 = uvm_reg_field::type_id::create("rx_clear27");
    rx_clear27.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear27 = uvm_reg_field::type_id::create("tx_clear27");
    tx_clear27.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level27 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level27");
    rx_fifo_int_trig_level27.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg27.set_inst_name($sformatf("%s.wcov27", get_full_name()));
  endfunction

  covergroup wr_cg27;
    option.per_instance=1;
    rx_clear27 : coverpoint rx_clear27.value[0:0];
    tx_clear27 : coverpoint tx_clear27.value[0:0];
    rx_fifo_int_trig_level27 : coverpoint rx_fifo_int_trig_level27.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg27.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c27, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c27, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c27)
  function new(input string name="unnamed27-ua_fifo_ctrl_c27");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg27=new;
  endfunction : new
endclass : ua_fifo_ctrl_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 188


class ua_lcr_c27 extends uvm_reg;

  rand uvm_reg_field char_lngth27;
  rand uvm_reg_field num_stop_bits27;
  rand uvm_reg_field p_en27;
  rand uvm_reg_field parity_even27;
  rand uvm_reg_field parity_sticky27;
  rand uvm_reg_field break_ctrl27;
  rand uvm_reg_field div_latch_access27;

  constraint c_char_lngth27 { char_lngth27.value != 2'b00; }
  constraint c_break_ctrl27 { break_ctrl27.value == 1'b0; }
  virtual function void build();
    char_lngth27 = uvm_reg_field::type_id::create("char_lngth27");
    char_lngth27.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits27 = uvm_reg_field::type_id::create("num_stop_bits27");
    num_stop_bits27.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en27 = uvm_reg_field::type_id::create("p_en27");
    p_en27.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even27 = uvm_reg_field::type_id::create("parity_even27");
    parity_even27.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky27 = uvm_reg_field::type_id::create("parity_sticky27");
    parity_sticky27.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl27 = uvm_reg_field::type_id::create("break_ctrl27");
    break_ctrl27.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access27 = uvm_reg_field::type_id::create("div_latch_access27");
    div_latch_access27.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg27.set_inst_name($sformatf("%s.wcov27", get_full_name()));
    rd_cg27.set_inst_name($sformatf("%s.rcov27", get_full_name()));
  endfunction

  covergroup wr_cg27;
    option.per_instance=1;
    char_lngth27 : coverpoint char_lngth27.value[1:0];
    num_stop_bits27 : coverpoint num_stop_bits27.value[0:0];
    p_en27 : coverpoint p_en27.value[0:0];
    parity_even27 : coverpoint parity_even27.value[0:0];
    parity_sticky27 : coverpoint parity_sticky27.value[0:0];
    break_ctrl27 : coverpoint break_ctrl27.value[0:0];
    div_latch_access27 : coverpoint div_latch_access27.value[0:0];
  endgroup
  covergroup rd_cg27;
    option.per_instance=1;
    char_lngth27 : coverpoint char_lngth27.value[1:0];
    num_stop_bits27 : coverpoint num_stop_bits27.value[0:0];
    p_en27 : coverpoint p_en27.value[0:0];
    parity_even27 : coverpoint parity_even27.value[0:0];
    parity_sticky27 : coverpoint parity_sticky27.value[0:0];
    break_ctrl27 : coverpoint break_ctrl27.value[0:0];
    div_latch_access27 : coverpoint div_latch_access27.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg27.sample();
    if(is_read) rd_cg27.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c27, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c27, uvm_reg)
  `uvm_object_utils(ua_lcr_c27)
  function new(input string name="unnamed27-ua_lcr_c27");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg27=new;
    rd_cg27=new;
  endfunction : new
endclass : ua_lcr_c27

//////////////////////////////////////////////////////////////////////////////
// Register definition27
//////////////////////////////////////////////////////////////////////////////
// Line27 Number27: 25


class ua_ier_c27 extends uvm_reg;

  rand uvm_reg_field rx_data27;
  rand uvm_reg_field tx_data27;
  rand uvm_reg_field rx_line_sts27;
  rand uvm_reg_field mdm_sts27;

  virtual function void build();
    rx_data27 = uvm_reg_field::type_id::create("rx_data27");
    rx_data27.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data27 = uvm_reg_field::type_id::create("tx_data27");
    tx_data27.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts27 = uvm_reg_field::type_id::create("rx_line_sts27");
    rx_line_sts27.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts27 = uvm_reg_field::type_id::create("mdm_sts27");
    mdm_sts27.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg27.set_inst_name($sformatf("%s.wcov27", get_full_name()));
    rd_cg27.set_inst_name($sformatf("%s.rcov27", get_full_name()));
  endfunction

  covergroup wr_cg27;
    option.per_instance=1;
    rx_data27 : coverpoint rx_data27.value[0:0];
    tx_data27 : coverpoint tx_data27.value[0:0];
    rx_line_sts27 : coverpoint rx_line_sts27.value[0:0];
    mdm_sts27 : coverpoint mdm_sts27.value[0:0];
  endgroup
  covergroup rd_cg27;
    option.per_instance=1;
    rx_data27 : coverpoint rx_data27.value[0:0];
    tx_data27 : coverpoint tx_data27.value[0:0];
    rx_line_sts27 : coverpoint rx_line_sts27.value[0:0];
    mdm_sts27 : coverpoint mdm_sts27.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg27.sample();
    if(is_read) rd_cg27.sample();
  endfunction

  `uvm_register_cb(ua_ier_c27, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c27, uvm_reg)
  `uvm_object_utils(ua_ier_c27)
  function new(input string name="unnamed27-ua_ier_c27");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg27=new;
    rd_cg27=new;
  endfunction : new
endclass : ua_ier_c27

class uart_ctrl_rf_c27 extends uvm_reg_block;

  rand ua_div_latch0_c27 ua_div_latch027;
  rand ua_div_latch1_c27 ua_div_latch127;
  rand ua_int_id_c27 ua_int_id27;
  rand ua_fifo_ctrl_c27 ua_fifo_ctrl27;
  rand ua_lcr_c27 ua_lcr27;
  rand ua_ier_c27 ua_ier27;

  virtual function void build();

    // Now27 create all registers

    ua_div_latch027 = ua_div_latch0_c27::type_id::create("ua_div_latch027", , get_full_name());
    ua_div_latch127 = ua_div_latch1_c27::type_id::create("ua_div_latch127", , get_full_name());
    ua_int_id27 = ua_int_id_c27::type_id::create("ua_int_id27", , get_full_name());
    ua_fifo_ctrl27 = ua_fifo_ctrl_c27::type_id::create("ua_fifo_ctrl27", , get_full_name());
    ua_lcr27 = ua_lcr_c27::type_id::create("ua_lcr27", , get_full_name());
    ua_ier27 = ua_ier_c27::type_id::create("ua_ier27", , get_full_name());

    // Now27 build the registers. Set parent and hdl_paths

    ua_div_latch027.configure(this, null, "dl27[7:0]");
    ua_div_latch027.build();
    ua_div_latch127.configure(this, null, "dl27[15;8]");
    ua_div_latch127.build();
    ua_int_id27.configure(this, null, "iir27");
    ua_int_id27.build();
    ua_fifo_ctrl27.configure(this, null, "fcr27");
    ua_fifo_ctrl27.build();
    ua_lcr27.configure(this, null, "lcr27");
    ua_lcr27.build();
    ua_ier27.configure(this, null, "ier27");
    ua_ier27.build();
    // Now27 define address mappings27
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch027, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch127, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id27, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl27, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr27, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier27, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c27)
  function new(input string name="unnamed27-uart_ctrl_rf27");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c27

//////////////////////////////////////////////////////////////////////////////
// Address_map27 definition27
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c27 extends uvm_reg_block;

  rand uart_ctrl_rf_c27 uart_ctrl_rf27;

  function void build();
    // Now27 define address mappings27
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf27 = uart_ctrl_rf_c27::type_id::create("uart_ctrl_rf27", , get_full_name());
    uart_ctrl_rf27.configure(this, "regs");
    uart_ctrl_rf27.build();
    uart_ctrl_rf27.lock_model();
    default_map.add_submap(uart_ctrl_rf27.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top27.uart_dut27");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c27)
  function new(input string name="unnamed27-uart_ctrl_reg_model_c27");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c27

`endif // UART_CTRL_REGS_SV27
