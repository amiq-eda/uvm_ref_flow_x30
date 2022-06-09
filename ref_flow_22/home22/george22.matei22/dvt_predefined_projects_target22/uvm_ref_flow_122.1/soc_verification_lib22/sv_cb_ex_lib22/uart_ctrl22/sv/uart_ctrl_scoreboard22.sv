/*-------------------------------------------------------------------------
File22 name   : uart_ctrl_scoreboard22.sv
Title22       : APB22 - UART22 Scoreboard22
Project22     :
Created22     :
Description22 : Scoreboard22 for data integrity22 check between APB22 UVC22 and UART22 UVC22
Notes22       : Two22 similar22 scoreboards22 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb22)
`uvm_analysis_imp_decl(_uart22)

class uart_ctrl_tx_scbd22 extends uvm_scoreboard;
  bit [7:0] data_to_apb22[$];
  bit [7:0] temp122;
  bit div_en22;

  // Hooks22 to cause in scoroboard22 check errors22
  // This22 resulting22 failure22 is used in MDV22 workshop22 for failure22 analysis22
  `ifdef UVM_WKSHP22
    bit apb_error22;
  `endif

  // Config22 Information22 
  uart_pkg22::uart_config22 uart_cfg22;
  apb_pkg22::apb_slave_config22 slave_cfg22;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd22)
     `uvm_field_object(uart_cfg22, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg22, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb22 #(apb_pkg22::apb_transfer22, uart_ctrl_tx_scbd22) apb_match22;
  uvm_analysis_imp_uart22 #(uart_pkg22::uart_frame22, uart_ctrl_tx_scbd22) uart_add22;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add22  = new("uart_add22", this);
    apb_match22 = new("apb_match22", this);
  endfunction : new

  // implement UART22 Tx22 analysis22 port from reference model
  virtual function void write_uart22(uart_pkg22::uart_frame22 frame22);
    data_to_apb22.push_back(frame22.payload22);	
  endfunction : write_uart22
     
  // implement APB22 READ analysis22 port from reference model
  virtual function void write_apb22(input apb_pkg22::apb_transfer22 transfer22);

    if (transfer22.addr == (slave_cfg22.start_address22 + `LINE_CTRL22)) begin
      div_en22 = transfer22.data[7];
      `uvm_info("SCRBD22",
              $psprintf("LINE_CTRL22 Write with addr = 'h%0h and data = 'h%0h div_en22 = %0b",
              transfer22.addr, transfer22.data, div_en22 ), UVM_HIGH)
    end

    if (!div_en22) begin
    if ((transfer22.addr ==   (slave_cfg22.start_address22 + `RX_FIFO_REG22)) && (transfer22.direction22 == apb_pkg22::APB_READ22))
      begin
       `ifdef UVM_WKSHP22
          corrupt_data22(transfer22);
       `endif
          temp122 = data_to_apb22.pop_front();
       
        if (temp122 == transfer22.data ) 
          `uvm_info("SCRBD22", $psprintf("####### PASS22 : APB22 RECEIVED22 CORRECT22 DATA22 from %s  expected = 'h%0h, received22 = 'h%0h", slave_cfg22.name, temp122, transfer22.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD22", $psprintf("####### FAIL22 : APB22 RECEIVED22 WRONG22 DATA22 from %s", slave_cfg22.name))
          `uvm_info("SCRBD22", $psprintf("expected = 'h%0h, received22 = 'h%0h", temp122, transfer22.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb22
   
  function void assign_cfg22(uart_pkg22::uart_config22 u_cfg22);
    uart_cfg22 = u_cfg22;
  endfunction : assign_cfg22

  function void update_config22(uart_pkg22::uart_config22 u_cfg22);
    `uvm_info(get_type_name(), {"Updating Config22\n", u_cfg22.sprint}, UVM_HIGH)
    uart_cfg22 = u_cfg22;
  endfunction : update_config22

 `ifdef UVM_WKSHP22
    function void corrupt_data22 (apb_pkg22::apb_transfer22 transfer22);
      if (!randomize(apb_error22) with {apb_error22 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL22", $psprintf("Randomization failed for apb_error22"))
      `uvm_info("SCRBD22",(""), UVM_HIGH)
      transfer22.data+=apb_error22;    	
    endfunction : corrupt_data22
  `endif

  // Add task run to debug22 TLM connectivity22 -- dbg_lab622
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG22", "SB: Verify connections22 TX22 of scorebboard22 - using debug_provided_to", UVM_NONE)
      // Implement22 here22 the checks22 
    apb_match22.debug_provided_to();
    uart_add22.debug_provided_to();
      `uvm_info("TX_SCRB_DBG22", "SB: Verify connections22 of TX22 scorebboard22 - using debug_connected_to", UVM_NONE)
      // Implement22 here22 the checks22 
    apb_match22.debug_connected_to();
    uart_add22.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd22

class uart_ctrl_rx_scbd22 extends uvm_scoreboard;
  bit [7:0] data_from_apb22[$];
  bit [7:0] data_to_apb22[$]; // Relevant22 for Remoteloopback22 case only
  bit div_en22;

  bit [7:0] temp122;
  bit [7:0] mask;

  // Hooks22 to cause in scoroboard22 check errors22
  // This22 resulting22 failure22 is used in MDV22 workshop22 for failure22 analysis22
  `ifdef UVM_WKSHP22
    bit uart_error22;
  `endif

  uart_pkg22::uart_config22 uart_cfg22;
  apb_pkg22::apb_slave_config22 slave_cfg22;

  `uvm_component_utils(uart_ctrl_rx_scbd22)
  uvm_analysis_imp_apb22 #(apb_pkg22::apb_transfer22, uart_ctrl_rx_scbd22) apb_add22;
  uvm_analysis_imp_uart22 #(uart_pkg22::uart_frame22, uart_ctrl_rx_scbd22) uart_match22;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match22 = new("uart_match22", this);
    apb_add22    = new("apb_add22", this);
  endfunction : new
   
  // implement APB22 WRITE analysis22 port from reference model
  virtual function void write_apb22(input apb_pkg22::apb_transfer22 transfer22);
    `uvm_info("SCRBD22",
              $psprintf("write_apb22 called with addr = 'h%0h and data = 'h%0h",
              transfer22.addr, transfer22.data), UVM_HIGH)
    if ((transfer22.addr == (slave_cfg22.start_address22 + `LINE_CTRL22)) &&
        (transfer22.direction22 == apb_pkg22::APB_WRITE22)) begin
      div_en22 = transfer22.data[7];
      `uvm_info("SCRBD22",
              $psprintf("LINE_CTRL22 Write with addr = 'h%0h and data = 'h%0h div_en22 = %0b",
              transfer22.addr, transfer22.data, div_en22 ), UVM_HIGH)
    end

    if (!div_en22) begin
      if ((transfer22.addr == (slave_cfg22.start_address22 + `TX_FIFO_REG22)) &&
          (transfer22.direction22 == apb_pkg22::APB_WRITE22)) begin 
        `uvm_info("SCRBD22",
               $psprintf("write_apb22 called pushing22 into queue with data = 'h%0h",
               transfer22.data ), UVM_HIGH)
        data_from_apb22.push_back(transfer22.data);
      end
    end
  endfunction : write_apb22
   
  // implement UART22 Rx22 analysis22 port from reference model
  virtual function void write_uart22( uart_pkg22::uart_frame22 frame22);
    mask = calc_mask22();

    //In case of remote22 loopback22, the data does not get into the rx22/fifo and it gets22 
    // loopbacked22 to ua_txd22. 
    data_to_apb22.push_back(frame22.payload22);	

      temp122 = data_from_apb22.pop_front();

    `ifdef UVM_WKSHP22
        corrupt_payload22 (frame22);
    `endif 
    if ((temp122 & mask) == frame22.payload22) 
      `uvm_info("SCRBD22", $psprintf("####### PASS22 : %s RECEIVED22 CORRECT22 DATA22 expected = 'h%0h, received22 = 'h%0h", slave_cfg22.name, (temp122 & mask), frame22.payload22), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD22", $psprintf("####### FAIL22 : %s RECEIVED22 WRONG22 DATA22", slave_cfg22.name))
      `uvm_info("SCRBD22", $psprintf("expected = 'h%0h, received22 = 'h%0h", temp122, frame22.payload22), UVM_LOW)
    end
  endfunction : write_uart22
   
  function void assign_cfg22(uart_pkg22::uart_config22 u_cfg22);
     uart_cfg22 = u_cfg22;
  endfunction : assign_cfg22
   
  function void update_config22(uart_pkg22::uart_config22 u_cfg22);
   `uvm_info(get_type_name(), {"Updating Config22\n", u_cfg22.sprint}, UVM_HIGH)
    uart_cfg22 = u_cfg22;
  endfunction : update_config22

  function bit[7:0] calc_mask22();
    case (uart_cfg22.char_len_val22)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask22

  `ifdef UVM_WKSHP22
   function void corrupt_payload22 (uart_pkg22::uart_frame22 frame22);
      if(!randomize(uart_error22) with {uart_error22 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL22", $psprintf("Randomization failed for apb_error22"))
      `uvm_info("SCRBD22",(""), UVM_HIGH)
      frame22.payload22+=uart_error22;    	
   endfunction : corrupt_payload22

  `endif

  // Add task run to debug22 TLM connectivity22
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist22;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG22", "SB: Verify connections22 RX22 of scorebboard22 - using debug_provided_to", UVM_NONE)
      // Implement22 here22 the checks22 
    apb_add22.debug_provided_to();
    uart_match22.debug_provided_to();
      `uvm_info("RX_SCRB_DBG22", "SB: Verify connections22 of RX22 scorebboard22 - using debug_connected_to", UVM_NONE)
      // Implement22 here22 the checks22 
    apb_add22.debug_connected_to();
    uart_match22.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd22
