/*-------------------------------------------------------------------------
File24 name   : uart_ctrl_scoreboard24.sv
Title24       : APB24 - UART24 Scoreboard24
Project24     :
Created24     :
Description24 : Scoreboard24 for data integrity24 check between APB24 UVC24 and UART24 UVC24
Notes24       : Two24 similar24 scoreboards24 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb24)
`uvm_analysis_imp_decl(_uart24)

class uart_ctrl_tx_scbd24 extends uvm_scoreboard;
  bit [7:0] data_to_apb24[$];
  bit [7:0] temp124;
  bit div_en24;

  // Hooks24 to cause in scoroboard24 check errors24
  // This24 resulting24 failure24 is used in MDV24 workshop24 for failure24 analysis24
  `ifdef UVM_WKSHP24
    bit apb_error24;
  `endif

  // Config24 Information24 
  uart_pkg24::uart_config24 uart_cfg24;
  apb_pkg24::apb_slave_config24 slave_cfg24;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd24)
     `uvm_field_object(uart_cfg24, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg24, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb24 #(apb_pkg24::apb_transfer24, uart_ctrl_tx_scbd24) apb_match24;
  uvm_analysis_imp_uart24 #(uart_pkg24::uart_frame24, uart_ctrl_tx_scbd24) uart_add24;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add24  = new("uart_add24", this);
    apb_match24 = new("apb_match24", this);
  endfunction : new

  // implement UART24 Tx24 analysis24 port from reference model
  virtual function void write_uart24(uart_pkg24::uart_frame24 frame24);
    data_to_apb24.push_back(frame24.payload24);	
  endfunction : write_uart24
     
  // implement APB24 READ analysis24 port from reference model
  virtual function void write_apb24(input apb_pkg24::apb_transfer24 transfer24);

    if (transfer24.addr == (slave_cfg24.start_address24 + `LINE_CTRL24)) begin
      div_en24 = transfer24.data[7];
      `uvm_info("SCRBD24",
              $psprintf("LINE_CTRL24 Write with addr = 'h%0h and data = 'h%0h div_en24 = %0b",
              transfer24.addr, transfer24.data, div_en24 ), UVM_HIGH)
    end

    if (!div_en24) begin
    if ((transfer24.addr ==   (slave_cfg24.start_address24 + `RX_FIFO_REG24)) && (transfer24.direction24 == apb_pkg24::APB_READ24))
      begin
       `ifdef UVM_WKSHP24
          corrupt_data24(transfer24);
       `endif
          temp124 = data_to_apb24.pop_front();
       
        if (temp124 == transfer24.data ) 
          `uvm_info("SCRBD24", $psprintf("####### PASS24 : APB24 RECEIVED24 CORRECT24 DATA24 from %s  expected = 'h%0h, received24 = 'h%0h", slave_cfg24.name, temp124, transfer24.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD24", $psprintf("####### FAIL24 : APB24 RECEIVED24 WRONG24 DATA24 from %s", slave_cfg24.name))
          `uvm_info("SCRBD24", $psprintf("expected = 'h%0h, received24 = 'h%0h", temp124, transfer24.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb24
   
  function void assign_cfg24(uart_pkg24::uart_config24 u_cfg24);
    uart_cfg24 = u_cfg24;
  endfunction : assign_cfg24

  function void update_config24(uart_pkg24::uart_config24 u_cfg24);
    `uvm_info(get_type_name(), {"Updating Config24\n", u_cfg24.sprint}, UVM_HIGH)
    uart_cfg24 = u_cfg24;
  endfunction : update_config24

 `ifdef UVM_WKSHP24
    function void corrupt_data24 (apb_pkg24::apb_transfer24 transfer24);
      if (!randomize(apb_error24) with {apb_error24 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL24", $psprintf("Randomization failed for apb_error24"))
      `uvm_info("SCRBD24",(""), UVM_HIGH)
      transfer24.data+=apb_error24;    	
    endfunction : corrupt_data24
  `endif

  // Add task run to debug24 TLM connectivity24 -- dbg_lab624
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG24", "SB: Verify connections24 TX24 of scorebboard24 - using debug_provided_to", UVM_NONE)
      // Implement24 here24 the checks24 
    apb_match24.debug_provided_to();
    uart_add24.debug_provided_to();
      `uvm_info("TX_SCRB_DBG24", "SB: Verify connections24 of TX24 scorebboard24 - using debug_connected_to", UVM_NONE)
      // Implement24 here24 the checks24 
    apb_match24.debug_connected_to();
    uart_add24.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd24

class uart_ctrl_rx_scbd24 extends uvm_scoreboard;
  bit [7:0] data_from_apb24[$];
  bit [7:0] data_to_apb24[$]; // Relevant24 for Remoteloopback24 case only
  bit div_en24;

  bit [7:0] temp124;
  bit [7:0] mask;

  // Hooks24 to cause in scoroboard24 check errors24
  // This24 resulting24 failure24 is used in MDV24 workshop24 for failure24 analysis24
  `ifdef UVM_WKSHP24
    bit uart_error24;
  `endif

  uart_pkg24::uart_config24 uart_cfg24;
  apb_pkg24::apb_slave_config24 slave_cfg24;

  `uvm_component_utils(uart_ctrl_rx_scbd24)
  uvm_analysis_imp_apb24 #(apb_pkg24::apb_transfer24, uart_ctrl_rx_scbd24) apb_add24;
  uvm_analysis_imp_uart24 #(uart_pkg24::uart_frame24, uart_ctrl_rx_scbd24) uart_match24;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match24 = new("uart_match24", this);
    apb_add24    = new("apb_add24", this);
  endfunction : new
   
  // implement APB24 WRITE analysis24 port from reference model
  virtual function void write_apb24(input apb_pkg24::apb_transfer24 transfer24);
    `uvm_info("SCRBD24",
              $psprintf("write_apb24 called with addr = 'h%0h and data = 'h%0h",
              transfer24.addr, transfer24.data), UVM_HIGH)
    if ((transfer24.addr == (slave_cfg24.start_address24 + `LINE_CTRL24)) &&
        (transfer24.direction24 == apb_pkg24::APB_WRITE24)) begin
      div_en24 = transfer24.data[7];
      `uvm_info("SCRBD24",
              $psprintf("LINE_CTRL24 Write with addr = 'h%0h and data = 'h%0h div_en24 = %0b",
              transfer24.addr, transfer24.data, div_en24 ), UVM_HIGH)
    end

    if (!div_en24) begin
      if ((transfer24.addr == (slave_cfg24.start_address24 + `TX_FIFO_REG24)) &&
          (transfer24.direction24 == apb_pkg24::APB_WRITE24)) begin 
        `uvm_info("SCRBD24",
               $psprintf("write_apb24 called pushing24 into queue with data = 'h%0h",
               transfer24.data ), UVM_HIGH)
        data_from_apb24.push_back(transfer24.data);
      end
    end
  endfunction : write_apb24
   
  // implement UART24 Rx24 analysis24 port from reference model
  virtual function void write_uart24( uart_pkg24::uart_frame24 frame24);
    mask = calc_mask24();

    //In case of remote24 loopback24, the data does not get into the rx24/fifo and it gets24 
    // loopbacked24 to ua_txd24. 
    data_to_apb24.push_back(frame24.payload24);	

      temp124 = data_from_apb24.pop_front();

    `ifdef UVM_WKSHP24
        corrupt_payload24 (frame24);
    `endif 
    if ((temp124 & mask) == frame24.payload24) 
      `uvm_info("SCRBD24", $psprintf("####### PASS24 : %s RECEIVED24 CORRECT24 DATA24 expected = 'h%0h, received24 = 'h%0h", slave_cfg24.name, (temp124 & mask), frame24.payload24), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD24", $psprintf("####### FAIL24 : %s RECEIVED24 WRONG24 DATA24", slave_cfg24.name))
      `uvm_info("SCRBD24", $psprintf("expected = 'h%0h, received24 = 'h%0h", temp124, frame24.payload24), UVM_LOW)
    end
  endfunction : write_uart24
   
  function void assign_cfg24(uart_pkg24::uart_config24 u_cfg24);
     uart_cfg24 = u_cfg24;
  endfunction : assign_cfg24
   
  function void update_config24(uart_pkg24::uart_config24 u_cfg24);
   `uvm_info(get_type_name(), {"Updating Config24\n", u_cfg24.sprint}, UVM_HIGH)
    uart_cfg24 = u_cfg24;
  endfunction : update_config24

  function bit[7:0] calc_mask24();
    case (uart_cfg24.char_len_val24)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask24

  `ifdef UVM_WKSHP24
   function void corrupt_payload24 (uart_pkg24::uart_frame24 frame24);
      if(!randomize(uart_error24) with {uart_error24 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL24", $psprintf("Randomization failed for apb_error24"))
      `uvm_info("SCRBD24",(""), UVM_HIGH)
      frame24.payload24+=uart_error24;    	
   endfunction : corrupt_payload24

  `endif

  // Add task run to debug24 TLM connectivity24
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist24;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG24", "SB: Verify connections24 RX24 of scorebboard24 - using debug_provided_to", UVM_NONE)
      // Implement24 here24 the checks24 
    apb_add24.debug_provided_to();
    uart_match24.debug_provided_to();
      `uvm_info("RX_SCRB_DBG24", "SB: Verify connections24 of RX24 scorebboard24 - using debug_connected_to", UVM_NONE)
      // Implement24 here24 the checks24 
    apb_add24.debug_connected_to();
    uart_match24.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd24
