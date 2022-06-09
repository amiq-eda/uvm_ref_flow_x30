/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_env7.sv
Title7       : 
Project7     :
Created7     :
Description7 : Module7 env7, contains7 the instance of scoreboard7 and coverage7 model
Notes7       : 
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines7.svh"
class apb_subsystem_env7 extends uvm_env; 
  
  // Component configuration classes7
  apb_subsystem_config7 cfg;
  // These7 are pointers7 to config classes7 above7
  spi_pkg7::spi_csr7 spi_csr7;
  gpio_pkg7::gpio_csr7 gpio_csr7;

  uart_ctrl_pkg7::uart_ctrl_env7 apb_uart07; //block level module UVC7 reused7 - contains7 monitors7, scoreboard7, coverage7.
  uart_ctrl_pkg7::uart_ctrl_env7 apb_uart17; //block level module UVC7 reused7 - contains7 monitors7, scoreboard7, coverage7.
  
  // Module7 monitor7 (includes7 scoreboards7, coverage7, checking)
  apb_subsystem_monitor7 monitor7;

  // Pointer7 to the Register Database7 address map
  uvm_reg_block reg_model_ptr7;
   
  // TLM Connections7 
  uvm_analysis_port #(spi_pkg7::spi_csr7) spi_csr_out7;
  uvm_analysis_port #(gpio_pkg7::gpio_csr7) gpio_csr_out7;
  uvm_analysis_imp #(ahb_transfer7, apb_subsystem_env7) ahb_in7;

  `uvm_component_utils_begin(apb_subsystem_env7)
    `uvm_field_object(reg_model_ptr7, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create7 TLM ports7
    spi_csr_out7 = new("spi_csr_out7", this);
    gpio_csr_out7 = new("gpio_csr_out7", this);
    ahb_in7 = new("apb_in7", this);
    spi_csr7  = spi_pkg7::spi_csr7::type_id::create("spi_csr7", this) ;
    gpio_csr7 = gpio_pkg7::gpio_csr7::type_id::create("gpio_csr7", this) ;
  endfunction

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer7 transfer7);
  extern virtual function void write_effects7(ahb_transfer7 transfer7);
  extern virtual function void read_effects7(ahb_transfer7 transfer7);

endclass : apb_subsystem_env7

function void apb_subsystem_env7::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure7 the device7
  if (!uvm_config_db#(apb_subsystem_config7)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config7 creating7...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config7::get_type(),
                                     default_apb_subsystem_config7::get_type());
    cfg = apb_subsystem_config7::type_id::create("cfg");
  end
  // build system level monitor7
  monitor7 = apb_subsystem_monitor7::type_id::create("monitor7",this);
    apb_uart07  = uart_ctrl_pkg7::uart_ctrl_env7::type_id::create("apb_uart07",this);
    apb_uart17  = uart_ctrl_pkg7::uart_ctrl_env7::type_id::create("apb_uart17",this);
endfunction : build_phase
  
function void apb_subsystem_env7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB7 transfers7 - handles7 Register Operations7
function void apb_subsystem_env7::write(ahb_transfer7 transfer7);
    if (transfer7.direction7 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer7.address, transfer7.data), UVM_MEDIUM)
      write_effects7(transfer7);
    end
    else if (transfer7.direction7 == READ) begin
      if ((transfer7.address >= `AM_SPI0_BASE_ADDRESS7) && (transfer7.address <= `AM_SPI0_END_ADDRESS7)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update7() with address = 'h%0h, data = 'h%0h", transfer7.address, transfer7.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM17", "Unsupported7 access!!!")
endfunction : write

// UVM_REG: Update CONFIG7 based on APB7 writes to config registers
function void apb_subsystem_env7::write_effects7(ahb_transfer7 transfer7);
    case (transfer7.address)
      `AM_SPI0_BASE_ADDRESS7 + `SPI_CTRL_REG7 : begin
                                                  spi_csr7.mode_select7        = 1'b1;
                                                  spi_csr7.tx_clk_phase7       = transfer7.data[10];
                                                  spi_csr7.rx_clk_phase7       = transfer7.data[9];
                                                  spi_csr7.transfer_data_size7 = transfer7.data[6:0];
                                                  spi_csr7.get_data_size_as_int7();
                                                  spi_csr7.Copycfg_struct7();
                                                  spi_csr_out7.write(spi_csr7);
      `uvm_info("USR_MONITOR7", $psprintf("SPI7 CSR7 is \n%s", spi_csr7.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS7 + `SPI_DIV_REG7  : begin
                                                  spi_csr7.baud_rate_divisor7  = transfer7.data[15:0];
                                                  spi_csr7.Copycfg_struct7();
                                                  spi_csr_out7.write(spi_csr7);
                                                end
      `AM_SPI0_BASE_ADDRESS7 + `SPI_SS_REG7   : begin
                                                  spi_csr7.n_ss_out7           = transfer7.data[7:0];
                                                  spi_csr7.Copycfg_struct7();
                                                  spi_csr_out7.write(spi_csr7);
                                                end
      `AM_GPIO0_BASE_ADDRESS7 + `GPIO_BYPASS_MODE_REG7 : begin
                                                  gpio_csr7.bypass_mode7       = transfer7.data[0];
                                                  gpio_csr7.Copycfg_struct7();
                                                  gpio_csr_out7.write(gpio_csr7);
                                                end
      `AM_GPIO0_BASE_ADDRESS7 + `GPIO_DIRECTION_MODE_REG7 : begin
                                                  gpio_csr7.direction_mode7    = transfer7.data[0];
                                                  gpio_csr7.Copycfg_struct7();
                                                  gpio_csr_out7.write(gpio_csr7);
                                                end
      `AM_GPIO0_BASE_ADDRESS7 + `GPIO_OUTPUT_ENABLE_REG7 : begin
                                                  gpio_csr7.output_enable7     = transfer7.data[0];
                                                  gpio_csr7.Copycfg_struct7();
                                                  gpio_csr_out7.write(gpio_csr7);
                                                end
      default: `uvm_info("USR_MONITOR7", $psprintf("Write access not to Control7/Sataus7 Registers7"), UVM_HIGH)
    endcase
endfunction : write_effects7

function void apb_subsystem_env7::read_effects7(ahb_transfer7 transfer7);
  // Nothing for now
endfunction : read_effects7


