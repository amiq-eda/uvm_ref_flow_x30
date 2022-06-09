/*-------------------------------------------------------------------------
File1 name   : uart_cover1.sv
Title1       : APB1<>UART1 coverage1 collection1
Project1     :
Created1     :
Description1 : Collects1 coverage1 around1 the UART1 DUT
            : 
----------------------------------------------------------------------
Copyright1 2007 (c) Cadence1 Design1 Systems1, Inc1. All Rights1 Reserved1.
----------------------------------------------------------------------*/

class uart_ctrl_cover1 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if1 vif1;
  uart_pkg1::uart_config1 uart_cfg1;

  event tx_fifo_ptr_change1;
  event rx_fifo_ptr_change1;


  // Required1 macro1 for UVM automation1 and utilities1
  `uvm_component_utils(uart_ctrl_cover1)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage1();
      collect_rx_coverage1();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if1)::get(this, get_full_name(),"vif1", vif1))
      `uvm_fatal("NOVIF1",{"virtual interface must be set for: ",get_full_name(),".vif1"})
  endfunction : connect_phase

  virtual task collect_tx_coverage1();
    // --------------------------------
    // Extract1 & re-arrange1 to give1 a more useful1 input to covergroups1
    // --------------------------------
    // Calculate1 percentage1 fill1 level of TX1 FIFO
    forever begin
      @(vif1.tx_fifo_ptr1)
    //do any processing here1
      -> tx_fifo_ptr_change1;
    end  
  endtask : collect_tx_coverage1

  virtual task collect_rx_coverage1();
    // --------------------------------
    // Extract1 & re-arrange1 to give1 a more useful1 input to covergroups1
    // --------------------------------
    // Calculate1 percentage1 fill1 level of RX1 FIFO
    forever begin
      @(vif1.rx_fifo_ptr1)
    //do any processing here1
      -> rx_fifo_ptr_change1;
    end  
  endtask : collect_rx_coverage1

  // --------------------------------
  // Covergroup1 definitions1
  // --------------------------------

  // DUT TX1 FIFO covergroup
  covergroup dut_tx_fifo_cg1 @(tx_fifo_ptr_change1);
    tx_level1              : coverpoint vif1.tx_fifo_ptr1 {
                             bins EMPTY1 = {0};
                             bins HALF_FULL1 = {[7:10]};
                             bins FULL1 = {[13:15]};
                            }
  endgroup


  // DUT RX1 FIFO covergroup
  covergroup dut_rx_fifo_cg1 @(rx_fifo_ptr_change1);
    rx_level1              : coverpoint vif1.rx_fifo_ptr1 {
                             bins EMPTY1 = {0};
                             bins HALF_FULL1 = {[7:10]};
                             bins FULL1 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg1 = new();
    dut_rx_fifo_cg1.set_inst_name ("dut_rx_fifo_cg1");

    dut_tx_fifo_cg1 = new();
    dut_tx_fifo_cg1.set_inst_name ("dut_tx_fifo_cg1");

  endfunction
  
endclass : uart_ctrl_cover1
