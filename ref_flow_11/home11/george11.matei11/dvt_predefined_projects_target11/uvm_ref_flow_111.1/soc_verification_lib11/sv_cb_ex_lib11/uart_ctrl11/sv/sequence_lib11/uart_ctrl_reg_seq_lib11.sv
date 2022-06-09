/*-------------------------------------------------------------------------
File11 name   : uart_ctrl_reg_seq_lib11.sv
Title11       : UVM_REG Sequence Library11
Project11     :
Created11     :
Description11 : Register Sequence Library11 for the UART11 Controller11 DUT
Notes11       :
----------------------------------------------------------------------
Copyright11 2007 (c) Cadence11 Design11 Systems11, Inc11. All Rights11 Reserved11.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq11: Direct11 APB11 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq11 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq11)

   apb_pkg11::write_byte_seq11 write_seq11;
   rand bit [7:0] temp_data11;
   constraint c111 {temp_data11[7] == 1'b1; }

   function new(string name="apb_config_reg_seq11");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART11 Controller11 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line11 Control11 Register: bit 7, Divisor11 Latch11 Access = 1
      `uvm_do_with(write_seq11, { start_addr11 == 3; write_data11 == temp_data11; } )
      // Address 0: Divisor11 Latch11 Byte11 1 = 1
      `uvm_do_with(write_seq11, { start_addr11 == 0; write_data11 == 'h01; } )
      // Address 1: Divisor11 Latch11 Byte11 2 = 0
      `uvm_do_with(write_seq11, { start_addr11 == 1; write_data11 == 'h00; } )
      // Address 3: Line11 Control11 Register: bit 7, Divisor11 Latch11 Access = 0
      temp_data11[7] = 1'b0;
      `uvm_do_with(write_seq11, { start_addr11 == 3; write_data11 == temp_data11; } )
      `uvm_info(get_type_name(),
        "UART11 Controller11 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq11

//--------------------------------------------------------------------
// Base11 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq11 extends uvm_sequence;
  function new(string name="base_reg_seq11");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq11)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer11)

// Use a base sequence to raise/drop11 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running11 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq11

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq11: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq11 extends base_reg_seq11;

   // Pointer11 to the register model
   uart_ctrl_reg_model_c11 reg_model11;
   uvm_object rm_object11;

   `uvm_object_utils(uart_ctrl_config_reg_seq11)

   function new(string name="uart_ctrl_config_reg_seq11");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model11", rm_object11))
      $cast(reg_model11, rm_object11);
      `uvm_info(get_type_name(),
        "UART11 Controller11 Register configuration sequence starting...",
        UVM_LOW)
      // Line11 Control11 Register, set Divisor11 Latch11 Access = 1
      reg_model11.uart_ctrl_rf11.ua_lcr11.write(status, 'h8f);
      // Divisor11 Latch11 Byte11 1 = 1
      reg_model11.uart_ctrl_rf11.ua_div_latch011.write(status, 'h01);
      // Divisor11 Latch11 Byte11 2 = 0
      reg_model11.uart_ctrl_rf11.ua_div_latch111.write(status, 'h00);
      // Line11 Control11 Register, set Divisor11 Latch11 Access = 0
      reg_model11.uart_ctrl_rf11.ua_lcr11.write(status, 'h0f);
      //ToDo11: FIX11: DISABLE11 CHECKS11 AFTER CONFIG11 IS11 DONE
      reg_model11.uart_ctrl_rf11.ua_div_latch011.div_val11.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART11 Controller11 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq11

class uart_ctrl_1stopbit_reg_seq11 extends base_reg_seq11;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq11)

   function new(string name="uart_ctrl_1stopbit_reg_seq11");
      super.new(name);
   endfunction // new
 
   // Pointer11 to the register model
   uart_ctrl_rf_c11 reg_model11;
//   uart_ctrl_reg_model_c11 reg_model11;

   //ua_lcr_c11 ulcr11;
   //ua_div_latch0_c11 div_lsb11;
   //ua_div_latch1_c11 div_msb11;

   virtual task body();
     uvm_status_e status;
     reg_model11 = p_sequencer.reg_model11.uart_ctrl_rf11;
     `uvm_info(get_type_name(),
        "UART11 config register sequence with num_stop_bits11 == STOP111 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with11(ulcr11, "ua_lcr11", {value.num_stop_bits11 == 1'b0;})
      #50;
      //`rgm_write_by_name11(div_msb11, "ua_div_latch111")
      #50;
      //`rgm_write_by_name11(div_lsb11, "ua_div_latch011")
      #50;
      //ulcr11.value.div_latch_access11 = 1'b0;
      //`rgm_write_send11(ulcr11)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq11

class uart_cfg_rxtx_fifo_cov_reg_seq11 extends uart_ctrl_config_reg_seq11;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq11)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq11");
      super.new(name);
   endfunction : new
 
//   ua_ier_c11 uier11;
//   ua_idr_c11 uidr11;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx11/rx11 full/empty11 interrupts11...", UVM_LOW)
//     `rgm_write_by_name_with11(uier11, {uart_rf11, ".ua_ier11"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with11(uidr11, {uart_rf11, ".ua_idr11"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq11
