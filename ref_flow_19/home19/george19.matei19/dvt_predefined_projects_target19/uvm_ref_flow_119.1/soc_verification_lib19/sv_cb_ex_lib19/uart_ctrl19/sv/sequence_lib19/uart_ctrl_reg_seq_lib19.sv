/*-------------------------------------------------------------------------
File19 name   : uart_ctrl_reg_seq_lib19.sv
Title19       : UVM_REG Sequence Library19
Project19     :
Created19     :
Description19 : Register Sequence Library19 for the UART19 Controller19 DUT
Notes19       :
----------------------------------------------------------------------
Copyright19 2007 (c) Cadence19 Design19 Systems19, Inc19. All Rights19 Reserved19.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq19: Direct19 APB19 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq19 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq19)

   apb_pkg19::write_byte_seq19 write_seq19;
   rand bit [7:0] temp_data19;
   constraint c119 {temp_data19[7] == 1'b1; }

   function new(string name="apb_config_reg_seq19");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART19 Controller19 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line19 Control19 Register: bit 7, Divisor19 Latch19 Access = 1
      `uvm_do_with(write_seq19, { start_addr19 == 3; write_data19 == temp_data19; } )
      // Address 0: Divisor19 Latch19 Byte19 1 = 1
      `uvm_do_with(write_seq19, { start_addr19 == 0; write_data19 == 'h01; } )
      // Address 1: Divisor19 Latch19 Byte19 2 = 0
      `uvm_do_with(write_seq19, { start_addr19 == 1; write_data19 == 'h00; } )
      // Address 3: Line19 Control19 Register: bit 7, Divisor19 Latch19 Access = 0
      temp_data19[7] = 1'b0;
      `uvm_do_with(write_seq19, { start_addr19 == 3; write_data19 == temp_data19; } )
      `uvm_info(get_type_name(),
        "UART19 Controller19 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq19

//--------------------------------------------------------------------
// Base19 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq19 extends uvm_sequence;
  function new(string name="base_reg_seq19");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq19)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer19)

// Use a base sequence to raise/drop19 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running19 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq19

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq19: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq19 extends base_reg_seq19;

   // Pointer19 to the register model
   uart_ctrl_reg_model_c19 reg_model19;
   uvm_object rm_object19;

   `uvm_object_utils(uart_ctrl_config_reg_seq19)

   function new(string name="uart_ctrl_config_reg_seq19");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model19", rm_object19))
      $cast(reg_model19, rm_object19);
      `uvm_info(get_type_name(),
        "UART19 Controller19 Register configuration sequence starting...",
        UVM_LOW)
      // Line19 Control19 Register, set Divisor19 Latch19 Access = 1
      reg_model19.uart_ctrl_rf19.ua_lcr19.write(status, 'h8f);
      // Divisor19 Latch19 Byte19 1 = 1
      reg_model19.uart_ctrl_rf19.ua_div_latch019.write(status, 'h01);
      // Divisor19 Latch19 Byte19 2 = 0
      reg_model19.uart_ctrl_rf19.ua_div_latch119.write(status, 'h00);
      // Line19 Control19 Register, set Divisor19 Latch19 Access = 0
      reg_model19.uart_ctrl_rf19.ua_lcr19.write(status, 'h0f);
      //ToDo19: FIX19: DISABLE19 CHECKS19 AFTER CONFIG19 IS19 DONE
      reg_model19.uart_ctrl_rf19.ua_div_latch019.div_val19.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART19 Controller19 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq19

class uart_ctrl_1stopbit_reg_seq19 extends base_reg_seq19;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq19)

   function new(string name="uart_ctrl_1stopbit_reg_seq19");
      super.new(name);
   endfunction // new
 
   // Pointer19 to the register model
   uart_ctrl_rf_c19 reg_model19;
//   uart_ctrl_reg_model_c19 reg_model19;

   //ua_lcr_c19 ulcr19;
   //ua_div_latch0_c19 div_lsb19;
   //ua_div_latch1_c19 div_msb19;

   virtual task body();
     uvm_status_e status;
     reg_model19 = p_sequencer.reg_model19.uart_ctrl_rf19;
     `uvm_info(get_type_name(),
        "UART19 config register sequence with num_stop_bits19 == STOP119 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with19(ulcr19, "ua_lcr19", {value.num_stop_bits19 == 1'b0;})
      #50;
      //`rgm_write_by_name19(div_msb19, "ua_div_latch119")
      #50;
      //`rgm_write_by_name19(div_lsb19, "ua_div_latch019")
      #50;
      //ulcr19.value.div_latch_access19 = 1'b0;
      //`rgm_write_send19(ulcr19)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq19

class uart_cfg_rxtx_fifo_cov_reg_seq19 extends uart_ctrl_config_reg_seq19;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq19)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq19");
      super.new(name);
   endfunction : new
 
//   ua_ier_c19 uier19;
//   ua_idr_c19 uidr19;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx19/rx19 full/empty19 interrupts19...", UVM_LOW)
//     `rgm_write_by_name_with19(uier19, {uart_rf19, ".ua_ier19"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with19(uidr19, {uart_rf19, ".ua_idr19"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq19
