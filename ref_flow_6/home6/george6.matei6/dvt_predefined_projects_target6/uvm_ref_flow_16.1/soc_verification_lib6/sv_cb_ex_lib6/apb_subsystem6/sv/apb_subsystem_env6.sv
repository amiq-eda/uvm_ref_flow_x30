/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_env6.sv
Title6       : 
Project6     :
Created6     :
Description6 : Module6 env6, contains6 the instance of scoreboard6 and coverage6 model
Notes6       : 
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines6.svh"
class apb_subsystem_env6 extends uvm_env; 
  
  // Component configuration classes6
  apb_subsystem_config6 cfg;
  // These6 are pointers6 to config classes6 above6
  spi_pkg6::spi_csr6 spi_csr6;
  gpio_pkg6::gpio_csr6 gpio_csr6;

  uart_ctrl_pkg6::uart_ctrl_env6 apb_uart06; //block level module UVC6 reused6 - contains6 monitors6, scoreboard6, coverage6.
  uart_ctrl_pkg6::uart_ctrl_env6 apb_uart16; //block level module UVC6 reused6 - contains6 monitors6, scoreboard6, coverage6.
  
  // Module6 monitor6 (includes6 scoreboards6, coverage6, checking)
  apb_subsystem_monitor6 monitor6;

  // Pointer6 to the Register Database6 address map
  uvm_reg_block reg_model_ptr6;
   
  // TLM Connections6 
  uvm_analysis_port #(spi_pkg6::spi_csr6) spi_csr_out6;
  uvm_analysis_port #(gpio_pkg6::gpio_csr6) gpio_csr_out6;
  uvm_analysis_imp #(ahb_transfer6, apb_subsystem_env6) ahb_in6;

  `uvm_component_utils_begin(apb_subsystem_env6)
    `uvm_field_object(reg_model_ptr6, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create6 TLM ports6
    spi_csr_out6 = new("spi_csr_out6", this);
    gpio_csr_out6 = new("gpio_csr_out6", this);
    ahb_in6 = new("apb_in6", this);
    spi_csr6  = spi_pkg6::spi_csr6::type_id::create("spi_csr6", this) ;
    gpio_csr6 = gpio_pkg6::gpio_csr6::type_id::create("gpio_csr6", this) ;
  endfunction

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer6 transfer6);
  extern virtual function void write_effects6(ahb_transfer6 transfer6);
  extern virtual function void read_effects6(ahb_transfer6 transfer6);

endclass : apb_subsystem_env6

function void apb_subsystem_env6::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure6 the device6
  if (!uvm_config_db#(apb_subsystem_config6)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config6 creating6...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config6::get_type(),
                                     default_apb_subsystem_config6::get_type());
    cfg = apb_subsystem_config6::type_id::create("cfg");
  end
  // build system level monitor6
  monitor6 = apb_subsystem_monitor6::type_id::create("monitor6",this);
    apb_uart06  = uart_ctrl_pkg6::uart_ctrl_env6::type_id::create("apb_uart06",this);
    apb_uart16  = uart_ctrl_pkg6::uart_ctrl_env6::type_id::create("apb_uart16",this);
endfunction : build_phase
  
function void apb_subsystem_env6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB6 transfers6 - handles6 Register Operations6
function void apb_subsystem_env6::write(ahb_transfer6 transfer6);
    if (transfer6.direction6 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer6.address, transfer6.data), UVM_MEDIUM)
      write_effects6(transfer6);
    end
    else if (transfer6.direction6 == READ) begin
      if ((transfer6.address >= `AM_SPI0_BASE_ADDRESS6) && (transfer6.address <= `AM_SPI0_END_ADDRESS6)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update6() with address = 'h%0h, data = 'h%0h", transfer6.address, transfer6.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM16", "Unsupported6 access!!!")
endfunction : write

// UVM_REG: Update CONFIG6 based on APB6 writes to config registers
function void apb_subsystem_env6::write_effects6(ahb_transfer6 transfer6);
    case (transfer6.address)
      `AM_SPI0_BASE_ADDRESS6 + `SPI_CTRL_REG6 : begin
                                                  spi_csr6.mode_select6        = 1'b1;
                                                  spi_csr6.tx_clk_phase6       = transfer6.data[10];
                                                  spi_csr6.rx_clk_phase6       = transfer6.data[9];
                                                  spi_csr6.transfer_data_size6 = transfer6.data[6:0];
                                                  spi_csr6.get_data_size_as_int6();
                                                  spi_csr6.Copycfg_struct6();
                                                  spi_csr_out6.write(spi_csr6);
      `uvm_info("USR_MONITOR6", $psprintf("SPI6 CSR6 is \n%s", spi_csr6.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS6 + `SPI_DIV_REG6  : begin
                                                  spi_csr6.baud_rate_divisor6  = transfer6.data[15:0];
                                                  spi_csr6.Copycfg_struct6();
                                                  spi_csr_out6.write(spi_csr6);
                                                end
      `AM_SPI0_BASE_ADDRESS6 + `SPI_SS_REG6   : begin
                                                  spi_csr6.n_ss_out6           = transfer6.data[7:0];
                                                  spi_csr6.Copycfg_struct6();
                                                  spi_csr_out6.write(spi_csr6);
                                                end
      `AM_GPIO0_BASE_ADDRESS6 + `GPIO_BYPASS_MODE_REG6 : begin
                                                  gpio_csr6.bypass_mode6       = transfer6.data[0];
                                                  gpio_csr6.Copycfg_struct6();
                                                  gpio_csr_out6.write(gpio_csr6);
                                                end
      `AM_GPIO0_BASE_ADDRESS6 + `GPIO_DIRECTION_MODE_REG6 : begin
                                                  gpio_csr6.direction_mode6    = transfer6.data[0];
                                                  gpio_csr6.Copycfg_struct6();
                                                  gpio_csr_out6.write(gpio_csr6);
                                                end
      `AM_GPIO0_BASE_ADDRESS6 + `GPIO_OUTPUT_ENABLE_REG6 : begin
                                                  gpio_csr6.output_enable6     = transfer6.data[0];
                                                  gpio_csr6.Copycfg_struct6();
                                                  gpio_csr_out6.write(gpio_csr6);
                                                end
      default: `uvm_info("USR_MONITOR6", $psprintf("Write access not to Control6/Sataus6 Registers6"), UVM_HIGH)
    endcase
endfunction : write_effects6

function void apb_subsystem_env6::read_effects6(ahb_transfer6 transfer6);
  // Nothing for now
endfunction : read_effects6


