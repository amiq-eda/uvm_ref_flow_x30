/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_seq_lib8.sv
Title8       : 
Project8     :
Created8     :
Description8 : This8 file implements8 APB8 Sequences8 specific8 to UART8 
            : CSR8 programming8 and Tx8/Rx8 FIFO write/read
Notes8       : The interrupt8 sequence in this file is not yet complete.
            : The interrupt8 sequence should be triggred8 by the Rx8 fifo 
            : full event from the UART8 RTL8.
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

// writes 0-150 data in UART8 TX8 FIFO
class ahb_to_uart_wr8 extends uvm_sequence #(ahb_transfer8);

    function new(string name="ahb_to_uart_wr8");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    rand bit unsigned[31:0] rand_data8;
    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH8-1:0] start_addr8;
    rand bit [`AHB_DATA_WIDTH8-1:0] write_data8;
    rand int unsigned num_of_wr8;
    constraint num_of_wr_ct8 { (num_of_wr8 <= 150); }

    virtual task body();
      start_addr8 = base_addr + `TX_FIFO_REG8;
      for (int i = 0; i < num_of_wr8; i++) begin
      write_data8 = write_data8 + i;
      `uvm_do_with(req, { req.address == start_addr8; req.data == write_data8; req.direction8 == WRITE; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
      end
    endtask
  
  function void post_randomize();
      write_data8 = rand_data8;
  endfunction
endclass : ahb_to_uart_wr8

// writes 0-150 data in SPI8 TX8 FIFO
class ahb_to_spi_wr8 extends uvm_sequence #(ahb_transfer8);

    function new(string name="ahb_to_spi_wr8");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    rand bit unsigned[31:0] rand_data8;
    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH8-1:0] start_addr8;
    rand bit [`AHB_DATA_WIDTH8-1:0] write_data8;
    rand int unsigned num_of_wr8;
    constraint num_of_wr_ct8 { (num_of_wr8 <= 150); }

    virtual task body();
      start_addr8 = base_addr + `SPI_TX0_REG8;
      for (int i = 0; i < num_of_wr8; i++) begin
      write_data8 = write_data8 + i;
      `uvm_do_with(req, { req.address == start_addr8; req.data == write_data8; req.direction8 == WRITE; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
      end
    endtask
  
  function void post_randomize();
      write_data8 = rand_data8;
  endfunction
endclass : ahb_to_spi_wr8

// writes 1 data in GPIO8 TX8 REG
class ahb_to_gpio_wr8 extends uvm_sequence #(ahb_transfer8);

    function new(string name="ahb_to_gpio_wr8");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    rand bit unsigned[31:0] rand_data8;
    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH8-1:0] start_addr8;
    rand bit [`AHB_DATA_WIDTH8-1:0] write_data8;

    virtual task body();
      start_addr8 = base_addr + `GPIO_OUTPUT_VALUE_REG8;
      `uvm_do_with(req, { req.address == start_addr8; req.data == write_data8; req.direction8 == WRITE; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
    endtask
  
  function void post_randomize();
      write_data8 = rand_data8;
  endfunction
endclass : ahb_to_gpio_wr8

// Low8 Power8 CPF8 test
class shutdown_dut8 extends uvm_sequence #(ahb_transfer8);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    function new(string name="shutdown_dut8");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH8-1:0] start_addr8;

    rand bit [`AHB_DATA_WIDTH8-1:0] write_data8;
    constraint uart_smc_shut8 { (write_data8 >= 1 && write_data8 <= 3); }

    virtual task body();
      start_addr8 = 32'h00860004;
      //write_data8 = 32'h01;

     if (write_data8 == 1)
      `uvm_info("SEQ", ("shutdown_dut8 sequence is shutting8 down UART8 "), UVM_MEDIUM)
     else if (write_data8 == 2) 
      `uvm_info("SEQ", ("shutdown_dut8 sequence is shutting8 down SMC8 "), UVM_MEDIUM)
     else if (write_data8 == 3) 
      `uvm_info("SEQ", ("shutdown_dut8 sequence is shutting8 down UART8 and SMC8 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr8; req.data == write_data8; req.direction8 == WRITE; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
    endtask
  
endclass :  shutdown_dut8

// Low8 Power8 CPF8 test
class poweron_dut8 extends uvm_sequence #(ahb_transfer8);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    function new(string name="poweron_dut8");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH8-1:0] start_addr8;
    bit [`AHB_DATA_WIDTH8-1:0] write_data8;

    virtual task body();
      start_addr8 = 32'h00860004;
      write_data8 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut8 sequence is switching8 on PDurt8"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr8; req.data == write_data8; req.direction8 == WRITE; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
    endtask
  
endclass : poweron_dut8

// Reads8 UART8 RX8 FIFO
class intrpt_seq8 extends uvm_sequence #(ahb_transfer8);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    function new(string name="intrpt_seq8");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH8-1:0] read_addr8;
    rand int unsigned num_of_rd8;
    constraint num_of_rd_ct8 { (num_of_rd8 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH8-1:0] read_data8;

      for (int i = 0; i < num_of_rd8; i++) begin
        read_addr8 = base_addr + `RX_FIFO_REG8;      //rx8 fifo address
        `uvm_do_with(req, { req.address == read_addr8; req.data == read_data8; req.direction8 == READ; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG8 DATA8 is `x%0h", read_data8), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq8

// Reads8 SPI8 RX8 REG
class read_spi_rx_reg8 extends uvm_sequence #(ahb_transfer8);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    function new(string name="read_spi_rx_reg8");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH8-1:0] read_addr8;
    rand int unsigned num_of_rd8;
    constraint num_of_rd_ct8 { (num_of_rd8 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH8-1:0] read_data8;

      for (int i = 0; i < num_of_rd8; i++) begin
        read_addr8 = base_addr + `SPI_RX0_REG8;
        `uvm_do_with(req, { req.address == read_addr8; req.data == read_data8; req.direction8 == READ; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
        `uvm_info("SEQ", $psprintf("Read DATA8 is `x%0h", read_data8), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg8

// Reads8 GPIO8 INPUT_VALUE8 REG
class read_gpio_rx_reg8 extends uvm_sequence #(ahb_transfer8);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg8)
    `uvm_declare_p_sequencer(ahb_pkg8::ahb_master_sequencer8)    

    function new(string name="read_gpio_rx_reg8");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH8-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH8-1:0] read_addr8;

    virtual task body();
      bit [`AHB_DATA_WIDTH8-1:0] read_data8;

      read_addr8 = base_addr + `GPIO_INPUT_VALUE_REG8;
      `uvm_do_with(req, { req.address == read_addr8; req.data == read_data8; req.direction8 == READ; req.burst == ahb_pkg8::SINGLE8; req.hsize8 == ahb_pkg8::WORD8;} )
      `uvm_info("SEQ", $psprintf("Read DATA8 is `x%0h", read_data8), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg8

