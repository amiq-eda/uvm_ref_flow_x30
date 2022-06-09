/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_reg_seq_lib25.sv
Title25       : UVM_REG Sequence Library25
Project25     :
Created25     :
Description25 : Register Sequence Library25 for the UART25 Controller25 DUT
Notes25       :
----------------------------------------------------------------------
Copyright25 2007 (c) Cadence25 Design25 Systems25, Inc25. All Rights25 Reserved25.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq25: Direct25 APB25 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq25 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq25)

   apb_pkg25::write_byte_seq25 write_seq25;
   rand bit [7:0] temp_data25;
   constraint c125 {temp_data25[7] == 1'b1; }

   function new(string name="apb_config_reg_seq25");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART25 Controller25 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line25 Control25 Register: bit 7, Divisor25 Latch25 Access = 1
      `uvm_do_with(write_seq25, { start_addr25 == 3; write_data25 == temp_data25; } )
      // Address 0: Divisor25 Latch25 Byte25 1 = 1
      `uvm_do_with(write_seq25, { start_addr25 == 0; write_data25 == 'h01; } )
      // Address 1: Divisor25 Latch25 Byte25 2 = 0
      `uvm_do_with(write_seq25, { start_addr25 == 1; write_data25 == 'h00; } )
      // Address 3: Line25 Control25 Register: bit 7, Divisor25 Latch25 Access = 0
      temp_data25[7] = 1'b0;
      `uvm_do_with(write_seq25, { start_addr25 == 3; write_data25 == temp_data25; } )
      `uvm_info(get_type_name(),
        "UART25 Controller25 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq25

//--------------------------------------------------------------------
// Base25 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq25 extends uvm_sequence;
  function new(string name="base_reg_seq25");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq25)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer25)

// Use a base sequence to raise/drop25 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running25 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq25

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq25: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq25 extends base_reg_seq25;

   // Pointer25 to the register model
   uart_ctrl_reg_model_c25 reg_model25;
   uvm_object rm_object25;

   `uvm_object_utils(uart_ctrl_config_reg_seq25)

   function new(string name="uart_ctrl_config_reg_seq25");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model25", rm_object25))
      $cast(reg_model25, rm_object25);
      `uvm_info(get_type_name(),
        "UART25 Controller25 Register configuration sequence starting...",
        UVM_LOW)
      // Line25 Control25 Register, set Divisor25 Latch25 Access = 1
      reg_model25.uart_ctrl_rf25.ua_lcr25.write(status, 'h8f);
      // Divisor25 Latch25 Byte25 1 = 1
      reg_model25.uart_ctrl_rf25.ua_div_latch025.write(status, 'h01);
      // Divisor25 Latch25 Byte25 2 = 0
      reg_model25.uart_ctrl_rf25.ua_div_latch125.write(status, 'h00);
      // Line25 Control25 Register, set Divisor25 Latch25 Access = 0
      reg_model25.uart_ctrl_rf25.ua_lcr25.write(status, 'h0f);
      //ToDo25: FIX25: DISABLE25 CHECKS25 AFTER CONFIG25 IS25 DONE
      reg_model25.uart_ctrl_rf25.ua_div_latch025.div_val25.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART25 Controller25 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq25

class uart_ctrl_1stopbit_reg_seq25 extends base_reg_seq25;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq25)

   function new(string name="uart_ctrl_1stopbit_reg_seq25");
      super.new(name);
   endfunction // new
 
   // Pointer25 to the register model
   uart_ctrl_rf_c25 reg_model25;
//   uart_ctrl_reg_model_c25 reg_model25;

   //ua_lcr_c25 ulcr25;
   //ua_div_latch0_c25 div_lsb25;
   //ua_div_latch1_c25 div_msb25;

   virtual task body();
     uvm_status_e status;
     reg_model25 = p_sequencer.reg_model25.uart_ctrl_rf25;
     `uvm_info(get_type_name(),
        "UART25 config register sequence with num_stop_bits25 == STOP125 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with25(ulcr25, "ua_lcr25", {value.num_stop_bits25 == 1'b0;})
      #50;
      //`rgm_write_by_name25(div_msb25, "ua_div_latch125")
      #50;
      //`rgm_write_by_name25(div_lsb25, "ua_div_latch025")
      #50;
      //ulcr25.value.div_latch_access25 = 1'b0;
      //`rgm_write_send25(ulcr25)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq25

class uart_cfg_rxtx_fifo_cov_reg_seq25 extends uart_ctrl_config_reg_seq25;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq25)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq25");
      super.new(name);
   endfunction : new
 
//   ua_ier_c25 uier25;
//   ua_idr_c25 uidr25;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx25/rx25 full/empty25 interrupts25...", UVM_LOW)
//     `rgm_write_by_name_with25(uier25, {uart_rf25, ".ua_ier25"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with25(uidr25, {uart_rf25, ".ua_idr25"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq25
