/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_seq_lib2.sv
Title2       : 
Project2     :
Created2     :
Description2 : This2 file implements2 APB2 Sequences2 specific2 to UART2 
            : CSR2 programming2 and Tx2/Rx2 FIFO write/read
Notes2       : The interrupt2 sequence in this file is not yet complete.
            : The interrupt2 sequence should be triggred2 by the Rx2 fifo 
            : full event from the UART2 RTL2.
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

// writes 0-150 data in UART2 TX2 FIFO
class ahb_to_uart_wr2 extends uvm_sequence #(ahb_transfer2);

    function new(string name="ahb_to_uart_wr2");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    rand bit unsigned[31:0] rand_data2;
    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH2-1:0] start_addr2;
    rand bit [`AHB_DATA_WIDTH2-1:0] write_data2;
    rand int unsigned num_of_wr2;
    constraint num_of_wr_ct2 { (num_of_wr2 <= 150); }

    virtual task body();
      start_addr2 = base_addr + `TX_FIFO_REG2;
      for (int i = 0; i < num_of_wr2; i++) begin
      write_data2 = write_data2 + i;
      `uvm_do_with(req, { req.address == start_addr2; req.data == write_data2; req.direction2 == WRITE; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
      end
    endtask
  
  function void post_randomize();
      write_data2 = rand_data2;
  endfunction
endclass : ahb_to_uart_wr2

// writes 0-150 data in SPI2 TX2 FIFO
class ahb_to_spi_wr2 extends uvm_sequence #(ahb_transfer2);

    function new(string name="ahb_to_spi_wr2");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    rand bit unsigned[31:0] rand_data2;
    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH2-1:0] start_addr2;
    rand bit [`AHB_DATA_WIDTH2-1:0] write_data2;
    rand int unsigned num_of_wr2;
    constraint num_of_wr_ct2 { (num_of_wr2 <= 150); }

    virtual task body();
      start_addr2 = base_addr + `SPI_TX0_REG2;
      for (int i = 0; i < num_of_wr2; i++) begin
      write_data2 = write_data2 + i;
      `uvm_do_with(req, { req.address == start_addr2; req.data == write_data2; req.direction2 == WRITE; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
      end
    endtask
  
  function void post_randomize();
      write_data2 = rand_data2;
  endfunction
endclass : ahb_to_spi_wr2

// writes 1 data in GPIO2 TX2 REG
class ahb_to_gpio_wr2 extends uvm_sequence #(ahb_transfer2);

    function new(string name="ahb_to_gpio_wr2");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    rand bit unsigned[31:0] rand_data2;
    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH2-1:0] start_addr2;
    rand bit [`AHB_DATA_WIDTH2-1:0] write_data2;

    virtual task body();
      start_addr2 = base_addr + `GPIO_OUTPUT_VALUE_REG2;
      `uvm_do_with(req, { req.address == start_addr2; req.data == write_data2; req.direction2 == WRITE; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
    endtask
  
  function void post_randomize();
      write_data2 = rand_data2;
  endfunction
endclass : ahb_to_gpio_wr2

// Low2 Power2 CPF2 test
class shutdown_dut2 extends uvm_sequence #(ahb_transfer2);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    function new(string name="shutdown_dut2");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH2-1:0] start_addr2;

    rand bit [`AHB_DATA_WIDTH2-1:0] write_data2;
    constraint uart_smc_shut2 { (write_data2 >= 1 && write_data2 <= 3); }

    virtual task body();
      start_addr2 = 32'h00860004;
      //write_data2 = 32'h01;

     if (write_data2 == 1)
      `uvm_info("SEQ", ("shutdown_dut2 sequence is shutting2 down UART2 "), UVM_MEDIUM)
     else if (write_data2 == 2) 
      `uvm_info("SEQ", ("shutdown_dut2 sequence is shutting2 down SMC2 "), UVM_MEDIUM)
     else if (write_data2 == 3) 
      `uvm_info("SEQ", ("shutdown_dut2 sequence is shutting2 down UART2 and SMC2 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr2; req.data == write_data2; req.direction2 == WRITE; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
    endtask
  
endclass :  shutdown_dut2

// Low2 Power2 CPF2 test
class poweron_dut2 extends uvm_sequence #(ahb_transfer2);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    function new(string name="poweron_dut2");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH2-1:0] start_addr2;
    bit [`AHB_DATA_WIDTH2-1:0] write_data2;

    virtual task body();
      start_addr2 = 32'h00860004;
      write_data2 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut2 sequence is switching2 on PDurt2"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr2; req.data == write_data2; req.direction2 == WRITE; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
    endtask
  
endclass : poweron_dut2

// Reads2 UART2 RX2 FIFO
class intrpt_seq2 extends uvm_sequence #(ahb_transfer2);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    function new(string name="intrpt_seq2");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH2-1:0] read_addr2;
    rand int unsigned num_of_rd2;
    constraint num_of_rd_ct2 { (num_of_rd2 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH2-1:0] read_data2;

      for (int i = 0; i < num_of_rd2; i++) begin
        read_addr2 = base_addr + `RX_FIFO_REG2;      //rx2 fifo address
        `uvm_do_with(req, { req.address == read_addr2; req.data == read_data2; req.direction2 == READ; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG2 DATA2 is `x%0h", read_data2), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq2

// Reads2 SPI2 RX2 REG
class read_spi_rx_reg2 extends uvm_sequence #(ahb_transfer2);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    function new(string name="read_spi_rx_reg2");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH2-1:0] read_addr2;
    rand int unsigned num_of_rd2;
    constraint num_of_rd_ct2 { (num_of_rd2 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH2-1:0] read_data2;

      for (int i = 0; i < num_of_rd2; i++) begin
        read_addr2 = base_addr + `SPI_RX0_REG2;
        `uvm_do_with(req, { req.address == read_addr2; req.data == read_data2; req.direction2 == READ; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
        `uvm_info("SEQ", $psprintf("Read DATA2 is `x%0h", read_data2), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg2

// Reads2 GPIO2 INPUT_VALUE2 REG
class read_gpio_rx_reg2 extends uvm_sequence #(ahb_transfer2);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg2)
    `uvm_declare_p_sequencer(ahb_pkg2::ahb_master_sequencer2)    

    function new(string name="read_gpio_rx_reg2");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH2-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH2-1:0] read_addr2;

    virtual task body();
      bit [`AHB_DATA_WIDTH2-1:0] read_data2;

      read_addr2 = base_addr + `GPIO_INPUT_VALUE_REG2;
      `uvm_do_with(req, { req.address == read_addr2; req.data == read_data2; req.direction2 == READ; req.burst == ahb_pkg2::SINGLE2; req.hsize2 == ahb_pkg2::WORD2;} )
      `uvm_info("SEQ", $psprintf("Read DATA2 is `x%0h", read_data2), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg2

