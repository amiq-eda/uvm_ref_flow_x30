/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_env18.sv
Title18       : 
Project18     :
Created18     :
Description18 : Module18 env18, contains18 the instance of scoreboard18 and coverage18 model
Notes18       : 
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines18.svh"
class apb_subsystem_env18 extends uvm_env; 
  
  // Component configuration classes18
  apb_subsystem_config18 cfg;
  // These18 are pointers18 to config classes18 above18
  spi_pkg18::spi_csr18 spi_csr18;
  gpio_pkg18::gpio_csr18 gpio_csr18;

  uart_ctrl_pkg18::uart_ctrl_env18 apb_uart018; //block level module UVC18 reused18 - contains18 monitors18, scoreboard18, coverage18.
  uart_ctrl_pkg18::uart_ctrl_env18 apb_uart118; //block level module UVC18 reused18 - contains18 monitors18, scoreboard18, coverage18.
  
  // Module18 monitor18 (includes18 scoreboards18, coverage18, checking)
  apb_subsystem_monitor18 monitor18;

  // Pointer18 to the Register Database18 address map
  uvm_reg_block reg_model_ptr18;
   
  // TLM Connections18 
  uvm_analysis_port #(spi_pkg18::spi_csr18) spi_csr_out18;
  uvm_analysis_port #(gpio_pkg18::gpio_csr18) gpio_csr_out18;
  uvm_analysis_imp #(ahb_transfer18, apb_subsystem_env18) ahb_in18;

  `uvm_component_utils_begin(apb_subsystem_env18)
    `uvm_field_object(reg_model_ptr18, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create18 TLM ports18
    spi_csr_out18 = new("spi_csr_out18", this);
    gpio_csr_out18 = new("gpio_csr_out18", this);
    ahb_in18 = new("apb_in18", this);
    spi_csr18  = spi_pkg18::spi_csr18::type_id::create("spi_csr18", this) ;
    gpio_csr18 = gpio_pkg18::gpio_csr18::type_id::create("gpio_csr18", this) ;
  endfunction

  // Additional18 class methods18
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer18 transfer18);
  extern virtual function void write_effects18(ahb_transfer18 transfer18);
  extern virtual function void read_effects18(ahb_transfer18 transfer18);

endclass : apb_subsystem_env18

function void apb_subsystem_env18::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure18 the device18
  if (!uvm_config_db#(apb_subsystem_config18)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config18 creating18...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config18::get_type(),
                                     default_apb_subsystem_config18::get_type());
    cfg = apb_subsystem_config18::type_id::create("cfg");
  end
  // build system level monitor18
  monitor18 = apb_subsystem_monitor18::type_id::create("monitor18",this);
    apb_uart018  = uart_ctrl_pkg18::uart_ctrl_env18::type_id::create("apb_uart018",this);
    apb_uart118  = uart_ctrl_pkg18::uart_ctrl_env18::type_id::create("apb_uart118",this);
endfunction : build_phase
  
function void apb_subsystem_env18::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB18 transfers18 - handles18 Register Operations18
function void apb_subsystem_env18::write(ahb_transfer18 transfer18);
    if (transfer18.direction18 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer18.address, transfer18.data), UVM_MEDIUM)
      write_effects18(transfer18);
    end
    else if (transfer18.direction18 == READ) begin
      if ((transfer18.address >= `AM_SPI0_BASE_ADDRESS18) && (transfer18.address <= `AM_SPI0_END_ADDRESS18)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update18() with address = 'h%0h, data = 'h%0h", transfer18.address, transfer18.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM118", "Unsupported18 access!!!")
endfunction : write

// UVM_REG: Update CONFIG18 based on APB18 writes to config registers
function void apb_subsystem_env18::write_effects18(ahb_transfer18 transfer18);
    case (transfer18.address)
      `AM_SPI0_BASE_ADDRESS18 + `SPI_CTRL_REG18 : begin
                                                  spi_csr18.mode_select18        = 1'b1;
                                                  spi_csr18.tx_clk_phase18       = transfer18.data[10];
                                                  spi_csr18.rx_clk_phase18       = transfer18.data[9];
                                                  spi_csr18.transfer_data_size18 = transfer18.data[6:0];
                                                  spi_csr18.get_data_size_as_int18();
                                                  spi_csr18.Copycfg_struct18();
                                                  spi_csr_out18.write(spi_csr18);
      `uvm_info("USR_MONITOR18", $psprintf("SPI18 CSR18 is \n%s", spi_csr18.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS18 + `SPI_DIV_REG18  : begin
                                                  spi_csr18.baud_rate_divisor18  = transfer18.data[15:0];
                                                  spi_csr18.Copycfg_struct18();
                                                  spi_csr_out18.write(spi_csr18);
                                                end
      `AM_SPI0_BASE_ADDRESS18 + `SPI_SS_REG18   : begin
                                                  spi_csr18.n_ss_out18           = transfer18.data[7:0];
                                                  spi_csr18.Copycfg_struct18();
                                                  spi_csr_out18.write(spi_csr18);
                                                end
      `AM_GPIO0_BASE_ADDRESS18 + `GPIO_BYPASS_MODE_REG18 : begin
                                                  gpio_csr18.bypass_mode18       = transfer18.data[0];
                                                  gpio_csr18.Copycfg_struct18();
                                                  gpio_csr_out18.write(gpio_csr18);
                                                end
      `AM_GPIO0_BASE_ADDRESS18 + `GPIO_DIRECTION_MODE_REG18 : begin
                                                  gpio_csr18.direction_mode18    = transfer18.data[0];
                                                  gpio_csr18.Copycfg_struct18();
                                                  gpio_csr_out18.write(gpio_csr18);
                                                end
      `AM_GPIO0_BASE_ADDRESS18 + `GPIO_OUTPUT_ENABLE_REG18 : begin
                                                  gpio_csr18.output_enable18     = transfer18.data[0];
                                                  gpio_csr18.Copycfg_struct18();
                                                  gpio_csr_out18.write(gpio_csr18);
                                                end
      default: `uvm_info("USR_MONITOR18", $psprintf("Write access not to Control18/Sataus18 Registers18"), UVM_HIGH)
    endcase
endfunction : write_effects18

function void apb_subsystem_env18::read_effects18(ahb_transfer18 transfer18);
  // Nothing for now
endfunction : read_effects18


