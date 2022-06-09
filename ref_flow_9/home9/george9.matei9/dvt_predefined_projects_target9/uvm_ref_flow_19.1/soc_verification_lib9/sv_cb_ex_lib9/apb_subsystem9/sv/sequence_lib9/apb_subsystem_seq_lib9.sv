/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_seq_lib9.sv
Title9       : 
Project9     :
Created9     :
Description9 : This9 file implements9 APB9 Sequences9 specific9 to UART9 
            : CSR9 programming9 and Tx9/Rx9 FIFO write/read
Notes9       : The interrupt9 sequence in this file is not yet complete.
            : The interrupt9 sequence should be triggred9 by the Rx9 fifo 
            : full event from the UART9 RTL9.
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

// writes 0-150 data in UART9 TX9 FIFO
class ahb_to_uart_wr9 extends uvm_sequence #(ahb_transfer9);

    function new(string name="ahb_to_uart_wr9");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    rand bit unsigned[31:0] rand_data9;
    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH9-1:0] start_addr9;
    rand bit [`AHB_DATA_WIDTH9-1:0] write_data9;
    rand int unsigned num_of_wr9;
    constraint num_of_wr_ct9 { (num_of_wr9 <= 150); }

    virtual task body();
      start_addr9 = base_addr + `TX_FIFO_REG9;
      for (int i = 0; i < num_of_wr9; i++) begin
      write_data9 = write_data9 + i;
      `uvm_do_with(req, { req.address == start_addr9; req.data == write_data9; req.direction9 == WRITE; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
      end
    endtask
  
  function void post_randomize();
      write_data9 = rand_data9;
  endfunction
endclass : ahb_to_uart_wr9

// writes 0-150 data in SPI9 TX9 FIFO
class ahb_to_spi_wr9 extends uvm_sequence #(ahb_transfer9);

    function new(string name="ahb_to_spi_wr9");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    rand bit unsigned[31:0] rand_data9;
    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH9-1:0] start_addr9;
    rand bit [`AHB_DATA_WIDTH9-1:0] write_data9;
    rand int unsigned num_of_wr9;
    constraint num_of_wr_ct9 { (num_of_wr9 <= 150); }

    virtual task body();
      start_addr9 = base_addr + `SPI_TX0_REG9;
      for (int i = 0; i < num_of_wr9; i++) begin
      write_data9 = write_data9 + i;
      `uvm_do_with(req, { req.address == start_addr9; req.data == write_data9; req.direction9 == WRITE; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
      end
    endtask
  
  function void post_randomize();
      write_data9 = rand_data9;
  endfunction
endclass : ahb_to_spi_wr9

// writes 1 data in GPIO9 TX9 REG
class ahb_to_gpio_wr9 extends uvm_sequence #(ahb_transfer9);

    function new(string name="ahb_to_gpio_wr9");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    rand bit unsigned[31:0] rand_data9;
    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH9-1:0] start_addr9;
    rand bit [`AHB_DATA_WIDTH9-1:0] write_data9;

    virtual task body();
      start_addr9 = base_addr + `GPIO_OUTPUT_VALUE_REG9;
      `uvm_do_with(req, { req.address == start_addr9; req.data == write_data9; req.direction9 == WRITE; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
    endtask
  
  function void post_randomize();
      write_data9 = rand_data9;
  endfunction
endclass : ahb_to_gpio_wr9

// Low9 Power9 CPF9 test
class shutdown_dut9 extends uvm_sequence #(ahb_transfer9);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    function new(string name="shutdown_dut9");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH9-1:0] start_addr9;

    rand bit [`AHB_DATA_WIDTH9-1:0] write_data9;
    constraint uart_smc_shut9 { (write_data9 >= 1 && write_data9 <= 3); }

    virtual task body();
      start_addr9 = 32'h00860004;
      //write_data9 = 32'h01;

     if (write_data9 == 1)
      `uvm_info("SEQ", ("shutdown_dut9 sequence is shutting9 down UART9 "), UVM_MEDIUM)
     else if (write_data9 == 2) 
      `uvm_info("SEQ", ("shutdown_dut9 sequence is shutting9 down SMC9 "), UVM_MEDIUM)
     else if (write_data9 == 3) 
      `uvm_info("SEQ", ("shutdown_dut9 sequence is shutting9 down UART9 and SMC9 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr9; req.data == write_data9; req.direction9 == WRITE; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
    endtask
  
endclass :  shutdown_dut9

// Low9 Power9 CPF9 test
class poweron_dut9 extends uvm_sequence #(ahb_transfer9);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    function new(string name="poweron_dut9");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH9-1:0] start_addr9;
    bit [`AHB_DATA_WIDTH9-1:0] write_data9;

    virtual task body();
      start_addr9 = 32'h00860004;
      write_data9 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut9 sequence is switching9 on PDurt9"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr9; req.data == write_data9; req.direction9 == WRITE; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
    endtask
  
endclass : poweron_dut9

// Reads9 UART9 RX9 FIFO
class intrpt_seq9 extends uvm_sequence #(ahb_transfer9);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    function new(string name="intrpt_seq9");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH9-1:0] read_addr9;
    rand int unsigned num_of_rd9;
    constraint num_of_rd_ct9 { (num_of_rd9 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH9-1:0] read_data9;

      for (int i = 0; i < num_of_rd9; i++) begin
        read_addr9 = base_addr + `RX_FIFO_REG9;      //rx9 fifo address
        `uvm_do_with(req, { req.address == read_addr9; req.data == read_data9; req.direction9 == READ; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG9 DATA9 is `x%0h", read_data9), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq9

// Reads9 SPI9 RX9 REG
class read_spi_rx_reg9 extends uvm_sequence #(ahb_transfer9);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    function new(string name="read_spi_rx_reg9");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH9-1:0] read_addr9;
    rand int unsigned num_of_rd9;
    constraint num_of_rd_ct9 { (num_of_rd9 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH9-1:0] read_data9;

      for (int i = 0; i < num_of_rd9; i++) begin
        read_addr9 = base_addr + `SPI_RX0_REG9;
        `uvm_do_with(req, { req.address == read_addr9; req.data == read_data9; req.direction9 == READ; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
        `uvm_info("SEQ", $psprintf("Read DATA9 is `x%0h", read_data9), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg9

// Reads9 GPIO9 INPUT_VALUE9 REG
class read_gpio_rx_reg9 extends uvm_sequence #(ahb_transfer9);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg9)
    `uvm_declare_p_sequencer(ahb_pkg9::ahb_master_sequencer9)    

    function new(string name="read_gpio_rx_reg9");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH9-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH9-1:0] read_addr9;

    virtual task body();
      bit [`AHB_DATA_WIDTH9-1:0] read_data9;

      read_addr9 = base_addr + `GPIO_INPUT_VALUE_REG9;
      `uvm_do_with(req, { req.address == read_addr9; req.data == read_data9; req.direction9 == READ; req.burst == ahb_pkg9::SINGLE9; req.hsize9 == ahb_pkg9::WORD9;} )
      `uvm_info("SEQ", $psprintf("Read DATA9 is `x%0h", read_data9), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg9

