/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_vir_seq_lib7.sv
Title7       : Virtual Sequence
Project7     :
Created7     :
Description7 : This7 file implements7 the virtual sequence for the APB7-UART7 env7.
Notes7       : The concurrent_u2a_a2u_rand_trans7 sequence first configures7
            : the UART7 RTL7. Once7 the configuration sequence is completed
            : random read/write sequences from both the UVCs7 are enabled
            : in parallel7. At7 the end a Rx7 FIFO read sequence is executed7.
            : The intrpt_seq7 needs7 to be modified to take7 interrupt7 into account7.
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV7
`define APB_UART_VIRTUAL_SEQ_LIB_SV7

class u2a_incr_payload7 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr7;
  rand int unsigned num_a2u0_wr7;
  rand int unsigned num_u12a_wr7;
  rand int unsigned num_a2u1_wr7;

  function new(string name="u2a_incr_payload7",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)    

  constraint num_u02a_wr_ct7 {(num_u02a_wr7 > 2) && (num_u02a_wr7 <= 4);}
  constraint num_a2u0_wr_ct7 {(num_a2u0_wr7 == 1);}
  constraint num_u12a_wr_ct7 {(num_u12a_wr7 > 2) && (num_u12a_wr7 <= 4);}
  constraint num_a2u1_wr_ct7 {(num_a2u1_wr7 == 1);}

  // APB7 and UART7 UVC7 sequences
  uart_ctrl_config_reg_seq7 uart_cfg_dut_seq7;
  uart_incr_payload_seq7 uart_seq7;
  intrpt_seq7 rd_rx_fifo7;
  ahb_to_uart_wr7 raw_seq7;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq7", $psprintf("Number7 of APB7->UART07 Transaction7 = %d", num_a2u0_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Number7 of APB7->UART17 Transaction7 = %d", num_a2u1_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Number7 of UART07->APB7 Transaction7 = %d", num_u02a_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Number7 of UART17->APB7 Transaction7 = %d", num_u12a_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Total7 Number7 of AHB7, UART7 Transaction7 = %d", num_u02a_wr7 + num_a2u0_wr7 + num_u02a_wr7 + num_a2u0_wr7), UVM_LOW)

    // configure UART07 DUT
    uart_cfg_dut_seq7 = uart_ctrl_config_reg_seq7::type_id::create("uart_cfg_dut_seq7");
    uart_cfg_dut_seq7.reg_model7 = p_sequencer.reg_model_ptr7.uart0_rm7;
    uart_cfg_dut_seq7.start(null);


    // configure UART17 DUT
    uart_cfg_dut_seq7 = uart_ctrl_config_reg_seq7::type_id::create("uart_cfg_dut_seq7");
    uart_cfg_dut_seq7.reg_model7 = p_sequencer.reg_model_ptr7.uart1_rm7;
    uart_cfg_dut_seq7.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == num_a2u0_wr7; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == num_a2u1_wr7; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq7, p_sequencer.uart0_seqr7, {cnt == num_u02a_wr7;})
      `uvm_do_on_with(uart_seq7, p_sequencer.uart1_seqr7, {cnt == num_u12a_wr7;})
    join
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u02a_wr7; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u12a_wr7; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload7

// rand shutdown7 and power7-on
class on_off_seq7 extends uvm_sequence;
  `uvm_object_utils(on_off_seq7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)

  function new(string name = "on_off_seq7");
     super.new(name);
  endfunction

  shutdown_dut7 shut_dut7;
  poweron_dut7 power_dut7;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut7, p_sequencer.ahb_seqr7)
       #4000;
      `uvm_do_on(power_dut7, p_sequencer.ahb_seqr7)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq7


// shutdown7 and power7-on for uart17
class on_off_uart1_seq7 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)

  function new(string name = "on_off_uart1_seq7");
     super.new(name);
  endfunction

  shutdown_dut7 shut_dut7;
  poweron_dut7 power_dut7;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut7, p_sequencer.ahb_seqr7, {write_data7 == 1;})
        #4000;
      `uvm_do_on(power_dut7, p_sequencer.ahb_seqr7)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq7

// lp7 seq, configuration sequence
class lp_shutdown_config7 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr7;
  rand int unsigned num_a2u0_wr7;
  rand int unsigned num_u12a_wr7;
  rand int unsigned num_a2u1_wr7;

  function new(string name="lp_shutdown_config7",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)    

  constraint num_u02a_wr_ct7 {(num_u02a_wr7 > 2) && (num_u02a_wr7 <= 4);}
  constraint num_a2u0_wr_ct7 {(num_a2u0_wr7 == 1);}
  constraint num_u12a_wr_ct7 {(num_u12a_wr7 > 2) && (num_u12a_wr7 <= 4);}
  constraint num_a2u1_wr_ct7 {(num_a2u1_wr7 == 1);}

  // APB7 and UART7 UVC7 sequences
  uart_ctrl_config_reg_seq7 uart_cfg_dut_seq7;
  uart_incr_payload_seq7 uart_seq7;
  intrpt_seq7 rd_rx_fifo7;
  ahb_to_uart_wr7 raw_seq7;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq7", $psprintf("Number7 of APB7->UART07 Transaction7 = %d", num_a2u0_wr7), UVM_LOW);
    `uvm_info("vseq7", $psprintf("Number7 of APB7->UART17 Transaction7 = %d", num_a2u1_wr7), UVM_LOW);
    `uvm_info("vseq7", $psprintf("Number7 of UART07->APB7 Transaction7 = %d", num_u02a_wr7), UVM_LOW);
    `uvm_info("vseq7", $psprintf("Number7 of UART17->APB7 Transaction7 = %d", num_u12a_wr7), UVM_LOW);
    `uvm_info("vseq7", $psprintf("Total7 Number7 of AHB7, UART7 Transaction7 = %d", num_u02a_wr7 + num_a2u0_wr7 + num_u02a_wr7 + num_a2u0_wr7), UVM_LOW);

    // configure UART07 DUT
    uart_cfg_dut_seq7 = uart_ctrl_config_reg_seq7::type_id::create("uart_cfg_dut_seq7");
    uart_cfg_dut_seq7.reg_model7 = p_sequencer.reg_model_ptr7.uart0_rm7;
    uart_cfg_dut_seq7.start(null);


    // configure UART17 DUT
    uart_cfg_dut_seq7 = uart_ctrl_config_reg_seq7::type_id::create("uart_cfg_dut_seq7");
    uart_cfg_dut_seq7.reg_model7 = p_sequencer.reg_model_ptr7.uart1_rm7;
    uart_cfg_dut_seq7.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == num_a2u0_wr7; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == num_a2u1_wr7; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq7, p_sequencer.uart0_seqr7, {cnt == num_u02a_wr7;})
      `uvm_do_on_with(uart_seq7, p_sequencer.uart1_seqr7, {cnt == num_u12a_wr7;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u02a_wr7; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u12a_wr7; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == num_a2u0_wr7; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq7, p_sequencer.uart0_seqr7, {cnt == num_u02a_wr7;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config7

// rand lp7 shutdown7 seq between uart7 1 and smc7
class lp_shutdown_rand7 extends uvm_sequence;

  rand int unsigned num_u02a_wr7;
  rand int unsigned num_a2u0_wr7;
  rand int unsigned num_u12a_wr7;
  rand int unsigned num_a2u1_wr7;

  function new(string name="lp_shutdown_rand7",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)    

  constraint num_u02a_wr_ct7 {(num_u02a_wr7 > 2) && (num_u02a_wr7 <= 4);}
  constraint num_a2u0_wr_ct7 {(num_a2u0_wr7 == 1);}
  constraint num_u12a_wr_ct7 {(num_u12a_wr7 > 2) && (num_u12a_wr7 <= 4);}
  constraint num_a2u1_wr_ct7 {(num_a2u1_wr7 == 1);}


  on_off_seq7 on_off_seq7;
  uart_incr_payload_seq7 uart_seq7;
  intrpt_seq7 rd_rx_fifo7;
  ahb_to_uart_wr7 raw_seq7;
  lp_shutdown_config7 lp_shutdown_config7;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut7 down seq
    `uvm_do(lp_shutdown_config7);
    #20000;
    `uvm_do(on_off_seq7);

    #10000;
    fork
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == num_a2u1_wr7; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq7, p_sequencer.uart1_seqr7, {cnt == num_u12a_wr7;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u02a_wr7; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u12a_wr7; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand7


// sequence for shutting7 down uart7 1 alone7
class lp_shutdown_uart17 extends uvm_sequence;

  rand int unsigned num_u02a_wr7;
  rand int unsigned num_a2u0_wr7;
  rand int unsigned num_u12a_wr7;
  rand int unsigned num_a2u1_wr7;

  function new(string name="lp_shutdown_uart17",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart17)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)    

  constraint num_u02a_wr_ct7 {(num_u02a_wr7 > 2) && (num_u02a_wr7 <= 4);}
  constraint num_a2u0_wr_ct7 {(num_a2u0_wr7 == 1);}
  constraint num_u12a_wr_ct7 {(num_u12a_wr7 > 2) && (num_u12a_wr7 <= 4);}
  constraint num_a2u1_wr_ct7 {(num_a2u1_wr7 == 2);}


  on_off_uart1_seq7 on_off_uart1_seq7;
  uart_incr_payload_seq7 uart_seq7;
  intrpt_seq7 rd_rx_fifo7;
  ahb_to_uart_wr7 raw_seq7;
  lp_shutdown_config7 lp_shutdown_config7;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut7 down seq
    `uvm_do(lp_shutdown_config7);
    #20000;
    `uvm_do(on_off_uart1_seq7);

    #10000;
    fork
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == num_a2u1_wr7; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq7, p_sequencer.uart1_seqr7, {cnt == num_u12a_wr7;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u02a_wr7; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo7, p_sequencer.ahb_seqr7, {num_of_rd7 == num_u12a_wr7; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart17



class apb_spi_incr_payload7 extends uvm_sequence;

  rand int unsigned num_spi2a_wr7;
  rand int unsigned num_a2spi_wr7;

  function new(string name="apb_spi_incr_payload7",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)    

  constraint num_spi2a_wr_ct7 {(num_spi2a_wr7 > 2) && (num_spi2a_wr7 <= 4);}
  constraint num_a2spi_wr_ct7 {(num_a2spi_wr7 == 4);}

  // APB7 and UART7 UVC7 sequences
  spi_cfg_reg_seq7 spi_cfg_dut_seq7;
  spi_incr_payload7 spi_seq7;
  read_spi_rx_reg7 rd_rx_reg7;
  ahb_to_spi_wr7 raw_seq7;
  spi_en_tx_reg_seq7 en_spi_tx_seq7;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq7", $psprintf("Number7 of APB7->SPI7 Transaction7 = %d", num_a2spi_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Number7 of SPI7->APB7 Transaction7 = %d", num_a2spi_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Total7 Number7 of AHB7, SPI7 Transaction7 = %d", 2 * num_a2spi_wr7), UVM_LOW)

    // configure SPI7 DUT
    spi_cfg_dut_seq7 = spi_cfg_reg_seq7::type_id::create("spi_cfg_dut_seq7");
    spi_cfg_dut_seq7.reg_model7 = p_sequencer.reg_model_ptr7.spi_rf7;
    spi_cfg_dut_seq7.start(null);


    for (int i = 0; i < num_a2spi_wr7; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {num_of_wr7 == 1; base_addr == 'h800000;})
            en_spi_tx_seq7 = spi_en_tx_reg_seq7::type_id::create("en_spi_tx_seq7");
            en_spi_tx_seq7.reg_model7 = p_sequencer.reg_model_ptr7.spi_rf7;
            en_spi_tx_seq7.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq7, p_sequencer.spi0_seqr7, {cnt_i7 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg7, p_sequencer.ahb_seqr7, {num_of_rd7 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload7

class apb_gpio_simple_vseq7 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr7;

  function new(string name="apb_gpio_simple_vseq7",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)    

  constraint num_a2gpio_wr_ct7 {(num_a2gpio_wr7 == 4);}

  // APB7 and UART7 UVC7 sequences
  gpio_cfg_reg_seq7 gpio_cfg_dut_seq7;
  gpio_simple_trans_seq7 gpio_seq7;
  read_gpio_rx_reg7 rd_rx_reg7;
  ahb_to_gpio_wr7 raw_seq7;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq7", $psprintf("Number7 of AHB7->GPIO7 Transaction7 = %d", num_a2gpio_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Number7 of GPIO7->APB7 Transaction7 = %d", num_a2gpio_wr7), UVM_LOW)
    `uvm_info("vseq7", $psprintf("Total7 Number7 of AHB7, GPIO7 Transaction7 = %d", 2 * num_a2gpio_wr7), UVM_LOW)

    // configure SPI7 DUT
    gpio_cfg_dut_seq7 = gpio_cfg_reg_seq7::type_id::create("gpio_cfg_dut_seq7");
    gpio_cfg_dut_seq7.reg_model7 = p_sequencer.reg_model_ptr7.gpio_rf7;
    gpio_cfg_dut_seq7.start(null);


    for (int i = 0; i < num_a2gpio_wr7; i++) begin
      `uvm_do_on_with(raw_seq7, p_sequencer.ahb_seqr7, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq7, p_sequencer.gpio0_seqr7)
      `uvm_do_on_with(rd_rx_reg7, p_sequencer.ahb_seqr7, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq7

class apb_subsystem_vseq7 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq7",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq7)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)    

  // APB7 and UART7 UVC7 sequences
  u2a_incr_payload7 apb_to_uart7;
  apb_spi_incr_payload7 apb_to_spi7;
  apb_gpio_simple_vseq7 apb_to_gpio7;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq7", $psprintf("Doing apb_subsystem_vseq7"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart7)
      `uvm_do(apb_to_spi7)
      `uvm_do(apb_to_gpio7)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq7

class apb_ss_cms_seq7 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq7)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer7)

   function new(string name = "apb_ss_cms_seq7");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq7", $psprintf("Starting AHB7 Compliance7 Management7 System7 (CMS7)"), UVM_LOW)
//	   p_sequencer.ahb_seqr7.start_ahb_cms7();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq7
`endif
