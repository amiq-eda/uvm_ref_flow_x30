/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_vir_seq_lib11.sv
Title11       : Virtual Sequence
Project11     :
Created11     :
Description11 : This11 file implements11 the virtual sequence for the APB11-UART11 env11.
Notes11       : The concurrent_u2a_a2u_rand_trans11 sequence first configures11
            : the UART11 RTL11. Once11 the configuration sequence is completed
            : random read/write sequences from both the UVCs11 are enabled
            : in parallel11. At11 the end a Rx11 FIFO read sequence is executed11.
            : The intrpt_seq11 needs11 to be modified to take11 interrupt11 into account11.
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV11
`define APB_UART_VIRTUAL_SEQ_LIB_SV11

class u2a_incr_payload11 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr11;
  rand int unsigned num_a2u0_wr11;
  rand int unsigned num_u12a_wr11;
  rand int unsigned num_a2u1_wr11;

  function new(string name="u2a_incr_payload11",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)    

  constraint num_u02a_wr_ct11 {(num_u02a_wr11 > 2) && (num_u02a_wr11 <= 4);}
  constraint num_a2u0_wr_ct11 {(num_a2u0_wr11 == 1);}
  constraint num_u12a_wr_ct11 {(num_u12a_wr11 > 2) && (num_u12a_wr11 <= 4);}
  constraint num_a2u1_wr_ct11 {(num_a2u1_wr11 == 1);}

  // APB11 and UART11 UVC11 sequences
  uart_ctrl_config_reg_seq11 uart_cfg_dut_seq11;
  uart_incr_payload_seq11 uart_seq11;
  intrpt_seq11 rd_rx_fifo11;
  ahb_to_uart_wr11 raw_seq11;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq11", $psprintf("Number11 of APB11->UART011 Transaction11 = %d", num_a2u0_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Number11 of APB11->UART111 Transaction11 = %d", num_a2u1_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Number11 of UART011->APB11 Transaction11 = %d", num_u02a_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Number11 of UART111->APB11 Transaction11 = %d", num_u12a_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Total11 Number11 of AHB11, UART11 Transaction11 = %d", num_u02a_wr11 + num_a2u0_wr11 + num_u02a_wr11 + num_a2u0_wr11), UVM_LOW)

    // configure UART011 DUT
    uart_cfg_dut_seq11 = uart_ctrl_config_reg_seq11::type_id::create("uart_cfg_dut_seq11");
    uart_cfg_dut_seq11.reg_model11 = p_sequencer.reg_model_ptr11.uart0_rm11;
    uart_cfg_dut_seq11.start(null);


    // configure UART111 DUT
    uart_cfg_dut_seq11 = uart_ctrl_config_reg_seq11::type_id::create("uart_cfg_dut_seq11");
    uart_cfg_dut_seq11.reg_model11 = p_sequencer.reg_model_ptr11.uart1_rm11;
    uart_cfg_dut_seq11.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == num_a2u0_wr11; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == num_a2u1_wr11; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq11, p_sequencer.uart0_seqr11, {cnt == num_u02a_wr11;})
      `uvm_do_on_with(uart_seq11, p_sequencer.uart1_seqr11, {cnt == num_u12a_wr11;})
    join
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u02a_wr11; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u12a_wr11; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload11

// rand shutdown11 and power11-on
class on_off_seq11 extends uvm_sequence;
  `uvm_object_utils(on_off_seq11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)

  function new(string name = "on_off_seq11");
     super.new(name);
  endfunction

  shutdown_dut11 shut_dut11;
  poweron_dut11 power_dut11;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut11, p_sequencer.ahb_seqr11)
       #4000;
      `uvm_do_on(power_dut11, p_sequencer.ahb_seqr11)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq11


// shutdown11 and power11-on for uart111
class on_off_uart1_seq11 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)

  function new(string name = "on_off_uart1_seq11");
     super.new(name);
  endfunction

  shutdown_dut11 shut_dut11;
  poweron_dut11 power_dut11;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut11, p_sequencer.ahb_seqr11, {write_data11 == 1;})
        #4000;
      `uvm_do_on(power_dut11, p_sequencer.ahb_seqr11)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq11

// lp11 seq, configuration sequence
class lp_shutdown_config11 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr11;
  rand int unsigned num_a2u0_wr11;
  rand int unsigned num_u12a_wr11;
  rand int unsigned num_a2u1_wr11;

  function new(string name="lp_shutdown_config11",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)    

  constraint num_u02a_wr_ct11 {(num_u02a_wr11 > 2) && (num_u02a_wr11 <= 4);}
  constraint num_a2u0_wr_ct11 {(num_a2u0_wr11 == 1);}
  constraint num_u12a_wr_ct11 {(num_u12a_wr11 > 2) && (num_u12a_wr11 <= 4);}
  constraint num_a2u1_wr_ct11 {(num_a2u1_wr11 == 1);}

  // APB11 and UART11 UVC11 sequences
  uart_ctrl_config_reg_seq11 uart_cfg_dut_seq11;
  uart_incr_payload_seq11 uart_seq11;
  intrpt_seq11 rd_rx_fifo11;
  ahb_to_uart_wr11 raw_seq11;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq11", $psprintf("Number11 of APB11->UART011 Transaction11 = %d", num_a2u0_wr11), UVM_LOW);
    `uvm_info("vseq11", $psprintf("Number11 of APB11->UART111 Transaction11 = %d", num_a2u1_wr11), UVM_LOW);
    `uvm_info("vseq11", $psprintf("Number11 of UART011->APB11 Transaction11 = %d", num_u02a_wr11), UVM_LOW);
    `uvm_info("vseq11", $psprintf("Number11 of UART111->APB11 Transaction11 = %d", num_u12a_wr11), UVM_LOW);
    `uvm_info("vseq11", $psprintf("Total11 Number11 of AHB11, UART11 Transaction11 = %d", num_u02a_wr11 + num_a2u0_wr11 + num_u02a_wr11 + num_a2u0_wr11), UVM_LOW);

    // configure UART011 DUT
    uart_cfg_dut_seq11 = uart_ctrl_config_reg_seq11::type_id::create("uart_cfg_dut_seq11");
    uart_cfg_dut_seq11.reg_model11 = p_sequencer.reg_model_ptr11.uart0_rm11;
    uart_cfg_dut_seq11.start(null);


    // configure UART111 DUT
    uart_cfg_dut_seq11 = uart_ctrl_config_reg_seq11::type_id::create("uart_cfg_dut_seq11");
    uart_cfg_dut_seq11.reg_model11 = p_sequencer.reg_model_ptr11.uart1_rm11;
    uart_cfg_dut_seq11.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == num_a2u0_wr11; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == num_a2u1_wr11; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq11, p_sequencer.uart0_seqr11, {cnt == num_u02a_wr11;})
      `uvm_do_on_with(uart_seq11, p_sequencer.uart1_seqr11, {cnt == num_u12a_wr11;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u02a_wr11; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u12a_wr11; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == num_a2u0_wr11; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq11, p_sequencer.uart0_seqr11, {cnt == num_u02a_wr11;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config11

// rand lp11 shutdown11 seq between uart11 1 and smc11
class lp_shutdown_rand11 extends uvm_sequence;

  rand int unsigned num_u02a_wr11;
  rand int unsigned num_a2u0_wr11;
  rand int unsigned num_u12a_wr11;
  rand int unsigned num_a2u1_wr11;

  function new(string name="lp_shutdown_rand11",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)    

  constraint num_u02a_wr_ct11 {(num_u02a_wr11 > 2) && (num_u02a_wr11 <= 4);}
  constraint num_a2u0_wr_ct11 {(num_a2u0_wr11 == 1);}
  constraint num_u12a_wr_ct11 {(num_u12a_wr11 > 2) && (num_u12a_wr11 <= 4);}
  constraint num_a2u1_wr_ct11 {(num_a2u1_wr11 == 1);}


  on_off_seq11 on_off_seq11;
  uart_incr_payload_seq11 uart_seq11;
  intrpt_seq11 rd_rx_fifo11;
  ahb_to_uart_wr11 raw_seq11;
  lp_shutdown_config11 lp_shutdown_config11;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut11 down seq
    `uvm_do(lp_shutdown_config11);
    #20000;
    `uvm_do(on_off_seq11);

    #10000;
    fork
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == num_a2u1_wr11; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq11, p_sequencer.uart1_seqr11, {cnt == num_u12a_wr11;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u02a_wr11; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u12a_wr11; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand11


// sequence for shutting11 down uart11 1 alone11
class lp_shutdown_uart111 extends uvm_sequence;

  rand int unsigned num_u02a_wr11;
  rand int unsigned num_a2u0_wr11;
  rand int unsigned num_u12a_wr11;
  rand int unsigned num_a2u1_wr11;

  function new(string name="lp_shutdown_uart111",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart111)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)    

  constraint num_u02a_wr_ct11 {(num_u02a_wr11 > 2) && (num_u02a_wr11 <= 4);}
  constraint num_a2u0_wr_ct11 {(num_a2u0_wr11 == 1);}
  constraint num_u12a_wr_ct11 {(num_u12a_wr11 > 2) && (num_u12a_wr11 <= 4);}
  constraint num_a2u1_wr_ct11 {(num_a2u1_wr11 == 2);}


  on_off_uart1_seq11 on_off_uart1_seq11;
  uart_incr_payload_seq11 uart_seq11;
  intrpt_seq11 rd_rx_fifo11;
  ahb_to_uart_wr11 raw_seq11;
  lp_shutdown_config11 lp_shutdown_config11;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut11 down seq
    `uvm_do(lp_shutdown_config11);
    #20000;
    `uvm_do(on_off_uart1_seq11);

    #10000;
    fork
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == num_a2u1_wr11; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq11, p_sequencer.uart1_seqr11, {cnt == num_u12a_wr11;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u02a_wr11; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo11, p_sequencer.ahb_seqr11, {num_of_rd11 == num_u12a_wr11; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart111



class apb_spi_incr_payload11 extends uvm_sequence;

  rand int unsigned num_spi2a_wr11;
  rand int unsigned num_a2spi_wr11;

  function new(string name="apb_spi_incr_payload11",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)    

  constraint num_spi2a_wr_ct11 {(num_spi2a_wr11 > 2) && (num_spi2a_wr11 <= 4);}
  constraint num_a2spi_wr_ct11 {(num_a2spi_wr11 == 4);}

  // APB11 and UART11 UVC11 sequences
  spi_cfg_reg_seq11 spi_cfg_dut_seq11;
  spi_incr_payload11 spi_seq11;
  read_spi_rx_reg11 rd_rx_reg11;
  ahb_to_spi_wr11 raw_seq11;
  spi_en_tx_reg_seq11 en_spi_tx_seq11;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq11", $psprintf("Number11 of APB11->SPI11 Transaction11 = %d", num_a2spi_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Number11 of SPI11->APB11 Transaction11 = %d", num_a2spi_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Total11 Number11 of AHB11, SPI11 Transaction11 = %d", 2 * num_a2spi_wr11), UVM_LOW)

    // configure SPI11 DUT
    spi_cfg_dut_seq11 = spi_cfg_reg_seq11::type_id::create("spi_cfg_dut_seq11");
    spi_cfg_dut_seq11.reg_model11 = p_sequencer.reg_model_ptr11.spi_rf11;
    spi_cfg_dut_seq11.start(null);


    for (int i = 0; i < num_a2spi_wr11; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {num_of_wr11 == 1; base_addr == 'h800000;})
            en_spi_tx_seq11 = spi_en_tx_reg_seq11::type_id::create("en_spi_tx_seq11");
            en_spi_tx_seq11.reg_model11 = p_sequencer.reg_model_ptr11.spi_rf11;
            en_spi_tx_seq11.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq11, p_sequencer.spi0_seqr11, {cnt_i11 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg11, p_sequencer.ahb_seqr11, {num_of_rd11 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload11

class apb_gpio_simple_vseq11 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr11;

  function new(string name="apb_gpio_simple_vseq11",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)    

  constraint num_a2gpio_wr_ct11 {(num_a2gpio_wr11 == 4);}

  // APB11 and UART11 UVC11 sequences
  gpio_cfg_reg_seq11 gpio_cfg_dut_seq11;
  gpio_simple_trans_seq11 gpio_seq11;
  read_gpio_rx_reg11 rd_rx_reg11;
  ahb_to_gpio_wr11 raw_seq11;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq11", $psprintf("Number11 of AHB11->GPIO11 Transaction11 = %d", num_a2gpio_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Number11 of GPIO11->APB11 Transaction11 = %d", num_a2gpio_wr11), UVM_LOW)
    `uvm_info("vseq11", $psprintf("Total11 Number11 of AHB11, GPIO11 Transaction11 = %d", 2 * num_a2gpio_wr11), UVM_LOW)

    // configure SPI11 DUT
    gpio_cfg_dut_seq11 = gpio_cfg_reg_seq11::type_id::create("gpio_cfg_dut_seq11");
    gpio_cfg_dut_seq11.reg_model11 = p_sequencer.reg_model_ptr11.gpio_rf11;
    gpio_cfg_dut_seq11.start(null);


    for (int i = 0; i < num_a2gpio_wr11; i++) begin
      `uvm_do_on_with(raw_seq11, p_sequencer.ahb_seqr11, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq11, p_sequencer.gpio0_seqr11)
      `uvm_do_on_with(rd_rx_reg11, p_sequencer.ahb_seqr11, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq11

class apb_subsystem_vseq11 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq11",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq11)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)    

  // APB11 and UART11 UVC11 sequences
  u2a_incr_payload11 apb_to_uart11;
  apb_spi_incr_payload11 apb_to_spi11;
  apb_gpio_simple_vseq11 apb_to_gpio11;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq11", $psprintf("Doing apb_subsystem_vseq11"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart11)
      `uvm_do(apb_to_spi11)
      `uvm_do(apb_to_gpio11)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq11

class apb_ss_cms_seq11 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq11)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer11)

   function new(string name = "apb_ss_cms_seq11");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq11", $psprintf("Starting AHB11 Compliance11 Management11 System11 (CMS11)"), UVM_LOW)
//	   p_sequencer.ahb_seqr11.start_ahb_cms11();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq11
`endif
