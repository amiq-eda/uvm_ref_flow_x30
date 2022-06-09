/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_seq_lib28.sv
Title28       : 
Project28     :
Created28     :
Description28 : This28 file implements28 APB28 Sequences28 specific28 to UART28 
            : CSR28 programming28 and Tx28/Rx28 FIFO write/read
Notes28       : The interrupt28 sequence in this file is not yet complete.
            : The interrupt28 sequence should be triggred28 by the Rx28 fifo 
            : full event from the UART28 RTL28.
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

// writes 0-150 data in UART28 TX28 FIFO
class ahb_to_uart_wr28 extends uvm_sequence #(ahb_transfer28);

    function new(string name="ahb_to_uart_wr28");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    rand bit unsigned[31:0] rand_data28;
    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH28-1:0] start_addr28;
    rand bit [`AHB_DATA_WIDTH28-1:0] write_data28;
    rand int unsigned num_of_wr28;
    constraint num_of_wr_ct28 { (num_of_wr28 <= 150); }

    virtual task body();
      start_addr28 = base_addr + `TX_FIFO_REG28;
      for (int i = 0; i < num_of_wr28; i++) begin
      write_data28 = write_data28 + i;
      `uvm_do_with(req, { req.address == start_addr28; req.data == write_data28; req.direction28 == WRITE; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
      end
    endtask
  
  function void post_randomize();
      write_data28 = rand_data28;
  endfunction
endclass : ahb_to_uart_wr28

// writes 0-150 data in SPI28 TX28 FIFO
class ahb_to_spi_wr28 extends uvm_sequence #(ahb_transfer28);

    function new(string name="ahb_to_spi_wr28");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    rand bit unsigned[31:0] rand_data28;
    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH28-1:0] start_addr28;
    rand bit [`AHB_DATA_WIDTH28-1:0] write_data28;
    rand int unsigned num_of_wr28;
    constraint num_of_wr_ct28 { (num_of_wr28 <= 150); }

    virtual task body();
      start_addr28 = base_addr + `SPI_TX0_REG28;
      for (int i = 0; i < num_of_wr28; i++) begin
      write_data28 = write_data28 + i;
      `uvm_do_with(req, { req.address == start_addr28; req.data == write_data28; req.direction28 == WRITE; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
      end
    endtask
  
  function void post_randomize();
      write_data28 = rand_data28;
  endfunction
endclass : ahb_to_spi_wr28

// writes 1 data in GPIO28 TX28 REG
class ahb_to_gpio_wr28 extends uvm_sequence #(ahb_transfer28);

    function new(string name="ahb_to_gpio_wr28");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    rand bit unsigned[31:0] rand_data28;
    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH28-1:0] start_addr28;
    rand bit [`AHB_DATA_WIDTH28-1:0] write_data28;

    virtual task body();
      start_addr28 = base_addr + `GPIO_OUTPUT_VALUE_REG28;
      `uvm_do_with(req, { req.address == start_addr28; req.data == write_data28; req.direction28 == WRITE; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
    endtask
  
  function void post_randomize();
      write_data28 = rand_data28;
  endfunction
endclass : ahb_to_gpio_wr28

// Low28 Power28 CPF28 test
class shutdown_dut28 extends uvm_sequence #(ahb_transfer28);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    function new(string name="shutdown_dut28");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH28-1:0] start_addr28;

    rand bit [`AHB_DATA_WIDTH28-1:0] write_data28;
    constraint uart_smc_shut28 { (write_data28 >= 1 && write_data28 <= 3); }

    virtual task body();
      start_addr28 = 32'h00860004;
      //write_data28 = 32'h01;

     if (write_data28 == 1)
      `uvm_info("SEQ", ("shutdown_dut28 sequence is shutting28 down UART28 "), UVM_MEDIUM)
     else if (write_data28 == 2) 
      `uvm_info("SEQ", ("shutdown_dut28 sequence is shutting28 down SMC28 "), UVM_MEDIUM)
     else if (write_data28 == 3) 
      `uvm_info("SEQ", ("shutdown_dut28 sequence is shutting28 down UART28 and SMC28 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr28; req.data == write_data28; req.direction28 == WRITE; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
    endtask
  
endclass :  shutdown_dut28

// Low28 Power28 CPF28 test
class poweron_dut28 extends uvm_sequence #(ahb_transfer28);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    function new(string name="poweron_dut28");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH28-1:0] start_addr28;
    bit [`AHB_DATA_WIDTH28-1:0] write_data28;

    virtual task body();
      start_addr28 = 32'h00860004;
      write_data28 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut28 sequence is switching28 on PDurt28"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr28; req.data == write_data28; req.direction28 == WRITE; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
    endtask
  
endclass : poweron_dut28

// Reads28 UART28 RX28 FIFO
class intrpt_seq28 extends uvm_sequence #(ahb_transfer28);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    function new(string name="intrpt_seq28");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH28-1:0] read_addr28;
    rand int unsigned num_of_rd28;
    constraint num_of_rd_ct28 { (num_of_rd28 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH28-1:0] read_data28;

      for (int i = 0; i < num_of_rd28; i++) begin
        read_addr28 = base_addr + `RX_FIFO_REG28;      //rx28 fifo address
        `uvm_do_with(req, { req.address == read_addr28; req.data == read_data28; req.direction28 == READ; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG28 DATA28 is `x%0h", read_data28), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq28

// Reads28 SPI28 RX28 REG
class read_spi_rx_reg28 extends uvm_sequence #(ahb_transfer28);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    function new(string name="read_spi_rx_reg28");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH28-1:0] read_addr28;
    rand int unsigned num_of_rd28;
    constraint num_of_rd_ct28 { (num_of_rd28 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH28-1:0] read_data28;

      for (int i = 0; i < num_of_rd28; i++) begin
        read_addr28 = base_addr + `SPI_RX0_REG28;
        `uvm_do_with(req, { req.address == read_addr28; req.data == read_data28; req.direction28 == READ; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
        `uvm_info("SEQ", $psprintf("Read DATA28 is `x%0h", read_data28), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg28

// Reads28 GPIO28 INPUT_VALUE28 REG
class read_gpio_rx_reg28 extends uvm_sequence #(ahb_transfer28);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg28)
    `uvm_declare_p_sequencer(ahb_pkg28::ahb_master_sequencer28)    

    function new(string name="read_gpio_rx_reg28");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH28-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH28-1:0] read_addr28;

    virtual task body();
      bit [`AHB_DATA_WIDTH28-1:0] read_data28;

      read_addr28 = base_addr + `GPIO_INPUT_VALUE_REG28;
      `uvm_do_with(req, { req.address == read_addr28; req.data == read_data28; req.direction28 == READ; req.burst == ahb_pkg28::SINGLE28; req.hsize28 == ahb_pkg28::WORD28;} )
      `uvm_info("SEQ", $psprintf("Read DATA28 is `x%0h", read_data28), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg28

