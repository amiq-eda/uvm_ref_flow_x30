/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_reg_seq_lib23.sv
Title23       : UVM_REG Sequence Library23
Project23     :
Created23     :
Description23 : Register Sequence Library23 for the UART23 Controller23 DUT
Notes23       :
----------------------------------------------------------------------
Copyright23 2007 (c) Cadence23 Design23 Systems23, Inc23. All Rights23 Reserved23.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq23: Direct23 APB23 transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq23 extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq23)

   apb_pkg23::write_byte_seq23 write_seq23;
   rand bit [7:0] temp_data23;
   constraint c123 {temp_data23[7] == 1'b1; }

   function new(string name="apb_config_reg_seq23");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART23 Controller23 Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line23 Control23 Register: bit 7, Divisor23 Latch23 Access = 1
      `uvm_do_with(write_seq23, { start_addr23 == 3; write_data23 == temp_data23; } )
      // Address 0: Divisor23 Latch23 Byte23 1 = 1
      `uvm_do_with(write_seq23, { start_addr23 == 0; write_data23 == 'h01; } )
      // Address 1: Divisor23 Latch23 Byte23 2 = 0
      `uvm_do_with(write_seq23, { start_addr23 == 1; write_data23 == 'h00; } )
      // Address 3: Line23 Control23 Register: bit 7, Divisor23 Latch23 Access = 0
      temp_data23[7] = 1'b0;
      `uvm_do_with(write_seq23, { start_addr23 == 3; write_data23 == temp_data23; } )
      `uvm_info(get_type_name(),
        "UART23 Controller23 Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq23

//--------------------------------------------------------------------
// Base23 Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq23 extends uvm_sequence;
  function new(string name="base_reg_seq23");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq23)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer23)

// Use a base sequence to raise/drop23 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running23 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq23

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq23: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq23 extends base_reg_seq23;

   // Pointer23 to the register model
   uart_ctrl_reg_model_c23 reg_model23;
   uvm_object rm_object23;

   `uvm_object_utils(uart_ctrl_config_reg_seq23)

   function new(string name="uart_ctrl_config_reg_seq23");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model23", rm_object23))
      $cast(reg_model23, rm_object23);
      `uvm_info(get_type_name(),
        "UART23 Controller23 Register configuration sequence starting...",
        UVM_LOW)
      // Line23 Control23 Register, set Divisor23 Latch23 Access = 1
      reg_model23.uart_ctrl_rf23.ua_lcr23.write(status, 'h8f);
      // Divisor23 Latch23 Byte23 1 = 1
      reg_model23.uart_ctrl_rf23.ua_div_latch023.write(status, 'h01);
      // Divisor23 Latch23 Byte23 2 = 0
      reg_model23.uart_ctrl_rf23.ua_div_latch123.write(status, 'h00);
      // Line23 Control23 Register, set Divisor23 Latch23 Access = 0
      reg_model23.uart_ctrl_rf23.ua_lcr23.write(status, 'h0f);
      //ToDo23: FIX23: DISABLE23 CHECKS23 AFTER CONFIG23 IS23 DONE
      reg_model23.uart_ctrl_rf23.ua_div_latch023.div_val23.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART23 Controller23 Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq23

class uart_ctrl_1stopbit_reg_seq23 extends base_reg_seq23;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq23)

   function new(string name="uart_ctrl_1stopbit_reg_seq23");
      super.new(name);
   endfunction // new
 
   // Pointer23 to the register model
   uart_ctrl_rf_c23 reg_model23;
//   uart_ctrl_reg_model_c23 reg_model23;

   //ua_lcr_c23 ulcr23;
   //ua_div_latch0_c23 div_lsb23;
   //ua_div_latch1_c23 div_msb23;

   virtual task body();
     uvm_status_e status;
     reg_model23 = p_sequencer.reg_model23.uart_ctrl_rf23;
     `uvm_info(get_type_name(),
        "UART23 config register sequence with num_stop_bits23 == STOP123 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with23(ulcr23, "ua_lcr23", {value.num_stop_bits23 == 1'b0;})
      #50;
      //`rgm_write_by_name23(div_msb23, "ua_div_latch123")
      #50;
      //`rgm_write_by_name23(div_lsb23, "ua_div_latch023")
      #50;
      //ulcr23.value.div_latch_access23 = 1'b0;
      //`rgm_write_send23(ulcr23)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq23

class uart_cfg_rxtx_fifo_cov_reg_seq23 extends uart_ctrl_config_reg_seq23;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq23)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq23");
      super.new(name);
   endfunction : new
 
//   ua_ier_c23 uier23;
//   ua_idr_c23 uidr23;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx23/rx23 full/empty23 interrupts23...", UVM_LOW)
//     `rgm_write_by_name_with23(uier23, {uart_rf23, ".ua_ier23"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with23(uidr23, {uart_rf23, ".ua_idr23"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq23
