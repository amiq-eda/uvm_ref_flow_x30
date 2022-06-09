/*-------------------------------------------------------------------------
File25 name   : uart_cover25.sv
Title25       : APB25<>UART25 coverage25 collection25
Project25     :
Created25     :
Description25 : Collects25 coverage25 around25 the UART25 DUT
            : 
----------------------------------------------------------------------
Copyright25 2007 (c) Cadence25 Design25 Systems25, Inc25. All Rights25 Reserved25.
----------------------------------------------------------------------*/

class uart_ctrl_cover25 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if25 vif25;
  uart_pkg25::uart_config25 uart_cfg25;

  event tx_fifo_ptr_change25;
  event rx_fifo_ptr_change25;


  // Required25 macro25 for UVM automation25 and utilities25
  `uvm_component_utils(uart_ctrl_cover25)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage25();
      collect_rx_coverage25();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if25)::get(this, get_full_name(),"vif25", vif25))
      `uvm_fatal("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
  endfunction : connect_phase

  virtual task collect_tx_coverage25();
    // --------------------------------
    // Extract25 & re-arrange25 to give25 a more useful25 input to covergroups25
    // --------------------------------
    // Calculate25 percentage25 fill25 level of TX25 FIFO
    forever begin
      @(vif25.tx_fifo_ptr25)
    //do any processing here25
      -> tx_fifo_ptr_change25;
    end  
  endtask : collect_tx_coverage25

  virtual task collect_rx_coverage25();
    // --------------------------------
    // Extract25 & re-arrange25 to give25 a more useful25 input to covergroups25
    // --------------------------------
    // Calculate25 percentage25 fill25 level of RX25 FIFO
    forever begin
      @(vif25.rx_fifo_ptr25)
    //do any processing here25
      -> rx_fifo_ptr_change25;
    end  
  endtask : collect_rx_coverage25

  // --------------------------------
  // Covergroup25 definitions25
  // --------------------------------

  // DUT TX25 FIFO covergroup
  covergroup dut_tx_fifo_cg25 @(tx_fifo_ptr_change25);
    tx_level25              : coverpoint vif25.tx_fifo_ptr25 {
                             bins EMPTY25 = {0};
                             bins HALF_FULL25 = {[7:10]};
                             bins FULL25 = {[13:15]};
                            }
  endgroup


  // DUT RX25 FIFO covergroup
  covergroup dut_rx_fifo_cg25 @(rx_fifo_ptr_change25);
    rx_level25              : coverpoint vif25.rx_fifo_ptr25 {
                             bins EMPTY25 = {0};
                             bins HALF_FULL25 = {[7:10]};
                             bins FULL25 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg25 = new();
    dut_rx_fifo_cg25.set_inst_name ("dut_rx_fifo_cg25");

    dut_tx_fifo_cg25 = new();
    dut_tx_fifo_cg25.set_inst_name ("dut_tx_fifo_cg25");

  endfunction
  
endclass : uart_ctrl_cover25
