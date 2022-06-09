/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_env3.sv
Title3       : 
Project3     :
Created3     :
Description3 : Module3 env3, contains3 the instance of scoreboard3 and coverage3 model
Notes3       : 
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines3.svh"
class apb_subsystem_env3 extends uvm_env; 
  
  // Component configuration classes3
  apb_subsystem_config3 cfg;
  // These3 are pointers3 to config classes3 above3
  spi_pkg3::spi_csr3 spi_csr3;
  gpio_pkg3::gpio_csr3 gpio_csr3;

  uart_ctrl_pkg3::uart_ctrl_env3 apb_uart03; //block level module UVC3 reused3 - contains3 monitors3, scoreboard3, coverage3.
  uart_ctrl_pkg3::uart_ctrl_env3 apb_uart13; //block level module UVC3 reused3 - contains3 monitors3, scoreboard3, coverage3.
  
  // Module3 monitor3 (includes3 scoreboards3, coverage3, checking)
  apb_subsystem_monitor3 monitor3;

  // Pointer3 to the Register Database3 address map
  uvm_reg_block reg_model_ptr3;
   
  // TLM Connections3 
  uvm_analysis_port #(spi_pkg3::spi_csr3) spi_csr_out3;
  uvm_analysis_port #(gpio_pkg3::gpio_csr3) gpio_csr_out3;
  uvm_analysis_imp #(ahb_transfer3, apb_subsystem_env3) ahb_in3;

  `uvm_component_utils_begin(apb_subsystem_env3)
    `uvm_field_object(reg_model_ptr3, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create3 TLM ports3
    spi_csr_out3 = new("spi_csr_out3", this);
    gpio_csr_out3 = new("gpio_csr_out3", this);
    ahb_in3 = new("apb_in3", this);
    spi_csr3  = spi_pkg3::spi_csr3::type_id::create("spi_csr3", this) ;
    gpio_csr3 = gpio_pkg3::gpio_csr3::type_id::create("gpio_csr3", this) ;
  endfunction

  // Additional3 class methods3
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer3 transfer3);
  extern virtual function void write_effects3(ahb_transfer3 transfer3);
  extern virtual function void read_effects3(ahb_transfer3 transfer3);

endclass : apb_subsystem_env3

function void apb_subsystem_env3::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure3 the device3
  if (!uvm_config_db#(apb_subsystem_config3)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config3 creating3...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config3::get_type(),
                                     default_apb_subsystem_config3::get_type());
    cfg = apb_subsystem_config3::type_id::create("cfg");
  end
  // build system level monitor3
  monitor3 = apb_subsystem_monitor3::type_id::create("monitor3",this);
    apb_uart03  = uart_ctrl_pkg3::uart_ctrl_env3::type_id::create("apb_uart03",this);
    apb_uart13  = uart_ctrl_pkg3::uart_ctrl_env3::type_id::create("apb_uart13",this);
endfunction : build_phase
  
function void apb_subsystem_env3::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB3 transfers3 - handles3 Register Operations3
function void apb_subsystem_env3::write(ahb_transfer3 transfer3);
    if (transfer3.direction3 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer3.address, transfer3.data), UVM_MEDIUM)
      write_effects3(transfer3);
    end
    else if (transfer3.direction3 == READ) begin
      if ((transfer3.address >= `AM_SPI0_BASE_ADDRESS3) && (transfer3.address <= `AM_SPI0_END_ADDRESS3)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update3() with address = 'h%0h, data = 'h%0h", transfer3.address, transfer3.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM13", "Unsupported3 access!!!")
endfunction : write

// UVM_REG: Update CONFIG3 based on APB3 writes to config registers
function void apb_subsystem_env3::write_effects3(ahb_transfer3 transfer3);
    case (transfer3.address)
      `AM_SPI0_BASE_ADDRESS3 + `SPI_CTRL_REG3 : begin
                                                  spi_csr3.mode_select3        = 1'b1;
                                                  spi_csr3.tx_clk_phase3       = transfer3.data[10];
                                                  spi_csr3.rx_clk_phase3       = transfer3.data[9];
                                                  spi_csr3.transfer_data_size3 = transfer3.data[6:0];
                                                  spi_csr3.get_data_size_as_int3();
                                                  spi_csr3.Copycfg_struct3();
                                                  spi_csr_out3.write(spi_csr3);
      `uvm_info("USR_MONITOR3", $psprintf("SPI3 CSR3 is \n%s", spi_csr3.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS3 + `SPI_DIV_REG3  : begin
                                                  spi_csr3.baud_rate_divisor3  = transfer3.data[15:0];
                                                  spi_csr3.Copycfg_struct3();
                                                  spi_csr_out3.write(spi_csr3);
                                                end
      `AM_SPI0_BASE_ADDRESS3 + `SPI_SS_REG3   : begin
                                                  spi_csr3.n_ss_out3           = transfer3.data[7:0];
                                                  spi_csr3.Copycfg_struct3();
                                                  spi_csr_out3.write(spi_csr3);
                                                end
      `AM_GPIO0_BASE_ADDRESS3 + `GPIO_BYPASS_MODE_REG3 : begin
                                                  gpio_csr3.bypass_mode3       = transfer3.data[0];
                                                  gpio_csr3.Copycfg_struct3();
                                                  gpio_csr_out3.write(gpio_csr3);
                                                end
      `AM_GPIO0_BASE_ADDRESS3 + `GPIO_DIRECTION_MODE_REG3 : begin
                                                  gpio_csr3.direction_mode3    = transfer3.data[0];
                                                  gpio_csr3.Copycfg_struct3();
                                                  gpio_csr_out3.write(gpio_csr3);
                                                end
      `AM_GPIO0_BASE_ADDRESS3 + `GPIO_OUTPUT_ENABLE_REG3 : begin
                                                  gpio_csr3.output_enable3     = transfer3.data[0];
                                                  gpio_csr3.Copycfg_struct3();
                                                  gpio_csr_out3.write(gpio_csr3);
                                                end
      default: `uvm_info("USR_MONITOR3", $psprintf("Write access not to Control3/Sataus3 Registers3"), UVM_HIGH)
    endcase
endfunction : write_effects3

function void apb_subsystem_env3::read_effects3(ahb_transfer3 transfer3);
  // Nothing for now
endfunction : read_effects3


