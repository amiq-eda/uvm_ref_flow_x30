/*---------------------------------------------------------------------
File1 name   : apb_subsystem_reg_rdb1.sv
Title1       : Reg1 Mem1 data base
Project1     :
Created1     :
Description1 : reg data base for APB1 Subsystem1
Notes1       :
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
 
//////////////////////////////////////////////////////////////////////////////
// Address_map1 definition1
//////////////////////////////////////////////////////////////////////////////
class apb_ss_reg_model_c1 extends uvm_reg_block;

  //rand uart_ctrl_rf_c1 uart0_rf1;
  //rand uart_ctrl_rf_c1 uart1_rf1;
  rand uart_ctrl_reg_model_c1 uart0_rm1;
  rand uart_ctrl_reg_model_c1 uart1_rm1;
  rand spi_regfile1 spi_rf1;
  rand gpio_regfile1 gpio_rf1;

  function void build();
    // Now1 define address mappings1
/*
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rf1 = uart_ctrl_rf_c1::type_id::create("uart0_rf1", , get_full_name());
    uart0_rf1.configure(this, "rf01");
    uart0_rf1.build();
    uart0_rf1.lock_model();
    default_map.add_submap(uart0_rf1.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model1");
    uart1_rf1 = uart_ctrl_rf_c1::type_id::create("uart1_rf1", , get_full_name());
    uart1_rf1.configure(this, "rf11");
    uart1_rf1.build();
    uart1_rf1.lock_model();
    default_map.add_submap(uart1_rf1.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
*/
    default_map = create_map("default_map", 0, 1, UVM_LITTLE_ENDIAN);
    uart0_rm1 = uart_ctrl_reg_model_c1::type_id::create("uart0_rm1", , get_full_name());
    uart0_rm1.configure(this, "rf01");
    uart0_rm1.build();
    uart0_rm1.lock_model();
    default_map.add_submap(uart0_rm1.default_map, `UVM_REG_ADDR_WIDTH'h81_0000);
    set_hdl_path_root("reg_model1");
    uart1_rm1 = uart_ctrl_reg_model_c1::type_id::create("uart1_rm1", , get_full_name());
    uart1_rm1.configure(this, "rf11");
    uart1_rm1.build();
    uart1_rm1.lock_model();
    default_map.add_submap(uart1_rm1.default_map, `UVM_REG_ADDR_WIDTH'h88_0000);
    set_hdl_path_root("reg_model11");

    spi_rf1 = spi_regfile1::type_id::create("spi_rf1", , get_full_name());
    spi_rf1.configure(this, "rf21");
    spi_rf1.build();
    spi_rf1.lock_model();
    default_map.add_submap(spi_rf1.default_map, `UVM_REG_ADDR_WIDTH'h80_0000);
    set_hdl_path_root("apb_spi_addr_map_c1");
    gpio_rf1 = gpio_regfile1::type_id::create("gpio_rf1", , get_full_name());
    gpio_rf1.configure(this, "rf31");
    gpio_rf1.build();
    gpio_rf1.lock_model();
    default_map.add_submap(gpio_rf1.default_map, `UVM_REG_ADDR_WIDTH'h82_0000);
    set_hdl_path_root("apb_gpio_addr_map_c1");
    this.lock_model();
  endfunction

  `uvm_object_utils(apb_ss_reg_model_c1)

  function new(input string name="unnamed1-apb_ss_reg_model_c1");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

endclass : apb_ss_reg_model_c1

