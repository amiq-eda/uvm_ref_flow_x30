/*---------------------------------------------------------------------
File19 name   : apb_subsystem_reg_rdb19.sv
Title19       : Reg19 Mem19 data base
Project19     :
Created19     :
Description19 : reg data base for APB19 Subsystem19
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
 
//////////////////////////////////////////////////////////////////////////////
// Address_map19 definition19
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c19 extends uvm_reg_block;

  //rand uart_ctrl_rf_c19 uart0_rf19;
  //rand uart_ctrl_rf_c19 uart1_rf19;
  rand uart_ctrl_reg_model_c19 uart0_rm19;
  rand uart_ctrl_reg_model_c19 uart1_rm19;
  rand spi_regfile19 spi_rf19;
  rand gpio_regfile19 gpio_rf19;

  function void build();
    // Now19 define address mappings19
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf19 = uart_ctrl_rf_c19::type_id::create("uart0_rf19", , get_full_name());
    uart0_rf19.configure(this, "rf019");
    uart0_rf19.build();
    uart0_rf19.lock_model();
    default_map.add_submap(uart0_rf19.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model19");
    uart1_rf19 = uart_ctrl_rf_c19::type_id::create("uart1_rf19", , get_full_name());
    uart1_rf19.configure(this, "rf119");
    uart1_rf19.build();
    uart1_rf19.lock_model();
    default_map.add_submap(uart1_rf19.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm19 = uart_ctrl_reg_model_c19::type_id::create("uart0_rm19", , get_full_name());
    uart0_rm19.configure(this, "rf019");
    uart0_rm19.build();
    uart0_rm19.lock_model();
    default_map.add_submap(uart0_rm19.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model19");
    uart1_rm19 = uart_ctrl_reg_model_c19::type_id::create("uart1_rm19", , get_full_name());
    uart1_rm19.configure(this, "rf119");
    uart1_rm19.build();
    uart1_rm19.lock_model();
    default_map.add_submap(uart1_rm19.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model119");

    spi_rf19 = spi_regfile19::type_id::create("spi_rf19", , get_full_name());
    spi_rf19.configure(this, "rf219");
    spi_rf19.build();
    spi_rf19.lock_model();
    default_map.add_submap(spi_rf19.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c19");
    gpio_rf19 = gpio_regfile19::type_id::create("gpio_rf19", , get_full_name());
    gpio_rf19.configure(this, "rf319");
    gpio_rf19.build();
    gpio_rf19.lock_model();
    default_map.add_submap(gpio_rf19.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c19");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c19)

  function new(input string name="unnamed19-apb_ss_reg_model_c19");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c19

