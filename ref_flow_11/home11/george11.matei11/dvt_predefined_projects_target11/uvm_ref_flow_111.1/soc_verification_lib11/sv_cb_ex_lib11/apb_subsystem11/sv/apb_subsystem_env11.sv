/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_env11.sv
Title11       : 
Project11     :
Created11     :
Description11 : Module11 env11, contains11 the instance of scoreboard11 and coverage11 model
Notes11       : 
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines11.svh"
class apb_subsystem_env11 extends uvm_env; 
  
  // Component configuration classes11
  apb_subsystem_config11 cfg;
  // These11 are pointers11 to config classes11 above11
  spi_pkg11::spi_csr11 spi_csr11;
  gpio_pkg11::gpio_csr11 gpio_csr11;

  uart_ctrl_pkg11::uart_ctrl_env11 apb_uart011; //block level module UVC11 reused11 - contains11 monitors11, scoreboard11, coverage11.
  uart_ctrl_pkg11::uart_ctrl_env11 apb_uart111; //block level module UVC11 reused11 - contains11 monitors11, scoreboard11, coverage11.
  
  // Module11 monitor11 (includes11 scoreboards11, coverage11, checking)
  apb_subsystem_monitor11 monitor11;

  // Pointer11 to the Register Database11 address map
  uvm_reg_block reg_model_ptr11;
   
  // TLM Connections11 
  uvm_analysis_port #(spi_pkg11::spi_csr11) spi_csr_out11;
  uvm_analysis_port #(gpio_pkg11::gpio_csr11) gpio_csr_out11;
  uvm_analysis_imp #(ahb_transfer11, apb_subsystem_env11) ahb_in11;

  `uvm_component_utils_begin(apb_subsystem_env11)
    `uvm_field_object(reg_model_ptr11, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create11 TLM ports11
    spi_csr_out11 = new("spi_csr_out11", this);
    gpio_csr_out11 = new("gpio_csr_out11", this);
    ahb_in11 = new("apb_in11", this);
    spi_csr11  = spi_pkg11::spi_csr11::type_id::create("spi_csr11", this) ;
    gpio_csr11 = gpio_pkg11::gpio_csr11::type_id::create("gpio_csr11", this) ;
  endfunction

  // Additional11 class methods11
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer11 transfer11);
  extern virtual function void write_effects11(ahb_transfer11 transfer11);
  extern virtual function void read_effects11(ahb_transfer11 transfer11);

endclass : apb_subsystem_env11

function void apb_subsystem_env11::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure11 the device11
  if (!uvm_config_db#(apb_subsystem_config11)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config11 creating11...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config11::get_type(),
                                     default_apb_subsystem_config11::get_type());
    cfg = apb_subsystem_config11::type_id::create("cfg");
  end
  // build system level monitor11
  monitor11 = apb_subsystem_monitor11::type_id::create("monitor11",this);
    apb_uart011  = uart_ctrl_pkg11::uart_ctrl_env11::type_id::create("apb_uart011",this);
    apb_uart111  = uart_ctrl_pkg11::uart_ctrl_env11::type_id::create("apb_uart111",this);
endfunction : build_phase
  
function void apb_subsystem_env11::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB11 transfers11 - handles11 Register Operations11
function void apb_subsystem_env11::write(ahb_transfer11 transfer11);
    if (transfer11.direction11 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer11.address, transfer11.data), UVM_MEDIUM)
      write_effects11(transfer11);
    end
    else if (transfer11.direction11 == READ) begin
      if ((transfer11.address >= `AM_SPI0_BASE_ADDRESS11) && (transfer11.address <= `AM_SPI0_END_ADDRESS11)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update11() with address = 'h%0h, data = 'h%0h", transfer11.address, transfer11.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM111", "Unsupported11 access!!!")
endfunction : write

// UVM_REG: Update CONFIG11 based on APB11 writes to config registers
function void apb_subsystem_env11::write_effects11(ahb_transfer11 transfer11);
    case (transfer11.address)
      `AM_SPI0_BASE_ADDRESS11 + `SPI_CTRL_REG11 : begin
                                                  spi_csr11.mode_select11        = 1'b1;
                                                  spi_csr11.tx_clk_phase11       = transfer11.data[10];
                                                  spi_csr11.rx_clk_phase11       = transfer11.data[9];
                                                  spi_csr11.transfer_data_size11 = transfer11.data[6:0];
                                                  spi_csr11.get_data_size_as_int11();
                                                  spi_csr11.Copycfg_struct11();
                                                  spi_csr_out11.write(spi_csr11);
      `uvm_info("USR_MONITOR11", $psprintf("SPI11 CSR11 is \n%s", spi_csr11.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS11 + `SPI_DIV_REG11  : begin
                                                  spi_csr11.baud_rate_divisor11  = transfer11.data[15:0];
                                                  spi_csr11.Copycfg_struct11();
                                                  spi_csr_out11.write(spi_csr11);
                                                end
      `AM_SPI0_BASE_ADDRESS11 + `SPI_SS_REG11   : begin
                                                  spi_csr11.n_ss_out11           = transfer11.data[7:0];
                                                  spi_csr11.Copycfg_struct11();
                                                  spi_csr_out11.write(spi_csr11);
                                                end
      `AM_GPIO0_BASE_ADDRESS11 + `GPIO_BYPASS_MODE_REG11 : begin
                                                  gpio_csr11.bypass_mode11       = transfer11.data[0];
                                                  gpio_csr11.Copycfg_struct11();
                                                  gpio_csr_out11.write(gpio_csr11);
                                                end
      `AM_GPIO0_BASE_ADDRESS11 + `GPIO_DIRECTION_MODE_REG11 : begin
                                                  gpio_csr11.direction_mode11    = transfer11.data[0];
                                                  gpio_csr11.Copycfg_struct11();
                                                  gpio_csr_out11.write(gpio_csr11);
                                                end
      `AM_GPIO0_BASE_ADDRESS11 + `GPIO_OUTPUT_ENABLE_REG11 : begin
                                                  gpio_csr11.output_enable11     = transfer11.data[0];
                                                  gpio_csr11.Copycfg_struct11();
                                                  gpio_csr_out11.write(gpio_csr11);
                                                end
      default: `uvm_info("USR_MONITOR11", $psprintf("Write access not to Control11/Sataus11 Registers11"), UVM_HIGH)
    endcase
endfunction : write_effects11

function void apb_subsystem_env11::read_effects11(ahb_transfer11 transfer11);
  // Nothing for now
endfunction : read_effects11


