/*-------------------------------------------------------------------------
File12 name   : uart_ctrl_scoreboard12.sv
Title12       : APB12 - UART12 Scoreboard12
Project12     :
Created12     :
Description12 : Scoreboard12 for data integrity12 check between APB12 UVC12 and UART12 UVC12
Notes12       : Two12 similar12 scoreboards12 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb12)
`uvm_analysis_imp_decl(_uart12)

class uart_ctrl_tx_scbd12 extends uvm_scoreboard;
  bit [7:0] data_to_apb12[$];
  bit [7:0] temp112;
  bit div_en12;

  // Hooks12 to cause in scoroboard12 check errors12
  // This12 resulting12 failure12 is used in MDV12 workshop12 for failure12 analysis12
  `ifdef UVM_WKSHP12
    bit apb_error12;
  `endif

  // Config12 Information12 
  uart_pkg12::uart_config12 uart_cfg12;
  apb_pkg12::apb_slave_config12 slave_cfg12;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd12)
     `uvm_field_object(uart_cfg12, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg12, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb12 #(apb_pkg12::apb_transfer12, uart_ctrl_tx_scbd12) apb_match12;
  uvm_analysis_imp_uart12 #(uart_pkg12::uart_frame12, uart_ctrl_tx_scbd12) uart_add12;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add12  = new("uart_add12", this);
    apb_match12 = new("apb_match12", this);
  endfunction : new

  // implement UART12 Tx12 analysis12 port from reference model
  virtual function void write_uart12(uart_pkg12::uart_frame12 frame12);
    data_to_apb12.push_back(frame12.payload12);	
  endfunction : write_uart12
     
  // implement APB12 READ analysis12 port from reference model
  virtual function void write_apb12(input apb_pkg12::apb_transfer12 transfer12);

    if (transfer12.addr == (slave_cfg12.start_address12 + `LINE_CTRL12)) begin
      div_en12 = transfer12.data[7];
      `uvm_info("SCRBD12",
              $psprintf("LINE_CTRL12 Write with addr = 'h%0h and data = 'h%0h div_en12 = %0b",
              transfer12.addr, transfer12.data, div_en12 ), UVM_HIGH)
    end

    if (!div_en12) begin
    if ((transfer12.addr ==   (slave_cfg12.start_address12 + `RX_FIFO_REG12)) && (transfer12.direction12 == apb_pkg12::APB_READ12))
      begin
       `ifdef UVM_WKSHP12
          corrupt_data12(transfer12);
       `endif
          temp112 = data_to_apb12.pop_front();
       
        if (temp112 == transfer12.data ) 
          `uvm_info("SCRBD12", $psprintf("####### PASS12 : APB12 RECEIVED12 CORRECT12 DATA12 from %s  expected = 'h%0h, received12 = 'h%0h", slave_cfg12.name, temp112, transfer12.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD12", $psprintf("####### FAIL12 : APB12 RECEIVED12 WRONG12 DATA12 from %s", slave_cfg12.name))
          `uvm_info("SCRBD12", $psprintf("expected = 'h%0h, received12 = 'h%0h", temp112, transfer12.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb12
   
  function void assign_cfg12(uart_pkg12::uart_config12 u_cfg12);
    uart_cfg12 = u_cfg12;
  endfunction : assign_cfg12

  function void update_config12(uart_pkg12::uart_config12 u_cfg12);
    `uvm_info(get_type_name(), {"Updating Config12\n", u_cfg12.sprint}, UVM_HIGH)
    uart_cfg12 = u_cfg12;
  endfunction : update_config12

 `ifdef UVM_WKSHP12
    function void corrupt_data12 (apb_pkg12::apb_transfer12 transfer12);
      if (!randomize(apb_error12) with {apb_error12 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL12", $psprintf("Randomization failed for apb_error12"))
      `uvm_info("SCRBD12",(""), UVM_HIGH)
      transfer12.data+=apb_error12;    	
    endfunction : corrupt_data12
  `endif

  // Add task run to debug12 TLM connectivity12 -- dbg_lab612
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG12", "SB: Verify connections12 TX12 of scorebboard12 - using debug_provided_to", UVM_NONE)
      // Implement12 here12 the checks12 
    apb_match12.debug_provided_to();
    uart_add12.debug_provided_to();
      `uvm_info("TX_SCRB_DBG12", "SB: Verify connections12 of TX12 scorebboard12 - using debug_connected_to", UVM_NONE)
      // Implement12 here12 the checks12 
    apb_match12.debug_connected_to();
    uart_add12.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd12

class uart_ctrl_rx_scbd12 extends uvm_scoreboard;
  bit [7:0] data_from_apb12[$];
  bit [7:0] data_to_apb12[$]; // Relevant12 for Remoteloopback12 case only
  bit div_en12;

  bit [7:0] temp112;
  bit [7:0] mask;

  // Hooks12 to cause in scoroboard12 check errors12
  // This12 resulting12 failure12 is used in MDV12 workshop12 for failure12 analysis12
  `ifdef UVM_WKSHP12
    bit uart_error12;
  `endif

  uart_pkg12::uart_config12 uart_cfg12;
  apb_pkg12::apb_slave_config12 slave_cfg12;

  `uvm_component_utils(uart_ctrl_rx_scbd12)
  uvm_analysis_imp_apb12 #(apb_pkg12::apb_transfer12, uart_ctrl_rx_scbd12) apb_add12;
  uvm_analysis_imp_uart12 #(uart_pkg12::uart_frame12, uart_ctrl_rx_scbd12) uart_match12;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match12 = new("uart_match12", this);
    apb_add12    = new("apb_add12", this);
  endfunction : new
   
  // implement APB12 WRITE analysis12 port from reference model
  virtual function void write_apb12(input apb_pkg12::apb_transfer12 transfer12);
    `uvm_info("SCRBD12",
              $psprintf("write_apb12 called with addr = 'h%0h and data = 'h%0h",
              transfer12.addr, transfer12.data), UVM_HIGH)
    if ((transfer12.addr == (slave_cfg12.start_address12 + `LINE_CTRL12)) &&
        (transfer12.direction12 == apb_pkg12::APB_WRITE12)) begin
      div_en12 = transfer12.data[7];
      `uvm_info("SCRBD12",
              $psprintf("LINE_CTRL12 Write with addr = 'h%0h and data = 'h%0h div_en12 = %0b",
              transfer12.addr, transfer12.data, div_en12 ), UVM_HIGH)
    end

    if (!div_en12) begin
      if ((transfer12.addr == (slave_cfg12.start_address12 + `TX_FIFO_REG12)) &&
          (transfer12.direction12 == apb_pkg12::APB_WRITE12)) begin 
        `uvm_info("SCRBD12",
               $psprintf("write_apb12 called pushing12 into queue with data = 'h%0h",
               transfer12.data ), UVM_HIGH)
        data_from_apb12.push_back(transfer12.data);
      end
    end
  endfunction : write_apb12
   
  // implement UART12 Rx12 analysis12 port from reference model
  virtual function void write_uart12( uart_pkg12::uart_frame12 frame12);
    mask = calc_mask12();

    //In case of remote12 loopback12, the data does not get into the rx12/fifo and it gets12 
    // loopbacked12 to ua_txd12. 
    data_to_apb12.push_back(frame12.payload12);	

      temp112 = data_from_apb12.pop_front();

    `ifdef UVM_WKSHP12
        corrupt_payload12 (frame12);
    `endif 
    if ((temp112 & mask) == frame12.payload12) 
      `uvm_info("SCRBD12", $psprintf("####### PASS12 : %s RECEIVED12 CORRECT12 DATA12 expected = 'h%0h, received12 = 'h%0h", slave_cfg12.name, (temp112 & mask), frame12.payload12), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD12", $psprintf("####### FAIL12 : %s RECEIVED12 WRONG12 DATA12", slave_cfg12.name))
      `uvm_info("SCRBD12", $psprintf("expected = 'h%0h, received12 = 'h%0h", temp112, frame12.payload12), UVM_LOW)
    end
  endfunction : write_uart12
   
  function void assign_cfg12(uart_pkg12::uart_config12 u_cfg12);
     uart_cfg12 = u_cfg12;
  endfunction : assign_cfg12
   
  function void update_config12(uart_pkg12::uart_config12 u_cfg12);
   `uvm_info(get_type_name(), {"Updating Config12\n", u_cfg12.sprint}, UVM_HIGH)
    uart_cfg12 = u_cfg12;
  endfunction : update_config12

  function bit[7:0] calc_mask12();
    case (uart_cfg12.char_len_val12)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask12

  `ifdef UVM_WKSHP12
   function void corrupt_payload12 (uart_pkg12::uart_frame12 frame12);
      if(!randomize(uart_error12) with {uart_error12 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL12", $psprintf("Randomization failed for apb_error12"))
      `uvm_info("SCRBD12",(""), UVM_HIGH)
      frame12.payload12+=uart_error12;    	
   endfunction : corrupt_payload12

  `endif

  // Add task run to debug12 TLM connectivity12
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist12;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG12", "SB: Verify connections12 RX12 of scorebboard12 - using debug_provided_to", UVM_NONE)
      // Implement12 here12 the checks12 
    apb_add12.debug_provided_to();
    uart_match12.debug_provided_to();
      `uvm_info("RX_SCRB_DBG12", "SB: Verify connections12 of RX12 scorebboard12 - using debug_connected_to", UVM_NONE)
      // Implement12 here12 the checks12 
    apb_add12.debug_connected_to();
    uart_match12.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd12
