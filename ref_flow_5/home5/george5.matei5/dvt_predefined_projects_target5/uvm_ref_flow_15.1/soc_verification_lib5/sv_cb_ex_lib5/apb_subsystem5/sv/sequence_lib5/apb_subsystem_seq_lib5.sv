/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_seq_lib5.sv
Title5       : 
Project5     :
Created5     :
Description5 : This5 file implements5 APB5 Sequences5 specific5 to UART5 
            : CSR5 programming5 and Tx5/Rx5 FIFO write/read
Notes5       : The interrupt5 sequence in this file is not yet complete.
            : The interrupt5 sequence should be triggred5 by the Rx5 fifo 
            : full event from the UART5 RTL5.
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

// writes 0-150 data in UART5 TX5 FIFO
class ahb_to_uart_wr5 extends uvm_sequence #(ahb_transfer5);

    function new(string name="ahb_to_uart_wr5");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    rand bit unsigned[31:0] rand_data5;
    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH5-1:0] start_addr5;
    rand bit [`AHB_DATA_WIDTH5-1:0] write_data5;
    rand int unsigned num_of_wr5;
    constraint num_of_wr_ct5 { (num_of_wr5 <= 150); }

    virtual task body();
      start_addr5 = base_addr + `TX_FIFO_REG5;
      for (int i = 0; i < num_of_wr5; i++) begin
      write_data5 = write_data5 + i;
      `uvm_do_with(req, { req.address == start_addr5; req.data == write_data5; req.direction5 == WRITE; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
      end
    endtask
  
  function void post_randomize();
      write_data5 = rand_data5;
  endfunction
endclass : ahb_to_uart_wr5

// writes 0-150 data in SPI5 TX5 FIFO
class ahb_to_spi_wr5 extends uvm_sequence #(ahb_transfer5);

    function new(string name="ahb_to_spi_wr5");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    rand bit unsigned[31:0] rand_data5;
    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH5-1:0] start_addr5;
    rand bit [`AHB_DATA_WIDTH5-1:0] write_data5;
    rand int unsigned num_of_wr5;
    constraint num_of_wr_ct5 { (num_of_wr5 <= 150); }

    virtual task body();
      start_addr5 = base_addr + `SPI_TX0_REG5;
      for (int i = 0; i < num_of_wr5; i++) begin
      write_data5 = write_data5 + i;
      `uvm_do_with(req, { req.address == start_addr5; req.data == write_data5; req.direction5 == WRITE; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
      end
    endtask
  
  function void post_randomize();
      write_data5 = rand_data5;
  endfunction
endclass : ahb_to_spi_wr5

// writes 1 data in GPIO5 TX5 REG
class ahb_to_gpio_wr5 extends uvm_sequence #(ahb_transfer5);

    function new(string name="ahb_to_gpio_wr5");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    rand bit unsigned[31:0] rand_data5;
    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH5-1:0] start_addr5;
    rand bit [`AHB_DATA_WIDTH5-1:0] write_data5;

    virtual task body();
      start_addr5 = base_addr + `GPIO_OUTPUT_VALUE_REG5;
      `uvm_do_with(req, { req.address == start_addr5; req.data == write_data5; req.direction5 == WRITE; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
    endtask
  
  function void post_randomize();
      write_data5 = rand_data5;
  endfunction
endclass : ahb_to_gpio_wr5

// Low5 Power5 CPF5 test
class shutdown_dut5 extends uvm_sequence #(ahb_transfer5);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    function new(string name="shutdown_dut5");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH5-1:0] start_addr5;

    rand bit [`AHB_DATA_WIDTH5-1:0] write_data5;
    constraint uart_smc_shut5 { (write_data5 >= 1 && write_data5 <= 3); }

    virtual task body();
      start_addr5 = 32'h00860004;
      //write_data5 = 32'h01;

     if (write_data5 == 1)
      `uvm_info("SEQ", ("shutdown_dut5 sequence is shutting5 down UART5 "), UVM_MEDIUM)
     else if (write_data5 == 2) 
      `uvm_info("SEQ", ("shutdown_dut5 sequence is shutting5 down SMC5 "), UVM_MEDIUM)
     else if (write_data5 == 3) 
      `uvm_info("SEQ", ("shutdown_dut5 sequence is shutting5 down UART5 and SMC5 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr5; req.data == write_data5; req.direction5 == WRITE; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
    endtask
  
endclass :  shutdown_dut5

// Low5 Power5 CPF5 test
class poweron_dut5 extends uvm_sequence #(ahb_transfer5);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    function new(string name="poweron_dut5");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH5-1:0] start_addr5;
    bit [`AHB_DATA_WIDTH5-1:0] write_data5;

    virtual task body();
      start_addr5 = 32'h00860004;
      write_data5 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut5 sequence is switching5 on PDurt5"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr5; req.data == write_data5; req.direction5 == WRITE; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
    endtask
  
endclass : poweron_dut5

// Reads5 UART5 RX5 FIFO
class intrpt_seq5 extends uvm_sequence #(ahb_transfer5);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    function new(string name="intrpt_seq5");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH5-1:0] read_addr5;
    rand int unsigned num_of_rd5;
    constraint num_of_rd_ct5 { (num_of_rd5 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH5-1:0] read_data5;

      for (int i = 0; i < num_of_rd5; i++) begin
        read_addr5 = base_addr + `RX_FIFO_REG5;      //rx5 fifo address
        `uvm_do_with(req, { req.address == read_addr5; req.data == read_data5; req.direction5 == READ; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG5 DATA5 is `x%0h", read_data5), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq5

// Reads5 SPI5 RX5 REG
class read_spi_rx_reg5 extends uvm_sequence #(ahb_transfer5);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    function new(string name="read_spi_rx_reg5");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH5-1:0] read_addr5;
    rand int unsigned num_of_rd5;
    constraint num_of_rd_ct5 { (num_of_rd5 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH5-1:0] read_data5;

      for (int i = 0; i < num_of_rd5; i++) begin
        read_addr5 = base_addr + `SPI_RX0_REG5;
        `uvm_do_with(req, { req.address == read_addr5; req.data == read_data5; req.direction5 == READ; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
        `uvm_info("SEQ", $psprintf("Read DATA5 is `x%0h", read_data5), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg5

// Reads5 GPIO5 INPUT_VALUE5 REG
class read_gpio_rx_reg5 extends uvm_sequence #(ahb_transfer5);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg5)
    `uvm_declare_p_sequencer(ahb_pkg5::ahb_master_sequencer5)    

    function new(string name="read_gpio_rx_reg5");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH5-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH5-1:0] read_addr5;

    virtual task body();
      bit [`AHB_DATA_WIDTH5-1:0] read_data5;

      read_addr5 = base_addr + `GPIO_INPUT_VALUE_REG5;
      `uvm_do_with(req, { req.address == read_addr5; req.data == read_data5; req.direction5 == READ; req.burst == ahb_pkg5::SINGLE5; req.hsize5 == ahb_pkg5::WORD5;} )
      `uvm_info("SEQ", $psprintf("Read DATA5 is `x%0h", read_data5), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg5

