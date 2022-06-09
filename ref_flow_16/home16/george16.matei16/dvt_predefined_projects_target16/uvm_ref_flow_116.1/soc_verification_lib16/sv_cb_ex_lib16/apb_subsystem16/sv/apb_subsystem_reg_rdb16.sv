/*---------------------------------------------------------------------
File16 name   : apb_subsystem_reg_rdb16.sv
Title16       : Reg16 Mem16 data base
Project16     :
Created16     :
Description16 : reg data base for APB16 Subsystem16
Notes16       :
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map16 definition16
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c16 extends uvm_reg_block;

  //rand uart_ctrl_rf_c16 uart0_rf16;
  //rand uart_ctrl_rf_c16 uart1_rf16;
  rand uart_ctrl_reg_model_c16 uart0_rm16;
  rand uart_ctrl_reg_model_c16 uart1_rm16;
  rand spi_regfile16 spi_rf16;
  rand gpio_regfile16 gpio_rf16;

  function void build();
    // Now16 define address mappings16
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf16 = uart_ctrl_rf_c16::type_id::create("uart0_rf16", , get_full_name());
    uart0_rf16.configure(this, "rf016");
    uart0_rf16.build();
    uart0_rf16.lock_model();
    default_map.add_submap(uart0_rf16.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model16");
    uart1_rf16 = uart_ctrl_rf_c16::type_id::create("uart1_rf16", , get_full_name());
    uart1_rf16.configure(this, "rf116");
    uart1_rf16.build();
    uart1_rf16.lock_model();
    default_map.add_submap(uart1_rf16.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm16 = uart_ctrl_reg_model_c16::type_id::create("uart0_rm16", , get_full_name());
    uart0_rm16.configure(this, "rf016");
    uart0_rm16.build();
    uart0_rm16.lock_model();
    default_map.add_submap(uart0_rm16.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model16");
    uart1_rm16 = uart_ctrl_reg_model_c16::type_id::create("uart1_rm16", , get_full_name());
    uart1_rm16.configure(this, "rf116");
    uart1_rm16.build();
    uart1_rm16.lock_model();
    default_map.add_submap(uart1_rm16.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model116");

    spi_rf16 = spi_regfile16::type_id::create("spi_rf16", , get_full_name());
    spi_rf16.configure(this, "rf216");
    spi_rf16.build();
    spi_rf16.lock_model();
    default_map.add_submap(spi_rf16.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c16");
    gpio_rf16 = gpio_regfile16::type_id::create("gpio_rf16", , get_full_name());
    gpio_rf16.configure(this, "rf316");
    gpio_rf16.build();
    gpio_rf16.lock_model();
    default_map.add_submap(gpio_rf16.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c16");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c16)

  function new(input string name="unnamed16-apb_ss_reg_model_c16");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c16

