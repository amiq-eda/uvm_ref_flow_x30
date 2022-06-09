/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_seq_lib15.sv
Title15       : 
Project15     :
Created15     :
Description15 : This15 file implements15 APB15 Sequences15 specific15 to UART15 
            : CSR15 programming15 and Tx15/Rx15 FIFO write/read
Notes15       : The interrupt15 sequence in this file is not yet complete.
            : The interrupt15 sequence should be triggred15 by the Rx15 fifo 
            : full event from the UART15 RTL15.
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

// writes 0-150 data in UART15 TX15 FIFO
class ahb_to_uart_wr15 extends uvm_sequence #(ahb_transfer15);

    function new(string name="ahb_to_uart_wr15");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    rand bit unsigned[31:0] rand_data15;
    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH15-1:0] start_addr15;
    rand bit [`AHB_DATA_WIDTH15-1:0] write_data15;
    rand int unsigned num_of_wr15;
    constraint num_of_wr_ct15 { (num_of_wr15 <= 150); }

    virtual task body();
      start_addr15 = base_addr + `TX_FIFO_REG15;
      for (int i = 0; i < num_of_wr15; i++) begin
      write_data15 = write_data15 + i;
      `uvm_do_with(req, { req.address == start_addr15; req.data == write_data15; req.direction15 == WRITE; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
      end
    endtask
  
  function void post_randomize();
      write_data15 = rand_data15;
  endfunction
endclass : ahb_to_uart_wr15

// writes 0-150 data in SPI15 TX15 FIFO
class ahb_to_spi_wr15 extends uvm_sequence #(ahb_transfer15);

    function new(string name="ahb_to_spi_wr15");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    rand bit unsigned[31:0] rand_data15;
    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH15-1:0] start_addr15;
    rand bit [`AHB_DATA_WIDTH15-1:0] write_data15;
    rand int unsigned num_of_wr15;
    constraint num_of_wr_ct15 { (num_of_wr15 <= 150); }

    virtual task body();
      start_addr15 = base_addr + `SPI_TX0_REG15;
      for (int i = 0; i < num_of_wr15; i++) begin
      write_data15 = write_data15 + i;
      `uvm_do_with(req, { req.address == start_addr15; req.data == write_data15; req.direction15 == WRITE; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
      end
    endtask
  
  function void post_randomize();
      write_data15 = rand_data15;
  endfunction
endclass : ahb_to_spi_wr15

// writes 1 data in GPIO15 TX15 REG
class ahb_to_gpio_wr15 extends uvm_sequence #(ahb_transfer15);

    function new(string name="ahb_to_gpio_wr15");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    rand bit unsigned[31:0] rand_data15;
    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH15-1:0] start_addr15;
    rand bit [`AHB_DATA_WIDTH15-1:0] write_data15;

    virtual task body();
      start_addr15 = base_addr + `GPIO_OUTPUT_VALUE_REG15;
      `uvm_do_with(req, { req.address == start_addr15; req.data == write_data15; req.direction15 == WRITE; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
    endtask
  
  function void post_randomize();
      write_data15 = rand_data15;
  endfunction
endclass : ahb_to_gpio_wr15

// Low15 Power15 CPF15 test
class shutdown_dut15 extends uvm_sequence #(ahb_transfer15);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    function new(string name="shutdown_dut15");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH15-1:0] start_addr15;

    rand bit [`AHB_DATA_WIDTH15-1:0] write_data15;
    constraint uart_smc_shut15 { (write_data15 >= 1 && write_data15 <= 3); }

    virtual task body();
      start_addr15 = 32'h00860004;
      //write_data15 = 32'h01;

     if (write_data15 == 1)
      `uvm_info("SEQ", ("shutdown_dut15 sequence is shutting15 down UART15 "), UVM_MEDIUM)
     else if (write_data15 == 2) 
      `uvm_info("SEQ", ("shutdown_dut15 sequence is shutting15 down SMC15 "), UVM_MEDIUM)
     else if (write_data15 == 3) 
      `uvm_info("SEQ", ("shutdown_dut15 sequence is shutting15 down UART15 and SMC15 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr15; req.data == write_data15; req.direction15 == WRITE; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
    endtask
  
endclass :  shutdown_dut15

// Low15 Power15 CPF15 test
class poweron_dut15 extends uvm_sequence #(ahb_transfer15);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    function new(string name="poweron_dut15");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH15-1:0] start_addr15;
    bit [`AHB_DATA_WIDTH15-1:0] write_data15;

    virtual task body();
      start_addr15 = 32'h00860004;
      write_data15 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut15 sequence is switching15 on PDurt15"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr15; req.data == write_data15; req.direction15 == WRITE; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
    endtask
  
endclass : poweron_dut15

// Reads15 UART15 RX15 FIFO
class intrpt_seq15 extends uvm_sequence #(ahb_transfer15);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    function new(string name="intrpt_seq15");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH15-1:0] read_addr15;
    rand int unsigned num_of_rd15;
    constraint num_of_rd_ct15 { (num_of_rd15 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH15-1:0] read_data15;

      for (int i = 0; i < num_of_rd15; i++) begin
        read_addr15 = base_addr + `RX_FIFO_REG15;      //rx15 fifo address
        `uvm_do_with(req, { req.address == read_addr15; req.data == read_data15; req.direction15 == READ; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG15 DATA15 is `x%0h", read_data15), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq15

// Reads15 SPI15 RX15 REG
class read_spi_rx_reg15 extends uvm_sequence #(ahb_transfer15);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    function new(string name="read_spi_rx_reg15");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH15-1:0] read_addr15;
    rand int unsigned num_of_rd15;
    constraint num_of_rd_ct15 { (num_of_rd15 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH15-1:0] read_data15;

      for (int i = 0; i < num_of_rd15; i++) begin
        read_addr15 = base_addr + `SPI_RX0_REG15;
        `uvm_do_with(req, { req.address == read_addr15; req.data == read_data15; req.direction15 == READ; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
        `uvm_info("SEQ", $psprintf("Read DATA15 is `x%0h", read_data15), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg15

// Reads15 GPIO15 INPUT_VALUE15 REG
class read_gpio_rx_reg15 extends uvm_sequence #(ahb_transfer15);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg15)
    `uvm_declare_p_sequencer(ahb_pkg15::ahb_master_sequencer15)    

    function new(string name="read_gpio_rx_reg15");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH15-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH15-1:0] read_addr15;

    virtual task body();
      bit [`AHB_DATA_WIDTH15-1:0] read_data15;

      read_addr15 = base_addr + `GPIO_INPUT_VALUE_REG15;
      `uvm_do_with(req, { req.address == read_addr15; req.data == read_data15; req.direction15 == READ; req.burst == ahb_pkg15::SINGLE15; req.hsize15 == ahb_pkg15::WORD15;} )
      `uvm_info("SEQ", $psprintf("Read DATA15 is `x%0h", read_data15), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg15

