/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_env25.sv
Title25       : 
Project25     :
Created25     :
Description25 : Module25 env25, contains25 the instance of scoreboard25 and coverage25 model
Notes25       : 
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines25.svh"
class apb_subsystem_env25 extends uvm_env; 
  
  // Component configuration classes25
  apb_subsystem_config25 cfg;
  // These25 are pointers25 to config classes25 above25
  spi_pkg25::spi_csr25 spi_csr25;
  gpio_pkg25::gpio_csr25 gpio_csr25;

  uart_ctrl_pkg25::uart_ctrl_env25 apb_uart025; //block level module UVC25 reused25 - contains25 monitors25, scoreboard25, coverage25.
  uart_ctrl_pkg25::uart_ctrl_env25 apb_uart125; //block level module UVC25 reused25 - contains25 monitors25, scoreboard25, coverage25.
  
  // Module25 monitor25 (includes25 scoreboards25, coverage25, checking)
  apb_subsystem_monitor25 monitor25;

  // Pointer25 to the Register Database25 address map
  uvm_reg_block reg_model_ptr25;
   
  // TLM Connections25 
  uvm_analysis_port #(spi_pkg25::spi_csr25) spi_csr_out25;
  uvm_analysis_port #(gpio_pkg25::gpio_csr25) gpio_csr_out25;
  uvm_analysis_imp #(ahb_transfer25, apb_subsystem_env25) ahb_in25;

  `uvm_component_utils_begin(apb_subsystem_env25)
    `uvm_field_object(reg_model_ptr25, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create25 TLM ports25
    spi_csr_out25 = new("spi_csr_out25", this);
    gpio_csr_out25 = new("gpio_csr_out25", this);
    ahb_in25 = new("apb_in25", this);
    spi_csr25  = spi_pkg25::spi_csr25::type_id::create("spi_csr25", this) ;
    gpio_csr25 = gpio_pkg25::gpio_csr25::type_id::create("gpio_csr25", this) ;
  endfunction

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer25 transfer25);
  extern virtual function void write_effects25(ahb_transfer25 transfer25);
  extern virtual function void read_effects25(ahb_transfer25 transfer25);

endclass : apb_subsystem_env25

function void apb_subsystem_env25::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure25 the device25
  if (!uvm_config_db#(apb_subsystem_config25)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config25 creating25...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config25::get_type(),
                                     default_apb_subsystem_config25::get_type());
    cfg = apb_subsystem_config25::type_id::create("cfg");
  end
  // build system level monitor25
  monitor25 = apb_subsystem_monitor25::type_id::create("monitor25",this);
    apb_uart025  = uart_ctrl_pkg25::uart_ctrl_env25::type_id::create("apb_uart025",this);
    apb_uart125  = uart_ctrl_pkg25::uart_ctrl_env25::type_id::create("apb_uart125",this);
endfunction : build_phase
  
function void apb_subsystem_env25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB25 transfers25 - handles25 Register Operations25
function void apb_subsystem_env25::write(ahb_transfer25 transfer25);
    if (transfer25.direction25 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer25.address, transfer25.data), UVM_MEDIUM)
      write_effects25(transfer25);
    end
    else if (transfer25.direction25 == READ) begin
      if ((transfer25.address >= `AM_SPI0_BASE_ADDRESS25) && (transfer25.address <= `AM_SPI0_END_ADDRESS25)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update25() with address = 'h%0h, data = 'h%0h", transfer25.address, transfer25.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM125", "Unsupported25 access!!!")
endfunction : write

// UVM_REG: Update CONFIG25 based on APB25 writes to config registers
function void apb_subsystem_env25::write_effects25(ahb_transfer25 transfer25);
    case (transfer25.address)
      `AM_SPI0_BASE_ADDRESS25 + `SPI_CTRL_REG25 : begin
                                                  spi_csr25.mode_select25        = 1'b1;
                                                  spi_csr25.tx_clk_phase25       = transfer25.data[10];
                                                  spi_csr25.rx_clk_phase25       = transfer25.data[9];
                                                  spi_csr25.transfer_data_size25 = transfer25.data[6:0];
                                                  spi_csr25.get_data_size_as_int25();
                                                  spi_csr25.Copycfg_struct25();
                                                  spi_csr_out25.write(spi_csr25);
      `uvm_info("USR_MONITOR25", $psprintf("SPI25 CSR25 is \n%s", spi_csr25.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS25 + `SPI_DIV_REG25  : begin
                                                  spi_csr25.baud_rate_divisor25  = transfer25.data[15:0];
                                                  spi_csr25.Copycfg_struct25();
                                                  spi_csr_out25.write(spi_csr25);
                                                end
      `AM_SPI0_BASE_ADDRESS25 + `SPI_SS_REG25   : begin
                                                  spi_csr25.n_ss_out25           = transfer25.data[7:0];
                                                  spi_csr25.Copycfg_struct25();
                                                  spi_csr_out25.write(spi_csr25);
                                                end
      `AM_GPIO0_BASE_ADDRESS25 + `GPIO_BYPASS_MODE_REG25 : begin
                                                  gpio_csr25.bypass_mode25       = transfer25.data[0];
                                                  gpio_csr25.Copycfg_struct25();
                                                  gpio_csr_out25.write(gpio_csr25);
                                                end
      `AM_GPIO0_BASE_ADDRESS25 + `GPIO_DIRECTION_MODE_REG25 : begin
                                                  gpio_csr25.direction_mode25    = transfer25.data[0];
                                                  gpio_csr25.Copycfg_struct25();
                                                  gpio_csr_out25.write(gpio_csr25);
                                                end
      `AM_GPIO0_BASE_ADDRESS25 + `GPIO_OUTPUT_ENABLE_REG25 : begin
                                                  gpio_csr25.output_enable25     = transfer25.data[0];
                                                  gpio_csr25.Copycfg_struct25();
                                                  gpio_csr_out25.write(gpio_csr25);
                                                end
      default: `uvm_info("USR_MONITOR25", $psprintf("Write access not to Control25/Sataus25 Registers25"), UVM_HIGH)
    endcase
endfunction : write_effects25

function void apb_subsystem_env25::read_effects25(ahb_transfer25 transfer25);
  // Nothing for now
endfunction : read_effects25


