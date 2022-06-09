/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_env1.sv
Title1       : 
Project1     :
Created1     :
Description1 : Module1 env1, contains1 the instance of scoreboard1 and coverage1 model
Notes1       : 
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines1.svh"
class apb_subsystem_env1 extends uvm_env; 
  
  // Component configuration classes1
  apb_subsystem_config1 cfg;
  // These1 are pointers1 to config classes1 above1
  spi_pkg1::spi_csr1 spi_csr1;
  gpio_pkg1::gpio_csr1 gpio_csr1;

  uart_ctrl_pkg1::uart_ctrl_env1 apb_uart01; //block level module UVC1 reused1 - contains1 monitors1, scoreboard1, coverage1.
  uart_ctrl_pkg1::uart_ctrl_env1 apb_uart11; //block level module UVC1 reused1 - contains1 monitors1, scoreboard1, coverage1.
  
  // Module1 monitor1 (includes1 scoreboards1, coverage1, checking)
  apb_subsystem_monitor1 monitor1;

  // Pointer1 to the Register Database1 address map
  uvm_reg_block reg_model_ptr1;
   
  // TLM Connections1 
  uvm_analysis_port #(spi_pkg1::spi_csr1) spi_csr_out1;
  uvm_analysis_port #(gpio_pkg1::gpio_csr1) gpio_csr_out1;
  uvm_analysis_imp #(ahb_transfer1, apb_subsystem_env1) ahb_in1;

  `uvm_component_utils_begin(apb_subsystem_env1)
    `uvm_field_object(reg_model_ptr1, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create1 TLM ports1
    spi_csr_out1 = new("spi_csr_out1", this);
    gpio_csr_out1 = new("gpio_csr_out1", this);
    ahb_in1 = new("apb_in1", this);
    spi_csr1  = spi_pkg1::spi_csr1::type_id::create("spi_csr1", this) ;
    gpio_csr1 = gpio_pkg1::gpio_csr1::type_id::create("gpio_csr1", this) ;
  endfunction

  // Additional1 class methods1
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer1 transfer1);
  extern virtual function void write_effects1(ahb_transfer1 transfer1);
  extern virtual function void read_effects1(ahb_transfer1 transfer1);

endclass : apb_subsystem_env1

function void apb_subsystem_env1::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure1 the device1
  if (!uvm_config_db#(apb_subsystem_config1)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config1 creating1...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config1::get_type(),
                                     default_apb_subsystem_config1::get_type());
    cfg = apb_subsystem_config1::type_id::create("cfg");
  end
  // build system level monitor1
  monitor1 = apb_subsystem_monitor1::type_id::create("monitor1",this);
    apb_uart01  = uart_ctrl_pkg1::uart_ctrl_env1::type_id::create("apb_uart01",this);
    apb_uart11  = uart_ctrl_pkg1::uart_ctrl_env1::type_id::create("apb_uart11",this);
endfunction : build_phase
  
function void apb_subsystem_env1::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB1 transfers1 - handles1 Register Operations1
function void apb_subsystem_env1::write(ahb_transfer1 transfer1);
    if (transfer1.direction1 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer1.address, transfer1.data), UVM_MEDIUM)
      write_effects1(transfer1);
    end
    else if (transfer1.direction1 == READ) begin
      if ((transfer1.address >= `AM_SPI0_BASE_ADDRESS1) && (transfer1.address <= `AM_SPI0_END_ADDRESS1)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update1() with address = 'h%0h, data = 'h%0h", transfer1.address, transfer1.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM11", "Unsupported1 access!!!")
endfunction : write

// UVM_REG: Update CONFIG1 based on APB1 writes to config registers
function void apb_subsystem_env1::write_effects1(ahb_transfer1 transfer1);
    case (transfer1.address)
      `AM_SPI0_BASE_ADDRESS1 + `SPI_CTRL_REG1 : begin
                                                  spi_csr1.mode_select1        = 1'b1;
                                                  spi_csr1.tx_clk_phase1       = transfer1.data[10];
                                                  spi_csr1.rx_clk_phase1       = transfer1.data[9];
                                                  spi_csr1.transfer_data_size1 = transfer1.data[6:0];
                                                  spi_csr1.get_data_size_as_int1();
                                                  spi_csr1.Copycfg_struct1();
                                                  spi_csr_out1.write(spi_csr1);
      `uvm_info("USR_MONITOR1", $psprintf("SPI1 CSR1 is \n%s", spi_csr1.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS1 + `SPI_DIV_REG1  : begin
                                                  spi_csr1.baud_rate_divisor1  = transfer1.data[15:0];
                                                  spi_csr1.Copycfg_struct1();
                                                  spi_csr_out1.write(spi_csr1);
                                                end
      `AM_SPI0_BASE_ADDRESS1 + `SPI_SS_REG1   : begin
                                                  spi_csr1.n_ss_out1           = transfer1.data[7:0];
                                                  spi_csr1.Copycfg_struct1();
                                                  spi_csr_out1.write(spi_csr1);
                                                end
      `AM_GPIO0_BASE_ADDRESS1 + `GPIO_BYPASS_MODE_REG1 : begin
                                                  gpio_csr1.bypass_mode1       = transfer1.data[0];
                                                  gpio_csr1.Copycfg_struct1();
                                                  gpio_csr_out1.write(gpio_csr1);
                                                end
      `AM_GPIO0_BASE_ADDRESS1 + `GPIO_DIRECTION_MODE_REG1 : begin
                                                  gpio_csr1.direction_mode1    = transfer1.data[0];
                                                  gpio_csr1.Copycfg_struct1();
                                                  gpio_csr_out1.write(gpio_csr1);
                                                end
      `AM_GPIO0_BASE_ADDRESS1 + `GPIO_OUTPUT_ENABLE_REG1 : begin
                                                  gpio_csr1.output_enable1     = transfer1.data[0];
                                                  gpio_csr1.Copycfg_struct1();
                                                  gpio_csr_out1.write(gpio_csr1);
                                                end
      default: `uvm_info("USR_MONITOR1", $psprintf("Write access not to Control1/Sataus1 Registers1"), UVM_HIGH)
    endcase
endfunction : write_effects1

function void apb_subsystem_env1::read_effects1(ahb_transfer1 transfer1);
  // Nothing for now
endfunction : read_effects1


