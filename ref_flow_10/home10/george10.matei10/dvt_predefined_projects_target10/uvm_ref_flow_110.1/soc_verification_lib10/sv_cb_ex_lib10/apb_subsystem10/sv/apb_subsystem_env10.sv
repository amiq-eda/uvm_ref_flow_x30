/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_env10.sv
Title10       : 
Project10     :
Created10     :
Description10 : Module10 env10, contains10 the instance of scoreboard10 and coverage10 model
Notes10       : 
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines10.svh"
class apb_subsystem_env10 extends uvm_env; 
  
  // Component configuration classes10
  apb_subsystem_config10 cfg;
  // These10 are pointers10 to config classes10 above10
  spi_pkg10::spi_csr10 spi_csr10;
  gpio_pkg10::gpio_csr10 gpio_csr10;

  uart_ctrl_pkg10::uart_ctrl_env10 apb_uart010; //block level module UVC10 reused10 - contains10 monitors10, scoreboard10, coverage10.
  uart_ctrl_pkg10::uart_ctrl_env10 apb_uart110; //block level module UVC10 reused10 - contains10 monitors10, scoreboard10, coverage10.
  
  // Module10 monitor10 (includes10 scoreboards10, coverage10, checking)
  apb_subsystem_monitor10 monitor10;

  // Pointer10 to the Register Database10 address map
  uvm_reg_block reg_model_ptr10;
   
  // TLM Connections10 
  uvm_analysis_port #(spi_pkg10::spi_csr10) spi_csr_out10;
  uvm_analysis_port #(gpio_pkg10::gpio_csr10) gpio_csr_out10;
  uvm_analysis_imp #(ahb_transfer10, apb_subsystem_env10) ahb_in10;

  `uvm_component_utils_begin(apb_subsystem_env10)
    `uvm_field_object(reg_model_ptr10, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create10 TLM ports10
    spi_csr_out10 = new("spi_csr_out10", this);
    gpio_csr_out10 = new("gpio_csr_out10", this);
    ahb_in10 = new("apb_in10", this);
    spi_csr10  = spi_pkg10::spi_csr10::type_id::create("spi_csr10", this) ;
    gpio_csr10 = gpio_pkg10::gpio_csr10::type_id::create("gpio_csr10", this) ;
  endfunction

  // Additional10 class methods10
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer10 transfer10);
  extern virtual function void write_effects10(ahb_transfer10 transfer10);
  extern virtual function void read_effects10(ahb_transfer10 transfer10);

endclass : apb_subsystem_env10

function void apb_subsystem_env10::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure10 the device10
  if (!uvm_config_db#(apb_subsystem_config10)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config10 creating10...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config10::get_type(),
                                     default_apb_subsystem_config10::get_type());
    cfg = apb_subsystem_config10::type_id::create("cfg");
  end
  // build system level monitor10
  monitor10 = apb_subsystem_monitor10::type_id::create("monitor10",this);
    apb_uart010  = uart_ctrl_pkg10::uart_ctrl_env10::type_id::create("apb_uart010",this);
    apb_uart110  = uart_ctrl_pkg10::uart_ctrl_env10::type_id::create("apb_uart110",this);
endfunction : build_phase
  
function void apb_subsystem_env10::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB10 transfers10 - handles10 Register Operations10
function void apb_subsystem_env10::write(ahb_transfer10 transfer10);
    if (transfer10.direction10 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer10.address, transfer10.data), UVM_MEDIUM)
      write_effects10(transfer10);
    end
    else if (transfer10.direction10 == READ) begin
      if ((transfer10.address >= `AM_SPI0_BASE_ADDRESS10) && (transfer10.address <= `AM_SPI0_END_ADDRESS10)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update10() with address = 'h%0h, data = 'h%0h", transfer10.address, transfer10.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM110", "Unsupported10 access!!!")
endfunction : write

// UVM_REG: Update CONFIG10 based on APB10 writes to config registers
function void apb_subsystem_env10::write_effects10(ahb_transfer10 transfer10);
    case (transfer10.address)
      `AM_SPI0_BASE_ADDRESS10 + `SPI_CTRL_REG10 : begin
                                                  spi_csr10.mode_select10        = 1'b1;
                                                  spi_csr10.tx_clk_phase10       = transfer10.data[10];
                                                  spi_csr10.rx_clk_phase10       = transfer10.data[9];
                                                  spi_csr10.transfer_data_size10 = transfer10.data[6:0];
                                                  spi_csr10.get_data_size_as_int10();
                                                  spi_csr10.Copycfg_struct10();
                                                  spi_csr_out10.write(spi_csr10);
      `uvm_info("USR_MONITOR10", $psprintf("SPI10 CSR10 is \n%s", spi_csr10.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS10 + `SPI_DIV_REG10  : begin
                                                  spi_csr10.baud_rate_divisor10  = transfer10.data[15:0];
                                                  spi_csr10.Copycfg_struct10();
                                                  spi_csr_out10.write(spi_csr10);
                                                end
      `AM_SPI0_BASE_ADDRESS10 + `SPI_SS_REG10   : begin
                                                  spi_csr10.n_ss_out10           = transfer10.data[7:0];
                                                  spi_csr10.Copycfg_struct10();
                                                  spi_csr_out10.write(spi_csr10);
                                                end
      `AM_GPIO0_BASE_ADDRESS10 + `GPIO_BYPASS_MODE_REG10 : begin
                                                  gpio_csr10.bypass_mode10       = transfer10.data[0];
                                                  gpio_csr10.Copycfg_struct10();
                                                  gpio_csr_out10.write(gpio_csr10);
                                                end
      `AM_GPIO0_BASE_ADDRESS10 + `GPIO_DIRECTION_MODE_REG10 : begin
                                                  gpio_csr10.direction_mode10    = transfer10.data[0];
                                                  gpio_csr10.Copycfg_struct10();
                                                  gpio_csr_out10.write(gpio_csr10);
                                                end
      `AM_GPIO0_BASE_ADDRESS10 + `GPIO_OUTPUT_ENABLE_REG10 : begin
                                                  gpio_csr10.output_enable10     = transfer10.data[0];
                                                  gpio_csr10.Copycfg_struct10();
                                                  gpio_csr_out10.write(gpio_csr10);
                                                end
      default: `uvm_info("USR_MONITOR10", $psprintf("Write access not to Control10/Sataus10 Registers10"), UVM_HIGH)
    endcase
endfunction : write_effects10

function void apb_subsystem_env10::read_effects10(ahb_transfer10 transfer10);
  // Nothing for now
endfunction : read_effects10


