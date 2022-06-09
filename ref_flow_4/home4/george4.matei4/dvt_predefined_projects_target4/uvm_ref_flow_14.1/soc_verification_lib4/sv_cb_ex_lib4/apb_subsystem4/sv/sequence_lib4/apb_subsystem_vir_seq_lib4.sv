/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_vir_seq_lib4.sv
Title4       : Virtual Sequence
Project4     :
Created4     :
Description4 : This4 file implements4 the virtual sequence for the APB4-UART4 env4.
Notes4       : The concurrent_u2a_a2u_rand_trans4 sequence first configures4
            : the UART4 RTL4. Once4 the configuration sequence is completed
            : random read/write sequences from both the UVCs4 are enabled
            : in parallel4. At4 the end a Rx4 FIFO read sequence is executed4.
            : The intrpt_seq4 needs4 to be modified to take4 interrupt4 into account4.
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV4
`define APB_UART_VIRTUAL_SEQ_LIB_SV4

class u2a_incr_payload4 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr4;
  rand int unsigned num_a2u0_wr4;
  rand int unsigned num_u12a_wr4;
  rand int unsigned num_a2u1_wr4;

  function new(string name="u2a_incr_payload4",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)    

  constraint num_u02a_wr_ct4 {(num_u02a_wr4 > 2) && (num_u02a_wr4 <= 4);}
  constraint num_a2u0_wr_ct4 {(num_a2u0_wr4 == 1);}
  constraint num_u12a_wr_ct4 {(num_u12a_wr4 > 2) && (num_u12a_wr4 <= 4);}
  constraint num_a2u1_wr_ct4 {(num_a2u1_wr4 == 1);}

  // APB4 and UART4 UVC4 sequences
  uart_ctrl_config_reg_seq4 uart_cfg_dut_seq4;
  uart_incr_payload_seq4 uart_seq4;
  intrpt_seq4 rd_rx_fifo4;
  ahb_to_uart_wr4 raw_seq4;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq4", $psprintf("Number4 of APB4->UART04 Transaction4 = %d", num_a2u0_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Number4 of APB4->UART14 Transaction4 = %d", num_a2u1_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Number4 of UART04->APB4 Transaction4 = %d", num_u02a_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Number4 of UART14->APB4 Transaction4 = %d", num_u12a_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Total4 Number4 of AHB4, UART4 Transaction4 = %d", num_u02a_wr4 + num_a2u0_wr4 + num_u02a_wr4 + num_a2u0_wr4), UVM_LOW)

    // configure UART04 DUT
    uart_cfg_dut_seq4 = uart_ctrl_config_reg_seq4::type_id::create("uart_cfg_dut_seq4");
    uart_cfg_dut_seq4.reg_model4 = p_sequencer.reg_model_ptr4.uart0_rm4;
    uart_cfg_dut_seq4.start(null);


    // configure UART14 DUT
    uart_cfg_dut_seq4 = uart_ctrl_config_reg_seq4::type_id::create("uart_cfg_dut_seq4");
    uart_cfg_dut_seq4.reg_model4 = p_sequencer.reg_model_ptr4.uart1_rm4;
    uart_cfg_dut_seq4.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == num_a2u0_wr4; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == num_a2u1_wr4; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq4, p_sequencer.uart0_seqr4, {cnt == num_u02a_wr4;})
      `uvm_do_on_with(uart_seq4, p_sequencer.uart1_seqr4, {cnt == num_u12a_wr4;})
    join
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u02a_wr4; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u12a_wr4; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload4

// rand shutdown4 and power4-on
class on_off_seq4 extends uvm_sequence;
  `uvm_object_utils(on_off_seq4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)

  function new(string name = "on_off_seq4");
     super.new(name);
  endfunction

  shutdown_dut4 shut_dut4;
  poweron_dut4 power_dut4;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut4, p_sequencer.ahb_seqr4)
       #4000;
      `uvm_do_on(power_dut4, p_sequencer.ahb_seqr4)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq4


// shutdown4 and power4-on for uart14
class on_off_uart1_seq4 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)

  function new(string name = "on_off_uart1_seq4");
     super.new(name);
  endfunction

  shutdown_dut4 shut_dut4;
  poweron_dut4 power_dut4;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut4, p_sequencer.ahb_seqr4, {write_data4 == 1;})
        #4000;
      `uvm_do_on(power_dut4, p_sequencer.ahb_seqr4)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq4

// lp4 seq, configuration sequence
class lp_shutdown_config4 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr4;
  rand int unsigned num_a2u0_wr4;
  rand int unsigned num_u12a_wr4;
  rand int unsigned num_a2u1_wr4;

  function new(string name="lp_shutdown_config4",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)    

  constraint num_u02a_wr_ct4 {(num_u02a_wr4 > 2) && (num_u02a_wr4 <= 4);}
  constraint num_a2u0_wr_ct4 {(num_a2u0_wr4 == 1);}
  constraint num_u12a_wr_ct4 {(num_u12a_wr4 > 2) && (num_u12a_wr4 <= 4);}
  constraint num_a2u1_wr_ct4 {(num_a2u1_wr4 == 1);}

  // APB4 and UART4 UVC4 sequences
  uart_ctrl_config_reg_seq4 uart_cfg_dut_seq4;
  uart_incr_payload_seq4 uart_seq4;
  intrpt_seq4 rd_rx_fifo4;
  ahb_to_uart_wr4 raw_seq4;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq4", $psprintf("Number4 of APB4->UART04 Transaction4 = %d", num_a2u0_wr4), UVM_LOW);
    `uvm_info("vseq4", $psprintf("Number4 of APB4->UART14 Transaction4 = %d", num_a2u1_wr4), UVM_LOW);
    `uvm_info("vseq4", $psprintf("Number4 of UART04->APB4 Transaction4 = %d", num_u02a_wr4), UVM_LOW);
    `uvm_info("vseq4", $psprintf("Number4 of UART14->APB4 Transaction4 = %d", num_u12a_wr4), UVM_LOW);
    `uvm_info("vseq4", $psprintf("Total4 Number4 of AHB4, UART4 Transaction4 = %d", num_u02a_wr4 + num_a2u0_wr4 + num_u02a_wr4 + num_a2u0_wr4), UVM_LOW);

    // configure UART04 DUT
    uart_cfg_dut_seq4 = uart_ctrl_config_reg_seq4::type_id::create("uart_cfg_dut_seq4");
    uart_cfg_dut_seq4.reg_model4 = p_sequencer.reg_model_ptr4.uart0_rm4;
    uart_cfg_dut_seq4.start(null);


    // configure UART14 DUT
    uart_cfg_dut_seq4 = uart_ctrl_config_reg_seq4::type_id::create("uart_cfg_dut_seq4");
    uart_cfg_dut_seq4.reg_model4 = p_sequencer.reg_model_ptr4.uart1_rm4;
    uart_cfg_dut_seq4.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == num_a2u0_wr4; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == num_a2u1_wr4; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq4, p_sequencer.uart0_seqr4, {cnt == num_u02a_wr4;})
      `uvm_do_on_with(uart_seq4, p_sequencer.uart1_seqr4, {cnt == num_u12a_wr4;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u02a_wr4; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u12a_wr4; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == num_a2u0_wr4; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq4, p_sequencer.uart0_seqr4, {cnt == num_u02a_wr4;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config4

// rand lp4 shutdown4 seq between uart4 1 and smc4
class lp_shutdown_rand4 extends uvm_sequence;

  rand int unsigned num_u02a_wr4;
  rand int unsigned num_a2u0_wr4;
  rand int unsigned num_u12a_wr4;
  rand int unsigned num_a2u1_wr4;

  function new(string name="lp_shutdown_rand4",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)    

  constraint num_u02a_wr_ct4 {(num_u02a_wr4 > 2) && (num_u02a_wr4 <= 4);}
  constraint num_a2u0_wr_ct4 {(num_a2u0_wr4 == 1);}
  constraint num_u12a_wr_ct4 {(num_u12a_wr4 > 2) && (num_u12a_wr4 <= 4);}
  constraint num_a2u1_wr_ct4 {(num_a2u1_wr4 == 1);}


  on_off_seq4 on_off_seq4;
  uart_incr_payload_seq4 uart_seq4;
  intrpt_seq4 rd_rx_fifo4;
  ahb_to_uart_wr4 raw_seq4;
  lp_shutdown_config4 lp_shutdown_config4;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut4 down seq
    `uvm_do(lp_shutdown_config4);
    #20000;
    `uvm_do(on_off_seq4);

    #10000;
    fork
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == num_a2u1_wr4; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq4, p_sequencer.uart1_seqr4, {cnt == num_u12a_wr4;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u02a_wr4; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u12a_wr4; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand4


// sequence for shutting4 down uart4 1 alone4
class lp_shutdown_uart14 extends uvm_sequence;

  rand int unsigned num_u02a_wr4;
  rand int unsigned num_a2u0_wr4;
  rand int unsigned num_u12a_wr4;
  rand int unsigned num_a2u1_wr4;

  function new(string name="lp_shutdown_uart14",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart14)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)    

  constraint num_u02a_wr_ct4 {(num_u02a_wr4 > 2) && (num_u02a_wr4 <= 4);}
  constraint num_a2u0_wr_ct4 {(num_a2u0_wr4 == 1);}
  constraint num_u12a_wr_ct4 {(num_u12a_wr4 > 2) && (num_u12a_wr4 <= 4);}
  constraint num_a2u1_wr_ct4 {(num_a2u1_wr4 == 2);}


  on_off_uart1_seq4 on_off_uart1_seq4;
  uart_incr_payload_seq4 uart_seq4;
  intrpt_seq4 rd_rx_fifo4;
  ahb_to_uart_wr4 raw_seq4;
  lp_shutdown_config4 lp_shutdown_config4;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut4 down seq
    `uvm_do(lp_shutdown_config4);
    #20000;
    `uvm_do(on_off_uart1_seq4);

    #10000;
    fork
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == num_a2u1_wr4; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq4, p_sequencer.uart1_seqr4, {cnt == num_u12a_wr4;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u02a_wr4; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo4, p_sequencer.ahb_seqr4, {num_of_rd4 == num_u12a_wr4; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart14



class apb_spi_incr_payload4 extends uvm_sequence;

  rand int unsigned num_spi2a_wr4;
  rand int unsigned num_a2spi_wr4;

  function new(string name="apb_spi_incr_payload4",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)    

  constraint num_spi2a_wr_ct4 {(num_spi2a_wr4 > 2) && (num_spi2a_wr4 <= 4);}
  constraint num_a2spi_wr_ct4 {(num_a2spi_wr4 == 4);}

  // APB4 and UART4 UVC4 sequences
  spi_cfg_reg_seq4 spi_cfg_dut_seq4;
  spi_incr_payload4 spi_seq4;
  read_spi_rx_reg4 rd_rx_reg4;
  ahb_to_spi_wr4 raw_seq4;
  spi_en_tx_reg_seq4 en_spi_tx_seq4;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq4", $psprintf("Number4 of APB4->SPI4 Transaction4 = %d", num_a2spi_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Number4 of SPI4->APB4 Transaction4 = %d", num_a2spi_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Total4 Number4 of AHB4, SPI4 Transaction4 = %d", 2 * num_a2spi_wr4), UVM_LOW)

    // configure SPI4 DUT
    spi_cfg_dut_seq4 = spi_cfg_reg_seq4::type_id::create("spi_cfg_dut_seq4");
    spi_cfg_dut_seq4.reg_model4 = p_sequencer.reg_model_ptr4.spi_rf4;
    spi_cfg_dut_seq4.start(null);


    for (int i = 0; i < num_a2spi_wr4; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {num_of_wr4 == 1; base_addr == 'h800000;})
            en_spi_tx_seq4 = spi_en_tx_reg_seq4::type_id::create("en_spi_tx_seq4");
            en_spi_tx_seq4.reg_model4 = p_sequencer.reg_model_ptr4.spi_rf4;
            en_spi_tx_seq4.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq4, p_sequencer.spi0_seqr4, {cnt_i4 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg4, p_sequencer.ahb_seqr4, {num_of_rd4 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload4

class apb_gpio_simple_vseq4 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr4;

  function new(string name="apb_gpio_simple_vseq4",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)    

  constraint num_a2gpio_wr_ct4 {(num_a2gpio_wr4 == 4);}

  // APB4 and UART4 UVC4 sequences
  gpio_cfg_reg_seq4 gpio_cfg_dut_seq4;
  gpio_simple_trans_seq4 gpio_seq4;
  read_gpio_rx_reg4 rd_rx_reg4;
  ahb_to_gpio_wr4 raw_seq4;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq4", $psprintf("Number4 of AHB4->GPIO4 Transaction4 = %d", num_a2gpio_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Number4 of GPIO4->APB4 Transaction4 = %d", num_a2gpio_wr4), UVM_LOW)
    `uvm_info("vseq4", $psprintf("Total4 Number4 of AHB4, GPIO4 Transaction4 = %d", 2 * num_a2gpio_wr4), UVM_LOW)

    // configure SPI4 DUT
    gpio_cfg_dut_seq4 = gpio_cfg_reg_seq4::type_id::create("gpio_cfg_dut_seq4");
    gpio_cfg_dut_seq4.reg_model4 = p_sequencer.reg_model_ptr4.gpio_rf4;
    gpio_cfg_dut_seq4.start(null);


    for (int i = 0; i < num_a2gpio_wr4; i++) begin
      `uvm_do_on_with(raw_seq4, p_sequencer.ahb_seqr4, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq4, p_sequencer.gpio0_seqr4)
      `uvm_do_on_with(rd_rx_reg4, p_sequencer.ahb_seqr4, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq4

class apb_subsystem_vseq4 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq4",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq4)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)    

  // APB4 and UART4 UVC4 sequences
  u2a_incr_payload4 apb_to_uart4;
  apb_spi_incr_payload4 apb_to_spi4;
  apb_gpio_simple_vseq4 apb_to_gpio4;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq4", $psprintf("Doing apb_subsystem_vseq4"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart4)
      `uvm_do(apb_to_spi4)
      `uvm_do(apb_to_gpio4)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq4

class apb_ss_cms_seq4 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq4)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer4)

   function new(string name = "apb_ss_cms_seq4");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq4", $psprintf("Starting AHB4 Compliance4 Management4 System4 (CMS4)"), UVM_LOW)
//	   p_sequencer.ahb_seqr4.start_ahb_cms4();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq4
`endif
