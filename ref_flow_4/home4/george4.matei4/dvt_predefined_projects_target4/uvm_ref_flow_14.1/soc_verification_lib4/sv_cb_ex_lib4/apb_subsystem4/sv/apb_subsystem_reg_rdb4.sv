/*---------------------------------------------------------------------
File4 name   : apb_subsystem_reg_rdb4.sv
Title4       : Reg4 Mem4 data base
Project4     :
Created4     :
Description4 : reg data base for APB4 Subsystem4
Notes4       :
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map4 definition4
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c4 extends uvm_reg_block;

  //rand uart_ctrl_rf_c4 uart0_rf4;
  //rand uart_ctrl_rf_c4 uart1_rf4;
  rand uart_ctrl_reg_model_c4 uart0_rm4;
  rand uart_ctrl_reg_model_c4 uart1_rm4;
  rand spi_regfile4 spi_rf4;
  rand gpio_regfile4 gpio_rf4;

  function void build();
    // Now4 define address mappings4
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf4 = uart_ctrl_rf_c4::type_id::create("uart0_rf4", , get_full_name());
    uart0_rf4.configure(this, "rf04");
    uart0_rf4.build();
    uart0_rf4.lock_model();
    default_map.add_submap(uart0_rf4.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model4");
    uart1_rf4 = uart_ctrl_rf_c4::type_id::create("uart1_rf4", , get_full_name());
    uart1_rf4.configure(this, "rf14");
    uart1_rf4.build();
    uart1_rf4.lock_model();
    default_map.add_submap(uart1_rf4.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm4 = uart_ctrl_reg_model_c4::type_id::create("uart0_rm4", , get_full_name());
    uart0_rm4.configure(this, "rf04");
    uart0_rm4.build();
    uart0_rm4.lock_model();
    default_map.add_submap(uart0_rm4.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model4");
    uart1_rm4 = uart_ctrl_reg_model_c4::type_id::create("uart1_rm4", , get_full_name());
    uart1_rm4.configure(this, "rf14");
    uart1_rm4.build();
    uart1_rm4.lock_model();
    default_map.add_submap(uart1_rm4.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model14");

    spi_rf4 = spi_regfile4::type_id::create("spi_rf4", , get_full_name());
    spi_rf4.configure(this, "rf24");
    spi_rf4.build();
    spi_rf4.lock_model();
    default_map.add_submap(spi_rf4.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c4");
    gpio_rf4 = gpio_regfile4::type_id::create("gpio_rf4", , get_full_name());
    gpio_rf4.configure(this, "rf34");
    gpio_rf4.build();
    gpio_rf4.lock_model();
    default_map.add_submap(gpio_rf4.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c4");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c4)

  function new(input string name="unnamed4-apb_ss_reg_model_c4");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c4

