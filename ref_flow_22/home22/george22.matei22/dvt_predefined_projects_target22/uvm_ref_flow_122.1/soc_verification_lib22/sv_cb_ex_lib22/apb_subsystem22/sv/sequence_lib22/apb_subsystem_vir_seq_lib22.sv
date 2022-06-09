/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_vir_seq_lib22.sv
Title22       : Virtual Sequence
Project22     :
Created22     :
Description22 : This22 file implements22 the virtual sequence for the APB22-UART22 env22.
Notes22       : The concurrent_u2a_a2u_rand_trans22 sequence first configures22
            : the UART22 RTL22. Once22 the configuration sequence is completed
            : random read/write sequences from both the UVCs22 are enabled
            : in parallel22. At22 the end a Rx22 FIFO read sequence is executed22.
            : The intrpt_seq22 needs22 to be modified to take22 interrupt22 into account22.
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_UART_VIRTUAL_SEQ_LIB_SV22
`define APB_UART_VIRTUAL_SEQ_LIB_SV22

class u2a_incr_payload22 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr22;
  rand int unsigned num_a2u0_wr22;
  rand int unsigned num_u12a_wr22;
  rand int unsigned num_a2u1_wr22;

  function new(string name="u2a_incr_payload22",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(u2a_incr_payload22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)    

  constraint num_u02a_wr_ct22 {(num_u02a_wr22 > 2) && (num_u02a_wr22 <= 4);}
  constraint num_a2u0_wr_ct22 {(num_a2u0_wr22 == 1);}
  constraint num_u12a_wr_ct22 {(num_u12a_wr22 > 2) && (num_u12a_wr22 <= 4);}
  constraint num_a2u1_wr_ct22 {(num_a2u1_wr22 == 1);}

  // APB22 and UART22 UVC22 sequences
  uart_ctrl_config_reg_seq22 uart_cfg_dut_seq22;
  uart_incr_payload_seq22 uart_seq22;
  intrpt_seq22 rd_rx_fifo22;
  ahb_to_uart_wr22 raw_seq22;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq22", $psprintf("Number22 of APB22->UART022 Transaction22 = %d", num_a2u0_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Number22 of APB22->UART122 Transaction22 = %d", num_a2u1_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Number22 of UART022->APB22 Transaction22 = %d", num_u02a_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Number22 of UART122->APB22 Transaction22 = %d", num_u12a_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Total22 Number22 of AHB22, UART22 Transaction22 = %d", num_u02a_wr22 + num_a2u0_wr22 + num_u02a_wr22 + num_a2u0_wr22), UVM_LOW)

    // configure UART022 DUT
    uart_cfg_dut_seq22 = uart_ctrl_config_reg_seq22::type_id::create("uart_cfg_dut_seq22");
    uart_cfg_dut_seq22.reg_model22 = p_sequencer.reg_model_ptr22.uart0_rm22;
    uart_cfg_dut_seq22.start(null);


    // configure UART122 DUT
    uart_cfg_dut_seq22 = uart_ctrl_config_reg_seq22::type_id::create("uart_cfg_dut_seq22");
    uart_cfg_dut_seq22.reg_model22 = p_sequencer.reg_model_ptr22.uart1_rm22;
    uart_cfg_dut_seq22.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == num_a2u0_wr22; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == num_a2u1_wr22; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq22, p_sequencer.uart0_seqr22, {cnt == num_u02a_wr22;})
      `uvm_do_on_with(uart_seq22, p_sequencer.uart1_seqr22, {cnt == num_u12a_wr22;})
    join
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u02a_wr22; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u12a_wr22; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : u2a_incr_payload22

// rand shutdown22 and power22-on
class on_off_seq22 extends uvm_sequence;
  `uvm_object_utils(on_off_seq22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)

  function new(string name = "on_off_seq22");
     super.new(name);
  endfunction

  shutdown_dut22 shut_dut22;
  poweron_dut22 power_dut22;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 10; i ++) begin
      `uvm_do_on(shut_dut22, p_sequencer.ahb_seqr22)
       #4000;
      `uvm_do_on(power_dut22, p_sequencer.ahb_seqr22)
       #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_seq22


// shutdown22 and power22-on for uart122
class on_off_uart1_seq22 extends uvm_sequence;
  `uvm_object_utils(on_off_uart1_seq22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)

  function new(string name = "on_off_uart1_seq22");
     super.new(name);
  endfunction

  shutdown_dut22 shut_dut22;
  poweron_dut22 power_dut22;

  virtual task body();
    uvm_test_done.raise_objection(this);
    for (int i=0 ; i <= 5; i ++) begin
      `uvm_do_on_with(shut_dut22, p_sequencer.ahb_seqr22, {write_data22 == 1;})
        #4000;
      `uvm_do_on(power_dut22, p_sequencer.ahb_seqr22)
        #4000;
    end
    uvm_test_done.drop_objection(this);
  endtask : body
  
endclass : on_off_uart1_seq22

// lp22 seq, configuration sequence
class lp_shutdown_config22 extends uvm_sequence;

  //bit success;
  rand int unsigned num_u02a_wr22;
  rand int unsigned num_a2u0_wr22;
  rand int unsigned num_u12a_wr22;
  rand int unsigned num_a2u1_wr22;

  function new(string name="lp_shutdown_config22",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_config22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)    

  constraint num_u02a_wr_ct22 {(num_u02a_wr22 > 2) && (num_u02a_wr22 <= 4);}
  constraint num_a2u0_wr_ct22 {(num_a2u0_wr22 == 1);}
  constraint num_u12a_wr_ct22 {(num_u12a_wr22 > 2) && (num_u12a_wr22 <= 4);}
  constraint num_a2u1_wr_ct22 {(num_a2u1_wr22 == 1);}

  // APB22 and UART22 UVC22 sequences
  uart_ctrl_config_reg_seq22 uart_cfg_dut_seq22;
  uart_incr_payload_seq22 uart_seq22;
  intrpt_seq22 rd_rx_fifo22;
  ahb_to_uart_wr22 raw_seq22;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq22", $psprintf("Number22 of APB22->UART022 Transaction22 = %d", num_a2u0_wr22), UVM_LOW);
    `uvm_info("vseq22", $psprintf("Number22 of APB22->UART122 Transaction22 = %d", num_a2u1_wr22), UVM_LOW);
    `uvm_info("vseq22", $psprintf("Number22 of UART022->APB22 Transaction22 = %d", num_u02a_wr22), UVM_LOW);
    `uvm_info("vseq22", $psprintf("Number22 of UART122->APB22 Transaction22 = %d", num_u12a_wr22), UVM_LOW);
    `uvm_info("vseq22", $psprintf("Total22 Number22 of AHB22, UART22 Transaction22 = %d", num_u02a_wr22 + num_a2u0_wr22 + num_u02a_wr22 + num_a2u0_wr22), UVM_LOW);

    // configure UART022 DUT
    uart_cfg_dut_seq22 = uart_ctrl_config_reg_seq22::type_id::create("uart_cfg_dut_seq22");
    uart_cfg_dut_seq22.reg_model22 = p_sequencer.reg_model_ptr22.uart0_rm22;
    uart_cfg_dut_seq22.start(null);


    // configure UART122 DUT
    uart_cfg_dut_seq22 = uart_ctrl_config_reg_seq22::type_id::create("uart_cfg_dut_seq22");
    uart_cfg_dut_seq22.reg_model22 = p_sequencer.reg_model_ptr22.uart1_rm22;
    uart_cfg_dut_seq22.start(null);


    #1000;
    fork
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == num_a2u0_wr22; base_addr == 'h810000;})
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == num_a2u1_wr22; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq22, p_sequencer.uart0_seqr22, {cnt == num_u02a_wr22;})
      `uvm_do_on_with(uart_seq22, p_sequencer.uart1_seqr22, {cnt == num_u12a_wr22;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u02a_wr22; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u12a_wr22; base_addr == 'h880000;})


    fork
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == num_a2u0_wr22; base_addr == 'h810000;})
      `uvm_do_on_with(uart_seq22, p_sequencer.uart0_seqr22, {cnt == num_u02a_wr22;})
    join_none

    uvm_test_done.drop_objection(this);
  endtask : body
endclass : lp_shutdown_config22

// rand lp22 shutdown22 seq between uart22 1 and smc22
class lp_shutdown_rand22 extends uvm_sequence;

  rand int unsigned num_u02a_wr22;
  rand int unsigned num_a2u0_wr22;
  rand int unsigned num_u12a_wr22;
  rand int unsigned num_a2u1_wr22;

  function new(string name="lp_shutdown_rand22",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_rand22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)    

  constraint num_u02a_wr_ct22 {(num_u02a_wr22 > 2) && (num_u02a_wr22 <= 4);}
  constraint num_a2u0_wr_ct22 {(num_a2u0_wr22 == 1);}
  constraint num_u12a_wr_ct22 {(num_u12a_wr22 > 2) && (num_u12a_wr22 <= 4);}
  constraint num_a2u1_wr_ct22 {(num_a2u1_wr22 == 1);}


  on_off_seq22 on_off_seq22;
  uart_incr_payload_seq22 uart_seq22;
  intrpt_seq22 rd_rx_fifo22;
  ahb_to_uart_wr22 raw_seq22;
  lp_shutdown_config22 lp_shutdown_config22;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut22 down seq
    `uvm_do(lp_shutdown_config22);
    #20000;
    `uvm_do(on_off_seq22);

    #10000;
    fork
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == num_a2u1_wr22; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq22, p_sequencer.uart1_seqr22, {cnt == num_u12a_wr22;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u02a_wr22; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u12a_wr22; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_rand22


// sequence for shutting22 down uart22 1 alone22
class lp_shutdown_uart122 extends uvm_sequence;

  rand int unsigned num_u02a_wr22;
  rand int unsigned num_a2u0_wr22;
  rand int unsigned num_u12a_wr22;
  rand int unsigned num_a2u1_wr22;

  function new(string name="lp_shutdown_uart122",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(lp_shutdown_uart122)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)    

  constraint num_u02a_wr_ct22 {(num_u02a_wr22 > 2) && (num_u02a_wr22 <= 4);}
  constraint num_a2u0_wr_ct22 {(num_a2u0_wr22 == 1);}
  constraint num_u12a_wr_ct22 {(num_u12a_wr22 > 2) && (num_u12a_wr22 <= 4);}
  constraint num_a2u1_wr_ct22 {(num_a2u1_wr22 == 2);}


  on_off_uart1_seq22 on_off_uart1_seq22;
  uart_incr_payload_seq22 uart_seq22;
  intrpt_seq22 rd_rx_fifo22;
  ahb_to_uart_wr22 raw_seq22;
  lp_shutdown_config22 lp_shutdown_config22;

  virtual task body();
    uvm_test_done.raise_objection(this);

    // call the shut22 down seq
    `uvm_do(lp_shutdown_config22);
    #20000;
    `uvm_do(on_off_uart1_seq22);

    #10000;
    fork
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == num_a2u1_wr22; base_addr == 'h880000;})
      `uvm_do_on_with(uart_seq22, p_sequencer.uart1_seqr22, {cnt == num_u12a_wr22;})
    join
    #1000;
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u02a_wr22; base_addr == 'h810000;})
    `uvm_do_on_with(rd_rx_fifo22, p_sequencer.ahb_seqr22, {num_of_rd22 == num_u12a_wr22; base_addr == 'h880000;})

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : lp_shutdown_uart122



class apb_spi_incr_payload22 extends uvm_sequence;

  rand int unsigned num_spi2a_wr22;
  rand int unsigned num_a2spi_wr22;

  function new(string name="apb_spi_incr_payload22",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_spi_incr_payload22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)    

  constraint num_spi2a_wr_ct22 {(num_spi2a_wr22 > 2) && (num_spi2a_wr22 <= 4);}
  constraint num_a2spi_wr_ct22 {(num_a2spi_wr22 == 4);}

  // APB22 and UART22 UVC22 sequences
  spi_cfg_reg_seq22 spi_cfg_dut_seq22;
  spi_incr_payload22 spi_seq22;
  read_spi_rx_reg22 rd_rx_reg22;
  ahb_to_spi_wr22 raw_seq22;
  spi_en_tx_reg_seq22 en_spi_tx_seq22;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq22", $psprintf("Number22 of APB22->SPI22 Transaction22 = %d", num_a2spi_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Number22 of SPI22->APB22 Transaction22 = %d", num_a2spi_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Total22 Number22 of AHB22, SPI22 Transaction22 = %d", 2 * num_a2spi_wr22), UVM_LOW)

    // configure SPI22 DUT
    spi_cfg_dut_seq22 = spi_cfg_reg_seq22::type_id::create("spi_cfg_dut_seq22");
    spi_cfg_dut_seq22.reg_model22 = p_sequencer.reg_model_ptr22.spi_rf22;
    spi_cfg_dut_seq22.start(null);


    for (int i = 0; i < num_a2spi_wr22; i++) begin
      fork
        begin
            `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {num_of_wr22 == 1; base_addr == 'h800000;})
            en_spi_tx_seq22 = spi_en_tx_reg_seq22::type_id::create("en_spi_tx_seq22");
            en_spi_tx_seq22.reg_model22 = p_sequencer.reg_model_ptr22.spi_rf22;
            en_spi_tx_seq22.start(null);
            #10000;
        end
        begin
           `uvm_do_on_with(spi_seq22, p_sequencer.spi0_seqr22, {cnt_i22 == 1;})
            #10000;
           `uvm_do_on_with(rd_rx_reg22, p_sequencer.ahb_seqr22, {num_of_rd22 == 1; base_addr == 'h800000;})
        end
      join
    end

    #1000;
    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_spi_incr_payload22

class apb_gpio_simple_vseq22 extends uvm_sequence;

  rand int unsigned num_a2gpio_wr22;

  function new(string name="apb_gpio_simple_vseq22",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_gpio_simple_vseq22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)    

  constraint num_a2gpio_wr_ct22 {(num_a2gpio_wr22 == 4);}

  // APB22 and UART22 UVC22 sequences
  gpio_cfg_reg_seq22 gpio_cfg_dut_seq22;
  gpio_simple_trans_seq22 gpio_seq22;
  read_gpio_rx_reg22 rd_rx_reg22;
  ahb_to_gpio_wr22 raw_seq22;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq22", $psprintf("Number22 of AHB22->GPIO22 Transaction22 = %d", num_a2gpio_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Number22 of GPIO22->APB22 Transaction22 = %d", num_a2gpio_wr22), UVM_LOW)
    `uvm_info("vseq22", $psprintf("Total22 Number22 of AHB22, GPIO22 Transaction22 = %d", 2 * num_a2gpio_wr22), UVM_LOW)

    // configure SPI22 DUT
    gpio_cfg_dut_seq22 = gpio_cfg_reg_seq22::type_id::create("gpio_cfg_dut_seq22");
    gpio_cfg_dut_seq22.reg_model22 = p_sequencer.reg_model_ptr22.gpio_rf22;
    gpio_cfg_dut_seq22.start(null);


    for (int i = 0; i < num_a2gpio_wr22; i++) begin
      `uvm_do_on_with(raw_seq22, p_sequencer.ahb_seqr22, {base_addr == 'h820000;})
      `uvm_do_on(gpio_seq22, p_sequencer.gpio0_seqr22)
      `uvm_do_on_with(rd_rx_reg22, p_sequencer.ahb_seqr22, {base_addr == 'h820000;})
    end

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_gpio_simple_vseq22

class apb_subsystem_vseq22 extends uvm_sequence;

  function new(string name="apb_subsystem_vseq22",
      uvm_sequencer_base sequencer=null, 
      uvm_sequence parent_seq=null);
      super.new(name);
  endfunction : new

  // Register sequence with a sequencer 
  `uvm_object_utils(apb_subsystem_vseq22)
  `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)    

  // APB22 and UART22 UVC22 sequences
  u2a_incr_payload22 apb_to_uart22;
  apb_spi_incr_payload22 apb_to_spi22;
  apb_gpio_simple_vseq22 apb_to_gpio22;

  virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq22", $psprintf("Doing apb_subsystem_vseq22"), UVM_LOW)
    fork
      `uvm_do(apb_to_uart22)
      `uvm_do(apb_to_spi22)
      `uvm_do(apb_to_gpio22)
    join

    uvm_test_done.drop_objection(this);
  endtask : body

endclass : apb_subsystem_vseq22

class apb_ss_cms_seq22 extends uvm_sequence;

   `uvm_object_utils(apb_ss_cms_seq22)
   `uvm_declare_p_sequencer(apb_subsystem_virtual_sequencer22)

   function new(string name = "apb_ss_cms_seq22");
      super.new(name);
   endfunction
  
   virtual task body();
    uvm_test_done.raise_objection(this);

    `uvm_info("vseq22", $psprintf("Starting AHB22 Compliance22 Management22 System22 (CMS22)"), UVM_LOW)
//	   p_sequencer.ahb_seqr22.start_ahb_cms22();  TODO: yet to implement

    uvm_test_done.drop_objection(this);
   endtask
     
endclass : apb_ss_cms_seq22
`endif
