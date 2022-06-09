/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_env13.sv
Title13       : 
Project13     :
Created13     :
Description13 : Module13 env13, contains13 the instance of scoreboard13 and coverage13 model
Notes13       : 
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines13.svh"
class apb_subsystem_env13 extends uvm_env; 
  
  // Component configuration classes13
  apb_subsystem_config13 cfg;
  // These13 are pointers13 to config classes13 above13
  spi_pkg13::spi_csr13 spi_csr13;
  gpio_pkg13::gpio_csr13 gpio_csr13;

  uart_ctrl_pkg13::uart_ctrl_env13 apb_uart013; //block level module UVC13 reused13 - contains13 monitors13, scoreboard13, coverage13.
  uart_ctrl_pkg13::uart_ctrl_env13 apb_uart113; //block level module UVC13 reused13 - contains13 monitors13, scoreboard13, coverage13.
  
  // Module13 monitor13 (includes13 scoreboards13, coverage13, checking)
  apb_subsystem_monitor13 monitor13;

  // Pointer13 to the Register Database13 address map
  uvm_reg_block reg_model_ptr13;
   
  // TLM Connections13 
  uvm_analysis_port #(spi_pkg13::spi_csr13) spi_csr_out13;
  uvm_analysis_port #(gpio_pkg13::gpio_csr13) gpio_csr_out13;
  uvm_analysis_imp #(ahb_transfer13, apb_subsystem_env13) ahb_in13;

  `uvm_component_utils_begin(apb_subsystem_env13)
    `uvm_field_object(reg_model_ptr13, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create13 TLM ports13
    spi_csr_out13 = new("spi_csr_out13", this);
    gpio_csr_out13 = new("gpio_csr_out13", this);
    ahb_in13 = new("apb_in13", this);
    spi_csr13  = spi_pkg13::spi_csr13::type_id::create("spi_csr13", this) ;
    gpio_csr13 = gpio_pkg13::gpio_csr13::type_id::create("gpio_csr13", this) ;
  endfunction

  // Additional13 class methods13
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer13 transfer13);
  extern virtual function void write_effects13(ahb_transfer13 transfer13);
  extern virtual function void read_effects13(ahb_transfer13 transfer13);

endclass : apb_subsystem_env13

function void apb_subsystem_env13::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure13 the device13
  if (!uvm_config_db#(apb_subsystem_config13)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config13 creating13...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config13::get_type(),
                                     default_apb_subsystem_config13::get_type());
    cfg = apb_subsystem_config13::type_id::create("cfg");
  end
  // build system level monitor13
  monitor13 = apb_subsystem_monitor13::type_id::create("monitor13",this);
    apb_uart013  = uart_ctrl_pkg13::uart_ctrl_env13::type_id::create("apb_uart013",this);
    apb_uart113  = uart_ctrl_pkg13::uart_ctrl_env13::type_id::create("apb_uart113",this);
endfunction : build_phase
  
function void apb_subsystem_env13::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB13 transfers13 - handles13 Register Operations13
function void apb_subsystem_env13::write(ahb_transfer13 transfer13);
    if (transfer13.direction13 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer13.address, transfer13.data), UVM_MEDIUM)
      write_effects13(transfer13);
    end
    else if (transfer13.direction13 == READ) begin
      if ((transfer13.address >= `AM_SPI0_BASE_ADDRESS13) && (transfer13.address <= `AM_SPI0_END_ADDRESS13)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update13() with address = 'h%0h, data = 'h%0h", transfer13.address, transfer13.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM113", "Unsupported13 access!!!")
endfunction : write

// UVM_REG: Update CONFIG13 based on APB13 writes to config registers
function void apb_subsystem_env13::write_effects13(ahb_transfer13 transfer13);
    case (transfer13.address)
      `AM_SPI0_BASE_ADDRESS13 + `SPI_CTRL_REG13 : begin
                                                  spi_csr13.mode_select13        = 1'b1;
                                                  spi_csr13.tx_clk_phase13       = transfer13.data[10];
                                                  spi_csr13.rx_clk_phase13       = transfer13.data[9];
                                                  spi_csr13.transfer_data_size13 = transfer13.data[6:0];
                                                  spi_csr13.get_data_size_as_int13();
                                                  spi_csr13.Copycfg_struct13();
                                                  spi_csr_out13.write(spi_csr13);
      `uvm_info("USR_MONITOR13", $psprintf("SPI13 CSR13 is \n%s", spi_csr13.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS13 + `SPI_DIV_REG13  : begin
                                                  spi_csr13.baud_rate_divisor13  = transfer13.data[15:0];
                                                  spi_csr13.Copycfg_struct13();
                                                  spi_csr_out13.write(spi_csr13);
                                                end
      `AM_SPI0_BASE_ADDRESS13 + `SPI_SS_REG13   : begin
                                                  spi_csr13.n_ss_out13           = transfer13.data[7:0];
                                                  spi_csr13.Copycfg_struct13();
                                                  spi_csr_out13.write(spi_csr13);
                                                end
      `AM_GPIO0_BASE_ADDRESS13 + `GPIO_BYPASS_MODE_REG13 : begin
                                                  gpio_csr13.bypass_mode13       = transfer13.data[0];
                                                  gpio_csr13.Copycfg_struct13();
                                                  gpio_csr_out13.write(gpio_csr13);
                                                end
      `AM_GPIO0_BASE_ADDRESS13 + `GPIO_DIRECTION_MODE_REG13 : begin
                                                  gpio_csr13.direction_mode13    = transfer13.data[0];
                                                  gpio_csr13.Copycfg_struct13();
                                                  gpio_csr_out13.write(gpio_csr13);
                                                end
      `AM_GPIO0_BASE_ADDRESS13 + `GPIO_OUTPUT_ENABLE_REG13 : begin
                                                  gpio_csr13.output_enable13     = transfer13.data[0];
                                                  gpio_csr13.Copycfg_struct13();
                                                  gpio_csr_out13.write(gpio_csr13);
                                                end
      default: `uvm_info("USR_MONITOR13", $psprintf("Write access not to Control13/Sataus13 Registers13"), UVM_HIGH)
    endcase
endfunction : write_effects13

function void apb_subsystem_env13::read_effects13(ahb_transfer13 transfer13);
  // Nothing for now
endfunction : read_effects13


