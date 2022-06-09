/*-------------------------------------------------------------------------
File23 name   : uart_cover23.sv
Title23       : APB23<>UART23 coverage23 collection23
Project23     :
Created23     :
Description23 : Collects23 coverage23 around23 the UART23 DUT
            : 
----------------------------------------------------------------------
Copyright23 2007 (c) Cadence23 Design23 Systems23, Inc23. All Rights23 Reserved23.
----------------------------------------------------------------------*/

class uart_ctrl_cover23 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if23 vif23;
  uart_pkg23::uart_config23 uart_cfg23;

  event tx_fifo_ptr_change23;
  event rx_fifo_ptr_change23;


  // Required23 macro23 for UVM automation23 and utilities23
  `uvm_component_utils(uart_ctrl_cover23)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage23();
      collect_rx_coverage23();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if23)::get(this, get_full_name(),"vif23", vif23))
      `uvm_fatal("NOVIF23",{"virtual interface must be set for: ",get_full_name(),".vif23"})
  endfunction : connect_phase

  virtual task collect_tx_coverage23();
    // --------------------------------
    // Extract23 & re-arrange23 to give23 a more useful23 input to covergroups23
    // --------------------------------
    // Calculate23 percentage23 fill23 level of TX23 FIFO
    forever begin
      @(vif23.tx_fifo_ptr23)
    //do any processing here23
      -> tx_fifo_ptr_change23;
    end  
  endtask : collect_tx_coverage23

  virtual task collect_rx_coverage23();
    // --------------------------------
    // Extract23 & re-arrange23 to give23 a more useful23 input to covergroups23
    // --------------------------------
    // Calculate23 percentage23 fill23 level of RX23 FIFO
    forever begin
      @(vif23.rx_fifo_ptr23)
    //do any processing here23
      -> rx_fifo_ptr_change23;
    end  
  endtask : collect_rx_coverage23

  // --------------------------------
  // Covergroup23 definitions23
  // --------------------------------

  // DUT TX23 FIFO covergroup
  covergroup dut_tx_fifo_cg23 @(tx_fifo_ptr_change23);
    tx_level23              : coverpoint vif23.tx_fifo_ptr23 {
                             bins EMPTY23 = {0};
                             bins HALF_FULL23 = {[7:10]};
                             bins FULL23 = {[13:15]};
                            }
  endgroup


  // DUT RX23 FIFO covergroup
  covergroup dut_rx_fifo_cg23 @(rx_fifo_ptr_change23);
    rx_level23              : coverpoint vif23.rx_fifo_ptr23 {
                             bins EMPTY23 = {0};
                             bins HALF_FULL23 = {[7:10]};
                             bins FULL23 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg23 = new();
    dut_rx_fifo_cg23.set_inst_name ("dut_rx_fifo_cg23");

    dut_tx_fifo_cg23 = new();
    dut_tx_fifo_cg23.set_inst_name ("dut_tx_fifo_cg23");

  endfunction
  
endclass : uart_ctrl_cover23
