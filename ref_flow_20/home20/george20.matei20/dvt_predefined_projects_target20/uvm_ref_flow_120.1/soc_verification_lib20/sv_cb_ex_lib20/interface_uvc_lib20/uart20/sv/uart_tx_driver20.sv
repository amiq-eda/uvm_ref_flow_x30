/*-------------------------------------------------------------------------
File20 name   : uart_tx_driver20.sv
Title20       : TX20 Driver20
Project20     :
Created20     :
Description20 : Describes20 UART20 Trasmit20 Driver20 for UART20 UVC20
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER20
`define UART_TX_DRIVER20

class uart_tx_driver20 extends uvm_driver #(uart_frame20) ;

  // The virtual interface used to drive20 and view20 HDL signals20.
  virtual interface uart_if20 vif20;

  // handle to  a cfg class
  uart_config20 cfg;

  bit sample_clk20;
  bit baud_clk20;
  bit [15:0] ua_brgr20;
  bit [7:0] ua_bdiv20;
  int num_of_bits_sent20;
  int num_frames_sent20;

  // Provide20 implementations20 of virtual methods20 such20 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver20)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk20, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk20, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr20, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv20, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor20 - required20 UVM syntax20
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional20 class methods20
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive20();
  extern virtual task gen_sample_rate20(ref bit [15:0] ua_brgr20, ref bit sample_clk20);
  extern virtual task send_tx_frame20(input uart_frame20 frame20);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver20

// UVM build_phase
function void uart_tx_driver20::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config20)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG20", "uart_config20 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver20::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if20)::get(this, "", "vif20", vif20))
   `uvm_error("NOVIF20",{"virtual interface must be set for: ",get_full_name(),".vif20"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver20::run_phase(uvm_phase phase);
  fork
    get_and_drive20();
    gen_sample_rate20(ua_brgr20, sample_clk20);
  join
endtask : run_phase

// reset
task uart_tx_driver20::reset();
  @(negedge vif20.reset);
  `uvm_info(get_type_name(), "Reset20 Asserted20", UVM_MEDIUM)
   vif20.txd20 = 1;        //Transmit20 Data
   vif20.rts_n20 = 0;      //Request20 to Send20
   vif20.dtr_n20 = 0;      //Data Terminal20 Ready20
   vif20.dcd_n20 = 0;      //Data Carrier20 Detect20
   vif20.baud_clk20 = 0;       //Baud20 Data
endtask : reset

//  get_and20 drive20
task uart_tx_driver20::get_and_drive20();
  while (1) begin
    reset();
    fork
      @(negedge vif20.reset)
        `uvm_info(get_type_name(), "Reset20 asserted20", UVM_LOW)
    begin
      forever begin
        @(posedge vif20.clock20 iff (vif20.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame20(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If20 we20 are in the middle20 of a transfer20, need to end the tx20. Also20,
    //do any reset cleanup20 here20. The only way20 we20 got20 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive20

task uart_tx_driver20::gen_sample_rate20(ref bit [15:0] ua_brgr20, ref bit sample_clk20);
  forever begin
    @(posedge vif20.clock20);
    if (!vif20.reset) begin
      ua_brgr20 = 0;
      sample_clk20 = 0;
    end else begin
      if (ua_brgr20 == ({cfg.baud_rate_div20, cfg.baud_rate_gen20})) begin
        ua_brgr20 = 0;
        sample_clk20 = 1;
      end else begin
        sample_clk20 = 0;
        ua_brgr20++;
      end
    end
  end
endtask : gen_sample_rate20

// -------------------
// send_tx_frame20
// -------------------
task uart_tx_driver20::send_tx_frame20(input uart_frame20 frame20);
  bit [7:0] payload_byte20;
  num_of_bits_sent20 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver20 Sending20 TX20 Frame20...\n%s", frame20.sprint()),
            UVM_HIGH)
 
  repeat (frame20.transmit_delay20)
    @(posedge vif20.clock20);
  void'(this.begin_tr(frame20));
   
  wait((!cfg.rts_en20)||(!vif20.cts_n20));
  `uvm_info(get_type_name(), "Driver20 - Modem20 RTS20 or CTS20 asserted20", UVM_HIGH)

  while (num_of_bits_sent20 <= (1 + cfg.char_len_val20 + cfg.parity_en20 + cfg.nbstop20)) begin
    @(posedge vif20.clock20);
    #1;
    if (sample_clk20) begin
      if (num_of_bits_sent20 == 0) begin
        // Start20 sending20 tx_frame20 with "start bit"
        vif20.txd20 = frame20.start_bit20;
        `uvm_info(get_type_name(),
                  $psprintf("Driver20 Sending20 Frame20 SOP20: %b", frame20.start_bit20),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent20 > 0) && (num_of_bits_sent20 < (1 + cfg.char_len_val20))) begin
        // sending20 "data bits" 
        payload_byte20 = frame20.payload20[num_of_bits_sent20-1] ;
        vif20.txd20 = frame20.payload20[num_of_bits_sent20-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver20 Sending20 Frame20 data bit number20:%0d value:'b%b",
             (num_of_bits_sent20-1), payload_byte20), UVM_HIGH)
      end
      if ((num_of_bits_sent20 == (1 + cfg.char_len_val20)) && (cfg.parity_en20)) begin
        // sending20 "parity20 bit" if parity20 is enabled
        vif20.txd20 = frame20.calc_parity20(cfg.char_len_val20, cfg.parity_mode20);
        `uvm_info(get_type_name(),
             $psprintf("Driver20 Sending20 Frame20 Parity20 bit:'b%b",
             frame20.calc_parity20(cfg.char_len_val20, cfg.parity_mode20)), UVM_HIGH)
      end
      if (num_of_bits_sent20 == (1 + cfg.char_len_val20 + cfg.parity_en20)) begin
        // sending20 "stop/error bits"
        for (int i = 0; i < cfg.nbstop20; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver20 Sending20 Frame20 Stop bit:'b%b",
               frame20.stop_bits20[i]), UVM_HIGH)
          wait (sample_clk20);
          if (frame20.error_bits20[i]) begin
            vif20.txd20 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver20 intensionally20 corrupting20 Stop bit since20 error_bits20['b%b] is 'b%b", i, frame20.error_bits20[i]),
                 UVM_HIGH)
          end else
          vif20.txd20 = frame20.stop_bits20[i];
          num_of_bits_sent20++;
          wait (!sample_clk20);
        end
      end
    num_of_bits_sent20++;
    wait (!sample_clk20);
    end
  end
  
  num_frames_sent20++;
  `uvm_info(get_type_name(),
       $psprintf("Frame20 **%0d** Sent20...", num_frames_sent20), UVM_MEDIUM)
  wait (sample_clk20);
  vif20.txd20 = 1;

  `uvm_info(get_type_name(), "Frame20 complete...", UVM_MEDIUM)
  this.end_tr(frame20);
   
endtask : send_tx_frame20

//UVM report_phase
function void uart_tx_driver20::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART20 Frames20 Sent20:%0d", num_frames_sent20),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER20
