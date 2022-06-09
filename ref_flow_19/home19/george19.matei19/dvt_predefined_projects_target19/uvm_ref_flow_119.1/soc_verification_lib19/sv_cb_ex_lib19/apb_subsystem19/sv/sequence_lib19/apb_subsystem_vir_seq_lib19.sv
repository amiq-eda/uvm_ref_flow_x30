/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_vir_seq_lib19.sv
Title19       : Virtual Sequence
Project19     :
Created19     :
Description19 : This19 file implements19 the virtual sequence for the APB19-UART19 env19.
Notes19       : The concurrent_u2a_a2u_rand_trans19 sequence first configures19
            : the UART19 RTL19. Once19 the configuration sequence is completed
            : random read/write sequences from both the UVCs19 are enabled
            : in parallel19. At19 the end a Rx19 FIFO read sequence is executed19.
            : The intrpt_seq19 needs19 to be modified to take19 interrupt19 into account19.
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV19
`define APB_UART_VIRTUAL_SEQ_LIB_SV19

class u2a_incr_payload19 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr19;
  rand int unsigned num_a2u0_wr19;
  rand int unsigned num_u12a_wr19;
  rand int unsigned num_a2u1_wr19;

  function new(string name="u2a_incr_payload19",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)    

  constraint num_u02a_wr_ct19 {(num_u02a_wr19 > 2) && (num_u02a_wr19 <= 4);}
  constraint num_a2u0_wr_ct19 {(num_a2u0_wr19 == 1);}
  constraint num_u12a_wr_ct19 {(num_u12a_wr19 > 2) && (num_u12a_wr19 <= 4);}
  constraint num_a2u1_wr_ct19 {(num_a2u1_wr19 == 1);}

  // APB19 and UART19 UVC19 sequences
  uart_ctrl_config_reg_seq19 uart_cfg_dut_seq19;
  uart_incr_payload_seq19 uart_seq19;
  intrpt_seq19 rd_rx_fifo19;
  ahb_to_uart_wr19 raw_seq19;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq19", $psprintf("Number19 of APB19->UART019 Transaction19 = %d", num_a2u0_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Number19 of APB19->UART119 Transaction19 = %d", num_a2u1_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Number19 of UART019->APB19 Transaction19 = %d", num_u02a_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Number19 of UART119->APB19 Transaction19 = %d", num_u12a_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Total19 Number19 of AHB19, UART19 Transaction19 = %d", num_u02a_wr19 + num_a2u0_wr19 + num_u02a_wr19 + num_a2u0_wr19), UVM_LOW)

    // configure UART019 DUT
    uart_cfg_dut_seq19 = uart_ctrl_config_reg_seq19::type_id::create("uart_cfg_dut_seq19");
    uart_cfg_dut_seq19.reg_model19 = p_sequencer.reg_model_ptr19.uart0_rm19;
    uart_cfg_dut_seq19.start(null);


    // configure UART119 DUT
    uart_cfg_dut_seq19 = uart_ctrl_config_reg_seq19::type_id::create("uart_cfg_dut_seq19");
    uart_cfg_dut_seq19.reg_model19 = p_sequencer.reg_model_ptr19.uart1_rm19;
    uart_cfg_dut_seq19.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == num_a2u0_wr19; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == num_a2u1_wr19; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq19, p_sequencer.uart0_seqr19, {cnt == num_u02a_wr19;})
      `uvm_do_on_with(uart_seq19, p_sequencer.uart1_seqr19, {cnt == num_u12a_wr19;})
    join
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u02a_wr19; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u12a_wr19; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload19

// rand shutdown19 and power19-on
class on_off_seq19 extends uvm_sequence;
  `uvm_object_utils(on_off_seq19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)

  function new(string name = "on_off_seq19");
     super.new(name);
  endfunction

  shutdown_dut19 shut_dut19;
  poweron_dut19 power_dut19;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut19, p_sequencer.ahb_seqr19)
       #4000;
      `uvm_do_on(power_dut19, p_sequencer.ahb_seqr19)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq19


// shutdown19 and power19-on for uart119
class on_off_uart1_seq19 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)

  function new(string name = "on_off_uart1_seq19");
     super.new(name);
  endfunction

  shutdown_dut19 shut_dut19;
  poweron_dut19 power_dut19;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut19, p_sequencer.ahb_seqr19, {write_data19 == 1;})
        #4000;
      `uvm_do_on(power_dut19, p_sequencer.ahb_seqr19)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq19

// lp19 seq, configuration sequence
class lp_shutdown_config19 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr19;
  rand int unsigned num_a2u0_wr19;
  rand int unsigned num_u12a_wr19;
  rand int unsigned num_a2u1_wr19;

  function new(string name="lp_shutdown_config19",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)    

  constraint num_u02a_wr_ct19 {(num_u02a_wr19 > 2) && (num_u02a_wr19 <= 4);}
  constraint num_a2u0_wr_ct19 {(num_a2u0_wr19 == 1);}
  constraint num_u12a_wr_ct19 {(num_u12a_wr19 > 2) && (num_u12a_wr19 <= 4);}
  constraint num_a2u1_wr_ct19 {(num_a2u1_wr19 == 1);}

  // APB19 and UART19 UVC19 sequences
  uart_ctrl_config_reg_seq19 uart_cfg_dut_seq19;
  uart_incr_payload_seq19 uart_seq19;
  intrpt_seq19 rd_rx_fifo19;
  ahb_to_uart_wr19 raw_seq19;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq19", $psprintf("Number19 of APB19->UART019 Transaction19 = %d", num_a2u0_wr19), UVM_LOW);
    `uvm_info("vseq19", $psprintf("Number19 of APB19->UART119 Transaction19 = %d", num_a2u1_wr19), UVM_LOW);
    `uvm_info("vseq19", $psprintf("Number19 of UART019->APB19 Transaction19 = %d", num_u02a_wr19), UVM_LOW);
    `uvm_info("vseq19", $psprintf("Number19 of UART119->APB19 Transaction19 = %d", num_u12a_wr19), UVM_LOW);
    `uvm_info("vseq19", $psprintf("Total19 Number19 of AHB19, UART19 Transaction19 = %d", num_u02a_wr19 + num_a2u0_wr19 + num_u02a_wr19 + num_a2u0_wr19), UVM_LOW);

    // configure UART019 DUT
    uart_cfg_dut_seq19 = uart_ctrl_config_reg_seq19::type_id::create("uart_cfg_dut_seq19");
    uart_cfg_dut_seq19.reg_model19 = p_sequencer.reg_model_ptr19.uart0_rm19;
    uart_cfg_dut_seq19.start(null);


    // configure UART119 DUT
    uart_cfg_dut_seq19 = uart_ctrl_config_reg_seq19::type_id::create("uart_cfg_dut_seq19");
    uart_cfg_dut_seq19.reg_model19 = p_sequencer.reg_model_ptr19.uart1_rm19;
    uart_cfg_dut_seq19.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == num_a2u0_wr19; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == num_a2u1_wr19; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq19, p_sequencer.uart0_seqr19, {cnt == num_u02a_wr19;})
      `uvm_do_on_with(uart_seq19, p_sequencer.uart1_seqr19, {cnt == num_u12a_wr19;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u02a_wr19; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u12a_wr19; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == num_a2u0_wr19; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq19, p_sequencer.uart0_seqr19, {cnt == num_u02a_wr19;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config19

// rand lp19 shutdown19 seq between uart19 1 and smc19
class lp_shutdown_rand19 extends uvm_sequence;

  rand int unsigned num_u02a_wr19;
  rand int unsigned num_a2u0_wr19;
  rand int unsigned num_u12a_wr19;
  rand int unsigned num_a2u1_wr19;

  function new(string name="lp_shutdown_rand19",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)    

  constraint num_u02a_wr_ct19 {(num_u02a_wr19 > 2) && (num_u02a_wr19 <= 4);}
  constraint num_a2u0_wr_ct19 {(num_a2u0_wr19 == 1);}
  constraint num_u12a_wr_ct19 {(num_u12a_wr19 > 2) && (num_u12a_wr19 <= 4);}
  constraint num_a2u1_wr_ct19 {(num_a2u1_wr19 == 1);}


  on_off_seq19 on_off_seq19;
  uart_incr_payload_seq19 uart_seq19;
  intrpt_seq19 rd_rx_fifo19;
  ahb_to_uart_wr19 raw_seq19;
  lp_shutdown_config19 lp_shutdown_config19;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut19 down seq
    `uvm_do(lp_shutdown_config19);
    #20000;
    `uvm_do(on_off_seq19);

    #10000;
    fork
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == num_a2u1_wr19; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq19, p_sequencer.uart1_seqr19, {cnt == num_u12a_wr19;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u02a_wr19; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u12a_wr19; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand19


// sequence for shutting19 down uart19 1 alone19
class lp_shutdown_uart119 extends uvm_sequence;

  rand int unsigned num_u02a_wr19;
  rand int unsigned num_a2u0_wr19;
  rand int unsigned num_u12a_wr19;
  rand int unsigned num_a2u1_wr19;

  function new(string name="lp_shutdown_uart119",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart119)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)    

  constraint num_u02a_wr_ct19 {(num_u02a_wr19 > 2) && (num_u02a_wr19 <= 4);}
  constraint num_a2u0_wr_ct19 {(num_a2u0_wr19 == 1);}
  constraint num_u12a_wr_ct19 {(num_u12a_wr19 > 2) && (num_u12a_wr19 <= 4);}
  constraint num_a2u1_wr_ct19 {(num_a2u1_wr19 == 2);}


  on_off_uart1_seq19 on_off_uart1_seq19;
  uart_incr_payload_seq19 uart_seq19;
  intrpt_seq19 rd_rx_fifo19;
  ahb_to_uart_wr19 raw_seq19;
  lp_shutdown_config19 lp_shutdown_config19;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut19 down seq
    `uvm_do(lp_shutdown_config19);
    #20000;
    `uvm_do(on_off_uart1_seq19);

    #10000;
    fork
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == num_a2u1_wr19; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq19, p_sequencer.uart1_seqr19, {cnt == num_u12a_wr19;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u02a_wr19; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo19, p_sequencer.ahb_seqr19, {num_of_rd19 == num_u12a_wr19; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart119



class apb_spi_incr_payload19 extends uvm_sequence;

  rand int unsigned num_spi2a_wr19;
  rand int unsigned num_a2spi_wr19;

  function new(string name="apb_spi_incr_payload19",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)    

  constraint num_spi2a_wr_ct19 {(num_spi2a_wr19 > 2) && (num_spi2a_wr19 <= 4);}
  constraint num_a2spi_wr_ct19 {(num_a2spi_wr19 == 4);}

  // APB19 and UART19 UVC19 sequences
  spi_cfg_reg_seq19 spi_cfg_dut_seq19;
  spi_incr_payload19 spi_seq19;
  read_spi_rx_reg19 rd_rx_reg19;
  ahb_to_spi_wr19 raw_seq19;
  spi_en_tx_reg_seq19 en_spi_tx_seq19;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq19", $psprintf("Number19 of APB19->SPI19 Transaction19 = %d", num_a2spi_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Number19 of SPI19->APB19 Transaction19 = %d", num_a2spi_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Total19 Number19 of AHB19, SPI19 Transaction19 = %d", 2 * num_a2spi_wr19), UVM_LOW)

    // configure SPI19 DUT
    spi_cfg_dut_seq19 = spi_cfg_reg_seq19::type_id::create("spi_cfg_dut_seq19");
    spi_cfg_dut_seq19.reg_model19 = p_sequencer.reg_model_ptr19.spi_rf19;
    spi_cfg_dut_seq19.start(null);


    for (int i = 0; i < num_a2spi_wr19; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {num_of_wr19 == 1; base_addr == 'h800000;})
            en_spi_tx_seq19 = spi_en_tx_reg_seq19::type_id::create("en_spi_tx_seq19");
            en_spi_tx_seq19.reg_model19 = p_sequencer.reg_model_ptr19.spi_rf19;
            en_spi_tx_seq19.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq19, p_sequencer.spi0_seqr19, {cnt_i19 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg19, p_sequencer.ahb_seqr19, {num_of_rd19 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload19

class apb_gpio_simple_vseq19 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr19;

  function new(string name="apb_gpio_simple_vseq19",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)    

  constraint num_a2gpio_wr_ct19 {(num_a2gpio_wr19 == 4);}

  // APB19 and UART19 UVC19 sequences
  gpio_cfg_reg_seq19 gpio_cfg_dut_seq19;
  gpio_simple_trans_seq19 gpio_seq19;
  read_gpio_rx_reg19 rd_rx_reg19;
  ahb_to_gpio_wr19 raw_seq19;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq19", $psprintf("Number19 of AHB19->GPIO19 Transaction19 = %d", num_a2gpio_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Number19 of GPIO19->APB19 Transaction19 = %d", num_a2gpio_wr19), UVM_LOW)
    `uvm_info("vseq19", $psprintf("Total19 Number19 of AHB19, GPIO19 Transaction19 = %d", 2 * num_a2gpio_wr19), UVM_LOW)

    // configure SPI19 DUT
    gpio_cfg_dut_seq19 = gpio_cfg_reg_seq19::type_id::create("gpio_cfg_dut_seq19");
    gpio_cfg_dut_seq19.reg_model19 = p_sequencer.reg_model_ptr19.gpio_rf19;
    gpio_cfg_dut_seq19.start(null);


    for (int i = 0; i < num_a2gpio_wr19; i++) begin
      `uvm_do_on_with(raw_seq19, p_sequencer.ahb_seqr19, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq19, p_sequencer.gpio0_seqr19)
      `uvm_do_on_with(rd_rx_reg19, p_sequencer.ahb_seqr19, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq19

class apb_subsystem_vseq19 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq19",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq19)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)    

  // APB19 and UART19 UVC19 sequences
  u2a_incr_payload19 apb_to_uart19;
  apb_spi_incr_payload19 apb_to_spi19;
  apb_gpio_simple_vseq19 apb_to_gpio19;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq19", $psprintf("Doing apb_subsystem_vseq19"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart19)
      `uvm_do(apb_to_spi19)
      `uvm_do(apb_to_gpio19)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq19

class apb_ss_cms_seq19 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq19)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer19)

   function new(string name = "apb_ss_cms_seq19");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq19", $psprintf("Starting AHB19 Compliance19 Management19 System19 (CMS19)"), UVM_LOW)
//	   p_sequencer.ahb_seqr19.start_ahb_cms19();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq19
`endif
