/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_env5.sv
Title5       : 
Project5     :
Created5     :
Description5 : Module5 env5, contains5 the instance of scoreboard5 and coverage5 model
Notes5       : 
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines5.svh"
class apb_subsystem_env5 extends uvm_env; 
  
  // Component configuration classes5
  apb_subsystem_config5 cfg;
  // These5 are pointers5 to config classes5 above5
  spi_pkg5::spi_csr5 spi_csr5;
  gpio_pkg5::gpio_csr5 gpio_csr5;

  uart_ctrl_pkg5::uart_ctrl_env5 apb_uart05; //block level module UVC5 reused5 - contains5 monitors5, scoreboard5, coverage5.
  uart_ctrl_pkg5::uart_ctrl_env5 apb_uart15; //block level module UVC5 reused5 - contains5 monitors5, scoreboard5, coverage5.
  
  // Module5 monitor5 (includes5 scoreboards5, coverage5, checking)
  apb_subsystem_monitor5 monitor5;

  // Pointer5 to the Register Database5 address map
  uvm_reg_block reg_model_ptr5;
   
  // TLM Connections5 
  uvm_analysis_port #(spi_pkg5::spi_csr5) spi_csr_out5;
  uvm_analysis_port #(gpio_pkg5::gpio_csr5) gpio_csr_out5;
  uvm_analysis_imp #(ahb_transfer5, apb_subsystem_env5) ahb_in5;

  `uvm_component_utils_begin(apb_subsystem_env5)
    `uvm_field_object(reg_model_ptr5, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create5 TLM ports5
    spi_csr_out5 = new("spi_csr_out5", this);
    gpio_csr_out5 = new("gpio_csr_out5", this);
    ahb_in5 = new("apb_in5", this);
    spi_csr5  = spi_pkg5::spi_csr5::type_id::create("spi_csr5", this) ;
    gpio_csr5 = gpio_pkg5::gpio_csr5::type_id::create("gpio_csr5", this) ;
  endfunction

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer5 transfer5);
  extern virtual function void write_effects5(ahb_transfer5 transfer5);
  extern virtual function void read_effects5(ahb_transfer5 transfer5);

endclass : apb_subsystem_env5

function void apb_subsystem_env5::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure5 the device5
  if (!uvm_config_db#(apb_subsystem_config5)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config5 creating5...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config5::get_type(),
                                     default_apb_subsystem_config5::get_type());
    cfg = apb_subsystem_config5::type_id::create("cfg");
  end
  // build system level monitor5
  monitor5 = apb_subsystem_monitor5::type_id::create("monitor5",this);
    apb_uart05  = uart_ctrl_pkg5::uart_ctrl_env5::type_id::create("apb_uart05",this);
    apb_uart15  = uart_ctrl_pkg5::uart_ctrl_env5::type_id::create("apb_uart15",this);
endfunction : build_phase
  
function void apb_subsystem_env5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB5 transfers5 - handles5 Register Operations5
function void apb_subsystem_env5::write(ahb_transfer5 transfer5);
    if (transfer5.direction5 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer5.address, transfer5.data), UVM_MEDIUM)
      write_effects5(transfer5);
    end
    else if (transfer5.direction5 == READ) begin
      if ((transfer5.address >= `AM_SPI0_BASE_ADDRESS5) && (transfer5.address <= `AM_SPI0_END_ADDRESS5)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update5() with address = 'h%0h, data = 'h%0h", transfer5.address, transfer5.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM15", "Unsupported5 access!!!")
endfunction : write

// UVM_REG: Update CONFIG5 based on APB5 writes to config registers
function void apb_subsystem_env5::write_effects5(ahb_transfer5 transfer5);
    case (transfer5.address)
      `AM_SPI0_BASE_ADDRESS5 + `SPI_CTRL_REG5 : begin
                                                  spi_csr5.mode_select5        = 1'b1;
                                                  spi_csr5.tx_clk_phase5       = transfer5.data[10];
                                                  spi_csr5.rx_clk_phase5       = transfer5.data[9];
                                                  spi_csr5.transfer_data_size5 = transfer5.data[6:0];
                                                  spi_csr5.get_data_size_as_int5();
                                                  spi_csr5.Copycfg_struct5();
                                                  spi_csr_out5.write(spi_csr5);
      `uvm_info("USR_MONITOR5", $psprintf("SPI5 CSR5 is \n%s", spi_csr5.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS5 + `SPI_DIV_REG5  : begin
                                                  spi_csr5.baud_rate_divisor5  = transfer5.data[15:0];
                                                  spi_csr5.Copycfg_struct5();
                                                  spi_csr_out5.write(spi_csr5);
                                                end
      `AM_SPI0_BASE_ADDRESS5 + `SPI_SS_REG5   : begin
                                                  spi_csr5.n_ss_out5           = transfer5.data[7:0];
                                                  spi_csr5.Copycfg_struct5();
                                                  spi_csr_out5.write(spi_csr5);
                                                end
      `AM_GPIO0_BASE_ADDRESS5 + `GPIO_BYPASS_MODE_REG5 : begin
                                                  gpio_csr5.bypass_mode5       = transfer5.data[0];
                                                  gpio_csr5.Copycfg_struct5();
                                                  gpio_csr_out5.write(gpio_csr5);
                                                end
      `AM_GPIO0_BASE_ADDRESS5 + `GPIO_DIRECTION_MODE_REG5 : begin
                                                  gpio_csr5.direction_mode5    = transfer5.data[0];
                                                  gpio_csr5.Copycfg_struct5();
                                                  gpio_csr_out5.write(gpio_csr5);
                                                end
      `AM_GPIO0_BASE_ADDRESS5 + `GPIO_OUTPUT_ENABLE_REG5 : begin
                                                  gpio_csr5.output_enable5     = transfer5.data[0];
                                                  gpio_csr5.Copycfg_struct5();
                                                  gpio_csr_out5.write(gpio_csr5);
                                                end
      default: `uvm_info("USR_MONITOR5", $psprintf("Write access not to Control5/Sataus5 Registers5"), UVM_HIGH)
    endcase
endfunction : write_effects5

function void apb_subsystem_env5::read_effects5(ahb_transfer5 transfer5);
  // Nothing for now
endfunction : read_effects5


