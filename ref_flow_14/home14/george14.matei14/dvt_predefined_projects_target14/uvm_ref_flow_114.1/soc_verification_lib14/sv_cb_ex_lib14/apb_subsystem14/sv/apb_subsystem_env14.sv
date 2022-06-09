/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_env14.sv
Title14       : 
Project14     :
Created14     :
Description14 : Module14 env14, contains14 the instance of scoreboard14 and coverage14 model
Notes14       : 
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines14.svh"
class apb_subsystem_env14 extends uvm_env; 
  
  // Component configuration classes14
  apb_subsystem_config14 cfg;
  // These14 are pointers14 to config classes14 above14
  spi_pkg14::spi_csr14 spi_csr14;
  gpio_pkg14::gpio_csr14 gpio_csr14;

  uart_ctrl_pkg14::uart_ctrl_env14 apb_uart014; //block level module UVC14 reused14 - contains14 monitors14, scoreboard14, coverage14.
  uart_ctrl_pkg14::uart_ctrl_env14 apb_uart114; //block level module UVC14 reused14 - contains14 monitors14, scoreboard14, coverage14.
  
  // Module14 monitor14 (includes14 scoreboards14, coverage14, checking)
  apb_subsystem_monitor14 monitor14;

  // Pointer14 to the Register Database14 address map
  uvm_reg_block reg_model_ptr14;
   
  // TLM Connections14 
  uvm_analysis_port #(spi_pkg14::spi_csr14) spi_csr_out14;
  uvm_analysis_port #(gpio_pkg14::gpio_csr14) gpio_csr_out14;
  uvm_analysis_imp #(ahb_transfer14, apb_subsystem_env14) ahb_in14;

  `uvm_component_utils_begin(apb_subsystem_env14)
    `uvm_field_object(reg_model_ptr14, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create14 TLM ports14
    spi_csr_out14 = new("spi_csr_out14", this);
    gpio_csr_out14 = new("gpio_csr_out14", this);
    ahb_in14 = new("apb_in14", this);
    spi_csr14  = spi_pkg14::spi_csr14::type_id::create("spi_csr14", this) ;
    gpio_csr14 = gpio_pkg14::gpio_csr14::type_id::create("gpio_csr14", this) ;
  endfunction

  // Additional14 class methods14
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer14 transfer14);
  extern virtual function void write_effects14(ahb_transfer14 transfer14);
  extern virtual function void read_effects14(ahb_transfer14 transfer14);

endclass : apb_subsystem_env14

function void apb_subsystem_env14::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure14 the device14
  if (!uvm_config_db#(apb_subsystem_config14)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config14 creating14...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config14::get_type(),
                                     default_apb_subsystem_config14::get_type());
    cfg = apb_subsystem_config14::type_id::create("cfg");
  end
  // build system level monitor14
  monitor14 = apb_subsystem_monitor14::type_id::create("monitor14",this);
    apb_uart014  = uart_ctrl_pkg14::uart_ctrl_env14::type_id::create("apb_uart014",this);
    apb_uart114  = uart_ctrl_pkg14::uart_ctrl_env14::type_id::create("apb_uart114",this);
endfunction : build_phase
  
function void apb_subsystem_env14::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB14 transfers14 - handles14 Register Operations14
function void apb_subsystem_env14::write(ahb_transfer14 transfer14);
    if (transfer14.direction14 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer14.address, transfer14.data), UVM_MEDIUM)
      write_effects14(transfer14);
    end
    else if (transfer14.direction14 == READ) begin
      if ((transfer14.address >= `AM_SPI0_BASE_ADDRESS14) && (transfer14.address <= `AM_SPI0_END_ADDRESS14)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update14() with address = 'h%0h, data = 'h%0h", transfer14.address, transfer14.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM114", "Unsupported14 access!!!")
endfunction : write

// UVM_REG: Update CONFIG14 based on APB14 writes to config registers
function void apb_subsystem_env14::write_effects14(ahb_transfer14 transfer14);
    case (transfer14.address)
      `AM_SPI0_BASE_ADDRESS14 + `SPI_CTRL_REG14 : begin
                                                  spi_csr14.mode_select14        = 1'b1;
                                                  spi_csr14.tx_clk_phase14       = transfer14.data[10];
                                                  spi_csr14.rx_clk_phase14       = transfer14.data[9];
                                                  spi_csr14.transfer_data_size14 = transfer14.data[6:0];
                                                  spi_csr14.get_data_size_as_int14();
                                                  spi_csr14.Copycfg_struct14();
                                                  spi_csr_out14.write(spi_csr14);
      `uvm_info("USR_MONITOR14", $psprintf("SPI14 CSR14 is \n%s", spi_csr14.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS14 + `SPI_DIV_REG14  : begin
                                                  spi_csr14.baud_rate_divisor14  = transfer14.data[15:0];
                                                  spi_csr14.Copycfg_struct14();
                                                  spi_csr_out14.write(spi_csr14);
                                                end
      `AM_SPI0_BASE_ADDRESS14 + `SPI_SS_REG14   : begin
                                                  spi_csr14.n_ss_out14           = transfer14.data[7:0];
                                                  spi_csr14.Copycfg_struct14();
                                                  spi_csr_out14.write(spi_csr14);
                                                end
      `AM_GPIO0_BASE_ADDRESS14 + `GPIO_BYPASS_MODE_REG14 : begin
                                                  gpio_csr14.bypass_mode14       = transfer14.data[0];
                                                  gpio_csr14.Copycfg_struct14();
                                                  gpio_csr_out14.write(gpio_csr14);
                                                end
      `AM_GPIO0_BASE_ADDRESS14 + `GPIO_DIRECTION_MODE_REG14 : begin
                                                  gpio_csr14.direction_mode14    = transfer14.data[0];
                                                  gpio_csr14.Copycfg_struct14();
                                                  gpio_csr_out14.write(gpio_csr14);
                                                end
      `AM_GPIO0_BASE_ADDRESS14 + `GPIO_OUTPUT_ENABLE_REG14 : begin
                                                  gpio_csr14.output_enable14     = transfer14.data[0];
                                                  gpio_csr14.Copycfg_struct14();
                                                  gpio_csr_out14.write(gpio_csr14);
                                                end
      default: `uvm_info("USR_MONITOR14", $psprintf("Write access not to Control14/Sataus14 Registers14"), UVM_HIGH)
    endcase
endfunction : write_effects14

function void apb_subsystem_env14::read_effects14(ahb_transfer14 transfer14);
  // Nothing for now
endfunction : read_effects14


