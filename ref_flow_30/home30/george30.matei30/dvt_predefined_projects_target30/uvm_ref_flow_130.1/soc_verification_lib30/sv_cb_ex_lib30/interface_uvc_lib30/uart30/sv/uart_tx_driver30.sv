/*-------------------------------------------------------------------------
File30 name   : uart_tx_driver30.sv
Title30       : TX30 Driver30
Project30     :
Created30     :
Description30 : Describes30 UART30 Trasmit30 Driver30 for UART30 UVC30
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER30
`define UART_TX_DRIVER30

class uart_tx_driver30 extends uvm_driver #(uart_frame30) ;

  // The virtual interface used to drive30 and view30 HDL signals30.
  virtual interface uart_if30 vif30;

  // handle to  a cfg class
  uart_config30 cfg;

  bit sample_clk30;
  bit baud_clk30;
  bit [15:0] ua_brgr30;
  bit [7:0] ua_bdiv30;
  int num_of_bits_sent30;
  int num_frames_sent30;

  // Provide30 implementations30 of virtual methods30 such30 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver30)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk30, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk30, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr30, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv30, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor30 - required30 UVM syntax30
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional30 class methods30
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive30();
  extern virtual task gen_sample_rate30(ref bit [15:0] ua_brgr30, ref bit sample_clk30);
  extern virtual task send_tx_frame30(input uart_frame30 frame30);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver30

// UVM build_phase
function void uart_tx_driver30::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config30)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG30", "uart_config30 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver30::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if30)::get(this, "", "vif30", vif30))
   `uvm_error("NOVIF30",{"virtual interface must be set for: ",get_full_name(),".vif30"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver30::run_phase(uvm_phase phase);
  fork
    get_and_drive30();
    gen_sample_rate30(ua_brgr30, sample_clk30);
  join
endtask : run_phase

// reset
task uart_tx_driver30::reset();
  @(negedge vif30.reset);
  `uvm_info(get_type_name(), "Reset30 Asserted30", UVM_MEDIUM)
   vif30.txd30 = 1;        //Transmit30 Data
   vif30.rts_n30 = 0;      //Request30 to Send30
   vif30.dtr_n30 = 0;      //Data Terminal30 Ready30
   vif30.dcd_n30 = 0;      //Data Carrier30 Detect30
   vif30.baud_clk30 = 0;       //Baud30 Data
endtask : reset

//  get_and30 drive30
task uart_tx_driver30::get_and_drive30();
  while (1) begin
    reset();
    fork
      @(negedge vif30.reset)
        `uvm_info(get_type_name(), "Reset30 asserted30", UVM_LOW)
    begin
      forever begin
        @(posedge vif30.clock30 iff (vif30.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame30(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If30 we30 are in the middle30 of a transfer30, need to end the tx30. Also30,
    //do any reset cleanup30 here30. The only way30 we30 got30 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive30

task uart_tx_driver30::gen_sample_rate30(ref bit [15:0] ua_brgr30, ref bit sample_clk30);
  forever begin
    @(posedge vif30.clock30);
    if (!vif30.reset) begin
      ua_brgr30 = 0;
      sample_clk30 = 0;
    end else begin
      if (ua_brgr30 == ({cfg.baud_rate_div30, cfg.baud_rate_gen30})) begin
        ua_brgr30 = 0;
        sample_clk30 = 1;
      end else begin
        sample_clk30 = 0;
        ua_brgr30++;
      end
    end
  end
endtask : gen_sample_rate30

// -------------------
// send_tx_frame30
// -------------------
task uart_tx_driver30::send_tx_frame30(input uart_frame30 frame30);
  bit [7:0] payload_byte30;
  num_of_bits_sent30 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver30 Sending30 TX30 Frame30...\n%s", frame30.sprint()),
            UVM_HIGH)
 
  repeat (frame30.transmit_delay30)
    @(posedge vif30.clock30);
  void'(this.begin_tr(frame30));
   
  wait((!cfg.rts_en30)||(!vif30.cts_n30));
  `uvm_info(get_type_name(), "Driver30 - Modem30 RTS30 or CTS30 asserted30", UVM_HIGH)

  while (num_of_bits_sent30 <= (1 + cfg.char_len_val30 + cfg.parity_en30 + cfg.nbstop30)) begin
    @(posedge vif30.clock30);
    #1;
    if (sample_clk30) begin
      if (num_of_bits_sent30 == 0) begin
        // Start30 sending30 tx_frame30 with "start bit"
        vif30.txd30 = frame30.start_bit30;
        `uvm_info(get_type_name(),
                  $psprintf("Driver30 Sending30 Frame30 SOP30: %b", frame30.start_bit30),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent30 > 0) && (num_of_bits_sent30 < (1 + cfg.char_len_val30))) begin
        // sending30 "data bits" 
        payload_byte30 = frame30.payload30[num_of_bits_sent30-1] ;
        vif30.txd30 = frame30.payload30[num_of_bits_sent30-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver30 Sending30 Frame30 data bit number30:%0d value:'b%b",
             (num_of_bits_sent30-1), payload_byte30), UVM_HIGH)
      end
      if ((num_of_bits_sent30 == (1 + cfg.char_len_val30)) && (cfg.parity_en30)) begin
        // sending30 "parity30 bit" if parity30 is enabled
        vif30.txd30 = frame30.calc_parity30(cfg.char_len_val30, cfg.parity_mode30);
        `uvm_info(get_type_name(),
             $psprintf("Driver30 Sending30 Frame30 Parity30 bit:'b%b",
             frame30.calc_parity30(cfg.char_len_val30, cfg.parity_mode30)), UVM_HIGH)
      end
      if (num_of_bits_sent30 == (1 + cfg.char_len_val30 + cfg.parity_en30)) begin
        // sending30 "stop/error bits"
        for (int i = 0; i < cfg.nbstop30; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver30 Sending30 Frame30 Stop bit:'b%b",
               frame30.stop_bits30[i]), UVM_HIGH)
          wait (sample_clk30);
          if (frame30.error_bits30[i]) begin
            vif30.txd30 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver30 intensionally30 corrupting30 Stop bit since30 error_bits30['b%b] is 'b%b", i, frame30.error_bits30[i]),
                 UVM_HIGH)
          end else
          vif30.txd30 = frame30.stop_bits30[i];
          num_of_bits_sent30++;
          wait (!sample_clk30);
        end
      end
    num_of_bits_sent30++;
    wait (!sample_clk30);
    end
  end
  
  num_frames_sent30++;
  `uvm_info(get_type_name(),
       $psprintf("Frame30 **%0d** Sent30...", num_frames_sent30), UVM_MEDIUM)
  wait (sample_clk30);
  vif30.txd30 = 1;

  `uvm_info(get_type_name(), "Frame30 complete...", UVM_MEDIUM)
  this.end_tr(frame30);
   
endtask : send_tx_frame30

//UVM report_phase
function void uart_tx_driver30::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART30 Frames30 Sent30:%0d", num_frames_sent30),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER30
