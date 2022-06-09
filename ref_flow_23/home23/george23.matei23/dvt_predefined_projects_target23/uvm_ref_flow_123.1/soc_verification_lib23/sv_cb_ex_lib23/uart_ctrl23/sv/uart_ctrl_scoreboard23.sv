/*-------------------------------------------------------------------------
File23 name   : uart_ctrl_scoreboard23.sv
Title23       : APB23 - UART23 Scoreboard23
Project23     :
Created23     :
Description23 : Scoreboard23 for data integrity23 check between APB23 UVC23 and UART23 UVC23
Notes23       : Two23 similar23 scoreboards23 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb23)
`uvm_analysis_imp_decl(_uart23)

class uart_ctrl_tx_scbd23 extends uvm_scoreboard;
  bit [7:0] data_to_apb23[$];
  bit [7:0] temp123;
  bit div_en23;

  // Hooks23 to cause in scoroboard23 check errors23
  // This23 resulting23 failure23 is used in MDV23 workshop23 for failure23 analysis23
  `ifdef UVM_WKSHP23
    bit apb_error23;
  `endif

  // Config23 Information23 
  uart_pkg23::uart_config23 uart_cfg23;
  apb_pkg23::apb_slave_config23 slave_cfg23;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd23)
     `uvm_field_object(uart_cfg23, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg23, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb23 #(apb_pkg23::apb_transfer23, uart_ctrl_tx_scbd23) apb_match23;
  uvm_analysis_imp_uart23 #(uart_pkg23::uart_frame23, uart_ctrl_tx_scbd23) uart_add23;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add23  = new("uart_add23", this);
    apb_match23 = new("apb_match23", this);
  endfunction : new

  // implement UART23 Tx23 analysis23 port from reference model
  virtual function void write_uart23(uart_pkg23::uart_frame23 frame23);
    data_to_apb23.push_back(frame23.payload23);	
  endfunction : write_uart23
     
  // implement APB23 READ analysis23 port from reference model
  virtual function void write_apb23(input apb_pkg23::apb_transfer23 transfer23);

    if (transfer23.addr == (slave_cfg23.start_address23 + `LINE_CTRL23)) begin
      div_en23 = transfer23.data[7];
      `uvm_info("SCRBD23",
              $psprintf("LINE_CTRL23 Write with addr = 'h%0h and data = 'h%0h div_en23 = %0b",
              transfer23.addr, transfer23.data, div_en23 ), UVM_HIGH)
    end

    if (!div_en23) begin
    if ((transfer23.addr ==   (slave_cfg23.start_address23 + `RX_FIFO_REG23)) && (transfer23.direction23 == apb_pkg23::APB_READ23))
      begin
       `ifdef UVM_WKSHP23
          corrupt_data23(transfer23);
       `endif
          temp123 = data_to_apb23.pop_front();
       
        if (temp123 == transfer23.data ) 
          `uvm_info("SCRBD23", $psprintf("####### PASS23 : APB23 RECEIVED23 CORRECT23 DATA23 from %s  expected = 'h%0h, received23 = 'h%0h", slave_cfg23.name, temp123, transfer23.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD23", $psprintf("####### FAIL23 : APB23 RECEIVED23 WRONG23 DATA23 from %s", slave_cfg23.name))
          `uvm_info("SCRBD23", $psprintf("expected = 'h%0h, received23 = 'h%0h", temp123, transfer23.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb23
   
  function void assign_cfg23(uart_pkg23::uart_config23 u_cfg23);
    uart_cfg23 = u_cfg23;
  endfunction : assign_cfg23

  function void update_config23(uart_pkg23::uart_config23 u_cfg23);
    `uvm_info(get_type_name(), {"Updating Config23\n", u_cfg23.sprint}, UVM_HIGH)
    uart_cfg23 = u_cfg23;
  endfunction : update_config23

 `ifdef UVM_WKSHP23
    function void corrupt_data23 (apb_pkg23::apb_transfer23 transfer23);
      if (!randomize(apb_error23) with {apb_error23 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL23", $psprintf("Randomization failed for apb_error23"))
      `uvm_info("SCRBD23",(""), UVM_HIGH)
      transfer23.data+=apb_error23;    	
    endfunction : corrupt_data23
  `endif

  // Add task run to debug23 TLM connectivity23 -- dbg_lab623
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG23", "SB: Verify connections23 TX23 of scorebboard23 - using debug_provided_to", UVM_NONE)
      // Implement23 here23 the checks23 
    apb_match23.debug_provided_to();
    uart_add23.debug_provided_to();
      `uvm_info("TX_SCRB_DBG23", "SB: Verify connections23 of TX23 scorebboard23 - using debug_connected_to", UVM_NONE)
      // Implement23 here23 the checks23 
    apb_match23.debug_connected_to();
    uart_add23.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd23

class uart_ctrl_rx_scbd23 extends uvm_scoreboard;
  bit [7:0] data_from_apb23[$];
  bit [7:0] data_to_apb23[$]; // Relevant23 for Remoteloopback23 case only
  bit div_en23;

  bit [7:0] temp123;
  bit [7:0] mask;

  // Hooks23 to cause in scoroboard23 check errors23
  // This23 resulting23 failure23 is used in MDV23 workshop23 for failure23 analysis23
  `ifdef UVM_WKSHP23
    bit uart_error23;
  `endif

  uart_pkg23::uart_config23 uart_cfg23;
  apb_pkg23::apb_slave_config23 slave_cfg23;

  `uvm_component_utils(uart_ctrl_rx_scbd23)
  uvm_analysis_imp_apb23 #(apb_pkg23::apb_transfer23, uart_ctrl_rx_scbd23) apb_add23;
  uvm_analysis_imp_uart23 #(uart_pkg23::uart_frame23, uart_ctrl_rx_scbd23) uart_match23;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match23 = new("uart_match23", this);
    apb_add23    = new("apb_add23", this);
  endfunction : new
   
  // implement APB23 WRITE analysis23 port from reference model
  virtual function void write_apb23(input apb_pkg23::apb_transfer23 transfer23);
    `uvm_info("SCRBD23",
              $psprintf("write_apb23 called with addr = 'h%0h and data = 'h%0h",
              transfer23.addr, transfer23.data), UVM_HIGH)
    if ((transfer23.addr == (slave_cfg23.start_address23 + `LINE_CTRL23)) &&
        (transfer23.direction23 == apb_pkg23::APB_WRITE23)) begin
      div_en23 = transfer23.data[7];
      `uvm_info("SCRBD23",
              $psprintf("LINE_CTRL23 Write with addr = 'h%0h and data = 'h%0h div_en23 = %0b",
              transfer23.addr, transfer23.data, div_en23 ), UVM_HIGH)
    end

    if (!div_en23) begin
      if ((transfer23.addr == (slave_cfg23.start_address23 + `TX_FIFO_REG23)) &&
          (transfer23.direction23 == apb_pkg23::APB_WRITE23)) begin 
        `uvm_info("SCRBD23",
               $psprintf("write_apb23 called pushing23 into queue with data = 'h%0h",
               transfer23.data ), UVM_HIGH)
        data_from_apb23.push_back(transfer23.data);
      end
    end
  endfunction : write_apb23
   
  // implement UART23 Rx23 analysis23 port from reference model
  virtual function void write_uart23( uart_pkg23::uart_frame23 frame23);
    mask = calc_mask23();

    //In case of remote23 loopback23, the data does not get into the rx23/fifo and it gets23 
    // loopbacked23 to ua_txd23. 
    data_to_apb23.push_back(frame23.payload23);	

      temp123 = data_from_apb23.pop_front();

    `ifdef UVM_WKSHP23
        corrupt_payload23 (frame23);
    `endif 
    if ((temp123 & mask) == frame23.payload23) 
      `uvm_info("SCRBD23", $psprintf("####### PASS23 : %s RECEIVED23 CORRECT23 DATA23 expected = 'h%0h, received23 = 'h%0h", slave_cfg23.name, (temp123 & mask), frame23.payload23), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD23", $psprintf("####### FAIL23 : %s RECEIVED23 WRONG23 DATA23", slave_cfg23.name))
      `uvm_info("SCRBD23", $psprintf("expected = 'h%0h, received23 = 'h%0h", temp123, frame23.payload23), UVM_LOW)
    end
  endfunction : write_uart23
   
  function void assign_cfg23(uart_pkg23::uart_config23 u_cfg23);
     uart_cfg23 = u_cfg23;
  endfunction : assign_cfg23
   
  function void update_config23(uart_pkg23::uart_config23 u_cfg23);
   `uvm_info(get_type_name(), {"Updating Config23\n", u_cfg23.sprint}, UVM_HIGH)
    uart_cfg23 = u_cfg23;
  endfunction : update_config23

  function bit[7:0] calc_mask23();
    case (uart_cfg23.char_len_val23)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask23

  `ifdef UVM_WKSHP23
   function void corrupt_payload23 (uart_pkg23::uart_frame23 frame23);
      if(!randomize(uart_error23) with {uart_error23 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL23", $psprintf("Randomization failed for apb_error23"))
      `uvm_info("SCRBD23",(""), UVM_HIGH)
      frame23.payload23+=uart_error23;    	
   endfunction : corrupt_payload23

  `endif

  // Add task run to debug23 TLM connectivity23
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist23;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG23", "SB: Verify connections23 RX23 of scorebboard23 - using debug_provided_to", UVM_NONE)
      // Implement23 here23 the checks23 
    apb_add23.debug_provided_to();
    uart_match23.debug_provided_to();
      `uvm_info("RX_SCRB_DBG23", "SB: Verify connections23 of RX23 scorebboard23 - using debug_connected_to", UVM_NONE)
      // Implement23 here23 the checks23 
    apb_add23.debug_connected_to();
    uart_match23.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd23
