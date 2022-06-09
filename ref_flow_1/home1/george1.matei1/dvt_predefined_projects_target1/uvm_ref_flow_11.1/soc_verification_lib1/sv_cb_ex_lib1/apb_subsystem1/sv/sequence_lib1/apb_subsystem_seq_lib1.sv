/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_seq_lib1.sv
Title1       : 
Project1     :
Created1     :
Description1 : This1 file implements1 APB1 Sequences1 specific1 to UART1 
            : CSR1 programming1 and Tx1/Rx1 FIFO write/read
Notes1       : The interrupt1 sequence in this file is not yet complete.
            : The interrupt1 sequence should be triggred1 by the Rx1 fifo 
            : full event from the UART1 RTL1.
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

// writes 0-150 data in UART1 TX1 FIFO
class ahb_to_uart_wr1 extends uvm_sequence #(ahb_transfer1);

    function new(string name="ahb_to_uart_wr1");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    rand bit unsigned[31:0] rand_data1;
    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH1-1:0] start_addr1;
    rand bit [`AHB_DATA_WIDTH1-1:0] write_data1;
    rand int unsigned num_of_wr1;
    constraint num_of_wr_ct1 { (num_of_wr1 <= 150); }

    virtual task body();
      start_addr1 = base_addr + `TX_FIFO_REG1;
      for (int i = 0; i < num_of_wr1; i++) begin
      write_data1 = write_data1 + i;
      `uvm_do_with(req, { req.address == start_addr1; req.data == write_data1; req.direction1 == WRITE; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
      end
    endtask
  
  function void post_randomize();
      write_data1 = rand_data1;
  endfunction
endclass : ahb_to_uart_wr1

// writes 0-150 data in SPI1 TX1 FIFO
class ahb_to_spi_wr1 extends uvm_sequence #(ahb_transfer1);

    function new(string name="ahb_to_spi_wr1");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    rand bit unsigned[31:0] rand_data1;
    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH1-1:0] start_addr1;
    rand bit [`AHB_DATA_WIDTH1-1:0] write_data1;
    rand int unsigned num_of_wr1;
    constraint num_of_wr_ct1 { (num_of_wr1 <= 150); }

    virtual task body();
      start_addr1 = base_addr + `SPI_TX0_REG1;
      for (int i = 0; i < num_of_wr1; i++) begin
      write_data1 = write_data1 + i;
      `uvm_do_with(req, { req.address == start_addr1; req.data == write_data1; req.direction1 == WRITE; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
      end
    endtask
  
  function void post_randomize();
      write_data1 = rand_data1;
  endfunction
endclass : ahb_to_spi_wr1

// writes 1 data in GPIO1 TX1 REG
class ahb_to_gpio_wr1 extends uvm_sequence #(ahb_transfer1);

    function new(string name="ahb_to_gpio_wr1");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    rand bit unsigned[31:0] rand_data1;
    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH1-1:0] start_addr1;
    rand bit [`AHB_DATA_WIDTH1-1:0] write_data1;

    virtual task body();
      start_addr1 = base_addr + `GPIO_OUTPUT_VALUE_REG1;
      `uvm_do_with(req, { req.address == start_addr1; req.data == write_data1; req.direction1 == WRITE; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
    endtask
  
  function void post_randomize();
      write_data1 = rand_data1;
  endfunction
endclass : ahb_to_gpio_wr1

// Low1 Power1 CPF1 test
class shutdown_dut1 extends uvm_sequence #(ahb_transfer1);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    function new(string name="shutdown_dut1");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH1-1:0] start_addr1;

    rand bit [`AHB_DATA_WIDTH1-1:0] write_data1;
    constraint uart_smc_shut1 { (write_data1 >= 1 && write_data1 <= 3); }

    virtual task body();
      start_addr1 = 32'h00860004;
      //write_data1 = 32'h01;

     if (write_data1 == 1)
      `uvm_info("SEQ", ("shutdown_dut1 sequence is shutting1 down UART1 "), UVM_MEDIUM)
     else if (write_data1 == 2) 
      `uvm_info("SEQ", ("shutdown_dut1 sequence is shutting1 down SMC1 "), UVM_MEDIUM)
     else if (write_data1 == 3) 
      `uvm_info("SEQ", ("shutdown_dut1 sequence is shutting1 down UART1 and SMC1 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr1; req.data == write_data1; req.direction1 == WRITE; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
    endtask
  
endclass :  shutdown_dut1

// Low1 Power1 CPF1 test
class poweron_dut1 extends uvm_sequence #(ahb_transfer1);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    function new(string name="poweron_dut1");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH1-1:0] start_addr1;
    bit [`AHB_DATA_WIDTH1-1:0] write_data1;

    virtual task body();
      start_addr1 = 32'h00860004;
      write_data1 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut1 sequence is switching1 on PDurt1"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr1; req.data == write_data1; req.direction1 == WRITE; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
    endtask
  
endclass : poweron_dut1

// Reads1 UART1 RX1 FIFO
class intrpt_seq1 extends uvm_sequence #(ahb_transfer1);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    function new(string name="intrpt_seq1");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH1-1:0] read_addr1;
    rand int unsigned num_of_rd1;
    constraint num_of_rd_ct1 { (num_of_rd1 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH1-1:0] read_data1;

      for (int i = 0; i < num_of_rd1; i++) begin
        read_addr1 = base_addr + `RX_FIFO_REG1;      //rx1 fifo address
        `uvm_do_with(req, { req.address == read_addr1; req.data == read_data1; req.direction1 == READ; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG1 DATA1 is `x%0h", read_data1), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq1

// Reads1 SPI1 RX1 REG
class read_spi_rx_reg1 extends uvm_sequence #(ahb_transfer1);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    function new(string name="read_spi_rx_reg1");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH1-1:0] read_addr1;
    rand int unsigned num_of_rd1;
    constraint num_of_rd_ct1 { (num_of_rd1 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH1-1:0] read_data1;

      for (int i = 0; i < num_of_rd1; i++) begin
        read_addr1 = base_addr + `SPI_RX0_REG1;
        `uvm_do_with(req, { req.address == read_addr1; req.data == read_data1; req.direction1 == READ; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
        `uvm_info("SEQ", $psprintf("Read DATA1 is `x%0h", read_data1), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg1

// Reads1 GPIO1 INPUT_VALUE1 REG
class read_gpio_rx_reg1 extends uvm_sequence #(ahb_transfer1);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg1)
    `uvm_declare_p_sequencer(ahb_pkg1::ahb_master_sequencer1)    

    function new(string name="read_gpio_rx_reg1");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH1-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH1-1:0] read_addr1;

    virtual task body();
      bit [`AHB_DATA_WIDTH1-1:0] read_data1;

      read_addr1 = base_addr + `GPIO_INPUT_VALUE_REG1;
      `uvm_do_with(req, { req.address == read_addr1; req.data == read_data1; req.direction1 == READ; req.burst == ahb_pkg1::SINGLE1; req.hsize1 == ahb_pkg1::WORD1;} )
      `uvm_info("SEQ", $psprintf("Read DATA1 is `x%0h", read_data1), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg1

