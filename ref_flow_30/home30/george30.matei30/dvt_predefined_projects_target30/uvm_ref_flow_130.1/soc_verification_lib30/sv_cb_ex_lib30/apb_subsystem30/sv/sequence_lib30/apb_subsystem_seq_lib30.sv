/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_seq_lib30.sv
Title30       : 
Project30     :
Created30     :
Description30 : This30 file implements30 APB30 Sequences30 specific30 to UART30 
            : CSR30 programming30 and Tx30/Rx30 FIFO write/read
Notes30       : The interrupt30 sequence in this file is not yet complete.
            : The interrupt30 sequence should be triggred30 by the Rx30 fifo 
            : full event from the UART30 RTL30.
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

// writes 0-150 data in UART30 TX30 FIFO
class ahb_to_uart_wr30 extends uvm_sequence #(ahb_transfer30);

    function new(string name="ahb_to_uart_wr30");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    rand bit unsigned[31:0] rand_data30;
    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH30-1:0] start_addr30;
    rand bit [`AHB_DATA_WIDTH30-1:0] write_data30;
    rand int unsigned num_of_wr30;
    constraint num_of_wr_ct30 { (num_of_wr30 <= 150); }

    virtual task body();
      start_addr30 = base_addr + `TX_FIFO_REG30;
      for (int i = 0; i < num_of_wr30; i++) begin
      write_data30 = write_data30 + i;
      `uvm_do_with(req, { req.address == start_addr30; req.data == write_data30; req.direction30 == WRITE; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
      end
    endtask
  
  function void post_randomize();
      write_data30 = rand_data30;
  endfunction
endclass : ahb_to_uart_wr30

// writes 0-150 data in SPI30 TX30 FIFO
class ahb_to_spi_wr30 extends uvm_sequence #(ahb_transfer30);

    function new(string name="ahb_to_spi_wr30");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    rand bit unsigned[31:0] rand_data30;
    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH30-1:0] start_addr30;
    rand bit [`AHB_DATA_WIDTH30-1:0] write_data30;
    rand int unsigned num_of_wr30;
    constraint num_of_wr_ct30 { (num_of_wr30 <= 150); }

    virtual task body();
      start_addr30 = base_addr + `SPI_TX0_REG30;
      for (int i = 0; i < num_of_wr30; i++) begin
      write_data30 = write_data30 + i;
      `uvm_do_with(req, { req.address == start_addr30; req.data == write_data30; req.direction30 == WRITE; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
      end
    endtask
  
  function void post_randomize();
      write_data30 = rand_data30;
  endfunction
endclass : ahb_to_spi_wr30

// writes 1 data in GPIO30 TX30 REG
class ahb_to_gpio_wr30 extends uvm_sequence #(ahb_transfer30);

    function new(string name="ahb_to_gpio_wr30");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    rand bit unsigned[31:0] rand_data30;
    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH30-1:0] start_addr30;
    rand bit [`AHB_DATA_WIDTH30-1:0] write_data30;

    virtual task body();
      start_addr30 = base_addr + `GPIO_OUTPUT_VALUE_REG30;
      `uvm_do_with(req, { req.address == start_addr30; req.data == write_data30; req.direction30 == WRITE; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
    endtask
  
  function void post_randomize();
      write_data30 = rand_data30;
  endfunction
endclass : ahb_to_gpio_wr30

// Low30 Power30 CPF30 test
class shutdown_dut30 extends uvm_sequence #(ahb_transfer30);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    function new(string name="shutdown_dut30");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH30-1:0] start_addr30;

    rand bit [`AHB_DATA_WIDTH30-1:0] write_data30;
    constraint uart_smc_shut30 { (write_data30 >= 1 && write_data30 <= 3); }

    virtual task body();
      start_addr30 = 32'h00860004;
      //write_data30 = 32'h01;

     if (write_data30 == 1)
      `uvm_info("SEQ", ("shutdown_dut30 sequence is shutting30 down UART30 "), UVM_MEDIUM)
     else if (write_data30 == 2) 
      `uvm_info("SEQ", ("shutdown_dut30 sequence is shutting30 down SMC30 "), UVM_MEDIUM)
     else if (write_data30 == 3) 
      `uvm_info("SEQ", ("shutdown_dut30 sequence is shutting30 down UART30 and SMC30 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr30; req.data == write_data30; req.direction30 == WRITE; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
    endtask
  
endclass :  shutdown_dut30

// Low30 Power30 CPF30 test
class poweron_dut30 extends uvm_sequence #(ahb_transfer30);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    function new(string name="poweron_dut30");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH30-1:0] start_addr30;
    bit [`AHB_DATA_WIDTH30-1:0] write_data30;

    virtual task body();
      start_addr30 = 32'h00860004;
      write_data30 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut30 sequence is switching30 on PDurt30"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr30; req.data == write_data30; req.direction30 == WRITE; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
    endtask
  
endclass : poweron_dut30

// Reads30 UART30 RX30 FIFO
class intrpt_seq30 extends uvm_sequence #(ahb_transfer30);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    function new(string name="intrpt_seq30");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH30-1:0] read_addr30;
    rand int unsigned num_of_rd30;
    constraint num_of_rd_ct30 { (num_of_rd30 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH30-1:0] read_data30;

      for (int i = 0; i < num_of_rd30; i++) begin
        read_addr30 = base_addr + `RX_FIFO_REG30;      //rx30 fifo address
        `uvm_do_with(req, { req.address == read_addr30; req.data == read_data30; req.direction30 == READ; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG30 DATA30 is `x%0h", read_data30), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq30

// Reads30 SPI30 RX30 REG
class read_spi_rx_reg30 extends uvm_sequence #(ahb_transfer30);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    function new(string name="read_spi_rx_reg30");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH30-1:0] read_addr30;
    rand int unsigned num_of_rd30;
    constraint num_of_rd_ct30 { (num_of_rd30 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH30-1:0] read_data30;

      for (int i = 0; i < num_of_rd30; i++) begin
        read_addr30 = base_addr + `SPI_RX0_REG30;
        `uvm_do_with(req, { req.address == read_addr30; req.data == read_data30; req.direction30 == READ; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
        `uvm_info("SEQ", $psprintf("Read DATA30 is `x%0h", read_data30), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg30

// Reads30 GPIO30 INPUT_VALUE30 REG
class read_gpio_rx_reg30 extends uvm_sequence #(ahb_transfer30);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg30)
    `uvm_declare_p_sequencer(ahb_pkg30::ahb_master_sequencer30)    

    function new(string name="read_gpio_rx_reg30");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH30-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH30-1:0] read_addr30;

    virtual task body();
      bit [`AHB_DATA_WIDTH30-1:0] read_data30;

      read_addr30 = base_addr + `GPIO_INPUT_VALUE_REG30;
      `uvm_do_with(req, { req.address == read_addr30; req.data == read_data30; req.direction30 == READ; req.burst == ahb_pkg30::SINGLE30; req.hsize30 == ahb_pkg30::WORD30;} )
      `uvm_info("SEQ", $psprintf("Read DATA30 is `x%0h", read_data30), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg30

