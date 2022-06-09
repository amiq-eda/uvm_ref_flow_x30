/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_seq_lib4.sv
Title4       : 
Project4     :
Created4     :
Description4 : This4 file implements4 APB4 Sequences4 specific4 to UART4 
            : CSR4 programming4 and Tx4/Rx4 FIFO write/read
Notes4       : The interrupt4 sequence in this file is not yet complete.
            : The interrupt4 sequence should be triggred4 by the Rx4 fifo 
            : full event from the UART4 RTL4.
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

// writes 0-150 data in UART4 TX4 FIFO
class ahb_to_uart_wr4 extends uvm_sequence #(ahb_transfer4);

    function new(string name="ahb_to_uart_wr4");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    rand bit unsigned[31:0] rand_data4;
    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH4-1:0] start_addr4;
    rand bit [`AHB_DATA_WIDTH4-1:0] write_data4;
    rand int unsigned num_of_wr4;
    constraint num_of_wr_ct4 { (num_of_wr4 <= 150); }

    virtual task body();
      start_addr4 = base_addr + `TX_FIFO_REG4;
      for (int i = 0; i < num_of_wr4; i++) begin
      write_data4 = write_data4 + i;
      `uvm_do_with(req, { req.address == start_addr4; req.data == write_data4; req.direction4 == WRITE; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
      end
    endtask
  
  function void post_randomize();
      write_data4 = rand_data4;
  endfunction
endclass : ahb_to_uart_wr4

// writes 0-150 data in SPI4 TX4 FIFO
class ahb_to_spi_wr4 extends uvm_sequence #(ahb_transfer4);

    function new(string name="ahb_to_spi_wr4");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    rand bit unsigned[31:0] rand_data4;
    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH4-1:0] start_addr4;
    rand bit [`AHB_DATA_WIDTH4-1:0] write_data4;
    rand int unsigned num_of_wr4;
    constraint num_of_wr_ct4 { (num_of_wr4 <= 150); }

    virtual task body();
      start_addr4 = base_addr + `SPI_TX0_REG4;
      for (int i = 0; i < num_of_wr4; i++) begin
      write_data4 = write_data4 + i;
      `uvm_do_with(req, { req.address == start_addr4; req.data == write_data4; req.direction4 == WRITE; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
      end
    endtask
  
  function void post_randomize();
      write_data4 = rand_data4;
  endfunction
endclass : ahb_to_spi_wr4

// writes 1 data in GPIO4 TX4 REG
class ahb_to_gpio_wr4 extends uvm_sequence #(ahb_transfer4);

    function new(string name="ahb_to_gpio_wr4");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    rand bit unsigned[31:0] rand_data4;
    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH4-1:0] start_addr4;
    rand bit [`AHB_DATA_WIDTH4-1:0] write_data4;

    virtual task body();
      start_addr4 = base_addr + `GPIO_OUTPUT_VALUE_REG4;
      `uvm_do_with(req, { req.address == start_addr4; req.data == write_data4; req.direction4 == WRITE; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
    endtask
  
  function void post_randomize();
      write_data4 = rand_data4;
  endfunction
endclass : ahb_to_gpio_wr4

// Low4 Power4 CPF4 test
class shutdown_dut4 extends uvm_sequence #(ahb_transfer4);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    function new(string name="shutdown_dut4");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH4-1:0] start_addr4;

    rand bit [`AHB_DATA_WIDTH4-1:0] write_data4;
    constraint uart_smc_shut4 { (write_data4 >= 1 && write_data4 <= 3); }

    virtual task body();
      start_addr4 = 32'h00860004;
      //write_data4 = 32'h01;

     if (write_data4 == 1)
      `uvm_info("SEQ", ("shutdown_dut4 sequence is shutting4 down UART4 "), UVM_MEDIUM)
     else if (write_data4 == 2) 
      `uvm_info("SEQ", ("shutdown_dut4 sequence is shutting4 down SMC4 "), UVM_MEDIUM)
     else if (write_data4 == 3) 
      `uvm_info("SEQ", ("shutdown_dut4 sequence is shutting4 down UART4 and SMC4 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr4; req.data == write_data4; req.direction4 == WRITE; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
    endtask
  
endclass :  shutdown_dut4

// Low4 Power4 CPF4 test
class poweron_dut4 extends uvm_sequence #(ahb_transfer4);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    function new(string name="poweron_dut4");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH4-1:0] start_addr4;
    bit [`AHB_DATA_WIDTH4-1:0] write_data4;

    virtual task body();
      start_addr4 = 32'h00860004;
      write_data4 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut4 sequence is switching4 on PDurt4"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr4; req.data == write_data4; req.direction4 == WRITE; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
    endtask
  
endclass : poweron_dut4

// Reads4 UART4 RX4 FIFO
class intrpt_seq4 extends uvm_sequence #(ahb_transfer4);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    function new(string name="intrpt_seq4");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH4-1:0] read_addr4;
    rand int unsigned num_of_rd4;
    constraint num_of_rd_ct4 { (num_of_rd4 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH4-1:0] read_data4;

      for (int i = 0; i < num_of_rd4; i++) begin
        read_addr4 = base_addr + `RX_FIFO_REG4;      //rx4 fifo address
        `uvm_do_with(req, { req.address == read_addr4; req.data == read_data4; req.direction4 == READ; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG4 DATA4 is `x%0h", read_data4), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq4

// Reads4 SPI4 RX4 REG
class read_spi_rx_reg4 extends uvm_sequence #(ahb_transfer4);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    function new(string name="read_spi_rx_reg4");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH4-1:0] read_addr4;
    rand int unsigned num_of_rd4;
    constraint num_of_rd_ct4 { (num_of_rd4 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH4-1:0] read_data4;

      for (int i = 0; i < num_of_rd4; i++) begin
        read_addr4 = base_addr + `SPI_RX0_REG4;
        `uvm_do_with(req, { req.address == read_addr4; req.data == read_data4; req.direction4 == READ; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
        `uvm_info("SEQ", $psprintf("Read DATA4 is `x%0h", read_data4), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg4

// Reads4 GPIO4 INPUT_VALUE4 REG
class read_gpio_rx_reg4 extends uvm_sequence #(ahb_transfer4);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg4)
    `uvm_declare_p_sequencer(ahb_pkg4::ahb_master_sequencer4)    

    function new(string name="read_gpio_rx_reg4");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH4-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH4-1:0] read_addr4;

    virtual task body();
      bit [`AHB_DATA_WIDTH4-1:0] read_data4;

      read_addr4 = base_addr + `GPIO_INPUT_VALUE_REG4;
      `uvm_do_with(req, { req.address == read_addr4; req.data == read_data4; req.direction4 == READ; req.burst == ahb_pkg4::SINGLE4; req.hsize4 == ahb_pkg4::WORD4;} )
      `uvm_info("SEQ", $psprintf("Read DATA4 is `x%0h", read_data4), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg4

