/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_env4.sv
Title4       : 
Project4     :
Created4     :
Description4 : Module4 env4, contains4 the instance of scoreboard4 and coverage4 model
Notes4       : 
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines4.svh"
class apb_subsystem_env4 extends uvm_env; 
  
  // Component configuration classes4
  apb_subsystem_config4 cfg;
  // These4 are pointers4 to config classes4 above4
  spi_pkg4::spi_csr4 spi_csr4;
  gpio_pkg4::gpio_csr4 gpio_csr4;

  uart_ctrl_pkg4::uart_ctrl_env4 apb_uart04; //block level module UVC4 reused4 - contains4 monitors4, scoreboard4, coverage4.
  uart_ctrl_pkg4::uart_ctrl_env4 apb_uart14; //block level module UVC4 reused4 - contains4 monitors4, scoreboard4, coverage4.
  
  // Module4 monitor4 (includes4 scoreboards4, coverage4, checking)
  apb_subsystem_monitor4 monitor4;

  // Pointer4 to the Register Database4 address map
  uvm_reg_block reg_model_ptr4;
   
  // TLM Connections4 
  uvm_analysis_port #(spi_pkg4::spi_csr4) spi_csr_out4;
  uvm_analysis_port #(gpio_pkg4::gpio_csr4) gpio_csr_out4;
  uvm_analysis_imp #(ahb_transfer4, apb_subsystem_env4) ahb_in4;

  `uvm_component_utils_begin(apb_subsystem_env4)
    `uvm_field_object(reg_model_ptr4, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create4 TLM ports4
    spi_csr_out4 = new("spi_csr_out4", this);
    gpio_csr_out4 = new("gpio_csr_out4", this);
    ahb_in4 = new("apb_in4", this);
    spi_csr4  = spi_pkg4::spi_csr4::type_id::create("spi_csr4", this) ;
    gpio_csr4 = gpio_pkg4::gpio_csr4::type_id::create("gpio_csr4", this) ;
  endfunction

  // Additional4 class methods4
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer4 transfer4);
  extern virtual function void write_effects4(ahb_transfer4 transfer4);
  extern virtual function void read_effects4(ahb_transfer4 transfer4);

endclass : apb_subsystem_env4

function void apb_subsystem_env4::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure4 the device4
  if (!uvm_config_db#(apb_subsystem_config4)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config4 creating4...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config4::get_type(),
                                     default_apb_subsystem_config4::get_type());
    cfg = apb_subsystem_config4::type_id::create("cfg");
  end
  // build system level monitor4
  monitor4 = apb_subsystem_monitor4::type_id::create("monitor4",this);
    apb_uart04  = uart_ctrl_pkg4::uart_ctrl_env4::type_id::create("apb_uart04",this);
    apb_uart14  = uart_ctrl_pkg4::uart_ctrl_env4::type_id::create("apb_uart14",this);
endfunction : build_phase
  
function void apb_subsystem_env4::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB4 transfers4 - handles4 Register Operations4
function void apb_subsystem_env4::write(ahb_transfer4 transfer4);
    if (transfer4.direction4 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer4.address, transfer4.data), UVM_MEDIUM)
      write_effects4(transfer4);
    end
    else if (transfer4.direction4 == READ) begin
      if ((transfer4.address >= `AM_SPI0_BASE_ADDRESS4) && (transfer4.address <= `AM_SPI0_END_ADDRESS4)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update4() with address = 'h%0h, data = 'h%0h", transfer4.address, transfer4.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM14", "Unsupported4 access!!!")
endfunction : write

// UVM_REG: Update CONFIG4 based on APB4 writes to config registers
function void apb_subsystem_env4::write_effects4(ahb_transfer4 transfer4);
    case (transfer4.address)
      `AM_SPI0_BASE_ADDRESS4 + `SPI_CTRL_REG4 : begin
                                                  spi_csr4.mode_select4        = 1'b1;
                                                  spi_csr4.tx_clk_phase4       = transfer4.data[10];
                                                  spi_csr4.rx_clk_phase4       = transfer4.data[9];
                                                  spi_csr4.transfer_data_size4 = transfer4.data[6:0];
                                                  spi_csr4.get_data_size_as_int4();
                                                  spi_csr4.Copycfg_struct4();
                                                  spi_csr_out4.write(spi_csr4);
      `uvm_info("USR_MONITOR4", $psprintf("SPI4 CSR4 is \n%s", spi_csr4.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS4 + `SPI_DIV_REG4  : begin
                                                  spi_csr4.baud_rate_divisor4  = transfer4.data[15:0];
                                                  spi_csr4.Copycfg_struct4();
                                                  spi_csr_out4.write(spi_csr4);
                                                end
      `AM_SPI0_BASE_ADDRESS4 + `SPI_SS_REG4   : begin
                                                  spi_csr4.n_ss_out4           = transfer4.data[7:0];
                                                  spi_csr4.Copycfg_struct4();
                                                  spi_csr_out4.write(spi_csr4);
                                                end
      `AM_GPIO0_BASE_ADDRESS4 + `GPIO_BYPASS_MODE_REG4 : begin
                                                  gpio_csr4.bypass_mode4       = transfer4.data[0];
                                                  gpio_csr4.Copycfg_struct4();
                                                  gpio_csr_out4.write(gpio_csr4);
                                                end
      `AM_GPIO0_BASE_ADDRESS4 + `GPIO_DIRECTION_MODE_REG4 : begin
                                                  gpio_csr4.direction_mode4    = transfer4.data[0];
                                                  gpio_csr4.Copycfg_struct4();
                                                  gpio_csr_out4.write(gpio_csr4);
                                                end
      `AM_GPIO0_BASE_ADDRESS4 + `GPIO_OUTPUT_ENABLE_REG4 : begin
                                                  gpio_csr4.output_enable4     = transfer4.data[0];
                                                  gpio_csr4.Copycfg_struct4();
                                                  gpio_csr_out4.write(gpio_csr4);
                                                end
      default: `uvm_info("USR_MONITOR4", $psprintf("Write access not to Control4/Sataus4 Registers4"), UVM_HIGH)
    endcase
endfunction : write_effects4

function void apb_subsystem_env4::read_effects4(ahb_transfer4 transfer4);
  // Nothing for now
endfunction : read_effects4


