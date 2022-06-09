// This21 file is generated21 using Cadence21 iregGen21 version21 1.05

`ifndef UART_CTRL_REGS_SV21
`define UART_CTRL_REGS_SV21

// Input21 File21: uart_ctrl_regs21.xml21

// Number21 of AddrMaps21 = 1
// Number21 of RegFiles21 = 1
// Number21 of Registers21 = 6
// Number21 of Memories21 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 262


class ua_div_latch0_c21 extends uvm_reg;

  rand uvm_reg_field div_val21;

  constraint c_div_val21 { div_val21.value == 1; }
  virtual function void build();
    div_val21 = uvm_reg_field::type_id::create("div_val21");
    div_val21.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg21.set_inst_name($sformatf("%s.wcov21", get_full_name()));
    rd_cg21.set_inst_name($sformatf("%s.rcov21", get_full_name()));
  endfunction

  covergroup wr_cg21;
    option.per_instance=1;
    div_val21 : coverpoint div_val21.value[7:0];
  endgroup
  covergroup rd_cg21;
    option.per_instance=1;
    div_val21 : coverpoint div_val21.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg21.sample();
    if(is_read) rd_cg21.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c21, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c21, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c21)
  function new(input string name="unnamed21-ua_div_latch0_c21");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg21=new;
    rd_cg21=new;
  endfunction : new
endclass : ua_div_latch0_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 287


class ua_div_latch1_c21 extends uvm_reg;

  rand uvm_reg_field div_val21;

  constraint c_div_val21 { div_val21.value == 0; }
  virtual function void build();
    div_val21 = uvm_reg_field::type_id::create("div_val21");
    div_val21.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg21.set_inst_name($sformatf("%s.wcov21", get_full_name()));
    rd_cg21.set_inst_name($sformatf("%s.rcov21", get_full_name()));
  endfunction

  covergroup wr_cg21;
    option.per_instance=1;
    div_val21 : coverpoint div_val21.value[7:0];
  endgroup
  covergroup rd_cg21;
    option.per_instance=1;
    div_val21 : coverpoint div_val21.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg21.sample();
    if(is_read) rd_cg21.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c21, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c21, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c21)
  function new(input string name="unnamed21-ua_div_latch1_c21");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg21=new;
    rd_cg21=new;
  endfunction : new
endclass : ua_div_latch1_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 82


class ua_int_id_c21 extends uvm_reg;

  uvm_reg_field priority_bit21;
  uvm_reg_field bit121;
  uvm_reg_field bit221;
  uvm_reg_field bit321;

  virtual function void build();
    priority_bit21 = uvm_reg_field::type_id::create("priority_bit21");
    priority_bit21.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit121 = uvm_reg_field::type_id::create("bit121");
    bit121.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit221 = uvm_reg_field::type_id::create("bit221");
    bit221.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit321 = uvm_reg_field::type_id::create("bit321");
    bit321.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg21.set_inst_name($sformatf("%s.rcov21", get_full_name()));
  endfunction

  covergroup rd_cg21;
    option.per_instance=1;
    priority_bit21 : coverpoint priority_bit21.value[0:0];
    bit121 : coverpoint bit121.value[0:0];
    bit221 : coverpoint bit221.value[0:0];
    bit321 : coverpoint bit321.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg21.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c21, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c21, uvm_reg)
  `uvm_object_utils(ua_int_id_c21)
  function new(input string name="unnamed21-ua_int_id_c21");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg21=new;
  endfunction : new
endclass : ua_int_id_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 139


class ua_fifo_ctrl_c21 extends uvm_reg;

  rand uvm_reg_field rx_clear21;
  rand uvm_reg_field tx_clear21;
  rand uvm_reg_field rx_fifo_int_trig_level21;

  virtual function void build();
    rx_clear21 = uvm_reg_field::type_id::create("rx_clear21");
    rx_clear21.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear21 = uvm_reg_field::type_id::create("tx_clear21");
    tx_clear21.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level21 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level21");
    rx_fifo_int_trig_level21.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg21.set_inst_name($sformatf("%s.wcov21", get_full_name()));
  endfunction

  covergroup wr_cg21;
    option.per_instance=1;
    rx_clear21 : coverpoint rx_clear21.value[0:0];
    tx_clear21 : coverpoint tx_clear21.value[0:0];
    rx_fifo_int_trig_level21 : coverpoint rx_fifo_int_trig_level21.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg21.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c21, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c21, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c21)
  function new(input string name="unnamed21-ua_fifo_ctrl_c21");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg21=new;
  endfunction : new
endclass : ua_fifo_ctrl_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 188


class ua_lcr_c21 extends uvm_reg;

  rand uvm_reg_field char_lngth21;
  rand uvm_reg_field num_stop_bits21;
  rand uvm_reg_field p_en21;
  rand uvm_reg_field parity_even21;
  rand uvm_reg_field parity_sticky21;
  rand uvm_reg_field break_ctrl21;
  rand uvm_reg_field div_latch_access21;

  constraint c_char_lngth21 { char_lngth21.value != 2'b00; }
  constraint c_break_ctrl21 { break_ctrl21.value == 1'b0; }
  virtual function void build();
    char_lngth21 = uvm_reg_field::type_id::create("char_lngth21");
    char_lngth21.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits21 = uvm_reg_field::type_id::create("num_stop_bits21");
    num_stop_bits21.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en21 = uvm_reg_field::type_id::create("p_en21");
    p_en21.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even21 = uvm_reg_field::type_id::create("parity_even21");
    parity_even21.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky21 = uvm_reg_field::type_id::create("parity_sticky21");
    parity_sticky21.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl21 = uvm_reg_field::type_id::create("break_ctrl21");
    break_ctrl21.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access21 = uvm_reg_field::type_id::create("div_latch_access21");
    div_latch_access21.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg21.set_inst_name($sformatf("%s.wcov21", get_full_name()));
    rd_cg21.set_inst_name($sformatf("%s.rcov21", get_full_name()));
  endfunction

  covergroup wr_cg21;
    option.per_instance=1;
    char_lngth21 : coverpoint char_lngth21.value[1:0];
    num_stop_bits21 : coverpoint num_stop_bits21.value[0:0];
    p_en21 : coverpoint p_en21.value[0:0];
    parity_even21 : coverpoint parity_even21.value[0:0];
    parity_sticky21 : coverpoint parity_sticky21.value[0:0];
    break_ctrl21 : coverpoint break_ctrl21.value[0:0];
    div_latch_access21 : coverpoint div_latch_access21.value[0:0];
  endgroup
  covergroup rd_cg21;
    option.per_instance=1;
    char_lngth21 : coverpoint char_lngth21.value[1:0];
    num_stop_bits21 : coverpoint num_stop_bits21.value[0:0];
    p_en21 : coverpoint p_en21.value[0:0];
    parity_even21 : coverpoint parity_even21.value[0:0];
    parity_sticky21 : coverpoint parity_sticky21.value[0:0];
    break_ctrl21 : coverpoint break_ctrl21.value[0:0];
    div_latch_access21 : coverpoint div_latch_access21.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg21.sample();
    if(is_read) rd_cg21.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c21, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c21, uvm_reg)
  `uvm_object_utils(ua_lcr_c21)
  function new(input string name="unnamed21-ua_lcr_c21");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg21=new;
    rd_cg21=new;
  endfunction : new
endclass : ua_lcr_c21

//////////////////////////////////////////////////////////////////////////////
// Register definition21
//////////////////////////////////////////////////////////////////////////////
// Line21 Number21: 25


class ua_ier_c21 extends uvm_reg;

  rand uvm_reg_field rx_data21;
  rand uvm_reg_field tx_data21;
  rand uvm_reg_field rx_line_sts21;
  rand uvm_reg_field mdm_sts21;

  virtual function void build();
    rx_data21 = uvm_reg_field::type_id::create("rx_data21");
    rx_data21.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data21 = uvm_reg_field::type_id::create("tx_data21");
    tx_data21.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts21 = uvm_reg_field::type_id::create("rx_line_sts21");
    rx_line_sts21.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts21 = uvm_reg_field::type_id::create("mdm_sts21");
    mdm_sts21.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg21.set_inst_name($sformatf("%s.wcov21", get_full_name()));
    rd_cg21.set_inst_name($sformatf("%s.rcov21", get_full_name()));
  endfunction

  covergroup wr_cg21;
    option.per_instance=1;
    rx_data21 : coverpoint rx_data21.value[0:0];
    tx_data21 : coverpoint tx_data21.value[0:0];
    rx_line_sts21 : coverpoint rx_line_sts21.value[0:0];
    mdm_sts21 : coverpoint mdm_sts21.value[0:0];
  endgroup
  covergroup rd_cg21;
    option.per_instance=1;
    rx_data21 : coverpoint rx_data21.value[0:0];
    tx_data21 : coverpoint tx_data21.value[0:0];
    rx_line_sts21 : coverpoint rx_line_sts21.value[0:0];
    mdm_sts21 : coverpoint mdm_sts21.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg21.sample();
    if(is_read) rd_cg21.sample();
  endfunction

  `uvm_register_cb(ua_ier_c21, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c21, uvm_reg)
  `uvm_object_utils(ua_ier_c21)
  function new(input string name="unnamed21-ua_ier_c21");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg21=new;
    rd_cg21=new;
  endfunction : new
endclass : ua_ier_c21

class uart_ctrl_rf_c21 extends uvm_reg_block;

  rand ua_div_latch0_c21 ua_div_latch021;
  rand ua_div_latch1_c21 ua_div_latch121;
  rand ua_int_id_c21 ua_int_id21;
  rand ua_fifo_ctrl_c21 ua_fifo_ctrl21;
  rand ua_lcr_c21 ua_lcr21;
  rand ua_ier_c21 ua_ier21;

  virtual function void build();

    // Now21 create all registers

    ua_div_latch021 = ua_div_latch0_c21::type_id::create("ua_div_latch021", , get_full_name());
    ua_div_latch121 = ua_div_latch1_c21::type_id::create("ua_div_latch121", , get_full_name());
    ua_int_id21 = ua_int_id_c21::type_id::create("ua_int_id21", , get_full_name());
    ua_fifo_ctrl21 = ua_fifo_ctrl_c21::type_id::create("ua_fifo_ctrl21", , get_full_name());
    ua_lcr21 = ua_lcr_c21::type_id::create("ua_lcr21", , get_full_name());
    ua_ier21 = ua_ier_c21::type_id::create("ua_ier21", , get_full_name());

    // Now21 build the registers. Set parent and hdl_paths

    ua_div_latch021.configure(this, null, "dl21[7:0]");
    ua_div_latch021.build();
    ua_div_latch121.configure(this, null, "dl21[15;8]");
    ua_div_latch121.build();
    ua_int_id21.configure(this, null, "iir21");
    ua_int_id21.build();
    ua_fifo_ctrl21.configure(this, null, "fcr21");
    ua_fifo_ctrl21.build();
    ua_lcr21.configure(this, null, "lcr21");
    ua_lcr21.build();
    ua_ier21.configure(this, null, "ier21");
    ua_ier21.build();
    // Now21 define address mappings21
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch021, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch121, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id21, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl21, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr21, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier21, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c21)
  function new(input string name="unnamed21-uart_ctrl_rf21");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c21

//////////////////////////////////////////////////////////////////////////////
// Address_map21 definition21
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c21 extends uvm_reg_block;

  rand uart_ctrl_rf_c21 uart_ctrl_rf21;

  function void build();
    // Now21 define address mappings21
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf21 = uart_ctrl_rf_c21::type_id::create("uart_ctrl_rf21", , get_full_name());
    uart_ctrl_rf21.configure(this, "regs");
    uart_ctrl_rf21.build();
    uart_ctrl_rf21.lock_model();
    default_map.add_submap(uart_ctrl_rf21.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top21.uart_dut21");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c21)
  function new(input string name="unnamed21-uart_ctrl_reg_model_c21");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c21

`endif // UART_CTRL_REGS_SV21
