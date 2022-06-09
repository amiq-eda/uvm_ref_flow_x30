/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_env19.sv
Title19       : 
Project19     :
Created19     :
Description19 : Module19 env19, contains19 the instance of scoreboard19 and coverage19 model
Notes19       : 
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


//`include "apb_subsystem_defines19.svh"
class apb_subsystem_env19 extends uvm_env; 
  
  // Component configuration classes19
  apb_subsystem_config19 cfg;
  // These19 are pointers19 to config classes19 above19
  spi_pkg19::spi_csr19 spi_csr19;
  gpio_pkg19::gpio_csr19 gpio_csr19;

  uart_ctrl_pkg19::uart_ctrl_env19 apb_uart019; //block level module UVC19 reused19 - contains19 monitors19, scoreboard19, coverage19.
  uart_ctrl_pkg19::uart_ctrl_env19 apb_uart119; //block level module UVC19 reused19 - contains19 monitors19, scoreboard19, coverage19.
  
  // Module19 monitor19 (includes19 scoreboards19, coverage19, checking)
  apb_subsystem_monitor19 monitor19;

  // Pointer19 to the Register Database19 address map
  uvm_reg_block reg_model_ptr19;
   
  // TLM Connections19 
  uvm_analysis_port #(spi_pkg19::spi_csr19) spi_csr_out19;
  uvm_analysis_port #(gpio_pkg19::gpio_csr19) gpio_csr_out19;
  uvm_analysis_imp #(ahb_transfer19, apb_subsystem_env19) ahb_in19;

  `uvm_component_utils_begin(apb_subsystem_env19)
    `uvm_field_object(reg_model_ptr19, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(cfg, UVM_DEFAULT)
  `uvm_component_utils_end

  // constructor
  function new(input string name, input uvm_component parent=null);
    super.new(name,parent);
    // Create19 TLM ports19
    spi_csr_out19 = new("spi_csr_out19", this);
    gpio_csr_out19 = new("gpio_csr_out19", this);
    ahb_in19 = new("apb_in19", this);
    spi_csr19  = spi_pkg19::spi_csr19::type_id::create("spi_csr19", this) ;
    gpio_csr19 = gpio_pkg19::gpio_csr19::type_id::create("gpio_csr19", this) ;
  endfunction

  // Additional19 class methods19
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void write(ahb_transfer19 transfer19);
  extern virtual function void write_effects19(ahb_transfer19 transfer19);
  extern virtual function void read_effects19(ahb_transfer19 transfer19);

endclass : apb_subsystem_env19

function void apb_subsystem_env19::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configure19 the device19
  if (!uvm_config_db#(apb_subsystem_config19)::get(this, "", "cfg", cfg)) begin
    `uvm_info(get_type_name(),"No apb_subsystem_config19 creating19...", UVM_LOW)
    set_inst_override_by_type("cfg", apb_subsystem_config19::get_type(),
                                     default_apb_subsystem_config19::get_type());
    cfg = apb_subsystem_config19::type_id::create("cfg");
  end
  // build system level monitor19
  monitor19 = apb_subsystem_monitor19::type_id::create("monitor19",this);
    apb_uart019  = uart_ctrl_pkg19::uart_ctrl_env19::type_id::create("apb_uart019",this);
    apb_uart119  = uart_ctrl_pkg19::uart_ctrl_env19::type_id::create("apb_uart119",this);
endfunction : build_phase
  
function void apb_subsystem_env19::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

// UVM_REG: write method for APB19 transfers19 - handles19 Register Operations19
function void apb_subsystem_env19::write(ahb_transfer19 transfer19);
    if (transfer19.direction19 == WRITE) begin
      `uvm_info(get_type_name(),
          $psprintf("Write -- calling update() with address = 'h%0h, data = 'h%0h",
          transfer19.address, transfer19.data), UVM_MEDIUM)
      write_effects19(transfer19);
    end
    else if (transfer19.direction19 == READ) begin
      if ((transfer19.address >= `AM_SPI0_BASE_ADDRESS19) && (transfer19.address <= `AM_SPI0_END_ADDRESS19)) begin
        `uvm_info(get_type_name(), $psprintf("Read -- calling compare_and_update19() with address = 'h%0h, data = 'h%0h", transfer19.address, transfer19.data), UVM_MEDIUM)
      end
    end else
        `uvm_error("REGMEM119", "Unsupported19 access!!!")
endfunction : write

// UVM_REG: Update CONFIG19 based on APB19 writes to config registers
function void apb_subsystem_env19::write_effects19(ahb_transfer19 transfer19);
    case (transfer19.address)
      `AM_SPI0_BASE_ADDRESS19 + `SPI_CTRL_REG19 : begin
                                                  spi_csr19.mode_select19        = 1'b1;
                                                  spi_csr19.tx_clk_phase19       = transfer19.data[10];
                                                  spi_csr19.rx_clk_phase19       = transfer19.data[9];
                                                  spi_csr19.transfer_data_size19 = transfer19.data[6:0];
                                                  spi_csr19.get_data_size_as_int19();
                                                  spi_csr19.Copycfg_struct19();
                                                  spi_csr_out19.write(spi_csr19);
      `uvm_info("USR_MONITOR19", $psprintf("SPI19 CSR19 is \n%s", spi_csr19.sprint()), UVM_MEDIUM)
                                                end
      `AM_SPI0_BASE_ADDRESS19 + `SPI_DIV_REG19  : begin
                                                  spi_csr19.baud_rate_divisor19  = transfer19.data[15:0];
                                                  spi_csr19.Copycfg_struct19();
                                                  spi_csr_out19.write(spi_csr19);
                                                end
      `AM_SPI0_BASE_ADDRESS19 + `SPI_SS_REG19   : begin
                                                  spi_csr19.n_ss_out19           = transfer19.data[7:0];
                                                  spi_csr19.Copycfg_struct19();
                                                  spi_csr_out19.write(spi_csr19);
                                                end
      `AM_GPIO0_BASE_ADDRESS19 + `GPIO_BYPASS_MODE_REG19 : begin
                                                  gpio_csr19.bypass_mode19       = transfer19.data[0];
                                                  gpio_csr19.Copycfg_struct19();
                                                  gpio_csr_out19.write(gpio_csr19);
                                                end
      `AM_GPIO0_BASE_ADDRESS19 + `GPIO_DIRECTION_MODE_REG19 : begin
                                                  gpio_csr19.direction_mode19    = transfer19.data[0];
                                                  gpio_csr19.Copycfg_struct19();
                                                  gpio_csr_out19.write(gpio_csr19);
                                                end
      `AM_GPIO0_BASE_ADDRESS19 + `GPIO_OUTPUT_ENABLE_REG19 : begin
                                                  gpio_csr19.output_enable19     = transfer19.data[0];
                                                  gpio_csr19.Copycfg_struct19();
                                                  gpio_csr_out19.write(gpio_csr19);
                                                end
      default: `uvm_info("USR_MONITOR19", $psprintf("Write access not to Control19/Sataus19 Registers19"), UVM_HIGH)
    endcase
endfunction : write_effects19

function void apb_subsystem_env19::read_effects19(ahb_transfer19 transfer19);
  // Nothing for now
endfunction : read_effects19


