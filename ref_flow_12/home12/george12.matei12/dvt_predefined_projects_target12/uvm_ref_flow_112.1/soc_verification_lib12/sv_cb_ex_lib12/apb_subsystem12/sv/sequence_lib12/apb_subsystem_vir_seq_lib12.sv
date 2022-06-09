/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_vir_seq_lib12.sv
Title12       : Virtual Sequence
Project12     :
Created12     :
Description12 : This12 file implements12 the virtual sequence for the APB12-UART12 env12.
Notes12       : The concurrent_u2a_a2u_rand_trans12 sequence first configures12
            : the UART12 RTL12. Once12 the configuration sequence is completed
            : random read/write sequences from both the UVCs12 are enabled
            : in parallel12. At12 the end a Rx12 FIFO read sequence is executed12.
            : The intrpt_seq12 needs12 to be modified to take12 interrupt12 into account12.
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV12
`define APB_UART_VIRTUAL_SEQ_LIB_SV12

class u2a_incr_payload12 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr12;
  rand int unsigned num_a2u0_wr12;
  rand int unsigned num_u12a_wr12;
  rand int unsigned num_a2u1_wr12;

  function new(string name="u2a_incr_payload12",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)    

  constraint num_u02a_wr_ct12 {(num_u02a_wr12 > 2) && (num_u02a_wr12 <= 4);}
  constraint num_a2u0_wr_ct12 {(num_a2u0_wr12 == 1);}
  constraint num_u12a_wr_ct12 {(num_u12a_wr12 > 2) && (num_u12a_wr12 <= 4);}
  constraint num_a2u1_wr_ct12 {(num_a2u1_wr12 == 1);}

  // APB12 and UART12 UVC12 sequences
  uart_ctrl_config_reg_seq12 uart_cfg_dut_seq12;
  uart_incr_payload_seq12 uart_seq12;
  intrpt_seq12 rd_rx_fifo12;
  ahb_to_uart_wr12 raw_seq12;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq12", $psprintf("Number12 of APB12->UART012 Transaction12 = %d", num_a2u0_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Number12 of APB12->UART112 Transaction12 = %d", num_a2u1_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Number12 of UART012->APB12 Transaction12 = %d", num_u02a_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Number12 of UART112->APB12 Transaction12 = %d", num_u12a_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Total12 Number12 of AHB12, UART12 Transaction12 = %d", num_u02a_wr12 + num_a2u0_wr12 + num_u02a_wr12 + num_a2u0_wr12), UVM_LOW)

    // configure UART012 DUT
    uart_cfg_dut_seq12 = uart_ctrl_config_reg_seq12::type_id::create("uart_cfg_dut_seq12");
    uart_cfg_dut_seq12.reg_model12 = p_sequencer.reg_model_ptr12.uart0_rm12;
    uart_cfg_dut_seq12.start(null);


    // configure UART112 DUT
    uart_cfg_dut_seq12 = uart_ctrl_config_reg_seq12::type_id::create("uart_cfg_dut_seq12");
    uart_cfg_dut_seq12.reg_model12 = p_sequencer.reg_model_ptr12.uart1_rm12;
    uart_cfg_dut_seq12.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == num_a2u0_wr12; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == num_a2u1_wr12; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq12, p_sequencer.uart0_seqr12, {cnt == num_u02a_wr12;})
      `uvm_do_on_with(uart_seq12, p_sequencer.uart1_seqr12, {cnt == num_u12a_wr12;})
    join
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u02a_wr12; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u12a_wr12; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload12

// rand shutdown12 and power12-on
class on_off_seq12 extends uvm_sequence;
  `uvm_object_utils(on_off_seq12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)

  function new(string name = "on_off_seq12");
     super.new(name);
  endfunction

  shutdown_dut12 shut_dut12;
  poweron_dut12 power_dut12;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut12, p_sequencer.ahb_seqr12)
       #4000;
      `uvm_do_on(power_dut12, p_sequencer.ahb_seqr12)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq12


// shutdown12 and power12-on for uart112
class on_off_uart1_seq12 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)

  function new(string name = "on_off_uart1_seq12");
     super.new(name);
  endfunction

  shutdown_dut12 shut_dut12;
  poweron_dut12 power_dut12;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut12, p_sequencer.ahb_seqr12, {write_data12 == 1;})
        #4000;
      `uvm_do_on(power_dut12, p_sequencer.ahb_seqr12)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq12

// lp12 seq, configuration sequence
class lp_shutdown_config12 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr12;
  rand int unsigned num_a2u0_wr12;
  rand int unsigned num_u12a_wr12;
  rand int unsigned num_a2u1_wr12;

  function new(string name="lp_shutdown_config12",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)    

  constraint num_u02a_wr_ct12 {(num_u02a_wr12 > 2) && (num_u02a_wr12 <= 4);}
  constraint num_a2u0_wr_ct12 {(num_a2u0_wr12 == 1);}
  constraint num_u12a_wr_ct12 {(num_u12a_wr12 > 2) && (num_u12a_wr12 <= 4);}
  constraint num_a2u1_wr_ct12 {(num_a2u1_wr12 == 1);}

  // APB12 and UART12 UVC12 sequences
  uart_ctrl_config_reg_seq12 uart_cfg_dut_seq12;
  uart_incr_payload_seq12 uart_seq12;
  intrpt_seq12 rd_rx_fifo12;
  ahb_to_uart_wr12 raw_seq12;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq12", $psprintf("Number12 of APB12->UART012 Transaction12 = %d", num_a2u0_wr12), UVM_LOW);
    `uvm_info("vseq12", $psprintf("Number12 of APB12->UART112 Transaction12 = %d", num_a2u1_wr12), UVM_LOW);
    `uvm_info("vseq12", $psprintf("Number12 of UART012->APB12 Transaction12 = %d", num_u02a_wr12), UVM_LOW);
    `uvm_info("vseq12", $psprintf("Number12 of UART112->APB12 Transaction12 = %d", num_u12a_wr12), UVM_LOW);
    `uvm_info("vseq12", $psprintf("Total12 Number12 of AHB12, UART12 Transaction12 = %d", num_u02a_wr12 + num_a2u0_wr12 + num_u02a_wr12 + num_a2u0_wr12), UVM_LOW);

    // configure UART012 DUT
    uart_cfg_dut_seq12 = uart_ctrl_config_reg_seq12::type_id::create("uart_cfg_dut_seq12");
    uart_cfg_dut_seq12.reg_model12 = p_sequencer.reg_model_ptr12.uart0_rm12;
    uart_cfg_dut_seq12.start(null);


    // configure UART112 DUT
    uart_cfg_dut_seq12 = uart_ctrl_config_reg_seq12::type_id::create("uart_cfg_dut_seq12");
    uart_cfg_dut_seq12.reg_model12 = p_sequencer.reg_model_ptr12.uart1_rm12;
    uart_cfg_dut_seq12.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == num_a2u0_wr12; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == num_a2u1_wr12; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq12, p_sequencer.uart0_seqr12, {cnt == num_u02a_wr12;})
      `uvm_do_on_with(uart_seq12, p_sequencer.uart1_seqr12, {cnt == num_u12a_wr12;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u02a_wr12; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u12a_wr12; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == num_a2u0_wr12; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq12, p_sequencer.uart0_seqr12, {cnt == num_u02a_wr12;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config12

// rand lp12 shutdown12 seq between uart12 1 and smc12
class lp_shutdown_rand12 extends uvm_sequence;

  rand int unsigned num_u02a_wr12;
  rand int unsigned num_a2u0_wr12;
  rand int unsigned num_u12a_wr12;
  rand int unsigned num_a2u1_wr12;

  function new(string name="lp_shutdown_rand12",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)    

  constraint num_u02a_wr_ct12 {(num_u02a_wr12 > 2) && (num_u02a_wr12 <= 4);}
  constraint num_a2u0_wr_ct12 {(num_a2u0_wr12 == 1);}
  constraint num_u12a_wr_ct12 {(num_u12a_wr12 > 2) && (num_u12a_wr12 <= 4);}
  constraint num_a2u1_wr_ct12 {(num_a2u1_wr12 == 1);}


  on_off_seq12 on_off_seq12;
  uart_incr_payload_seq12 uart_seq12;
  intrpt_seq12 rd_rx_fifo12;
  ahb_to_uart_wr12 raw_seq12;
  lp_shutdown_config12 lp_shutdown_config12;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut12 down seq
    `uvm_do(lp_shutdown_config12);
    #20000;
    `uvm_do(on_off_seq12);

    #10000;
    fork
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == num_a2u1_wr12; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq12, p_sequencer.uart1_seqr12, {cnt == num_u12a_wr12;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u02a_wr12; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u12a_wr12; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand12


// sequence for shutting12 down uart12 1 alone12
class lp_shutdown_uart112 extends uvm_sequence;

  rand int unsigned num_u02a_wr12;
  rand int unsigned num_a2u0_wr12;
  rand int unsigned num_u12a_wr12;
  rand int unsigned num_a2u1_wr12;

  function new(string name="lp_shutdown_uart112",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart112)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)    

  constraint num_u02a_wr_ct12 {(num_u02a_wr12 > 2) && (num_u02a_wr12 <= 4);}
  constraint num_a2u0_wr_ct12 {(num_a2u0_wr12 == 1);}
  constraint num_u12a_wr_ct12 {(num_u12a_wr12 > 2) && (num_u12a_wr12 <= 4);}
  constraint num_a2u1_wr_ct12 {(num_a2u1_wr12 == 2);}


  on_off_uart1_seq12 on_off_uart1_seq12;
  uart_incr_payload_seq12 uart_seq12;
  intrpt_seq12 rd_rx_fifo12;
  ahb_to_uart_wr12 raw_seq12;
  lp_shutdown_config12 lp_shutdown_config12;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut12 down seq
    `uvm_do(lp_shutdown_config12);
    #20000;
    `uvm_do(on_off_uart1_seq12);

    #10000;
    fork
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == num_a2u1_wr12; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq12, p_sequencer.uart1_seqr12, {cnt == num_u12a_wr12;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u02a_wr12; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo12, p_sequencer.ahb_seqr12, {num_of_rd12 == num_u12a_wr12; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart112



class apb_spi_incr_payload12 extends uvm_sequence;

  rand int unsigned num_spi2a_wr12;
  rand int unsigned num_a2spi_wr12;

  function new(string name="apb_spi_incr_payload12",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)    

  constraint num_spi2a_wr_ct12 {(num_spi2a_wr12 > 2) && (num_spi2a_wr12 <= 4);}
  constraint num_a2spi_wr_ct12 {(num_a2spi_wr12 == 4);}

  // APB12 and UART12 UVC12 sequences
  spi_cfg_reg_seq12 spi_cfg_dut_seq12;
  spi_incr_payload12 spi_seq12;
  read_spi_rx_reg12 rd_rx_reg12;
  ahb_to_spi_wr12 raw_seq12;
  spi_en_tx_reg_seq12 en_spi_tx_seq12;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq12", $psprintf("Number12 of APB12->SPI12 Transaction12 = %d", num_a2spi_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Number12 of SPI12->APB12 Transaction12 = %d", num_a2spi_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Total12 Number12 of AHB12, SPI12 Transaction12 = %d", 2 * num_a2spi_wr12), UVM_LOW)

    // configure SPI12 DUT
    spi_cfg_dut_seq12 = spi_cfg_reg_seq12::type_id::create("spi_cfg_dut_seq12");
    spi_cfg_dut_seq12.reg_model12 = p_sequencer.reg_model_ptr12.spi_rf12;
    spi_cfg_dut_seq12.start(null);


    for (int i = 0; i < num_a2spi_wr12; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {num_of_wr12 == 1; base_addr == 'h800000;})
            en_spi_tx_seq12 = spi_en_tx_reg_seq12::type_id::create("en_spi_tx_seq12");
            en_spi_tx_seq12.reg_model12 = p_sequencer.reg_model_ptr12.spi_rf12;
            en_spi_tx_seq12.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq12, p_sequencer.spi0_seqr12, {cnt_i12 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg12, p_sequencer.ahb_seqr12, {num_of_rd12 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload12

class apb_gpio_simple_vseq12 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr12;

  function new(string name="apb_gpio_simple_vseq12",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)    

  constraint num_a2gpio_wr_ct12 {(num_a2gpio_wr12 == 4);}

  // APB12 and UART12 UVC12 sequences
  gpio_cfg_reg_seq12 gpio_cfg_dut_seq12;
  gpio_simple_trans_seq12 gpio_seq12;
  read_gpio_rx_reg12 rd_rx_reg12;
  ahb_to_gpio_wr12 raw_seq12;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq12", $psprintf("Number12 of AHB12->GPIO12 Transaction12 = %d", num_a2gpio_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Number12 of GPIO12->APB12 Transaction12 = %d", num_a2gpio_wr12), UVM_LOW)
    `uvm_info("vseq12", $psprintf("Total12 Number12 of AHB12, GPIO12 Transaction12 = %d", 2 * num_a2gpio_wr12), UVM_LOW)

    // configure SPI12 DUT
    gpio_cfg_dut_seq12 = gpio_cfg_reg_seq12::type_id::create("gpio_cfg_dut_seq12");
    gpio_cfg_dut_seq12.reg_model12 = p_sequencer.reg_model_ptr12.gpio_rf12;
    gpio_cfg_dut_seq12.start(null);


    for (int i = 0; i < num_a2gpio_wr12; i++) begin
      `uvm_do_on_with(raw_seq12, p_sequencer.ahb_seqr12, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq12, p_sequencer.gpio0_seqr12)
      `uvm_do_on_with(rd_rx_reg12, p_sequencer.ahb_seqr12, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq12

class apb_subsystem_vseq12 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq12",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq12)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)    

  // APB12 and UART12 UVC12 sequences
  u2a_incr_payload12 apb_to_uart12;
  apb_spi_incr_payload12 apb_to_spi12;
  apb_gpio_simple_vseq12 apb_to_gpio12;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq12", $psprintf("Doing apb_subsystem_vseq12"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart12)
      `uvm_do(apb_to_spi12)
      `uvm_do(apb_to_gpio12)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq12

class apb_ss_cms_seq12 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq12)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer12)

   function new(string name = "apb_ss_cms_seq12");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq12", $psprintf("Starting AHB12 Compliance12 Management12 System12 (CMS12)"), UVM_LOW)
//	   p_sequencer.ahb_seqr12.start_ahb_cms12();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq12
`endif
