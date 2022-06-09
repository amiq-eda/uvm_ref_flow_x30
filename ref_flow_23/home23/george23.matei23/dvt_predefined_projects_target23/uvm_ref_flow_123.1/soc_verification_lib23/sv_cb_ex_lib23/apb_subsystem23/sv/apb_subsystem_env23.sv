/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_env23.sv
Title23       : 
Project23     :
Created23     :
Description23 : Module23 env23, contains23 the instance of scoreboard23 and coverage23 model
Notes23       : 
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines23.svh"
class apb_subsystem_env23 extends uvm_env; 
  
  // Component configuration classes23
  apb_subsystem_config23 cfg;
  // These23 are pointers23 to config classes23 above23
  spi_pkg23::spi_csr23 spi_csr23;
  gpio_pkg23::gpio_csr23 gpio_csr23;

  uart_ctrl_pkg23::uart_ctrl_env23 apb_uart023; //block level module UVC23 reused23 - contains23 monitors23, scoreboard23, coverage23.
  uart_ctrl_pkg23::uart_ctrl_env23 apb_uart123; //block level module UVC23 reused23 - contains23 monitors23, scoreboard23, coverage23.
  
  // Module23 monitor23 (includes23 scoreboards23, coverage23, checking)
  apb_subsystem_monitor23 monitor23;

  // Pointer23 to the Register Database23 address map
  uvm_reg_block reg_model_ptr23;
   
  // TLM Connections23 
  uvm_analysis_port #(spi_pkg23::spi_csr23) spi_csr_out23;
  uvm_analysis_port #(gpio_pkg23::gpio_csr23) gpio_csr_out23;
  uvm_analysis_imp #(ahb_transfer23, apb_subsystem_env23) ahb_in23;

  `uvm_component_utils_begin(apb_subsystem_env23)
    `uvm_field_object(reg_model_ptr23, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create23 TLM ports23
    spi_csr_out23 = new("spi_csr_out23", this);
    gpio_csr_out23 = new("gpio_csr_out23", this);
    ahb_in23 = new("apb_in23", this);
    spi_csr23  = spi_pkg23::spi_csr23::type_id::create("spi_csr23", this) ;
    gpio_csr23 = gpio_pkg23::gpio_csr23::type_id::create("gpio_csr23", this) ;
  endfunction

  // Additional23 class methods23
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer23 transfer23);
  extern virtual function void write_effects23(ahb_transfer23 transfer23);
  extern virtual function void read_effects23(ahb_transfer23 transfer23);

endclass : apb_subsystem_env23

function void apb_subsystem_env23::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure23 the device23
  if (!uvm_config_db#(apb_subsystem_config23)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config23 creating23...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config23::get_type(),
                                     default_apb_subsystem_config23::get_type());
    cfg = apb_subsystem_config23::type_id::create("cfg");
  end
  // build system level monitor23
  monitor23 = apb_subsystem_monitor23::type_id::create("monitor23",this);
    apb_uart023  = uart_ctrl_pkg23::uart_ctrl_env23::type_id::create("apb_uart023",this);
    apb_uart123  = uart_ctrl_pkg23::uart_ctrl_env23::type_id::create("apb_uart123",this);
endfunction : build_phase
  
function void apb_subsystem_env23::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB23 transfers23 - handles23 Register Operations23
function void apb_subsystem_env23::write(ahb_transfer23 transfer23);
    if (transfer23.direction23 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer23.address, transfer23.data), UVM_MEDIUM)
      write_effects23(transfer23);
    end
    else if (transfer23.direction23 == READ) begin
      if ((transfer23.address >= `AM_SPI0_BASE_ADDRESS23) && (transfer23.address <= `AM_SPI0_END_ADDRESS23)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update23() with address = 'h%0h, data = 'h%0h", transfer23.address, transfer23.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM123", "Unsupported23 access!!!")
endfunction : write

// UVM_REG: Update CONFIG23 based on APB23 writes to config registers
function void apb_subsystem_env23::write_effects23(ahb_transfer23 transfer23);
    case (transfer23.address)
      `AM_SPI0_BASE_ADDRESS23 + `SPI_CTRL_REG23 : begin
                                                  spi_csr23.mode_select23        = 1'b1;
                                                  spi_csr23.tx_clk_phase23       = transfer23.data[10];
                                                  spi_csr23.rx_clk_phase23       = transfer23.data[9];
                                                  spi_csr23.transfer_data_size23 = transfer23.data[6:0];
                                                  spi_csr23.get_data_size_as_int23();
                                                  spi_csr23.Copycfg_struct23();
                                                  spi_csr_out23.write(spi_csr23);
      `uvm_info("USR_MONITOR23", $psprintf("SPI23 CSR23 is \n%s", spi_csr23.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS23 + `SPI_DIV_REG23  : begin
                                                  spi_csr23.baud_rate_divisor23  = transfer23.data[15:0];
                                                  spi_csr23.Copycfg_struct23();
                                                  spi_csr_out23.write(spi_csr23);
                                                end
      `AM_SPI0_BASE_ADDRESS23 + `SPI_SS_REG23   : begin
                                                  spi_csr23.n_ss_out23           = transfer23.data[7:0];
                                                  spi_csr23.Copycfg_struct23();
                                                  spi_csr_out23.write(spi_csr23);
                                                end
      `AM_GPIO0_BASE_ADDRESS23 + `GPIO_BYPASS_MODE_REG23 : begin
                                                  gpio_csr23.bypass_mode23       = transfer23.data[0];
                                                  gpio_csr23.Copycfg_struct23();
                                                  gpio_csr_out23.write(gpio_csr23);
                                                end
      `AM_GPIO0_BASE_ADDRESS23 + `GPIO_DIRECTION_MODE_REG23 : begin
                                                  gpio_csr23.direction_mode23    = transfer23.data[0];
                                                  gpio_csr23.Copycfg_struct23();
                                                  gpio_csr_out23.write(gpio_csr23);
                                                end
      `AM_GPIO0_BASE_ADDRESS23 + `GPIO_OUTPUT_ENABLE_REG23 : begin
                                                  gpio_csr23.output_enable23     = transfer23.data[0];
                                                  gpio_csr23.Copycfg_struct23();
                                                  gpio_csr_out23.write(gpio_csr23);
                                                end
      default: `uvm_info("USR_MONITOR23", $psprintf("Write access not to Control23/Sataus23 Registers23"), UVM_HIGH)
    endcase
endfunction : write_effects23

function void apb_subsystem_env23::read_effects23(ahb_transfer23 transfer23);
  // Nothing for now
endfunction : read_effects23


