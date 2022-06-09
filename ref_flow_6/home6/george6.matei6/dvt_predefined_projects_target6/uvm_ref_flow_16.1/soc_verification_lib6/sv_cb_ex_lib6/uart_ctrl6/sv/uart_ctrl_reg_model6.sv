// This6 file is generated6 using Cadence6 iregGen6 version6 1.05

`ifndef UART_CTRL_REGS_SV6
`define UART_CTRL_REGS_SV6

// Input6 File6: uart_ctrl_regs6.xml6

// Number6 of AddrMaps6 = 1
// Number6 of RegFiles6 = 1
// Number6 of Registers6 = 6
// Number6 of Memories6 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 262


class ua_div_latch0_c6 extends uvm_reg;

  rand uvm_reg_field div_val6;

  constraint c_div_val6 { div_val6.value == 1; }
  virtual function void build();
    div_val6 = uvm_reg_field::type_id::create("div_val6");
    div_val6.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg6.set_inst_name($sformatf("%s.wcov6", get_full_name()));
    rd_cg6.set_inst_name($sformatf("%s.rcov6", get_full_name()));
  endfunction

  covergroup wr_cg6;
    option.per_instance=1;
    div_val6 : coverpoint div_val6.value[7:0];
  endgroup
  covergroup rd_cg6;
    option.per_instance=1;
    div_val6 : coverpoint div_val6.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg6.sample();
    if(is_read) rd_cg6.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c6, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c6, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c6)
  function new(input string name="unnamed6-ua_div_latch0_c6");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg6=new;
    rd_cg6=new;
  endfunction : new
endclass : ua_div_latch0_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 287


class ua_div_latch1_c6 extends uvm_reg;

  rand uvm_reg_field div_val6;

  constraint c_div_val6 { div_val6.value == 0; }
  virtual function void build();
    div_val6 = uvm_reg_field::type_id::create("div_val6");
    div_val6.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg6.set_inst_name($sformatf("%s.wcov6", get_full_name()));
    rd_cg6.set_inst_name($sformatf("%s.rcov6", get_full_name()));
  endfunction

  covergroup wr_cg6;
    option.per_instance=1;
    div_val6 : coverpoint div_val6.value[7:0];
  endgroup
  covergroup rd_cg6;
    option.per_instance=1;
    div_val6 : coverpoint div_val6.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg6.sample();
    if(is_read) rd_cg6.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c6, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c6, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c6)
  function new(input string name="unnamed6-ua_div_latch1_c6");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg6=new;
    rd_cg6=new;
  endfunction : new
endclass : ua_div_latch1_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 82


class ua_int_id_c6 extends uvm_reg;

  uvm_reg_field priority_bit6;
  uvm_reg_field bit16;
  uvm_reg_field bit26;
  uvm_reg_field bit36;

  virtual function void build();
    priority_bit6 = uvm_reg_field::type_id::create("priority_bit6");
    priority_bit6.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit16 = uvm_reg_field::type_id::create("bit16");
    bit16.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit26 = uvm_reg_field::type_id::create("bit26");
    bit26.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit36 = uvm_reg_field::type_id::create("bit36");
    bit36.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg6.set_inst_name($sformatf("%s.rcov6", get_full_name()));
  endfunction

  covergroup rd_cg6;
    option.per_instance=1;
    priority_bit6 : coverpoint priority_bit6.value[0:0];
    bit16 : coverpoint bit16.value[0:0];
    bit26 : coverpoint bit26.value[0:0];
    bit36 : coverpoint bit36.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg6.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c6, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c6, uvm_reg)
  `uvm_object_utils(ua_int_id_c6)
  function new(input string name="unnamed6-ua_int_id_c6");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg6=new;
  endfunction : new
endclass : ua_int_id_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 139


class ua_fifo_ctrl_c6 extends uvm_reg;

  rand uvm_reg_field rx_clear6;
  rand uvm_reg_field tx_clear6;
  rand uvm_reg_field rx_fifo_int_trig_level6;

  virtual function void build();
    rx_clear6 = uvm_reg_field::type_id::create("rx_clear6");
    rx_clear6.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear6 = uvm_reg_field::type_id::create("tx_clear6");
    tx_clear6.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level6 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level6");
    rx_fifo_int_trig_level6.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg6.set_inst_name($sformatf("%s.wcov6", get_full_name()));
  endfunction

  covergroup wr_cg6;
    option.per_instance=1;
    rx_clear6 : coverpoint rx_clear6.value[0:0];
    tx_clear6 : coverpoint tx_clear6.value[0:0];
    rx_fifo_int_trig_level6 : coverpoint rx_fifo_int_trig_level6.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg6.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c6, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c6, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c6)
  function new(input string name="unnamed6-ua_fifo_ctrl_c6");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg6=new;
  endfunction : new
endclass : ua_fifo_ctrl_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 188


class ua_lcr_c6 extends uvm_reg;

  rand uvm_reg_field char_lngth6;
  rand uvm_reg_field num_stop_bits6;
  rand uvm_reg_field p_en6;
  rand uvm_reg_field parity_even6;
  rand uvm_reg_field parity_sticky6;
  rand uvm_reg_field break_ctrl6;
  rand uvm_reg_field div_latch_access6;

  constraint c_char_lngth6 { char_lngth6.value != 2'b00; }
  constraint c_break_ctrl6 { break_ctrl6.value == 1'b0; }
  virtual function void build();
    char_lngth6 = uvm_reg_field::type_id::create("char_lngth6");
    char_lngth6.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits6 = uvm_reg_field::type_id::create("num_stop_bits6");
    num_stop_bits6.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en6 = uvm_reg_field::type_id::create("p_en6");
    p_en6.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even6 = uvm_reg_field::type_id::create("parity_even6");
    parity_even6.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky6 = uvm_reg_field::type_id::create("parity_sticky6");
    parity_sticky6.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl6 = uvm_reg_field::type_id::create("break_ctrl6");
    break_ctrl6.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access6 = uvm_reg_field::type_id::create("div_latch_access6");
    div_latch_access6.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg6.set_inst_name($sformatf("%s.wcov6", get_full_name()));
    rd_cg6.set_inst_name($sformatf("%s.rcov6", get_full_name()));
  endfunction

  covergroup wr_cg6;
    option.per_instance=1;
    char_lngth6 : coverpoint char_lngth6.value[1:0];
    num_stop_bits6 : coverpoint num_stop_bits6.value[0:0];
    p_en6 : coverpoint p_en6.value[0:0];
    parity_even6 : coverpoint parity_even6.value[0:0];
    parity_sticky6 : coverpoint parity_sticky6.value[0:0];
    break_ctrl6 : coverpoint break_ctrl6.value[0:0];
    div_latch_access6 : coverpoint div_latch_access6.value[0:0];
  endgroup
  covergroup rd_cg6;
    option.per_instance=1;
    char_lngth6 : coverpoint char_lngth6.value[1:0];
    num_stop_bits6 : coverpoint num_stop_bits6.value[0:0];
    p_en6 : coverpoint p_en6.value[0:0];
    parity_even6 : coverpoint parity_even6.value[0:0];
    parity_sticky6 : coverpoint parity_sticky6.value[0:0];
    break_ctrl6 : coverpoint break_ctrl6.value[0:0];
    div_latch_access6 : coverpoint div_latch_access6.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg6.sample();
    if(is_read) rd_cg6.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c6, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c6, uvm_reg)
  `uvm_object_utils(ua_lcr_c6)
  function new(input string name="unnamed6-ua_lcr_c6");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg6=new;
    rd_cg6=new;
  endfunction : new
endclass : ua_lcr_c6

//////////////////////////////////////////////////////////////////////////////
// Register definition6
//////////////////////////////////////////////////////////////////////////////
// Line6 Number6: 25


class ua_ier_c6 extends uvm_reg;

  rand uvm_reg_field rx_data6;
  rand uvm_reg_field tx_data6;
  rand uvm_reg_field rx_line_sts6;
  rand uvm_reg_field mdm_sts6;

  virtual function void build();
    rx_data6 = uvm_reg_field::type_id::create("rx_data6");
    rx_data6.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data6 = uvm_reg_field::type_id::create("tx_data6");
    tx_data6.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts6 = uvm_reg_field::type_id::create("rx_line_sts6");
    rx_line_sts6.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts6 = uvm_reg_field::type_id::create("mdm_sts6");
    mdm_sts6.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg6.set_inst_name($sformatf("%s.wcov6", get_full_name()));
    rd_cg6.set_inst_name($sformatf("%s.rcov6", get_full_name()));
  endfunction

  covergroup wr_cg6;
    option.per_instance=1;
    rx_data6 : coverpoint rx_data6.value[0:0];
    tx_data6 : coverpoint tx_data6.value[0:0];
    rx_line_sts6 : coverpoint rx_line_sts6.value[0:0];
    mdm_sts6 : coverpoint mdm_sts6.value[0:0];
  endgroup
  covergroup rd_cg6;
    option.per_instance=1;
    rx_data6 : coverpoint rx_data6.value[0:0];
    tx_data6 : coverpoint tx_data6.value[0:0];
    rx_line_sts6 : coverpoint rx_line_sts6.value[0:0];
    mdm_sts6 : coverpoint mdm_sts6.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg6.sample();
    if(is_read) rd_cg6.sample();
  endfunction

  `uvm_register_cb(ua_ier_c6, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c6, uvm_reg)
  `uvm_object_utils(ua_ier_c6)
  function new(input string name="unnamed6-ua_ier_c6");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg6=new;
    rd_cg6=new;
  endfunction : new
endclass : ua_ier_c6

class uart_ctrl_rf_c6 extends uvm_reg_block;

  rand ua_div_latch0_c6 ua_div_latch06;
  rand ua_div_latch1_c6 ua_div_latch16;
  rand ua_int_id_c6 ua_int_id6;
  rand ua_fifo_ctrl_c6 ua_fifo_ctrl6;
  rand ua_lcr_c6 ua_lcr6;
  rand ua_ier_c6 ua_ier6;

  virtual function void build();

    // Now6 create all registers

    ua_div_latch06 = ua_div_latch0_c6::type_id::create("ua_div_latch06", , get_full_name());
    ua_div_latch16 = ua_div_latch1_c6::type_id::create("ua_div_latch16", , get_full_name());
    ua_int_id6 = ua_int_id_c6::type_id::create("ua_int_id6", , get_full_name());
    ua_fifo_ctrl6 = ua_fifo_ctrl_c6::type_id::create("ua_fifo_ctrl6", , get_full_name());
    ua_lcr6 = ua_lcr_c6::type_id::create("ua_lcr6", , get_full_name());
    ua_ier6 = ua_ier_c6::type_id::create("ua_ier6", , get_full_name());

    // Now6 build the registers. Set parent and hdl_paths

    ua_div_latch06.configure(this, null, "dl6[7:0]");
    ua_div_latch06.build();
    ua_div_latch16.configure(this, null, "dl6[15;8]");
    ua_div_latch16.build();
    ua_int_id6.configure(this, null, "iir6");
    ua_int_id6.build();
    ua_fifo_ctrl6.configure(this, null, "fcr6");
    ua_fifo_ctrl6.build();
    ua_lcr6.configure(this, null, "lcr6");
    ua_lcr6.build();
    ua_ier6.configure(this, null, "ier6");
    ua_ier6.build();
    // Now6 define address mappings6
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch06, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch16, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id6, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl6, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr6, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier6, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c6)
  function new(input string name="unnamed6-uart_ctrl_rf6");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c6

//////////////////////////////////////////////////////////////////////////////
// Address_map6 definition6
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c6 extends uvm_reg_block;

  rand uart_ctrl_rf_c6 uart_ctrl_rf6;

  function void build();
    // Now6 define address mappings6
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf6 = uart_ctrl_rf_c6::type_id::create("uart_ctrl_rf6", , get_full_name());
    uart_ctrl_rf6.configure(this, "regs");
    uart_ctrl_rf6.build();
    uart_ctrl_rf6.lock_model();
    default_map.add_submap(uart_ctrl_rf6.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top6.uart_dut6");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c6)
  function new(input string name="unnamed6-uart_ctrl_reg_model_c6");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c6

`endif // UART_CTRL_REGS_SV6
