/*-------------------------------------------------------------------------
File18 name   : uart_ctrl_reg_seq_lib18.sv
Title18       : UVM_REG Sequence Library18
Project18     :
Created18     :
Description18 : Register Sequence Library18 for the UART18 Controller18 DUT
Notes18       :
----------------------------------------------------------------------
Copyright18 2007 (c) Cadence18 Design18 Systems18, Inc18. All Rights18 Reserved18.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq18: Direct18 APB18 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq18 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq18)

   apb_pkg18::write_byte_seq18 write_seq18;
   rand bit [7:0] temp_data18;
   constraint c118 {temp_data18[7] == 1'b1; }

   function new(string name="apb_config_reg_seq18");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART18 Controller18 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line18 Control18 Register: bit 7, Divisor18 Latch18 Access = 1
      `uvm_do_with(write_seq18, { start_addr18 == 3; write_data18 == temp_data18; } )
      // Address 0: Divisor18 Latch18 Byte18 1 = 1
      `uvm_do_with(write_seq18, { start_addr18 == 0; write_data18 == 'h01; } )
      // Address 1: Divisor18 Latch18 Byte18 2 = 0
      `uvm_do_with(write_seq18, { start_addr18 == 1; write_data18 == 'h00; } )
      // Address 3: Line18 Control18 Register: bit 7, Divisor18 Latch18 Access = 0
      temp_data18[7] = 1'b0;
      `uvm_do_with(write_seq18, { start_addr18 == 3; write_data18 == temp_data18; } )
      `uvm_info(get_type_name(),
        "UART18 Controller18 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq18

//--------------------------------------------------------------------
// Base18 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq18 extends uvm_sequence;
  function new(string name="base_reg_seq18");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq18)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer18)

// Use a base sequence to raise/drop18 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running18 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq18

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq18: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq18 extends base_reg_seq18;

   // Pointer18 to the register model
   uart_ctrl_reg_model_c18 reg_model18;
   uvm_object rm_object18;

   `uvm_object_utils(uart_ctrl_config_reg_seq18)

   function new(string name="uart_ctrl_config_reg_seq18");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model18", rm_object18))
      $cast(reg_model18, rm_object18);
      `uvm_info(get_type_name(),
        "UART18 Controller18 Register configuration sequence starting...",
        UVM_LOW)
      // Line18 Control18 Register, set Divisor18 Latch18 Access = 1
      reg_model18.uart_ctrl_rf18.ua_lcr18.write(status, 'h8f);
      // Divisor18 Latch18 Byte18 1 = 1
      reg_model18.uart_ctrl_rf18.ua_div_latch018.write(status, 'h01);
      // Divisor18 Latch18 Byte18 2 = 0
      reg_model18.uart_ctrl_rf18.ua_div_latch118.write(status, 'h00);
      // Line18 Control18 Register, set Divisor18 Latch18 Access = 0
      reg_model18.uart_ctrl_rf18.ua_lcr18.write(status, 'h0f);
      //ToDo18: FIX18: DISABLE18 CHECKS18 AFTER CONFIG18 IS18 DONE
      reg_model18.uart_ctrl_rf18.ua_div_latch018.div_val18.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART18 Controller18 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq18

class uart_ctrl_1stopbit_reg_seq18 extends base_reg_seq18;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq18)

   function new(string name="uart_ctrl_1stopbit_reg_seq18");
      super.new(name);
   endfunction // new
 
   // Pointer18 to the register model
   uart_ctrl_rf_c18 reg_model18;
//   uart_ctrl_reg_model_c18 reg_model18;

   //ua_lcr_c18 ulcr18;
   //ua_div_latch0_c18 div_lsb18;
   //ua_div_latch1_c18 div_msb18;

   virtual task body();
     uvm_status_e status;
     reg_model18 = p_sequencer.reg_model18.uart_ctrl_rf18;
     `uvm_info(get_type_name(),
        "UART18 config register sequence with num_stop_bits18 == STOP118 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with18(ulcr18, "ua_lcr18", {value.num_stop_bits18 == 1'b0;})
      #50;
      //`rgm_write_by_name18(div_msb18, "ua_div_latch118")
      #50;
      //`rgm_write_by_name18(div_lsb18, "ua_div_latch018")
      #50;
      //ulcr18.value.div_latch_access18 = 1'b0;
      //`rgm_write_send18(ulcr18)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq18

class uart_cfg_rxtx_fifo_cov_reg_seq18 extends uart_ctrl_config_reg_seq18;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq18)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq18");
      super.new(name);
   endfunction : new
 
//   ua_ier_c18 uier18;
//   ua_idr_c18 uidr18;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx18/rx18 full/empty18 interrupts18...", UVM_LOW)
//     `rgm_write_by_name_with18(uier18, {uart_rf18, ".ua_ier18"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with18(uidr18, {uart_rf18, ".ua_idr18"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq18
