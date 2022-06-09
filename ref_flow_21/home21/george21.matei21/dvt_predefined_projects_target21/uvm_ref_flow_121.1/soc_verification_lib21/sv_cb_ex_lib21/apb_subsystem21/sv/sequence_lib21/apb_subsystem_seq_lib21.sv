/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_seq_lib21.sv
Title21       : 
Project21     :
Created21     :
Description21 : This21 file implements21 APB21 Sequences21 specific21 to UART21 
            : CSR21 programming21 and Tx21/Rx21 FIFO write/read
Notes21       : The interrupt21 sequence in this file is not yet complete.
            : The interrupt21 sequence should be triggred21 by the Rx21 fifo 
            : full event from the UART21 RTL21.
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

// writes 0-150 data in UART21 TX21 FIFO
class ahb_to_uart_wr21 extends uvm_sequence #(ahb_transfer21);

    function new(string name="ahb_to_uart_wr21");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_uart_wr21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    rand bit unsigned[31:0] rand_data21;
    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH21-1:0] start_addr21;
    rand bit [`AHB_DATA_WIDTH21-1:0] write_data21;
    rand int unsigned num_of_wr21;
    constraint num_of_wr_ct21 { (num_of_wr21 <= 150); }

    virtual task body();
      start_addr21 = base_addr + `TX_FIFO_REG21;
      for (int i = 0; i < num_of_wr21; i++) begin
      write_data21 = write_data21 + i;
      `uvm_do_with(req, { req.address == start_addr21; req.data == write_data21; req.direction21 == WRITE; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
      end
    endtask
  
  function void post_randomize();
      write_data21 = rand_data21;
  endfunction
endclass : ahb_to_uart_wr21

// writes 0-150 data in SPI21 TX21 FIFO
class ahb_to_spi_wr21 extends uvm_sequence #(ahb_transfer21);

    function new(string name="ahb_to_spi_wr21");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_spi_wr21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    rand bit unsigned[31:0] rand_data21;
    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH21-1:0] start_addr21;
    rand bit [`AHB_DATA_WIDTH21-1:0] write_data21;
    rand int unsigned num_of_wr21;
    constraint num_of_wr_ct21 { (num_of_wr21 <= 150); }

    virtual task body();
      start_addr21 = base_addr + `SPI_TX0_REG21;
      for (int i = 0; i < num_of_wr21; i++) begin
      write_data21 = write_data21 + i;
      `uvm_do_with(req, { req.address == start_addr21; req.data == write_data21; req.direction21 == WRITE; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
      end
    endtask
  
  function void post_randomize();
      write_data21 = rand_data21;
  endfunction
endclass : ahb_to_spi_wr21

// writes 1 data in GPIO21 TX21 REG
class ahb_to_gpio_wr21 extends uvm_sequence #(ahb_transfer21);

    function new(string name="ahb_to_gpio_wr21");
      super.new(name);
    endfunction

    // Register sequence with a sequencer 
    `uvm_object_utils(ahb_to_gpio_wr21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    rand bit unsigned[31:0] rand_data21;
    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;
    bit [`AHB_ADDR_WIDTH21-1:0] start_addr21;
    rand bit [`AHB_DATA_WIDTH21-1:0] write_data21;

    virtual task body();
      start_addr21 = base_addr + `GPIO_OUTPUT_VALUE_REG21;
      `uvm_do_with(req, { req.address == start_addr21; req.data == write_data21; req.direction21 == WRITE; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
    endtask
  
  function void post_randomize();
      write_data21 = rand_data21;
  endfunction
endclass : ahb_to_gpio_wr21

// Low21 Power21 CPF21 test
class shutdown_dut21 extends uvm_sequence #(ahb_transfer21);

    // Register sequence with a sequencer 
    `uvm_object_utils(shutdown_dut21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    function new(string name="shutdown_dut21");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH21-1:0] start_addr21;

    rand bit [`AHB_DATA_WIDTH21-1:0] write_data21;
    constraint uart_smc_shut21 { (write_data21 >= 1 && write_data21 <= 3); }

    virtual task body();
      start_addr21 = 32'h00860004;
      //write_data21 = 32'h01;

     if (write_data21 == 1)
      `uvm_info("SEQ", ("shutdown_dut21 sequence is shutting21 down UART21 "), UVM_MEDIUM)
     else if (write_data21 == 2) 
      `uvm_info("SEQ", ("shutdown_dut21 sequence is shutting21 down SMC21 "), UVM_MEDIUM)
     else if (write_data21 == 3) 
      `uvm_info("SEQ", ("shutdown_dut21 sequence is shutting21 down UART21 and SMC21 "), UVM_MEDIUM)

      `uvm_do_with(req, { req.address == start_addr21; req.data == write_data21; req.direction21 == WRITE; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
    endtask
  
endclass :  shutdown_dut21

// Low21 Power21 CPF21 test
class poweron_dut21 extends uvm_sequence #(ahb_transfer21);

    // Register sequence with a sequencer 
    `uvm_object_utils(poweron_dut21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    function new(string name="poweron_dut21");
      super.new(name);
    endfunction
  
    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;

    bit [`AHB_ADDR_WIDTH21-1:0] start_addr21;
    bit [`AHB_DATA_WIDTH21-1:0] write_data21;

    virtual task body();
      start_addr21 = 32'h00860004;
      write_data21 = 32'h00;
      `uvm_info("SEQ", ("poweron_dut21 sequence is switching21 on PDurt21"), UVM_MEDIUM)
      `uvm_do_with(req, { req.address == start_addr21; req.data == write_data21; req.direction21 == WRITE; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
    endtask
  
endclass : poweron_dut21

// Reads21 UART21 RX21 FIFO
class intrpt_seq21 extends uvm_sequence #(ahb_transfer21);

    // Register sequence with a sequencer 
    `uvm_object_utils(intrpt_seq21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    function new(string name="intrpt_seq21");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH21-1:0] read_addr21;
    rand int unsigned num_of_rd21;
    constraint num_of_rd_ct21 { (num_of_rd21 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH21-1:0] read_data21;

      for (int i = 0; i < num_of_rd21; i++) begin
        read_addr21 = base_addr + `RX_FIFO_REG21;      //rx21 fifo address
        `uvm_do_with(req, { req.address == read_addr21; req.data == read_data21; req.direction21 == READ; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
        `uvm_info("SEQ", $psprintf("Read RX_FIFO_REG21 DATA21 is `x%0h", read_data21), UVM_HIGH)
      end
    endtask
  
endclass : intrpt_seq21

// Reads21 SPI21 RX21 REG
class read_spi_rx_reg21 extends uvm_sequence #(ahb_transfer21);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_spi_rx_reg21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    function new(string name="read_spi_rx_reg21");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH21-1:0] read_addr21;
    rand int unsigned num_of_rd21;
    constraint num_of_rd_ct21 { (num_of_rd21 <= 150); }

    virtual task body();
      bit [`AHB_DATA_WIDTH21-1:0] read_data21;

      for (int i = 0; i < num_of_rd21; i++) begin
        read_addr21 = base_addr + `SPI_RX0_REG21;
        `uvm_do_with(req, { req.address == read_addr21; req.data == read_data21; req.direction21 == READ; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
        `uvm_info("SEQ", $psprintf("Read DATA21 is `x%0h", read_data21), UVM_HIGH)
      end
    endtask
  
endclass : read_spi_rx_reg21

// Reads21 GPIO21 INPUT_VALUE21 REG
class read_gpio_rx_reg21 extends uvm_sequence #(ahb_transfer21);

    // Register sequence with a sequencer 
    `uvm_object_utils(read_gpio_rx_reg21)
    `uvm_declare_p_sequencer(ahb_pkg21::ahb_master_sequencer21)    

    function new(string name="read_gpio_rx_reg21");
      super.new(name);
    endfunction

    rand bit [`AHB_ADDR_WIDTH21-1:0] base_addr;
    rand bit [`AHB_ADDR_WIDTH21-1:0] read_addr21;

    virtual task body();
      bit [`AHB_DATA_WIDTH21-1:0] read_data21;

      read_addr21 = base_addr + `GPIO_INPUT_VALUE_REG21;
      `uvm_do_with(req, { req.address == read_addr21; req.data == read_data21; req.direction21 == READ; req.burst == ahb_pkg21::SINGLE21; req.hsize21 == ahb_pkg21::WORD21;} )
      `uvm_info("SEQ", $psprintf("Read DATA21 is `x%0h", read_data21), UVM_HIGH)
    endtask
  
endclass : read_gpio_rx_reg21

