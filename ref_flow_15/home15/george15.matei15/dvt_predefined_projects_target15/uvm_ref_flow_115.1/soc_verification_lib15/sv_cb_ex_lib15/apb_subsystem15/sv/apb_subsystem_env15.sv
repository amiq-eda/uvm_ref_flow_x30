/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_env15.sv
Title15       : 
Project15     :
Created15     :
Description15 : Module15 env15, contains15 the instance of scoreboard15 and coverage15 model
Notes15       : 
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines15.svh"
class apb_subsystem_env15 extends uvm_env; 
  
  // Component configuration classes15
  apb_subsystem_config15 cfg;
  // These15 are pointers15 to config classes15 above15
  spi_pkg15::spi_csr15 spi_csr15;
  gpio_pkg15::gpio_csr15 gpio_csr15;

  uart_ctrl_pkg15::uart_ctrl_env15 apb_uart015; //block level module UVC15 reused15 - contains15 monitors15, scoreboard15, coverage15.
  uart_ctrl_pkg15::uart_ctrl_env15 apb_uart115; //block level module UVC15 reused15 - contains15 monitors15, scoreboard15, coverage15.
  
  // Module15 monitor15 (includes15 scoreboards15, coverage15, checking)
  apb_subsystem_monitor15 monitor15;

  // Pointer15 to the Register Database15 address map
  uvm_reg_block reg_model_ptr15;
   
  // TLM Connections15 
  uvm_analysis_port #(spi_pkg15::spi_csr15) spi_csr_out15;
  uvm_analysis_port #(gpio_pkg15::gpio_csr15) gpio_csr_out15;
  uvm_analysis_imp #(ahb_transfer15, apb_subsystem_env15) ahb_in15;

  `uvm_component_utils_begin(apb_subsystem_env15)
    `uvm_field_object(reg_model_ptr15, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create15 TLM ports15
    spi_csr_out15 = new("spi_csr_out15", this);
    gpio_csr_out15 = new("gpio_csr_out15", this);
    ahb_in15 = new("apb_in15", this);
    spi_csr15  = spi_pkg15::spi_csr15::type_id::create("spi_csr15", this) ;
    gpio_csr15 = gpio_pkg15::gpio_csr15::type_id::create("gpio_csr15", this) ;
  endfunction

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer15 transfer15);
  extern virtual function void write_effects15(ahb_transfer15 transfer15);
  extern virtual function void read_effects15(ahb_transfer15 transfer15);

endclass : apb_subsystem_env15

function void apb_subsystem_env15::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure15 the device15
  if (!uvm_config_db#(apb_subsystem_config15)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config15 creating15...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config15::get_type(),
                                     default_apb_subsystem_config15::get_type());
    cfg = apb_subsystem_config15::type_id::create("cfg");
  end
  // build system level monitor15
  monitor15 = apb_subsystem_monitor15::type_id::create("monitor15",this);
    apb_uart015  = uart_ctrl_pkg15::uart_ctrl_env15::type_id::create("apb_uart015",this);
    apb_uart115  = uart_ctrl_pkg15::uart_ctrl_env15::type_id::create("apb_uart115",this);
endfunction : build_phase
  
function void apb_subsystem_env15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB15 transfers15 - handles15 Register Operations15
function void apb_subsystem_env15::write(ahb_transfer15 transfer15);
    if (transfer15.direction15 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer15.address, transfer15.data), UVM_MEDIUM)
      write_effects15(transfer15);
    end
    else if (transfer15.direction15 == READ) begin
      if ((transfer15.address >= `AM_SPI0_BASE_ADDRESS15) && (transfer15.address <= `AM_SPI0_END_ADDRESS15)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update15() with address = 'h%0h, data = 'h%0h", transfer15.address, transfer15.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM115", "Unsupported15 access!!!")
endfunction : write

// UVM_REG: Update CONFIG15 based on APB15 writes to config registers
function void apb_subsystem_env15::write_effects15(ahb_transfer15 transfer15);
    case (transfer15.address)
      `AM_SPI0_BASE_ADDRESS15 + `SPI_CTRL_REG15 : begin
                                                  spi_csr15.mode_select15        = 1'b1;
                                                  spi_csr15.tx_clk_phase15       = transfer15.data[10];
                                                  spi_csr15.rx_clk_phase15       = transfer15.data[9];
                                                  spi_csr15.transfer_data_size15 = transfer15.data[6:0];
                                                  spi_csr15.get_data_size_as_int15();
                                                  spi_csr15.Copycfg_struct15();
                                                  spi_csr_out15.write(spi_csr15);
      `uvm_info("USR_MONITOR15", $psprintf("SPI15 CSR15 is \n%s", spi_csr15.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS15 + `SPI_DIV_REG15  : begin
                                                  spi_csr15.baud_rate_divisor15  = transfer15.data[15:0];
                                                  spi_csr15.Copycfg_struct15();
                                                  spi_csr_out15.write(spi_csr15);
                                                end
      `AM_SPI0_BASE_ADDRESS15 + `SPI_SS_REG15   : begin
                                                  spi_csr15.n_ss_out15           = transfer15.data[7:0];
                                                  spi_csr15.Copycfg_struct15();
                                                  spi_csr_out15.write(spi_csr15);
                                                end
      `AM_GPIO0_BASE_ADDRESS15 + `GPIO_BYPASS_MODE_REG15 : begin
                                                  gpio_csr15.bypass_mode15       = transfer15.data[0];
                                                  gpio_csr15.Copycfg_struct15();
                                                  gpio_csr_out15.write(gpio_csr15);
                                                end
      `AM_GPIO0_BASE_ADDRESS15 + `GPIO_DIRECTION_MODE_REG15 : begin
                                                  gpio_csr15.direction_mode15    = transfer15.data[0];
                                                  gpio_csr15.Copycfg_struct15();
                                                  gpio_csr_out15.write(gpio_csr15);
                                                end
      `AM_GPIO0_BASE_ADDRESS15 + `GPIO_OUTPUT_ENABLE_REG15 : begin
                                                  gpio_csr15.output_enable15     = transfer15.data[0];
                                                  gpio_csr15.Copycfg_struct15();
                                                  gpio_csr_out15.write(gpio_csr15);
                                                end
      default: `uvm_info("USR_MONITOR15", $psprintf("Write access not to Control15/Sataus15 Registers15"), UVM_HIGH)
    endcase
endfunction : write_effects15

function void apb_subsystem_env15::read_effects15(ahb_transfer15 transfer15);
  // Nothing for now
endfunction : read_effects15


