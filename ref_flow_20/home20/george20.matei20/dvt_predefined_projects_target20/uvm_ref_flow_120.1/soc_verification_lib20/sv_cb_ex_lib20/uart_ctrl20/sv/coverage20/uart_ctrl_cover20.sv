/*-------------------------------------------------------------------------
File20 name   : uart_cover20.sv
Title20       : APB20<>UART20 coverage20 collection20
Project20     :
Created20     :
Description20 : Collects20 coverage20 around20 the UART20 DUT
            : 
----------------------------------------------------------------------
Copyright20 2007 (c) Cadence20 Design20 Systems20, Inc20. All Rights20 Reserved20.
----------------------------------------------------------------------*/

class uart_ctrl_cover20 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if20 vif20;
  uart_pkg20::uart_config20 uart_cfg20;

  event tx_fifo_ptr_change20;
  event rx_fifo_ptr_change20;


  // Required20 macro20 for UVM automation20 and utilities20
  `uvm_component_utils(uart_ctrl_cover20)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage20();
      collect_rx_coverage20();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if20)::get(this, get_full_name(),"vif20", vif20))
      `uvm_fatal("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
  endfunction : connect_phase

  virtual task collect_tx_coverage20();
    // --------------------------------
    // Extract20 & re-arrange20 to give20 a more useful20 input to covergroups20
    // --------------------------------
    // Calculate20 percentage20 fill20 level of TX20 FIFO
    forever begin
      @(vif20.tx_fifo_ptr20)
    //do any processing here20
      -> tx_fifo_ptr_change20;
    end  
  endtask : collect_tx_coverage20

  virtual task collect_rx_coverage20();
    // --------------------------------
    // Extract20 & re-arrange20 to give20 a more useful20 input to covergroups20
    // --------------------------------
    // Calculate20 percentage20 fill20 level of RX20 FIFO
    forever begin
      @(vif20.rx_fifo_ptr20)
    //do any processing here20
      -> rx_fifo_ptr_change20;
    end  
  endtask : collect_rx_coverage20

  // --------------------------------
  // Covergroup20 definitions20
  // --------------------------------

  // DUT TX20 FIFO covergroup
  covergroup dut_tx_fifo_cg20 @(tx_fifo_ptr_change20);
    tx_level20              : coverpoint vif20.tx_fifo_ptr20 {
                             bins EMPTY20 = {0};
                             bins HALF_FULL20 = {[7:10]};
                             bins FULL20 = {[13:15]};
                            }
  endgroup


  // DUT RX20 FIFO covergroup
  covergroup dut_rx_fifo_cg20 @(rx_fifo_ptr_change20);
    rx_level20              : coverpoint vif20.rx_fifo_ptr20 {
                             bins EMPTY20 = {0};
                             bins HALF_FULL20 = {[7:10]};
                             bins FULL20 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg20 = new();
    dut_rx_fifo_cg20.set_inst_name ("dut_rx_fifo_cg20");

    dut_tx_fifo_cg20 = new();
    dut_tx_fifo_cg20.set_inst_name ("dut_tx_fifo_cg20");

  endfunction
  
endclass : uart_ctrl_cover20
