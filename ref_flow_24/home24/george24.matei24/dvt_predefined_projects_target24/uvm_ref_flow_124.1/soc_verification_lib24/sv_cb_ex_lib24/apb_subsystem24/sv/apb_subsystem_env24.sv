/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_env24.sv
Title24       : 
Project24     :
Created24     :
Description24 : Module24 env24, contains24 the instance of scoreboard24 and coverage24 model
Notes24       : 
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines24.svh"
class apb_subsystem_env24 extends uvm_env; 
  
  // Component configuration classes24
  apb_subsystem_config24 cfg;
  // These24 are pointers24 to config classes24 above24
  spi_pkg24::spi_csr24 spi_csr24;
  gpio_pkg24::gpio_csr24 gpio_csr24;

  uart_ctrl_pkg24::uart_ctrl_env24 apb_uart024; //block level module UVC24 reused24 - contains24 monitors24, scoreboard24, coverage24.
  uart_ctrl_pkg24::uart_ctrl_env24 apb_uart124; //block level module UVC24 reused24 - contains24 monitors24, scoreboard24, coverage24.
  
  // Module24 monitor24 (includes24 scoreboards24, coverage24, checking)
  apb_subsystem_monitor24 monitor24;

  // Pointer24 to the Register Database24 address map
  uvm_reg_block reg_model_ptr24;
   
  // TLM Connections24 
  uvm_analysis_port #(spi_pkg24::spi_csr24) spi_csr_out24;
  uvm_analysis_port #(gpio_pkg24::gpio_csr24) gpio_csr_out24;
  uvm_analysis_imp #(ahb_transfer24, apb_subsystem_env24) ahb_in24;

  `uvm_component_utils_begin(apb_subsystem_env24)
    `uvm_field_object(reg_model_ptr24, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create24 TLM ports24
    spi_csr_out24 = new("spi_csr_out24", this);
    gpio_csr_out24 = new("gpio_csr_out24", this);
    ahb_in24 = new("apb_in24", this);
    spi_csr24  = spi_pkg24::spi_csr24::type_id::create("spi_csr24", this) ;
    gpio_csr24 = gpio_pkg24::gpio_csr24::type_id::create("gpio_csr24", this) ;
  endfunction

  // Additional24 class methods24
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer24 transfer24);
  extern virtual function void write_effects24(ahb_transfer24 transfer24);
  extern virtual function void read_effects24(ahb_transfer24 transfer24);

endclass : apb_subsystem_env24

function void apb_subsystem_env24::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure24 the device24
  if (!uvm_config_db#(apb_subsystem_config24)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config24 creating24...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config24::get_type(),
                                     default_apb_subsystem_config24::get_type());
    cfg = apb_subsystem_config24::type_id::create("cfg");
  end
  // build system level monitor24
  monitor24 = apb_subsystem_monitor24::type_id::create("monitor24",this);
    apb_uart024  = uart_ctrl_pkg24::uart_ctrl_env24::type_id::create("apb_uart024",this);
    apb_uart124  = uart_ctrl_pkg24::uart_ctrl_env24::type_id::create("apb_uart124",this);
endfunction : build_phase
  
function void apb_subsystem_env24::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB24 transfers24 - handles24 Register Operations24
function void apb_subsystem_env24::write(ahb_transfer24 transfer24);
    if (transfer24.direction24 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer24.address, transfer24.data), UVM_MEDIUM)
      write_effects24(transfer24);
    end
    else if (transfer24.direction24 == READ) begin
      if ((transfer24.address >= `AM_SPI0_BASE_ADDRESS24) && (transfer24.address <= `AM_SPI0_END_ADDRESS24)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update24() with address = 'h%0h, data = 'h%0h", transfer24.address, transfer24.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM124", "Unsupported24 access!!!")
endfunction : write

// UVM_REG: Update CONFIG24 based on APB24 writes to config registers
function void apb_subsystem_env24::write_effects24(ahb_transfer24 transfer24);
    case (transfer24.address)
      `AM_SPI0_BASE_ADDRESS24 + `SPI_CTRL_REG24 : begin
                                                  spi_csr24.mode_select24        = 1'b1;
                                                  spi_csr24.tx_clk_phase24       = transfer24.data[10];
                                                  spi_csr24.rx_clk_phase24       = transfer24.data[9];
                                                  spi_csr24.transfer_data_size24 = transfer24.data[6:0];
                                                  spi_csr24.get_data_size_as_int24();
                                                  spi_csr24.Copycfg_struct24();
                                                  spi_csr_out24.write(spi_csr24);
      `uvm_info("USR_MONITOR24", $psprintf("SPI24 CSR24 is \n%s", spi_csr24.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS24 + `SPI_DIV_REG24  : begin
                                                  spi_csr24.baud_rate_divisor24  = transfer24.data[15:0];
                                                  spi_csr24.Copycfg_struct24();
                                                  spi_csr_out24.write(spi_csr24);
                                                end
      `AM_SPI0_BASE_ADDRESS24 + `SPI_SS_REG24   : begin
                                                  spi_csr24.n_ss_out24           = transfer24.data[7:0];
                                                  spi_csr24.Copycfg_struct24();
                                                  spi_csr_out24.write(spi_csr24);
                                                end
      `AM_GPIO0_BASE_ADDRESS24 + `GPIO_BYPASS_MODE_REG24 : begin
                                                  gpio_csr24.bypass_mode24       = transfer24.data[0];
                                                  gpio_csr24.Copycfg_struct24();
                                                  gpio_csr_out24.write(gpio_csr24);
                                                end
      `AM_GPIO0_BASE_ADDRESS24 + `GPIO_DIRECTION_MODE_REG24 : begin
                                                  gpio_csr24.direction_mode24    = transfer24.data[0];
                                                  gpio_csr24.Copycfg_struct24();
                                                  gpio_csr_out24.write(gpio_csr24);
                                                end
      `AM_GPIO0_BASE_ADDRESS24 + `GPIO_OUTPUT_ENABLE_REG24 : begin
                                                  gpio_csr24.output_enable24     = transfer24.data[0];
                                                  gpio_csr24.Copycfg_struct24();
                                                  gpio_csr_out24.write(gpio_csr24);
                                                end
      default: `uvm_info("USR_MONITOR24", $psprintf("Write access not to Control24/Sataus24 Registers24"), UVM_HIGH)
    endcase
endfunction : write_effects24

function void apb_subsystem_env24::read_effects24(ahb_transfer24 transfer24);
  // Nothing for now
endfunction : read_effects24


