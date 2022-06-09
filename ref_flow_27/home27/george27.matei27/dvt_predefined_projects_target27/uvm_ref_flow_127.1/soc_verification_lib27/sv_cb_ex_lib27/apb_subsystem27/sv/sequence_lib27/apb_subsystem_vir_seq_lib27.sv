/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_vir_seq_lib27.sv
Title27       : Virtual Sequence
Project27     :
Created27     :
Description27 : This27 file implements27 the virtual sequence for the APB27-UART27 env27.
Notes27       : The concurrent_u2a_a2u_rand_trans27 sequence first configures27
            : the UART27 RTL27. Once27 the configuration sequence is completed
            : random read/write sequences from both the UVCs27 are enabled
            : in parallel27. At27 the end a Rx27 FIFO read sequence is executed27.
            : The intrpt_seq27 needs27 to be modified to take27 interrupt27 into account27.
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV27
`define APB_UART_VIRTUAL_SEQ_LIB_SV27

class u2a_incr_payload27 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr27;
  rand int unsigned num_a2u0_wr27;
  rand int unsigned num_u12a_wr27;
  rand int unsigned num_a2u1_wr27;

  function new(string name="u2a_incr_payload27",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)    

  constraint num_u02a_wr_ct27 {(num_u02a_wr27 > 2) && (num_u02a_wr27 <= 4);}
  constraint num_a2u0_wr_ct27 {(num_a2u0_wr27 == 1);}
  constraint num_u12a_wr_ct27 {(num_u12a_wr27 > 2) && (num_u12a_wr27 <= 4);}
  constraint num_a2u1_wr_ct27 {(num_a2u1_wr27 == 1);}

  // APB27 and UART27 UVC27 sequences
  uart_ctrl_config_reg_seq27 uart_cfg_dut_seq27;
  uart_incr_payload_seq27 uart_seq27;
  intrpt_seq27 rd_rx_fifo27;
  ahb_to_uart_wr27 raw_seq27;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq27", $psprintf("Number27 of APB27->UART027 Transaction27 = %d", num_a2u0_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Number27 of APB27->UART127 Transaction27 = %d", num_a2u1_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Number27 of UART027->APB27 Transaction27 = %d", num_u02a_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Number27 of UART127->APB27 Transaction27 = %d", num_u12a_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Total27 Number27 of AHB27, UART27 Transaction27 = %d", num_u02a_wr27 + num_a2u0_wr27 + num_u02a_wr27 + num_a2u0_wr27), UVM_LOW)

    // configure UART027 DUT
    uart_cfg_dut_seq27 = uart_ctrl_config_reg_seq27::type_id::create("uart_cfg_dut_seq27");
    uart_cfg_dut_seq27.reg_model27 = p_sequencer.reg_model_ptr27.uart0_rm27;
    uart_cfg_dut_seq27.start(null);


    // configure UART127 DUT
    uart_cfg_dut_seq27 = uart_ctrl_config_reg_seq27::type_id::create("uart_cfg_dut_seq27");
    uart_cfg_dut_seq27.reg_model27 = p_sequencer.reg_model_ptr27.uart1_rm27;
    uart_cfg_dut_seq27.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == num_a2u0_wr27; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == num_a2u1_wr27; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq27, p_sequencer.uart0_seqr27, {cnt == num_u02a_wr27;})
      `uvm_do_on_with(uart_seq27, p_sequencer.uart1_seqr27, {cnt == num_u12a_wr27;})
    join
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u02a_wr27; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u12a_wr27; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload27

// rand shutdown27 and power27-on
class on_off_seq27 extends uvm_sequence;
  `uvm_object_utils(on_off_seq27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)

  function new(string name = "on_off_seq27");
     super.new(name);
  endfunction

  shutdown_dut27 shut_dut27;
  poweron_dut27 power_dut27;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut27, p_sequencer.ahb_seqr27)
       #4000;
      `uvm_do_on(power_dut27, p_sequencer.ahb_seqr27)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq27


// shutdown27 and power27-on for uart127
class on_off_uart1_seq27 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)

  function new(string name = "on_off_uart1_seq27");
     super.new(name);
  endfunction

  shutdown_dut27 shut_dut27;
  poweron_dut27 power_dut27;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut27, p_sequencer.ahb_seqr27, {write_data27 == 1;})
        #4000;
      `uvm_do_on(power_dut27, p_sequencer.ahb_seqr27)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq27

// lp27 seq, configuration sequence
class lp_shutdown_config27 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr27;
  rand int unsigned num_a2u0_wr27;
  rand int unsigned num_u12a_wr27;
  rand int unsigned num_a2u1_wr27;

  function new(string name="lp_shutdown_config27",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)    

  constraint num_u02a_wr_ct27 {(num_u02a_wr27 > 2) && (num_u02a_wr27 <= 4);}
  constraint num_a2u0_wr_ct27 {(num_a2u0_wr27 == 1);}
  constraint num_u12a_wr_ct27 {(num_u12a_wr27 > 2) && (num_u12a_wr27 <= 4);}
  constraint num_a2u1_wr_ct27 {(num_a2u1_wr27 == 1);}

  // APB27 and UART27 UVC27 sequences
  uart_ctrl_config_reg_seq27 uart_cfg_dut_seq27;
  uart_incr_payload_seq27 uart_seq27;
  intrpt_seq27 rd_rx_fifo27;
  ahb_to_uart_wr27 raw_seq27;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq27", $psprintf("Number27 of APB27->UART027 Transaction27 = %d", num_a2u0_wr27), UVM_LOW);
    `uvm_info("vseq27", $psprintf("Number27 of APB27->UART127 Transaction27 = %d", num_a2u1_wr27), UVM_LOW);
    `uvm_info("vseq27", $psprintf("Number27 of UART027->APB27 Transaction27 = %d", num_u02a_wr27), UVM_LOW);
    `uvm_info("vseq27", $psprintf("Number27 of UART127->APB27 Transaction27 = %d", num_u12a_wr27), UVM_LOW);
    `uvm_info("vseq27", $psprintf("Total27 Number27 of AHB27, UART27 Transaction27 = %d", num_u02a_wr27 + num_a2u0_wr27 + num_u02a_wr27 + num_a2u0_wr27), UVM_LOW);

    // configure UART027 DUT
    uart_cfg_dut_seq27 = uart_ctrl_config_reg_seq27::type_id::create("uart_cfg_dut_seq27");
    uart_cfg_dut_seq27.reg_model27 = p_sequencer.reg_model_ptr27.uart0_rm27;
    uart_cfg_dut_seq27.start(null);


    // configure UART127 DUT
    uart_cfg_dut_seq27 = uart_ctrl_config_reg_seq27::type_id::create("uart_cfg_dut_seq27");
    uart_cfg_dut_seq27.reg_model27 = p_sequencer.reg_model_ptr27.uart1_rm27;
    uart_cfg_dut_seq27.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == num_a2u0_wr27; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == num_a2u1_wr27; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq27, p_sequencer.uart0_seqr27, {cnt == num_u02a_wr27;})
      `uvm_do_on_with(uart_seq27, p_sequencer.uart1_seqr27, {cnt == num_u12a_wr27;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u02a_wr27; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u12a_wr27; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == num_a2u0_wr27; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq27, p_sequencer.uart0_seqr27, {cnt == num_u02a_wr27;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config27

// rand lp27 shutdown27 seq between uart27 1 and smc27
class lp_shutdown_rand27 extends uvm_sequence;

  rand int unsigned num_u02a_wr27;
  rand int unsigned num_a2u0_wr27;
  rand int unsigned num_u12a_wr27;
  rand int unsigned num_a2u1_wr27;

  function new(string name="lp_shutdown_rand27",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)    

  constraint num_u02a_wr_ct27 {(num_u02a_wr27 > 2) && (num_u02a_wr27 <= 4);}
  constraint num_a2u0_wr_ct27 {(num_a2u0_wr27 == 1);}
  constraint num_u12a_wr_ct27 {(num_u12a_wr27 > 2) && (num_u12a_wr27 <= 4);}
  constraint num_a2u1_wr_ct27 {(num_a2u1_wr27 == 1);}


  on_off_seq27 on_off_seq27;
  uart_incr_payload_seq27 uart_seq27;
  intrpt_seq27 rd_rx_fifo27;
  ahb_to_uart_wr27 raw_seq27;
  lp_shutdown_config27 lp_shutdown_config27;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut27 down seq
    `uvm_do(lp_shutdown_config27);
    #20000;
    `uvm_do(on_off_seq27);

    #10000;
    fork
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == num_a2u1_wr27; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq27, p_sequencer.uart1_seqr27, {cnt == num_u12a_wr27;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u02a_wr27; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u12a_wr27; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand27


// sequence for shutting27 down uart27 1 alone27
class lp_shutdown_uart127 extends uvm_sequence;

  rand int unsigned num_u02a_wr27;
  rand int unsigned num_a2u0_wr27;
  rand int unsigned num_u12a_wr27;
  rand int unsigned num_a2u1_wr27;

  function new(string name="lp_shutdown_uart127",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart127)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)    

  constraint num_u02a_wr_ct27 {(num_u02a_wr27 > 2) && (num_u02a_wr27 <= 4);}
  constraint num_a2u0_wr_ct27 {(num_a2u0_wr27 == 1);}
  constraint num_u12a_wr_ct27 {(num_u12a_wr27 > 2) && (num_u12a_wr27 <= 4);}
  constraint num_a2u1_wr_ct27 {(num_a2u1_wr27 == 2);}


  on_off_uart1_seq27 on_off_uart1_seq27;
  uart_incr_payload_seq27 uart_seq27;
  intrpt_seq27 rd_rx_fifo27;
  ahb_to_uart_wr27 raw_seq27;
  lp_shutdown_config27 lp_shutdown_config27;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut27 down seq
    `uvm_do(lp_shutdown_config27);
    #20000;
    `uvm_do(on_off_uart1_seq27);

    #10000;
    fork
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == num_a2u1_wr27; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq27, p_sequencer.uart1_seqr27, {cnt == num_u12a_wr27;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u02a_wr27; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo27, p_sequencer.ahb_seqr27, {num_of_rd27 == num_u12a_wr27; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart127



class apb_spi_incr_payload27 extends uvm_sequence;

  rand int unsigned num_spi2a_wr27;
  rand int unsigned num_a2spi_wr27;

  function new(string name="apb_spi_incr_payload27",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)    

  constraint num_spi2a_wr_ct27 {(num_spi2a_wr27 > 2) && (num_spi2a_wr27 <= 4);}
  constraint num_a2spi_wr_ct27 {(num_a2spi_wr27 == 4);}

  // APB27 and UART27 UVC27 sequences
  spi_cfg_reg_seq27 spi_cfg_dut_seq27;
  spi_incr_payload27 spi_seq27;
  read_spi_rx_reg27 rd_rx_reg27;
  ahb_to_spi_wr27 raw_seq27;
  spi_en_tx_reg_seq27 en_spi_tx_seq27;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq27", $psprintf("Number27 of APB27->SPI27 Transaction27 = %d", num_a2spi_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Number27 of SPI27->APB27 Transaction27 = %d", num_a2spi_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Total27 Number27 of AHB27, SPI27 Transaction27 = %d", 2 * num_a2spi_wr27), UVM_LOW)

    // configure SPI27 DUT
    spi_cfg_dut_seq27 = spi_cfg_reg_seq27::type_id::create("spi_cfg_dut_seq27");
    spi_cfg_dut_seq27.reg_model27 = p_sequencer.reg_model_ptr27.spi_rf27;
    spi_cfg_dut_seq27.start(null);


    for (int i = 0; i < num_a2spi_wr27; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {num_of_wr27 == 1; base_addr == 'h800000;})
            en_spi_tx_seq27 = spi_en_tx_reg_seq27::type_id::create("en_spi_tx_seq27");
            en_spi_tx_seq27.reg_model27 = p_sequencer.reg_model_ptr27.spi_rf27;
            en_spi_tx_seq27.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq27, p_sequencer.spi0_seqr27, {cnt_i27 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg27, p_sequencer.ahb_seqr27, {num_of_rd27 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload27

class apb_gpio_simple_vseq27 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr27;

  function new(string name="apb_gpio_simple_vseq27",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)    

  constraint num_a2gpio_wr_ct27 {(num_a2gpio_wr27 == 4);}

  // APB27 and UART27 UVC27 sequences
  gpio_cfg_reg_seq27 gpio_cfg_dut_seq27;
  gpio_simple_trans_seq27 gpio_seq27;
  read_gpio_rx_reg27 rd_rx_reg27;
  ahb_to_gpio_wr27 raw_seq27;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq27", $psprintf("Number27 of AHB27->GPIO27 Transaction27 = %d", num_a2gpio_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Number27 of GPIO27->APB27 Transaction27 = %d", num_a2gpio_wr27), UVM_LOW)
    `uvm_info("vseq27", $psprintf("Total27 Number27 of AHB27, GPIO27 Transaction27 = %d", 2 * num_a2gpio_wr27), UVM_LOW)

    // configure SPI27 DUT
    gpio_cfg_dut_seq27 = gpio_cfg_reg_seq27::type_id::create("gpio_cfg_dut_seq27");
    gpio_cfg_dut_seq27.reg_model27 = p_sequencer.reg_model_ptr27.gpio_rf27;
    gpio_cfg_dut_seq27.start(null);


    for (int i = 0; i < num_a2gpio_wr27; i++) begin
      `uvm_do_on_with(raw_seq27, p_sequencer.ahb_seqr27, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq27, p_sequencer.gpio0_seqr27)
      `uvm_do_on_with(rd_rx_reg27, p_sequencer.ahb_seqr27, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq27

class apb_subsystem_vseq27 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq27",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq27)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)    

  // APB27 and UART27 UVC27 sequences
  u2a_incr_payload27 apb_to_uart27;
  apb_spi_incr_payload27 apb_to_spi27;
  apb_gpio_simple_vseq27 apb_to_gpio27;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq27", $psprintf("Doing apb_subsystem_vseq27"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart27)
      `uvm_do(apb_to_spi27)
      `uvm_do(apb_to_gpio27)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq27

class apb_ss_cms_seq27 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq27)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer27)

   function new(string name = "apb_ss_cms_seq27");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq27", $psprintf("Starting AHB27 Compliance27 Management27 System27 (CMS27)"), UVM_LOW)
//	   p_sequencer.ahb_seqr27.start_ahb_cms27();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq27
`endif
