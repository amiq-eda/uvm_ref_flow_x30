/*-------------------------------------------------------------------------
File29 name   : uart_ctrl_scoreboard29.sv
Title29       : APB29 - UART29 Scoreboard29
Project29     :
Created29     :
Description29 : Scoreboard29 for data integrity29 check between APB29 UVC29 and UART29 UVC29
Notes29       : Two29 similar29 scoreboards29 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb29)
`uvm_analysis_imp_decl(_uart29)

class uart_ctrl_tx_scbd29 extends uvm_scoreboard;
  bit [7:0] data_to_apb29[$];
  bit [7:0] temp129;
  bit div_en29;

  // Hooks29 to cause in scoroboard29 check errors29
  // This29 resulting29 failure29 is used in MDV29 workshop29 for failure29 analysis29
  `ifdef UVM_WKSHP29
    bit apb_error29;
  `endif

  // Config29 Information29 
  uart_pkg29::uart_config29 uart_cfg29;
  apb_pkg29::apb_slave_config29 slave_cfg29;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd29)
     `uvm_field_object(uart_cfg29, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg29, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb29 #(apb_pkg29::apb_transfer29, uart_ctrl_tx_scbd29) apb_match29;
  uvm_analysis_imp_uart29 #(uart_pkg29::uart_frame29, uart_ctrl_tx_scbd29) uart_add29;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add29  = new("uart_add29", this);
    apb_match29 = new("apb_match29", this);
  endfunction : new

  // implement UART29 Tx29 analysis29 port from reference model
  virtual function void write_uart29(uart_pkg29::uart_frame29 frame29);
    data_to_apb29.push_back(frame29.payload29);	
  endfunction : write_uart29
     
  // implement APB29 READ analysis29 port from reference model
  virtual function void write_apb29(input apb_pkg29::apb_transfer29 transfer29);

    if (transfer29.addr == (slave_cfg29.start_address29 + `LINE_CTRL29)) begin
      div_en29 = transfer29.data[7];
      `uvm_info("SCRBD29",
              $psprintf("LINE_CTRL29 Write with addr = 'h%0h and data = 'h%0h div_en29 = %0b",
              transfer29.addr, transfer29.data, div_en29 ), UVM_HIGH)
    end

    if (!div_en29) begin
    if ((transfer29.addr ==   (slave_cfg29.start_address29 + `RX_FIFO_REG29)) && (transfer29.direction29 == apb_pkg29::APB_READ29))
      begin
       `ifdef UVM_WKSHP29
          corrupt_data29(transfer29);
       `endif
          temp129 = data_to_apb29.pop_front();
       
        if (temp129 == transfer29.data ) 
          `uvm_info("SCRBD29", $psprintf("####### PASS29 : APB29 RECEIVED29 CORRECT29 DATA29 from %s  expected = 'h%0h, received29 = 'h%0h", slave_cfg29.name, temp129, transfer29.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD29", $psprintf("####### FAIL29 : APB29 RECEIVED29 WRONG29 DATA29 from %s", slave_cfg29.name))
          `uvm_info("SCRBD29", $psprintf("expected = 'h%0h, received29 = 'h%0h", temp129, transfer29.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb29
   
  function void assign_cfg29(uart_pkg29::uart_config29 u_cfg29);
    uart_cfg29 = u_cfg29;
  endfunction : assign_cfg29

  function void update_config29(uart_pkg29::uart_config29 u_cfg29);
    `uvm_info(get_type_name(), {"Updating Config29\n", u_cfg29.sprint}, UVM_HIGH)
    uart_cfg29 = u_cfg29;
  endfunction : update_config29

 `ifdef UVM_WKSHP29
    function void corrupt_data29 (apb_pkg29::apb_transfer29 transfer29);
      if (!randomize(apb_error29) with {apb_error29 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL29", $psprintf("Randomization failed for apb_error29"))
      `uvm_info("SCRBD29",(""), UVM_HIGH)
      transfer29.data+=apb_error29;    	
    endfunction : corrupt_data29
  `endif

  // Add task run to debug29 TLM connectivity29 -- dbg_lab629
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG29", "SB: Verify connections29 TX29 of scorebboard29 - using debug_provided_to", UVM_NONE)
      // Implement29 here29 the checks29 
    apb_match29.debug_provided_to();
    uart_add29.debug_provided_to();
      `uvm_info("TX_SCRB_DBG29", "SB: Verify connections29 of TX29 scorebboard29 - using debug_connected_to", UVM_NONE)
      // Implement29 here29 the checks29 
    apb_match29.debug_connected_to();
    uart_add29.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd29

class uart_ctrl_rx_scbd29 extends uvm_scoreboard;
  bit [7:0] data_from_apb29[$];
  bit [7:0] data_to_apb29[$]; // Relevant29 for Remoteloopback29 case only
  bit div_en29;

  bit [7:0] temp129;
  bit [7:0] mask;

  // Hooks29 to cause in scoroboard29 check errors29
  // This29 resulting29 failure29 is used in MDV29 workshop29 for failure29 analysis29
  `ifdef UVM_WKSHP29
    bit uart_error29;
  `endif

  uart_pkg29::uart_config29 uart_cfg29;
  apb_pkg29::apb_slave_config29 slave_cfg29;

  `uvm_component_utils(uart_ctrl_rx_scbd29)
  uvm_analysis_imp_apb29 #(apb_pkg29::apb_transfer29, uart_ctrl_rx_scbd29) apb_add29;
  uvm_analysis_imp_uart29 #(uart_pkg29::uart_frame29, uart_ctrl_rx_scbd29) uart_match29;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match29 = new("uart_match29", this);
    apb_add29    = new("apb_add29", this);
  endfunction : new
   
  // implement APB29 WRITE analysis29 port from reference model
  virtual function void write_apb29(input apb_pkg29::apb_transfer29 transfer29);
    `uvm_info("SCRBD29",
              $psprintf("write_apb29 called with addr = 'h%0h and data = 'h%0h",
              transfer29.addr, transfer29.data), UVM_HIGH)
    if ((transfer29.addr == (slave_cfg29.start_address29 + `LINE_CTRL29)) &&
        (transfer29.direction29 == apb_pkg29::APB_WRITE29)) begin
      div_en29 = transfer29.data[7];
      `uvm_info("SCRBD29",
              $psprintf("LINE_CTRL29 Write with addr = 'h%0h and data = 'h%0h div_en29 = %0b",
              transfer29.addr, transfer29.data, div_en29 ), UVM_HIGH)
    end

    if (!div_en29) begin
      if ((transfer29.addr == (slave_cfg29.start_address29 + `TX_FIFO_REG29)) &&
          (transfer29.direction29 == apb_pkg29::APB_WRITE29)) begin 
        `uvm_info("SCRBD29",
               $psprintf("write_apb29 called pushing29 into queue with data = 'h%0h",
               transfer29.data ), UVM_HIGH)
        data_from_apb29.push_back(transfer29.data);
      end
    end
  endfunction : write_apb29
   
  // implement UART29 Rx29 analysis29 port from reference model
  virtual function void write_uart29( uart_pkg29::uart_frame29 frame29);
    mask = calc_mask29();

    //In case of remote29 loopback29, the data does not get into the rx29/fifo and it gets29 
    // loopbacked29 to ua_txd29. 
    data_to_apb29.push_back(frame29.payload29);	

      temp129 = data_from_apb29.pop_front();

    `ifdef UVM_WKSHP29
        corrupt_payload29 (frame29);
    `endif 
    if ((temp129 & mask) == frame29.payload29) 
      `uvm_info("SCRBD29", $psprintf("####### PASS29 : %s RECEIVED29 CORRECT29 DATA29 expected = 'h%0h, received29 = 'h%0h", slave_cfg29.name, (temp129 & mask), frame29.payload29), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD29", $psprintf("####### FAIL29 : %s RECEIVED29 WRONG29 DATA29", slave_cfg29.name))
      `uvm_info("SCRBD29", $psprintf("expected = 'h%0h, received29 = 'h%0h", temp129, frame29.payload29), UVM_LOW)
    end
  endfunction : write_uart29
   
  function void assign_cfg29(uart_pkg29::uart_config29 u_cfg29);
     uart_cfg29 = u_cfg29;
  endfunction : assign_cfg29
   
  function void update_config29(uart_pkg29::uart_config29 u_cfg29);
   `uvm_info(get_type_name(), {"Updating Config29\n", u_cfg29.sprint}, UVM_HIGH)
    uart_cfg29 = u_cfg29;
  endfunction : update_config29

  function bit[7:0] calc_mask29();
    case (uart_cfg29.char_len_val29)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask29

  `ifdef UVM_WKSHP29
   function void corrupt_payload29 (uart_pkg29::uart_frame29 frame29);
      if(!randomize(uart_error29) with {uart_error29 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL29", $psprintf("Randomization failed for apb_error29"))
      `uvm_info("SCRBD29",(""), UVM_HIGH)
      frame29.payload29+=uart_error29;    	
   endfunction : corrupt_payload29

  `endif

  // Add task run to debug29 TLM connectivity29
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist29;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG29", "SB: Verify connections29 RX29 of scorebboard29 - using debug_provided_to", UVM_NONE)
      // Implement29 here29 the checks29 
    apb_add29.debug_provided_to();
    uart_match29.debug_provided_to();
      `uvm_info("RX_SCRB_DBG29", "SB: Verify connections29 of RX29 scorebboard29 - using debug_connected_to", UVM_NONE)
      // Implement29 here29 the checks29 
    apb_add29.debug_connected_to();
    uart_match29.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd29
