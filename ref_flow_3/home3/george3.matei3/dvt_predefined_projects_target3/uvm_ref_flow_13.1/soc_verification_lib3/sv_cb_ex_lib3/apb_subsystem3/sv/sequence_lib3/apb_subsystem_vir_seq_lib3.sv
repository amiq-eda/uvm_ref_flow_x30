/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_vir_seq_lib3.sv
Title3       : Virtual Sequence
Project3     :
Created3     :
Description3 : This3 file implements3 the virtual sequence for the APB3-UART3 env3.
Notes3       : The concurrent_u2a_a2u_rand_trans3 sequence first configures3
            : the UART3 RTL3. Once3 the configuration sequence is completed
            : random read/write sequences from both the UVCs3 are enabled
            : in parallel3. At3 the end a Rx3 FIFO read sequence is executed3.
            : The intrpt_seq3 needs3 to be modified to take3 interrupt3 into account3.
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV3
`define APB_UART_VIRTUAL_SEQ_LIB_SV3

class u2a_incr_payload3 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr3;
  rand int unsigned num_a2u0_wr3;
  rand int unsigned num_u12a_wr3;
  rand int unsigned num_a2u1_wr3;

  function new(string name="u2a_incr_payload3",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)    

  constraint num_u02a_wr_ct3 {(num_u02a_wr3 > 2) && (num_u02a_wr3 <= 4);}
  constraint num_a2u0_wr_ct3 {(num_a2u0_wr3 == 1);}
  constraint num_u12a_wr_ct3 {(num_u12a_wr3 > 2) && (num_u12a_wr3 <= 4);}
  constraint num_a2u1_wr_ct3 {(num_a2u1_wr3 == 1);}

  // APB3 and UART3 UVC3 sequences
  uart_ctrl_config_reg_seq3 uart_cfg_dut_seq3;
  uart_incr_payload_seq3 uart_seq3;
  intrpt_seq3 rd_rx_fifo3;
  ahb_to_uart_wr3 raw_seq3;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq3", $psprintf("Number3 of APB3->UART03 Transaction3 = %d", num_a2u0_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Number3 of APB3->UART13 Transaction3 = %d", num_a2u1_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Number3 of UART03->APB3 Transaction3 = %d", num_u02a_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Number3 of UART13->APB3 Transaction3 = %d", num_u12a_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Total3 Number3 of AHB3, UART3 Transaction3 = %d", num_u02a_wr3 + num_a2u0_wr3 + num_u02a_wr3 + num_a2u0_wr3), UVM_LOW)

    // configure UART03 DUT
    uart_cfg_dut_seq3 = uart_ctrl_config_reg_seq3::type_id::create("uart_cfg_dut_seq3");
    uart_cfg_dut_seq3.reg_model3 = p_sequencer.reg_model_ptr3.uart0_rm3;
    uart_cfg_dut_seq3.start(null);


    // configure UART13 DUT
    uart_cfg_dut_seq3 = uart_ctrl_config_reg_seq3::type_id::create("uart_cfg_dut_seq3");
    uart_cfg_dut_seq3.reg_model3 = p_sequencer.reg_model_ptr3.uart1_rm3;
    uart_cfg_dut_seq3.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == num_a2u0_wr3; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == num_a2u1_wr3; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq3, p_sequencer.uart0_seqr3, {cnt == num_u02a_wr3;})
      `uvm_do_on_with(uart_seq3, p_sequencer.uart1_seqr3, {cnt == num_u12a_wr3;})
    join
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u02a_wr3; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u12a_wr3; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload3

// rand shutdown3 and power3-on
class on_off_seq3 extends uvm_sequence;
  `uvm_object_utils(on_off_seq3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)

  function new(string name = "on_off_seq3");
     super.new(name);
  endfunction

  shutdown_dut3 shut_dut3;
  poweron_dut3 power_dut3;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut3, p_sequencer.ahb_seqr3)
       #4000;
      `uvm_do_on(power_dut3, p_sequencer.ahb_seqr3)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq3


// shutdown3 and power3-on for uart13
class on_off_uart1_seq3 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)

  function new(string name = "on_off_uart1_seq3");
     super.new(name);
  endfunction

  shutdown_dut3 shut_dut3;
  poweron_dut3 power_dut3;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut3, p_sequencer.ahb_seqr3, {write_data3 == 1;})
        #4000;
      `uvm_do_on(power_dut3, p_sequencer.ahb_seqr3)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq3

// lp3 seq, configuration sequence
class lp_shutdown_config3 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr3;
  rand int unsigned num_a2u0_wr3;
  rand int unsigned num_u12a_wr3;
  rand int unsigned num_a2u1_wr3;

  function new(string name="lp_shutdown_config3",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)    

  constraint num_u02a_wr_ct3 {(num_u02a_wr3 > 2) && (num_u02a_wr3 <= 4);}
  constraint num_a2u0_wr_ct3 {(num_a2u0_wr3 == 1);}
  constraint num_u12a_wr_ct3 {(num_u12a_wr3 > 2) && (num_u12a_wr3 <= 4);}
  constraint num_a2u1_wr_ct3 {(num_a2u1_wr3 == 1);}

  // APB3 and UART3 UVC3 sequences
  uart_ctrl_config_reg_seq3 uart_cfg_dut_seq3;
  uart_incr_payload_seq3 uart_seq3;
  intrpt_seq3 rd_rx_fifo3;
  ahb_to_uart_wr3 raw_seq3;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq3", $psprintf("Number3 of APB3->UART03 Transaction3 = %d", num_a2u0_wr3), UVM_LOW);
    `uvm_info("vseq3", $psprintf("Number3 of APB3->UART13 Transaction3 = %d", num_a2u1_wr3), UVM_LOW);
    `uvm_info("vseq3", $psprintf("Number3 of UART03->APB3 Transaction3 = %d", num_u02a_wr3), UVM_LOW);
    `uvm_info("vseq3", $psprintf("Number3 of UART13->APB3 Transaction3 = %d", num_u12a_wr3), UVM_LOW);
    `uvm_info("vseq3", $psprintf("Total3 Number3 of AHB3, UART3 Transaction3 = %d", num_u02a_wr3 + num_a2u0_wr3 + num_u02a_wr3 + num_a2u0_wr3), UVM_LOW);

    // configure UART03 DUT
    uart_cfg_dut_seq3 = uart_ctrl_config_reg_seq3::type_id::create("uart_cfg_dut_seq3");
    uart_cfg_dut_seq3.reg_model3 = p_sequencer.reg_model_ptr3.uart0_rm3;
    uart_cfg_dut_seq3.start(null);


    // configure UART13 DUT
    uart_cfg_dut_seq3 = uart_ctrl_config_reg_seq3::type_id::create("uart_cfg_dut_seq3");
    uart_cfg_dut_seq3.reg_model3 = p_sequencer.reg_model_ptr3.uart1_rm3;
    uart_cfg_dut_seq3.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == num_a2u0_wr3; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == num_a2u1_wr3; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq3, p_sequencer.uart0_seqr3, {cnt == num_u02a_wr3;})
      `uvm_do_on_with(uart_seq3, p_sequencer.uart1_seqr3, {cnt == num_u12a_wr3;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u02a_wr3; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u12a_wr3; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == num_a2u0_wr3; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq3, p_sequencer.uart0_seqr3, {cnt == num_u02a_wr3;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config3

// rand lp3 shutdown3 seq between uart3 1 and smc3
class lp_shutdown_rand3 extends uvm_sequence;

  rand int unsigned num_u02a_wr3;
  rand int unsigned num_a2u0_wr3;
  rand int unsigned num_u12a_wr3;
  rand int unsigned num_a2u1_wr3;

  function new(string name="lp_shutdown_rand3",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)    

  constraint num_u02a_wr_ct3 {(num_u02a_wr3 > 2) && (num_u02a_wr3 <= 4);}
  constraint num_a2u0_wr_ct3 {(num_a2u0_wr3 == 1);}
  constraint num_u12a_wr_ct3 {(num_u12a_wr3 > 2) && (num_u12a_wr3 <= 4);}
  constraint num_a2u1_wr_ct3 {(num_a2u1_wr3 == 1);}


  on_off_seq3 on_off_seq3;
  uart_incr_payload_seq3 uart_seq3;
  intrpt_seq3 rd_rx_fifo3;
  ahb_to_uart_wr3 raw_seq3;
  lp_shutdown_config3 lp_shutdown_config3;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut3 down seq
    `uvm_do(lp_shutdown_config3);
    #20000;
    `uvm_do(on_off_seq3);

    #10000;
    fork
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == num_a2u1_wr3; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq3, p_sequencer.uart1_seqr3, {cnt == num_u12a_wr3;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u02a_wr3; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u12a_wr3; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand3


// sequence for shutting3 down uart3 1 alone3
class lp_shutdown_uart13 extends uvm_sequence;

  rand int unsigned num_u02a_wr3;
  rand int unsigned num_a2u0_wr3;
  rand int unsigned num_u12a_wr3;
  rand int unsigned num_a2u1_wr3;

  function new(string name="lp_shutdown_uart13",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart13)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)    

  constraint num_u02a_wr_ct3 {(num_u02a_wr3 > 2) && (num_u02a_wr3 <= 4);}
  constraint num_a2u0_wr_ct3 {(num_a2u0_wr3 == 1);}
  constraint num_u12a_wr_ct3 {(num_u12a_wr3 > 2) && (num_u12a_wr3 <= 4);}
  constraint num_a2u1_wr_ct3 {(num_a2u1_wr3 == 2);}


  on_off_uart1_seq3 on_off_uart1_seq3;
  uart_incr_payload_seq3 uart_seq3;
  intrpt_seq3 rd_rx_fifo3;
  ahb_to_uart_wr3 raw_seq3;
  lp_shutdown_config3 lp_shutdown_config3;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut3 down seq
    `uvm_do(lp_shutdown_config3);
    #20000;
    `uvm_do(on_off_uart1_seq3);

    #10000;
    fork
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == num_a2u1_wr3; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq3, p_sequencer.uart1_seqr3, {cnt == num_u12a_wr3;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u02a_wr3; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo3, p_sequencer.ahb_seqr3, {num_of_rd3 == num_u12a_wr3; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart13



class apb_spi_incr_payload3 extends uvm_sequence;

  rand int unsigned num_spi2a_wr3;
  rand int unsigned num_a2spi_wr3;

  function new(string name="apb_spi_incr_payload3",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)    

  constraint num_spi2a_wr_ct3 {(num_spi2a_wr3 > 2) && (num_spi2a_wr3 <= 4);}
  constraint num_a2spi_wr_ct3 {(num_a2spi_wr3 == 4);}

  // APB3 and UART3 UVC3 sequences
  spi_cfg_reg_seq3 spi_cfg_dut_seq3;
  spi_incr_payload3 spi_seq3;
  read_spi_rx_reg3 rd_rx_reg3;
  ahb_to_spi_wr3 raw_seq3;
  spi_en_tx_reg_seq3 en_spi_tx_seq3;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq3", $psprintf("Number3 of APB3->SPI3 Transaction3 = %d", num_a2spi_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Number3 of SPI3->APB3 Transaction3 = %d", num_a2spi_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Total3 Number3 of AHB3, SPI3 Transaction3 = %d", 2 * num_a2spi_wr3), UVM_LOW)

    // configure SPI3 DUT
    spi_cfg_dut_seq3 = spi_cfg_reg_seq3::type_id::create("spi_cfg_dut_seq3");
    spi_cfg_dut_seq3.reg_model3 = p_sequencer.reg_model_ptr3.spi_rf3;
    spi_cfg_dut_seq3.start(null);


    for (int i = 0; i < num_a2spi_wr3; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {num_of_wr3 == 1; base_addr == 'h800000;})
            en_spi_tx_seq3 = spi_en_tx_reg_seq3::type_id::create("en_spi_tx_seq3");
            en_spi_tx_seq3.reg_model3 = p_sequencer.reg_model_ptr3.spi_rf3;
            en_spi_tx_seq3.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq3, p_sequencer.spi0_seqr3, {cnt_i3 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg3, p_sequencer.ahb_seqr3, {num_of_rd3 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload3

class apb_gpio_simple_vseq3 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr3;

  function new(string name="apb_gpio_simple_vseq3",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)    

  constraint num_a2gpio_wr_ct3 {(num_a2gpio_wr3 == 4);}

  // APB3 and UART3 UVC3 sequences
  gpio_cfg_reg_seq3 gpio_cfg_dut_seq3;
  gpio_simple_trans_seq3 gpio_seq3;
  read_gpio_rx_reg3 rd_rx_reg3;
  ahb_to_gpio_wr3 raw_seq3;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq3", $psprintf("Number3 of AHB3->GPIO3 Transaction3 = %d", num_a2gpio_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Number3 of GPIO3->APB3 Transaction3 = %d", num_a2gpio_wr3), UVM_LOW)
    `uvm_info("vseq3", $psprintf("Total3 Number3 of AHB3, GPIO3 Transaction3 = %d", 2 * num_a2gpio_wr3), UVM_LOW)

    // configure SPI3 DUT
    gpio_cfg_dut_seq3 = gpio_cfg_reg_seq3::type_id::create("gpio_cfg_dut_seq3");
    gpio_cfg_dut_seq3.reg_model3 = p_sequencer.reg_model_ptr3.gpio_rf3;
    gpio_cfg_dut_seq3.start(null);


    for (int i = 0; i < num_a2gpio_wr3; i++) begin
      `uvm_do_on_with(raw_seq3, p_sequencer.ahb_seqr3, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq3, p_sequencer.gpio0_seqr3)
      `uvm_do_on_with(rd_rx_reg3, p_sequencer.ahb_seqr3, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq3

class apb_subsystem_vseq3 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq3",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq3)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)    

  // APB3 and UART3 UVC3 sequences
  u2a_incr_payload3 apb_to_uart3;
  apb_spi_incr_payload3 apb_to_spi3;
  apb_gpio_simple_vseq3 apb_to_gpio3;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq3", $psprintf("Doing apb_subsystem_vseq3"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart3)
      `uvm_do(apb_to_spi3)
      `uvm_do(apb_to_gpio3)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq3

class apb_ss_cms_seq3 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq3)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer3)

   function new(string name = "apb_ss_cms_seq3");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq3", $psprintf("Starting AHB3 Compliance3 Management3 System3 (CMS3)"), UVM_LOW)
//	   p_sequencer.ahb_seqr3.start_ahb_cms3();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq3
`endif
