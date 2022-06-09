/*-------------------------------------------------------------------------
File3 name   : uart_ctrl_scoreboard3.sv
Title3       : APB3 - UART3 Scoreboard3
Project3     :
Created3     :
Description3 : Scoreboard3 for data integrity3 check between APB3 UVC3 and UART3 UVC3
Notes3       : Two3 similar3 scoreboards3 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb3)
`uvm_analysis_imp_decl(_uart3)

class uart_ctrl_tx_scbd3 extends uvm_scoreboard;
  bit [7:0] data_to_apb3[$];
  bit [7:0] temp13;
  bit div_en3;

  // Hooks3 to cause in scoroboard3 check errors3
  // This3 resulting3 failure3 is used in MDV3 workshop3 for failure3 analysis3
  `ifdef UVM_WKSHP3
    bit apb_error3;
  `endif

  // Config3 Information3 
  uart_pkg3::uart_config3 uart_cfg3;
  apb_pkg3::apb_slave_config3 slave_cfg3;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd3)
     `uvm_field_object(uart_cfg3, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg3, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb3 #(apb_pkg3::apb_transfer3, uart_ctrl_tx_scbd3) apb_match3;
  uvm_analysis_imp_uart3 #(uart_pkg3::uart_frame3, uart_ctrl_tx_scbd3) uart_add3;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add3  = new("uart_add3", this);
    apb_match3 = new("apb_match3", this);
  endfunction : new

  // implement UART3 Tx3 analysis3 port from reference model
  virtual function void write_uart3(uart_pkg3::uart_frame3 frame3);
    data_to_apb3.push_back(frame3.payload3);	
  endfunction : write_uart3
     
  // implement APB3 READ analysis3 port from reference model
  virtual function void write_apb3(input apb_pkg3::apb_transfer3 transfer3);

    if (transfer3.addr == (slave_cfg3.start_address3 + `LINE_CTRL3)) begin
      div_en3 = transfer3.data[7];
      `uvm_info("SCRBD3",
              $psprintf("LINE_CTRL3 Write with addr = 'h%0h and data = 'h%0h div_en3 = %0b",
              transfer3.addr, transfer3.data, div_en3 ), UVM_HIGH)
    end

    if (!div_en3) begin
    if ((transfer3.addr ==   (slave_cfg3.start_address3 + `RX_FIFO_REG3)) && (transfer3.direction3 == apb_pkg3::APB_READ3))
      begin
       `ifdef UVM_WKSHP3
          corrupt_data3(transfer3);
       `endif
          temp13 = data_to_apb3.pop_front();
       
        if (temp13 == transfer3.data ) 
          `uvm_info("SCRBD3", $psprintf("####### PASS3 : APB3 RECEIVED3 CORRECT3 DATA3 from %s  expected = 'h%0h, received3 = 'h%0h", slave_cfg3.name, temp13, transfer3.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD3", $psprintf("####### FAIL3 : APB3 RECEIVED3 WRONG3 DATA3 from %s", slave_cfg3.name))
          `uvm_info("SCRBD3", $psprintf("expected = 'h%0h, received3 = 'h%0h", temp13, transfer3.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb3
   
  function void assign_cfg3(uart_pkg3::uart_config3 u_cfg3);
    uart_cfg3 = u_cfg3;
  endfunction : assign_cfg3

  function void update_config3(uart_pkg3::uart_config3 u_cfg3);
    `uvm_info(get_type_name(), {"Updating Config3\n", u_cfg3.sprint}, UVM_HIGH)
    uart_cfg3 = u_cfg3;
  endfunction : update_config3

 `ifdef UVM_WKSHP3
    function void corrupt_data3 (apb_pkg3::apb_transfer3 transfer3);
      if (!randomize(apb_error3) with {apb_error3 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL3", $psprintf("Randomization failed for apb_error3"))
      `uvm_info("SCRBD3",(""), UVM_HIGH)
      transfer3.data+=apb_error3;    	
    endfunction : corrupt_data3
  `endif

  // Add task run to debug3 TLM connectivity3 -- dbg_lab63
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG3", "SB: Verify connections3 TX3 of scorebboard3 - using debug_provided_to", UVM_NONE)
      // Implement3 here3 the checks3 
    apb_match3.debug_provided_to();
    uart_add3.debug_provided_to();
      `uvm_info("TX_SCRB_DBG3", "SB: Verify connections3 of TX3 scorebboard3 - using debug_connected_to", UVM_NONE)
      // Implement3 here3 the checks3 
    apb_match3.debug_connected_to();
    uart_add3.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd3

class uart_ctrl_rx_scbd3 extends uvm_scoreboard;
  bit [7:0] data_from_apb3[$];
  bit [7:0] data_to_apb3[$]; // Relevant3 for Remoteloopback3 case only
  bit div_en3;

  bit [7:0] temp13;
  bit [7:0] mask;

  // Hooks3 to cause in scoroboard3 check errors3
  // This3 resulting3 failure3 is used in MDV3 workshop3 for failure3 analysis3
  `ifdef UVM_WKSHP3
    bit uart_error3;
  `endif

  uart_pkg3::uart_config3 uart_cfg3;
  apb_pkg3::apb_slave_config3 slave_cfg3;

  `uvm_component_utils(uart_ctrl_rx_scbd3)
  uvm_analysis_imp_apb3 #(apb_pkg3::apb_transfer3, uart_ctrl_rx_scbd3) apb_add3;
  uvm_analysis_imp_uart3 #(uart_pkg3::uart_frame3, uart_ctrl_rx_scbd3) uart_match3;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match3 = new("uart_match3", this);
    apb_add3    = new("apb_add3", this);
  endfunction : new
   
  // implement APB3 WRITE analysis3 port from reference model
  virtual function void write_apb3(input apb_pkg3::apb_transfer3 transfer3);
    `uvm_info("SCRBD3",
              $psprintf("write_apb3 called with addr = 'h%0h and data = 'h%0h",
              transfer3.addr, transfer3.data), UVM_HIGH)
    if ((transfer3.addr == (slave_cfg3.start_address3 + `LINE_CTRL3)) &&
        (transfer3.direction3 == apb_pkg3::APB_WRITE3)) begin
      div_en3 = transfer3.data[7];
      `uvm_info("SCRBD3",
              $psprintf("LINE_CTRL3 Write with addr = 'h%0h and data = 'h%0h div_en3 = %0b",
              transfer3.addr, transfer3.data, div_en3 ), UVM_HIGH)
    end

    if (!div_en3) begin
      if ((transfer3.addr == (slave_cfg3.start_address3 + `TX_FIFO_REG3)) &&
          (transfer3.direction3 == apb_pkg3::APB_WRITE3)) begin 
        `uvm_info("SCRBD3",
               $psprintf("write_apb3 called pushing3 into queue with data = 'h%0h",
               transfer3.data ), UVM_HIGH)
        data_from_apb3.push_back(transfer3.data);
      end
    end
  endfunction : write_apb3
   
  // implement UART3 Rx3 analysis3 port from reference model
  virtual function void write_uart3( uart_pkg3::uart_frame3 frame3);
    mask = calc_mask3();

    //In case of remote3 loopback3, the data does not get into the rx3/fifo and it gets3 
    // loopbacked3 to ua_txd3. 
    data_to_apb3.push_back(frame3.payload3);	

      temp13 = data_from_apb3.pop_front();

    `ifdef UVM_WKSHP3
        corrupt_payload3 (frame3);
    `endif 
    if ((temp13 & mask) == frame3.payload3) 
      `uvm_info("SCRBD3", $psprintf("####### PASS3 : %s RECEIVED3 CORRECT3 DATA3 expected = 'h%0h, received3 = 'h%0h", slave_cfg3.name, (temp13 & mask), frame3.payload3), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD3", $psprintf("####### FAIL3 : %s RECEIVED3 WRONG3 DATA3", slave_cfg3.name))
      `uvm_info("SCRBD3", $psprintf("expected = 'h%0h, received3 = 'h%0h", temp13, frame3.payload3), UVM_LOW)
    end
  endfunction : write_uart3
   
  function void assign_cfg3(uart_pkg3::uart_config3 u_cfg3);
     uart_cfg3 = u_cfg3;
  endfunction : assign_cfg3
   
  function void update_config3(uart_pkg3::uart_config3 u_cfg3);
   `uvm_info(get_type_name(), {"Updating Config3\n", u_cfg3.sprint}, UVM_HIGH)
    uart_cfg3 = u_cfg3;
  endfunction : update_config3

  function bit[7:0] calc_mask3();
    case (uart_cfg3.char_len_val3)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask3

  `ifdef UVM_WKSHP3
   function void corrupt_payload3 (uart_pkg3::uart_frame3 frame3);
      if(!randomize(uart_error3) with {uart_error3 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL3", $psprintf("Randomization failed for apb_error3"))
      `uvm_info("SCRBD3",(""), UVM_HIGH)
      frame3.payload3+=uart_error3;    	
   endfunction : corrupt_payload3

  `endif

  // Add task run to debug3 TLM connectivity3
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist3;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG3", "SB: Verify connections3 RX3 of scorebboard3 - using debug_provided_to", UVM_NONE)
      // Implement3 here3 the checks3 
    apb_add3.debug_provided_to();
    uart_match3.debug_provided_to();
      `uvm_info("RX_SCRB_DBG3", "SB: Verify connections3 of RX3 scorebboard3 - using debug_connected_to", UVM_NONE)
      // Implement3 here3 the checks3 
    apb_add3.debug_connected_to();
    uart_match3.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd3
