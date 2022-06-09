/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_env2.sv
Title2       : 
Project2     :
Created2     :
Description2 : Module2 env2, contains2 the instance of scoreboard2 and coverage2 model
Notes2       : 
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines2.svh"
class apb_subsystem_env2 extends uvm_env; 
  
  // Component configuration classes2
  apb_subsystem_config2 cfg;
  // These2 are pointers2 to config classes2 above2
  spi_pkg2::spi_csr2 spi_csr2;
  gpio_pkg2::gpio_csr2 gpio_csr2;

  uart_ctrl_pkg2::uart_ctrl_env2 apb_uart02; //block level module UVC2 reused2 - contains2 monitors2, scoreboard2, coverage2.
  uart_ctrl_pkg2::uart_ctrl_env2 apb_uart12; //block level module UVC2 reused2 - contains2 monitors2, scoreboard2, coverage2.
  
  // Module2 monitor2 (includes2 scoreboards2, coverage2, checking)
  apb_subsystem_monitor2 monitor2;

  // Pointer2 to the Register Database2 address map
  uvm_reg_block reg_model_ptr2;
   
  // TLM Connections2 
  uvm_analysis_port #(spi_pkg2::spi_csr2) spi_csr_out2;
  uvm_analysis_port #(gpio_pkg2::gpio_csr2) gpio_csr_out2;
  uvm_analysis_imp #(ahb_transfer2, apb_subsystem_env2) ahb_in2;

  `uvm_component_utils_begin(apb_subsystem_env2)
    `uvm_field_object(reg_model_ptr2, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create2 TLM ports2
    spi_csr_out2 = new("spi_csr_out2", this);
    gpio_csr_out2 = new("gpio_csr_out2", this);
    ahb_in2 = new("apb_in2", this);
    spi_csr2  = spi_pkg2::spi_csr2::type_id::create("spi_csr2", this) ;
    gpio_csr2 = gpio_pkg2::gpio_csr2::type_id::create("gpio_csr2", this) ;
  endfunction

  // Additional2 class methods2
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer2 transfer2);
  extern virtual function void write_effects2(ahb_transfer2 transfer2);
  extern virtual function void read_effects2(ahb_transfer2 transfer2);

endclass : apb_subsystem_env2

function void apb_subsystem_env2::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure2 the device2
  if (!uvm_config_db#(apb_subsystem_config2)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config2 creating2...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config2::get_type(),
                                     default_apb_subsystem_config2::get_type());
    cfg = apb_subsystem_config2::type_id::create("cfg");
  end
  // build system level monitor2
  monitor2 = apb_subsystem_monitor2::type_id::create("monitor2",this);
    apb_uart02  = uart_ctrl_pkg2::uart_ctrl_env2::type_id::create("apb_uart02",this);
    apb_uart12  = uart_ctrl_pkg2::uart_ctrl_env2::type_id::create("apb_uart12",this);
endfunction : build_phase
  
function void apb_subsystem_env2::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB2 transfers2 - handles2 Register Operations2
function void apb_subsystem_env2::write(ahb_transfer2 transfer2);
    if (transfer2.direction2 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer2.address, transfer2.data), UVM_MEDIUM)
      write_effects2(transfer2);
    end
    else if (transfer2.direction2 == READ) begin
      if ((transfer2.address >= `AM_SPI0_BASE_ADDRESS2) && (transfer2.address <= `AM_SPI0_END_ADDRESS2)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update2() with address = 'h%0h, data = 'h%0h", transfer2.address, transfer2.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM12", "Unsupported2 access!!!")
endfunction : write

// UVM_REG: Update CONFIG2 based on APB2 writes to config registers
function void apb_subsystem_env2::write_effects2(ahb_transfer2 transfer2);
    case (transfer2.address)
      `AM_SPI0_BASE_ADDRESS2 + `SPI_CTRL_REG2 : begin
                                                  spi_csr2.mode_select2        = 1'b1;
                                                  spi_csr2.tx_clk_phase2       = transfer2.data[10];
                                                  spi_csr2.rx_clk_phase2       = transfer2.data[9];
                                                  spi_csr2.transfer_data_size2 = transfer2.data[6:0];
                                                  spi_csr2.get_data_size_as_int2();
                                                  spi_csr2.Copycfg_struct2();
                                                  spi_csr_out2.write(spi_csr2);
      `uvm_info("USR_MONITOR2", $psprintf("SPI2 CSR2 is \n%s", spi_csr2.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS2 + `SPI_DIV_REG2  : begin
                                                  spi_csr2.baud_rate_divisor2  = transfer2.data[15:0];
                                                  spi_csr2.Copycfg_struct2();
                                                  spi_csr_out2.write(spi_csr2);
                                                end
      `AM_SPI0_BASE_ADDRESS2 + `SPI_SS_REG2   : begin
                                                  spi_csr2.n_ss_out2           = transfer2.data[7:0];
                                                  spi_csr2.Copycfg_struct2();
                                                  spi_csr_out2.write(spi_csr2);
                                                end
      `AM_GPIO0_BASE_ADDRESS2 + `GPIO_BYPASS_MODE_REG2 : begin
                                                  gpio_csr2.bypass_mode2       = transfer2.data[0];
                                                  gpio_csr2.Copycfg_struct2();
                                                  gpio_csr_out2.write(gpio_csr2);
                                                end
      `AM_GPIO0_BASE_ADDRESS2 + `GPIO_DIRECTION_MODE_REG2 : begin
                                                  gpio_csr2.direction_mode2    = transfer2.data[0];
                                                  gpio_csr2.Copycfg_struct2();
                                                  gpio_csr_out2.write(gpio_csr2);
                                                end
      `AM_GPIO0_BASE_ADDRESS2 + `GPIO_OUTPUT_ENABLE_REG2 : begin
                                                  gpio_csr2.output_enable2     = transfer2.data[0];
                                                  gpio_csr2.Copycfg_struct2();
                                                  gpio_csr_out2.write(gpio_csr2);
                                                end
      default: `uvm_info("USR_MONITOR2", $psprintf("Write access not to Control2/Sataus2 Registers2"), UVM_HIGH)
    endcase
endfunction : write_effects2

function void apb_subsystem_env2::read_effects2(ahb_transfer2 transfer2);
  // Nothing for now
endfunction : read_effects2


