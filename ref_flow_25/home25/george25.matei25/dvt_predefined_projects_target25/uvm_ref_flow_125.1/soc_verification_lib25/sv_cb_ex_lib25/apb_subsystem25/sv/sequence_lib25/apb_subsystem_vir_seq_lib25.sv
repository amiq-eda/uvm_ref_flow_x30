/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_vir_seq_lib25.sv
Title25       : Virtual Sequence
Project25     :
Created25     :
Description25 : This25 file implements25 the virtual sequence for the APB25-UART25 env25.
Notes25       : The concurrent_u2a_a2u_rand_trans25 sequence first configures25
            : the UART25 RTL25. Once25 the configuration sequence is completed
            : random read/write sequences from both the UVCs25 are enabled
            : in parallel25. At25 the end a Rx25 FIFO read sequence is executed25.
            : The intrpt_seq25 needs25 to be modified to take25 interrupt25 into account25.
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV25
`define APB_UART_VIRTUAL_SEQ_LIB_SV25

class u2a_incr_payload25 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr25;
  rand int unsigned num_a2u0_wr25;
  rand int unsigned num_u12a_wr25;
  rand int unsigned num_a2u1_wr25;

  function new(string name="u2a_incr_payload25",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)    

  constraint num_u02a_wr_ct25 {(num_u02a_wr25 > 2) && (num_u02a_wr25 <= 4);}
  constraint num_a2u0_wr_ct25 {(num_a2u0_wr25 == 1);}
  constraint num_u12a_wr_ct25 {(num_u12a_wr25 > 2) && (num_u12a_wr25 <= 4);}
  constraint num_a2u1_wr_ct25 {(num_a2u1_wr25 == 1);}

  // APB25 and UART25 UVC25 sequences
  uart_ctrl_config_reg_seq25 uart_cfg_dut_seq25;
  uart_incr_payload_seq25 uart_seq25;
  intrpt_seq25 rd_rx_fifo25;
  ahb_to_uart_wr25 raw_seq25;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq25", $psprintf("Number25 of APB25->UART025 Transaction25 = %d", num_a2u0_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Number25 of APB25->UART125 Transaction25 = %d", num_a2u1_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Number25 of UART025->APB25 Transaction25 = %d", num_u02a_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Number25 of UART125->APB25 Transaction25 = %d", num_u12a_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Total25 Number25 of AHB25, UART25 Transaction25 = %d", num_u02a_wr25 + num_a2u0_wr25 + num_u02a_wr25 + num_a2u0_wr25), UVM_LOW)

    // configure UART025 DUT
    uart_cfg_dut_seq25 = uart_ctrl_config_reg_seq25::type_id::create("uart_cfg_dut_seq25");
    uart_cfg_dut_seq25.reg_model25 = p_sequencer.reg_model_ptr25.uart0_rm25;
    uart_cfg_dut_seq25.start(null);


    // configure UART125 DUT
    uart_cfg_dut_seq25 = uart_ctrl_config_reg_seq25::type_id::create("uart_cfg_dut_seq25");
    uart_cfg_dut_seq25.reg_model25 = p_sequencer.reg_model_ptr25.uart1_rm25;
    uart_cfg_dut_seq25.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == num_a2u0_wr25; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == num_a2u1_wr25; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq25, p_sequencer.uart0_seqr25, {cnt == num_u02a_wr25;})
      `uvm_do_on_with(uart_seq25, p_sequencer.uart1_seqr25, {cnt == num_u12a_wr25;})
    join
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u02a_wr25; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u12a_wr25; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload25

// rand shutdown25 and power25-on
class on_off_seq25 extends uvm_sequence;
  `uvm_object_utils(on_off_seq25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)

  function new(string name = "on_off_seq25");
     super.new(name);
  endfunction

  shutdown_dut25 shut_dut25;
  poweron_dut25 power_dut25;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut25, p_sequencer.ahb_seqr25)
       #4000;
      `uvm_do_on(power_dut25, p_sequencer.ahb_seqr25)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq25


// shutdown25 and power25-on for uart125
class on_off_uart1_seq25 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)

  function new(string name = "on_off_uart1_seq25");
     super.new(name);
  endfunction

  shutdown_dut25 shut_dut25;
  poweron_dut25 power_dut25;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut25, p_sequencer.ahb_seqr25, {write_data25 == 1;})
        #4000;
      `uvm_do_on(power_dut25, p_sequencer.ahb_seqr25)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq25

// lp25 seq, configuration sequence
class lp_shutdown_config25 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr25;
  rand int unsigned num_a2u0_wr25;
  rand int unsigned num_u12a_wr25;
  rand int unsigned num_a2u1_wr25;

  function new(string name="lp_shutdown_config25",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)    

  constraint num_u02a_wr_ct25 {(num_u02a_wr25 > 2) && (num_u02a_wr25 <= 4);}
  constraint num_a2u0_wr_ct25 {(num_a2u0_wr25 == 1);}
  constraint num_u12a_wr_ct25 {(num_u12a_wr25 > 2) && (num_u12a_wr25 <= 4);}
  constraint num_a2u1_wr_ct25 {(num_a2u1_wr25 == 1);}

  // APB25 and UART25 UVC25 sequences
  uart_ctrl_config_reg_seq25 uart_cfg_dut_seq25;
  uart_incr_payload_seq25 uart_seq25;
  intrpt_seq25 rd_rx_fifo25;
  ahb_to_uart_wr25 raw_seq25;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq25", $psprintf("Number25 of APB25->UART025 Transaction25 = %d", num_a2u0_wr25), UVM_LOW);
    `uvm_info("vseq25", $psprintf("Number25 of APB25->UART125 Transaction25 = %d", num_a2u1_wr25), UVM_LOW);
    `uvm_info("vseq25", $psprintf("Number25 of UART025->APB25 Transaction25 = %d", num_u02a_wr25), UVM_LOW);
    `uvm_info("vseq25", $psprintf("Number25 of UART125->APB25 Transaction25 = %d", num_u12a_wr25), UVM_LOW);
    `uvm_info("vseq25", $psprintf("Total25 Number25 of AHB25, UART25 Transaction25 = %d", num_u02a_wr25 + num_a2u0_wr25 + num_u02a_wr25 + num_a2u0_wr25), UVM_LOW);

    // configure UART025 DUT
    uart_cfg_dut_seq25 = uart_ctrl_config_reg_seq25::type_id::create("uart_cfg_dut_seq25");
    uart_cfg_dut_seq25.reg_model25 = p_sequencer.reg_model_ptr25.uart0_rm25;
    uart_cfg_dut_seq25.start(null);


    // configure UART125 DUT
    uart_cfg_dut_seq25 = uart_ctrl_config_reg_seq25::type_id::create("uart_cfg_dut_seq25");
    uart_cfg_dut_seq25.reg_model25 = p_sequencer.reg_model_ptr25.uart1_rm25;
    uart_cfg_dut_seq25.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == num_a2u0_wr25; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == num_a2u1_wr25; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq25, p_sequencer.uart0_seqr25, {cnt == num_u02a_wr25;})
      `uvm_do_on_with(uart_seq25, p_sequencer.uart1_seqr25, {cnt == num_u12a_wr25;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u02a_wr25; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u12a_wr25; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == num_a2u0_wr25; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq25, p_sequencer.uart0_seqr25, {cnt == num_u02a_wr25;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config25

// rand lp25 shutdown25 seq between uart25 1 and smc25
class lp_shutdown_rand25 extends uvm_sequence;

  rand int unsigned num_u02a_wr25;
  rand int unsigned num_a2u0_wr25;
  rand int unsigned num_u12a_wr25;
  rand int unsigned num_a2u1_wr25;

  function new(string name="lp_shutdown_rand25",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)    

  constraint num_u02a_wr_ct25 {(num_u02a_wr25 > 2) && (num_u02a_wr25 <= 4);}
  constraint num_a2u0_wr_ct25 {(num_a2u0_wr25 == 1);}
  constraint num_u12a_wr_ct25 {(num_u12a_wr25 > 2) && (num_u12a_wr25 <= 4);}
  constraint num_a2u1_wr_ct25 {(num_a2u1_wr25 == 1);}


  on_off_seq25 on_off_seq25;
  uart_incr_payload_seq25 uart_seq25;
  intrpt_seq25 rd_rx_fifo25;
  ahb_to_uart_wr25 raw_seq25;
  lp_shutdown_config25 lp_shutdown_config25;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut25 down seq
    `uvm_do(lp_shutdown_config25);
    #20000;
    `uvm_do(on_off_seq25);

    #10000;
    fork
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == num_a2u1_wr25; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq25, p_sequencer.uart1_seqr25, {cnt == num_u12a_wr25;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u02a_wr25; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u12a_wr25; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand25


// sequence for shutting25 down uart25 1 alone25
class lp_shutdown_uart125 extends uvm_sequence;

  rand int unsigned num_u02a_wr25;
  rand int unsigned num_a2u0_wr25;
  rand int unsigned num_u12a_wr25;
  rand int unsigned num_a2u1_wr25;

  function new(string name="lp_shutdown_uart125",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart125)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)    

  constraint num_u02a_wr_ct25 {(num_u02a_wr25 > 2) && (num_u02a_wr25 <= 4);}
  constraint num_a2u0_wr_ct25 {(num_a2u0_wr25 == 1);}
  constraint num_u12a_wr_ct25 {(num_u12a_wr25 > 2) && (num_u12a_wr25 <= 4);}
  constraint num_a2u1_wr_ct25 {(num_a2u1_wr25 == 2);}


  on_off_uart1_seq25 on_off_uart1_seq25;
  uart_incr_payload_seq25 uart_seq25;
  intrpt_seq25 rd_rx_fifo25;
  ahb_to_uart_wr25 raw_seq25;
  lp_shutdown_config25 lp_shutdown_config25;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut25 down seq
    `uvm_do(lp_shutdown_config25);
    #20000;
    `uvm_do(on_off_uart1_seq25);

    #10000;
    fork
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == num_a2u1_wr25; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq25, p_sequencer.uart1_seqr25, {cnt == num_u12a_wr25;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u02a_wr25; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo25, p_sequencer.ahb_seqr25, {num_of_rd25 == num_u12a_wr25; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart125



class apb_spi_incr_payload25 extends uvm_sequence;

  rand int unsigned num_spi2a_wr25;
  rand int unsigned num_a2spi_wr25;

  function new(string name="apb_spi_incr_payload25",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)    

  constraint num_spi2a_wr_ct25 {(num_spi2a_wr25 > 2) && (num_spi2a_wr25 <= 4);}
  constraint num_a2spi_wr_ct25 {(num_a2spi_wr25 == 4);}

  // APB25 and UART25 UVC25 sequences
  spi_cfg_reg_seq25 spi_cfg_dut_seq25;
  spi_incr_payload25 spi_seq25;
  read_spi_rx_reg25 rd_rx_reg25;
  ahb_to_spi_wr25 raw_seq25;
  spi_en_tx_reg_seq25 en_spi_tx_seq25;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq25", $psprintf("Number25 of APB25->SPI25 Transaction25 = %d", num_a2spi_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Number25 of SPI25->APB25 Transaction25 = %d", num_a2spi_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Total25 Number25 of AHB25, SPI25 Transaction25 = %d", 2 * num_a2spi_wr25), UVM_LOW)

    // configure SPI25 DUT
    spi_cfg_dut_seq25 = spi_cfg_reg_seq25::type_id::create("spi_cfg_dut_seq25");
    spi_cfg_dut_seq25.reg_model25 = p_sequencer.reg_model_ptr25.spi_rf25;
    spi_cfg_dut_seq25.start(null);


    for (int i = 0; i < num_a2spi_wr25; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {num_of_wr25 == 1; base_addr == 'h800000;})
            en_spi_tx_seq25 = spi_en_tx_reg_seq25::type_id::create("en_spi_tx_seq25");
            en_spi_tx_seq25.reg_model25 = p_sequencer.reg_model_ptr25.spi_rf25;
            en_spi_tx_seq25.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq25, p_sequencer.spi0_seqr25, {cnt_i25 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg25, p_sequencer.ahb_seqr25, {num_of_rd25 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload25

class apb_gpio_simple_vseq25 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr25;

  function new(string name="apb_gpio_simple_vseq25",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)    

  constraint num_a2gpio_wr_ct25 {(num_a2gpio_wr25 == 4);}

  // APB25 and UART25 UVC25 sequences
  gpio_cfg_reg_seq25 gpio_cfg_dut_seq25;
  gpio_simple_trans_seq25 gpio_seq25;
  read_gpio_rx_reg25 rd_rx_reg25;
  ahb_to_gpio_wr25 raw_seq25;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq25", $psprintf("Number25 of AHB25->GPIO25 Transaction25 = %d", num_a2gpio_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Number25 of GPIO25->APB25 Transaction25 = %d", num_a2gpio_wr25), UVM_LOW)
    `uvm_info("vseq25", $psprintf("Total25 Number25 of AHB25, GPIO25 Transaction25 = %d", 2 * num_a2gpio_wr25), UVM_LOW)

    // configure SPI25 DUT
    gpio_cfg_dut_seq25 = gpio_cfg_reg_seq25::type_id::create("gpio_cfg_dut_seq25");
    gpio_cfg_dut_seq25.reg_model25 = p_sequencer.reg_model_ptr25.gpio_rf25;
    gpio_cfg_dut_seq25.start(null);


    for (int i = 0; i < num_a2gpio_wr25; i++) begin
      `uvm_do_on_with(raw_seq25, p_sequencer.ahb_seqr25, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq25, p_sequencer.gpio0_seqr25)
      `uvm_do_on_with(rd_rx_reg25, p_sequencer.ahb_seqr25, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq25

class apb_subsystem_vseq25 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq25",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq25)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)    

  // APB25 and UART25 UVC25 sequences
  u2a_incr_payload25 apb_to_uart25;
  apb_spi_incr_payload25 apb_to_spi25;
  apb_gpio_simple_vseq25 apb_to_gpio25;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq25", $psprintf("Doing apb_subsystem_vseq25"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart25)
      `uvm_do(apb_to_spi25)
      `uvm_do(apb_to_gpio25)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq25

class apb_ss_cms_seq25 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq25)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer25)

   function new(string name = "apb_ss_cms_seq25");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq25", $psprintf("Starting AHB25 Compliance25 Management25 System25 (CMS25)"), UVM_LOW)
//	   p_sequencer.ahb_seqr25.start_ahb_cms25();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq25
`endif
