/*-------------------------------------------------------------------------
File11 name   : uart_ctrl_scoreboard11.sv
Title11       : APB11 - UART11 Scoreboard11
Project11     :
Created11     :
Description11 : Scoreboard11 for data integrity11 check between APB11 UVC11 and UART11 UVC11
Notes11       : Two11 similar11 scoreboards11 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb11)
`uvm_analysis_imp_decl(_uart11)

class uart_ctrl_tx_scbd11 extends uvm_scoreboard;
  bit [7:0] data_to_apb11[$];
  bit [7:0] temp111;
  bit div_en11;

  // Hooks11 to cause in scoroboard11 check errors11
  // This11 resulting11 failure11 is used in MDV11 workshop11 for failure11 analysis11
  `ifdef UVM_WKSHP11
    bit apb_error11;
  `endif

  // Config11 Information11 
  uart_pkg11::uart_config11 uart_cfg11;
  apb_pkg11::apb_slave_config11 slave_cfg11;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd11)
     `uvm_field_object(uart_cfg11, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg11, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb11 #(apb_pkg11::apb_transfer11, uart_ctrl_tx_scbd11) apb_match11;
  uvm_analysis_imp_uart11 #(uart_pkg11::uart_frame11, uart_ctrl_tx_scbd11) uart_add11;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add11  = new("uart_add11", this);
    apb_match11 = new("apb_match11", this);
  endfunction : new

  // implement UART11 Tx11 analysis11 port from reference model
  virtual function void write_uart11(uart_pkg11::uart_frame11 frame11);
    data_to_apb11.push_back(frame11.payload11);	
  endfunction : write_uart11
     
  // implement APB11 READ analysis11 port from reference model
  virtual function void write_apb11(input apb_pkg11::apb_transfer11 transfer11);

    if (transfer11.addr == (slave_cfg11.start_address11 + `LINE_CTRL11)) begin
      div_en11 = transfer11.data[7];
      `uvm_info("SCRBD11",
              $psprintf("LINE_CTRL11 Write with addr = 'h%0h and data = 'h%0h div_en11 = %0b",
              transfer11.addr, transfer11.data, div_en11 ), UVM_HIGH)
    end

    if (!div_en11) begin
    if ((transfer11.addr ==   (slave_cfg11.start_address11 + `RX_FIFO_REG11)) && (transfer11.direction11 == apb_pkg11::APB_READ11))
      begin
       `ifdef UVM_WKSHP11
          corrupt_data11(transfer11);
       `endif
          temp111 = data_to_apb11.pop_front();
       
        if (temp111 == transfer11.data ) 
          `uvm_info("SCRBD11", $psprintf("####### PASS11 : APB11 RECEIVED11 CORRECT11 DATA11 from %s  expected = 'h%0h, received11 = 'h%0h", slave_cfg11.name, temp111, transfer11.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD11", $psprintf("####### FAIL11 : APB11 RECEIVED11 WRONG11 DATA11 from %s", slave_cfg11.name))
          `uvm_info("SCRBD11", $psprintf("expected = 'h%0h, received11 = 'h%0h", temp111, transfer11.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb11
   
  function void assign_cfg11(uart_pkg11::uart_config11 u_cfg11);
    uart_cfg11 = u_cfg11;
  endfunction : assign_cfg11

  function void update_config11(uart_pkg11::uart_config11 u_cfg11);
    `uvm_info(get_type_name(), {"Updating Config11\n", u_cfg11.sprint}, UVM_HIGH)
    uart_cfg11 = u_cfg11;
  endfunction : update_config11

 `ifdef UVM_WKSHP11
    function void corrupt_data11 (apb_pkg11::apb_transfer11 transfer11);
      if (!randomize(apb_error11) with {apb_error11 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL11", $psprintf("Randomization failed for apb_error11"))
      `uvm_info("SCRBD11",(""), UVM_HIGH)
      transfer11.data+=apb_error11;    	
    endfunction : corrupt_data11
  `endif

  // Add task run to debug11 TLM connectivity11 -- dbg_lab611
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG11", "SB: Verify connections11 TX11 of scorebboard11 - using debug_provided_to", UVM_NONE)
      // Implement11 here11 the checks11 
    apb_match11.debug_provided_to();
    uart_add11.debug_provided_to();
      `uvm_info("TX_SCRB_DBG11", "SB: Verify connections11 of TX11 scorebboard11 - using debug_connected_to", UVM_NONE)
      // Implement11 here11 the checks11 
    apb_match11.debug_connected_to();
    uart_add11.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd11

class uart_ctrl_rx_scbd11 extends uvm_scoreboard;
  bit [7:0] data_from_apb11[$];
  bit [7:0] data_to_apb11[$]; // Relevant11 for Remoteloopback11 case only
  bit div_en11;

  bit [7:0] temp111;
  bit [7:0] mask;

  // Hooks11 to cause in scoroboard11 check errors11
  // This11 resulting11 failure11 is used in MDV11 workshop11 for failure11 analysis11
  `ifdef UVM_WKSHP11
    bit uart_error11;
  `endif

  uart_pkg11::uart_config11 uart_cfg11;
  apb_pkg11::apb_slave_config11 slave_cfg11;

  `uvm_component_utils(uart_ctrl_rx_scbd11)
  uvm_analysis_imp_apb11 #(apb_pkg11::apb_transfer11, uart_ctrl_rx_scbd11) apb_add11;
  uvm_analysis_imp_uart11 #(uart_pkg11::uart_frame11, uart_ctrl_rx_scbd11) uart_match11;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match11 = new("uart_match11", this);
    apb_add11    = new("apb_add11", this);
  endfunction : new
   
  // implement APB11 WRITE analysis11 port from reference model
  virtual function void write_apb11(input apb_pkg11::apb_transfer11 transfer11);
    `uvm_info("SCRBD11",
              $psprintf("write_apb11 called with addr = 'h%0h and data = 'h%0h",
              transfer11.addr, transfer11.data), UVM_HIGH)
    if ((transfer11.addr == (slave_cfg11.start_address11 + `LINE_CTRL11)) &&
        (transfer11.direction11 == apb_pkg11::APB_WRITE11)) begin
      div_en11 = transfer11.data[7];
      `uvm_info("SCRBD11",
              $psprintf("LINE_CTRL11 Write with addr = 'h%0h and data = 'h%0h div_en11 = %0b",
              transfer11.addr, transfer11.data, div_en11 ), UVM_HIGH)
    end

    if (!div_en11) begin
      if ((transfer11.addr == (slave_cfg11.start_address11 + `TX_FIFO_REG11)) &&
          (transfer11.direction11 == apb_pkg11::APB_WRITE11)) begin 
        `uvm_info("SCRBD11",
               $psprintf("write_apb11 called pushing11 into queue with data = 'h%0h",
               transfer11.data ), UVM_HIGH)
        data_from_apb11.push_back(transfer11.data);
      end
    end
  endfunction : write_apb11
   
  // implement UART11 Rx11 analysis11 port from reference model
  virtual function void write_uart11( uart_pkg11::uart_frame11 frame11);
    mask = calc_mask11();

    //In case of remote11 loopback11, the data does not get into the rx11/fifo and it gets11 
    // loopbacked11 to ua_txd11. 
    data_to_apb11.push_back(frame11.payload11);	

      temp111 = data_from_apb11.pop_front();

    `ifdef UVM_WKSHP11
        corrupt_payload11 (frame11);
    `endif 
    if ((temp111 & mask) == frame11.payload11) 
      `uvm_info("SCRBD11", $psprintf("####### PASS11 : %s RECEIVED11 CORRECT11 DATA11 expected = 'h%0h, received11 = 'h%0h", slave_cfg11.name, (temp111 & mask), frame11.payload11), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD11", $psprintf("####### FAIL11 : %s RECEIVED11 WRONG11 DATA11", slave_cfg11.name))
      `uvm_info("SCRBD11", $psprintf("expected = 'h%0h, received11 = 'h%0h", temp111, frame11.payload11), UVM_LOW)
    end
  endfunction : write_uart11
   
  function void assign_cfg11(uart_pkg11::uart_config11 u_cfg11);
     uart_cfg11 = u_cfg11;
  endfunction : assign_cfg11
   
  function void update_config11(uart_pkg11::uart_config11 u_cfg11);
   `uvm_info(get_type_name(), {"Updating Config11\n", u_cfg11.sprint}, UVM_HIGH)
    uart_cfg11 = u_cfg11;
  endfunction : update_config11

  function bit[7:0] calc_mask11();
    case (uart_cfg11.char_len_val11)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask11

  `ifdef UVM_WKSHP11
   function void corrupt_payload11 (uart_pkg11::uart_frame11 frame11);
      if(!randomize(uart_error11) with {uart_error11 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL11", $psprintf("Randomization failed for apb_error11"))
      `uvm_info("SCRBD11",(""), UVM_HIGH)
      frame11.payload11+=uart_error11;    	
   endfunction : corrupt_payload11

  `endif

  // Add task run to debug11 TLM connectivity11
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist11;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG11", "SB: Verify connections11 RX11 of scorebboard11 - using debug_provided_to", UVM_NONE)
      // Implement11 here11 the checks11 
    apb_add11.debug_provided_to();
    uart_match11.debug_provided_to();
      `uvm_info("RX_SCRB_DBG11", "SB: Verify connections11 of RX11 scorebboard11 - using debug_connected_to", UVM_NONE)
      // Implement11 here11 the checks11 
    apb_add11.debug_connected_to();
    uart_match11.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd11
