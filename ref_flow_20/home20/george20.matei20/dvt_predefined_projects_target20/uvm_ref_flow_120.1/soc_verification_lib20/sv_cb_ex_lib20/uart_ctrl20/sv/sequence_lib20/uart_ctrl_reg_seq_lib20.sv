/*-------------------------------------------------------------------------
File20 name   : uart_ctrl_reg_seq_lib20.sv
Title20       : UVM_REG Sequence Library20
Project20     :
Created20     :
Description20 : Register Sequence Library20 for the UART20 Controller20 DUT
Notes20       :
----------------------------------------------------------------------
Copyright20 2007 (c) Cadence20 Design20 Systems20, Inc20. All Rights20 Reserved20.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq20: Direct20 APB20 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq20 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq20)

   apb_pkg20::write_byte_seq20 write_seq20;
   rand bit [7:0] temp_data20;
   constraint c120 {temp_data20[7] == 1'b1; }

   function new(string name="apb_config_reg_seq20");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART20 Controller20 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line20 Control20 Register: bit 7, Divisor20 Latch20 Access = 1
      `uvm_do_with(write_seq20, { start_addr20 == 3; write_data20 == temp_data20; } )
      // Address 0: Divisor20 Latch20 Byte20 1 = 1
      `uvm_do_with(write_seq20, { start_addr20 == 0; write_data20 == 'h01; } )
      // Address 1: Divisor20 Latch20 Byte20 2 = 0
      `uvm_do_with(write_seq20, { start_addr20 == 1; write_data20 == 'h00; } )
      // Address 3: Line20 Control20 Register: bit 7, Divisor20 Latch20 Access = 0
      temp_data20[7] = 1'b0;
      `uvm_do_with(write_seq20, { start_addr20 == 3; write_data20 == temp_data20; } )
      `uvm_info(get_type_name(),
        "UART20 Controller20 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq20

//--------------------------------------------------------------------
// Base20 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq20 extends uvm_sequence;
  function new(string name="base_reg_seq20");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq20)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer20)

// Use a base sequence to raise/drop20 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running20 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq20

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq20: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq20 extends base_reg_seq20;

   // Pointer20 to the register model
   uart_ctrl_reg_model_c20 reg_model20;
   uvm_object rm_object20;

   `uvm_object_utils(uart_ctrl_config_reg_seq20)

   function new(string name="uart_ctrl_config_reg_seq20");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model20", rm_object20))
      $cast(reg_model20, rm_object20);
      `uvm_info(get_type_name(),
        "UART20 Controller20 Register configuration sequence starting...",
        UVM_LOW)
      // Line20 Control20 Register, set Divisor20 Latch20 Access = 1
      reg_model20.uart_ctrl_rf20.ua_lcr20.write(status, 'h8f);
      // Divisor20 Latch20 Byte20 1 = 1
      reg_model20.uart_ctrl_rf20.ua_div_latch020.write(status, 'h01);
      // Divisor20 Latch20 Byte20 2 = 0
      reg_model20.uart_ctrl_rf20.ua_div_latch120.write(status, 'h00);
      // Line20 Control20 Register, set Divisor20 Latch20 Access = 0
      reg_model20.uart_ctrl_rf20.ua_lcr20.write(status, 'h0f);
      //ToDo20: FIX20: DISABLE20 CHECKS20 AFTER CONFIG20 IS20 DONE
      reg_model20.uart_ctrl_rf20.ua_div_latch020.div_val20.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART20 Controller20 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq20

class uart_ctrl_1stopbit_reg_seq20 extends base_reg_seq20;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq20)

   function new(string name="uart_ctrl_1stopbit_reg_seq20");
      super.new(name);
   endfunction // new
 
   // Pointer20 to the register model
   uart_ctrl_rf_c20 reg_model20;
//   uart_ctrl_reg_model_c20 reg_model20;

   //ua_lcr_c20 ulcr20;
   //ua_div_latch0_c20 div_lsb20;
   //ua_div_latch1_c20 div_msb20;

   virtual task body();
     uvm_status_e status;
     reg_model20 = p_sequencer.reg_model20.uart_ctrl_rf20;
     `uvm_info(get_type_name(),
        "UART20 config register sequence with num_stop_bits20 == STOP120 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with20(ulcr20, "ua_lcr20", {value.num_stop_bits20 == 1'b0;})
      #50;
      //`rgm_write_by_name20(div_msb20, "ua_div_latch120")
      #50;
      //`rgm_write_by_name20(div_lsb20, "ua_div_latch020")
      #50;
      //ulcr20.value.div_latch_access20 = 1'b0;
      //`rgm_write_send20(ulcr20)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq20

class uart_cfg_rxtx_fifo_cov_reg_seq20 extends uart_ctrl_config_reg_seq20;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq20)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq20");
      super.new(name);
   endfunction : new
 
//   ua_ier_c20 uier20;
//   ua_idr_c20 uidr20;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx20/rx20 full/empty20 interrupts20...", UVM_LOW)
//     `rgm_write_by_name_with20(uier20, {uart_rf20, ".ua_ier20"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with20(uidr20, {uart_rf20, ".ua_idr20"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq20
