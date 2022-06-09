/*-------------------------------------------------------------------------
File26 name   : uart_ctrl_reg_seq_lib26.sv
Title26       : UVM_REG Sequence Library26
Project26     :
Created26     :
Description26 : Register Sequence Library26 for the UART26 Controller26 DUT
Notes26       :
----------------------------------------------------------------------
Copyright26 2007 (c) Cadence26 Design26 Systems26, Inc26. All Rights26 Reserved26.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq26: Direct26 APB26 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq26 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq26)

   apb_pkg26::write_byte_seq26 write_seq26;
   rand bit [7:0] temp_data26;
   constraint c126 {temp_data26[7] == 1'b1; }

   function new(string name="apb_config_reg_seq26");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART26 Controller26 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line26 Control26 Register: bit 7, Divisor26 Latch26 Access = 1
      `uvm_do_with(write_seq26, { start_addr26 == 3; write_data26 == temp_data26; } )
      // Address 0: Divisor26 Latch26 Byte26 1 = 1
      `uvm_do_with(write_seq26, { start_addr26 == 0; write_data26 == 'h01; } )
      // Address 1: Divisor26 Latch26 Byte26 2 = 0
      `uvm_do_with(write_seq26, { start_addr26 == 1; write_data26 == 'h00; } )
      // Address 3: Line26 Control26 Register: bit 7, Divisor26 Latch26 Access = 0
      temp_data26[7] = 1'b0;
      `uvm_do_with(write_seq26, { start_addr26 == 3; write_data26 == temp_data26; } )
      `uvm_info(get_type_name(),
        "UART26 Controller26 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq26

//--------------------------------------------------------------------
// Base26 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq26 extends uvm_sequence;
  function new(string name="base_reg_seq26");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq26)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer26)

// Use a base sequence to raise/drop26 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running26 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq26

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq26: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq26 extends base_reg_seq26;

   // Pointer26 to the register model
   uart_ctrl_reg_model_c26 reg_model26;
   uvm_object rm_object26;

   `uvm_object_utils(uart_ctrl_config_reg_seq26)

   function new(string name="uart_ctrl_config_reg_seq26");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model26", rm_object26))
      $cast(reg_model26, rm_object26);
      `uvm_info(get_type_name(),
        "UART26 Controller26 Register configuration sequence starting...",
        UVM_LOW)
      // Line26 Control26 Register, set Divisor26 Latch26 Access = 1
      reg_model26.uart_ctrl_rf26.ua_lcr26.write(status, 'h8f);
      // Divisor26 Latch26 Byte26 1 = 1
      reg_model26.uart_ctrl_rf26.ua_div_latch026.write(status, 'h01);
      // Divisor26 Latch26 Byte26 2 = 0
      reg_model26.uart_ctrl_rf26.ua_div_latch126.write(status, 'h00);
      // Line26 Control26 Register, set Divisor26 Latch26 Access = 0
      reg_model26.uart_ctrl_rf26.ua_lcr26.write(status, 'h0f);
      //ToDo26: FIX26: DISABLE26 CHECKS26 AFTER CONFIG26 IS26 DONE
      reg_model26.uart_ctrl_rf26.ua_div_latch026.div_val26.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART26 Controller26 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq26

class uart_ctrl_1stopbit_reg_seq26 extends base_reg_seq26;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq26)

   function new(string name="uart_ctrl_1stopbit_reg_seq26");
      super.new(name);
   endfunction // new
 
   // Pointer26 to the register model
   uart_ctrl_rf_c26 reg_model26;
//   uart_ctrl_reg_model_c26 reg_model26;

   //ua_lcr_c26 ulcr26;
   //ua_div_latch0_c26 div_lsb26;
   //ua_div_latch1_c26 div_msb26;

   virtual task body();
     uvm_status_e status;
     reg_model26 = p_sequencer.reg_model26.uart_ctrl_rf26;
     `uvm_info(get_type_name(),
        "UART26 config register sequence with num_stop_bits26 == STOP126 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with26(ulcr26, "ua_lcr26", {value.num_stop_bits26 == 1'b0;})
      #50;
      //`rgm_write_by_name26(div_msb26, "ua_div_latch126")
      #50;
      //`rgm_write_by_name26(div_lsb26, "ua_div_latch026")
      #50;
      //ulcr26.value.div_latch_access26 = 1'b0;
      //`rgm_write_send26(ulcr26)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq26

class uart_cfg_rxtx_fifo_cov_reg_seq26 extends uart_ctrl_config_reg_seq26;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq26)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq26");
      super.new(name);
   endfunction : new
 
//   ua_ier_c26 uier26;
//   ua_idr_c26 uidr26;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx26/rx26 full/empty26 interrupts26...", UVM_LOW)
//     `rgm_write_by_name_with26(uier26, {uart_rf26, ".ua_ier26"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with26(uidr26, {uart_rf26, ".ua_idr26"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq26
