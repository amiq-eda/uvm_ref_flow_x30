/*---------------------------------------------------------------------
File14 name   : apb_subsystem_reg_rdb14.sv
Title14       : Reg14 Mem14 data base
Project14     :
Created14     :
Description14 : reg data base for APB14 Subsystem14
Notes14       :
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map14 definition14
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c14 extends uvm_reg_block;

  //rand uart_ctrl_rf_c14 uart0_rf14;
  //rand uart_ctrl_rf_c14 uart1_rf14;
  rand uart_ctrl_reg_model_c14 uart0_rm14;
  rand uart_ctrl_reg_model_c14 uart1_rm14;
  rand spi_regfile14 spi_rf14;
  rand gpio_regfile14 gpio_rf14;

  function void build();
    // Now14 define address mappings14
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf14 = uart_ctrl_rf_c14::type_id::create("uart0_rf14", , get_full_name());
    uart0_rf14.configure(this, "rf014");
    uart0_rf14.build();
    uart0_rf14.lock_model();
    default_map.add_submap(uart0_rf14.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model14");
    uart1_rf14 = uart_ctrl_rf_c14::type_id::create("uart1_rf14", , get_full_name());
    uart1_rf14.configure(this, "rf114");
    uart1_rf14.build();
    uart1_rf14.lock_model();
    default_map.add_submap(uart1_rf14.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm14 = uart_ctrl_reg_model_c14::type_id::create("uart0_rm14", , get_full_name());
    uart0_rm14.configure(this, "rf014");
    uart0_rm14.build();
    uart0_rm14.lock_model();
    default_map.add_submap(uart0_rm14.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model14");
    uart1_rm14 = uart_ctrl_reg_model_c14::type_id::create("uart1_rm14", , get_full_name());
    uart1_rm14.configure(this, "rf114");
    uart1_rm14.build();
    uart1_rm14.lock_model();
    default_map.add_submap(uart1_rm14.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model114");

    spi_rf14 = spi_regfile14::type_id::create("spi_rf14", , get_full_name());
    spi_rf14.configure(this, "rf214");
    spi_rf14.build();
    spi_rf14.lock_model();
    default_map.add_submap(spi_rf14.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c14");
    gpio_rf14 = gpio_regfile14::type_id::create("gpio_rf14", , get_full_name());
    gpio_rf14.configure(this, "rf314");
    gpio_rf14.build();
    gpio_rf14.lock_model();
    default_map.add_submap(gpio_rf14.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c14");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c14)

  function new(input string name="unnamed14-apb_ss_reg_model_c14");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c14

