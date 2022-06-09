/*---------------------------------------------------------------------
File7 name   : apb_subsystem_reg_rdb7.sv
Title7       : Reg7 Mem7 data base
Project7     :
Created7     :
Description7 : reg data base for APB7 Subsystem7
Notes7       :
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map7 definition7
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c7 extends uvm_reg_block;

  //rand uart_ctrl_rf_c7 uart0_rf7;
  //rand uart_ctrl_rf_c7 uart1_rf7;
  rand uart_ctrl_reg_model_c7 uart0_rm7;
  rand uart_ctrl_reg_model_c7 uart1_rm7;
  rand spi_regfile7 spi_rf7;
  rand gpio_regfile7 gpio_rf7;

  function void build();
    // Now7 define address mappings7
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf7 = uart_ctrl_rf_c7::type_id::create("uart0_rf7", , get_full_name());
    uart0_rf7.configure(this, "rf07");
    uart0_rf7.build();
    uart0_rf7.lock_model();
    default_map.add_submap(uart0_rf7.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model7");
    uart1_rf7 = uart_ctrl_rf_c7::type_id::create("uart1_rf7", , get_full_name());
    uart1_rf7.configure(this, "rf17");
    uart1_rf7.build();
    uart1_rf7.lock_model();
    default_map.add_submap(uart1_rf7.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm7 = uart_ctrl_reg_model_c7::type_id::create("uart0_rm7", , get_full_name());
    uart0_rm7.configure(this, "rf07");
    uart0_rm7.build();
    uart0_rm7.lock_model();
    default_map.add_submap(uart0_rm7.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model7");
    uart1_rm7 = uart_ctrl_reg_model_c7::type_id::create("uart1_rm7", , get_full_name());
    uart1_rm7.configure(this, "rf17");
    uart1_rm7.build();
    uart1_rm7.lock_model();
    default_map.add_submap(uart1_rm7.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model17");

    spi_rf7 = spi_regfile7::type_id::create("spi_rf7", , get_full_name());
    spi_rf7.configure(this, "rf27");
    spi_rf7.build();
    spi_rf7.lock_model();
    default_map.add_submap(spi_rf7.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c7");
    gpio_rf7 = gpio_regfile7::type_id::create("gpio_rf7", , get_full_name());
    gpio_rf7.configure(this, "rf37");
    gpio_rf7.build();
    gpio_rf7.lock_model();
    default_map.add_submap(gpio_rf7.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c7");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c7)

  function new(input string name="unnamed7-apb_ss_reg_model_c7");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c7

