/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_reg_seq_lib22.sv
Title22       : UVM_REG Sequence Library22
Project22     :
Created22     :
Description22 : Register Sequence Library22 for the UART22 Controller22 DUT
Notes22       :
----------------------------------------------------------------------
Copyright22 2007 (c) Cadence22 Design22 Systems22, Inc22. All Rights22 Reserved22.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq22: Direct22 APB22 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq22 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq22)

   apb_pkg22::write_byte_seq22 write_seq22;
   rand bit [7:0] temp_data22;
   constraint c122 {temp_data22[7] == 1'b1; }

   function new(string name="apb_config_reg_seq22");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART22 Controller22 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line22 Control22 Register: bit 7, Divisor22 Latch22 Access = 1
      `uvm_do_with(write_seq22, { start_addr22 == 3; write_data22 == temp_data22; } )
      // Address 0: Divisor22 Latch22 Byte22 1 = 1
      `uvm_do_with(write_seq22, { start_addr22 == 0; write_data22 == 'h01; } )
      // Address 1: Divisor22 Latch22 Byte22 2 = 0
      `uvm_do_with(write_seq22, { start_addr22 == 1; write_data22 == 'h00; } )
      // Address 3: Line22 Control22 Register: bit 7, Divisor22 Latch22 Access = 0
      temp_data22[7] = 1'b0;
      `uvm_do_with(write_seq22, { start_addr22 == 3; write_data22 == temp_data22; } )
      `uvm_info(get_type_name(),
        "UART22 Controller22 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq22

//--------------------------------------------------------------------
// Base22 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq22 extends uvm_sequence;
  function new(string name="base_reg_seq22");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq22)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer22)

// Use a base sequence to raise/drop22 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running22 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq22

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq22: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq22 extends base_reg_seq22;

   // Pointer22 to the register model
   uart_ctrl_reg_model_c22 reg_model22;
   uvm_object rm_object22;

   `uvm_object_utils(uart_ctrl_config_reg_seq22)

   function new(string name="uart_ctrl_config_reg_seq22");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model22", rm_object22))
      $cast(reg_model22, rm_object22);
      `uvm_info(get_type_name(),
        "UART22 Controller22 Register configuration sequence starting...",
        UVM_LOW)
      // Line22 Control22 Register, set Divisor22 Latch22 Access = 1
      reg_model22.uart_ctrl_rf22.ua_lcr22.write(status, 'h8f);
      // Divisor22 Latch22 Byte22 1 = 1
      reg_model22.uart_ctrl_rf22.ua_div_latch022.write(status, 'h01);
      // Divisor22 Latch22 Byte22 2 = 0
      reg_model22.uart_ctrl_rf22.ua_div_latch122.write(status, 'h00);
      // Line22 Control22 Register, set Divisor22 Latch22 Access = 0
      reg_model22.uart_ctrl_rf22.ua_lcr22.write(status, 'h0f);
      //ToDo22: FIX22: DISABLE22 CHECKS22 AFTER CONFIG22 IS22 DONE
      reg_model22.uart_ctrl_rf22.ua_div_latch022.div_val22.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART22 Controller22 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq22

class uart_ctrl_1stopbit_reg_seq22 extends base_reg_seq22;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq22)

   function new(string name="uart_ctrl_1stopbit_reg_seq22");
      super.new(name);
   endfunction // new
 
   // Pointer22 to the register model
   uart_ctrl_rf_c22 reg_model22;
//   uart_ctrl_reg_model_c22 reg_model22;

   //ua_lcr_c22 ulcr22;
   //ua_div_latch0_c22 div_lsb22;
   //ua_div_latch1_c22 div_msb22;

   virtual task body();
     uvm_status_e status;
     reg_model22 = p_sequencer.reg_model22.uart_ctrl_rf22;
     `uvm_info(get_type_name(),
        "UART22 config register sequence with num_stop_bits22 == STOP122 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with22(ulcr22, "ua_lcr22", {value.num_stop_bits22 == 1'b0;})
      #50;
      //`rgm_write_by_name22(div_msb22, "ua_div_latch122")
      #50;
      //`rgm_write_by_name22(div_lsb22, "ua_div_latch022")
      #50;
      //ulcr22.value.div_latch_access22 = 1'b0;
      //`rgm_write_send22(ulcr22)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq22

class uart_cfg_rxtx_fifo_cov_reg_seq22 extends uart_ctrl_config_reg_seq22;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq22)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq22");
      super.new(name);
   endfunction : new
 
//   ua_ier_c22 uier22;
//   ua_idr_c22 uidr22;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx22/rx22 full/empty22 interrupts22...", UVM_LOW)
//     `rgm_write_by_name_with22(uier22, {uart_rf22, ".ua_ier22"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with22(uidr22, {uart_rf22, ".ua_idr22"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq22
