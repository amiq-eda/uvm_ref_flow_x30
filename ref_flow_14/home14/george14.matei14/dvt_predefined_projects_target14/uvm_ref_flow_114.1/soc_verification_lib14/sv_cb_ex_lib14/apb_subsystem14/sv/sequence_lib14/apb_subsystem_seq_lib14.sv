/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_seq_lib14.sv
Title14       : 
Project14     :
Created14     :
Description14 : This14 file implements14 APB14 Sequences14 specific14 to UART14 
            : CSR14 programming14 and Tx14/Rx14 FIFO write/read
Notes14       : The interrupt14 sequence in this file is not yet complete.
            : The interrupt14 sequence should be triggred14 by the Rx14 fifo 
            : full event from the UART14 RTL14.
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

// writes 0-150 data in UART14 TX14 FIFO
class ahb_to_uart_wr14 extends uvm_sequence #(ahb_transfer14);

    function new(string name="ahb_to_uart_wr14");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    rand bit unsigned[31:0] rand_data14;
    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH14-1:0] start_addr14;
    rand bit [`AHB_DATA_WIDTH14-1:0] write_data14;
    rand int unsigned num_of_wr14;
    constraint num_of_wr_ct14 { (num_of_wr14 <= 150); }

    virtual task body();
      start_addr14 = base_addr + `TX_FIFO_REG14;
      for (int i = 0; i < num_of_wr14; i++) begin
      write_data14 = write_data14 + i;
      `uvm_do_with(req, { req.address == start_addr14; req.data == write_data14; req.direction14 == WRITE; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
      end
    endtask
  
  function void post_randomize();
      write_data14 = rand_data14;
  endfunction
endclass : ahb_to_uart_wr14

// writes 0-150 data in SPI14 TX14 FIFO
class ahb_to_spi_wr14 extends uvm_sequence #(ahb_transfer14);

    function new(string name="ahb_to_spi_wr14");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    rand bit unsigned[31:0] rand_data14;
    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH14-1:0] start_addr14;
    rand bit [`AHB_DATA_WIDTH14-1:0] write_data14;
    rand int unsigned num_of_wr14;
    constraint num_of_wr_ct14 { (num_of_wr14 <= 150); }

    virtual task body();
      start_addr14 = base_addr + `SPI_TX0_REG14;
      for (int i = 0; i < num_of_wr14; i++) begin
      write_data14 = write_data14 + i;
      `uvm_do_with(req, { req.address == start_addr14; req.data == write_data14; req.direction14 == WRITE; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
      end
    endtask
  
  function void post_randomize();
      write_data14 = rand_data14;
  endfunction
endclass : ahb_to_spi_wr14

// writes 1 data in GPIO14 TX14 REG
class ahb_to_gpio_wr14 extends uvm_sequence #(ahb_transfer14);

    function new(string name="ahb_to_gpio_wr14");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    rand bit unsigned[31:0] rand_data14;
    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH14-1:0] start_addr14;
    rand bit [`AHB_DATA_WIDTH14-1:0] write_data14;

    virtual task body();
      start_addr14 = base_addr + `GPIO_OUTPUT_VALUE_REG14;
      `uvm_do_with(req, { req.address == start_addr14; req.data == write_data14; req.direction14 == WRITE; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
    endtask
  
  function void post_randomize();
      write_data14 = rand_data14;
  endfunction
endclass : ahb_to_gpio_wr14

// Low14 Power14 CPF14 test
class shutdown_dut14 extends uvm_sequence #(ahb_transfer14);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    function new(string name="shutdown_dut14");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH14-1:0] start_addr14;

    rand bit [`AHB_DATA_WIDTH14-1:0] write_data14;
    constraint uart_smc_shut14 { (write_data14 >= 1 && write_data14 <= 3); }

    virtual task body();
      start_addr14 = 32'h00860004;
      //write_data14 = 32'h01;

     if (write_data14 == 1)
      `uvm_info("SEQ", ("shutdown_dut14 sequence is shutting14 down UART14 "), UVM_MEDIUM)
     else if (write_data14 == 2) 
      `uvm_info("SEQ", ("shutdown_dut14 sequence is shutting14 down SMC14 "), UVM_MEDIUM)
     else if (write_data14 == 3) 
      `uvm_info("SEQ", ("shutdown_dut14 sequence is shutting14 down UART14 and SMC14 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr14; req.data == write_data14; req.direction14 == WRITE; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
    endtask
  
endclass :  shutdown_dut14

// Low14 Power14 CPF14 test
class poweron_dut14 extends uvm_sequence #(ahb_transfer14);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    function new(string name="poweron_dut14");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH14-1:0] start_addr14;
    bit [`AHB_DATA_WIDTH14-1:0] write_data14;

    virtual task body();
      start_addr14 = 32'h00860004;
      write_data14 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut14 sequence is switching14 on PDurt14"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr14; req.data == write_data14; req.direction14 == WRITE; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
    endtask
  
endclass : poweron_dut14

// Reads14 UART14 RX14 FIFO
class intrpt_seq14 extends uvm_sequence #(ahb_transfer14);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    function new(string name="intrpt_seq14");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH14-1:0] read_addr14;
    rand int unsigned num_of_rd14;
    constraint num_of_rd_ct14 { (num_of_rd14 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH14-1:0] read_data14;

      for (int i = 0; i < num_of_rd14; i++) begin
        read_addr14 = base_addr + `RX_FIFO_REG14;      //rx14 fifo address
        `uvm_do_with(req, { req.address == read_addr14; req.data == read_data14; req.direction14 == READ; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG14 DATA14 is `x%0h", read_data14), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq14

// Reads14 SPI14 RX14 REG
class read_spi_rx_reg14 extends uvm_sequence #(ahb_transfer14);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    function new(string name="read_spi_rx_reg14");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH14-1:0] read_addr14;
    rand int unsigned num_of_rd14;
    constraint num_of_rd_ct14 { (num_of_rd14 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH14-1:0] read_data14;

      for (int i = 0; i < num_of_rd14; i++) begin
        read_addr14 = base_addr + `SPI_RX0_REG14;
        `uvm_do_with(req, { req.address == read_addr14; req.data == read_data14; req.direction14 == READ; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
        `uvm_info("SEQ", $psprintf("Read DATA14 is `x%0h", read_data14), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg14

// Reads14 GPIO14 INPUT_VALUE14 REG
class read_gpio_rx_reg14 extends uvm_sequence #(ahb_transfer14);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg14)
    `uvm_declare_p_sequencer(ahb_pkg14::ahb_master_sequencer14)    

    function new(string name="read_gpio_rx_reg14");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH14-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH14-1:0] read_addr14;

    virtual task body();
      bit [`AHB_DATA_WIDTH14-1:0] read_data14;

      read_addr14 = base_addr + `GPIO_INPUT_VALUE_REG14;
      `uvm_do_with(req, { req.address == read_addr14; req.data == read_data14; req.direction14 == READ; req.burst == ahb_pkg14::SINGLE14; req.hsize14 == ahb_pkg14::WORD14;} )
      `uvm_info("SEQ", $psprintf("Read DATA14 is `x%0h", read_data14), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg14

