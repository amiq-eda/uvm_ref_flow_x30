/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_vir_seq_lib18.sv
Title18       : Virtual Sequence
Project18     :
Created18     :
Description18 : This18 file implements18 the virtual sequence for the APB18-UART18 env18.
Notes18       : The concurrent_u2a_a2u_rand_trans18 sequence first configures18
            : the UART18 RTL18. Once18 the configuration sequence is completed
            : random read/write sequences from both the UVCs18 are enabled
            : in parallel18. At18 the end a Rx18 FIFO read sequence is executed18.
            : The intrpt_seq18 needs18 to be modified to take18 interrupt18 into account18.
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV18
`define APB_UART_VIRTUAL_SEQ_LIB_SV18

class u2a_incr_payload18 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr18;
  rand int unsigned num_a2u0_wr18;
  rand int unsigned num_u12a_wr18;
  rand int unsigned num_a2u1_wr18;

  function new(string name="u2a_incr_payload18",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)    

  constraint num_u02a_wr_ct18 {(num_u02a_wr18 > 2) && (num_u02a_wr18 <= 4);}
  constraint num_a2u0_wr_ct18 {(num_a2u0_wr18 == 1);}
  constraint num_u12a_wr_ct18 {(num_u12a_wr18 > 2) && (num_u12a_wr18 <= 4);}
  constraint num_a2u1_wr_ct18 {(num_a2u1_wr18 == 1);}

  // APB18 and UART18 UVC18 sequences
  uart_ctrl_config_reg_seq18 uart_cfg_dut_seq18;
  uart_incr_payload_seq18 uart_seq18;
  intrpt_seq18 rd_rx_fifo18;
  ahb_to_uart_wr18 raw_seq18;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq18", $psprintf("Number18 of APB18->UART018 Transaction18 = %d", num_a2u0_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Number18 of APB18->UART118 Transaction18 = %d", num_a2u1_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Number18 of UART018->APB18 Transaction18 = %d", num_u02a_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Number18 of UART118->APB18 Transaction18 = %d", num_u12a_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Total18 Number18 of AHB18, UART18 Transaction18 = %d", num_u02a_wr18 + num_a2u0_wr18 + num_u02a_wr18 + num_a2u0_wr18), UVM_LOW)

    // configure UART018 DUT
    uart_cfg_dut_seq18 = uart_ctrl_config_reg_seq18::type_id::create("uart_cfg_dut_seq18");
    uart_cfg_dut_seq18.reg_model18 = p_sequencer.reg_model_ptr18.uart0_rm18;
    uart_cfg_dut_seq18.start(null);


    // configure UART118 DUT
    uart_cfg_dut_seq18 = uart_ctrl_config_reg_seq18::type_id::create("uart_cfg_dut_seq18");
    uart_cfg_dut_seq18.reg_model18 = p_sequencer.reg_model_ptr18.uart1_rm18;
    uart_cfg_dut_seq18.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == num_a2u0_wr18; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == num_a2u1_wr18; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq18, p_sequencer.uart0_seqr18, {cnt == num_u02a_wr18;})
      `uvm_do_on_with(uart_seq18, p_sequencer.uart1_seqr18, {cnt == num_u12a_wr18;})
    join
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u02a_wr18; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u12a_wr18; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload18

// rand shutdown18 and power18-on
class on_off_seq18 extends uvm_sequence;
  `uvm_object_utils(on_off_seq18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)

  function new(string name = "on_off_seq18");
     super.new(name);
  endfunction

  shutdown_dut18 shut_dut18;
  poweron_dut18 power_dut18;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut18, p_sequencer.ahb_seqr18)
       #4000;
      `uvm_do_on(power_dut18, p_sequencer.ahb_seqr18)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq18


// shutdown18 and power18-on for uart118
class on_off_uart1_seq18 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)

  function new(string name = "on_off_uart1_seq18");
     super.new(name);
  endfunction

  shutdown_dut18 shut_dut18;
  poweron_dut18 power_dut18;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut18, p_sequencer.ahb_seqr18, {write_data18 == 1;})
        #4000;
      `uvm_do_on(power_dut18, p_sequencer.ahb_seqr18)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq18

// lp18 seq, configuration sequence
class lp_shutdown_config18 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr18;
  rand int unsigned num_a2u0_wr18;
  rand int unsigned num_u12a_wr18;
  rand int unsigned num_a2u1_wr18;

  function new(string name="lp_shutdown_config18",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)    

  constraint num_u02a_wr_ct18 {(num_u02a_wr18 > 2) && (num_u02a_wr18 <= 4);}
  constraint num_a2u0_wr_ct18 {(num_a2u0_wr18 == 1);}
  constraint num_u12a_wr_ct18 {(num_u12a_wr18 > 2) && (num_u12a_wr18 <= 4);}
  constraint num_a2u1_wr_ct18 {(num_a2u1_wr18 == 1);}

  // APB18 and UART18 UVC18 sequences
  uart_ctrl_config_reg_seq18 uart_cfg_dut_seq18;
  uart_incr_payload_seq18 uart_seq18;
  intrpt_seq18 rd_rx_fifo18;
  ahb_to_uart_wr18 raw_seq18;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq18", $psprintf("Number18 of APB18->UART018 Transaction18 = %d", num_a2u0_wr18), UVM_LOW);
    `uvm_info("vseq18", $psprintf("Number18 of APB18->UART118 Transaction18 = %d", num_a2u1_wr18), UVM_LOW);
    `uvm_info("vseq18", $psprintf("Number18 of UART018->APB18 Transaction18 = %d", num_u02a_wr18), UVM_LOW);
    `uvm_info("vseq18", $psprintf("Number18 of UART118->APB18 Transaction18 = %d", num_u12a_wr18), UVM_LOW);
    `uvm_info("vseq18", $psprintf("Total18 Number18 of AHB18, UART18 Transaction18 = %d", num_u02a_wr18 + num_a2u0_wr18 + num_u02a_wr18 + num_a2u0_wr18), UVM_LOW);

    // configure UART018 DUT
    uart_cfg_dut_seq18 = uart_ctrl_config_reg_seq18::type_id::create("uart_cfg_dut_seq18");
    uart_cfg_dut_seq18.reg_model18 = p_sequencer.reg_model_ptr18.uart0_rm18;
    uart_cfg_dut_seq18.start(null);


    // configure UART118 DUT
    uart_cfg_dut_seq18 = uart_ctrl_config_reg_seq18::type_id::create("uart_cfg_dut_seq18");
    uart_cfg_dut_seq18.reg_model18 = p_sequencer.reg_model_ptr18.uart1_rm18;
    uart_cfg_dut_seq18.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == num_a2u0_wr18; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == num_a2u1_wr18; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq18, p_sequencer.uart0_seqr18, {cnt == num_u02a_wr18;})
      `uvm_do_on_with(uart_seq18, p_sequencer.uart1_seqr18, {cnt == num_u12a_wr18;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u02a_wr18; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u12a_wr18; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == num_a2u0_wr18; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq18, p_sequencer.uart0_seqr18, {cnt == num_u02a_wr18;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config18

// rand lp18 shutdown18 seq between uart18 1 and smc18
class lp_shutdown_rand18 extends uvm_sequence;

  rand int unsigned num_u02a_wr18;
  rand int unsigned num_a2u0_wr18;
  rand int unsigned num_u12a_wr18;
  rand int unsigned num_a2u1_wr18;

  function new(string name="lp_shutdown_rand18",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)    

  constraint num_u02a_wr_ct18 {(num_u02a_wr18 > 2) && (num_u02a_wr18 <= 4);}
  constraint num_a2u0_wr_ct18 {(num_a2u0_wr18 == 1);}
  constraint num_u12a_wr_ct18 {(num_u12a_wr18 > 2) && (num_u12a_wr18 <= 4);}
  constraint num_a2u1_wr_ct18 {(num_a2u1_wr18 == 1);}


  on_off_seq18 on_off_seq18;
  uart_incr_payload_seq18 uart_seq18;
  intrpt_seq18 rd_rx_fifo18;
  ahb_to_uart_wr18 raw_seq18;
  lp_shutdown_config18 lp_shutdown_config18;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut18 down seq
    `uvm_do(lp_shutdown_config18);
    #20000;
    `uvm_do(on_off_seq18);

    #10000;
    fork
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == num_a2u1_wr18; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq18, p_sequencer.uart1_seqr18, {cnt == num_u12a_wr18;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u02a_wr18; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u12a_wr18; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand18


// sequence for shutting18 down uart18 1 alone18
class lp_shutdown_uart118 extends uvm_sequence;

  rand int unsigned num_u02a_wr18;
  rand int unsigned num_a2u0_wr18;
  rand int unsigned num_u12a_wr18;
  rand int unsigned num_a2u1_wr18;

  function new(string name="lp_shutdown_uart118",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart118)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)    

  constraint num_u02a_wr_ct18 {(num_u02a_wr18 > 2) && (num_u02a_wr18 <= 4);}
  constraint num_a2u0_wr_ct18 {(num_a2u0_wr18 == 1);}
  constraint num_u12a_wr_ct18 {(num_u12a_wr18 > 2) && (num_u12a_wr18 <= 4);}
  constraint num_a2u1_wr_ct18 {(num_a2u1_wr18 == 2);}


  on_off_uart1_seq18 on_off_uart1_seq18;
  uart_incr_payload_seq18 uart_seq18;
  intrpt_seq18 rd_rx_fifo18;
  ahb_to_uart_wr18 raw_seq18;
  lp_shutdown_config18 lp_shutdown_config18;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut18 down seq
    `uvm_do(lp_shutdown_config18);
    #20000;
    `uvm_do(on_off_uart1_seq18);

    #10000;
    fork
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == num_a2u1_wr18; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq18, p_sequencer.uart1_seqr18, {cnt == num_u12a_wr18;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u02a_wr18; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo18, p_sequencer.ahb_seqr18, {num_of_rd18 == num_u12a_wr18; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart118



class apb_spi_incr_payload18 extends uvm_sequence;

  rand int unsigned num_spi2a_wr18;
  rand int unsigned num_a2spi_wr18;

  function new(string name="apb_spi_incr_payload18",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)    

  constraint num_spi2a_wr_ct18 {(num_spi2a_wr18 > 2) && (num_spi2a_wr18 <= 4);}
  constraint num_a2spi_wr_ct18 {(num_a2spi_wr18 == 4);}

  // APB18 and UART18 UVC18 sequences
  spi_cfg_reg_seq18 spi_cfg_dut_seq18;
  spi_incr_payload18 spi_seq18;
  read_spi_rx_reg18 rd_rx_reg18;
  ahb_to_spi_wr18 raw_seq18;
  spi_en_tx_reg_seq18 en_spi_tx_seq18;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq18", $psprintf("Number18 of APB18->SPI18 Transaction18 = %d", num_a2spi_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Number18 of SPI18->APB18 Transaction18 = %d", num_a2spi_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Total18 Number18 of AHB18, SPI18 Transaction18 = %d", 2 * num_a2spi_wr18), UVM_LOW)

    // configure SPI18 DUT
    spi_cfg_dut_seq18 = spi_cfg_reg_seq18::type_id::create("spi_cfg_dut_seq18");
    spi_cfg_dut_seq18.reg_model18 = p_sequencer.reg_model_ptr18.spi_rf18;
    spi_cfg_dut_seq18.start(null);


    for (int i = 0; i < num_a2spi_wr18; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {num_of_wr18 == 1; base_addr == 'h800000;})
            en_spi_tx_seq18 = spi_en_tx_reg_seq18::type_id::create("en_spi_tx_seq18");
            en_spi_tx_seq18.reg_model18 = p_sequencer.reg_model_ptr18.spi_rf18;
            en_spi_tx_seq18.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq18, p_sequencer.spi0_seqr18, {cnt_i18 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg18, p_sequencer.ahb_seqr18, {num_of_rd18 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload18

class apb_gpio_simple_vseq18 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr18;

  function new(string name="apb_gpio_simple_vseq18",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)    

  constraint num_a2gpio_wr_ct18 {(num_a2gpio_wr18 == 4);}

  // APB18 and UART18 UVC18 sequences
  gpio_cfg_reg_seq18 gpio_cfg_dut_seq18;
  gpio_simple_trans_seq18 gpio_seq18;
  read_gpio_rx_reg18 rd_rx_reg18;
  ahb_to_gpio_wr18 raw_seq18;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq18", $psprintf("Number18 of AHB18->GPIO18 Transaction18 = %d", num_a2gpio_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Number18 of GPIO18->APB18 Transaction18 = %d", num_a2gpio_wr18), UVM_LOW)
    `uvm_info("vseq18", $psprintf("Total18 Number18 of AHB18, GPIO18 Transaction18 = %d", 2 * num_a2gpio_wr18), UVM_LOW)

    // configure SPI18 DUT
    gpio_cfg_dut_seq18 = gpio_cfg_reg_seq18::type_id::create("gpio_cfg_dut_seq18");
    gpio_cfg_dut_seq18.reg_model18 = p_sequencer.reg_model_ptr18.gpio_rf18;
    gpio_cfg_dut_seq18.start(null);


    for (int i = 0; i < num_a2gpio_wr18; i++) begin
      `uvm_do_on_with(raw_seq18, p_sequencer.ahb_seqr18, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq18, p_sequencer.gpio0_seqr18)
      `uvm_do_on_with(rd_rx_reg18, p_sequencer.ahb_seqr18, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq18

class apb_subsystem_vseq18 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq18",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq18)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)    

  // APB18 and UART18 UVC18 sequences
  u2a_incr_payload18 apb_to_uart18;
  apb_spi_incr_payload18 apb_to_spi18;
  apb_gpio_simple_vseq18 apb_to_gpio18;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq18", $psprintf("Doing apb_subsystem_vseq18"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart18)
      `uvm_do(apb_to_spi18)
      `uvm_do(apb_to_gpio18)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq18

class apb_ss_cms_seq18 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq18)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer18)

   function new(string name = "apb_ss_cms_seq18");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq18", $psprintf("Starting AHB18 Compliance18 Management18 System18 (CMS18)"), UVM_LOW)
//	   p_sequencer.ahb_seqr18.start_ahb_cms18();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq18
`endif
