/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_reg_seq_lib27.sv
Title27       : UVM_REG Sequence Library27
Project27     :
Created27     :
Description27 : Register Sequence Library27 for the UART27 Controller27 DUT
Notes27       :
----------------------------------------------------------------------
Copyright27 2007 (c) Cadence27 Design27 Systems27, Inc27. All Rights27 Reserved27.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq27: Direct27 APB27 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq27 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq27)

   apb_pkg27::write_byte_seq27 write_seq27;
   rand bit [7:0] temp_data27;
   constraint c127 {temp_data27[7] == 1'b1; }

   function new(string name="apb_config_reg_seq27");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART27 Controller27 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line27 Control27 Register: bit 7, Divisor27 Latch27 Access = 1
      `uvm_do_with(write_seq27, { start_addr27 == 3; write_data27 == temp_data27; } )
      // Address 0: Divisor27 Latch27 Byte27 1 = 1
      `uvm_do_with(write_seq27, { start_addr27 == 0; write_data27 == 'h01; } )
      // Address 1: Divisor27 Latch27 Byte27 2 = 0
      `uvm_do_with(write_seq27, { start_addr27 == 1; write_data27 == 'h00; } )
      // Address 3: Line27 Control27 Register: bit 7, Divisor27 Latch27 Access = 0
      temp_data27[7] = 1'b0;
      `uvm_do_with(write_seq27, { start_addr27 == 3; write_data27 == temp_data27; } )
      `uvm_info(get_type_name(),
        "UART27 Controller27 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq27

//--------------------------------------------------------------------
// Base27 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq27 extends uvm_sequence;
  function new(string name="base_reg_seq27");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq27)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer27)

// Use a base sequence to raise/drop27 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running27 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq27

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq27: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq27 extends base_reg_seq27;

   // Pointer27 to the register model
   uart_ctrl_reg_model_c27 reg_model27;
   uvm_object rm_object27;

   `uvm_object_utils(uart_ctrl_config_reg_seq27)

   function new(string name="uart_ctrl_config_reg_seq27");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model27", rm_object27))
      $cast(reg_model27, rm_object27);
      `uvm_info(get_type_name(),
        "UART27 Controller27 Register configuration sequence starting...",
        UVM_LOW)
      // Line27 Control27 Register, set Divisor27 Latch27 Access = 1
      reg_model27.uart_ctrl_rf27.ua_lcr27.write(status, 'h8f);
      // Divisor27 Latch27 Byte27 1 = 1
      reg_model27.uart_ctrl_rf27.ua_div_latch027.write(status, 'h01);
      // Divisor27 Latch27 Byte27 2 = 0
      reg_model27.uart_ctrl_rf27.ua_div_latch127.write(status, 'h00);
      // Line27 Control27 Register, set Divisor27 Latch27 Access = 0
      reg_model27.uart_ctrl_rf27.ua_lcr27.write(status, 'h0f);
      //ToDo27: FIX27: DISABLE27 CHECKS27 AFTER CONFIG27 IS27 DONE
      reg_model27.uart_ctrl_rf27.ua_div_latch027.div_val27.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART27 Controller27 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq27

class uart_ctrl_1stopbit_reg_seq27 extends base_reg_seq27;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq27)

   function new(string name="uart_ctrl_1stopbit_reg_seq27");
      super.new(name);
   endfunction // new
 
   // Pointer27 to the register model
   uart_ctrl_rf_c27 reg_model27;
//   uart_ctrl_reg_model_c27 reg_model27;

   //ua_lcr_c27 ulcr27;
   //ua_div_latch0_c27 div_lsb27;
   //ua_div_latch1_c27 div_msb27;

   virtual task body();
     uvm_status_e status;
     reg_model27 = p_sequencer.reg_model27.uart_ctrl_rf27;
     `uvm_info(get_type_name(),
        "UART27 config register sequence with num_stop_bits27 == STOP127 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with27(ulcr27, "ua_lcr27", {value.num_stop_bits27 == 1'b0;})
      #50;
      //`rgm_write_by_name27(div_msb27, "ua_div_latch127")
      #50;
      //`rgm_write_by_name27(div_lsb27, "ua_div_latch027")
      #50;
      //ulcr27.value.div_latch_access27 = 1'b0;
      //`rgm_write_send27(ulcr27)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq27

class uart_cfg_rxtx_fifo_cov_reg_seq27 extends uart_ctrl_config_reg_seq27;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq27)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq27");
      super.new(name);
   endfunction : new
 
//   ua_ier_c27 uier27;
//   ua_idr_c27 uidr27;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx27/rx27 full/empty27 interrupts27...", UVM_LOW)
//     `rgm_write_by_name_with27(uier27, {uart_rf27, ".ua_ier27"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with27(uidr27, {uart_rf27, ".ua_idr27"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq27
