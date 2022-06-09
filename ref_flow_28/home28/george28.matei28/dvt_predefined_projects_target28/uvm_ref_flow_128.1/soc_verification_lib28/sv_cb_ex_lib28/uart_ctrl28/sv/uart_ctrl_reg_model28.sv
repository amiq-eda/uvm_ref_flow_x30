// This28 file is generated28 using Cadence28 iregGen28 version28 1.05

`ifndef UART_CTRL_REGS_SV28
`define UART_CTRL_REGS_SV28

// Input28 File28: uart_ctrl_regs28.xml28

// Number28 of AddrMaps28 = 1
// Number28 of RegFiles28 = 1
// Number28 of Registers28 = 6
// Number28 of Memories28 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 262


class ua_div_latch0_c28 extends uvm_reg;

  rand uvm_reg_field div_val28;

  constraint c_div_val28 { div_val28.value == 1; }
  virtual function void build();
    div_val28 = uvm_reg_field::type_id::create("div_val28");
    div_val28.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg28.set_inst_name($sformatf("%s.wcov28", get_full_name()));
    rd_cg28.set_inst_name($sformatf("%s.rcov28", get_full_name()));
  endfunction

  covergroup wr_cg28;
    option.per_instance=1;
    div_val28 : coverpoint div_val28.value[7:0];
  endgroup
  covergroup rd_cg28;
    option.per_instance=1;
    div_val28 : coverpoint div_val28.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg28.sample();
    if(is_read) rd_cg28.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c28, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c28, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c28)
  function new(input string name="unnamed28-ua_div_latch0_c28");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg28=new;
    rd_cg28=new;
  endfunction : new
endclass : ua_div_latch0_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 287


class ua_div_latch1_c28 extends uvm_reg;

  rand uvm_reg_field div_val28;

  constraint c_div_val28 { div_val28.value == 0; }
  virtual function void build();
    div_val28 = uvm_reg_field::type_id::create("div_val28");
    div_val28.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg28.set_inst_name($sformatf("%s.wcov28", get_full_name()));
    rd_cg28.set_inst_name($sformatf("%s.rcov28", get_full_name()));
  endfunction

  covergroup wr_cg28;
    option.per_instance=1;
    div_val28 : coverpoint div_val28.value[7:0];
  endgroup
  covergroup rd_cg28;
    option.per_instance=1;
    div_val28 : coverpoint div_val28.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg28.sample();
    if(is_read) rd_cg28.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c28, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c28, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c28)
  function new(input string name="unnamed28-ua_div_latch1_c28");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg28=new;
    rd_cg28=new;
  endfunction : new
endclass : ua_div_latch1_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 82


class ua_int_id_c28 extends uvm_reg;

  uvm_reg_field priority_bit28;
  uvm_reg_field bit128;
  uvm_reg_field bit228;
  uvm_reg_field bit328;

  virtual function void build();
    priority_bit28 = uvm_reg_field::type_id::create("priority_bit28");
    priority_bit28.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit128 = uvm_reg_field::type_id::create("bit128");
    bit128.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit228 = uvm_reg_field::type_id::create("bit228");
    bit228.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit328 = uvm_reg_field::type_id::create("bit328");
    bit328.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg28.set_inst_name($sformatf("%s.rcov28", get_full_name()));
  endfunction

  covergroup rd_cg28;
    option.per_instance=1;
    priority_bit28 : coverpoint priority_bit28.value[0:0];
    bit128 : coverpoint bit128.value[0:0];
    bit228 : coverpoint bit228.value[0:0];
    bit328 : coverpoint bit328.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg28.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c28, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c28, uvm_reg)
  `uvm_object_utils(ua_int_id_c28)
  function new(input string name="unnamed28-ua_int_id_c28");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg28=new;
  endfunction : new
endclass : ua_int_id_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 139


class ua_fifo_ctrl_c28 extends uvm_reg;

  rand uvm_reg_field rx_clear28;
  rand uvm_reg_field tx_clear28;
  rand uvm_reg_field rx_fifo_int_trig_level28;

  virtual function void build();
    rx_clear28 = uvm_reg_field::type_id::create("rx_clear28");
    rx_clear28.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear28 = uvm_reg_field::type_id::create("tx_clear28");
    tx_clear28.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level28 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level28");
    rx_fifo_int_trig_level28.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg28.set_inst_name($sformatf("%s.wcov28", get_full_name()));
  endfunction

  covergroup wr_cg28;
    option.per_instance=1;
    rx_clear28 : coverpoint rx_clear28.value[0:0];
    tx_clear28 : coverpoint tx_clear28.value[0:0];
    rx_fifo_int_trig_level28 : coverpoint rx_fifo_int_trig_level28.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg28.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c28, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c28, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c28)
  function new(input string name="unnamed28-ua_fifo_ctrl_c28");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg28=new;
  endfunction : new
endclass : ua_fifo_ctrl_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 188


class ua_lcr_c28 extends uvm_reg;

  rand uvm_reg_field char_lngth28;
  rand uvm_reg_field num_stop_bits28;
  rand uvm_reg_field p_en28;
  rand uvm_reg_field parity_even28;
  rand uvm_reg_field parity_sticky28;
  rand uvm_reg_field break_ctrl28;
  rand uvm_reg_field div_latch_access28;

  constraint c_char_lngth28 { char_lngth28.value != 2'b00; }
  constraint c_break_ctrl28 { break_ctrl28.value == 1'b0; }
  virtual function void build();
    char_lngth28 = uvm_reg_field::type_id::create("char_lngth28");
    char_lngth28.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits28 = uvm_reg_field::type_id::create("num_stop_bits28");
    num_stop_bits28.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en28 = uvm_reg_field::type_id::create("p_en28");
    p_en28.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even28 = uvm_reg_field::type_id::create("parity_even28");
    parity_even28.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky28 = uvm_reg_field::type_id::create("parity_sticky28");
    parity_sticky28.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl28 = uvm_reg_field::type_id::create("break_ctrl28");
    break_ctrl28.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access28 = uvm_reg_field::type_id::create("div_latch_access28");
    div_latch_access28.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg28.set_inst_name($sformatf("%s.wcov28", get_full_name()));
    rd_cg28.set_inst_name($sformatf("%s.rcov28", get_full_name()));
  endfunction

  covergroup wr_cg28;
    option.per_instance=1;
    char_lngth28 : coverpoint char_lngth28.value[1:0];
    num_stop_bits28 : coverpoint num_stop_bits28.value[0:0];
    p_en28 : coverpoint p_en28.value[0:0];
    parity_even28 : coverpoint parity_even28.value[0:0];
    parity_sticky28 : coverpoint parity_sticky28.value[0:0];
    break_ctrl28 : coverpoint break_ctrl28.value[0:0];
    div_latch_access28 : coverpoint div_latch_access28.value[0:0];
  endgroup
  covergroup rd_cg28;
    option.per_instance=1;
    char_lngth28 : coverpoint char_lngth28.value[1:0];
    num_stop_bits28 : coverpoint num_stop_bits28.value[0:0];
    p_en28 : coverpoint p_en28.value[0:0];
    parity_even28 : coverpoint parity_even28.value[0:0];
    parity_sticky28 : coverpoint parity_sticky28.value[0:0];
    break_ctrl28 : coverpoint break_ctrl28.value[0:0];
    div_latch_access28 : coverpoint div_latch_access28.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg28.sample();
    if(is_read) rd_cg28.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c28, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c28, uvm_reg)
  `uvm_object_utils(ua_lcr_c28)
  function new(input string name="unnamed28-ua_lcr_c28");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg28=new;
    rd_cg28=new;
  endfunction : new
endclass : ua_lcr_c28

//////////////////////////////////////////////////////////////////////////////
// Register definition28
//////////////////////////////////////////////////////////////////////////////
// Line28 Number28: 25


class ua_ier_c28 extends uvm_reg;

  rand uvm_reg_field rx_data28;
  rand uvm_reg_field tx_data28;
  rand uvm_reg_field rx_line_sts28;
  rand uvm_reg_field mdm_sts28;

  virtual function void build();
    rx_data28 = uvm_reg_field::type_id::create("rx_data28");
    rx_data28.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data28 = uvm_reg_field::type_id::create("tx_data28");
    tx_data28.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts28 = uvm_reg_field::type_id::create("rx_line_sts28");
    rx_line_sts28.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts28 = uvm_reg_field::type_id::create("mdm_sts28");
    mdm_sts28.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg28.set_inst_name($sformatf("%s.wcov28", get_full_name()));
    rd_cg28.set_inst_name($sformatf("%s.rcov28", get_full_name()));
  endfunction

  covergroup wr_cg28;
    option.per_instance=1;
    rx_data28 : coverpoint rx_data28.value[0:0];
    tx_data28 : coverpoint tx_data28.value[0:0];
    rx_line_sts28 : coverpoint rx_line_sts28.value[0:0];
    mdm_sts28 : coverpoint mdm_sts28.value[0:0];
  endgroup
  covergroup rd_cg28;
    option.per_instance=1;
    rx_data28 : coverpoint rx_data28.value[0:0];
    tx_data28 : coverpoint tx_data28.value[0:0];
    rx_line_sts28 : coverpoint rx_line_sts28.value[0:0];
    mdm_sts28 : coverpoint mdm_sts28.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg28.sample();
    if(is_read) rd_cg28.sample();
  endfunction

  `uvm_register_cb(ua_ier_c28, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c28, uvm_reg)
  `uvm_object_utils(ua_ier_c28)
  function new(input string name="unnamed28-ua_ier_c28");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg28=new;
    rd_cg28=new;
  endfunction : new
endclass : ua_ier_c28

class uart_ctrl_rf_c28 extends uvm_reg_block;

  rand ua_div_latch0_c28 ua_div_latch028;
  rand ua_div_latch1_c28 ua_div_latch128;
  rand ua_int_id_c28 ua_int_id28;
  rand ua_fifo_ctrl_c28 ua_fifo_ctrl28;
  rand ua_lcr_c28 ua_lcr28;
  rand ua_ier_c28 ua_ier28;

  virtual function void build();

    // Now28 create all registers

    ua_div_latch028 = ua_div_latch0_c28::type_id::create("ua_div_latch028", , get_full_name());
    ua_div_latch128 = ua_div_latch1_c28::type_id::create("ua_div_latch128", , get_full_name());
    ua_int_id28 = ua_int_id_c28::type_id::create("ua_int_id28", , get_full_name());
    ua_fifo_ctrl28 = ua_fifo_ctrl_c28::type_id::create("ua_fifo_ctrl28", , get_full_name());
    ua_lcr28 = ua_lcr_c28::type_id::create("ua_lcr28", , get_full_name());
    ua_ier28 = ua_ier_c28::type_id::create("ua_ier28", , get_full_name());

    // Now28 build the registers. Set parent and hdl_paths

    ua_div_latch028.configure(this, null, "dl28[7:0]");
    ua_div_latch028.build();
    ua_div_latch128.configure(this, null, "dl28[15;8]");
    ua_div_latch128.build();
    ua_int_id28.configure(this, null, "iir28");
    ua_int_id28.build();
    ua_fifo_ctrl28.configure(this, null, "fcr28");
    ua_fifo_ctrl28.build();
    ua_lcr28.configure(this, null, "lcr28");
    ua_lcr28.build();
    ua_ier28.configure(this, null, "ier28");
    ua_ier28.build();
    // Now28 define address mappings28
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch028, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch128, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id28, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl28, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr28, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier28, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c28)
  function new(input string name="unnamed28-uart_ctrl_rf28");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c28

//////////////////////////////////////////////////////////////////////////////
// Address_map28 definition28
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c28 extends uvm_reg_block;

  rand uart_ctrl_rf_c28 uart_ctrl_rf28;

  function void build();
    // Now28 define address mappings28
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf28 = uart_ctrl_rf_c28::type_id::create("uart_ctrl_rf28", , get_full_name());
    uart_ctrl_rf28.configure(this, "regs");
    uart_ctrl_rf28.build();
    uart_ctrl_rf28.lock_model();
    default_map.add_submap(uart_ctrl_rf28.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top28.uart_dut28");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c28)
  function new(input string name="unnamed28-uart_ctrl_reg_model_c28");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c28

`endif // UART_CTRL_REGS_SV28
