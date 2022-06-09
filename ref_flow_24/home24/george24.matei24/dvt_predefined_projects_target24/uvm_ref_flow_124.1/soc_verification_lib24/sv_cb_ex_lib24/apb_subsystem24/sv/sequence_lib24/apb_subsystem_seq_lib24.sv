/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_seq_lib24.sv
Title24       : 
Project24     :
Created24     :
Description24 : This24 file implements24 APB24 Sequences24 specific24 to UART24 
            : CSR24 programming24 and Tx24/Rx24 FIFO write/read
Notes24       : The interrupt24 sequence in this file is not yet complete.
            : The interrupt24 sequence should be triggred24 by the Rx24 fifo 
            : full event from the UART24 RTL24.
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

// writes 0-150 data in UART24 TX24 FIFO
class ahb_to_uart_wr24 extends uvm_sequence #(ahb_transfer24);

    function new(string name="ahb_to_uart_wr24");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    rand bit unsigned[31:0] rand_data24;
    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH24-1:0] start_addr24;
    rand bit [`AHB_DATA_WIDTH24-1:0] write_data24;
    rand int unsigned num_of_wr24;
    constraint num_of_wr_ct24 { (num_of_wr24 <= 150); }

    virtual task body();
      start_addr24 = base_addr + `TX_FIFO_REG24;
      for (int i = 0; i < num_of_wr24; i++) begin
      write_data24 = write_data24 + i;
      `uvm_do_with(req, { req.address == start_addr24; req.data == write_data24; req.direction24 == WRITE; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
      end
    endtask
  
  function void post_randomize();
      write_data24 = rand_data24;
  endfunction
endclass : ahb_to_uart_wr24

// writes 0-150 data in SPI24 TX24 FIFO
class ahb_to_spi_wr24 extends uvm_sequence #(ahb_transfer24);

    function new(string name="ahb_to_spi_wr24");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    rand bit unsigned[31:0] rand_data24;
    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH24-1:0] start_addr24;
    rand bit [`AHB_DATA_WIDTH24-1:0] write_data24;
    rand int unsigned num_of_wr24;
    constraint num_of_wr_ct24 { (num_of_wr24 <= 150); }

    virtual task body();
      start_addr24 = base_addr + `SPI_TX0_REG24;
      for (int i = 0; i < num_of_wr24; i++) begin
      write_data24 = write_data24 + i;
      `uvm_do_with(req, { req.address == start_addr24; req.data == write_data24; req.direction24 == WRITE; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
      end
    endtask
  
  function void post_randomize();
      write_data24 = rand_data24;
  endfunction
endclass : ahb_to_spi_wr24

// writes 1 data in GPIO24 TX24 REG
class ahb_to_gpio_wr24 extends uvm_sequence #(ahb_transfer24);

    function new(string name="ahb_to_gpio_wr24");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    rand bit unsigned[31:0] rand_data24;
    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH24-1:0] start_addr24;
    rand bit [`AHB_DATA_WIDTH24-1:0] write_data24;

    virtual task body();
      start_addr24 = base_addr + `GPIO_OUTPUT_VALUE_REG24;
      `uvm_do_with(req, { req.address == start_addr24; req.data == write_data24; req.direction24 == WRITE; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
    endtask
  
  function void post_randomize();
      write_data24 = rand_data24;
  endfunction
endclass : ahb_to_gpio_wr24

// Low24 Power24 CPF24 test
class shutdown_dut24 extends uvm_sequence #(ahb_transfer24);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    function new(string name="shutdown_dut24");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH24-1:0] start_addr24;

    rand bit [`AHB_DATA_WIDTH24-1:0] write_data24;
    constraint uart_smc_shut24 { (write_data24 >= 1 && write_data24 <= 3); }

    virtual task body();
      start_addr24 = 32'h00860004;
      //write_data24 = 32'h01;

     if (write_data24 == 1)
      `uvm_info("SEQ", ("shutdown_dut24 sequence is shutting24 down UART24 "), UVM_MEDIUM)
     else if (write_data24 == 2) 
      `uvm_info("SEQ", ("shutdown_dut24 sequence is shutting24 down SMC24 "), UVM_MEDIUM)
     else if (write_data24 == 3) 
      `uvm_info("SEQ", ("shutdown_dut24 sequence is shutting24 down UART24 and SMC24 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr24; req.data == write_data24; req.direction24 == WRITE; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
    endtask
  
endclass :  shutdown_dut24

// Low24 Power24 CPF24 test
class poweron_dut24 extends uvm_sequence #(ahb_transfer24);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    function new(string name="poweron_dut24");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH24-1:0] start_addr24;
    bit [`AHB_DATA_WIDTH24-1:0] write_data24;

    virtual task body();
      start_addr24 = 32'h00860004;
      write_data24 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut24 sequence is switching24 on PDurt24"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr24; req.data == write_data24; req.direction24 == WRITE; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
    endtask
  
endclass : poweron_dut24

// Reads24 UART24 RX24 FIFO
class intrpt_seq24 extends uvm_sequence #(ahb_transfer24);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    function new(string name="intrpt_seq24");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH24-1:0] read_addr24;
    rand int unsigned num_of_rd24;
    constraint num_of_rd_ct24 { (num_of_rd24 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH24-1:0] read_data24;

      for (int i = 0; i < num_of_rd24; i++) begin
        read_addr24 = base_addr + `RX_FIFO_REG24;      //rx24 fifo address
        `uvm_do_with(req, { req.address == read_addr24; req.data == read_data24; req.direction24 == READ; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG24 DATA24 is `x%0h", read_data24), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq24

// Reads24 SPI24 RX24 REG
class read_spi_rx_reg24 extends uvm_sequence #(ahb_transfer24);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    function new(string name="read_spi_rx_reg24");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH24-1:0] read_addr24;
    rand int unsigned num_of_rd24;
    constraint num_of_rd_ct24 { (num_of_rd24 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH24-1:0] read_data24;

      for (int i = 0; i < num_of_rd24; i++) begin
        read_addr24 = base_addr + `SPI_RX0_REG24;
        `uvm_do_with(req, { req.address == read_addr24; req.data == read_data24; req.direction24 == READ; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
        `uvm_info("SEQ", $psprintf("Read DATA24 is `x%0h", read_data24), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg24

// Reads24 GPIO24 INPUT_VALUE24 REG
class read_gpio_rx_reg24 extends uvm_sequence #(ahb_transfer24);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg24)
    `uvm_declare_p_sequencer(ahb_pkg24::ahb_master_sequencer24)    

    function new(string name="read_gpio_rx_reg24");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH24-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH24-1:0] read_addr24;

    virtual task body();
      bit [`AHB_DATA_WIDTH24-1:0] read_data24;

      read_addr24 = base_addr + `GPIO_INPUT_VALUE_REG24;
      `uvm_do_with(req, { req.address == read_addr24; req.data == read_data24; req.direction24 == READ; req.burst == ahb_pkg24::SINGLE24; req.hsize24 == ahb_pkg24::WORD24;} )
      `uvm_info("SEQ", $psprintf("Read DATA24 is `x%0h", read_data24), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg24

