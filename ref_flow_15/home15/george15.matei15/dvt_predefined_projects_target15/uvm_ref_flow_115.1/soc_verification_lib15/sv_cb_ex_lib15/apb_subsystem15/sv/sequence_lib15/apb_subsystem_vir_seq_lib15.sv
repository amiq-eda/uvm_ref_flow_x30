/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_vir_seq_lib15.sv
Title15       : Virtual Sequence
Project15     :
Created15     :
Description15 : This15 file implements15 the virtual sequence for the APB15-UART15 env15.
Notes15       : The concurrent_u2a_a2u_rand_trans15 sequence first configures15
            : the UART15 RTL15. Once15 the configuration sequence is completed
            : random read/write sequences from both the UVCs15 are enabled
            : in parallel15. At15 the end a Rx15 FIFO read sequence is executed15.
            : The intrpt_seq15 needs15 to be modified to take15 interrupt15 into account15.
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV15
`define APB_UART_VIRTUAL_SEQ_LIB_SV15

class u2a_incr_payload15 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr15;
  rand int unsigned num_a2u0_wr15;
  rand int unsigned num_u12a_wr15;
  rand int unsigned num_a2u1_wr15;

  function new(string name="u2a_incr_payload15",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)    

  constraint num_u02a_wr_ct15 {(num_u02a_wr15 > 2) && (num_u02a_wr15 <= 4);}
  constraint num_a2u0_wr_ct15 {(num_a2u0_wr15 == 1);}
  constraint num_u12a_wr_ct15 {(num_u12a_wr15 > 2) && (num_u12a_wr15 <= 4);}
  constraint num_a2u1_wr_ct15 {(num_a2u1_wr15 == 1);}

  // APB15 and UART15 UVC15 sequences
  uart_ctrl_config_reg_seq15 uart_cfg_dut_seq15;
  uart_incr_payload_seq15 uart_seq15;
  intrpt_seq15 rd_rx_fifo15;
  ahb_to_uart_wr15 raw_seq15;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq15", $psprintf("Number15 of APB15->UART015 Transaction15 = %d", num_a2u0_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Number15 of APB15->UART115 Transaction15 = %d", num_a2u1_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Number15 of UART015->APB15 Transaction15 = %d", num_u02a_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Number15 of UART115->APB15 Transaction15 = %d", num_u12a_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Total15 Number15 of AHB15, UART15 Transaction15 = %d", num_u02a_wr15 + num_a2u0_wr15 + num_u02a_wr15 + num_a2u0_wr15), UVM_LOW)

    // configure UART015 DUT
    uart_cfg_dut_seq15 = uart_ctrl_config_reg_seq15::type_id::create("uart_cfg_dut_seq15");
    uart_cfg_dut_seq15.reg_model15 = p_sequencer.reg_model_ptr15.uart0_rm15;
    uart_cfg_dut_seq15.start(null);


    // configure UART115 DUT
    uart_cfg_dut_seq15 = uart_ctrl_config_reg_seq15::type_id::create("uart_cfg_dut_seq15");
    uart_cfg_dut_seq15.reg_model15 = p_sequencer.reg_model_ptr15.uart1_rm15;
    uart_cfg_dut_seq15.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == num_a2u0_wr15; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == num_a2u1_wr15; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq15, p_sequencer.uart0_seqr15, {cnt == num_u02a_wr15;})
      `uvm_do_on_with(uart_seq15, p_sequencer.uart1_seqr15, {cnt == num_u12a_wr15;})
    join
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u02a_wr15; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u12a_wr15; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload15

// rand shutdown15 and power15-on
class on_off_seq15 extends uvm_sequence;
  `uvm_object_utils(on_off_seq15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)

  function new(string name = "on_off_seq15");
     super.new(name);
  endfunction

  shutdown_dut15 shut_dut15;
  poweron_dut15 power_dut15;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut15, p_sequencer.ahb_seqr15)
       #4000;
      `uvm_do_on(power_dut15, p_sequencer.ahb_seqr15)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq15


// shutdown15 and power15-on for uart115
class on_off_uart1_seq15 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)

  function new(string name = "on_off_uart1_seq15");
     super.new(name);
  endfunction

  shutdown_dut15 shut_dut15;
  poweron_dut15 power_dut15;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut15, p_sequencer.ahb_seqr15, {write_data15 == 1;})
        #4000;
      `uvm_do_on(power_dut15, p_sequencer.ahb_seqr15)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq15

// lp15 seq, configuration sequence
class lp_shutdown_config15 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr15;
  rand int unsigned num_a2u0_wr15;
  rand int unsigned num_u12a_wr15;
  rand int unsigned num_a2u1_wr15;

  function new(string name="lp_shutdown_config15",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)    

  constraint num_u02a_wr_ct15 {(num_u02a_wr15 > 2) && (num_u02a_wr15 <= 4);}
  constraint num_a2u0_wr_ct15 {(num_a2u0_wr15 == 1);}
  constraint num_u12a_wr_ct15 {(num_u12a_wr15 > 2) && (num_u12a_wr15 <= 4);}
  constraint num_a2u1_wr_ct15 {(num_a2u1_wr15 == 1);}

  // APB15 and UART15 UVC15 sequences
  uart_ctrl_config_reg_seq15 uart_cfg_dut_seq15;
  uart_incr_payload_seq15 uart_seq15;
  intrpt_seq15 rd_rx_fifo15;
  ahb_to_uart_wr15 raw_seq15;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq15", $psprintf("Number15 of APB15->UART015 Transaction15 = %d", num_a2u0_wr15), UVM_LOW);
    `uvm_info("vseq15", $psprintf("Number15 of APB15->UART115 Transaction15 = %d", num_a2u1_wr15), UVM_LOW);
    `uvm_info("vseq15", $psprintf("Number15 of UART015->APB15 Transaction15 = %d", num_u02a_wr15), UVM_LOW);
    `uvm_info("vseq15", $psprintf("Number15 of UART115->APB15 Transaction15 = %d", num_u12a_wr15), UVM_LOW);
    `uvm_info("vseq15", $psprintf("Total15 Number15 of AHB15, UART15 Transaction15 = %d", num_u02a_wr15 + num_a2u0_wr15 + num_u02a_wr15 + num_a2u0_wr15), UVM_LOW);

    // configure UART015 DUT
    uart_cfg_dut_seq15 = uart_ctrl_config_reg_seq15::type_id::create("uart_cfg_dut_seq15");
    uart_cfg_dut_seq15.reg_model15 = p_sequencer.reg_model_ptr15.uart0_rm15;
    uart_cfg_dut_seq15.start(null);


    // configure UART115 DUT
    uart_cfg_dut_seq15 = uart_ctrl_config_reg_seq15::type_id::create("uart_cfg_dut_seq15");
    uart_cfg_dut_seq15.reg_model15 = p_sequencer.reg_model_ptr15.uart1_rm15;
    uart_cfg_dut_seq15.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == num_a2u0_wr15; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == num_a2u1_wr15; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq15, p_sequencer.uart0_seqr15, {cnt == num_u02a_wr15;})
      `uvm_do_on_with(uart_seq15, p_sequencer.uart1_seqr15, {cnt == num_u12a_wr15;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u02a_wr15; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u12a_wr15; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == num_a2u0_wr15; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq15, p_sequencer.uart0_seqr15, {cnt == num_u02a_wr15;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config15

// rand lp15 shutdown15 seq between uart15 1 and smc15
class lp_shutdown_rand15 extends uvm_sequence;

  rand int unsigned num_u02a_wr15;
  rand int unsigned num_a2u0_wr15;
  rand int unsigned num_u12a_wr15;
  rand int unsigned num_a2u1_wr15;

  function new(string name="lp_shutdown_rand15",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)    

  constraint num_u02a_wr_ct15 {(num_u02a_wr15 > 2) && (num_u02a_wr15 <= 4);}
  constraint num_a2u0_wr_ct15 {(num_a2u0_wr15 == 1);}
  constraint num_u12a_wr_ct15 {(num_u12a_wr15 > 2) && (num_u12a_wr15 <= 4);}
  constraint num_a2u1_wr_ct15 {(num_a2u1_wr15 == 1);}


  on_off_seq15 on_off_seq15;
  uart_incr_payload_seq15 uart_seq15;
  intrpt_seq15 rd_rx_fifo15;
  ahb_to_uart_wr15 raw_seq15;
  lp_shutdown_config15 lp_shutdown_config15;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut15 down seq
    `uvm_do(lp_shutdown_config15);
    #20000;
    `uvm_do(on_off_seq15);

    #10000;
    fork
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == num_a2u1_wr15; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq15, p_sequencer.uart1_seqr15, {cnt == num_u12a_wr15;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u02a_wr15; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u12a_wr15; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand15


// sequence for shutting15 down uart15 1 alone15
class lp_shutdown_uart115 extends uvm_sequence;

  rand int unsigned num_u02a_wr15;
  rand int unsigned num_a2u0_wr15;
  rand int unsigned num_u12a_wr15;
  rand int unsigned num_a2u1_wr15;

  function new(string name="lp_shutdown_uart115",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart115)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)    

  constraint num_u02a_wr_ct15 {(num_u02a_wr15 > 2) && (num_u02a_wr15 <= 4);}
  constraint num_a2u0_wr_ct15 {(num_a2u0_wr15 == 1);}
  constraint num_u12a_wr_ct15 {(num_u12a_wr15 > 2) && (num_u12a_wr15 <= 4);}
  constraint num_a2u1_wr_ct15 {(num_a2u1_wr15 == 2);}


  on_off_uart1_seq15 on_off_uart1_seq15;
  uart_incr_payload_seq15 uart_seq15;
  intrpt_seq15 rd_rx_fifo15;
  ahb_to_uart_wr15 raw_seq15;
  lp_shutdown_config15 lp_shutdown_config15;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut15 down seq
    `uvm_do(lp_shutdown_config15);
    #20000;
    `uvm_do(on_off_uart1_seq15);

    #10000;
    fork
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == num_a2u1_wr15; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq15, p_sequencer.uart1_seqr15, {cnt == num_u12a_wr15;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u02a_wr15; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo15, p_sequencer.ahb_seqr15, {num_of_rd15 == num_u12a_wr15; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart115



class apb_spi_incr_payload15 extends uvm_sequence;

  rand int unsigned num_spi2a_wr15;
  rand int unsigned num_a2spi_wr15;

  function new(string name="apb_spi_incr_payload15",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)    

  constraint num_spi2a_wr_ct15 {(num_spi2a_wr15 > 2) && (num_spi2a_wr15 <= 4);}
  constraint num_a2spi_wr_ct15 {(num_a2spi_wr15 == 4);}

  // APB15 and UART15 UVC15 sequences
  spi_cfg_reg_seq15 spi_cfg_dut_seq15;
  spi_incr_payload15 spi_seq15;
  read_spi_rx_reg15 rd_rx_reg15;
  ahb_to_spi_wr15 raw_seq15;
  spi_en_tx_reg_seq15 en_spi_tx_seq15;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq15", $psprintf("Number15 of APB15->SPI15 Transaction15 = %d", num_a2spi_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Number15 of SPI15->APB15 Transaction15 = %d", num_a2spi_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Total15 Number15 of AHB15, SPI15 Transaction15 = %d", 2 * num_a2spi_wr15), UVM_LOW)

    // configure SPI15 DUT
    spi_cfg_dut_seq15 = spi_cfg_reg_seq15::type_id::create("spi_cfg_dut_seq15");
    spi_cfg_dut_seq15.reg_model15 = p_sequencer.reg_model_ptr15.spi_rf15;
    spi_cfg_dut_seq15.start(null);


    for (int i = 0; i < num_a2spi_wr15; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {num_of_wr15 == 1; base_addr == 'h800000;})
            en_spi_tx_seq15 = spi_en_tx_reg_seq15::type_id::create("en_spi_tx_seq15");
            en_spi_tx_seq15.reg_model15 = p_sequencer.reg_model_ptr15.spi_rf15;
            en_spi_tx_seq15.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq15, p_sequencer.spi0_seqr15, {cnt_i15 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg15, p_sequencer.ahb_seqr15, {num_of_rd15 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload15

class apb_gpio_simple_vseq15 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr15;

  function new(string name="apb_gpio_simple_vseq15",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)    

  constraint num_a2gpio_wr_ct15 {(num_a2gpio_wr15 == 4);}

  // APB15 and UART15 UVC15 sequences
  gpio_cfg_reg_seq15 gpio_cfg_dut_seq15;
  gpio_simple_trans_seq15 gpio_seq15;
  read_gpio_rx_reg15 rd_rx_reg15;
  ahb_to_gpio_wr15 raw_seq15;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq15", $psprintf("Number15 of AHB15->GPIO15 Transaction15 = %d", num_a2gpio_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Number15 of GPIO15->APB15 Transaction15 = %d", num_a2gpio_wr15), UVM_LOW)
    `uvm_info("vseq15", $psprintf("Total15 Number15 of AHB15, GPIO15 Transaction15 = %d", 2 * num_a2gpio_wr15), UVM_LOW)

    // configure SPI15 DUT
    gpio_cfg_dut_seq15 = gpio_cfg_reg_seq15::type_id::create("gpio_cfg_dut_seq15");
    gpio_cfg_dut_seq15.reg_model15 = p_sequencer.reg_model_ptr15.gpio_rf15;
    gpio_cfg_dut_seq15.start(null);


    for (int i = 0; i < num_a2gpio_wr15; i++) begin
      `uvm_do_on_with(raw_seq15, p_sequencer.ahb_seqr15, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq15, p_sequencer.gpio0_seqr15)
      `uvm_do_on_with(rd_rx_reg15, p_sequencer.ahb_seqr15, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq15

class apb_subsystem_vseq15 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq15",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq15)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)    

  // APB15 and UART15 UVC15 sequences
  u2a_incr_payload15 apb_to_uart15;
  apb_spi_incr_payload15 apb_to_spi15;
  apb_gpio_simple_vseq15 apb_to_gpio15;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq15", $psprintf("Doing apb_subsystem_vseq15"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart15)
      `uvm_do(apb_to_spi15)
      `uvm_do(apb_to_gpio15)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq15

class apb_ss_cms_seq15 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq15)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer15)

   function new(string name = "apb_ss_cms_seq15");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq15", $psprintf("Starting AHB15 Compliance15 Management15 System15 (CMS15)"), UVM_LOW)
//	   p_sequencer.ahb_seqr15.start_ahb_cms15();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq15
`endif
