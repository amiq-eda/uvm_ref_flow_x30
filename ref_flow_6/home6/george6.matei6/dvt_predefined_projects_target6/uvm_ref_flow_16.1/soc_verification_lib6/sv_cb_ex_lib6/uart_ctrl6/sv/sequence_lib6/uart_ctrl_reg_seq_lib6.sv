/*-------------------------------------------------------------------------
File6 name   : uart_ctrl_reg_seq_lib6.sv
Title6       : UVM_REG Sequence Library6
Project6     :
Created6     :
Description6 : Register Sequence Library6 for the UART6 Controller6 DUT
Notes6       :
----------------------------------------------------------------------
Copyright6 2007 (c) Cadence6 Design6 Systems6, Inc6. All Rights6 Reserved6.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq6: Direct6 APB6 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq6 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq6)

   apb_pkg6::write_byte_seq6 write_seq6;
   rand bit [7:0] temp_data6;
   constraint c16 {temp_data6[7] == 1'b1; }

   function new(string name="apb_config_reg_seq6");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART6 Controller6 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line6 Control6 Register: bit 7, Divisor6 Latch6 Access = 1
      `uvm_do_with(write_seq6, { start_addr6 == 3; write_data6 == temp_data6; } )
      // Address 0: Divisor6 Latch6 Byte6 1 = 1
      `uvm_do_with(write_seq6, { start_addr6 == 0; write_data6 == 'h01; } )
      // Address 1: Divisor6 Latch6 Byte6 2 = 0
      `uvm_do_with(write_seq6, { start_addr6 == 1; write_data6 == 'h00; } )
      // Address 3: Line6 Control6 Register: bit 7, Divisor6 Latch6 Access = 0
      temp_data6[7] = 1'b0;
      `uvm_do_with(write_seq6, { start_addr6 == 3; write_data6 == temp_data6; } )
      `uvm_info(get_type_name(),
        "UART6 Controller6 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq6

//--------------------------------------------------------------------
// Base6 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq6 extends uvm_sequence;
  function new(string name="base_reg_seq6");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq6)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer6)

// Use a base sequence to raise/drop6 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running6 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq6

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq6: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq6 extends base_reg_seq6;

   // Pointer6 to the register model
   uart_ctrl_reg_model_c6 reg_model6;
   uvm_object rm_object6;

   `uvm_object_utils(uart_ctrl_config_reg_seq6)

   function new(string name="uart_ctrl_config_reg_seq6");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model6", rm_object6))
      $cast(reg_model6, rm_object6);
      `uvm_info(get_type_name(),
        "UART6 Controller6 Register configuration sequence starting...",
        UVM_LOW)
      // Line6 Control6 Register, set Divisor6 Latch6 Access = 1
      reg_model6.uart_ctrl_rf6.ua_lcr6.write(status, 'h8f);
      // Divisor6 Latch6 Byte6 1 = 1
      reg_model6.uart_ctrl_rf6.ua_div_latch06.write(status, 'h01);
      // Divisor6 Latch6 Byte6 2 = 0
      reg_model6.uart_ctrl_rf6.ua_div_latch16.write(status, 'h00);
      // Line6 Control6 Register, set Divisor6 Latch6 Access = 0
      reg_model6.uart_ctrl_rf6.ua_lcr6.write(status, 'h0f);
      //ToDo6: FIX6: DISABLE6 CHECKS6 AFTER CONFIG6 IS6 DONE
      reg_model6.uart_ctrl_rf6.ua_div_latch06.div_val6.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART6 Controller6 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq6

class uart_ctrl_1stopbit_reg_seq6 extends base_reg_seq6;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq6)

   function new(string name="uart_ctrl_1stopbit_reg_seq6");
      super.new(name);
   endfunction // new
 
   // Pointer6 to the register model
   uart_ctrl_rf_c6 reg_model6;
//   uart_ctrl_reg_model_c6 reg_model6;

   //ua_lcr_c6 ulcr6;
   //ua_div_latch0_c6 div_lsb6;
   //ua_div_latch1_c6 div_msb6;

   virtual task body();
     uvm_status_e status;
     reg_model6 = p_sequencer.reg_model6.uart_ctrl_rf6;
     `uvm_info(get_type_name(),
        "UART6 config register sequence with num_stop_bits6 == STOP16 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with6(ulcr6, "ua_lcr6", {value.num_stop_bits6 == 1'b0;})
      #50;
      //`rgm_write_by_name6(div_msb6, "ua_div_latch16")
      #50;
      //`rgm_write_by_name6(div_lsb6, "ua_div_latch06")
      #50;
      //ulcr6.value.div_latch_access6 = 1'b0;
      //`rgm_write_send6(ulcr6)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq6

class uart_cfg_rxtx_fifo_cov_reg_seq6 extends uart_ctrl_config_reg_seq6;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq6)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq6");
      super.new(name);
   endfunction : new
 
//   ua_ier_c6 uier6;
//   ua_idr_c6 uidr6;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx6/rx6 full/empty6 interrupts6...", UVM_LOW)
//     `rgm_write_by_name_with6(uier6, {uart_rf6, ".ua_ier6"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with6(uidr6, {uart_rf6, ".ua_idr6"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq6
