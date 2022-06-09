/*-------------------------------------------------------------------------
File30 name   : uart_cover30.sv
Title30       : APB30<>UART30 coverage30 collection30
Project30     :
Created30     :
Description30 : Collects30 coverage30 around30 the UART30 DUT
            : 
----------------------------------------------------------------------
Copyright30 2007 (c) Cadence30 Design30 Systems30, Inc30. All Rights30 Reserved30.
----------------------------------------------------------------------*/

class uart_ctrl_cover30 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if30 vif30;
  uart_pkg30::uart_config30 uart_cfg30;

  event tx_fifo_ptr_change30;
  event rx_fifo_ptr_change30;


  // Required30 macro30 for UVM automation30 and utilities30
  `uvm_component_utils(uart_ctrl_cover30)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage30();
      collect_rx_coverage30();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if30)::get(this, get_full_name(),"vif30", vif30))
      `uvm_fatal("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
  endfunction : connect_phase

  virtual task collect_tx_coverage30();
    // --------------------------------
    // Extract30 & re-arrange30 to give30 a more useful30 input to covergroups30
    // --------------------------------
    // Calculate30 percentage30 fill30 level of TX30 FIFO
    forever begin
      @(vif30.tx_fifo_ptr30)
    //do any processing here30
      -> tx_fifo_ptr_change30;
    end  
  endtask : collect_tx_coverage30

  virtual task collect_rx_coverage30();
    // --------------------------------
    // Extract30 & re-arrange30 to give30 a more useful30 input to covergroups30
    // --------------------------------
    // Calculate30 percentage30 fill30 level of RX30 FIFO
    forever begin
      @(vif30.rx_fifo_ptr30)
    //do any processing here30
      -> rx_fifo_ptr_change30;
    end  
  endtask : collect_rx_coverage30

  // --------------------------------
  // Covergroup30 definitions30
  // --------------------------------

  // DUT TX30 FIFO covergroup
  covergroup dut_tx_fifo_cg30 @(tx_fifo_ptr_change30);
    tx_level30              : coverpoint vif30.tx_fifo_ptr30 {
                             bins EMPTY30 = {0};
                             bins HALF_FULL30 = {[7:10]};
                             bins FULL30 = {[13:15]};
                            }
  endgroup


  // DUT RX30 FIFO covergroup
  covergroup dut_rx_fifo_cg30 @(rx_fifo_ptr_change30);
    rx_level30              : coverpoint vif30.rx_fifo_ptr30 {
                             bins EMPTY30 = {0};
                             bins HALF_FULL30 = {[7:10]};
                             bins FULL30 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg30 = new();
    dut_rx_fifo_cg30.set_inst_name ("dut_rx_fifo_cg30");

    dut_tx_fifo_cg30 = new();
    dut_tx_fifo_cg30.set_inst_name ("dut_tx_fifo_cg30");

  endfunction
  
endclass : uart_ctrl_cover30
