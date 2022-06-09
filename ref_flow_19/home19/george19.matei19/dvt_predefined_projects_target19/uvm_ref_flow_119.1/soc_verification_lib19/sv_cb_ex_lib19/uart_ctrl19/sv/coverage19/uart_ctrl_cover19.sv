/*-------------------------------------------------------------------------
File19 name   : uart_cover19.sv
Title19       : APB19<>UART19 coverage19 collection19
Project19     :
Created19     :
Description19 : Collects19 coverage19 around19 the UART19 DUT
            : 
----------------------------------------------------------------------
Copyright19 2007 (c) Cadence19 Design19 Systems19, Inc19. All Rights19 Reserved19.
----------------------------------------------------------------------*/

class uart_ctrl_cover19 extends  uvm_component ;

  virtual interface uart_ctrl_internal_if19 vif19;
  uart_pkg19::uart_config19 uart_cfg19;

  event tx_fifo_ptr_change19;
  event rx_fifo_ptr_change19;


  // Required19 macro19 for UVM automation19 and utilities19
  `uvm_component_utils(uart_ctrl_cover19)

  virtual task run_phase(uvm_phase phase);
    fork
      collect_tx_coverage19();
      collect_rx_coverage19();
    join

  endtask : run_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual uart_ctrl_internal_if19)::get(this, get_full_name(),"vif19", vif19))
      `uvm_fatal("NOVIF19",{"virtual interface must be set for: ",get_full_name(),".vif19"})
  endfunction : connect_phase

  virtual task collect_tx_coverage19();
    // --------------------------------
    // Extract19 & re-arrange19 to give19 a more useful19 input to covergroups19
    // --------------------------------
    // Calculate19 percentage19 fill19 level of TX19 FIFO
    forever begin
      @(vif19.tx_fifo_ptr19)
    //do any processing here19
      -> tx_fifo_ptr_change19;
    end  
  endtask : collect_tx_coverage19

  virtual task collect_rx_coverage19();
    // --------------------------------
    // Extract19 & re-arrange19 to give19 a more useful19 input to covergroups19
    // --------------------------------
    // Calculate19 percentage19 fill19 level of RX19 FIFO
    forever begin
      @(vif19.rx_fifo_ptr19)
    //do any processing here19
      -> rx_fifo_ptr_change19;
    end  
  endtask : collect_rx_coverage19

  // --------------------------------
  // Covergroup19 definitions19
  // --------------------------------

  // DUT TX19 FIFO covergroup
  covergroup dut_tx_fifo_cg19 @(tx_fifo_ptr_change19);
    tx_level19              : coverpoint vif19.tx_fifo_ptr19 {
                             bins EMPTY19 = {0};
                             bins HALF_FULL19 = {[7:10]};
                             bins FULL19 = {[13:15]};
                            }
  endgroup


  // DUT RX19 FIFO covergroup
  covergroup dut_rx_fifo_cg19 @(rx_fifo_ptr_change19);
    rx_level19              : coverpoint vif19.rx_fifo_ptr19 {
                             bins EMPTY19 = {0};
                             bins HALF_FULL19 = {[7:10]};
                             bins FULL19 = {[13:15]};
                            }
  endgroup

  function new(string name , uvm_component parent);
    super.new(name, parent);
    dut_rx_fifo_cg19 = new();
    dut_rx_fifo_cg19.set_inst_name ("dut_rx_fifo_cg19");

    dut_tx_fifo_cg19 = new();
    dut_tx_fifo_cg19.set_inst_name ("dut_tx_fifo_cg19");

  endfunction
  
endclass : uart_ctrl_cover19
