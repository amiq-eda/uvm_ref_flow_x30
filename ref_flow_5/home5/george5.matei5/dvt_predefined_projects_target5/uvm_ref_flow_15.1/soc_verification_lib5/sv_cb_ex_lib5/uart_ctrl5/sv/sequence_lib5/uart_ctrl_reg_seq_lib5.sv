/*-------------------------------------------------------------------------
File5 name   : uart_ctrl_reg_seq_lib5.sv
Title5       : UVM_REG Sequence Library5
Project5     :
Created5     :
Description5 : Register Sequence Library5 for the UART5 Controller5 DUT
Notes5       :
----------------------------------------------------------------------
Copyright5 2007 (c) Cadence5 Design5 Systems5, Inc5. All Rights5 Reserved5.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq5: Direct5 APB5 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq5 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq5)

   apb_pkg5::write_byte_seq5 write_seq5;
   rand bit [7:0] temp_data5;
   constraint c15 {temp_data5[7] == 1'b1; }

   function new(string name="apb_config_reg_seq5");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART5 Controller5 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line5 Control5 Register: bit 7, Divisor5 Latch5 Access = 1
      `uvm_do_with(write_seq5, { start_addr5 == 3; write_data5 == temp_data5; } )
      // Address 0: Divisor5 Latch5 Byte5 1 = 1
      `uvm_do_with(write_seq5, { start_addr5 == 0; write_data5 == 'h01; } )
      // Address 1: Divisor5 Latch5 Byte5 2 = 0
      `uvm_do_with(write_seq5, { start_addr5 == 1; write_data5 == 'h00; } )
      // Address 3: Line5 Control5 Register: bit 7, Divisor5 Latch5 Access = 0
      temp_data5[7] = 1'b0;
      `uvm_do_with(write_seq5, { start_addr5 == 3; write_data5 == temp_data5; } )
      `uvm_info(get_type_name(),
        "UART5 Controller5 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq5

//--------------------------------------------------------------------
// Base5 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq5 extends uvm_sequence;
  function new(string name="base_reg_seq5");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq5)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer5)

// Use a base sequence to raise/drop5 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running5 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq5

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq5: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq5 extends base_reg_seq5;

   // Pointer5 to the register model
   uart_ctrl_reg_model_c5 reg_model5;
   uvm_object rm_object5;

   `uvm_object_utils(uart_ctrl_config_reg_seq5)

   function new(string name="uart_ctrl_config_reg_seq5");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model5", rm_object5))
      $cast(reg_model5, rm_object5);
      `uvm_info(get_type_name(),
        "UART5 Controller5 Register configuration sequence starting...",
        UVM_LOW)
      // Line5 Control5 Register, set Divisor5 Latch5 Access = 1
      reg_model5.uart_ctrl_rf5.ua_lcr5.write(status, 'h8f);
      // Divisor5 Latch5 Byte5 1 = 1
      reg_model5.uart_ctrl_rf5.ua_div_latch05.write(status, 'h01);
      // Divisor5 Latch5 Byte5 2 = 0
      reg_model5.uart_ctrl_rf5.ua_div_latch15.write(status, 'h00);
      // Line5 Control5 Register, set Divisor5 Latch5 Access = 0
      reg_model5.uart_ctrl_rf5.ua_lcr5.write(status, 'h0f);
      //ToDo5: FIX5: DISABLE5 CHECKS5 AFTER CONFIG5 IS5 DONE
      reg_model5.uart_ctrl_rf5.ua_div_latch05.div_val5.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART5 Controller5 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq5

class uart_ctrl_1stopbit_reg_seq5 extends base_reg_seq5;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq5)

   function new(string name="uart_ctrl_1stopbit_reg_seq5");
      super.new(name);
   endfunction // new
 
   // Pointer5 to the register model
   uart_ctrl_rf_c5 reg_model5;
//   uart_ctrl_reg_model_c5 reg_model5;

   //ua_lcr_c5 ulcr5;
   //ua_div_latch0_c5 div_lsb5;
   //ua_div_latch1_c5 div_msb5;

   virtual task body();
     uvm_status_e status;
     reg_model5 = p_sequencer.reg_model5.uart_ctrl_rf5;
     `uvm_info(get_type_name(),
        "UART5 config register sequence with num_stop_bits5 == STOP15 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with5(ulcr5, "ua_lcr5", {value.num_stop_bits5 == 1'b0;})
      #50;
      //`rgm_write_by_name5(div_msb5, "ua_div_latch15")
      #50;
      //`rgm_write_by_name5(div_lsb5, "ua_div_latch05")
      #50;
      //ulcr5.value.div_latch_access5 = 1'b0;
      //`rgm_write_send5(ulcr5)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq5

class uart_cfg_rxtx_fifo_cov_reg_seq5 extends uart_ctrl_config_reg_seq5;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq5)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq5");
      super.new(name);
   endfunction : new
 
//   ua_ier_c5 uier5;
//   ua_idr_c5 uidr5;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx5/rx5 full/empty5 interrupts5...", UVM_LOW)
//     `rgm_write_by_name_with5(uier5, {uart_rf5, ".ua_ier5"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with5(uidr5, {uart_rf5, ".ua_idr5"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq5
