/*-------------------------------------------------------------------------
File15 name   : uart_cover15.sv
Title15       : APB15<>UART15 coverage15 collection15
Project15     :
Created15     :
Description15 : Collects15 coverage15 around15 the UART15 DUT
            : 
----------------------------------------------------------------------
Copyright15 2007 (c) Cadence15 Design15 Systems15, Inc15. All Rights15 Reserved15.
----------------------------------------------------------------------*/

class uart_ctrl_cover15 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if15 vif15;
  uart_pkg15::uart_config15 uart_cfg15;

  event tx_fifo_ptr_change15;
  event rx_fifo_ptr_change15;


  // Required15 macro15 for UVM automation15 and utilities15
  `uvm_component_utils(uart_ctrl_cover15)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage15();
      collect_rx_coverage15();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if15)::get(this, get_full_name(),"vif15", vif15))
      `uvm_fatal("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
  endfunction : connect_phase

  virtual task collect_tx_coverage15();
    // --------------------------------
    // Extract15 & re-arrange15 to give15 a more useful15 input to covergroups15
    // --------------------------------
    // Calculate15 percentage15 fill15 level of TX15 FIFO
    forever begin
      @(vif15.tx_fifo_ptr15)
    //do any processing here15
      -> tx_fifo_ptr_change15;
    end  
  endtask : collect_tx_coverage15

  virtual task collect_rx_coverage15();
    // --------------------------------
    // Extract15 & re-arrange15 to give15 a more useful15 input to covergroups15
    // --------------------------------
    // Calculate15 percentage15 fill15 level of RX15 FIFO
    forever begin
      @(vif15.rx_fifo_ptr15)
    //do any processing here15
      -> rx_fifo_ptr_change15;
    end  
  endtask : collect_rx_coverage15

  // --------------------------------
  // Covergroup15 definitions15
  // --------------------------------

  // DUT TX15 FIFO covergroup
  covergroup dut_tx_fifo_cg15 @(tx_fifo_ptr_change15);
    tx_level15              : coverpoint vif15.tx_fifo_ptr15 {
                             bins EMPTY15 = {0};
                             bins HALF_FULL15 = {[7:10]};
                             bins FULL15 = {[13:15]};
                            }
  endgroup


  // DUT RX15 FIFO covergroup
  covergroup dut_rx_fifo_cg15 @(rx_fifo_ptr_change15);
    rx_level15              : coverpoint vif15.rx_fifo_ptr15 {
                             bins EMPTY15 = {0};
                             bins HALF_FULL15 = {[7:10]};
                             bins FULL15 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg15 = new();
    dut_rx_fifo_cg15.set_inst_name ("dut_rx_fifo_cg15");

    dut_tx_fifo_cg15 = new();
    dut_tx_fifo_cg15.set_inst_name ("dut_tx_fifo_cg15");

  endfunction
  
endclass : uart_ctrl_cover15
