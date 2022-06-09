/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_vir_seq_lib30.sv
Title30       : Virtual Sequence
Project30     :
Created30     :
Description30 : This30 file implements30 the virtual sequence for the APB30-UART30 env30.
Notes30       : The concurrent_u2a_a2u_rand_trans30 sequence first configures30
            : the UART30 RTL30. Once30 the configuration sequence is completed
            : random read/write sequences from both the UVCs30 are enabled
            : in parallel30. At30 the end a Rx30 FIFO read sequence is executed30.
            : The intrpt_seq30 needs30 to be modified to take30 interrupt30 into account30.
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV30
`define APB_UART_VIRTUAL_SEQ_LIB_SV30

class u2a_incr_payload30 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr30;
  rand int unsigned num_a2u0_wr30;
  rand int unsigned num_u12a_wr30;
  rand int unsigned num_a2u1_wr30;

  function new(string name="u2a_incr_payload30",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)    

  constraint num_u02a_wr_ct30 {(num_u02a_wr30 > 2) && (num_u02a_wr30 <= 4);}
  constraint num_a2u0_wr_ct30 {(num_a2u0_wr30 == 1);}
  constraint num_u12a_wr_ct30 {(num_u12a_wr30 > 2) && (num_u12a_wr30 <= 4);}
  constraint num_a2u1_wr_ct30 {(num_a2u1_wr30 == 1);}

  // APB30 and UART30 UVC30 sequences
  uart_ctrl_config_reg_seq30 uart_cfg_dut_seq30;
  uart_incr_payload_seq30 uart_seq30;
  intrpt_seq30 rd_rx_fifo30;
  ahb_to_uart_wr30 raw_seq30;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq30", $psprintf("Number30 of APB30->UART030 Transaction30 = %d", num_a2u0_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Number30 of APB30->UART130 Transaction30 = %d", num_a2u1_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Number30 of UART030->APB30 Transaction30 = %d", num_u02a_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Number30 of UART130->APB30 Transaction30 = %d", num_u12a_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Total30 Number30 of AHB30, UART30 Transaction30 = %d", num_u02a_wr30 + num_a2u0_wr30 + num_u02a_wr30 + num_a2u0_wr30), UVM_LOW)

    // configure UART030 DUT
    uart_cfg_dut_seq30 = uart_ctrl_config_reg_seq30::type_id::create("uart_cfg_dut_seq30");
    uart_cfg_dut_seq30.reg_model30 = p_sequencer.reg_model_ptr30.uart0_rm30;
    uart_cfg_dut_seq30.start(null);


    // configure UART130 DUT
    uart_cfg_dut_seq30 = uart_ctrl_config_reg_seq30::type_id::create("uart_cfg_dut_seq30");
    uart_cfg_dut_seq30.reg_model30 = p_sequencer.reg_model_ptr30.uart1_rm30;
    uart_cfg_dut_seq30.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == num_a2u0_wr30; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == num_a2u1_wr30; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq30, p_sequencer.uart0_seqr30, {cnt == num_u02a_wr30;})
      `uvm_do_on_with(uart_seq30, p_sequencer.uart1_seqr30, {cnt == num_u12a_wr30;})
    join
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u02a_wr30; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u12a_wr30; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload30

// rand shutdown30 and power30-on
class on_off_seq30 extends uvm_sequence;
  `uvm_object_utils(on_off_seq30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)

  function new(string name = "on_off_seq30");
     super.new(name);
  endfunction

  shutdown_dut30 shut_dut30;
  poweron_dut30 power_dut30;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut30, p_sequencer.ahb_seqr30)
       #4000;
      `uvm_do_on(power_dut30, p_sequencer.ahb_seqr30)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq30


// shutdown30 and power30-on for uart130
class on_off_uart1_seq30 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)

  function new(string name = "on_off_uart1_seq30");
     super.new(name);
  endfunction

  shutdown_dut30 shut_dut30;
  poweron_dut30 power_dut30;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut30, p_sequencer.ahb_seqr30, {write_data30 == 1;})
        #4000;
      `uvm_do_on(power_dut30, p_sequencer.ahb_seqr30)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq30

// lp30 seq, configuration sequence
class lp_shutdown_config30 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr30;
  rand int unsigned num_a2u0_wr30;
  rand int unsigned num_u12a_wr30;
  rand int unsigned num_a2u1_wr30;

  function new(string name="lp_shutdown_config30",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)    

  constraint num_u02a_wr_ct30 {(num_u02a_wr30 > 2) && (num_u02a_wr30 <= 4);}
  constraint num_a2u0_wr_ct30 {(num_a2u0_wr30 == 1);}
  constraint num_u12a_wr_ct30 {(num_u12a_wr30 > 2) && (num_u12a_wr30 <= 4);}
  constraint num_a2u1_wr_ct30 {(num_a2u1_wr30 == 1);}

  // APB30 and UART30 UVC30 sequences
  uart_ctrl_config_reg_seq30 uart_cfg_dut_seq30;
  uart_incr_payload_seq30 uart_seq30;
  intrpt_seq30 rd_rx_fifo30;
  ahb_to_uart_wr30 raw_seq30;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq30", $psprintf("Number30 of APB30->UART030 Transaction30 = %d", num_a2u0_wr30), UVM_LOW);
    `uvm_info("vseq30", $psprintf("Number30 of APB30->UART130 Transaction30 = %d", num_a2u1_wr30), UVM_LOW);
    `uvm_info("vseq30", $psprintf("Number30 of UART030->APB30 Transaction30 = %d", num_u02a_wr30), UVM_LOW);
    `uvm_info("vseq30", $psprintf("Number30 of UART130->APB30 Transaction30 = %d", num_u12a_wr30), UVM_LOW);
    `uvm_info("vseq30", $psprintf("Total30 Number30 of AHB30, UART30 Transaction30 = %d", num_u02a_wr30 + num_a2u0_wr30 + num_u02a_wr30 + num_a2u0_wr30), UVM_LOW);

    // configure UART030 DUT
    uart_cfg_dut_seq30 = uart_ctrl_config_reg_seq30::type_id::create("uart_cfg_dut_seq30");
    uart_cfg_dut_seq30.reg_model30 = p_sequencer.reg_model_ptr30.uart0_rm30;
    uart_cfg_dut_seq30.start(null);


    // configure UART130 DUT
    uart_cfg_dut_seq30 = uart_ctrl_config_reg_seq30::type_id::create("uart_cfg_dut_seq30");
    uart_cfg_dut_seq30.reg_model30 = p_sequencer.reg_model_ptr30.uart1_rm30;
    uart_cfg_dut_seq30.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == num_a2u0_wr30; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == num_a2u1_wr30; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq30, p_sequencer.uart0_seqr30, {cnt == num_u02a_wr30;})
      `uvm_do_on_with(uart_seq30, p_sequencer.uart1_seqr30, {cnt == num_u12a_wr30;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u02a_wr30; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u12a_wr30; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == num_a2u0_wr30; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq30, p_sequencer.uart0_seqr30, {cnt == num_u02a_wr30;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config30

// rand lp30 shutdown30 seq between uart30 1 and smc30
class lp_shutdown_rand30 extends uvm_sequence;

  rand int unsigned num_u02a_wr30;
  rand int unsigned num_a2u0_wr30;
  rand int unsigned num_u12a_wr30;
  rand int unsigned num_a2u1_wr30;

  function new(string name="lp_shutdown_rand30",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)    

  constraint num_u02a_wr_ct30 {(num_u02a_wr30 > 2) && (num_u02a_wr30 <= 4);}
  constraint num_a2u0_wr_ct30 {(num_a2u0_wr30 == 1);}
  constraint num_u12a_wr_ct30 {(num_u12a_wr30 > 2) && (num_u12a_wr30 <= 4);}
  constraint num_a2u1_wr_ct30 {(num_a2u1_wr30 == 1);}


  on_off_seq30 on_off_seq30;
  uart_incr_payload_seq30 uart_seq30;
  intrpt_seq30 rd_rx_fifo30;
  ahb_to_uart_wr30 raw_seq30;
  lp_shutdown_config30 lp_shutdown_config30;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut30 down seq
    `uvm_do(lp_shutdown_config30);
    #20000;
    `uvm_do(on_off_seq30);

    #10000;
    fork
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == num_a2u1_wr30; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq30, p_sequencer.uart1_seqr30, {cnt == num_u12a_wr30;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u02a_wr30; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u12a_wr30; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand30


// sequence for shutting30 down uart30 1 alone30
class lp_shutdown_uart130 extends uvm_sequence;

  rand int unsigned num_u02a_wr30;
  rand int unsigned num_a2u0_wr30;
  rand int unsigned num_u12a_wr30;
  rand int unsigned num_a2u1_wr30;

  function new(string name="lp_shutdown_uart130",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart130)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)    

  constraint num_u02a_wr_ct30 {(num_u02a_wr30 > 2) && (num_u02a_wr30 <= 4);}
  constraint num_a2u0_wr_ct30 {(num_a2u0_wr30 == 1);}
  constraint num_u12a_wr_ct30 {(num_u12a_wr30 > 2) && (num_u12a_wr30 <= 4);}
  constraint num_a2u1_wr_ct30 {(num_a2u1_wr30 == 2);}


  on_off_uart1_seq30 on_off_uart1_seq30;
  uart_incr_payload_seq30 uart_seq30;
  intrpt_seq30 rd_rx_fifo30;
  ahb_to_uart_wr30 raw_seq30;
  lp_shutdown_config30 lp_shutdown_config30;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut30 down seq
    `uvm_do(lp_shutdown_config30);
    #20000;
    `uvm_do(on_off_uart1_seq30);

    #10000;
    fork
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == num_a2u1_wr30; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq30, p_sequencer.uart1_seqr30, {cnt == num_u12a_wr30;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u02a_wr30; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo30, p_sequencer.ahb_seqr30, {num_of_rd30 == num_u12a_wr30; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart130



class apb_spi_incr_payload30 extends uvm_sequence;

  rand int unsigned num_spi2a_wr30;
  rand int unsigned num_a2spi_wr30;

  function new(string name="apb_spi_incr_payload30",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)    

  constraint num_spi2a_wr_ct30 {(num_spi2a_wr30 > 2) && (num_spi2a_wr30 <= 4);}
  constraint num_a2spi_wr_ct30 {(num_a2spi_wr30 == 4);}

  // APB30 and UART30 UVC30 sequences
  spi_cfg_reg_seq30 spi_cfg_dut_seq30;
  spi_incr_payload30 spi_seq30;
  read_spi_rx_reg30 rd_rx_reg30;
  ahb_to_spi_wr30 raw_seq30;
  spi_en_tx_reg_seq30 en_spi_tx_seq30;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq30", $psprintf("Number30 of APB30->SPI30 Transaction30 = %d", num_a2spi_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Number30 of SPI30->APB30 Transaction30 = %d", num_a2spi_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Total30 Number30 of AHB30, SPI30 Transaction30 = %d", 2 * num_a2spi_wr30), UVM_LOW)

    // configure SPI30 DUT
    spi_cfg_dut_seq30 = spi_cfg_reg_seq30::type_id::create("spi_cfg_dut_seq30");
    spi_cfg_dut_seq30.reg_model30 = p_sequencer.reg_model_ptr30.spi_rf30;
    spi_cfg_dut_seq30.start(null);


    for (int i = 0; i < num_a2spi_wr30; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {num_of_wr30 == 1; base_addr == 'h800000;})
            en_spi_tx_seq30 = spi_en_tx_reg_seq30::type_id::create("en_spi_tx_seq30");
            en_spi_tx_seq30.reg_model30 = p_sequencer.reg_model_ptr30.spi_rf30;
            en_spi_tx_seq30.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq30, p_sequencer.spi0_seqr30, {cnt_i30 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg30, p_sequencer.ahb_seqr30, {num_of_rd30 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload30

class apb_gpio_simple_vseq30 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr30;

  function new(string name="apb_gpio_simple_vseq30",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)    

  constraint num_a2gpio_wr_ct30 {(num_a2gpio_wr30 == 4);}

  // APB30 and UART30 UVC30 sequences
  gpio_cfg_reg_seq30 gpio_cfg_dut_seq30;
  gpio_simple_trans_seq30 gpio_seq30;
  read_gpio_rx_reg30 rd_rx_reg30;
  ahb_to_gpio_wr30 raw_seq30;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq30", $psprintf("Number30 of AHB30->GPIO30 Transaction30 = %d", num_a2gpio_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Number30 of GPIO30->APB30 Transaction30 = %d", num_a2gpio_wr30), UVM_LOW)
    `uvm_info("vseq30", $psprintf("Total30 Number30 of AHB30, GPIO30 Transaction30 = %d", 2 * num_a2gpio_wr30), UVM_LOW)

    // configure SPI30 DUT
    gpio_cfg_dut_seq30 = gpio_cfg_reg_seq30::type_id::create("gpio_cfg_dut_seq30");
    gpio_cfg_dut_seq30.reg_model30 = p_sequencer.reg_model_ptr30.gpio_rf30;
    gpio_cfg_dut_seq30.start(null);


    for (int i = 0; i < num_a2gpio_wr30; i++) begin
      `uvm_do_on_with(raw_seq30, p_sequencer.ahb_seqr30, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq30, p_sequencer.gpio0_seqr30)
      `uvm_do_on_with(rd_rx_reg30, p_sequencer.ahb_seqr30, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq30

class apb_subsystem_vseq30 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq30",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq30)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)    

  // APB30 and UART30 UVC30 sequences
  u2a_incr_payload30 apb_to_uart30;
  apb_spi_incr_payload30 apb_to_spi30;
  apb_gpio_simple_vseq30 apb_to_gpio30;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq30", $psprintf("Doing apb_subsystem_vseq30"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart30)
      `uvm_do(apb_to_spi30)
      `uvm_do(apb_to_gpio30)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq30

class apb_ss_cms_seq30 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq30)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer30)

   function new(string name = "apb_ss_cms_seq30");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq30", $psprintf("Starting AHB30 Compliance30 Management30 System30 (CMS30)"), UVM_LOW)
//	   p_sequencer.ahb_seqr30.start_ahb_cms30();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq30
`endif
