// This2 file is generated2 using Cadence2 iregGen2 version2 1.05

`ifndef UART_CTRL_REGS_SV2
`define UART_CTRL_REGS_SV2

// Input2 File2: uart_ctrl_regs2.xml2

// Number2 of AddrMaps2 = 1
// Number2 of RegFiles2 = 1
// Number2 of Registers2 = 6
// Number2 of Memories2 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 262


class ua_div_latch0_c2 extends uvm_reg;

  rand uvm_reg_field div_val2;

  constraint c_div_val2 { div_val2.value == 1; }
  virtual function void build();
    div_val2 = uvm_reg_field::type_id::create("div_val2");
    div_val2.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg2.set_inst_name($sformatf("%s.wcov2", get_full_name()));
    rd_cg2.set_inst_name($sformatf("%s.rcov2", get_full_name()));
  endfunction

  covergroup wr_cg2;
    option.per_instance=1;
    div_val2 : coverpoint div_val2.value[7:0];
  endgroup
  covergroup rd_cg2;
    option.per_instance=1;
    div_val2 : coverpoint div_val2.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg2.sample();
    if(is_read) rd_cg2.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c2, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c2, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c2)
  function new(input string name="unnamed2-ua_div_latch0_c2");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg2=new;
    rd_cg2=new;
  endfunction : new
endclass : ua_div_latch0_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 287


class ua_div_latch1_c2 extends uvm_reg;

  rand uvm_reg_field div_val2;

  constraint c_div_val2 { div_val2.value == 0; }
  virtual function void build();
    div_val2 = uvm_reg_field::type_id::create("div_val2");
    div_val2.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg2.set_inst_name($sformatf("%s.wcov2", get_full_name()));
    rd_cg2.set_inst_name($sformatf("%s.rcov2", get_full_name()));
  endfunction

  covergroup wr_cg2;
    option.per_instance=1;
    div_val2 : coverpoint div_val2.value[7:0];
  endgroup
  covergroup rd_cg2;
    option.per_instance=1;
    div_val2 : coverpoint div_val2.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg2.sample();
    if(is_read) rd_cg2.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c2, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c2, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c2)
  function new(input string name="unnamed2-ua_div_latch1_c2");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg2=new;
    rd_cg2=new;
  endfunction : new
endclass : ua_div_latch1_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 82


class ua_int_id_c2 extends uvm_reg;

  uvm_reg_field priority_bit2;
  uvm_reg_field bit12;
  uvm_reg_field bit22;
  uvm_reg_field bit32;

  virtual function void build();
    priority_bit2 = uvm_reg_field::type_id::create("priority_bit2");
    priority_bit2.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit12 = uvm_reg_field::type_id::create("bit12");
    bit12.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit22 = uvm_reg_field::type_id::create("bit22");
    bit22.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit32 = uvm_reg_field::type_id::create("bit32");
    bit32.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg2.set_inst_name($sformatf("%s.rcov2", get_full_name()));
  endfunction

  covergroup rd_cg2;
    option.per_instance=1;
    priority_bit2 : coverpoint priority_bit2.value[0:0];
    bit12 : coverpoint bit12.value[0:0];
    bit22 : coverpoint bit22.value[0:0];
    bit32 : coverpoint bit32.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg2.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c2, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c2, uvm_reg)
  `uvm_object_utils(ua_int_id_c2)
  function new(input string name="unnamed2-ua_int_id_c2");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg2=new;
  endfunction : new
endclass : ua_int_id_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 139


class ua_fifo_ctrl_c2 extends uvm_reg;

  rand uvm_reg_field rx_clear2;
  rand uvm_reg_field tx_clear2;
  rand uvm_reg_field rx_fifo_int_trig_level2;

  virtual function void build();
    rx_clear2 = uvm_reg_field::type_id::create("rx_clear2");
    rx_clear2.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear2 = uvm_reg_field::type_id::create("tx_clear2");
    tx_clear2.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level2 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level2");
    rx_fifo_int_trig_level2.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg2.set_inst_name($sformatf("%s.wcov2", get_full_name()));
  endfunction

  covergroup wr_cg2;
    option.per_instance=1;
    rx_clear2 : coverpoint rx_clear2.value[0:0];
    tx_clear2 : coverpoint tx_clear2.value[0:0];
    rx_fifo_int_trig_level2 : coverpoint rx_fifo_int_trig_level2.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg2.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c2, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c2, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c2)
  function new(input string name="unnamed2-ua_fifo_ctrl_c2");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg2=new;
  endfunction : new
endclass : ua_fifo_ctrl_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 188


class ua_lcr_c2 extends uvm_reg;

  rand uvm_reg_field char_lngth2;
  rand uvm_reg_field num_stop_bits2;
  rand uvm_reg_field p_en2;
  rand uvm_reg_field parity_even2;
  rand uvm_reg_field parity_sticky2;
  rand uvm_reg_field break_ctrl2;
  rand uvm_reg_field div_latch_access2;

  constraint c_char_lngth2 { char_lngth2.value != 2'b00; }
  constraint c_break_ctrl2 { break_ctrl2.value == 1'b0; }
  virtual function void build();
    char_lngth2 = uvm_reg_field::type_id::create("char_lngth2");
    char_lngth2.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits2 = uvm_reg_field::type_id::create("num_stop_bits2");
    num_stop_bits2.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en2 = uvm_reg_field::type_id::create("p_en2");
    p_en2.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even2 = uvm_reg_field::type_id::create("parity_even2");
    parity_even2.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky2 = uvm_reg_field::type_id::create("parity_sticky2");
    parity_sticky2.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl2 = uvm_reg_field::type_id::create("break_ctrl2");
    break_ctrl2.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access2 = uvm_reg_field::type_id::create("div_latch_access2");
    div_latch_access2.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg2.set_inst_name($sformatf("%s.wcov2", get_full_name()));
    rd_cg2.set_inst_name($sformatf("%s.rcov2", get_full_name()));
  endfunction

  covergroup wr_cg2;
    option.per_instance=1;
    char_lngth2 : coverpoint char_lngth2.value[1:0];
    num_stop_bits2 : coverpoint num_stop_bits2.value[0:0];
    p_en2 : coverpoint p_en2.value[0:0];
    parity_even2 : coverpoint parity_even2.value[0:0];
    parity_sticky2 : coverpoint parity_sticky2.value[0:0];
    break_ctrl2 : coverpoint break_ctrl2.value[0:0];
    div_latch_access2 : coverpoint div_latch_access2.value[0:0];
  endgroup
  covergroup rd_cg2;
    option.per_instance=1;
    char_lngth2 : coverpoint char_lngth2.value[1:0];
    num_stop_bits2 : coverpoint num_stop_bits2.value[0:0];
    p_en2 : coverpoint p_en2.value[0:0];
    parity_even2 : coverpoint parity_even2.value[0:0];
    parity_sticky2 : coverpoint parity_sticky2.value[0:0];
    break_ctrl2 : coverpoint break_ctrl2.value[0:0];
    div_latch_access2 : coverpoint div_latch_access2.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg2.sample();
    if(is_read) rd_cg2.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c2, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c2, uvm_reg)
  `uvm_object_utils(ua_lcr_c2)
  function new(input string name="unnamed2-ua_lcr_c2");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg2=new;
    rd_cg2=new;
  endfunction : new
endclass : ua_lcr_c2

//////////////////////////////////////////////////////////////////////////////
// Register definition2
//////////////////////////////////////////////////////////////////////////////
// Line2 Number2: 25


class ua_ier_c2 extends uvm_reg;

  rand uvm_reg_field rx_data2;
  rand uvm_reg_field tx_data2;
  rand uvm_reg_field rx_line_sts2;
  rand uvm_reg_field mdm_sts2;

  virtual function void build();
    rx_data2 = uvm_reg_field::type_id::create("rx_data2");
    rx_data2.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data2 = uvm_reg_field::type_id::create("tx_data2");
    tx_data2.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts2 = uvm_reg_field::type_id::create("rx_line_sts2");
    rx_line_sts2.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts2 = uvm_reg_field::type_id::create("mdm_sts2");
    mdm_sts2.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg2.set_inst_name($sformatf("%s.wcov2", get_full_name()));
    rd_cg2.set_inst_name($sformatf("%s.rcov2", get_full_name()));
  endfunction

  covergroup wr_cg2;
    option.per_instance=1;
    rx_data2 : coverpoint rx_data2.value[0:0];
    tx_data2 : coverpoint tx_data2.value[0:0];
    rx_line_sts2 : coverpoint rx_line_sts2.value[0:0];
    mdm_sts2 : coverpoint mdm_sts2.value[0:0];
  endgroup
  covergroup rd_cg2;
    option.per_instance=1;
    rx_data2 : coverpoint rx_data2.value[0:0];
    tx_data2 : coverpoint tx_data2.value[0:0];
    rx_line_sts2 : coverpoint rx_line_sts2.value[0:0];
    mdm_sts2 : coverpoint mdm_sts2.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg2.sample();
    if(is_read) rd_cg2.sample();
  endfunction

  `uvm_register_cb(ua_ier_c2, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c2, uvm_reg)
  `uvm_object_utils(ua_ier_c2)
  function new(input string name="unnamed2-ua_ier_c2");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg2=new;
    rd_cg2=new;
  endfunction : new
endclass : ua_ier_c2

class uart_ctrl_rf_c2 extends uvm_reg_block;

  rand ua_div_latch0_c2 ua_div_latch02;
  rand ua_div_latch1_c2 ua_div_latch12;
  rand ua_int_id_c2 ua_int_id2;
  rand ua_fifo_ctrl_c2 ua_fifo_ctrl2;
  rand ua_lcr_c2 ua_lcr2;
  rand ua_ier_c2 ua_ier2;

  virtual function void build();

    // Now2 create all registers

    ua_div_latch02 = ua_div_latch0_c2::type_id::create("ua_div_latch02", , get_full_name());
    ua_div_latch12 = ua_div_latch1_c2::type_id::create("ua_div_latch12", , get_full_name());
    ua_int_id2 = ua_int_id_c2::type_id::create("ua_int_id2", , get_full_name());
    ua_fifo_ctrl2 = ua_fifo_ctrl_c2::type_id::create("ua_fifo_ctrl2", , get_full_name());
    ua_lcr2 = ua_lcr_c2::type_id::create("ua_lcr2", , get_full_name());
    ua_ier2 = ua_ier_c2::type_id::create("ua_ier2", , get_full_name());

    // Now2 build the registers. Set parent and hdl_paths

    ua_div_latch02.configure(this, null, "dl2[7:0]");
    ua_div_latch02.build();
    ua_div_latch12.configure(this, null, "dl2[15;8]");
    ua_div_latch12.build();
    ua_int_id2.configure(this, null, "iir2");
    ua_int_id2.build();
    ua_fifo_ctrl2.configure(this, null, "fcr2");
    ua_fifo_ctrl2.build();
    ua_lcr2.configure(this, null, "lcr2");
    ua_lcr2.build();
    ua_ier2.configure(this, null, "ier2");
    ua_ier2.build();
    // Now2 define address mappings2
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch02, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch12, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id2, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl2, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr2, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier2, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c2)
  function new(input string name="unnamed2-uart_ctrl_rf2");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c2

//////////////////////////////////////////////////////////////////////////////
// Address_map2 definition2
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c2 extends uvm_reg_block;

  rand uart_ctrl_rf_c2 uart_ctrl_rf2;

  function void build();
    // Now2 define address mappings2
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf2 = uart_ctrl_rf_c2::type_id::create("uart_ctrl_rf2", , get_full_name());
    uart_ctrl_rf2.configure(this, "regs");
    uart_ctrl_rf2.build();
    uart_ctrl_rf2.lock_model();
    default_map.add_submap(uart_ctrl_rf2.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top2.uart_dut2");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c2)
  function new(input string name="unnamed2-uart_ctrl_reg_model_c2");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c2

`endif // UART_CTRL_REGS_SV2
