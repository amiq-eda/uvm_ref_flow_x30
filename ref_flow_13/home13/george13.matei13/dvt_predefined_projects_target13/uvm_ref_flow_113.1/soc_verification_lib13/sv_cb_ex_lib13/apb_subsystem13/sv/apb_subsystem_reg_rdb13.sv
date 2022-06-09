/*---------------------------------------------------------------------
File13 name   : apb_subsystem_reg_rdb13.sv
Title13       : Reg13 Mem13 data base
Project13     :
Created13     :
Description13 : reg data base for APB13 Subsystem13
Notes13       :
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map13 definition13
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c13 extends uvm_reg_block;

  //rand uart_ctrl_rf_c13 uart0_rf13;
  //rand uart_ctrl_rf_c13 uart1_rf13;
  rand uart_ctrl_reg_model_c13 uart0_rm13;
  rand uart_ctrl_reg_model_c13 uart1_rm13;
  rand spi_regfile13 spi_rf13;
  rand gpio_regfile13 gpio_rf13;

  function void build();
    // Now13 define address mappings13
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf13 = uart_ctrl_rf_c13::type_id::create("uart0_rf13", , get_full_name());
    uart0_rf13.configure(this, "rf013");
    uart0_rf13.build();
    uart0_rf13.lock_model();
    default_map.add_submap(uart0_rf13.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model13");
    uart1_rf13 = uart_ctrl_rf_c13::type_id::create("uart1_rf13", , get_full_name());
    uart1_rf13.configure(this, "rf113");
    uart1_rf13.build();
    uart1_rf13.lock_model();
    default_map.add_submap(uart1_rf13.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm13 = uart_ctrl_reg_model_c13::type_id::create("uart0_rm13", , get_full_name());
    uart0_rm13.configure(this, "rf013");
    uart0_rm13.build();
    uart0_rm13.lock_model();
    default_map.add_submap(uart0_rm13.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model13");
    uart1_rm13 = uart_ctrl_reg_model_c13::type_id::create("uart1_rm13", , get_full_name());
    uart1_rm13.configure(this, "rf113");
    uart1_rm13.build();
    uart1_rm13.lock_model();
    default_map.add_submap(uart1_rm13.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model113");

    spi_rf13 = spi_regfile13::type_id::create("spi_rf13", , get_full_name());
    spi_rf13.configure(this, "rf213");
    spi_rf13.build();
    spi_rf13.lock_model();
    default_map.add_submap(spi_rf13.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c13");
    gpio_rf13 = gpio_regfile13::type_id::create("gpio_rf13", , get_full_name());
    gpio_rf13.configure(this, "rf313");
    gpio_rf13.build();
    gpio_rf13.lock_model();
    default_map.add_submap(gpio_rf13.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c13");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c13)

  function new(input string name="unnamed13-apb_ss_reg_model_c13");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c13

