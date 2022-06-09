/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_env20.sv
Title20       : 
Project20     :
Created20     :
Description20 : Module20 env20, contains20 the instance of scoreboard20 and coverage20 model
Notes20       : 
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines20.svh"
class apb_subsystem_env20 extends uvm_env; 
  
  // Component configuration classes20
  apb_subsystem_config20 cfg;
  // These20 are pointers20 to config classes20 above20
  spi_pkg20::spi_csr20 spi_csr20;
  gpio_pkg20::gpio_csr20 gpio_csr20;

  uart_ctrl_pkg20::uart_ctrl_env20 apb_uart020; //block level module UVC20 reused20 - contains20 monitors20, scoreboard20, coverage20.
  uart_ctrl_pkg20::uart_ctrl_env20 apb_uart120; //block level module UVC20 reused20 - contains20 monitors20, scoreboard20, coverage20.
  
  // Module20 monitor20 (includes20 scoreboards20, coverage20, checking)
  apb_subsystem_monitor20 monitor20;

  // Pointer20 to the Register Database20 address map
  uvm_reg_block reg_model_ptr20;
   
  // TLM Connections20 
  uvm_analysis_port #(spi_pkg20::spi_csr20) spi_csr_out20;
  uvm_analysis_port #(gpio_pkg20::gpio_csr20) gpio_csr_out20;
  uvm_analysis_imp #(ahb_transfer20, apb_subsystem_env20) ahb_in20;

  `uvm_component_utils_begin(apb_subsystem_env20)
    `uvm_field_object(reg_model_ptr20, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create20 TLM ports20
    spi_csr_out20 = new("spi_csr_out20", this);
    gpio_csr_out20 = new("gpio_csr_out20", this);
    ahb_in20 = new("apb_in20", this);
    spi_csr20  = spi_pkg20::spi_csr20::type_id::create("spi_csr20", this) ;
    gpio_csr20 = gpio_pkg20::gpio_csr20::type_id::create("gpio_csr20", this) ;
  endfunction

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer20 transfer20);
  extern virtual function void write_effects20(ahb_transfer20 transfer20);
  extern virtual function void read_effects20(ahb_transfer20 transfer20);

endclass : apb_subsystem_env20

function void apb_subsystem_env20::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure20 the device20
  if (!uvm_config_db#(apb_subsystem_config20)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config20 creating20...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config20::get_type(),
                                     default_apb_subsystem_config20::get_type());
    cfg = apb_subsystem_config20::type_id::create("cfg");
  end
  // build system level monitor20
  monitor20 = apb_subsystem_monitor20::type_id::create("monitor20",this);
    apb_uart020  = uart_ctrl_pkg20::uart_ctrl_env20::type_id::create("apb_uart020",this);
    apb_uart120  = uart_ctrl_pkg20::uart_ctrl_env20::type_id::create("apb_uart120",this);
endfunction : build_phase
  
function void apb_subsystem_env20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB20 transfers20 - handles20 Register Operations20
function void apb_subsystem_env20::write(ahb_transfer20 transfer20);
    if (transfer20.direction20 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer20.address, transfer20.data), UVM_MEDIUM)
      write_effects20(transfer20);
    end
    else if (transfer20.direction20 == READ) begin
      if ((transfer20.address >= `AM_SPI0_BASE_ADDRESS20) && (transfer20.address <= `AM_SPI0_END_ADDRESS20)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update20() with address = 'h%0h, data = 'h%0h", transfer20.address, transfer20.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM120", "Unsupported20 access!!!")
endfunction : write

// UVM_REG: Update CONFIG20 based on APB20 writes to config registers
function void apb_subsystem_env20::write_effects20(ahb_transfer20 transfer20);
    case (transfer20.address)
      `AM_SPI0_BASE_ADDRESS20 + `SPI_CTRL_REG20 : begin
                                                  spi_csr20.mode_select20        = 1'b1;
                                                  spi_csr20.tx_clk_phase20       = transfer20.data[10];
                                                  spi_csr20.rx_clk_phase20       = transfer20.data[9];
                                                  spi_csr20.transfer_data_size20 = transfer20.data[6:0];
                                                  spi_csr20.get_data_size_as_int20();
                                                  spi_csr20.Copycfg_struct20();
                                                  spi_csr_out20.write(spi_csr20);
      `uvm_info("USR_MONITOR20", $psprintf("SPI20 CSR20 is \n%s", spi_csr20.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS20 + `SPI_DIV_REG20  : begin
                                                  spi_csr20.baud_rate_divisor20  = transfer20.data[15:0];
                                                  spi_csr20.Copycfg_struct20();
                                                  spi_csr_out20.write(spi_csr20);
                                                end
      `AM_SPI0_BASE_ADDRESS20 + `SPI_SS_REG20   : begin
                                                  spi_csr20.n_ss_out20           = transfer20.data[7:0];
                                                  spi_csr20.Copycfg_struct20();
                                                  spi_csr_out20.write(spi_csr20);
                                                end
      `AM_GPIO0_BASE_ADDRESS20 + `GPIO_BYPASS_MODE_REG20 : begin
                                                  gpio_csr20.bypass_mode20       = transfer20.data[0];
                                                  gpio_csr20.Copycfg_struct20();
                                                  gpio_csr_out20.write(gpio_csr20);
                                                end
      `AM_GPIO0_BASE_ADDRESS20 + `GPIO_DIRECTION_MODE_REG20 : begin
                                                  gpio_csr20.direction_mode20    = transfer20.data[0];
                                                  gpio_csr20.Copycfg_struct20();
                                                  gpio_csr_out20.write(gpio_csr20);
                                                end
      `AM_GPIO0_BASE_ADDRESS20 + `GPIO_OUTPUT_ENABLE_REG20 : begin
                                                  gpio_csr20.output_enable20     = transfer20.data[0];
                                                  gpio_csr20.Copycfg_struct20();
                                                  gpio_csr_out20.write(gpio_csr20);
                                                end
      default: `uvm_info("USR_MONITOR20", $psprintf("Write access not to Control20/Sataus20 Registers20"), UVM_HIGH)
    endcase
endfunction : write_effects20

function void apb_subsystem_env20::read_effects20(ahb_transfer20 transfer20);
  // Nothing for now
endfunction : read_effects20


