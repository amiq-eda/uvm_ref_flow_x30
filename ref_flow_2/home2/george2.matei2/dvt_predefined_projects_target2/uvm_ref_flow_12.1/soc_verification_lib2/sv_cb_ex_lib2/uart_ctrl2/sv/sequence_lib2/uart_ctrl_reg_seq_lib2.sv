/*-------------------------------------------------------------------------
File2 name   : uart_ctrl_reg_seq_lib2.sv
Title2       : UVM_REG Sequence Library2
Project2     :
Created2     :
Description2 : Register Sequence Library2 for the UART2 Controller2 DUT
Notes2       :
----------------------------------------------------------------------
Copyright2 2007 (c) Cadence2 Design2 Systems2, Inc2. All Rights2 Reserved2.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq2: Direct2 APB2 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq2 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq2)

   apb_pkg2::write_byte_seq2 write_seq2;
   rand bit [7:0] temp_data2;
   constraint c12 {temp_data2[7] == 1'b1; }

   function new(string name="apb_config_reg_seq2");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART2 Controller2 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line2 Control2 Register: bit 7, Divisor2 Latch2 Access = 1
      `uvm_do_with(write_seq2, { start_addr2 == 3; write_data2 == temp_data2; } )
      // Address 0: Divisor2 Latch2 Byte2 1 = 1
      `uvm_do_with(write_seq2, { start_addr2 == 0; write_data2 == 'h01; } )
      // Address 1: Divisor2 Latch2 Byte2 2 = 0
      `uvm_do_with(write_seq2, { start_addr2 == 1; write_data2 == 'h00; } )
      // Address 3: Line2 Control2 Register: bit 7, Divisor2 Latch2 Access = 0
      temp_data2[7] = 1'b0;
      `uvm_do_with(write_seq2, { start_addr2 == 3; write_data2 == temp_data2; } )
      `uvm_info(get_type_name(),
        "UART2 Controller2 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq2

//--------------------------------------------------------------------
// Base2 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq2 extends uvm_sequence;
  function new(string name="base_reg_seq2");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq2)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer2)

// Use a base sequence to raise/drop2 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running2 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq2

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq2: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq2 extends base_reg_seq2;

   // Pointer2 to the register model
   uart_ctrl_reg_model_c2 reg_model2;
   uvm_object rm_object2;

   `uvm_object_utils(uart_ctrl_config_reg_seq2)

   function new(string name="uart_ctrl_config_reg_seq2");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model2", rm_object2))
      $cast(reg_model2, rm_object2);
      `uvm_info(get_type_name(),
        "UART2 Controller2 Register configuration sequence starting...",
        UVM_LOW)
      // Line2 Control2 Register, set Divisor2 Latch2 Access = 1
      reg_model2.uart_ctrl_rf2.ua_lcr2.write(status, 'h8f);
      // Divisor2 Latch2 Byte2 1 = 1
      reg_model2.uart_ctrl_rf2.ua_div_latch02.write(status, 'h01);
      // Divisor2 Latch2 Byte2 2 = 0
      reg_model2.uart_ctrl_rf2.ua_div_latch12.write(status, 'h00);
      // Line2 Control2 Register, set Divisor2 Latch2 Access = 0
      reg_model2.uart_ctrl_rf2.ua_lcr2.write(status, 'h0f);
      //ToDo2: FIX2: DISABLE2 CHECKS2 AFTER CONFIG2 IS2 DONE
      reg_model2.uart_ctrl_rf2.ua_div_latch02.div_val2.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART2 Controller2 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq2

class uart_ctrl_1stopbit_reg_seq2 extends base_reg_seq2;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq2)

   function new(string name="uart_ctrl_1stopbit_reg_seq2");
      super.new(name);
   endfunction // new
 
   // Pointer2 to the register model
   uart_ctrl_rf_c2 reg_model2;
//   uart_ctrl_reg_model_c2 reg_model2;

   //ua_lcr_c2 ulcr2;
   //ua_div_latch0_c2 div_lsb2;
   //ua_div_latch1_c2 div_msb2;

   virtual task body();
     uvm_status_e status;
     reg_model2 = p_sequencer.reg_model2.uart_ctrl_rf2;
     `uvm_info(get_type_name(),
        "UART2 config register sequence with num_stop_bits2 == STOP12 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with2(ulcr2, "ua_lcr2", {value.num_stop_bits2 == 1'b0;})
      #50;
      //`rgm_write_by_name2(div_msb2, "ua_div_latch12")
      #50;
      //`rgm_write_by_name2(div_lsb2, "ua_div_latch02")
      #50;
      //ulcr2.value.div_latch_access2 = 1'b0;
      //`rgm_write_send2(ulcr2)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq2

class uart_cfg_rxtx_fifo_cov_reg_seq2 extends uart_ctrl_config_reg_seq2;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq2)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq2");
      super.new(name);
   endfunction : new
 
//   ua_ier_c2 uier2;
//   ua_idr_c2 uidr2;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx2/rx2 full/empty2 interrupts2...", UVM_LOW)
//     `rgm_write_by_name_with2(uier2, {uart_rf2, ".ua_ier2"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with2(uidr2, {uart_rf2, ".ua_idr2"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq2
