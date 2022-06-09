/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_vir_seq_lib20.sv
Title20       : Virtual Sequence
Project20     :
Created20     :
Description20 : This20 file implements20 the virtual sequence for the APB20-UART20 env20.
Notes20       : The concurrent_u2a_a2u_rand_trans20 sequence first configures20
            : the UART20 RTL20. Once20 the configuration sequence is completed
            : random read/write sequences from both the UVCs20 are enabled
            : in parallel20. At20 the end a Rx20 FIFO read sequence is executed20.
            : The intrpt_seq20 needs20 to be modified to take20 interrupt20 into account20.
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV20
`define APB_UART_VIRTUAL_SEQ_LIB_SV20

class u2a_incr_payload20 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr20;
  rand int unsigned num_a2u0_wr20;
  rand int unsigned num_u12a_wr20;
  rand int unsigned num_a2u1_wr20;

  function new(string name="u2a_incr_payload20",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)    

  constraint num_u02a_wr_ct20 {(num_u02a_wr20 > 2) && (num_u02a_wr20 <= 4);}
  constraint num_a2u0_wr_ct20 {(num_a2u0_wr20 == 1);}
  constraint num_u12a_wr_ct20 {(num_u12a_wr20 > 2) && (num_u12a_wr20 <= 4);}
  constraint num_a2u1_wr_ct20 {(num_a2u1_wr20 == 1);}

  // APB20 and UART20 UVC20 sequences
  uart_ctrl_config_reg_seq20 uart_cfg_dut_seq20;
  uart_incr_payload_seq20 uart_seq20;
  intrpt_seq20 rd_rx_fifo20;
  ahb_to_uart_wr20 raw_seq20;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq20", $psprintf("Number20 of APB20->UART020 Transaction20 = %d", num_a2u0_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Number20 of APB20->UART120 Transaction20 = %d", num_a2u1_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Number20 of UART020->APB20 Transaction20 = %d", num_u02a_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Number20 of UART120->APB20 Transaction20 = %d", num_u12a_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Total20 Number20 of AHB20, UART20 Transaction20 = %d", num_u02a_wr20 + num_a2u0_wr20 + num_u02a_wr20 + num_a2u0_wr20), UVM_LOW)

    // configure UART020 DUT
    uart_cfg_dut_seq20 = uart_ctrl_config_reg_seq20::type_id::create("uart_cfg_dut_seq20");
    uart_cfg_dut_seq20.reg_model20 = p_sequencer.reg_model_ptr20.uart0_rm20;
    uart_cfg_dut_seq20.start(null);


    // configure UART120 DUT
    uart_cfg_dut_seq20 = uart_ctrl_config_reg_seq20::type_id::create("uart_cfg_dut_seq20");
    uart_cfg_dut_seq20.reg_model20 = p_sequencer.reg_model_ptr20.uart1_rm20;
    uart_cfg_dut_seq20.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == num_a2u0_wr20; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == num_a2u1_wr20; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq20, p_sequencer.uart0_seqr20, {cnt == num_u02a_wr20;})
      `uvm_do_on_with(uart_seq20, p_sequencer.uart1_seqr20, {cnt == num_u12a_wr20;})
    join
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u02a_wr20; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u12a_wr20; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload20

// rand shutdown20 and power20-on
class on_off_seq20 extends uvm_sequence;
  `uvm_object_utils(on_off_seq20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)

  function new(string name = "on_off_seq20");
     super.new(name);
  endfunction

  shutdown_dut20 shut_dut20;
  poweron_dut20 power_dut20;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut20, p_sequencer.ahb_seqr20)
       #4000;
      `uvm_do_on(power_dut20, p_sequencer.ahb_seqr20)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq20


// shutdown20 and power20-on for uart120
class on_off_uart1_seq20 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)

  function new(string name = "on_off_uart1_seq20");
     super.new(name);
  endfunction

  shutdown_dut20 shut_dut20;
  poweron_dut20 power_dut20;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut20, p_sequencer.ahb_seqr20, {write_data20 == 1;})
        #4000;
      `uvm_do_on(power_dut20, p_sequencer.ahb_seqr20)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq20

// lp20 seq, configuration sequence
class lp_shutdown_config20 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr20;
  rand int unsigned num_a2u0_wr20;
  rand int unsigned num_u12a_wr20;
  rand int unsigned num_a2u1_wr20;

  function new(string name="lp_shutdown_config20",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)    

  constraint num_u02a_wr_ct20 {(num_u02a_wr20 > 2) && (num_u02a_wr20 <= 4);}
  constraint num_a2u0_wr_ct20 {(num_a2u0_wr20 == 1);}
  constraint num_u12a_wr_ct20 {(num_u12a_wr20 > 2) && (num_u12a_wr20 <= 4);}
  constraint num_a2u1_wr_ct20 {(num_a2u1_wr20 == 1);}

  // APB20 and UART20 UVC20 sequences
  uart_ctrl_config_reg_seq20 uart_cfg_dut_seq20;
  uart_incr_payload_seq20 uart_seq20;
  intrpt_seq20 rd_rx_fifo20;
  ahb_to_uart_wr20 raw_seq20;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq20", $psprintf("Number20 of APB20->UART020 Transaction20 = %d", num_a2u0_wr20), UVM_LOW);
    `uvm_info("vseq20", $psprintf("Number20 of APB20->UART120 Transaction20 = %d", num_a2u1_wr20), UVM_LOW);
    `uvm_info("vseq20", $psprintf("Number20 of UART020->APB20 Transaction20 = %d", num_u02a_wr20), UVM_LOW);
    `uvm_info("vseq20", $psprintf("Number20 of UART120->APB20 Transaction20 = %d", num_u12a_wr20), UVM_LOW);
    `uvm_info("vseq20", $psprintf("Total20 Number20 of AHB20, UART20 Transaction20 = %d", num_u02a_wr20 + num_a2u0_wr20 + num_u02a_wr20 + num_a2u0_wr20), UVM_LOW);

    // configure UART020 DUT
    uart_cfg_dut_seq20 = uart_ctrl_config_reg_seq20::type_id::create("uart_cfg_dut_seq20");
    uart_cfg_dut_seq20.reg_model20 = p_sequencer.reg_model_ptr20.uart0_rm20;
    uart_cfg_dut_seq20.start(null);


    // configure UART120 DUT
    uart_cfg_dut_seq20 = uart_ctrl_config_reg_seq20::type_id::create("uart_cfg_dut_seq20");
    uart_cfg_dut_seq20.reg_model20 = p_sequencer.reg_model_ptr20.uart1_rm20;
    uart_cfg_dut_seq20.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == num_a2u0_wr20; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == num_a2u1_wr20; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq20, p_sequencer.uart0_seqr20, {cnt == num_u02a_wr20;})
      `uvm_do_on_with(uart_seq20, p_sequencer.uart1_seqr20, {cnt == num_u12a_wr20;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u02a_wr20; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u12a_wr20; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == num_a2u0_wr20; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq20, p_sequencer.uart0_seqr20, {cnt == num_u02a_wr20;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config20

// rand lp20 shutdown20 seq between uart20 1 and smc20
class lp_shutdown_rand20 extends uvm_sequence;

  rand int unsigned num_u02a_wr20;
  rand int unsigned num_a2u0_wr20;
  rand int unsigned num_u12a_wr20;
  rand int unsigned num_a2u1_wr20;

  function new(string name="lp_shutdown_rand20",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)    

  constraint num_u02a_wr_ct20 {(num_u02a_wr20 > 2) && (num_u02a_wr20 <= 4);}
  constraint num_a2u0_wr_ct20 {(num_a2u0_wr20 == 1);}
  constraint num_u12a_wr_ct20 {(num_u12a_wr20 > 2) && (num_u12a_wr20 <= 4);}
  constraint num_a2u1_wr_ct20 {(num_a2u1_wr20 == 1);}


  on_off_seq20 on_off_seq20;
  uart_incr_payload_seq20 uart_seq20;
  intrpt_seq20 rd_rx_fifo20;
  ahb_to_uart_wr20 raw_seq20;
  lp_shutdown_config20 lp_shutdown_config20;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut20 down seq
    `uvm_do(lp_shutdown_config20);
    #20000;
    `uvm_do(on_off_seq20);

    #10000;
    fork
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == num_a2u1_wr20; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq20, p_sequencer.uart1_seqr20, {cnt == num_u12a_wr20;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u02a_wr20; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u12a_wr20; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand20


// sequence for shutting20 down uart20 1 alone20
class lp_shutdown_uart120 extends uvm_sequence;

  rand int unsigned num_u02a_wr20;
  rand int unsigned num_a2u0_wr20;
  rand int unsigned num_u12a_wr20;
  rand int unsigned num_a2u1_wr20;

  function new(string name="lp_shutdown_uart120",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart120)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)    

  constraint num_u02a_wr_ct20 {(num_u02a_wr20 > 2) && (num_u02a_wr20 <= 4);}
  constraint num_a2u0_wr_ct20 {(num_a2u0_wr20 == 1);}
  constraint num_u12a_wr_ct20 {(num_u12a_wr20 > 2) && (num_u12a_wr20 <= 4);}
  constraint num_a2u1_wr_ct20 {(num_a2u1_wr20 == 2);}


  on_off_uart1_seq20 on_off_uart1_seq20;
  uart_incr_payload_seq20 uart_seq20;
  intrpt_seq20 rd_rx_fifo20;
  ahb_to_uart_wr20 raw_seq20;
  lp_shutdown_config20 lp_shutdown_config20;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut20 down seq
    `uvm_do(lp_shutdown_config20);
    #20000;
    `uvm_do(on_off_uart1_seq20);

    #10000;
    fork
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == num_a2u1_wr20; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq20, p_sequencer.uart1_seqr20, {cnt == num_u12a_wr20;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u02a_wr20; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo20, p_sequencer.ahb_seqr20, {num_of_rd20 == num_u12a_wr20; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart120



class apb_spi_incr_payload20 extends uvm_sequence;

  rand int unsigned num_spi2a_wr20;
  rand int unsigned num_a2spi_wr20;

  function new(string name="apb_spi_incr_payload20",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)    

  constraint num_spi2a_wr_ct20 {(num_spi2a_wr20 > 2) && (num_spi2a_wr20 <= 4);}
  constraint num_a2spi_wr_ct20 {(num_a2spi_wr20 == 4);}

  // APB20 and UART20 UVC20 sequences
  spi_cfg_reg_seq20 spi_cfg_dut_seq20;
  spi_incr_payload20 spi_seq20;
  read_spi_rx_reg20 rd_rx_reg20;
  ahb_to_spi_wr20 raw_seq20;
  spi_en_tx_reg_seq20 en_spi_tx_seq20;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq20", $psprintf("Number20 of APB20->SPI20 Transaction20 = %d", num_a2spi_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Number20 of SPI20->APB20 Transaction20 = %d", num_a2spi_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Total20 Number20 of AHB20, SPI20 Transaction20 = %d", 2 * num_a2spi_wr20), UVM_LOW)

    // configure SPI20 DUT
    spi_cfg_dut_seq20 = spi_cfg_reg_seq20::type_id::create("spi_cfg_dut_seq20");
    spi_cfg_dut_seq20.reg_model20 = p_sequencer.reg_model_ptr20.spi_rf20;
    spi_cfg_dut_seq20.start(null);


    for (int i = 0; i < num_a2spi_wr20; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {num_of_wr20 == 1; base_addr == 'h800000;})
            en_spi_tx_seq20 = spi_en_tx_reg_seq20::type_id::create("en_spi_tx_seq20");
            en_spi_tx_seq20.reg_model20 = p_sequencer.reg_model_ptr20.spi_rf20;
            en_spi_tx_seq20.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq20, p_sequencer.spi0_seqr20, {cnt_i20 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg20, p_sequencer.ahb_seqr20, {num_of_rd20 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload20

class apb_gpio_simple_vseq20 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr20;

  function new(string name="apb_gpio_simple_vseq20",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)    

  constraint num_a2gpio_wr_ct20 {(num_a2gpio_wr20 == 4);}

  // APB20 and UART20 UVC20 sequences
  gpio_cfg_reg_seq20 gpio_cfg_dut_seq20;
  gpio_simple_trans_seq20 gpio_seq20;
  read_gpio_rx_reg20 rd_rx_reg20;
  ahb_to_gpio_wr20 raw_seq20;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq20", $psprintf("Number20 of AHB20->GPIO20 Transaction20 = %d", num_a2gpio_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Number20 of GPIO20->APB20 Transaction20 = %d", num_a2gpio_wr20), UVM_LOW)
    `uvm_info("vseq20", $psprintf("Total20 Number20 of AHB20, GPIO20 Transaction20 = %d", 2 * num_a2gpio_wr20), UVM_LOW)

    // configure SPI20 DUT
    gpio_cfg_dut_seq20 = gpio_cfg_reg_seq20::type_id::create("gpio_cfg_dut_seq20");
    gpio_cfg_dut_seq20.reg_model20 = p_sequencer.reg_model_ptr20.gpio_rf20;
    gpio_cfg_dut_seq20.start(null);


    for (int i = 0; i < num_a2gpio_wr20; i++) begin
      `uvm_do_on_with(raw_seq20, p_sequencer.ahb_seqr20, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq20, p_sequencer.gpio0_seqr20)
      `uvm_do_on_with(rd_rx_reg20, p_sequencer.ahb_seqr20, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq20

class apb_subsystem_vseq20 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq20",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq20)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)    

  // APB20 and UART20 UVC20 sequences
  u2a_incr_payload20 apb_to_uart20;
  apb_spi_incr_payload20 apb_to_spi20;
  apb_gpio_simple_vseq20 apb_to_gpio20;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq20", $psprintf("Doing apb_subsystem_vseq20"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart20)
      `uvm_do(apb_to_spi20)
      `uvm_do(apb_to_gpio20)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq20

class apb_ss_cms_seq20 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq20)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer20)

   function new(string name = "apb_ss_cms_seq20");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq20", $psprintf("Starting AHB20 Compliance20 Management20 System20 (CMS20)"), UVM_LOW)
//	   p_sequencer.ahb_seqr20.start_ahb_cms20();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq20
`endif
