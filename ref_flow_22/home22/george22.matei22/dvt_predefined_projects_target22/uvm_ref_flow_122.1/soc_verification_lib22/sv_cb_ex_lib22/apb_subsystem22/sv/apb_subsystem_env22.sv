/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_env22.sv
Title22       : 
Project22     :
Created22     :
Description22 : Module22 env22, contains22 the instance of scoreboard22 and coverage22 model
Notes22       : 
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines22.svh"
class apb_subsystem_env22 extends uvm_env; 
  
  // Component configuration classes22
  apb_subsystem_config22 cfg;
  // These22 are pointers22 to config classes22 above22
  spi_pkg22::spi_csr22 spi_csr22;
  gpio_pkg22::gpio_csr22 gpio_csr22;

  uart_ctrl_pkg22::uart_ctrl_env22 apb_uart022; //block level module UVC22 reused22 - contains22 monitors22, scoreboard22, coverage22.
  uart_ctrl_pkg22::uart_ctrl_env22 apb_uart122; //block level module UVC22 reused22 - contains22 monitors22, scoreboard22, coverage22.
  
  // Module22 monitor22 (includes22 scoreboards22, coverage22, checking)
  apb_subsystem_monitor22 monitor22;

  // Pointer22 to the Register Database22 address map
  uvm_reg_block reg_model_ptr22;
   
  // TLM Connections22 
  uvm_analysis_port #(spi_pkg22::spi_csr22) spi_csr_out22;
  uvm_analysis_port #(gpio_pkg22::gpio_csr22) gpio_csr_out22;
  uvm_analysis_imp #(ahb_transfer22, apb_subsystem_env22) ahb_in22;

  `uvm_component_utils_begin(apb_subsystem_env22)
    `uvm_field_object(reg_model_ptr22, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create22 TLM ports22
    spi_csr_out22 = new("spi_csr_out22", this);
    gpio_csr_out22 = new("gpio_csr_out22", this);
    ahb_in22 = new("apb_in22", this);
    spi_csr22  = spi_pkg22::spi_csr22::type_id::create("spi_csr22", this) ;
    gpio_csr22 = gpio_pkg22::gpio_csr22::type_id::create("gpio_csr22", this) ;
  endfunction

  // Additional22 class methods22
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer22 transfer22);
  extern virtual function void write_effects22(ahb_transfer22 transfer22);
  extern virtual function void read_effects22(ahb_transfer22 transfer22);

endclass : apb_subsystem_env22

function void apb_subsystem_env22::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure22 the device22
  if (!uvm_config_db#(apb_subsystem_config22)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config22 creating22...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config22::get_type(),
                                     default_apb_subsystem_config22::get_type());
    cfg = apb_subsystem_config22::type_id::create("cfg");
  end
  // build system level monitor22
  monitor22 = apb_subsystem_monitor22::type_id::create("monitor22",this);
    apb_uart022  = uart_ctrl_pkg22::uart_ctrl_env22::type_id::create("apb_uart022",this);
    apb_uart122  = uart_ctrl_pkg22::uart_ctrl_env22::type_id::create("apb_uart122",this);
endfunction : build_phase
  
function void apb_subsystem_env22::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB22 transfers22 - handles22 Register Operations22
function void apb_subsystem_env22::write(ahb_transfer22 transfer22);
    if (transfer22.direction22 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer22.address, transfer22.data), UVM_MEDIUM)
      write_effects22(transfer22);
    end
    else if (transfer22.direction22 == READ) begin
      if ((transfer22.address >= `AM_SPI0_BASE_ADDRESS22) && (transfer22.address <= `AM_SPI0_END_ADDRESS22)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update22() with address = 'h%0h, data = 'h%0h", transfer22.address, transfer22.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM122", "Unsupported22 access!!!")
endfunction : write

// UVM_REG: Update CONFIG22 based on APB22 writes to config registers
function void apb_subsystem_env22::write_effects22(ahb_transfer22 transfer22);
    case (transfer22.address)
      `AM_SPI0_BASE_ADDRESS22 + `SPI_CTRL_REG22 : begin
                                                  spi_csr22.mode_select22        = 1'b1;
                                                  spi_csr22.tx_clk_phase22       = transfer22.data[10];
                                                  spi_csr22.rx_clk_phase22       = transfer22.data[9];
                                                  spi_csr22.transfer_data_size22 = transfer22.data[6:0];
                                                  spi_csr22.get_data_size_as_int22();
                                                  spi_csr22.Copycfg_struct22();
                                                  spi_csr_out22.write(spi_csr22);
      `uvm_info("USR_MONITOR22", $psprintf("SPI22 CSR22 is \n%s", spi_csr22.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS22 + `SPI_DIV_REG22  : begin
                                                  spi_csr22.baud_rate_divisor22  = transfer22.data[15:0];
                                                  spi_csr22.Copycfg_struct22();
                                                  spi_csr_out22.write(spi_csr22);
                                                end
      `AM_SPI0_BASE_ADDRESS22 + `SPI_SS_REG22   : begin
                                                  spi_csr22.n_ss_out22           = transfer22.data[7:0];
                                                  spi_csr22.Copycfg_struct22();
                                                  spi_csr_out22.write(spi_csr22);
                                                end
      `AM_GPIO0_BASE_ADDRESS22 + `GPIO_BYPASS_MODE_REG22 : begin
                                                  gpio_csr22.bypass_mode22       = transfer22.data[0];
                                                  gpio_csr22.Copycfg_struct22();
                                                  gpio_csr_out22.write(gpio_csr22);
                                                end
      `AM_GPIO0_BASE_ADDRESS22 + `GPIO_DIRECTION_MODE_REG22 : begin
                                                  gpio_csr22.direction_mode22    = transfer22.data[0];
                                                  gpio_csr22.Copycfg_struct22();
                                                  gpio_csr_out22.write(gpio_csr22);
                                                end
      `AM_GPIO0_BASE_ADDRESS22 + `GPIO_OUTPUT_ENABLE_REG22 : begin
                                                  gpio_csr22.output_enable22     = transfer22.data[0];
                                                  gpio_csr22.Copycfg_struct22();
                                                  gpio_csr_out22.write(gpio_csr22);
                                                end
      default: `uvm_info("USR_MONITOR22", $psprintf("Write access not to Control22/Sataus22 Registers22"), UVM_HIGH)
    endcase
endfunction : write_effects22

function void apb_subsystem_env22::read_effects22(ahb_transfer22 transfer22);
  // Nothing for now
endfunction : read_effects22


