/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_seq_lib17.sv
Title17       : 
Project17     :
Created17     :
Description17 : This17 file implements17 APB17 Sequences17 specific17 to UART17 
            : CSR17 programming17 and Tx17/Rx17 FIFO write/read
Notes17       : The interrupt17 sequence in this file is not yet complete.
            : The interrupt17 sequence should be triggred17 by the Rx17 fifo 
            : full event from the UART17 RTL17.
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

// writes 0-150 data in UART17 TX17 FIFO
class ahb_to_uart_wr17 extends uvm_sequence #(ahb_transfer17);

    function new(string name="ahb_to_uart_wr17");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    rand bit unsigned[31:0] rand_data17;
    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH17-1:0] start_addr17;
    rand bit [`AHB_DATA_WIDTH17-1:0] write_data17;
    rand int unsigned num_of_wr17;
    constraint num_of_wr_ct17 { (num_of_wr17 <= 150); }

    virtual task body();
      start_addr17 = base_addr + `TX_FIFO_REG17;
      for (int i = 0; i < num_of_wr17; i++) begin
      write_data17 = write_data17 + i;
      `uvm_do_with(req, { req.address == start_addr17; req.data == write_data17; req.direction17 == WRITE; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
      end
    endtask
  
  function void post_randomize();
      write_data17 = rand_data17;
  endfunction
endclass : ahb_to_uart_wr17

// writes 0-150 data in SPI17 TX17 FIFO
class ahb_to_spi_wr17 extends uvm_sequence #(ahb_transfer17);

    function new(string name="ahb_to_spi_wr17");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    rand bit unsigned[31:0] rand_data17;
    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH17-1:0] start_addr17;
    rand bit [`AHB_DATA_WIDTH17-1:0] write_data17;
    rand int unsigned num_of_wr17;
    constraint num_of_wr_ct17 { (num_of_wr17 <= 150); }

    virtual task body();
      start_addr17 = base_addr + `SPI_TX0_REG17;
      for (int i = 0; i < num_of_wr17; i++) begin
      write_data17 = write_data17 + i;
      `uvm_do_with(req, { req.address == start_addr17; req.data == write_data17; req.direction17 == WRITE; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
      end
    endtask
  
  function void post_randomize();
      write_data17 = rand_data17;
  endfunction
endclass : ahb_to_spi_wr17

// writes 1 data in GPIO17 TX17 REG
class ahb_to_gpio_wr17 extends uvm_sequence #(ahb_transfer17);

    function new(string name="ahb_to_gpio_wr17");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    rand bit unsigned[31:0] rand_data17;
    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH17-1:0] start_addr17;
    rand bit [`AHB_DATA_WIDTH17-1:0] write_data17;

    virtual task body();
      start_addr17 = base_addr + `GPIO_OUTPUT_VALUE_REG17;
      `uvm_do_with(req, { req.address == start_addr17; req.data == write_data17; req.direction17 == WRITE; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
    endtask
  
  function void post_randomize();
      write_data17 = rand_data17;
  endfunction
endclass : ahb_to_gpio_wr17

// Low17 Power17 CPF17 test
class shutdown_dut17 extends uvm_sequence #(ahb_transfer17);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    function new(string name="shutdown_dut17");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH17-1:0] start_addr17;

    rand bit [`AHB_DATA_WIDTH17-1:0] write_data17;
    constraint uart_smc_shut17 { (write_data17 >= 1 && write_data17 <= 3); }

    virtual task body();
      start_addr17 = 32'h00860004;
      //write_data17 = 32'h01;

     if (write_data17 == 1)
      `uvm_info("SEQ", ("shutdown_dut17 sequence is shutting17 down UART17 "), UVM_MEDIUM)
     else if (write_data17 == 2) 
      `uvm_info("SEQ", ("shutdown_dut17 sequence is shutting17 down SMC17 "), UVM_MEDIUM)
     else if (write_data17 == 3) 
      `uvm_info("SEQ", ("shutdown_dut17 sequence is shutting17 down UART17 and SMC17 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr17; req.data == write_data17; req.direction17 == WRITE; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
    endtask
  
endclass :  shutdown_dut17

// Low17 Power17 CPF17 test
class poweron_dut17 extends uvm_sequence #(ahb_transfer17);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    function new(string name="poweron_dut17");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH17-1:0] start_addr17;
    bit [`AHB_DATA_WIDTH17-1:0] write_data17;

    virtual task body();
      start_addr17 = 32'h00860004;
      write_data17 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut17 sequence is switching17 on PDurt17"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr17; req.data == write_data17; req.direction17 == WRITE; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
    endtask
  
endclass : poweron_dut17

// Reads17 UART17 RX17 FIFO
class intrpt_seq17 extends uvm_sequence #(ahb_transfer17);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    function new(string name="intrpt_seq17");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH17-1:0] read_addr17;
    rand int unsigned num_of_rd17;
    constraint num_of_rd_ct17 { (num_of_rd17 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH17-1:0] read_data17;

      for (int i = 0; i < num_of_rd17; i++) begin
        read_addr17 = base_addr + `RX_FIFO_REG17;      //rx17 fifo address
        `uvm_do_with(req, { req.address == read_addr17; req.data == read_data17; req.direction17 == READ; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG17 DATA17 is `x%0h", read_data17), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq17

// Reads17 SPI17 RX17 REG
class read_spi_rx_reg17 extends uvm_sequence #(ahb_transfer17);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    function new(string name="read_spi_rx_reg17");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH17-1:0] read_addr17;
    rand int unsigned num_of_rd17;
    constraint num_of_rd_ct17 { (num_of_rd17 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH17-1:0] read_data17;

      for (int i = 0; i < num_of_rd17; i++) begin
        read_addr17 = base_addr + `SPI_RX0_REG17;
        `uvm_do_with(req, { req.address == read_addr17; req.data == read_data17; req.direction17 == READ; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
        `uvm_info("SEQ", $psprintf("Read DATA17 is `x%0h", read_data17), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg17

// Reads17 GPIO17 INPUT_VALUE17 REG
class read_gpio_rx_reg17 extends uvm_sequence #(ahb_transfer17);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg17)
    `uvm_declare_p_sequencer(ahb_pkg17::ahb_master_sequencer17)    

    function new(string name="read_gpio_rx_reg17");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH17-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH17-1:0] read_addr17;

    virtual task body();
      bit [`AHB_DATA_WIDTH17-1:0] read_data17;

      read_addr17 = base_addr + `GPIO_INPUT_VALUE_REG17;
      `uvm_do_with(req, { req.address == read_addr17; req.data == read_data17; req.direction17 == READ; req.burst == ahb_pkg17::SINGLE17; req.hsize17 == ahb_pkg17::WORD17;} )
      `uvm_info("SEQ", $psprintf("Read DATA17 is `x%0h", read_data17), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg17

