/*-------------------------------------------------------------------------
File10 name   : uart_cover10.sv
Title10       : APB10<>UART10 coverage10 collection10
Project10     :
Created10     :
Description10 : Collects10 coverage10 around10 the UART10 DUT
            : 
----------------------------------------------------------------------
Copyright10 2007 (c) Cadence10 Design10 Systems10, Inc10. All Rights10 Reserved10.
----------------------------------------------------------------------*/

class uart_ctrl_cover10 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if10 vif10;
  uart_pkg10::uart_config10 uart_cfg10;

  event tx_fifo_ptr_change10;
  event rx_fifo_ptr_change10;


  // Required10 macro10 for UVM automation10 and utilities10
  `uvm_component_utils(uart_ctrl_cover10)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage10();
      collect_rx_coverage10();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if10)::get(this, get_full_name(),"vif10", vif10))
      `uvm_fatal("NOVIF10",{"virtual interface must be set for: ",get_full_name(),".vif10"})
  endfunction : connect_phase

  virtual task collect_tx_coverage10();
    // --------------------------------
    // Extract10 & re-arrange10 to give10 a more useful10 input to covergroups10
    // --------------------------------
    // Calculate10 percentage10 fill10 level of TX10 FIFO
    forever begin
      @(vif10.tx_fifo_ptr10)
    //do any processing here10
      -> tx_fifo_ptr_change10;
    end  
  endtask : collect_tx_coverage10

  virtual task collect_rx_coverage10();
    // --------------------------------
    // Extract10 & re-arrange10 to give10 a more useful10 input to covergroups10
    // --------------------------------
    // Calculate10 percentage10 fill10 level of RX10 FIFO
    forever begin
      @(vif10.rx_fifo_ptr10)
    //do any processing here10
      -> rx_fifo_ptr_change10;
    end  
  endtask : collect_rx_coverage10

  // --------------------------------
  // Covergroup10 definitions10
  // --------------------------------

  // DUT TX10 FIFO covergroup
  covergroup dut_tx_fifo_cg10 @(tx_fifo_ptr_change10);
    tx_level10              : coverpoint vif10.tx_fifo_ptr10 {
                             bins EMPTY10 = {0};
                             bins HALF_FULL10 = {[7:10]};
                             bins FULL10 = {[13:15]};
                            }
  endgroup


  // DUT RX10 FIFO covergroup
  covergroup dut_rx_fifo_cg10 @(rx_fifo_ptr_change10);
    rx_level10              : coverpoint vif10.rx_fifo_ptr10 {
                             bins EMPTY10 = {0};
                             bins HALF_FULL10 = {[7:10]};
                             bins FULL10 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg10 = new();
    dut_rx_fifo_cg10.set_inst_name ("dut_rx_fifo_cg10");

    dut_tx_fifo_cg10 = new();
    dut_tx_fifo_cg10.set_inst_name ("dut_tx_fifo_cg10");

  endfunction
  
endclass : uart_ctrl_cover10
