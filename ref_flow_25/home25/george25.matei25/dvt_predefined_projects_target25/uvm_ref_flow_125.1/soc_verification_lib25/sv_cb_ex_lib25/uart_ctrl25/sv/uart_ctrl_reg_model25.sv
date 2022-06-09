// This25 file is generated25 using Cadence25 iregGen25 version25 1.05

`ifndef UART_CTRL_REGS_SV25
`define UART_CTRL_REGS_SV25

// Input25 File25: uart_ctrl_regs25.xml25

// Number25 of AddrMaps25 = 1
// Number25 of RegFiles25 = 1
// Number25 of Registers25 = 6
// Number25 of Memories25 = 0


//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 262


class ua_div_latch0_c25 extends uvm_reg;

  rand uvm_reg_field div_val25;

  constraint c_div_val25 { div_val25.value == 1; }
  virtual function void build();
    div_val25 = uvm_reg_field::type_id::create("div_val25");
    div_val25.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg25.set_inst_name($sformatf("%s.wcov25", get_full_name()));
    rd_cg25.set_inst_name($sformatf("%s.rcov25", get_full_name()));
  endfunction

  covergroup wr_cg25;
    option.per_instance=1;
    div_val25 : coverpoint div_val25.value[7:0];
  endgroup
  covergroup rd_cg25;
    option.per_instance=1;
    div_val25 : coverpoint div_val25.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg25.sample();
    if(is_read) rd_cg25.sample();
  endfunction

  `uvm_register_cb(ua_div_latch0_c25, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch0_c25, uvm_reg)
  `uvm_object_utils(ua_div_latch0_c25)
  function new(input string name="unnamed25-ua_div_latch0_c25");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg25=new;
    rd_cg25=new;
  endfunction : new
endclass : ua_div_latch0_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 287


class ua_div_latch1_c25 extends uvm_reg;

  rand uvm_reg_field div_val25;

  constraint c_div_val25 { div_val25.value == 0; }
  virtual function void build();
    div_val25 = uvm_reg_field::type_id::create("div_val25");
    div_val25.configure(this, 8, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    wr_cg25.set_inst_name($sformatf("%s.wcov25", get_full_name()));
    rd_cg25.set_inst_name($sformatf("%s.rcov25", get_full_name()));
  endfunction

  covergroup wr_cg25;
    option.per_instance=1;
    div_val25 : coverpoint div_val25.value[7:0];
  endgroup
  covergroup rd_cg25;
    option.per_instance=1;
    div_val25 : coverpoint div_val25.value[7:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg25.sample();
    if(is_read) rd_cg25.sample();
  endfunction

  `uvm_register_cb(ua_div_latch1_c25, uvm_reg_cbs) 
  `uvm_set_super_type(ua_div_latch1_c25, uvm_reg)
  `uvm_object_utils(ua_div_latch1_c25)
  function new(input string name="unnamed25-ua_div_latch1_c25");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg25=new;
    rd_cg25=new;
  endfunction : new
endclass : ua_div_latch1_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 82


class ua_int_id_c25 extends uvm_reg;

  uvm_reg_field priority_bit25;
  uvm_reg_field bit125;
  uvm_reg_field bit225;
  uvm_reg_field bit325;

  virtual function void build();
    priority_bit25 = uvm_reg_field::type_id::create("priority_bit25");
    priority_bit25.configure(this, 1, 0, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>0, 1, 0, 1);
    bit125 = uvm_reg_field::type_id::create("bit125");
    bit125.configure(this, 1, 1, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>1, 1, 0, 1);
    bit225 = uvm_reg_field::type_id::create("bit225");
    bit225.configure(this, 1, 2, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>2, 1, 0, 1);
    bit325 = uvm_reg_field::type_id::create("bit325");
    bit325.configure(this, 1, 3, "RO", 0, `UVM_REG_DATA_WIDTH'hC1>>3, 1, 0, 1);
    rd_cg25.set_inst_name($sformatf("%s.rcov25", get_full_name()));
  endfunction

  covergroup rd_cg25;
    option.per_instance=1;
    priority_bit25 : coverpoint priority_bit25.value[0:0];
    bit125 : coverpoint bit125.value[0:0];
    bit225 : coverpoint bit225.value[0:0];
    bit325 : coverpoint bit325.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(is_read) rd_cg25.sample();
  endfunction

  `uvm_register_cb(ua_int_id_c25, uvm_reg_cbs) 
  `uvm_set_super_type(ua_int_id_c25, uvm_reg)
  `uvm_object_utils(ua_int_id_c25)
  function new(input string name="unnamed25-ua_int_id_c25");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    rd_cg25=new;
  endfunction : new
endclass : ua_int_id_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 139


class ua_fifo_ctrl_c25 extends uvm_reg;

  rand uvm_reg_field rx_clear25;
  rand uvm_reg_field tx_clear25;
  rand uvm_reg_field rx_fifo_int_trig_level25;

  virtual function void build();
    rx_clear25 = uvm_reg_field::type_id::create("rx_clear25");
    rx_clear25.configure(this, 1, 1, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>1, 1, 1, 1);
    tx_clear25 = uvm_reg_field::type_id::create("tx_clear25");
    tx_clear25.configure(this, 1, 2, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>2, 1, 1, 1);
    rx_fifo_int_trig_level25 = uvm_reg_field::type_id::create("rx_fifo_int_trig_level25");
    rx_fifo_int_trig_level25.configure(this, 2, 6, "WO", 0, `UVM_REG_DATA_WIDTH'hC0>>6, 1, 1, 1);
    wr_cg25.set_inst_name($sformatf("%s.wcov25", get_full_name()));
  endfunction

  covergroup wr_cg25;
    option.per_instance=1;
    rx_clear25 : coverpoint rx_clear25.value[0:0];
    tx_clear25 : coverpoint tx_clear25.value[0:0];
    rx_fifo_int_trig_level25 : coverpoint rx_fifo_int_trig_level25.value[1:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg25.sample();
  endfunction

  `uvm_register_cb(ua_fifo_ctrl_c25, uvm_reg_cbs) 
  `uvm_set_super_type(ua_fifo_ctrl_c25, uvm_reg)
  `uvm_object_utils(ua_fifo_ctrl_c25)
  function new(input string name="unnamed25-ua_fifo_ctrl_c25");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg25=new;
  endfunction : new
endclass : ua_fifo_ctrl_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 188


class ua_lcr_c25 extends uvm_reg;

  rand uvm_reg_field char_lngth25;
  rand uvm_reg_field num_stop_bits25;
  rand uvm_reg_field p_en25;
  rand uvm_reg_field parity_even25;
  rand uvm_reg_field parity_sticky25;
  rand uvm_reg_field break_ctrl25;
  rand uvm_reg_field div_latch_access25;

  constraint c_char_lngth25 { char_lngth25.value != 2'b00; }
  constraint c_break_ctrl25 { break_ctrl25.value == 1'b0; }
  virtual function void build();
    char_lngth25 = uvm_reg_field::type_id::create("char_lngth25");
    char_lngth25.configure(this, 2, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>0, 1, 1, 1);
    num_stop_bits25 = uvm_reg_field::type_id::create("num_stop_bits25");
    num_stop_bits25.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>2, 1, 1, 1);
    p_en25 = uvm_reg_field::type_id::create("p_en25");
    p_en25.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>3, 1, 1, 1);
    parity_even25 = uvm_reg_field::type_id::create("parity_even25");
    parity_even25.configure(this, 1, 4, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>4, 1, 1, 1);
    parity_sticky25 = uvm_reg_field::type_id::create("parity_sticky25");
    parity_sticky25.configure(this, 1, 5, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>5, 1, 1, 1);
    break_ctrl25 = uvm_reg_field::type_id::create("break_ctrl25");
    break_ctrl25.configure(this, 1, 6, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>6, 1, 1, 1);
    div_latch_access25 = uvm_reg_field::type_id::create("div_latch_access25");
    div_latch_access25.configure(this, 1, 7, "RW", 0, `UVM_REG_DATA_WIDTH'h03>>7, 1, 1, 1);
    wr_cg25.set_inst_name($sformatf("%s.wcov25", get_full_name()));
    rd_cg25.set_inst_name($sformatf("%s.rcov25", get_full_name()));
  endfunction

  covergroup wr_cg25;
    option.per_instance=1;
    char_lngth25 : coverpoint char_lngth25.value[1:0];
    num_stop_bits25 : coverpoint num_stop_bits25.value[0:0];
    p_en25 : coverpoint p_en25.value[0:0];
    parity_even25 : coverpoint parity_even25.value[0:0];
    parity_sticky25 : coverpoint parity_sticky25.value[0:0];
    break_ctrl25 : coverpoint break_ctrl25.value[0:0];
    div_latch_access25 : coverpoint div_latch_access25.value[0:0];
  endgroup
  covergroup rd_cg25;
    option.per_instance=1;
    char_lngth25 : coverpoint char_lngth25.value[1:0];
    num_stop_bits25 : coverpoint num_stop_bits25.value[0:0];
    p_en25 : coverpoint p_en25.value[0:0];
    parity_even25 : coverpoint parity_even25.value[0:0];
    parity_sticky25 : coverpoint parity_sticky25.value[0:0];
    break_ctrl25 : coverpoint break_ctrl25.value[0:0];
    div_latch_access25 : coverpoint div_latch_access25.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg25.sample();
    if(is_read) rd_cg25.sample();
  endfunction

  `uvm_register_cb(ua_lcr_c25, uvm_reg_cbs) 
  `uvm_set_super_type(ua_lcr_c25, uvm_reg)
  `uvm_object_utils(ua_lcr_c25)
  function new(input string name="unnamed25-ua_lcr_c25");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg25=new;
    rd_cg25=new;
  endfunction : new
endclass : ua_lcr_c25

//////////////////////////////////////////////////////////////////////////////
// Register definition25
//////////////////////////////////////////////////////////////////////////////
// Line25 Number25: 25


class ua_ier_c25 extends uvm_reg;

  rand uvm_reg_field rx_data25;
  rand uvm_reg_field tx_data25;
  rand uvm_reg_field rx_line_sts25;
  rand uvm_reg_field mdm_sts25;

  virtual function void build();
    rx_data25 = uvm_reg_field::type_id::create("rx_data25");
    rx_data25.configure(this, 1, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>0, 1, 1, 1);
    tx_data25 = uvm_reg_field::type_id::create("tx_data25");
    tx_data25.configure(this, 1, 1, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>1, 1, 1, 1);
    rx_line_sts25 = uvm_reg_field::type_id::create("rx_line_sts25");
    rx_line_sts25.configure(this, 1, 2, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>2, 1, 1, 1);
    mdm_sts25 = uvm_reg_field::type_id::create("mdm_sts25");
    mdm_sts25.configure(this, 1, 3, "RW", 0, `UVM_REG_DATA_WIDTH'h00>>3, 1, 1, 1);
    wr_cg25.set_inst_name($sformatf("%s.wcov25", get_full_name()));
    rd_cg25.set_inst_name($sformatf("%s.rcov25", get_full_name()));
  endfunction

  covergroup wr_cg25;
    option.per_instance=1;
    rx_data25 : coverpoint rx_data25.value[0:0];
    tx_data25 : coverpoint tx_data25.value[0:0];
    rx_line_sts25 : coverpoint rx_line_sts25.value[0:0];
    mdm_sts25 : coverpoint mdm_sts25.value[0:0];
  endgroup
  covergroup rd_cg25;
    option.per_instance=1;
    rx_data25 : coverpoint rx_data25.value[0:0];
    tx_data25 : coverpoint tx_data25.value[0:0];
    rx_line_sts25 : coverpoint rx_line_sts25.value[0:0];
    mdm_sts25 : coverpoint mdm_sts25.value[0:0];
  endgroup

  virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
    super.sample(data, byte_en, is_read, map);
    if(!is_read) wr_cg25.sample();
    if(is_read) rd_cg25.sample();
  endfunction

  `uvm_register_cb(ua_ier_c25, uvm_reg_cbs) 
  `uvm_set_super_type(ua_ier_c25, uvm_reg)
  `uvm_object_utils(ua_ier_c25)
  function new(input string name="unnamed25-ua_ier_c25");
    super.new(name, 8, build_coverage(UVM_CVR_FIELD_VALS));
    wr_cg25=new;
    rd_cg25=new;
  endfunction : new
endclass : ua_ier_c25

class uart_ctrl_rf_c25 extends uvm_reg_block;

  rand ua_div_latch0_c25 ua_div_latch025;
  rand ua_div_latch1_c25 ua_div_latch125;
  rand ua_int_id_c25 ua_int_id25;
  rand ua_fifo_ctrl_c25 ua_fifo_ctrl25;
  rand ua_lcr_c25 ua_lcr25;
  rand ua_ier_c25 ua_ier25;

  virtual function void build();

    // Now25 create all registers

    ua_div_latch025 = ua_div_latch0_c25::type_id::create("ua_div_latch025", , get_full_name());
    ua_div_latch125 = ua_div_latch1_c25::type_id::create("ua_div_latch125", , get_full_name());
    ua_int_id25 = ua_int_id_c25::type_id::create("ua_int_id25", , get_full_name());
    ua_fifo_ctrl25 = ua_fifo_ctrl_c25::type_id::create("ua_fifo_ctrl25", , get_full_name());
    ua_lcr25 = ua_lcr_c25::type_id::create("ua_lcr25", , get_full_name());
    ua_ier25 = ua_ier_c25::type_id::create("ua_ier25", , get_full_name());

    // Now25 build the registers. Set parent and hdl_paths

    ua_div_latch025.configure(this, null, "dl25[7:0]");
    ua_div_latch025.build();
    ua_div_latch125.configure(this, null, "dl25[15;8]");
    ua_div_latch125.build();
    ua_int_id25.configure(this, null, "iir25");
    ua_int_id25.build();
    ua_fifo_ctrl25.configure(this, null, "fcr25");
    ua_fifo_ctrl25.build();
    ua_lcr25.configure(this, null, "lcr25");
    ua_lcr25.build();
    ua_ier25.configure(this, null, "ier25");
    ua_ier25.build();
    // Now25 define address mappings25
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    default_map.add_reg(ua_div_latch025, `UVM_REG_ADDR_WIDTH'h0, "RW");
    default_map.add_reg(ua_div_latch125, `UVM_REG_ADDR_WIDTH'h1, "RW");
    default_map.add_reg(ua_int_id25, `UVM_REG_ADDR_WIDTH'h2, "RO");
    default_map.add_reg(ua_fifo_ctrl25, `UVM_REG_ADDR_WIDTH'h2, "WO");
    default_map.add_reg(ua_lcr25, `UVM_REG_ADDR_WIDTH'h3, "RW");
    default_map.add_reg(ua_ier25, `UVM_REG_ADDR_WIDTH'h8, "RW");
  endfunction

  `uvm_object_utils(uart_ctrl_rf_c25)
  function new(input string name="unnamed25-uart_ctrl_rf25");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

endclass : uart_ctrl_rf_c25

//////////////////////////////////////////////////////////////////////////////
// Address_map25 definition25
//////////////////////////////////////////////////////////////////////////////
class uart_ctrl_reg_model_c25 extends uvm_reg_block;

  rand uart_ctrl_rf_c25 uart_ctrl_rf25;

  function void build();
    // Now25 define address mappings25
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart_ctrl_rf25 = uart_ctrl_rf_c25::type_id::create("uart_ctrl_rf25", , get_full_name());
    uart_ctrl_rf25.configure(this, "regs");
    uart_ctrl_rf25.build();
    uart_ctrl_rf25.lock_model();
    default_map.add_submap(uart_ctrl_rf25.default_map, `UVM_REG_ADDR_WIDTH'h0);
    set_hdl_path_root("uart_ctrl_top25.uart_dut25");
    this.lock_model();
    default_map.set_check_on_read();
  endfunction
  `uvm_object_utils(uart_ctrl_reg_model_c25)
  function new(input string name="unnamed25-uart_ctrl_reg_model_c25");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
endclass : uart_ctrl_reg_model_c25

`endif // UART_CTRL_REGS_SV25
