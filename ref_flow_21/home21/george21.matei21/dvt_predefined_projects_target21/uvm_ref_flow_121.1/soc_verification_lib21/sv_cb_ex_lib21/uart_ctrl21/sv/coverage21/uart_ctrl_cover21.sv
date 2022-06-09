/*-------------------------------------------------------------------------
File21 name   : uart_cover21.sv
Title21       : APB21<>UART21 coverage21 collection21
Project21     :
Created21     :
Description21 : Collects21 coverage21 around21 the UART21 DUT
            : 
----------------------------------------------------------------------
Copyright21 2007 (c) Cadence21 Design21 Systems21, Inc21. All Rights21 Reserved21.
----------------------------------------------------------------------*/

class uart_ctrl_cover21 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if21 vif21;
  uart_pkg21::uart_config21 uart_cfg21;

  event tx_fifo_ptr_change21;
  event rx_fifo_ptr_change21;


  // Required21 macro21 for UVM automation21 and utilities21
  `uvm_component_utils(uart_ctrl_cover21)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage21();
      collect_rx_coverage21();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if21)::get(this, get_full_name(),"vif21", vif21))
      `uvm_fatal("NOVIF21",{"virtual interface must be set for: ",get_full_name(),".vif21"})
  endfunction : connect_phase

  virtual task collect_tx_coverage21();
    // --------------------------------
    // Extract21 & re-arrange21 to give21 a more useful21 input to covergroups21
    // --------------------------------
    // Calculate21 percentage21 fill21 level of TX21 FIFO
    forever begin
      @(vif21.tx_fifo_ptr21)
    //do any processing here21
      -> tx_fifo_ptr_change21;
    end  
  endtask : collect_tx_coverage21

  virtual task collect_rx_coverage21();
    // --------------------------------
    // Extract21 & re-arrange21 to give21 a more useful21 input to covergroups21
    // --------------------------------
    // Calculate21 percentage21 fill21 level of RX21 FIFO
    forever begin
      @(vif21.rx_fifo_ptr21)
    //do any processing here21
      -> rx_fifo_ptr_change21;
    end  
  endtask : collect_rx_coverage21

  // --------------------------------
  // Covergroup21 definitions21
  // --------------------------------

  // DUT TX21 FIFO covergroup
  covergroup dut_tx_fifo_cg21 @(tx_fifo_ptr_change21);
    tx_level21              : coverpoint vif21.tx_fifo_ptr21 {
                             bins EMPTY21 = {0};
                             bins HALF_FULL21 = {[7:10]};
                             bins FULL21 = {[13:15]};
                            }
  endgroup


  // DUT RX21 FIFO covergroup
  covergroup dut_rx_fifo_cg21 @(rx_fifo_ptr_change21);
    rx_level21              : coverpoint vif21.rx_fifo_ptr21 {
                             bins EMPTY21 = {0};
                             bins HALF_FULL21 = {[7:10]};
                             bins FULL21 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg21 = new();
    dut_rx_fifo_cg21.set_inst_name ("dut_rx_fifo_cg21");

    dut_tx_fifo_cg21 = new();
    dut_tx_fifo_cg21.set_inst_name ("dut_tx_fifo_cg21");

  endfunction
  
endclass : uart_ctrl_cover21
