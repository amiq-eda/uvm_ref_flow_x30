/*---------------------------------------------------------------------
File30 name   : apb_subsystem_reg_rdb30.sv
Title30       : Reg30 Mem30 data base
Project30     :
Created30     :
Description30 : reg data base for APB30 Subsystem30
Notes30       :
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map30 definition30
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c30 extends uvm_reg_block;

  //rand uart_ctrl_rf_c30 uart0_rf30;
  //rand uart_ctrl_rf_c30 uart1_rf30;
  rand uart_ctrl_reg_model_c30 uart0_rm30;
  rand uart_ctrl_reg_model_c30 uart1_rm30;
  rand spi_regfile30 spi_rf30;
  rand gpio_regfile30 gpio_rf30;

  function void build();
    // Now30 define address mappings30
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf30 = uart_ctrl_rf_c30::type_id::create("uart0_rf30", , get_full_name());
    uart0_rf30.configure(this, "rf030");
    uart0_rf30.build();
    uart0_rf30.lock_model();
    default_map.add_submap(uart0_rf30.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model30");
    uart1_rf30 = uart_ctrl_rf_c30::type_id::create("uart1_rf30", , get_full_name());
    uart1_rf30.configure(this, "rf130");
    uart1_rf30.build();
    uart1_rf30.lock_model();
    default_map.add_submap(uart1_rf30.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm30 = uart_ctrl_reg_model_c30::type_id::create("uart0_rm30", , get_full_name());
    uart0_rm30.configure(this, "rf030");
    uart0_rm30.build();
    uart0_rm30.lock_model();
    default_map.add_submap(uart0_rm30.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model30");
    uart1_rm30 = uart_ctrl_reg_model_c30::type_id::create("uart1_rm30", , get_full_name());
    uart1_rm30.configure(this, "rf130");
    uart1_rm30.build();
    uart1_rm30.lock_model();
    default_map.add_submap(uart1_rm30.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model130");

    spi_rf30 = spi_regfile30::type_id::create("spi_rf30", , get_full_name());
    spi_rf30.configure(this, "rf230");
    spi_rf30.build();
    spi_rf30.lock_model();
    default_map.add_submap(spi_rf30.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c30");
    gpio_rf30 = gpio_regfile30::type_id::create("gpio_rf30", , get_full_name());
    gpio_rf30.configure(this, "rf330");
    gpio_rf30.build();
    gpio_rf30.lock_model();
    default_map.add_submap(gpio_rf30.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c30");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c30)

  function new(input string name="unnamed30-apb_ss_reg_model_c30");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c30

