/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_reg_seq_lib14.sv
Title14       : UVM_REG Sequence Library14
Project14     :
Created14     :
Description14 : Register Sequence Library14 for the UART14 Controller14 DUT
Notes14       :
----------------------------------------------------------------------
Copyright14 2007 (c) Cadence14 Design14 Systems14, Inc14. All Rights14 Reserved14.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq14: Direct14 APB14 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq14 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq14)

   apb_pkg14::write_byte_seq14 write_seq14;
   rand bit [7:0] temp_data14;
   constraint c114 {temp_data14[7] == 1'b1; }

   function new(string name="apb_config_reg_seq14");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART14 Controller14 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line14 Control14 Register: bit 7, Divisor14 Latch14 Access = 1
      `uvm_do_with(write_seq14, { start_addr14 == 3; write_data14 == temp_data14; } )
      // Address 0: Divisor14 Latch14 Byte14 1 = 1
      `uvm_do_with(write_seq14, { start_addr14 == 0; write_data14 == 'h01; } )
      // Address 1: Divisor14 Latch14 Byte14 2 = 0
      `uvm_do_with(write_seq14, { start_addr14 == 1; write_data14 == 'h00; } )
      // Address 3: Line14 Control14 Register: bit 7, Divisor14 Latch14 Access = 0
      temp_data14[7] = 1'b0;
      `uvm_do_with(write_seq14, { start_addr14 == 3; write_data14 == temp_data14; } )
      `uvm_info(get_type_name(),
        "UART14 Controller14 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq14

//--------------------------------------------------------------------
// Base14 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq14 extends uvm_sequence;
  function new(string name="base_reg_seq14");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq14)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer14)

// Use a base sequence to raise/drop14 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running14 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq14

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq14: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq14 extends base_reg_seq14;

   // Pointer14 to the register model
   uart_ctrl_reg_model_c14 reg_model14;
   uvm_object rm_object14;

   `uvm_object_utils(uart_ctrl_config_reg_seq14)

   function new(string name="uart_ctrl_config_reg_seq14");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model14", rm_object14))
      $cast(reg_model14, rm_object14);
      `uvm_info(get_type_name(),
        "UART14 Controller14 Register configuration sequence starting...",
        UVM_LOW)
      // Line14 Control14 Register, set Divisor14 Latch14 Access = 1
      reg_model14.uart_ctrl_rf14.ua_lcr14.write(status, 'h8f);
      // Divisor14 Latch14 Byte14 1 = 1
      reg_model14.uart_ctrl_rf14.ua_div_latch014.write(status, 'h01);
      // Divisor14 Latch14 Byte14 2 = 0
      reg_model14.uart_ctrl_rf14.ua_div_latch114.write(status, 'h00);
      // Line14 Control14 Register, set Divisor14 Latch14 Access = 0
      reg_model14.uart_ctrl_rf14.ua_lcr14.write(status, 'h0f);
      //ToDo14: FIX14: DISABLE14 CHECKS14 AFTER CONFIG14 IS14 DONE
      reg_model14.uart_ctrl_rf14.ua_div_latch014.div_val14.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART14 Controller14 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq14

class uart_ctrl_1stopbit_reg_seq14 extends base_reg_seq14;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq14)

   function new(string name="uart_ctrl_1stopbit_reg_seq14");
      super.new(name);
   endfunction // new
 
   // Pointer14 to the register model
   uart_ctrl_rf_c14 reg_model14;
//   uart_ctrl_reg_model_c14 reg_model14;

   //ua_lcr_c14 ulcr14;
   //ua_div_latch0_c14 div_lsb14;
   //ua_div_latch1_c14 div_msb14;

   virtual task body();
     uvm_status_e status;
     reg_model14 = p_sequencer.reg_model14.uart_ctrl_rf14;
     `uvm_info(get_type_name(),
        "UART14 config register sequence with num_stop_bits14 == STOP114 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with14(ulcr14, "ua_lcr14", {value.num_stop_bits14 == 1'b0;})
      #50;
      //`rgm_write_by_name14(div_msb14, "ua_div_latch114")
      #50;
      //`rgm_write_by_name14(div_lsb14, "ua_div_latch014")
      #50;
      //ulcr14.value.div_latch_access14 = 1'b0;
      //`rgm_write_send14(ulcr14)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq14

class uart_cfg_rxtx_fifo_cov_reg_seq14 extends uart_ctrl_config_reg_seq14;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq14)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq14");
      super.new(name);
   endfunction : new
 
//   ua_ier_c14 uier14;
//   ua_idr_c14 uidr14;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx14/rx14 full/empty14 interrupts14...", UVM_LOW)
//     `rgm_write_by_name_with14(uier14, {uart_rf14, ".ua_ier14"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with14(uidr14, {uart_rf14, ".ua_idr14"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq14
