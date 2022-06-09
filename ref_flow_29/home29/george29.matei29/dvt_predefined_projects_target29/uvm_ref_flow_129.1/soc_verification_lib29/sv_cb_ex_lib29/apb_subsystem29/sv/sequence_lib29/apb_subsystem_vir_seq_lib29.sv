/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_vir_seq_lib29.sv
Title29       : Virtual Sequence
Project29     :
Created29     :
Description29 : This29 file implements29 the virtual sequence for the APB29-UART29 env29.
Notes29       : The concurrent_u2a_a2u_rand_trans29 sequence first configures29
            : the UART29 RTL29. Once29 the configuration sequence is completed
            : random read/write sequences from both the UVCs29 are enabled
            : in parallel29. At29 the end a Rx29 FIFO read sequence is executed29.
            : The intrpt_seq29 needs29 to be modified to take29 interrupt29 into account29.
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV29
`define APB_UART_VIRTUAL_SEQ_LIB_SV29

class u2a_incr_payload29 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr29;
  rand int unsigned num_a2u0_wr29;
  rand int unsigned num_u12a_wr29;
  rand int unsigned num_a2u1_wr29;

  function new(string name="u2a_incr_payload29",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)    

  constraint num_u02a_wr_ct29 {(num_u02a_wr29 > 2) && (num_u02a_wr29 <= 4);}
  constraint num_a2u0_wr_ct29 {(num_a2u0_wr29 == 1);}
  constraint num_u12a_wr_ct29 {(num_u12a_wr29 > 2) && (num_u12a_wr29 <= 4);}
  constraint num_a2u1_wr_ct29 {(num_a2u1_wr29 == 1);}

  // APB29 and UART29 UVC29 sequences
  uart_ctrl_config_reg_seq29 uart_cfg_dut_seq29;
  uart_incr_payload_seq29 uart_seq29;
  intrpt_seq29 rd_rx_fifo29;
  ahb_to_uart_wr29 raw_seq29;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq29", $psprintf("Number29 of APB29->UART029 Transaction29 = %d", num_a2u0_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Number29 of APB29->UART129 Transaction29 = %d", num_a2u1_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Number29 of UART029->APB29 Transaction29 = %d", num_u02a_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Number29 of UART129->APB29 Transaction29 = %d", num_u12a_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Total29 Number29 of AHB29, UART29 Transaction29 = %d", num_u02a_wr29 + num_a2u0_wr29 + num_u02a_wr29 + num_a2u0_wr29), UVM_LOW)

    // configure UART029 DUT
    uart_cfg_dut_seq29 = uart_ctrl_config_reg_seq29::type_id::create("uart_cfg_dut_seq29");
    uart_cfg_dut_seq29.reg_model29 = p_sequencer.reg_model_ptr29.uart0_rm29;
    uart_cfg_dut_seq29.start(null);


    // configure UART129 DUT
    uart_cfg_dut_seq29 = uart_ctrl_config_reg_seq29::type_id::create("uart_cfg_dut_seq29");
    uart_cfg_dut_seq29.reg_model29 = p_sequencer.reg_model_ptr29.uart1_rm29;
    uart_cfg_dut_seq29.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == num_a2u0_wr29; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == num_a2u1_wr29; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq29, p_sequencer.uart0_seqr29, {cnt == num_u02a_wr29;})
      `uvm_do_on_with(uart_seq29, p_sequencer.uart1_seqr29, {cnt == num_u12a_wr29;})
    join
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u02a_wr29; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u12a_wr29; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload29

// rand shutdown29 and power29-on
class on_off_seq29 extends uvm_sequence;
  `uvm_object_utils(on_off_seq29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)

  function new(string name = "on_off_seq29");
     super.new(name);
  endfunction

  shutdown_dut29 shut_dut29;
  poweron_dut29 power_dut29;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut29, p_sequencer.ahb_seqr29)
       #4000;
      `uvm_do_on(power_dut29, p_sequencer.ahb_seqr29)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq29


// shutdown29 and power29-on for uart129
class on_off_uart1_seq29 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)

  function new(string name = "on_off_uart1_seq29");
     super.new(name);
  endfunction

  shutdown_dut29 shut_dut29;
  poweron_dut29 power_dut29;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut29, p_sequencer.ahb_seqr29, {write_data29 == 1;})
        #4000;
      `uvm_do_on(power_dut29, p_sequencer.ahb_seqr29)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq29

// lp29 seq, configuration sequence
class lp_shutdown_config29 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr29;
  rand int unsigned num_a2u0_wr29;
  rand int unsigned num_u12a_wr29;
  rand int unsigned num_a2u1_wr29;

  function new(string name="lp_shutdown_config29",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)    

  constraint num_u02a_wr_ct29 {(num_u02a_wr29 > 2) && (num_u02a_wr29 <= 4);}
  constraint num_a2u0_wr_ct29 {(num_a2u0_wr29 == 1);}
  constraint num_u12a_wr_ct29 {(num_u12a_wr29 > 2) && (num_u12a_wr29 <= 4);}
  constraint num_a2u1_wr_ct29 {(num_a2u1_wr29 == 1);}

  // APB29 and UART29 UVC29 sequences
  uart_ctrl_config_reg_seq29 uart_cfg_dut_seq29;
  uart_incr_payload_seq29 uart_seq29;
  intrpt_seq29 rd_rx_fifo29;
  ahb_to_uart_wr29 raw_seq29;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq29", $psprintf("Number29 of APB29->UART029 Transaction29 = %d", num_a2u0_wr29), UVM_LOW);
    `uvm_info("vseq29", $psprintf("Number29 of APB29->UART129 Transaction29 = %d", num_a2u1_wr29), UVM_LOW);
    `uvm_info("vseq29", $psprintf("Number29 of UART029->APB29 Transaction29 = %d", num_u02a_wr29), UVM_LOW);
    `uvm_info("vseq29", $psprintf("Number29 of UART129->APB29 Transaction29 = %d", num_u12a_wr29), UVM_LOW);
    `uvm_info("vseq29", $psprintf("Total29 Number29 of AHB29, UART29 Transaction29 = %d", num_u02a_wr29 + num_a2u0_wr29 + num_u02a_wr29 + num_a2u0_wr29), UVM_LOW);

    // configure UART029 DUT
    uart_cfg_dut_seq29 = uart_ctrl_config_reg_seq29::type_id::create("uart_cfg_dut_seq29");
    uart_cfg_dut_seq29.reg_model29 = p_sequencer.reg_model_ptr29.uart0_rm29;
    uart_cfg_dut_seq29.start(null);


    // configure UART129 DUT
    uart_cfg_dut_seq29 = uart_ctrl_config_reg_seq29::type_id::create("uart_cfg_dut_seq29");
    uart_cfg_dut_seq29.reg_model29 = p_sequencer.reg_model_ptr29.uart1_rm29;
    uart_cfg_dut_seq29.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == num_a2u0_wr29; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == num_a2u1_wr29; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq29, p_sequencer.uart0_seqr29, {cnt == num_u02a_wr29;})
      `uvm_do_on_with(uart_seq29, p_sequencer.uart1_seqr29, {cnt == num_u12a_wr29;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u02a_wr29; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u12a_wr29; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == num_a2u0_wr29; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq29, p_sequencer.uart0_seqr29, {cnt == num_u02a_wr29;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config29

// rand lp29 shutdown29 seq between uart29 1 and smc29
class lp_shutdown_rand29 extends uvm_sequence;

  rand int unsigned num_u02a_wr29;
  rand int unsigned num_a2u0_wr29;
  rand int unsigned num_u12a_wr29;
  rand int unsigned num_a2u1_wr29;

  function new(string name="lp_shutdown_rand29",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)    

  constraint num_u02a_wr_ct29 {(num_u02a_wr29 > 2) && (num_u02a_wr29 <= 4);}
  constraint num_a2u0_wr_ct29 {(num_a2u0_wr29 == 1);}
  constraint num_u12a_wr_ct29 {(num_u12a_wr29 > 2) && (num_u12a_wr29 <= 4);}
  constraint num_a2u1_wr_ct29 {(num_a2u1_wr29 == 1);}


  on_off_seq29 on_off_seq29;
  uart_incr_payload_seq29 uart_seq29;
  intrpt_seq29 rd_rx_fifo29;
  ahb_to_uart_wr29 raw_seq29;
  lp_shutdown_config29 lp_shutdown_config29;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut29 down seq
    `uvm_do(lp_shutdown_config29);
    #20000;
    `uvm_do(on_off_seq29);

    #10000;
    fork
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == num_a2u1_wr29; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq29, p_sequencer.uart1_seqr29, {cnt == num_u12a_wr29;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u02a_wr29; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u12a_wr29; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand29


// sequence for shutting29 down uart29 1 alone29
class lp_shutdown_uart129 extends uvm_sequence;

  rand int unsigned num_u02a_wr29;
  rand int unsigned num_a2u0_wr29;
  rand int unsigned num_u12a_wr29;
  rand int unsigned num_a2u1_wr29;

  function new(string name="lp_shutdown_uart129",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart129)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)    

  constraint num_u02a_wr_ct29 {(num_u02a_wr29 > 2) && (num_u02a_wr29 <= 4);}
  constraint num_a2u0_wr_ct29 {(num_a2u0_wr29 == 1);}
  constraint num_u12a_wr_ct29 {(num_u12a_wr29 > 2) && (num_u12a_wr29 <= 4);}
  constraint num_a2u1_wr_ct29 {(num_a2u1_wr29 == 2);}


  on_off_uart1_seq29 on_off_uart1_seq29;
  uart_incr_payload_seq29 uart_seq29;
  intrpt_seq29 rd_rx_fifo29;
  ahb_to_uart_wr29 raw_seq29;
  lp_shutdown_config29 lp_shutdown_config29;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut29 down seq
    `uvm_do(lp_shutdown_config29);
    #20000;
    `uvm_do(on_off_uart1_seq29);

    #10000;
    fork
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == num_a2u1_wr29; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq29, p_sequencer.uart1_seqr29, {cnt == num_u12a_wr29;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u02a_wr29; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo29, p_sequencer.ahb_seqr29, {num_of_rd29 == num_u12a_wr29; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart129



class apb_spi_incr_payload29 extends uvm_sequence;

  rand int unsigned num_spi2a_wr29;
  rand int unsigned num_a2spi_wr29;

  function new(string name="apb_spi_incr_payload29",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)    

  constraint num_spi2a_wr_ct29 {(num_spi2a_wr29 > 2) && (num_spi2a_wr29 <= 4);}
  constraint num_a2spi_wr_ct29 {(num_a2spi_wr29 == 4);}

  // APB29 and UART29 UVC29 sequences
  spi_cfg_reg_seq29 spi_cfg_dut_seq29;
  spi_incr_payload29 spi_seq29;
  read_spi_rx_reg29 rd_rx_reg29;
  ahb_to_spi_wr29 raw_seq29;
  spi_en_tx_reg_seq29 en_spi_tx_seq29;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq29", $psprintf("Number29 of APB29->SPI29 Transaction29 = %d", num_a2spi_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Number29 of SPI29->APB29 Transaction29 = %d", num_a2spi_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Total29 Number29 of AHB29, SPI29 Transaction29 = %d", 2 * num_a2spi_wr29), UVM_LOW)

    // configure SPI29 DUT
    spi_cfg_dut_seq29 = spi_cfg_reg_seq29::type_id::create("spi_cfg_dut_seq29");
    spi_cfg_dut_seq29.reg_model29 = p_sequencer.reg_model_ptr29.spi_rf29;
    spi_cfg_dut_seq29.start(null);


    for (int i = 0; i < num_a2spi_wr29; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {num_of_wr29 == 1; base_addr == 'h800000;})
            en_spi_tx_seq29 = spi_en_tx_reg_seq29::type_id::create("en_spi_tx_seq29");
            en_spi_tx_seq29.reg_model29 = p_sequencer.reg_model_ptr29.spi_rf29;
            en_spi_tx_seq29.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq29, p_sequencer.spi0_seqr29, {cnt_i29 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg29, p_sequencer.ahb_seqr29, {num_of_rd29 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload29

class apb_gpio_simple_vseq29 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr29;

  function new(string name="apb_gpio_simple_vseq29",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)    

  constraint num_a2gpio_wr_ct29 {(num_a2gpio_wr29 == 4);}

  // APB29 and UART29 UVC29 sequences
  gpio_cfg_reg_seq29 gpio_cfg_dut_seq29;
  gpio_simple_trans_seq29 gpio_seq29;
  read_gpio_rx_reg29 rd_rx_reg29;
  ahb_to_gpio_wr29 raw_seq29;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq29", $psprintf("Number29 of AHB29->GPIO29 Transaction29 = %d", num_a2gpio_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Number29 of GPIO29->APB29 Transaction29 = %d", num_a2gpio_wr29), UVM_LOW)
    `uvm_info("vseq29", $psprintf("Total29 Number29 of AHB29, GPIO29 Transaction29 = %d", 2 * num_a2gpio_wr29), UVM_LOW)

    // configure SPI29 DUT
    gpio_cfg_dut_seq29 = gpio_cfg_reg_seq29::type_id::create("gpio_cfg_dut_seq29");
    gpio_cfg_dut_seq29.reg_model29 = p_sequencer.reg_model_ptr29.gpio_rf29;
    gpio_cfg_dut_seq29.start(null);


    for (int i = 0; i < num_a2gpio_wr29; i++) begin
      `uvm_do_on_with(raw_seq29, p_sequencer.ahb_seqr29, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq29, p_sequencer.gpio0_seqr29)
      `uvm_do_on_with(rd_rx_reg29, p_sequencer.ahb_seqr29, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq29

class apb_subsystem_vseq29 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq29",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq29)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)    

  // APB29 and UART29 UVC29 sequences
  u2a_incr_payload29 apb_to_uart29;
  apb_spi_incr_payload29 apb_to_spi29;
  apb_gpio_simple_vseq29 apb_to_gpio29;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq29", $psprintf("Doing apb_subsystem_vseq29"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart29)
      `uvm_do(apb_to_spi29)
      `uvm_do(apb_to_gpio29)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq29

class apb_ss_cms_seq29 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq29)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer29)

   function new(string name = "apb_ss_cms_seq29");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq29", $psprintf("Starting AHB29 Compliance29 Management29 System29 (CMS29)"), UVM_LOW)
//	   p_sequencer.ahb_seqr29.start_ahb_cms29();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq29
`endif
