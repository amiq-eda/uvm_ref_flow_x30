/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_env9.sv
Title9       : 
Project9     :
Created9     :
Description9 : Module9 env9, contains9 the instance of scoreboard9 and coverage9 model
Notes9       : 
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines9.svh"
class apb_subsystem_env9 extends uvm_env; 
  
  // Component configuration classes9
  apb_subsystem_config9 cfg;
  // These9 are pointers9 to config classes9 above9
  spi_pkg9::spi_csr9 spi_csr9;
  gpio_pkg9::gpio_csr9 gpio_csr9;

  uart_ctrl_pkg9::uart_ctrl_env9 apb_uart09; //block level module UVC9 reused9 - contains9 monitors9, scoreboard9, coverage9.
  uart_ctrl_pkg9::uart_ctrl_env9 apb_uart19; //block level module UVC9 reused9 - contains9 monitors9, scoreboard9, coverage9.
  
  // Module9 monitor9 (includes9 scoreboards9, coverage9, checking)
  apb_subsystem_monitor9 monitor9;

  // Pointer9 to the Register Database9 address map
  uvm_reg_block reg_model_ptr9;
   
  // TLM Connections9 
  uvm_analysis_port #(spi_pkg9::spi_csr9) spi_csr_out9;
  uvm_analysis_port #(gpio_pkg9::gpio_csr9) gpio_csr_out9;
  uvm_analysis_imp #(ahb_transfer9, apb_subsystem_env9) ahb_in9;

  `uvm_component_utils_begin(apb_subsystem_env9)
    `uvm_field_object(reg_model_ptr9, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create9 TLM ports9
    spi_csr_out9 = new("spi_csr_out9", this);
    gpio_csr_out9 = new("gpio_csr_out9", this);
    ahb_in9 = new("apb_in9", this);
    spi_csr9  = spi_pkg9::spi_csr9::type_id::create("spi_csr9", this) ;
    gpio_csr9 = gpio_pkg9::gpio_csr9::type_id::create("gpio_csr9", this) ;
  endfunction

  // Additional9 class methods9
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer9 transfer9);
  extern virtual function void write_effects9(ahb_transfer9 transfer9);
  extern virtual function void read_effects9(ahb_transfer9 transfer9);

endclass : apb_subsystem_env9

function void apb_subsystem_env9::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure9 the device9
  if (!uvm_config_db#(apb_subsystem_config9)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config9 creating9...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config9::get_type(),
                                     default_apb_subsystem_config9::get_type());
    cfg = apb_subsystem_config9::type_id::create("cfg");
  end
  // build system level monitor9
  monitor9 = apb_subsystem_monitor9::type_id::create("monitor9",this);
    apb_uart09  = uart_ctrl_pkg9::uart_ctrl_env9::type_id::create("apb_uart09",this);
    apb_uart19  = uart_ctrl_pkg9::uart_ctrl_env9::type_id::create("apb_uart19",this);
endfunction : build_phase
  
function void apb_subsystem_env9::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB9 transfers9 - handles9 Register Operations9
function void apb_subsystem_env9::write(ahb_transfer9 transfer9);
    if (transfer9.direction9 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer9.address, transfer9.data), UVM_MEDIUM)
      write_effects9(transfer9);
    end
    else if (transfer9.direction9 == READ) begin
      if ((transfer9.address >= `AM_SPI0_BASE_ADDRESS9) && (transfer9.address <= `AM_SPI0_END_ADDRESS9)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update9() with address = 'h%0h, data = 'h%0h", transfer9.address, transfer9.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM19", "Unsupported9 access!!!")
endfunction : write

// UVM_REG: Update CONFIG9 based on APB9 writes to config registers
function void apb_subsystem_env9::write_effects9(ahb_transfer9 transfer9);
    case (transfer9.address)
      `AM_SPI0_BASE_ADDRESS9 + `SPI_CTRL_REG9 : begin
                                                  spi_csr9.mode_select9        = 1'b1;
                                                  spi_csr9.tx_clk_phase9       = transfer9.data[10];
                                                  spi_csr9.rx_clk_phase9       = transfer9.data[9];
                                                  spi_csr9.transfer_data_size9 = transfer9.data[6:0];
                                                  spi_csr9.get_data_size_as_int9();
                                                  spi_csr9.Copycfg_struct9();
                                                  spi_csr_out9.write(spi_csr9);
      `uvm_info("USR_MONITOR9", $psprintf("SPI9 CSR9 is \n%s", spi_csr9.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS9 + `SPI_DIV_REG9  : begin
                                                  spi_csr9.baud_rate_divisor9  = transfer9.data[15:0];
                                                  spi_csr9.Copycfg_struct9();
                                                  spi_csr_out9.write(spi_csr9);
                                                end
      `AM_SPI0_BASE_ADDRESS9 + `SPI_SS_REG9   : begin
                                                  spi_csr9.n_ss_out9           = transfer9.data[7:0];
                                                  spi_csr9.Copycfg_struct9();
                                                  spi_csr_out9.write(spi_csr9);
                                                end
      `AM_GPIO0_BASE_ADDRESS9 + `GPIO_BYPASS_MODE_REG9 : begin
                                                  gpio_csr9.bypass_mode9       = transfer9.data[0];
                                                  gpio_csr9.Copycfg_struct9();
                                                  gpio_csr_out9.write(gpio_csr9);
                                                end
      `AM_GPIO0_BASE_ADDRESS9 + `GPIO_DIRECTION_MODE_REG9 : begin
                                                  gpio_csr9.direction_mode9    = transfer9.data[0];
                                                  gpio_csr9.Copycfg_struct9();
                                                  gpio_csr_out9.write(gpio_csr9);
                                                end
      `AM_GPIO0_BASE_ADDRESS9 + `GPIO_OUTPUT_ENABLE_REG9 : begin
                                                  gpio_csr9.output_enable9     = transfer9.data[0];
                                                  gpio_csr9.Copycfg_struct9();
                                                  gpio_csr_out9.write(gpio_csr9);
                                                end
      default: `uvm_info("USR_MONITOR9", $psprintf("Write access not to Control9/Sataus9 Registers9"), UVM_HIGH)
    endcase
endfunction : write_effects9

function void apb_subsystem_env9::read_effects9(ahb_transfer9 transfer9);
  // Nothing for now
endfunction : read_effects9


