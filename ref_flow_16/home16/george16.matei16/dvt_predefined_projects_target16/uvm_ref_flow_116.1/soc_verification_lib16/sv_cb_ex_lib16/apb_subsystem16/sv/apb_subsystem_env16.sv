/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_env16.sv
Title16       : 
Project16     :
Created16     :
Description16 : Module16 env16, contains16 the instance of scoreboard16 and coverage16 model
Notes16       : 
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines16.svh"
class apb_subsystem_env16 extends uvm_env; 
  
  // Component configuration classes16
  apb_subsystem_config16 cfg;
  // These16 are pointers16 to config classes16 above16
  spi_pkg16::spi_csr16 spi_csr16;
  gpio_pkg16::gpio_csr16 gpio_csr16;

  uart_ctrl_pkg16::uart_ctrl_env16 apb_uart016; //block level module UVC16 reused16 - contains16 monitors16, scoreboard16, coverage16.
  uart_ctrl_pkg16::uart_ctrl_env16 apb_uart116; //block level module UVC16 reused16 - contains16 monitors16, scoreboard16, coverage16.
  
  // Module16 monitor16 (includes16 scoreboards16, coverage16, checking)
  apb_subsystem_monitor16 monitor16;

  // Pointer16 to the Register Database16 address map
  uvm_reg_block reg_model_ptr16;
   
  // TLM Connections16 
  uvm_analysis_port #(spi_pkg16::spi_csr16) spi_csr_out16;
  uvm_analysis_port #(gpio_pkg16::gpio_csr16) gpio_csr_out16;
  uvm_analysis_imp #(ahb_transfer16, apb_subsystem_env16) ahb_in16;

  `uvm_component_utils_begin(apb_subsystem_env16)
    `uvm_field_object(reg_model_ptr16, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create16 TLM ports16
    spi_csr_out16 = new("spi_csr_out16", this);
    gpio_csr_out16 = new("gpio_csr_out16", this);
    ahb_in16 = new("apb_in16", this);
    spi_csr16  = spi_pkg16::spi_csr16::type_id::create("spi_csr16", this) ;
    gpio_csr16 = gpio_pkg16::gpio_csr16::type_id::create("gpio_csr16", this) ;
  endfunction

  // Additional16 class methods16
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer16 transfer16);
  extern virtual function void write_effects16(ahb_transfer16 transfer16);
  extern virtual function void read_effects16(ahb_transfer16 transfer16);

endclass : apb_subsystem_env16

function void apb_subsystem_env16::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure16 the device16
  if (!uvm_config_db#(apb_subsystem_config16)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config16 creating16...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config16::get_type(),
                                     default_apb_subsystem_config16::get_type());
    cfg = apb_subsystem_config16::type_id::create("cfg");
  end
  // build system level monitor16
  monitor16 = apb_subsystem_monitor16::type_id::create("monitor16",this);
    apb_uart016  = uart_ctrl_pkg16::uart_ctrl_env16::type_id::create("apb_uart016",this);
    apb_uart116  = uart_ctrl_pkg16::uart_ctrl_env16::type_id::create("apb_uart116",this);
endfunction : build_phase
  
function void apb_subsystem_env16::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB16 transfers16 - handles16 Register Operations16
function void apb_subsystem_env16::write(ahb_transfer16 transfer16);
    if (transfer16.direction16 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer16.address, transfer16.data), UVM_MEDIUM)
      write_effects16(transfer16);
    end
    else if (transfer16.direction16 == READ) begin
      if ((transfer16.address >= `AM_SPI0_BASE_ADDRESS16) && (transfer16.address <= `AM_SPI0_END_ADDRESS16)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update16() with address = 'h%0h, data = 'h%0h", transfer16.address, transfer16.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM116", "Unsupported16 access!!!")
endfunction : write

// UVM_REG: Update CONFIG16 based on APB16 writes to config registers
function void apb_subsystem_env16::write_effects16(ahb_transfer16 transfer16);
    case (transfer16.address)
      `AM_SPI0_BASE_ADDRESS16 + `SPI_CTRL_REG16 : begin
                                                  spi_csr16.mode_select16        = 1'b1;
                                                  spi_csr16.tx_clk_phase16       = transfer16.data[10];
                                                  spi_csr16.rx_clk_phase16       = transfer16.data[9];
                                                  spi_csr16.transfer_data_size16 = transfer16.data[6:0];
                                                  spi_csr16.get_data_size_as_int16();
                                                  spi_csr16.Copycfg_struct16();
                                                  spi_csr_out16.write(spi_csr16);
      `uvm_info("USR_MONITOR16", $psprintf("SPI16 CSR16 is \n%s", spi_csr16.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS16 + `SPI_DIV_REG16  : begin
                                                  spi_csr16.baud_rate_divisor16  = transfer16.data[15:0];
                                                  spi_csr16.Copycfg_struct16();
                                                  spi_csr_out16.write(spi_csr16);
                                                end
      `AM_SPI0_BASE_ADDRESS16 + `SPI_SS_REG16   : begin
                                                  spi_csr16.n_ss_out16           = transfer16.data[7:0];
                                                  spi_csr16.Copycfg_struct16();
                                                  spi_csr_out16.write(spi_csr16);
                                                end
      `AM_GPIO0_BASE_ADDRESS16 + `GPIO_BYPASS_MODE_REG16 : begin
                                                  gpio_csr16.bypass_mode16       = transfer16.data[0];
                                                  gpio_csr16.Copycfg_struct16();
                                                  gpio_csr_out16.write(gpio_csr16);
                                                end
      `AM_GPIO0_BASE_ADDRESS16 + `GPIO_DIRECTION_MODE_REG16 : begin
                                                  gpio_csr16.direction_mode16    = transfer16.data[0];
                                                  gpio_csr16.Copycfg_struct16();
                                                  gpio_csr_out16.write(gpio_csr16);
                                                end
      `AM_GPIO0_BASE_ADDRESS16 + `GPIO_OUTPUT_ENABLE_REG16 : begin
                                                  gpio_csr16.output_enable16     = transfer16.data[0];
                                                  gpio_csr16.Copycfg_struct16();
                                                  gpio_csr_out16.write(gpio_csr16);
                                                end
      default: `uvm_info("USR_MONITOR16", $psprintf("Write access not to Control16/Sataus16 Registers16"), UVM_HIGH)
    endcase
endfunction : write_effects16

function void apb_subsystem_env16::read_effects16(ahb_transfer16 transfer16);
  // Nothing for now
endfunction : read_effects16


