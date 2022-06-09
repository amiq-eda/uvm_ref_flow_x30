/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_env29.sv
Title29       : 
Project29     :
Created29     :
Description29 : Module29 env29, contains29 the instance of scoreboard29 and coverage29 model
Notes29       : 
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines29.svh"
class apb_subsystem_env29 extends uvm_env; 
  
  // Component configuration classes29
  apb_subsystem_config29 cfg;
  // These29 are pointers29 to config classes29 above29
  spi_pkg29::spi_csr29 spi_csr29;
  gpio_pkg29::gpio_csr29 gpio_csr29;

  uart_ctrl_pkg29::uart_ctrl_env29 apb_uart029; //block level module UVC29 reused29 - contains29 monitors29, scoreboard29, coverage29.
  uart_ctrl_pkg29::uart_ctrl_env29 apb_uart129; //block level module UVC29 reused29 - contains29 monitors29, scoreboard29, coverage29.
  
  // Module29 monitor29 (includes29 scoreboards29, coverage29, checking)
  apb_subsystem_monitor29 monitor29;

  // Pointer29 to the Register Database29 address map
  uvm_reg_block reg_model_ptr29;
   
  // TLM Connections29 
  uvm_analysis_port #(spi_pkg29::spi_csr29) spi_csr_out29;
  uvm_analysis_port #(gpio_pkg29::gpio_csr29) gpio_csr_out29;
  uvm_analysis_imp #(ahb_transfer29, apb_subsystem_env29) ahb_in29;

  `uvm_component_utils_begin(apb_subsystem_env29)
    `uvm_field_object(reg_model_ptr29, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create29 TLM ports29
    spi_csr_out29 = new("spi_csr_out29", this);
    gpio_csr_out29 = new("gpio_csr_out29", this);
    ahb_in29 = new("apb_in29", this);
    spi_csr29  = spi_pkg29::spi_csr29::type_id::create("spi_csr29", this) ;
    gpio_csr29 = gpio_pkg29::gpio_csr29::type_id::create("gpio_csr29", this) ;
  endfunction

  // Additional29 class methods29
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer29 transfer29);
  extern virtual function void write_effects29(ahb_transfer29 transfer29);
  extern virtual function void read_effects29(ahb_transfer29 transfer29);

endclass : apb_subsystem_env29

function void apb_subsystem_env29::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure29 the device29
  if (!uvm_config_db#(apb_subsystem_config29)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config29 creating29...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config29::get_type(),
                                     default_apb_subsystem_config29::get_type());
    cfg = apb_subsystem_config29::type_id::create("cfg");
  end
  // build system level monitor29
  monitor29 = apb_subsystem_monitor29::type_id::create("monitor29",this);
    apb_uart029  = uart_ctrl_pkg29::uart_ctrl_env29::type_id::create("apb_uart029",this);
    apb_uart129  = uart_ctrl_pkg29::uart_ctrl_env29::type_id::create("apb_uart129",this);
endfunction : build_phase
  
function void apb_subsystem_env29::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB29 transfers29 - handles29 Register Operations29
function void apb_subsystem_env29::write(ahb_transfer29 transfer29);
    if (transfer29.direction29 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer29.address, transfer29.data), UVM_MEDIUM)
      write_effects29(transfer29);
    end
    else if (transfer29.direction29 == READ) begin
      if ((transfer29.address >= `AM_SPI0_BASE_ADDRESS29) && (transfer29.address <= `AM_SPI0_END_ADDRESS29)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update29() with address = 'h%0h, data = 'h%0h", transfer29.address, transfer29.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM129", "Unsupported29 access!!!")
endfunction : write

// UVM_REG: Update CONFIG29 based on APB29 writes to config registers
function void apb_subsystem_env29::write_effects29(ahb_transfer29 transfer29);
    case (transfer29.address)
      `AM_SPI0_BASE_ADDRESS29 + `SPI_CTRL_REG29 : begin
                                                  spi_csr29.mode_select29        = 1'b1;
                                                  spi_csr29.tx_clk_phase29       = transfer29.data[10];
                                                  spi_csr29.rx_clk_phase29       = transfer29.data[9];
                                                  spi_csr29.transfer_data_size29 = transfer29.data[6:0];
                                                  spi_csr29.get_data_size_as_int29();
                                                  spi_csr29.Copycfg_struct29();
                                                  spi_csr_out29.write(spi_csr29);
      `uvm_info("USR_MONITOR29", $psprintf("SPI29 CSR29 is \n%s", spi_csr29.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS29 + `SPI_DIV_REG29  : begin
                                                  spi_csr29.baud_rate_divisor29  = transfer29.data[15:0];
                                                  spi_csr29.Copycfg_struct29();
                                                  spi_csr_out29.write(spi_csr29);
                                                end
      `AM_SPI0_BASE_ADDRESS29 + `SPI_SS_REG29   : begin
                                                  spi_csr29.n_ss_out29           = transfer29.data[7:0];
                                                  spi_csr29.Copycfg_struct29();
                                                  spi_csr_out29.write(spi_csr29);
                                                end
      `AM_GPIO0_BASE_ADDRESS29 + `GPIO_BYPASS_MODE_REG29 : begin
                                                  gpio_csr29.bypass_mode29       = transfer29.data[0];
                                                  gpio_csr29.Copycfg_struct29();
                                                  gpio_csr_out29.write(gpio_csr29);
                                                end
      `AM_GPIO0_BASE_ADDRESS29 + `GPIO_DIRECTION_MODE_REG29 : begin
                                                  gpio_csr29.direction_mode29    = transfer29.data[0];
                                                  gpio_csr29.Copycfg_struct29();
                                                  gpio_csr_out29.write(gpio_csr29);
                                                end
      `AM_GPIO0_BASE_ADDRESS29 + `GPIO_OUTPUT_ENABLE_REG29 : begin
                                                  gpio_csr29.output_enable29     = transfer29.data[0];
                                                  gpio_csr29.Copycfg_struct29();
                                                  gpio_csr_out29.write(gpio_csr29);
                                                end
      default: `uvm_info("USR_MONITOR29", $psprintf("Write access not to Control29/Sataus29 Registers29"), UVM_HIGH)
    endcase
endfunction : write_effects29

function void apb_subsystem_env29::read_effects29(ahb_transfer29 transfer29);
  // Nothing for now
endfunction : read_effects29


