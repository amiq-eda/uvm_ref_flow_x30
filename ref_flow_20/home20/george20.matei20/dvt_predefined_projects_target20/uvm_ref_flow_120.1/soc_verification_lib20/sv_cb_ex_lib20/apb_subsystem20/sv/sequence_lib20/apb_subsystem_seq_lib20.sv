/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_seq_lib20.sv
Title20       : 
Project20     :
Created20     :
Description20 : This20 file implements20 APB20 Sequences20 specific20 to UART20 
            : CSR20 programming20 and Tx20/Rx20 FIFO write/read
Notes20       : The interrupt20 sequence in this file is not yet complete.
            : The interrupt20 sequence should be triggred20 by the Rx20 fifo 
            : full event from the UART20 RTL20.
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

// writes 0-150 data in UART20 TX20 FIFO
class ahb_to_uart_wr20 extends uvm_sequence #(ahb_transfer20);

    function new(string name="ahb_to_uart_wr20");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    rand bit unsigned[31:0] rand_data20;
    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH20-1:0] start_addr20;
    rand bit [`AHB_DATA_WIDTH20-1:0] write_data20;
    rand int unsigned num_of_wr20;
    constraint num_of_wr_ct20 { (num_of_wr20 <= 150); }

    virtual task body();
      start_addr20 = base_addr + `TX_FIFO_REG20;
      for (int i = 0; i < num_of_wr20; i++) begin
      write_data20 = write_data20 + i;
      `uvm_do_with(req, { req.address == start_addr20; req.data == write_data20; req.direction20 == WRITE; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
      end
    endtask
  
  function void post_randomize();
      write_data20 = rand_data20;
  endfunction
endclass : ahb_to_uart_wr20

// writes 0-150 data in SPI20 TX20 FIFO
class ahb_to_spi_wr20 extends uvm_sequence #(ahb_transfer20);

    function new(string name="ahb_to_spi_wr20");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    rand bit unsigned[31:0] rand_data20;
    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH20-1:0] start_addr20;
    rand bit [`AHB_DATA_WIDTH20-1:0] write_data20;
    rand int unsigned num_of_wr20;
    constraint num_of_wr_ct20 { (num_of_wr20 <= 150); }

    virtual task body();
      start_addr20 = base_addr + `SPI_TX0_REG20;
      for (int i = 0; i < num_of_wr20; i++) begin
      write_data20 = write_data20 + i;
      `uvm_do_with(req, { req.address == start_addr20; req.data == write_data20; req.direction20 == WRITE; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
      end
    endtask
  
  function void post_randomize();
      write_data20 = rand_data20;
  endfunction
endclass : ahb_to_spi_wr20

// writes 1 data in GPIO20 TX20 REG
class ahb_to_gpio_wr20 extends uvm_sequence #(ahb_transfer20);

    function new(string name="ahb_to_gpio_wr20");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    rand bit unsigned[31:0] rand_data20;
    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH20-1:0] start_addr20;
    rand bit [`AHB_DATA_WIDTH20-1:0] write_data20;

    virtual task body();
      start_addr20 = base_addr + `GPIO_OUTPUT_VALUE_REG20;
      `uvm_do_with(req, { req.address == start_addr20; req.data == write_data20; req.direction20 == WRITE; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
    endtask
  
  function void post_randomize();
      write_data20 = rand_data20;
  endfunction
endclass : ahb_to_gpio_wr20

// Low20 Power20 CPF20 test
class shutdown_dut20 extends uvm_sequence #(ahb_transfer20);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    function new(string name="shutdown_dut20");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH20-1:0] start_addr20;

    rand bit [`AHB_DATA_WIDTH20-1:0] write_data20;
    constraint uart_smc_shut20 { (write_data20 >= 1 && write_data20 <= 3); }

    virtual task body();
      start_addr20 = 32'h00860004;
      //write_data20 = 32'h01;

     if (write_data20 == 1)
      `uvm_info("SEQ", ("shutdown_dut20 sequence is shutting20 down UART20 "), UVM_MEDIUM)
     else if (write_data20 == 2) 
      `uvm_info("SEQ", ("shutdown_dut20 sequence is shutting20 down SMC20 "), UVM_MEDIUM)
     else if (write_data20 == 3) 
      `uvm_info("SEQ", ("shutdown_dut20 sequence is shutting20 down UART20 and SMC20 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr20; req.data == write_data20; req.direction20 == WRITE; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
    endtask
  
endclass :  shutdown_dut20

// Low20 Power20 CPF20 test
class poweron_dut20 extends uvm_sequence #(ahb_transfer20);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    function new(string name="poweron_dut20");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH20-1:0] start_addr20;
    bit [`AHB_DATA_WIDTH20-1:0] write_data20;

    virtual task body();
      start_addr20 = 32'h00860004;
      write_data20 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut20 sequence is switching20 on PDurt20"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr20; req.data == write_data20; req.direction20 == WRITE; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
    endtask
  
endclass : poweron_dut20

// Reads20 UART20 RX20 FIFO
class intrpt_seq20 extends uvm_sequence #(ahb_transfer20);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    function new(string name="intrpt_seq20");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH20-1:0] read_addr20;
    rand int unsigned num_of_rd20;
    constraint num_of_rd_ct20 { (num_of_rd20 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH20-1:0] read_data20;

      for (int i = 0; i < num_of_rd20; i++) begin
        read_addr20 = base_addr + `RX_FIFO_REG20;      //rx20 fifo address
        `uvm_do_with(req, { req.address == read_addr20; req.data == read_data20; req.direction20 == READ; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG20 DATA20 is `x%0h", read_data20), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq20

// Reads20 SPI20 RX20 REG
class read_spi_rx_reg20 extends uvm_sequence #(ahb_transfer20);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    function new(string name="read_spi_rx_reg20");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH20-1:0] read_addr20;
    rand int unsigned num_of_rd20;
    constraint num_of_rd_ct20 { (num_of_rd20 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH20-1:0] read_data20;

      for (int i = 0; i < num_of_rd20; i++) begin
        read_addr20 = base_addr + `SPI_RX0_REG20;
        `uvm_do_with(req, { req.address == read_addr20; req.data == read_data20; req.direction20 == READ; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
        `uvm_info("SEQ", $psprintf("Read DATA20 is `x%0h", read_data20), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg20

// Reads20 GPIO20 INPUT_VALUE20 REG
class read_gpio_rx_reg20 extends uvm_sequence #(ahb_transfer20);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg20)
    `uvm_declare_p_sequencer(ahb_pkg20::ahb_master_sequencer20)    

    function new(string name="read_gpio_rx_reg20");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH20-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH20-1:0] read_addr20;

    virtual task body();
      bit [`AHB_DATA_WIDTH20-1:0] read_data20;

      read_addr20 = base_addr + `GPIO_INPUT_VALUE_REG20;
      `uvm_do_with(req, { req.address == read_addr20; req.data == read_data20; req.direction20 == READ; req.burst == ahb_pkg20::SINGLE20; req.hsize20 == ahb_pkg20::WORD20;} )
      `uvm_info("SEQ", $psprintf("Read DATA20 is `x%0h", read_data20), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg20

