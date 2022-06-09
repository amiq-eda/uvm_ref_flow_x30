/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_seq_lib18.sv
Title18       : 
Project18     :
Created18     :
Description18 : This18 file implements18 APB18 Sequences18 specific18 to UART18 
            : CSR18 programming18 and Tx18/Rx18 FIFO write/read
Notes18       : The interrupt18 sequence in this file is not yet complete.
            : The interrupt18 sequence should be triggred18 by the Rx18 fifo 
            : full event from the UART18 RTL18.
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

// writes 0-150 data in UART18 TX18 FIFO
class ahb_to_uart_wr18 extends uvm_sequence #(ahb_transfer18);

    function new(string name="ahb_to_uart_wr18");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    rand bit unsigned[31:0] rand_data18;
    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH18-1:0] start_addr18;
    rand bit [`AHB_DATA_WIDTH18-1:0] write_data18;
    rand int unsigned num_of_wr18;
    constraint num_of_wr_ct18 { (num_of_wr18 <= 150); }

    virtual task body();
      start_addr18 = base_addr + `TX_FIFO_REG18;
      for (int i = 0; i < num_of_wr18; i++) begin
      write_data18 = write_data18 + i;
      `uvm_do_with(req, { req.address == start_addr18; req.data == write_data18; req.direction18 == WRITE; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
      end
    endtask
  
  function void post_randomize();
      write_data18 = rand_data18;
  endfunction
endclass : ahb_to_uart_wr18

// writes 0-150 data in SPI18 TX18 FIFO
class ahb_to_spi_wr18 extends uvm_sequence #(ahb_transfer18);

    function new(string name="ahb_to_spi_wr18");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    rand bit unsigned[31:0] rand_data18;
    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH18-1:0] start_addr18;
    rand bit [`AHB_DATA_WIDTH18-1:0] write_data18;
    rand int unsigned num_of_wr18;
    constraint num_of_wr_ct18 { (num_of_wr18 <= 150); }

    virtual task body();
      start_addr18 = base_addr + `SPI_TX0_REG18;
      for (int i = 0; i < num_of_wr18; i++) begin
      write_data18 = write_data18 + i;
      `uvm_do_with(req, { req.address == start_addr18; req.data == write_data18; req.direction18 == WRITE; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
      end
    endtask
  
  function void post_randomize();
      write_data18 = rand_data18;
  endfunction
endclass : ahb_to_spi_wr18

// writes 1 data in GPIO18 TX18 REG
class ahb_to_gpio_wr18 extends uvm_sequence #(ahb_transfer18);

    function new(string name="ahb_to_gpio_wr18");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    rand bit unsigned[31:0] rand_data18;
    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH18-1:0] start_addr18;
    rand bit [`AHB_DATA_WIDTH18-1:0] write_data18;

    virtual task body();
      start_addr18 = base_addr + `GPIO_OUTPUT_VALUE_REG18;
      `uvm_do_with(req, { req.address == start_addr18; req.data == write_data18; req.direction18 == WRITE; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
    endtask
  
  function void post_randomize();
      write_data18 = rand_data18;
  endfunction
endclass : ahb_to_gpio_wr18

// Low18 Power18 CPF18 test
class shutdown_dut18 extends uvm_sequence #(ahb_transfer18);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    function new(string name="shutdown_dut18");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH18-1:0] start_addr18;

    rand bit [`AHB_DATA_WIDTH18-1:0] write_data18;
    constraint uart_smc_shut18 { (write_data18 >= 1 && write_data18 <= 3); }

    virtual task body();
      start_addr18 = 32'h00860004;
      //write_data18 = 32'h01;

     if (write_data18 == 1)
      `uvm_info("SEQ", ("shutdown_dut18 sequence is shutting18 down UART18 "), UVM_MEDIUM)
     else if (write_data18 == 2) 
      `uvm_info("SEQ", ("shutdown_dut18 sequence is shutting18 down SMC18 "), UVM_MEDIUM)
     else if (write_data18 == 3) 
      `uvm_info("SEQ", ("shutdown_dut18 sequence is shutting18 down UART18 and SMC18 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr18; req.data == write_data18; req.direction18 == WRITE; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
    endtask
  
endclass :  shutdown_dut18

// Low18 Power18 CPF18 test
class poweron_dut18 extends uvm_sequence #(ahb_transfer18);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    function new(string name="poweron_dut18");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH18-1:0] start_addr18;
    bit [`AHB_DATA_WIDTH18-1:0] write_data18;

    virtual task body();
      start_addr18 = 32'h00860004;
      write_data18 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut18 sequence is switching18 on PDurt18"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr18; req.data == write_data18; req.direction18 == WRITE; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
    endtask
  
endclass : poweron_dut18

// Reads18 UART18 RX18 FIFO
class intrpt_seq18 extends uvm_sequence #(ahb_transfer18);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    function new(string name="intrpt_seq18");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH18-1:0] read_addr18;
    rand int unsigned num_of_rd18;
    constraint num_of_rd_ct18 { (num_of_rd18 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH18-1:0] read_data18;

      for (int i = 0; i < num_of_rd18; i++) begin
        read_addr18 = base_addr + `RX_FIFO_REG18;      //rx18 fifo address
        `uvm_do_with(req, { req.address == read_addr18; req.data == read_data18; req.direction18 == READ; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG18 DATA18 is `x%0h", read_data18), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq18

// Reads18 SPI18 RX18 REG
class read_spi_rx_reg18 extends uvm_sequence #(ahb_transfer18);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    function new(string name="read_spi_rx_reg18");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH18-1:0] read_addr18;
    rand int unsigned num_of_rd18;
    constraint num_of_rd_ct18 { (num_of_rd18 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH18-1:0] read_data18;

      for (int i = 0; i < num_of_rd18; i++) begin
        read_addr18 = base_addr + `SPI_RX0_REG18;
        `uvm_do_with(req, { req.address == read_addr18; req.data == read_data18; req.direction18 == READ; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
        `uvm_info("SEQ", $psprintf("Read DATA18 is `x%0h", read_data18), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg18

// Reads18 GPIO18 INPUT_VALUE18 REG
class read_gpio_rx_reg18 extends uvm_sequence #(ahb_transfer18);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg18)
    `uvm_declare_p_sequencer(ahb_pkg18::ahb_master_sequencer18)    

    function new(string name="read_gpio_rx_reg18");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH18-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH18-1:0] read_addr18;

    virtual task body();
      bit [`AHB_DATA_WIDTH18-1:0] read_data18;

      read_addr18 = base_addr + `GPIO_INPUT_VALUE_REG18;
      `uvm_do_with(req, { req.address == read_addr18; req.data == read_data18; req.direction18 == READ; req.burst == ahb_pkg18::SINGLE18; req.hsize18 == ahb_pkg18::WORD18;} )
      `uvm_info("SEQ", $psprintf("Read DATA18 is `x%0h", read_data18), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg18

