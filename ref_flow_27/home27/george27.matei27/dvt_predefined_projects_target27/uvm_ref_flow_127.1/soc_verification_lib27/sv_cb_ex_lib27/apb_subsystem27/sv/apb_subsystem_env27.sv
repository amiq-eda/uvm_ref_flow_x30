/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_env27.sv
Title27       : 
Project27     :
Created27     :
Description27 : Module27 env27, contains27 the instance of scoreboard27 and coverage27 model
Notes27       : 
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines27.svh"
class apb_subsystem_env27 extends uvm_env; 
  
  // Component configuration classes27
  apb_subsystem_config27 cfg;
  // These27 are pointers27 to config classes27 above27
  spi_pkg27::spi_csr27 spi_csr27;
  gpio_pkg27::gpio_csr27 gpio_csr27;

  uart_ctrl_pkg27::uart_ctrl_env27 apb_uart027; //block level module UVC27 reused27 - contains27 monitors27, scoreboard27, coverage27.
  uart_ctrl_pkg27::uart_ctrl_env27 apb_uart127; //block level module UVC27 reused27 - contains27 monitors27, scoreboard27, coverage27.
  
  // Module27 monitor27 (includes27 scoreboards27, coverage27, checking)
  apb_subsystem_monitor27 monitor27;

  // Pointer27 to the Register Database27 address map
  uvm_reg_block reg_model_ptr27;
   
  // TLM Connections27 
  uvm_analysis_port #(spi_pkg27::spi_csr27) spi_csr_out27;
  uvm_analysis_port #(gpio_pkg27::gpio_csr27) gpio_csr_out27;
  uvm_analysis_imp #(ahb_transfer27, apb_subsystem_env27) ahb_in27;

  `uvm_component_utils_begin(apb_subsystem_env27)
    `uvm_field_object(reg_model_ptr27, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create27 TLM ports27
    spi_csr_out27 = new("spi_csr_out27", this);
    gpio_csr_out27 = new("gpio_csr_out27", this);
    ahb_in27 = new("apb_in27", this);
    spi_csr27  = spi_pkg27::spi_csr27::type_id::create("spi_csr27", this) ;
    gpio_csr27 = gpio_pkg27::gpio_csr27::type_id::create("gpio_csr27", this) ;
  endfunction

  // Additional27 class methods27
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer27 transfer27);
  extern virtual function void write_effects27(ahb_transfer27 transfer27);
  extern virtual function void read_effects27(ahb_transfer27 transfer27);

endclass : apb_subsystem_env27

function void apb_subsystem_env27::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure27 the device27
  if (!uvm_config_db#(apb_subsystem_config27)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config27 creating27...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config27::get_type(),
                                     default_apb_subsystem_config27::get_type());
    cfg = apb_subsystem_config27::type_id::create("cfg");
  end
  // build system level monitor27
  monitor27 = apb_subsystem_monitor27::type_id::create("monitor27",this);
    apb_uart027  = uart_ctrl_pkg27::uart_ctrl_env27::type_id::create("apb_uart027",this);
    apb_uart127  = uart_ctrl_pkg27::uart_ctrl_env27::type_id::create("apb_uart127",this);
endfunction : build_phase
  
function void apb_subsystem_env27::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB27 transfers27 - handles27 Register Operations27
function void apb_subsystem_env27::write(ahb_transfer27 transfer27);
    if (transfer27.direction27 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer27.address, transfer27.data), UVM_MEDIUM)
      write_effects27(transfer27);
    end
    else if (transfer27.direction27 == READ) begin
      if ((transfer27.address >= `AM_SPI0_BASE_ADDRESS27) && (transfer27.address <= `AM_SPI0_END_ADDRESS27)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update27() with address = 'h%0h, data = 'h%0h", transfer27.address, transfer27.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM127", "Unsupported27 access!!!")
endfunction : write

// UVM_REG: Update CONFIG27 based on APB27 writes to config registers
function void apb_subsystem_env27::write_effects27(ahb_transfer27 transfer27);
    case (transfer27.address)
      `AM_SPI0_BASE_ADDRESS27 + `SPI_CTRL_REG27 : begin
                                                  spi_csr27.mode_select27        = 1'b1;
                                                  spi_csr27.tx_clk_phase27       = transfer27.data[10];
                                                  spi_csr27.rx_clk_phase27       = transfer27.data[9];
                                                  spi_csr27.transfer_data_size27 = transfer27.data[6:0];
                                                  spi_csr27.get_data_size_as_int27();
                                                  spi_csr27.Copycfg_struct27();
                                                  spi_csr_out27.write(spi_csr27);
      `uvm_info("USR_MONITOR27", $psprintf("SPI27 CSR27 is \n%s", spi_csr27.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS27 + `SPI_DIV_REG27  : begin
                                                  spi_csr27.baud_rate_divisor27  = transfer27.data[15:0];
                                                  spi_csr27.Copycfg_struct27();
                                                  spi_csr_out27.write(spi_csr27);
                                                end
      `AM_SPI0_BASE_ADDRESS27 + `SPI_SS_REG27   : begin
                                                  spi_csr27.n_ss_out27           = transfer27.data[7:0];
                                                  spi_csr27.Copycfg_struct27();
                                                  spi_csr_out27.write(spi_csr27);
                                                end
      `AM_GPIO0_BASE_ADDRESS27 + `GPIO_BYPASS_MODE_REG27 : begin
                                                  gpio_csr27.bypass_mode27       = transfer27.data[0];
                                                  gpio_csr27.Copycfg_struct27();
                                                  gpio_csr_out27.write(gpio_csr27);
                                                end
      `AM_GPIO0_BASE_ADDRESS27 + `GPIO_DIRECTION_MODE_REG27 : begin
                                                  gpio_csr27.direction_mode27    = transfer27.data[0];
                                                  gpio_csr27.Copycfg_struct27();
                                                  gpio_csr_out27.write(gpio_csr27);
                                                end
      `AM_GPIO0_BASE_ADDRESS27 + `GPIO_OUTPUT_ENABLE_REG27 : begin
                                                  gpio_csr27.output_enable27     = transfer27.data[0];
                                                  gpio_csr27.Copycfg_struct27();
                                                  gpio_csr_out27.write(gpio_csr27);
                                                end
      default: `uvm_info("USR_MONITOR27", $psprintf("Write access not to Control27/Sataus27 Registers27"), UVM_HIGH)
    endcase
endfunction : write_effects27

function void apb_subsystem_env27::read_effects27(ahb_transfer27 transfer27);
  // Nothing for now
endfunction : read_effects27


