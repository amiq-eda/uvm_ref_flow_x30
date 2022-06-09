/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_reg_seq_lib12.sv
Title12       : UVM_REG Sequence Library12
Project12     :
Created12     :
Description12 : Register Sequence Library12 for the UART12 Controller12 DUT
Notes12       :
----------------------------------------------------------------------
Copyright12 2007 (c) Cadence12 Design12 Systems12, Inc12. All Rights12 Reserved12.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq12: Direct12 APB12 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq12 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq12)

   apb_pkg12::write_byte_seq12 write_seq12;
   rand bit [7:0] temp_data12;
   constraint c112 {temp_data12[7] == 1'b1; }

   function new(string name="apb_config_reg_seq12");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART12 Controller12 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line12 Control12 Register: bit 7, Divisor12 Latch12 Access = 1
      `uvm_do_with(write_seq12, { start_addr12 == 3; write_data12 == temp_data12; } )
      // Address 0: Divisor12 Latch12 Byte12 1 = 1
      `uvm_do_with(write_seq12, { start_addr12 == 0; write_data12 == 'h01; } )
      // Address 1: Divisor12 Latch12 Byte12 2 = 0
      `uvm_do_with(write_seq12, { start_addr12 == 1; write_data12 == 'h00; } )
      // Address 3: Line12 Control12 Register: bit 7, Divisor12 Latch12 Access = 0
      temp_data12[7] = 1'b0;
      `uvm_do_with(write_seq12, { start_addr12 == 3; write_data12 == temp_data12; } )
      `uvm_info(get_type_name(),
        "UART12 Controller12 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq12

//--------------------------------------------------------------------
// Base12 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq12 extends uvm_sequence;
  function new(string name="base_reg_seq12");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq12)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer12)

// Use a base sequence to raise/drop12 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running12 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq12

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq12: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq12 extends base_reg_seq12;

   // Pointer12 to the register model
   uart_ctrl_reg_model_c12 reg_model12;
   uvm_object rm_object12;

   `uvm_object_utils(uart_ctrl_config_reg_seq12)

   function new(string name="uart_ctrl_config_reg_seq12");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model12", rm_object12))
      $cast(reg_model12, rm_object12);
      `uvm_info(get_type_name(),
        "UART12 Controller12 Register configuration sequence starting...",
        UVM_LOW)
      // Line12 Control12 Register, set Divisor12 Latch12 Access = 1
      reg_model12.uart_ctrl_rf12.ua_lcr12.write(status, 'h8f);
      // Divisor12 Latch12 Byte12 1 = 1
      reg_model12.uart_ctrl_rf12.ua_div_latch012.write(status, 'h01);
      // Divisor12 Latch12 Byte12 2 = 0
      reg_model12.uart_ctrl_rf12.ua_div_latch112.write(status, 'h00);
      // Line12 Control12 Register, set Divisor12 Latch12 Access = 0
      reg_model12.uart_ctrl_rf12.ua_lcr12.write(status, 'h0f);
      //ToDo12: FIX12: DISABLE12 CHECKS12 AFTER CONFIG12 IS12 DONE
      reg_model12.uart_ctrl_rf12.ua_div_latch012.div_val12.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART12 Controller12 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq12

class uart_ctrl_1stopbit_reg_seq12 extends base_reg_seq12;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq12)

   function new(string name="uart_ctrl_1stopbit_reg_seq12");
      super.new(name);
   endfunction // new
 
   // Pointer12 to the register model
   uart_ctrl_rf_c12 reg_model12;
//   uart_ctrl_reg_model_c12 reg_model12;

   //ua_lcr_c12 ulcr12;
   //ua_div_latch0_c12 div_lsb12;
   //ua_div_latch1_c12 div_msb12;

   virtual task body();
     uvm_status_e status;
     reg_model12 = p_sequencer.reg_model12.uart_ctrl_rf12;
     `uvm_info(get_type_name(),
        "UART12 config register sequence with num_stop_bits12 == STOP112 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with12(ulcr12, "ua_lcr12", {value.num_stop_bits12 == 1'b0;})
      #50;
      //`rgm_write_by_name12(div_msb12, "ua_div_latch112")
      #50;
      //`rgm_write_by_name12(div_lsb12, "ua_div_latch012")
      #50;
      //ulcr12.value.div_latch_access12 = 1'b0;
      //`rgm_write_send12(ulcr12)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq12

class uart_cfg_rxtx_fifo_cov_reg_seq12 extends uart_ctrl_config_reg_seq12;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq12)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq12");
      super.new(name);
   endfunction : new
 
//   ua_ier_c12 uier12;
//   ua_idr_c12 uidr12;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx12/rx12 full/empty12 interrupts12...", UVM_LOW)
//     `rgm_write_by_name_with12(uier12, {uart_rf12, ".ua_ier12"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with12(uidr12, {uart_rf12, ".ua_idr12"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq12
