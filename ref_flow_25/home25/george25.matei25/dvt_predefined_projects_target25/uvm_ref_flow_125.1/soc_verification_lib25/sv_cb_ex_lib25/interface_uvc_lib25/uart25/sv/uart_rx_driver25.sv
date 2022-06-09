/*-------------------------------------------------------------------------
File25 name   : uart_rx_driver25.sv
Title25       : RX25 Driver25
Project25     :
Created25     :
Description25 : Describes25 UART25 Receiver25 Driver25 for UART25 UVC25
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER25
`define UART_RX_DRIVER25

class uart_rx_driver25 extends uvm_driver #(uart_frame25) ;

  // The virtual interface used to drive25 and view25 HDL signals25.
  virtual interface uart_if25 vif25;

  // handle to  a cfg class
  uart_config25 cfg;

  bit sample_clk25;
  bit [15:0] ua_brgr25;
  bit [7:0] ua_bdiv25;
  int num_of_bits_sent25;
  int num_frames_sent25;

  // Provide25 implementations25 of virtual methods25 such25 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver25)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr25, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv25, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor25 - required25 UVM syntax25
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional25 class methods25
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive25();
  extern virtual task gen_sample_rate25(ref bit [15:0] ua_brgr25, ref bit sample_clk25);
  extern virtual task send_rx_frame25(input uart_frame25 frame25);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver25

// UVM build_phase
function void uart_rx_driver25::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config25)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG25", "uart_config25 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver25::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if25)::get(this, "", "vif25", vif25))
   `uvm_error("NOVIF25",{"virtual interface must be set for: ",get_full_name(),".vif25"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver25::run_phase(uvm_phase phase);
  fork
    get_and_drive25();
    gen_sample_rate25(ua_brgr25, sample_clk25);
  join
endtask : run_phase

// reset
task uart_rx_driver25::reset();
  @(negedge vif25.reset);
  `uvm_info(get_type_name(), "Reset25 Asserted25", UVM_MEDIUM)
   vif25.rxd25 = 1;        //Receive25 Data
   vif25.cts_n25 = 0;      //Clear to Send25
   vif25.dsr_n25 = 0;      //Data Set Ready25
   vif25.ri_n25 = 0;       //Ring25 Indicator25
   vif25.baud_clk25 = 0;   //Baud25 Clk25 - NOT25 USED25
endtask : reset

//  get_and25 drive25
task uart_rx_driver25::get_and_drive25();
  while (1) begin
    reset();
    fork
      @(negedge vif25.reset)
        `uvm_info(get_type_name(), "Reset25 asserted25", UVM_LOW)
    begin
      forever begin
        @(posedge vif25.clock25 iff (vif25.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame25(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If25 we25 are in the middle25 of a transfer25, need to end the rx25. Also25,
    //do any reset cleanup25 here25. The only way25 we25 got25 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive25

task uart_rx_driver25::gen_sample_rate25(ref bit [15:0] ua_brgr25, ref bit sample_clk25);
  forever begin
    @(posedge vif25.clock25);
    if (!vif25.reset) begin
      ua_brgr25 = 0;
      sample_clk25 = 0;
    end else begin
      if (ua_brgr25 == ({cfg.baud_rate_div25, cfg.baud_rate_gen25})) begin
        ua_brgr25 = 0;
        sample_clk25 = 1;
      end else begin
        sample_clk25 = 0;
        ua_brgr25++;
      end
    end
  end
endtask : gen_sample_rate25

// -------------------
// send_rx_frame25
// -------------------
task uart_rx_driver25::send_rx_frame25(input uart_frame25 frame25);
  bit [7:0] payload_byte25;
  num_of_bits_sent25 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver25 Sending25 RX25 Frame25...\n%s", frame25.sprint()),
            UVM_HIGH)
 
  repeat (frame25.transmit_delay25)
    @(posedge vif25.clock25);
  void'(this.begin_tr(frame25));
   
  wait((!cfg.rts_en25)||(!vif25.cts_n25));
  `uvm_info(get_type_name(), "Driver25 - Modem25 RTS25 or CTS25 asserted25", UVM_HIGH)

  while (num_of_bits_sent25 <= (1 + cfg.char_len_val25 + cfg.parity_en25 + cfg.nbstop25)) begin
    @(posedge vif25.clock25);
    #1;
    if (sample_clk25) begin
      if (num_of_bits_sent25 == 0) begin
        // Start25 sending25 rx_frame25 with "start bit"
        vif25.rxd25 = frame25.start_bit25;
        `uvm_info(get_type_name(),
                  $psprintf("Driver25 Sending25 Frame25 SOP25: %b", frame25.start_bit25),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent25 > 0) && (num_of_bits_sent25 < (1 + cfg.char_len_val25))) begin
        // sending25 "data bits" 
        payload_byte25 = frame25.payload25[num_of_bits_sent25-1] ;
        vif25.rxd25 = frame25.payload25[num_of_bits_sent25-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver25 Sending25 Frame25 data bit number25:%0d value:'b%b",
             (num_of_bits_sent25-1), payload_byte25), UVM_HIGH)
      end
      if ((num_of_bits_sent25 == (1 + cfg.char_len_val25)) && (cfg.parity_en25)) begin
        // sending25 "parity25 bit" if parity25 is enabled
        vif25.rxd25 = frame25.calc_parity25(cfg.char_len_val25, cfg.parity_mode25);
        `uvm_info(get_type_name(),
             $psprintf("Driver25 Sending25 Frame25 Parity25 bit:'b%b",
             frame25.calc_parity25(cfg.char_len_val25, cfg.parity_mode25)), UVM_HIGH)
      end
      if (num_of_bits_sent25 == (1 + cfg.char_len_val25 + cfg.parity_en25)) begin
        // sending25 "stop/error bits"
        for (int i = 0; i < cfg.nbstop25; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver25 Sending25 Frame25 Stop bit:'b%b",
               frame25.stop_bits25[i]), UVM_HIGH)
          wait (sample_clk25);
          if (frame25.error_bits25[i]) begin
            vif25.rxd25 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver25 intensionally25 corrupting25 Stop bit since25 error_bits25['b%b] is 'b%b", i, frame25.error_bits25[i]),
                 UVM_HIGH)
          end else
          vif25.rxd25 = frame25.stop_bits25[i];
          num_of_bits_sent25++;
          wait (!sample_clk25);
        end
      end
    num_of_bits_sent25++;
    wait (!sample_clk25);
    end
  end
  
  num_frames_sent25++;
  `uvm_info(get_type_name(),
       $psprintf("Frame25 **%0d** Sent25...", num_frames_sent25), UVM_MEDIUM)
  wait (sample_clk25);
  vif25.rxd25 = 1;

  `uvm_info(get_type_name(), "Frame25 complete...", UVM_MEDIUM)
  this.end_tr(frame25);
   
endtask : send_rx_frame25

//UVM report_phase
function void uart_rx_driver25::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART25 Frames25 Sent25:%0d", num_frames_sent25),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER25
