/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_env30.sv
Title30       : 
Project30     :
Created30     :
Description30 : Module30 env30, contains30 the instance of scoreboard30 and coverage30 model
Notes30       : 
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines30.svh"
class apb_subsystem_env30 extends uvm_env; 
  
  // Component configuration classes30
  apb_subsystem_config30 cfg;
  // These30 are pointers30 to config classes30 above30
  spi_pkg30::spi_csr30 spi_csr30;
  gpio_pkg30::gpio_csr30 gpio_csr30;

  uart_ctrl_pkg30::uart_ctrl_env30 apb_uart030; //block level module UVC30 reused30 - contains30 monitors30, scoreboard30, coverage30.
  uart_ctrl_pkg30::uart_ctrl_env30 apb_uart130; //block level module UVC30 reused30 - contains30 monitors30, scoreboard30, coverage30.
  
  // Module30 monitor30 (includes30 scoreboards30, coverage30, checking)
  apb_subsystem_monitor30 monitor30;

  // Pointer30 to the Register Database30 address map
  uvm_reg_block reg_model_ptr30;
   
  // TLM Connections30 
  uvm_analysis_port #(spi_pkg30::spi_csr30) spi_csr_out30;
  uvm_analysis_port #(gpio_pkg30::gpio_csr30) gpio_csr_out30;
  uvm_analysis_imp #(ahb_transfer30, apb_subsystem_env30) ahb_in30;

  `uvm_component_utils_begin(apb_subsystem_env30)
    `uvm_field_object(reg_model_ptr30, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create30 TLM ports30
    spi_csr_out30 = new("spi_csr_out30", this);
    gpio_csr_out30 = new("gpio_csr_out30", this);
    ahb_in30 = new("apb_in30", this);
    spi_csr30  = spi_pkg30::spi_csr30::type_id::create("spi_csr30", this) ;
    gpio_csr30 = gpio_pkg30::gpio_csr30::type_id::create("gpio_csr30", this) ;
  endfunction

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer30 transfer30);
  extern virtual function void write_effects30(ahb_transfer30 transfer30);
  extern virtual function void read_effects30(ahb_transfer30 transfer30);

endclass : apb_subsystem_env30

function void apb_subsystem_env30::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure30 the device30
  if (!uvm_config_db#(apb_subsystem_config30)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config30 creating30...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config30::get_type(),
                                     default_apb_subsystem_config30::get_type());
    cfg = apb_subsystem_config30::type_id::create("cfg");
  end
  // build system level monitor30
  monitor30 = apb_subsystem_monitor30::type_id::create("monitor30",this);
    apb_uart030  = uart_ctrl_pkg30::uart_ctrl_env30::type_id::create("apb_uart030",this);
    apb_uart130  = uart_ctrl_pkg30::uart_ctrl_env30::type_id::create("apb_uart130",this);
endfunction : build_phase
  
function void apb_subsystem_env30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB30 transfers30 - handles30 Register Operations30
function void apb_subsystem_env30::write(ahb_transfer30 transfer30);
    if (transfer30.direction30 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer30.address, transfer30.data), UVM_MEDIUM)
      write_effects30(transfer30);
    end
    else if (transfer30.direction30 == READ) begin
      if ((transfer30.address >= `AM_SPI0_BASE_ADDRESS30) && (transfer30.address <= `AM_SPI0_END_ADDRESS30)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update30() with address = 'h%0h, data = 'h%0h", transfer30.address, transfer30.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM130", "Unsupported30 access!!!")
endfunction : write

// UVM_REG: Update CONFIG30 based on APB30 writes to config registers
function void apb_subsystem_env30::write_effects30(ahb_transfer30 transfer30);
    case (transfer30.address)
      `AM_SPI0_BASE_ADDRESS30 + `SPI_CTRL_REG30 : begin
                                                  spi_csr30.mode_select30        = 1'b1;
                                                  spi_csr30.tx_clk_phase30       = transfer30.data[10];
                                                  spi_csr30.rx_clk_phase30       = transfer30.data[9];
                                                  spi_csr30.transfer_data_size30 = transfer30.data[6:0];
                                                  spi_csr30.get_data_size_as_int30();
                                                  spi_csr30.Copycfg_struct30();
                                                  spi_csr_out30.write(spi_csr30);
      `uvm_info("USR_MONITOR30", $psprintf("SPI30 CSR30 is \n%s", spi_csr30.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS30 + `SPI_DIV_REG30  : begin
                                                  spi_csr30.baud_rate_divisor30  = transfer30.data[15:0];
                                                  spi_csr30.Copycfg_struct30();
                                                  spi_csr_out30.write(spi_csr30);
                                                end
      `AM_SPI0_BASE_ADDRESS30 + `SPI_SS_REG30   : begin
                                                  spi_csr30.n_ss_out30           = transfer30.data[7:0];
                                                  spi_csr30.Copycfg_struct30();
                                                  spi_csr_out30.write(spi_csr30);
                                                end
      `AM_GPIO0_BASE_ADDRESS30 + `GPIO_BYPASS_MODE_REG30 : begin
                                                  gpio_csr30.bypass_mode30       = transfer30.data[0];
                                                  gpio_csr30.Copycfg_struct30();
                                                  gpio_csr_out30.write(gpio_csr30);
                                                end
      `AM_GPIO0_BASE_ADDRESS30 + `GPIO_DIRECTION_MODE_REG30 : begin
                                                  gpio_csr30.direction_mode30    = transfer30.data[0];
                                                  gpio_csr30.Copycfg_struct30();
                                                  gpio_csr_out30.write(gpio_csr30);
                                                end
      `AM_GPIO0_BASE_ADDRESS30 + `GPIO_OUTPUT_ENABLE_REG30 : begin
                                                  gpio_csr30.output_enable30     = transfer30.data[0];
                                                  gpio_csr30.Copycfg_struct30();
                                                  gpio_csr_out30.write(gpio_csr30);
                                                end
      default: `uvm_info("USR_MONITOR30", $psprintf("Write access not to Control30/Sataus30 Registers30"), UVM_HIGH)
    endcase
endfunction : write_effects30

function void apb_subsystem_env30::read_effects30(ahb_transfer30 transfer30);
  // Nothing for now
endfunction : read_effects30


