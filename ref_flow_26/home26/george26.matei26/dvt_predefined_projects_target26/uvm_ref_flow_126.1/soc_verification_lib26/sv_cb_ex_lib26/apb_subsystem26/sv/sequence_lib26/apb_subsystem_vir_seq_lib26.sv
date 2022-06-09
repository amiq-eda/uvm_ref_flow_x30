/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_vir_seq_lib26.sv
Title26       : Virtual Sequence
Project26     :
Created26     :
Description26 : This26 file implements26 the virtual sequence for the APB26-UART26 env26.
Notes26       : The concurrent_u2a_a2u_rand_trans26 sequence first configures26
            : the UART26 RTL26. Once26 the configuration sequence is completed
            : random read/write sequences from both the UVCs26 are enabled
            : in parallel26. At26 the end a Rx26 FIFO read sequence is executed26.
            : The intrpt_seq26 needs26 to be modified to take26 interrupt26 into account26.
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV26
`define APB_UART_VIRTUAL_SEQ_LIB_SV26

class u2a_incr_payload26 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr26;
  rand int unsigned num_a2u0_wr26;
  rand int unsigned num_u12a_wr26;
  rand int unsigned num_a2u1_wr26;

  function new(string name="u2a_incr_payload26",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)    

  constraint num_u02a_wr_ct26 {(num_u02a_wr26 > 2) && (num_u02a_wr26 <= 4);}
  constraint num_a2u0_wr_ct26 {(num_a2u0_wr26 == 1);}
  constraint num_u12a_wr_ct26 {(num_u12a_wr26 > 2) && (num_u12a_wr26 <= 4);}
  constraint num_a2u1_wr_ct26 {(num_a2u1_wr26 == 1);}

  // APB26 and UART26 UVC26 sequences
  uart_ctrl_config_reg_seq26 uart_cfg_dut_seq26;
  uart_incr_payload_seq26 uart_seq26;
  intrpt_seq26 rd_rx_fifo26;
  ahb_to_uart_wr26 raw_seq26;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq26", $psprintf("Number26 of APB26->UART026 Transaction26 = %d", num_a2u0_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Number26 of APB26->UART126 Transaction26 = %d", num_a2u1_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Number26 of UART026->APB26 Transaction26 = %d", num_u02a_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Number26 of UART126->APB26 Transaction26 = %d", num_u12a_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Total26 Number26 of AHB26, UART26 Transaction26 = %d", num_u02a_wr26 + num_a2u0_wr26 + num_u02a_wr26 + num_a2u0_wr26), UVM_LOW)

    // configure UART026 DUT
    uart_cfg_dut_seq26 = uart_ctrl_config_reg_seq26::type_id::create("uart_cfg_dut_seq26");
    uart_cfg_dut_seq26.reg_model26 = p_sequencer.reg_model_ptr26.uart0_rm26;
    uart_cfg_dut_seq26.start(null);


    // configure UART126 DUT
    uart_cfg_dut_seq26 = uart_ctrl_config_reg_seq26::type_id::create("uart_cfg_dut_seq26");
    uart_cfg_dut_seq26.reg_model26 = p_sequencer.reg_model_ptr26.uart1_rm26;
    uart_cfg_dut_seq26.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == num_a2u0_wr26; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == num_a2u1_wr26; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq26, p_sequencer.uart0_seqr26, {cnt == num_u02a_wr26;})
      `uvm_do_on_with(uart_seq26, p_sequencer.uart1_seqr26, {cnt == num_u12a_wr26;})
    join
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u02a_wr26; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u12a_wr26; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload26

// rand shutdown26 and power26-on
class on_off_seq26 extends uvm_sequence;
  `uvm_object_utils(on_off_seq26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)

  function new(string name = "on_off_seq26");
     super.new(name);
  endfunction

  shutdown_dut26 shut_dut26;
  poweron_dut26 power_dut26;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut26, p_sequencer.ahb_seqr26)
       #4000;
      `uvm_do_on(power_dut26, p_sequencer.ahb_seqr26)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq26


// shutdown26 and power26-on for uart126
class on_off_uart1_seq26 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)

  function new(string name = "on_off_uart1_seq26");
     super.new(name);
  endfunction

  shutdown_dut26 shut_dut26;
  poweron_dut26 power_dut26;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut26, p_sequencer.ahb_seqr26, {write_data26 == 1;})
        #4000;
      `uvm_do_on(power_dut26, p_sequencer.ahb_seqr26)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq26

// lp26 seq, configuration sequence
class lp_shutdown_config26 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr26;
  rand int unsigned num_a2u0_wr26;
  rand int unsigned num_u12a_wr26;
  rand int unsigned num_a2u1_wr26;

  function new(string name="lp_shutdown_config26",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)    

  constraint num_u02a_wr_ct26 {(num_u02a_wr26 > 2) && (num_u02a_wr26 <= 4);}
  constraint num_a2u0_wr_ct26 {(num_a2u0_wr26 == 1);}
  constraint num_u12a_wr_ct26 {(num_u12a_wr26 > 2) && (num_u12a_wr26 <= 4);}
  constraint num_a2u1_wr_ct26 {(num_a2u1_wr26 == 1);}

  // APB26 and UART26 UVC26 sequences
  uart_ctrl_config_reg_seq26 uart_cfg_dut_seq26;
  uart_incr_payload_seq26 uart_seq26;
  intrpt_seq26 rd_rx_fifo26;
  ahb_to_uart_wr26 raw_seq26;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq26", $psprintf("Number26 of APB26->UART026 Transaction26 = %d", num_a2u0_wr26), UVM_LOW);
    `uvm_info("vseq26", $psprintf("Number26 of APB26->UART126 Transaction26 = %d", num_a2u1_wr26), UVM_LOW);
    `uvm_info("vseq26", $psprintf("Number26 of UART026->APB26 Transaction26 = %d", num_u02a_wr26), UVM_LOW);
    `uvm_info("vseq26", $psprintf("Number26 of UART126->APB26 Transaction26 = %d", num_u12a_wr26), UVM_LOW);
    `uvm_info("vseq26", $psprintf("Total26 Number26 of AHB26, UART26 Transaction26 = %d", num_u02a_wr26 + num_a2u0_wr26 + num_u02a_wr26 + num_a2u0_wr26), UVM_LOW);

    // configure UART026 DUT
    uart_cfg_dut_seq26 = uart_ctrl_config_reg_seq26::type_id::create("uart_cfg_dut_seq26");
    uart_cfg_dut_seq26.reg_model26 = p_sequencer.reg_model_ptr26.uart0_rm26;
    uart_cfg_dut_seq26.start(null);


    // configure UART126 DUT
    uart_cfg_dut_seq26 = uart_ctrl_config_reg_seq26::type_id::create("uart_cfg_dut_seq26");
    uart_cfg_dut_seq26.reg_model26 = p_sequencer.reg_model_ptr26.uart1_rm26;
    uart_cfg_dut_seq26.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == num_a2u0_wr26; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == num_a2u1_wr26; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq26, p_sequencer.uart0_seqr26, {cnt == num_u02a_wr26;})
      `uvm_do_on_with(uart_seq26, p_sequencer.uart1_seqr26, {cnt == num_u12a_wr26;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u02a_wr26; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u12a_wr26; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == num_a2u0_wr26; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq26, p_sequencer.uart0_seqr26, {cnt == num_u02a_wr26;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config26

// rand lp26 shutdown26 seq between uart26 1 and smc26
class lp_shutdown_rand26 extends uvm_sequence;

  rand int unsigned num_u02a_wr26;
  rand int unsigned num_a2u0_wr26;
  rand int unsigned num_u12a_wr26;
  rand int unsigned num_a2u1_wr26;

  function new(string name="lp_shutdown_rand26",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)    

  constraint num_u02a_wr_ct26 {(num_u02a_wr26 > 2) && (num_u02a_wr26 <= 4);}
  constraint num_a2u0_wr_ct26 {(num_a2u0_wr26 == 1);}
  constraint num_u12a_wr_ct26 {(num_u12a_wr26 > 2) && (num_u12a_wr26 <= 4);}
  constraint num_a2u1_wr_ct26 {(num_a2u1_wr26 == 1);}


  on_off_seq26 on_off_seq26;
  uart_incr_payload_seq26 uart_seq26;
  intrpt_seq26 rd_rx_fifo26;
  ahb_to_uart_wr26 raw_seq26;
  lp_shutdown_config26 lp_shutdown_config26;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut26 down seq
    `uvm_do(lp_shutdown_config26);
    #20000;
    `uvm_do(on_off_seq26);

    #10000;
    fork
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == num_a2u1_wr26; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq26, p_sequencer.uart1_seqr26, {cnt == num_u12a_wr26;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u02a_wr26; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u12a_wr26; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand26


// sequence for shutting26 down uart26 1 alone26
class lp_shutdown_uart126 extends uvm_sequence;

  rand int unsigned num_u02a_wr26;
  rand int unsigned num_a2u0_wr26;
  rand int unsigned num_u12a_wr26;
  rand int unsigned num_a2u1_wr26;

  function new(string name="lp_shutdown_uart126",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart126)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)    

  constraint num_u02a_wr_ct26 {(num_u02a_wr26 > 2) && (num_u02a_wr26 <= 4);}
  constraint num_a2u0_wr_ct26 {(num_a2u0_wr26 == 1);}
  constraint num_u12a_wr_ct26 {(num_u12a_wr26 > 2) && (num_u12a_wr26 <= 4);}
  constraint num_a2u1_wr_ct26 {(num_a2u1_wr26 == 2);}


  on_off_uart1_seq26 on_off_uart1_seq26;
  uart_incr_payload_seq26 uart_seq26;
  intrpt_seq26 rd_rx_fifo26;
  ahb_to_uart_wr26 raw_seq26;
  lp_shutdown_config26 lp_shutdown_config26;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut26 down seq
    `uvm_do(lp_shutdown_config26);
    #20000;
    `uvm_do(on_off_uart1_seq26);

    #10000;
    fork
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == num_a2u1_wr26; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq26, p_sequencer.uart1_seqr26, {cnt == num_u12a_wr26;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u02a_wr26; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo26, p_sequencer.ahb_seqr26, {num_of_rd26 == num_u12a_wr26; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart126



class apb_spi_incr_payload26 extends uvm_sequence;

  rand int unsigned num_spi2a_wr26;
  rand int unsigned num_a2spi_wr26;

  function new(string name="apb_spi_incr_payload26",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)    

  constraint num_spi2a_wr_ct26 {(num_spi2a_wr26 > 2) && (num_spi2a_wr26 <= 4);}
  constraint num_a2spi_wr_ct26 {(num_a2spi_wr26 == 4);}

  // APB26 and UART26 UVC26 sequences
  spi_cfg_reg_seq26 spi_cfg_dut_seq26;
  spi_incr_payload26 spi_seq26;
  read_spi_rx_reg26 rd_rx_reg26;
  ahb_to_spi_wr26 raw_seq26;
  spi_en_tx_reg_seq26 en_spi_tx_seq26;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq26", $psprintf("Number26 of APB26->SPI26 Transaction26 = %d", num_a2spi_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Number26 of SPI26->APB26 Transaction26 = %d", num_a2spi_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Total26 Number26 of AHB26, SPI26 Transaction26 = %d", 2 * num_a2spi_wr26), UVM_LOW)

    // configure SPI26 DUT
    spi_cfg_dut_seq26 = spi_cfg_reg_seq26::type_id::create("spi_cfg_dut_seq26");
    spi_cfg_dut_seq26.reg_model26 = p_sequencer.reg_model_ptr26.spi_rf26;
    spi_cfg_dut_seq26.start(null);


    for (int i = 0; i < num_a2spi_wr26; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {num_of_wr26 == 1; base_addr == 'h800000;})
            en_spi_tx_seq26 = spi_en_tx_reg_seq26::type_id::create("en_spi_tx_seq26");
            en_spi_tx_seq26.reg_model26 = p_sequencer.reg_model_ptr26.spi_rf26;
            en_spi_tx_seq26.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq26, p_sequencer.spi0_seqr26, {cnt_i26 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg26, p_sequencer.ahb_seqr26, {num_of_rd26 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload26

class apb_gpio_simple_vseq26 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr26;

  function new(string name="apb_gpio_simple_vseq26",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)    

  constraint num_a2gpio_wr_ct26 {(num_a2gpio_wr26 == 4);}

  // APB26 and UART26 UVC26 sequences
  gpio_cfg_reg_seq26 gpio_cfg_dut_seq26;
  gpio_simple_trans_seq26 gpio_seq26;
  read_gpio_rx_reg26 rd_rx_reg26;
  ahb_to_gpio_wr26 raw_seq26;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq26", $psprintf("Number26 of AHB26->GPIO26 Transaction26 = %d", num_a2gpio_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Number26 of GPIO26->APB26 Transaction26 = %d", num_a2gpio_wr26), UVM_LOW)
    `uvm_info("vseq26", $psprintf("Total26 Number26 of AHB26, GPIO26 Transaction26 = %d", 2 * num_a2gpio_wr26), UVM_LOW)

    // configure SPI26 DUT
    gpio_cfg_dut_seq26 = gpio_cfg_reg_seq26::type_id::create("gpio_cfg_dut_seq26");
    gpio_cfg_dut_seq26.reg_model26 = p_sequencer.reg_model_ptr26.gpio_rf26;
    gpio_cfg_dut_seq26.start(null);


    for (int i = 0; i < num_a2gpio_wr26; i++) begin
      `uvm_do_on_with(raw_seq26, p_sequencer.ahb_seqr26, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq26, p_sequencer.gpio0_seqr26)
      `uvm_do_on_with(rd_rx_reg26, p_sequencer.ahb_seqr26, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq26

class apb_subsystem_vseq26 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq26",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq26)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)    

  // APB26 and UART26 UVC26 sequences
  u2a_incr_payload26 apb_to_uart26;
  apb_spi_incr_payload26 apb_to_spi26;
  apb_gpio_simple_vseq26 apb_to_gpio26;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq26", $psprintf("Doing apb_subsystem_vseq26"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart26)
      `uvm_do(apb_to_spi26)
      `uvm_do(apb_to_gpio26)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq26

class apb_ss_cms_seq26 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq26)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer26)

   function new(string name = "apb_ss_cms_seq26");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq26", $psprintf("Starting AHB26 Compliance26 Management26 System26 (CMS26)"), UVM_LOW)
//	   p_sequencer.ahb_seqr26.start_ahb_cms26();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq26
`endif
