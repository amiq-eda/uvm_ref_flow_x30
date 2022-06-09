/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_env8.sv
Title8       : 
Project8     :
Created8     :
Description8 : Module8 env8, contains8 the instance of scoreboard8 and coverage8 model
Notes8       : 
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines8.svh"
class apb_subsystem_env8 extends uvm_env; 
  
  // Component configuration classes8
  apb_subsystem_config8 cfg;
  // These8 are pointers8 to config classes8 above8
  spi_pkg8::spi_csr8 spi_csr8;
  gpio_pkg8::gpio_csr8 gpio_csr8;

  uart_ctrl_pkg8::uart_ctrl_env8 apb_uart08; //block level module UVC8 reused8 - contains8 monitors8, scoreboard8, coverage8.
  uart_ctrl_pkg8::uart_ctrl_env8 apb_uart18; //block level module UVC8 reused8 - contains8 monitors8, scoreboard8, coverage8.
  
  // Module8 monitor8 (includes8 scoreboards8, coverage8, checking)
  apb_subsystem_monitor8 monitor8;

  // Pointer8 to the Register Database8 address map
  uvm_reg_block reg_model_ptr8;
   
  // TLM Connections8 
  uvm_analysis_port #(spi_pkg8::spi_csr8) spi_csr_out8;
  uvm_analysis_port #(gpio_pkg8::gpio_csr8) gpio_csr_out8;
  uvm_analysis_imp #(ahb_transfer8, apb_subsystem_env8) ahb_in8;

  `uvm_component_utils_begin(apb_subsystem_env8)
    `uvm_field_object(reg_model_ptr8, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create8 TLM ports8
    spi_csr_out8 = new("spi_csr_out8", this);
    gpio_csr_out8 = new("gpio_csr_out8", this);
    ahb_in8 = new("apb_in8", this);
    spi_csr8  = spi_pkg8::spi_csr8::type_id::create("spi_csr8", this) ;
    gpio_csr8 = gpio_pkg8::gpio_csr8::type_id::create("gpio_csr8", this) ;
  endfunction

  // Additional8 class methods8
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer8 transfer8);
  extern virtual function void write_effects8(ahb_transfer8 transfer8);
  extern virtual function void read_effects8(ahb_transfer8 transfer8);

endclass : apb_subsystem_env8

function void apb_subsystem_env8::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure8 the device8
  if (!uvm_config_db#(apb_subsystem_config8)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config8 creating8...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config8::get_type(),
                                     default_apb_subsystem_config8::get_type());
    cfg = apb_subsystem_config8::type_id::create("cfg");
  end
  // build system level monitor8
  monitor8 = apb_subsystem_monitor8::type_id::create("monitor8",this);
    apb_uart08  = uart_ctrl_pkg8::uart_ctrl_env8::type_id::create("apb_uart08",this);
    apb_uart18  = uart_ctrl_pkg8::uart_ctrl_env8::type_id::create("apb_uart18",this);
endfunction : build_phase
  
function void apb_subsystem_env8::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB8 transfers8 - handles8 Register Operations8
function void apb_subsystem_env8::write(ahb_transfer8 transfer8);
    if (transfer8.direction8 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer8.address, transfer8.data), UVM_MEDIUM)
      write_effects8(transfer8);
    end
    else if (transfer8.direction8 == READ) begin
      if ((transfer8.address >= `AM_SPI0_BASE_ADDRESS8) && (transfer8.address <= `AM_SPI0_END_ADDRESS8)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update8() with address = 'h%0h, data = 'h%0h", transfer8.address, transfer8.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM18", "Unsupported8 access!!!")
endfunction : write

// UVM_REG: Update CONFIG8 based on APB8 writes to config registers
function void apb_subsystem_env8::write_effects8(ahb_transfer8 transfer8);
    case (transfer8.address)
      `AM_SPI0_BASE_ADDRESS8 + `SPI_CTRL_REG8 : begin
                                                  spi_csr8.mode_select8        = 1'b1;
                                                  spi_csr8.tx_clk_phase8       = transfer8.data[10];
                                                  spi_csr8.rx_clk_phase8       = transfer8.data[9];
                                                  spi_csr8.transfer_data_size8 = transfer8.data[6:0];
                                                  spi_csr8.get_data_size_as_int8();
                                                  spi_csr8.Copycfg_struct8();
                                                  spi_csr_out8.write(spi_csr8);
      `uvm_info("USR_MONITOR8", $psprintf("SPI8 CSR8 is \n%s", spi_csr8.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS8 + `SPI_DIV_REG8  : begin
                                                  spi_csr8.baud_rate_divisor8  = transfer8.data[15:0];
                                                  spi_csr8.Copycfg_struct8();
                                                  spi_csr_out8.write(spi_csr8);
                                                end
      `AM_SPI0_BASE_ADDRESS8 + `SPI_SS_REG8   : begin
                                                  spi_csr8.n_ss_out8           = transfer8.data[7:0];
                                                  spi_csr8.Copycfg_struct8();
                                                  spi_csr_out8.write(spi_csr8);
                                                end
      `AM_GPIO0_BASE_ADDRESS8 + `GPIO_BYPASS_MODE_REG8 : begin
                                                  gpio_csr8.bypass_mode8       = transfer8.data[0];
                                                  gpio_csr8.Copycfg_struct8();
                                                  gpio_csr_out8.write(gpio_csr8);
                                                end
      `AM_GPIO0_BASE_ADDRESS8 + `GPIO_DIRECTION_MODE_REG8 : begin
                                                  gpio_csr8.direction_mode8    = transfer8.data[0];
                                                  gpio_csr8.Copycfg_struct8();
                                                  gpio_csr_out8.write(gpio_csr8);
                                                end
      `AM_GPIO0_BASE_ADDRESS8 + `GPIO_OUTPUT_ENABLE_REG8 : begin
                                                  gpio_csr8.output_enable8     = transfer8.data[0];
                                                  gpio_csr8.Copycfg_struct8();
                                                  gpio_csr_out8.write(gpio_csr8);
                                                end
      default: `uvm_info("USR_MONITOR8", $psprintf("Write access not to Control8/Sataus8 Registers8"), UVM_HIGH)
    endcase
endfunction : write_effects8

function void apb_subsystem_env8::read_effects8(ahb_transfer8 transfer8);
  // Nothing for now
endfunction : read_effects8


