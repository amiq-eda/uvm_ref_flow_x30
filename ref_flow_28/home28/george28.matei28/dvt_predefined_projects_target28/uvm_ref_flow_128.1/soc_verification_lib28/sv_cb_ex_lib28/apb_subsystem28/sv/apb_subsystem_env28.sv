/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_env28.sv
Title28       : 
Project28     :
Created28     :
Description28 : Module28 env28, contains28 the instance of scoreboard28 and coverage28 model
Notes28       : 
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines28.svh"
class apb_subsystem_env28 extends uvm_env; 
  
  // Component configuration classes28
  apb_subsystem_config28 cfg;
  // These28 are pointers28 to config classes28 above28
  spi_pkg28::spi_csr28 spi_csr28;
  gpio_pkg28::gpio_csr28 gpio_csr28;

  uart_ctrl_pkg28::uart_ctrl_env28 apb_uart028; //block level module UVC28 reused28 - contains28 monitors28, scoreboard28, coverage28.
  uart_ctrl_pkg28::uart_ctrl_env28 apb_uart128; //block level module UVC28 reused28 - contains28 monitors28, scoreboard28, coverage28.
  
  // Module28 monitor28 (includes28 scoreboards28, coverage28, checking)
  apb_subsystem_monitor28 monitor28;

  // Pointer28 to the Register Database28 address map
  uvm_reg_block reg_model_ptr28;
   
  // TLM Connections28 
  uvm_analysis_port #(spi_pkg28::spi_csr28) spi_csr_out28;
  uvm_analysis_port #(gpio_pkg28::gpio_csr28) gpio_csr_out28;
  uvm_analysis_imp #(ahb_transfer28, apb_subsystem_env28) ahb_in28;

  `uvm_component_utils_begin(apb_subsystem_env28)
    `uvm_field_object(reg_model_ptr28, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create28 TLM ports28
    spi_csr_out28 = new("spi_csr_out28", this);
    gpio_csr_out28 = new("gpio_csr_out28", this);
    ahb_in28 = new("apb_in28", this);
    spi_csr28  = spi_pkg28::spi_csr28::type_id::create("spi_csr28", this) ;
    gpio_csr28 = gpio_pkg28::gpio_csr28::type_id::create("gpio_csr28", this) ;
  endfunction

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer28 transfer28);
  extern virtual function void write_effects28(ahb_transfer28 transfer28);
  extern virtual function void read_effects28(ahb_transfer28 transfer28);

endclass : apb_subsystem_env28

function void apb_subsystem_env28::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure28 the device28
  if (!uvm_config_db#(apb_subsystem_config28)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config28 creating28...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config28::get_type(),
                                     default_apb_subsystem_config28::get_type());
    cfg = apb_subsystem_config28::type_id::create("cfg");
  end
  // build system level monitor28
  monitor28 = apb_subsystem_monitor28::type_id::create("monitor28",this);
    apb_uart028  = uart_ctrl_pkg28::uart_ctrl_env28::type_id::create("apb_uart028",this);
    apb_uart128  = uart_ctrl_pkg28::uart_ctrl_env28::type_id::create("apb_uart128",this);
endfunction : build_phase
  
function void apb_subsystem_env28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB28 transfers28 - handles28 Register Operations28
function void apb_subsystem_env28::write(ahb_transfer28 transfer28);
    if (transfer28.direction28 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer28.address, transfer28.data), UVM_MEDIUM)
      write_effects28(transfer28);
    end
    else if (transfer28.direction28 == READ) begin
      if ((transfer28.address >= `AM_SPI0_BASE_ADDRESS28) && (transfer28.address <= `AM_SPI0_END_ADDRESS28)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update28() with address = 'h%0h, data = 'h%0h", transfer28.address, transfer28.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM128", "Unsupported28 access!!!")
endfunction : write

// UVM_REG: Update CONFIG28 based on APB28 writes to config registers
function void apb_subsystem_env28::write_effects28(ahb_transfer28 transfer28);
    case (transfer28.address)
      `AM_SPI0_BASE_ADDRESS28 + `SPI_CTRL_REG28 : begin
                                                  spi_csr28.mode_select28        = 1'b1;
                                                  spi_csr28.tx_clk_phase28       = transfer28.data[10];
                                                  spi_csr28.rx_clk_phase28       = transfer28.data[9];
                                                  spi_csr28.transfer_data_size28 = transfer28.data[6:0];
                                                  spi_csr28.get_data_size_as_int28();
                                                  spi_csr28.Copycfg_struct28();
                                                  spi_csr_out28.write(spi_csr28);
      `uvm_info("USR_MONITOR28", $psprintf("SPI28 CSR28 is \n%s", spi_csr28.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS28 + `SPI_DIV_REG28  : begin
                                                  spi_csr28.baud_rate_divisor28  = transfer28.data[15:0];
                                                  spi_csr28.Copycfg_struct28();
                                                  spi_csr_out28.write(spi_csr28);
                                                end
      `AM_SPI0_BASE_ADDRESS28 + `SPI_SS_REG28   : begin
                                                  spi_csr28.n_ss_out28           = transfer28.data[7:0];
                                                  spi_csr28.Copycfg_struct28();
                                                  spi_csr_out28.write(spi_csr28);
                                                end
      `AM_GPIO0_BASE_ADDRESS28 + `GPIO_BYPASS_MODE_REG28 : begin
                                                  gpio_csr28.bypass_mode28       = transfer28.data[0];
                                                  gpio_csr28.Copycfg_struct28();
                                                  gpio_csr_out28.write(gpio_csr28);
                                                end
      `AM_GPIO0_BASE_ADDRESS28 + `GPIO_DIRECTION_MODE_REG28 : begin
                                                  gpio_csr28.direction_mode28    = transfer28.data[0];
                                                  gpio_csr28.Copycfg_struct28();
                                                  gpio_csr_out28.write(gpio_csr28);
                                                end
      `AM_GPIO0_BASE_ADDRESS28 + `GPIO_OUTPUT_ENABLE_REG28 : begin
                                                  gpio_csr28.output_enable28     = transfer28.data[0];
                                                  gpio_csr28.Copycfg_struct28();
                                                  gpio_csr_out28.write(gpio_csr28);
                                                end
      default: `uvm_info("USR_MONITOR28", $psprintf("Write access not to Control28/Sataus28 Registers28"), UVM_HIGH)
    endcase
endfunction : write_effects28

function void apb_subsystem_env28::read_effects28(ahb_transfer28 transfer28);
  // Nothing for now
endfunction : read_effects28


