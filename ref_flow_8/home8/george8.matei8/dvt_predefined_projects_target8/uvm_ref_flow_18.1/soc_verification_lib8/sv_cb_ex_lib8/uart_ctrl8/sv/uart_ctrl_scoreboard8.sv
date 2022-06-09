/*-------------------------------------------------------------------------
File8 name   : uart_ctrl_scoreboard8.sv
Title8       : APB8 - UART8 Scoreboard8
Project8     :
Created8     :
Description8 : Scoreboard8 for data integrity8 check between APB8 UVC8 and UART8 UVC8
Notes8       : Two8 similar8 scoreboards8 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb8)
`uvm_analysis_imp_decl(_uart8)

class uart_ctrl_tx_scbd8 extends uvm_scoreboard;
  bit [7:0] data_to_apb8[$];
  bit [7:0] temp18;
  bit div_en8;

  // Hooks8 to cause in scoroboard8 check errors8
  // This8 resulting8 failure8 is used in MDV8 workshop8 for failure8 analysis8
  `ifdef UVM_WKSHP8
    bit apb_error8;
  `endif

  // Config8 Information8 
  uart_pkg8::uart_config8 uart_cfg8;
  apb_pkg8::apb_slave_config8 slave_cfg8;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd8)
     `uvm_field_object(uart_cfg8, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg8, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb8 #(apb_pkg8::apb_transfer8, uart_ctrl_tx_scbd8) apb_match8;
  uvm_analysis_imp_uart8 #(uart_pkg8::uart_frame8, uart_ctrl_tx_scbd8) uart_add8;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add8  = new("uart_add8", this);
    apb_match8 = new("apb_match8", this);
  endfunction : new

  // implement UART8 Tx8 analysis8 port from reference model
  virtual function void write_uart8(uart_pkg8::uart_frame8 frame8);
    data_to_apb8.push_back(frame8.payload8);	
  endfunction : write_uart8
     
  // implement APB8 READ analysis8 port from reference model
  virtual function void write_apb8(input apb_pkg8::apb_transfer8 transfer8);

    if (transfer8.addr == (slave_cfg8.start_address8 + `LINE_CTRL8)) begin
      div_en8 = transfer8.data[7];
      `uvm_info("SCRBD8",
              $psprintf("LINE_CTRL8 Write with addr = 'h%0h and data = 'h%0h div_en8 = %0b",
              transfer8.addr, transfer8.data, div_en8 ), UVM_HIGH)
    end

    if (!div_en8) begin
    if ((transfer8.addr ==   (slave_cfg8.start_address8 + `RX_FIFO_REG8)) && (transfer8.direction8 == apb_pkg8::APB_READ8))
      begin
       `ifdef UVM_WKSHP8
          corrupt_data8(transfer8);
       `endif
          temp18 = data_to_apb8.pop_front();
       
        if (temp18 == transfer8.data ) 
          `uvm_info("SCRBD8", $psprintf("####### PASS8 : APB8 RECEIVED8 CORRECT8 DATA8 from %s  expected = 'h%0h, received8 = 'h%0h", slave_cfg8.name, temp18, transfer8.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD8", $psprintf("####### FAIL8 : APB8 RECEIVED8 WRONG8 DATA8 from %s", slave_cfg8.name))
          `uvm_info("SCRBD8", $psprintf("expected = 'h%0h, received8 = 'h%0h", temp18, transfer8.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb8
   
  function void assign_cfg8(uart_pkg8::uart_config8 u_cfg8);
    uart_cfg8 = u_cfg8;
  endfunction : assign_cfg8

  function void update_config8(uart_pkg8::uart_config8 u_cfg8);
    `uvm_info(get_type_name(), {"Updating Config8\n", u_cfg8.sprint}, UVM_HIGH)
    uart_cfg8 = u_cfg8;
  endfunction : update_config8

 `ifdef UVM_WKSHP8
    function void corrupt_data8 (apb_pkg8::apb_transfer8 transfer8);
      if (!randomize(apb_error8) with {apb_error8 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL8", $psprintf("Randomization failed for apb_error8"))
      `uvm_info("SCRBD8",(""), UVM_HIGH)
      transfer8.data+=apb_error8;    	
    endfunction : corrupt_data8
  `endif

  // Add task run to debug8 TLM connectivity8 -- dbg_lab68
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG8", "SB: Verify connections8 TX8 of scorebboard8 - using debug_provided_to", UVM_NONE)
      // Implement8 here8 the checks8 
    apb_match8.debug_provided_to();
    uart_add8.debug_provided_to();
      `uvm_info("TX_SCRB_DBG8", "SB: Verify connections8 of TX8 scorebboard8 - using debug_connected_to", UVM_NONE)
      // Implement8 here8 the checks8 
    apb_match8.debug_connected_to();
    uart_add8.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd8

class uart_ctrl_rx_scbd8 extends uvm_scoreboard;
  bit [7:0] data_from_apb8[$];
  bit [7:0] data_to_apb8[$]; // Relevant8 for Remoteloopback8 case only
  bit div_en8;

  bit [7:0] temp18;
  bit [7:0] mask;

  // Hooks8 to cause in scoroboard8 check errors8
  // This8 resulting8 failure8 is used in MDV8 workshop8 for failure8 analysis8
  `ifdef UVM_WKSHP8
    bit uart_error8;
  `endif

  uart_pkg8::uart_config8 uart_cfg8;
  apb_pkg8::apb_slave_config8 slave_cfg8;

  `uvm_component_utils(uart_ctrl_rx_scbd8)
  uvm_analysis_imp_apb8 #(apb_pkg8::apb_transfer8, uart_ctrl_rx_scbd8) apb_add8;
  uvm_analysis_imp_uart8 #(uart_pkg8::uart_frame8, uart_ctrl_rx_scbd8) uart_match8;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match8 = new("uart_match8", this);
    apb_add8    = new("apb_add8", this);
  endfunction : new
   
  // implement APB8 WRITE analysis8 port from reference model
  virtual function void write_apb8(input apb_pkg8::apb_transfer8 transfer8);
    `uvm_info("SCRBD8",
              $psprintf("write_apb8 called with addr = 'h%0h and data = 'h%0h",
              transfer8.addr, transfer8.data), UVM_HIGH)
    if ((transfer8.addr == (slave_cfg8.start_address8 + `LINE_CTRL8)) &&
        (transfer8.direction8 == apb_pkg8::APB_WRITE8)) begin
      div_en8 = transfer8.data[7];
      `uvm_info("SCRBD8",
              $psprintf("LINE_CTRL8 Write with addr = 'h%0h and data = 'h%0h div_en8 = %0b",
              transfer8.addr, transfer8.data, div_en8 ), UVM_HIGH)
    end

    if (!div_en8) begin
      if ((transfer8.addr == (slave_cfg8.start_address8 + `TX_FIFO_REG8)) &&
          (transfer8.direction8 == apb_pkg8::APB_WRITE8)) begin 
        `uvm_info("SCRBD8",
               $psprintf("write_apb8 called pushing8 into queue with data = 'h%0h",
               transfer8.data ), UVM_HIGH)
        data_from_apb8.push_back(transfer8.data);
      end
    end
  endfunction : write_apb8
   
  // implement UART8 Rx8 analysis8 port from reference model
  virtual function void write_uart8( uart_pkg8::uart_frame8 frame8);
    mask = calc_mask8();

    //In case of remote8 loopback8, the data does not get into the rx8/fifo and it gets8 
    // loopbacked8 to ua_txd8. 
    data_to_apb8.push_back(frame8.payload8);	

      temp18 = data_from_apb8.pop_front();

    `ifdef UVM_WKSHP8
        corrupt_payload8 (frame8);
    `endif 
    if ((temp18 & mask) == frame8.payload8) 
      `uvm_info("SCRBD8", $psprintf("####### PASS8 : %s RECEIVED8 CORRECT8 DATA8 expected = 'h%0h, received8 = 'h%0h", slave_cfg8.name, (temp18 & mask), frame8.payload8), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD8", $psprintf("####### FAIL8 : %s RECEIVED8 WRONG8 DATA8", slave_cfg8.name))
      `uvm_info("SCRBD8", $psprintf("expected = 'h%0h, received8 = 'h%0h", temp18, frame8.payload8), UVM_LOW)
    end
  endfunction : write_uart8
   
  function void assign_cfg8(uart_pkg8::uart_config8 u_cfg8);
     uart_cfg8 = u_cfg8;
  endfunction : assign_cfg8
   
  function void update_config8(uart_pkg8::uart_config8 u_cfg8);
   `uvm_info(get_type_name(), {"Updating Config8\n", u_cfg8.sprint}, UVM_HIGH)
    uart_cfg8 = u_cfg8;
  endfunction : update_config8

  function bit[7:0] calc_mask8();
    case (uart_cfg8.char_len_val8)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask8

  `ifdef UVM_WKSHP8
   function void corrupt_payload8 (uart_pkg8::uart_frame8 frame8);
      if(!randomize(uart_error8) with {uart_error8 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL8", $psprintf("Randomization failed for apb_error8"))
      `uvm_info("SCRBD8",(""), UVM_HIGH)
      frame8.payload8+=uart_error8;    	
   endfunction : corrupt_payload8

  `endif

  // Add task run to debug8 TLM connectivity8
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist8;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG8", "SB: Verify connections8 RX8 of scorebboard8 - using debug_provided_to", UVM_NONE)
      // Implement8 here8 the checks8 
    apb_add8.debug_provided_to();
    uart_match8.debug_provided_to();
      `uvm_info("RX_SCRB_DBG8", "SB: Verify connections8 of RX8 scorebboard8 - using debug_connected_to", UVM_NONE)
      // Implement8 here8 the checks8 
    apb_add8.debug_connected_to();
    uart_match8.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd8
