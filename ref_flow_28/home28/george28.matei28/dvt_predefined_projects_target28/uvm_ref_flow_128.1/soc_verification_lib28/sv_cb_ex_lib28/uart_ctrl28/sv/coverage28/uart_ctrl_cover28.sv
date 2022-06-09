/*-------------------------------------------------------------------------
File28 name   : uart_cover28.sv
Title28       : APB28<>UART28 coverage28 collection28
Project28     :
Created28     :
Description28 : Collects28 coverage28 around28 the UART28 DUT
            : 
----------------------------------------------------------------------
Copyright28 2007 (c) Cadence28 Design28 Systems28, Inc28. All Rights28 Reserved28.
----------------------------------------------------------------------*/

class uart_ctrl_cover28 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if28 vif28;
  uart_pkg28::uart_config28 uart_cfg28;

  event tx_fifo_ptr_change28;
  event rx_fifo_ptr_change28;


  // Required28 macro28 for UVM automation28 and utilities28
  `uvm_component_utils(uart_ctrl_cover28)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage28();
      collect_rx_coverage28();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if28)::get(this, get_full_name(),"vif28", vif28))
      `uvm_fatal("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
  endfunction : connect_phase

  virtual task collect_tx_coverage28();
    // --------------------------------
    // Extract28 & re-arrange28 to give28 a more useful28 input to covergroups28
    // --------------------------------
    // Calculate28 percentage28 fill28 level of TX28 FIFO
    forever begin
      @(vif28.tx_fifo_ptr28)
    //do any processing here28
      -> tx_fifo_ptr_change28;
    end  
  endtask : collect_tx_coverage28

  virtual task collect_rx_coverage28();
    // --------------------------------
    // Extract28 & re-arrange28 to give28 a more useful28 input to covergroups28
    // --------------------------------
    // Calculate28 percentage28 fill28 level of RX28 FIFO
    forever begin
      @(vif28.rx_fifo_ptr28)
    //do any processing here28
      -> rx_fifo_ptr_change28;
    end  
  endtask : collect_rx_coverage28

  // --------------------------------
  // Covergroup28 definitions28
  // --------------------------------

  // DUT TX28 FIFO covergroup
  covergroup dut_tx_fifo_cg28 @(tx_fifo_ptr_change28);
    tx_level28              : coverpoint vif28.tx_fifo_ptr28 {
                             bins EMPTY28 = {0};
                             bins HALF_FULL28 = {[7:10]};
                             bins FULL28 = {[13:15]};
                            }
  endgroup


  // DUT RX28 FIFO covergroup
  covergroup dut_rx_fifo_cg28 @(rx_fifo_ptr_change28);
    rx_level28              : coverpoint vif28.rx_fifo_ptr28 {
                             bins EMPTY28 = {0};
                             bins HALF_FULL28 = {[7:10]};
                             bins FULL28 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg28 = new();
    dut_rx_fifo_cg28.set_inst_name ("dut_rx_fifo_cg28");

    dut_tx_fifo_cg28 = new();
    dut_tx_fifo_cg28.set_inst_name ("dut_tx_fifo_cg28");

  endfunction
  
endclass : uart_ctrl_cover28
