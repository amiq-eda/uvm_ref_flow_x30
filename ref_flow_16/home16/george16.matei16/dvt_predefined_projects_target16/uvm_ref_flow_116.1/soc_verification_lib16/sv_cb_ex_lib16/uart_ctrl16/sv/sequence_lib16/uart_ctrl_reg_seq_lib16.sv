/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_reg_seq_lib16.sv
Title16       : UVM_REG Sequence Library16
Project16     :
Created16     :
Description16 : Register Sequence Library16 for the UART16 Controller16 DUT
Notes16       :
----------------------------------------------------------------------
Copyright16 2007 (c) Cadence16 Design16 Systems16, Inc16. All Rights16 Reserved16.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq16: Direct16 APB16 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq16 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq16)

   apb_pkg16::write_byte_seq16 write_seq16;
   rand bit [7:0] temp_data16;
   constraint c116 {temp_data16[7] == 1'b1; }

   function new(string name="apb_config_reg_seq16");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART16 Controller16 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line16 Control16 Register: bit 7, Divisor16 Latch16 Access = 1
      `uvm_do_with(write_seq16, { start_addr16 == 3; write_data16 == temp_data16; } )
      // Address 0: Divisor16 Latch16 Byte16 1 = 1
      `uvm_do_with(write_seq16, { start_addr16 == 0; write_data16 == 'h01; } )
      // Address 1: Divisor16 Latch16 Byte16 2 = 0
      `uvm_do_with(write_seq16, { start_addr16 == 1; write_data16 == 'h00; } )
      // Address 3: Line16 Control16 Register: bit 7, Divisor16 Latch16 Access = 0
      temp_data16[7] = 1'b0;
      `uvm_do_with(write_seq16, { start_addr16 == 3; write_data16 == temp_data16; } )
      `uvm_info(get_type_name(),
        "UART16 Controller16 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq16

//--------------------------------------------------------------------
// Base16 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq16 extends uvm_sequence;
  function new(string name="base_reg_seq16");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq16)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer16)

// Use a base sequence to raise/drop16 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running16 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq16

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq16: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq16 extends base_reg_seq16;

   // Pointer16 to the register model
   uart_ctrl_reg_model_c16 reg_model16;
   uvm_object rm_object16;

   `uvm_object_utils(uart_ctrl_config_reg_seq16)

   function new(string name="uart_ctrl_config_reg_seq16");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model16", rm_object16))
      $cast(reg_model16, rm_object16);
      `uvm_info(get_type_name(),
        "UART16 Controller16 Register configuration sequence starting...",
        UVM_LOW)
      // Line16 Control16 Register, set Divisor16 Latch16 Access = 1
      reg_model16.uart_ctrl_rf16.ua_lcr16.write(status, 'h8f);
      // Divisor16 Latch16 Byte16 1 = 1
      reg_model16.uart_ctrl_rf16.ua_div_latch016.write(status, 'h01);
      // Divisor16 Latch16 Byte16 2 = 0
      reg_model16.uart_ctrl_rf16.ua_div_latch116.write(status, 'h00);
      // Line16 Control16 Register, set Divisor16 Latch16 Access = 0
      reg_model16.uart_ctrl_rf16.ua_lcr16.write(status, 'h0f);
      //ToDo16: FIX16: DISABLE16 CHECKS16 AFTER CONFIG16 IS16 DONE
      reg_model16.uart_ctrl_rf16.ua_div_latch016.div_val16.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART16 Controller16 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq16

class uart_ctrl_1stopbit_reg_seq16 extends base_reg_seq16;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq16)

   function new(string name="uart_ctrl_1stopbit_reg_seq16");
      super.new(name);
   endfunction // new
 
   // Pointer16 to the register model
   uart_ctrl_rf_c16 reg_model16;
//   uart_ctrl_reg_model_c16 reg_model16;

   //ua_lcr_c16 ulcr16;
   //ua_div_latch0_c16 div_lsb16;
   //ua_div_latch1_c16 div_msb16;

   virtual task body();
     uvm_status_e status;
     reg_model16 = p_sequencer.reg_model16.uart_ctrl_rf16;
     `uvm_info(get_type_name(),
        "UART16 config register sequence with num_stop_bits16 == STOP116 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with16(ulcr16, "ua_lcr16", {value.num_stop_bits16 == 1'b0;})
      #50;
      //`rgm_write_by_name16(div_msb16, "ua_div_latch116")
      #50;
      //`rgm_write_by_name16(div_lsb16, "ua_div_latch016")
      #50;
      //ulcr16.value.div_latch_access16 = 1'b0;
      //`rgm_write_send16(ulcr16)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq16

class uart_cfg_rxtx_fifo_cov_reg_seq16 extends uart_ctrl_config_reg_seq16;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq16)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq16");
      super.new(name);
   endfunction : new
 
//   ua_ier_c16 uier16;
//   ua_idr_c16 uidr16;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx16/rx16 full/empty16 interrupts16...", UVM_LOW)
//     `rgm_write_by_name_with16(uier16, {uart_rf16, ".ua_ier16"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with16(uidr16, {uart_rf16, ".ua_idr16"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq16
