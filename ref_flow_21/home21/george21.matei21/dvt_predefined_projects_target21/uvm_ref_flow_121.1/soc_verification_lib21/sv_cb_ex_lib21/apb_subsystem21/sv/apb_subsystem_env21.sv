/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_env21.sv
Title21       : 
Project21     :
Created21     :
Description21 : Module21 env21, contains21 the instance of scoreboard21 and coverage21 model
Notes21       : 
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines21.svh"
class apb_subsystem_env21 extends uvm_env; 
  
  // Component configuration classes21
  apb_subsystem_config21 cfg;
  // These21 are pointers21 to config classes21 above21
  spi_pkg21::spi_csr21 spi_csr21;
  gpio_pkg21::gpio_csr21 gpio_csr21;

  uart_ctrl_pkg21::uart_ctrl_env21 apb_uart021; //block level module UVC21 reused21 - contains21 monitors21, scoreboard21, coverage21.
  uart_ctrl_pkg21::uart_ctrl_env21 apb_uart121; //block level module UVC21 reused21 - contains21 monitors21, scoreboard21, coverage21.
  
  // Module21 monitor21 (includes21 scoreboards21, coverage21, checking)
  apb_subsystem_monitor21 monitor21;

  // Pointer21 to the Register Database21 address map
  uvm_reg_block reg_model_ptr21;
   
  // TLM Connections21 
  uvm_analysis_port #(spi_pkg21::spi_csr21) spi_csr_out21;
  uvm_analysis_port #(gpio_pkg21::gpio_csr21) gpio_csr_out21;
  uvm_analysis_imp #(ahb_transfer21, apb_subsystem_env21) ahb_in21;

  `uvm_component_utils_begin(apb_subsystem_env21)
    `uvm_field_object(reg_model_ptr21, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create21 TLM ports21
    spi_csr_out21 = new("spi_csr_out21", this);
    gpio_csr_out21 = new("gpio_csr_out21", this);
    ahb_in21 = new("apb_in21", this);
    spi_csr21  = spi_pkg21::spi_csr21::type_id::create("spi_csr21", this) ;
    gpio_csr21 = gpio_pkg21::gpio_csr21::type_id::create("gpio_csr21", this) ;
  endfunction

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer21 transfer21);
  extern virtual function void write_effects21(ahb_transfer21 transfer21);
  extern virtual function void read_effects21(ahb_transfer21 transfer21);

endclass : apb_subsystem_env21

function void apb_subsystem_env21::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure21 the device21
  if (!uvm_config_db#(apb_subsystem_config21)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config21 creating21...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config21::get_type(),
                                     default_apb_subsystem_config21::get_type());
    cfg = apb_subsystem_config21::type_id::create("cfg");
  end
  // build system level monitor21
  monitor21 = apb_subsystem_monitor21::type_id::create("monitor21",this);
    apb_uart021  = uart_ctrl_pkg21::uart_ctrl_env21::type_id::create("apb_uart021",this);
    apb_uart121  = uart_ctrl_pkg21::uart_ctrl_env21::type_id::create("apb_uart121",this);
endfunction : build_phase
  
function void apb_subsystem_env21::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB21 transfers21 - handles21 Register Operations21
function void apb_subsystem_env21::write(ahb_transfer21 transfer21);
    if (transfer21.direction21 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer21.address, transfer21.data), UVM_MEDIUM)
      write_effects21(transfer21);
    end
    else if (transfer21.direction21 == READ) begin
      if ((transfer21.address >= `AM_SPI0_BASE_ADDRESS21) && (transfer21.address <= `AM_SPI0_END_ADDRESS21)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update21() with address = 'h%0h, data = 'h%0h", transfer21.address, transfer21.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM121", "Unsupported21 access!!!")
endfunction : write

// UVM_REG: Update CONFIG21 based on APB21 writes to config registers
function void apb_subsystem_env21::write_effects21(ahb_transfer21 transfer21);
    case (transfer21.address)
      `AM_SPI0_BASE_ADDRESS21 + `SPI_CTRL_REG21 : begin
                                                  spi_csr21.mode_select21        = 1'b1;
                                                  spi_csr21.tx_clk_phase21       = transfer21.data[10];
                                                  spi_csr21.rx_clk_phase21       = transfer21.data[9];
                                                  spi_csr21.transfer_data_size21 = transfer21.data[6:0];
                                                  spi_csr21.get_data_size_as_int21();
                                                  spi_csr21.Copycfg_struct21();
                                                  spi_csr_out21.write(spi_csr21);
      `uvm_info("USR_MONITOR21", $psprintf("SPI21 CSR21 is \n%s", spi_csr21.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS21 + `SPI_DIV_REG21  : begin
                                                  spi_csr21.baud_rate_divisor21  = transfer21.data[15:0];
                                                  spi_csr21.Copycfg_struct21();
                                                  spi_csr_out21.write(spi_csr21);
                                                end
      `AM_SPI0_BASE_ADDRESS21 + `SPI_SS_REG21   : begin
                                                  spi_csr21.n_ss_out21           = transfer21.data[7:0];
                                                  spi_csr21.Copycfg_struct21();
                                                  spi_csr_out21.write(spi_csr21);
                                                end
      `AM_GPIO0_BASE_ADDRESS21 + `GPIO_BYPASS_MODE_REG21 : begin
                                                  gpio_csr21.bypass_mode21       = transfer21.data[0];
                                                  gpio_csr21.Copycfg_struct21();
                                                  gpio_csr_out21.write(gpio_csr21);
                                                end
      `AM_GPIO0_BASE_ADDRESS21 + `GPIO_DIRECTION_MODE_REG21 : begin
                                                  gpio_csr21.direction_mode21    = transfer21.data[0];
                                                  gpio_csr21.Copycfg_struct21();
                                                  gpio_csr_out21.write(gpio_csr21);
                                                end
      `AM_GPIO0_BASE_ADDRESS21 + `GPIO_OUTPUT_ENABLE_REG21 : begin
                                                  gpio_csr21.output_enable21     = transfer21.data[0];
                                                  gpio_csr21.Copycfg_struct21();
                                                  gpio_csr_out21.write(gpio_csr21);
                                                end
      default: `uvm_info("USR_MONITOR21", $psprintf("Write access not to Control21/Sataus21 Registers21"), UVM_HIGH)
    endcase
endfunction : write_effects21

function void apb_subsystem_env21::read_effects21(ahb_transfer21 transfer21);
  // Nothing for now
endfunction : read_effects21


