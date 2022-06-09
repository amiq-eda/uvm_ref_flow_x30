/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_env26.sv
Title26       : 
Project26     :
Created26     :
Description26 : Module26 env26, contains26 the instance of scoreboard26 and coverage26 model
Notes26       : 
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines26.svh"
class apb_subsystem_env26 extends uvm_env; 
  
  // Component configuration classes26
  apb_subsystem_config26 cfg;
  // These26 are pointers26 to config classes26 above26
  spi_pkg26::spi_csr26 spi_csr26;
  gpio_pkg26::gpio_csr26 gpio_csr26;

  uart_ctrl_pkg26::uart_ctrl_env26 apb_uart026; //block level module UVC26 reused26 - contains26 monitors26, scoreboard26, coverage26.
  uart_ctrl_pkg26::uart_ctrl_env26 apb_uart126; //block level module UVC26 reused26 - contains26 monitors26, scoreboard26, coverage26.
  
  // Module26 monitor26 (includes26 scoreboards26, coverage26, checking)
  apb_subsystem_monitor26 monitor26;

  // Pointer26 to the Register Database26 address map
  uvm_reg_block reg_model_ptr26;
   
  // TLM Connections26 
  uvm_analysis_port #(spi_pkg26::spi_csr26) spi_csr_out26;
  uvm_analysis_port #(gpio_pkg26::gpio_csr26) gpio_csr_out26;
  uvm_analysis_imp #(ahb_transfer26, apb_subsystem_env26) ahb_in26;

  `uvm_component_utils_begin(apb_subsystem_env26)
    `uvm_field_object(reg_model_ptr26, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create26 TLM ports26
    spi_csr_out26 = new("spi_csr_out26", this);
    gpio_csr_out26 = new("gpio_csr_out26", this);
    ahb_in26 = new("apb_in26", this);
    spi_csr26  = spi_pkg26::spi_csr26::type_id::create("spi_csr26", this) ;
    gpio_csr26 = gpio_pkg26::gpio_csr26::type_id::create("gpio_csr26", this) ;
  endfunction

  // Additional26 class methods26
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer26 transfer26);
  extern virtual function void write_effects26(ahb_transfer26 transfer26);
  extern virtual function void read_effects26(ahb_transfer26 transfer26);

endclass : apb_subsystem_env26

function void apb_subsystem_env26::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure26 the device26
  if (!uvm_config_db#(apb_subsystem_config26)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config26 creating26...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config26::get_type(),
                                     default_apb_subsystem_config26::get_type());
    cfg = apb_subsystem_config26::type_id::create("cfg");
  end
  // build system level monitor26
  monitor26 = apb_subsystem_monitor26::type_id::create("monitor26",this);
    apb_uart026  = uart_ctrl_pkg26::uart_ctrl_env26::type_id::create("apb_uart026",this);
    apb_uart126  = uart_ctrl_pkg26::uart_ctrl_env26::type_id::create("apb_uart126",this);
endfunction : build_phase
  
function void apb_subsystem_env26::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB26 transfers26 - handles26 Register Operations26
function void apb_subsystem_env26::write(ahb_transfer26 transfer26);
    if (transfer26.direction26 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer26.address, transfer26.data), UVM_MEDIUM)
      write_effects26(transfer26);
    end
    else if (transfer26.direction26 == READ) begin
      if ((transfer26.address >= `AM_SPI0_BASE_ADDRESS26) && (transfer26.address <= `AM_SPI0_END_ADDRESS26)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update26() with address = 'h%0h, data = 'h%0h", transfer26.address, transfer26.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM126", "Unsupported26 access!!!")
endfunction : write

// UVM_REG: Update CONFIG26 based on APB26 writes to config registers
function void apb_subsystem_env26::write_effects26(ahb_transfer26 transfer26);
    case (transfer26.address)
      `AM_SPI0_BASE_ADDRESS26 + `SPI_CTRL_REG26 : begin
                                                  spi_csr26.mode_select26        = 1'b1;
                                                  spi_csr26.tx_clk_phase26       = transfer26.data[10];
                                                  spi_csr26.rx_clk_phase26       = transfer26.data[9];
                                                  spi_csr26.transfer_data_size26 = transfer26.data[6:0];
                                                  spi_csr26.get_data_size_as_int26();
                                                  spi_csr26.Copycfg_struct26();
                                                  spi_csr_out26.write(spi_csr26);
      `uvm_info("USR_MONITOR26", $psprintf("SPI26 CSR26 is \n%s", spi_csr26.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS26 + `SPI_DIV_REG26  : begin
                                                  spi_csr26.baud_rate_divisor26  = transfer26.data[15:0];
                                                  spi_csr26.Copycfg_struct26();
                                                  spi_csr_out26.write(spi_csr26);
                                                end
      `AM_SPI0_BASE_ADDRESS26 + `SPI_SS_REG26   : begin
                                                  spi_csr26.n_ss_out26           = transfer26.data[7:0];
                                                  spi_csr26.Copycfg_struct26();
                                                  spi_csr_out26.write(spi_csr26);
                                                end
      `AM_GPIO0_BASE_ADDRESS26 + `GPIO_BYPASS_MODE_REG26 : begin
                                                  gpio_csr26.bypass_mode26       = transfer26.data[0];
                                                  gpio_csr26.Copycfg_struct26();
                                                  gpio_csr_out26.write(gpio_csr26);
                                                end
      `AM_GPIO0_BASE_ADDRESS26 + `GPIO_DIRECTION_MODE_REG26 : begin
                                                  gpio_csr26.direction_mode26    = transfer26.data[0];
                                                  gpio_csr26.Copycfg_struct26();
                                                  gpio_csr_out26.write(gpio_csr26);
                                                end
      `AM_GPIO0_BASE_ADDRESS26 + `GPIO_OUTPUT_ENABLE_REG26 : begin
                                                  gpio_csr26.output_enable26     = transfer26.data[0];
                                                  gpio_csr26.Copycfg_struct26();
                                                  gpio_csr_out26.write(gpio_csr26);
                                                end
      default: `uvm_info("USR_MONITOR26", $psprintf("Write access not to Control26/Sataus26 Registers26"), UVM_HIGH)
    endcase
endfunction : write_effects26

function void apb_subsystem_env26::read_effects26(ahb_transfer26 transfer26);
  // Nothing for now
endfunction : read_effects26


