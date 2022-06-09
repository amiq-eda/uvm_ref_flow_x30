/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_env12.sv
Title12       : 
Project12     :
Created12     :
Description12 : Module12 env12, contains12 the instance of scoreboard12 and coverage12 model
Notes12       : 
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines12.svh"
class apb_subsystem_env12 extends uvm_env; 
  
  // Component configuration classes12
  apb_subsystem_config12 cfg;
  // These12 are pointers12 to config classes12 above12
  spi_pkg12::spi_csr12 spi_csr12;
  gpio_pkg12::gpio_csr12 gpio_csr12;

  uart_ctrl_pkg12::uart_ctrl_env12 apb_uart012; //block level module UVC12 reused12 - contains12 monitors12, scoreboard12, coverage12.
  uart_ctrl_pkg12::uart_ctrl_env12 apb_uart112; //block level module UVC12 reused12 - contains12 monitors12, scoreboard12, coverage12.
  
  // Module12 monitor12 (includes12 scoreboards12, coverage12, checking)
  apb_subsystem_monitor12 monitor12;

  // Pointer12 to the Register Database12 address map
  uvm_reg_block reg_model_ptr12;
   
  // TLM Connections12 
  uvm_analysis_port #(spi_pkg12::spi_csr12) spi_csr_out12;
  uvm_analysis_port #(gpio_pkg12::gpio_csr12) gpio_csr_out12;
  uvm_analysis_imp #(ahb_transfer12, apb_subsystem_env12) ahb_in12;

  `uvm_component_utils_begin(apb_subsystem_env12)
    `uvm_field_object(reg_model_ptr12, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create12 TLM ports12
    spi_csr_out12 = new("spi_csr_out12", this);
    gpio_csr_out12 = new("gpio_csr_out12", this);
    ahb_in12 = new("apb_in12", this);
    spi_csr12  = spi_pkg12::spi_csr12::type_id::create("spi_csr12", this) ;
    gpio_csr12 = gpio_pkg12::gpio_csr12::type_id::create("gpio_csr12", this) ;
  endfunction

  // Additional12 class methods12
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer12 transfer12);
  extern virtual function void write_effects12(ahb_transfer12 transfer12);
  extern virtual function void read_effects12(ahb_transfer12 transfer12);

endclass : apb_subsystem_env12

function void apb_subsystem_env12::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure12 the device12
  if (!uvm_config_db#(apb_subsystem_config12)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config12 creating12...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config12::get_type(),
                                     default_apb_subsystem_config12::get_type());
    cfg = apb_subsystem_config12::type_id::create("cfg");
  end
  // build system level monitor12
  monitor12 = apb_subsystem_monitor12::type_id::create("monitor12",this);
    apb_uart012  = uart_ctrl_pkg12::uart_ctrl_env12::type_id::create("apb_uart012",this);
    apb_uart112  = uart_ctrl_pkg12::uart_ctrl_env12::type_id::create("apb_uart112",this);
endfunction : build_phase
  
function void apb_subsystem_env12::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB12 transfers12 - handles12 Register Operations12
function void apb_subsystem_env12::write(ahb_transfer12 transfer12);
    if (transfer12.direction12 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer12.address, transfer12.data), UVM_MEDIUM)
      write_effects12(transfer12);
    end
    else if (transfer12.direction12 == READ) begin
      if ((transfer12.address >= `AM_SPI0_BASE_ADDRESS12) && (transfer12.address <= `AM_SPI0_END_ADDRESS12)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update12() with address = 'h%0h, data = 'h%0h", transfer12.address, transfer12.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM112", "Unsupported12 access!!!")
endfunction : write

// UVM_REG: Update CONFIG12 based on APB12 writes to config registers
function void apb_subsystem_env12::write_effects12(ahb_transfer12 transfer12);
    case (transfer12.address)
      `AM_SPI0_BASE_ADDRESS12 + `SPI_CTRL_REG12 : begin
                                                  spi_csr12.mode_select12        = 1'b1;
                                                  spi_csr12.tx_clk_phase12       = transfer12.data[10];
                                                  spi_csr12.rx_clk_phase12       = transfer12.data[9];
                                                  spi_csr12.transfer_data_size12 = transfer12.data[6:0];
                                                  spi_csr12.get_data_size_as_int12();
                                                  spi_csr12.Copycfg_struct12();
                                                  spi_csr_out12.write(spi_csr12);
      `uvm_info("USR_MONITOR12", $psprintf("SPI12 CSR12 is \n%s", spi_csr12.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS12 + `SPI_DIV_REG12  : begin
                                                  spi_csr12.baud_rate_divisor12  = transfer12.data[15:0];
                                                  spi_csr12.Copycfg_struct12();
                                                  spi_csr_out12.write(spi_csr12);
                                                end
      `AM_SPI0_BASE_ADDRESS12 + `SPI_SS_REG12   : begin
                                                  spi_csr12.n_ss_out12           = transfer12.data[7:0];
                                                  spi_csr12.Copycfg_struct12();
                                                  spi_csr_out12.write(spi_csr12);
                                                end
      `AM_GPIO0_BASE_ADDRESS12 + `GPIO_BYPASS_MODE_REG12 : begin
                                                  gpio_csr12.bypass_mode12       = transfer12.data[0];
                                                  gpio_csr12.Copycfg_struct12();
                                                  gpio_csr_out12.write(gpio_csr12);
                                                end
      `AM_GPIO0_BASE_ADDRESS12 + `GPIO_DIRECTION_MODE_REG12 : begin
                                                  gpio_csr12.direction_mode12    = transfer12.data[0];
                                                  gpio_csr12.Copycfg_struct12();
                                                  gpio_csr_out12.write(gpio_csr12);
                                                end
      `AM_GPIO0_BASE_ADDRESS12 + `GPIO_OUTPUT_ENABLE_REG12 : begin
                                                  gpio_csr12.output_enable12     = transfer12.data[0];
                                                  gpio_csr12.Copycfg_struct12();
                                                  gpio_csr_out12.write(gpio_csr12);
                                                end
      default: `uvm_info("USR_MONITOR12", $psprintf("Write access not to Control12/Sataus12 Registers12"), UVM_HIGH)
    endcase
endfunction : write_effects12

function void apb_subsystem_env12::read_effects12(ahb_transfer12 transfer12);
  // Nothing for now
endfunction : read_effects12


