/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_env17.sv
Title17       : 
Project17     :
Created17     :
Description17 : Module17 env17, contains17 the instance of scoreboard17 and coverage17 model
Notes17       : 
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines17.svh"
class apb_subsystem_env17 extends uvm_env; 
  
  // Component configuration classes17
  apb_subsystem_config17 cfg;
  // These17 are pointers17 to config classes17 above17
  spi_pkg17::spi_csr17 spi_csr17;
  gpio_pkg17::gpio_csr17 gpio_csr17;

  uart_ctrl_pkg17::uart_ctrl_env17 apb_uart017; //block level module UVC17 reused17 - contains17 monitors17, scoreboard17, coverage17.
  uart_ctrl_pkg17::uart_ctrl_env17 apb_uart117; //block level module UVC17 reused17 - contains17 monitors17, scoreboard17, coverage17.
  
  // Module17 monitor17 (includes17 scoreboards17, coverage17, checking)
  apb_subsystem_monitor17 monitor17;

  // Pointer17 to the Register Database17 address map
  uvm_reg_block reg_model_ptr17;
   
  // TLM Connections17 
  uvm_analysis_port #(spi_pkg17::spi_csr17) spi_csr_out17;
  uvm_analysis_port #(gpio_pkg17::gpio_csr17) gpio_csr_out17;
  uvm_analysis_imp #(ahb_transfer17, apb_subsystem_env17) ahb_in17;

  `uvm_component_utils_begin(apb_subsystem_env17)
    `uvm_field_object(reg_model_ptr17, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create17 TLM ports17
    spi_csr_out17 = new("spi_csr_out17", this);
    gpio_csr_out17 = new("gpio_csr_out17", this);
    ahb_in17 = new("apb_in17", this);
    spi_csr17  = spi_pkg17::spi_csr17::type_id::create("spi_csr17", this) ;
    gpio_csr17 = gpio_pkg17::gpio_csr17::type_id::create("gpio_csr17", this) ;
  endfunction

  // Additional17 class methods17
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer17 transfer17);
  extern virtual function void write_effects17(ahb_transfer17 transfer17);
  extern virtual function void read_effects17(ahb_transfer17 transfer17);

endclass : apb_subsystem_env17

function void apb_subsystem_env17::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure17 the device17
  if (!uvm_config_db#(apb_subsystem_config17)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config17 creating17...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config17::get_type(),
                                     default_apb_subsystem_config17::get_type());
    cfg = apb_subsystem_config17::type_id::create("cfg");
  end
  // build system level monitor17
  monitor17 = apb_subsystem_monitor17::type_id::create("monitor17",this);
    apb_uart017  = uart_ctrl_pkg17::uart_ctrl_env17::type_id::create("apb_uart017",this);
    apb_uart117  = uart_ctrl_pkg17::uart_ctrl_env17::type_id::create("apb_uart117",this);
endfunction : build_phase
  
function void apb_subsystem_env17::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB17 transfers17 - handles17 Register Operations17
function void apb_subsystem_env17::write(ahb_transfer17 transfer17);
    if (transfer17.direction17 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer17.address, transfer17.data), UVM_MEDIUM)
      write_effects17(transfer17);
    end
    else if (transfer17.direction17 == READ) begin
      if ((transfer17.address >= `AM_SPI0_BASE_ADDRESS17) && (transfer17.address <= `AM_SPI0_END_ADDRESS17)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update17() with address = 'h%0h, data = 'h%0h", transfer17.address, transfer17.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM117", "Unsupported17 access!!!")
endfunction : write

// UVM_REG: Update CONFIG17 based on APB17 writes to config registers
function void apb_subsystem_env17::write_effects17(ahb_transfer17 transfer17);
    case (transfer17.address)
      `AM_SPI0_BASE_ADDRESS17 + `SPI_CTRL_REG17 : begin
                                                  spi_csr17.mode_select17        = 1'b1;
                                                  spi_csr17.tx_clk_phase17       = transfer17.data[10];
                                                  spi_csr17.rx_clk_phase17       = transfer17.data[9];
                                                  spi_csr17.transfer_data_size17 = transfer17.data[6:0];
                                                  spi_csr17.get_data_size_as_int17();
                                                  spi_csr17.Copycfg_struct17();
                                                  spi_csr_out17.write(spi_csr17);
      `uvm_info("USR_MONITOR17", $psprintf("SPI17 CSR17 is \n%s", spi_csr17.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS17 + `SPI_DIV_REG17  : begin
                                                  spi_csr17.baud_rate_divisor17  = transfer17.data[15:0];
                                                  spi_csr17.Copycfg_struct17();
                                                  spi_csr_out17.write(spi_csr17);
                                                end
      `AM_SPI0_BASE_ADDRESS17 + `SPI_SS_REG17   : begin
                                                  spi_csr17.n_ss_out17           = transfer17.data[7:0];
                                                  spi_csr17.Copycfg_struct17();
                                                  spi_csr_out17.write(spi_csr17);
                                                end
      `AM_GPIO0_BASE_ADDRESS17 + `GPIO_BYPASS_MODE_REG17 : begin
                                                  gpio_csr17.bypass_mode17       = transfer17.data[0];
                                                  gpio_csr17.Copycfg_struct17();
                                                  gpio_csr_out17.write(gpio_csr17);
                                                end
      `AM_GPIO0_BASE_ADDRESS17 + `GPIO_DIRECTION_MODE_REG17 : begin
                                                  gpio_csr17.direction_mode17    = transfer17.data[0];
                                                  gpio_csr17.Copycfg_struct17();
                                                  gpio_csr_out17.write(gpio_csr17);
                                                end
      `AM_GPIO0_BASE_ADDRESS17 + `GPIO_OUTPUT_ENABLE_REG17 : begin
                                                  gpio_csr17.output_enable17     = transfer17.data[0];
                                                  gpio_csr17.Copycfg_struct17();
                                                  gpio_csr_out17.write(gpio_csr17);
                                                end
      default: `uvm_info("USR_MONITOR17", $psprintf("Write access not to Control17/Sataus17 Registers17"), UVM_HIGH)
    endcase
endfunction : write_effects17

function void apb_subsystem_env17::read_effects17(ahb_transfer17 transfer17);
  // Nothing for now
endfunction : read_effects17


