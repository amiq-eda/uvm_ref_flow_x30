/*-------------------------------------------------------------------------
File15 name   : uart_rx_driver15.sv
Title15       : RX15 Driver15
Project15     :
Created15     :
Description15 : Describes15 UART15 Receiver15 Driver15 for UART15 UVC15
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`ifndef UART_RX_DRIVER15
`define UART_RX_DRIVER15

class uart_rx_driver15 extends uvm_driver #(uart_frame15) ;

  // The virtual interface used to drive15 and view15 HDL signals15.
  virtual interface uart_if15 vif15;

  // handle to  a cfg class
  uart_config15 cfg;

  bit sample_clk15;
  bit [15:0] ua_brgr15;
  bit [7:0] ua_bdiv15;
  int num_of_bits_sent15;
  int num_frames_sent15;

  // Provide15 implementations15 of virtual methods15 such15 as get_type_name and create
  `uvm_component_utils_begin(uart_rx_driver15)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(ua_brgr15, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv15, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor15 - required15 UVM syntax15
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional15 class methods15
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive15();
  extern virtual task gen_sample_rate15(ref bit [15:0] ua_brgr15, ref bit sample_clk15);
  extern virtual task send_rx_frame15(input uart_frame15 frame15);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_rx_driver15

// UVM build_phase
function void uart_rx_driver15::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config15)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG15", "uart_config15 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_rx_driver15::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if15)::get(this, "", "vif15", vif15))
   `uvm_error("NOVIF15",{"virtual interface must be set for: ",get_full_name(),".vif15"})
endfunction : connect_phase

//UVM run_phase
task uart_rx_driver15::run_phase(uvm_phase phase);
  fork
    get_and_drive15();
    gen_sample_rate15(ua_brgr15, sample_clk15);
  join
endtask : run_phase

// reset
task uart_rx_driver15::reset();
  @(negedge vif15.reset);
  `uvm_info(get_type_name(), "Reset15 Asserted15", UVM_MEDIUM)
   vif15.rxd15 = 1;        //Receive15 Data
   vif15.cts_n15 = 0;      //Clear to Send15
   vif15.dsr_n15 = 0;      //Data Set Ready15
   vif15.ri_n15 = 0;       //Ring15 Indicator15
   vif15.baud_clk15 = 0;   //Baud15 Clk15 - NOT15 USED15
endtask : reset

//  get_and15 drive15
task uart_rx_driver15::get_and_drive15();
  while (1) begin
    reset();
    fork
      @(negedge vif15.reset)
        `uvm_info(get_type_name(), "Reset15 asserted15", UVM_LOW)
    begin
      forever begin
        @(posedge vif15.clock15 iff (vif15.reset))
        seq_item_port.get_next_item(req);
        send_rx_frame15(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If15 we15 are in the middle15 of a transfer15, need to end the rx15. Also15,
    //do any reset cleanup15 here15. The only way15 we15 got15 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive15

task uart_rx_driver15::gen_sample_rate15(ref bit [15:0] ua_brgr15, ref bit sample_clk15);
  forever begin
    @(posedge vif15.clock15);
    if (!vif15.reset) begin
      ua_brgr15 = 0;
      sample_clk15 = 0;
    end else begin
      if (ua_brgr15 == ({cfg.baud_rate_div15, cfg.baud_rate_gen15})) begin
        ua_brgr15 = 0;
        sample_clk15 = 1;
      end else begin
        sample_clk15 = 0;
        ua_brgr15++;
      end
    end
  end
endtask : gen_sample_rate15

// -------------------
// send_rx_frame15
// -------------------
task uart_rx_driver15::send_rx_frame15(input uart_frame15 frame15);
  bit [7:0] payload_byte15;
  num_of_bits_sent15 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver15 Sending15 RX15 Frame15...\n%s", frame15.sprint()),
            UVM_HIGH)
 
  repeat (frame15.transmit_delay15)
    @(posedge vif15.clock15);
  void'(this.begin_tr(frame15));
   
  wait((!cfg.rts_en15)||(!vif15.cts_n15));
  `uvm_info(get_type_name(), "Driver15 - Modem15 RTS15 or CTS15 asserted15", UVM_HIGH)

  while (num_of_bits_sent15 <= (1 + cfg.char_len_val15 + cfg.parity_en15 + cfg.nbstop15)) begin
    @(posedge vif15.clock15);
    #1;
    if (sample_clk15) begin
      if (num_of_bits_sent15 == 0) begin
        // Start15 sending15 rx_frame15 with "start bit"
        vif15.rxd15 = frame15.start_bit15;
        `uvm_info(get_type_name(),
                  $psprintf("Driver15 Sending15 Frame15 SOP15: %b", frame15.start_bit15),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent15 > 0) && (num_of_bits_sent15 < (1 + cfg.char_len_val15))) begin
        // sending15 "data bits" 
        payload_byte15 = frame15.payload15[num_of_bits_sent15-1] ;
        vif15.rxd15 = frame15.payload15[num_of_bits_sent15-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver15 Sending15 Frame15 data bit number15:%0d value:'b%b",
             (num_of_bits_sent15-1), payload_byte15), UVM_HIGH)
      end
      if ((num_of_bits_sent15 == (1 + cfg.char_len_val15)) && (cfg.parity_en15)) begin
        // sending15 "parity15 bit" if parity15 is enabled
        vif15.rxd15 = frame15.calc_parity15(cfg.char_len_val15, cfg.parity_mode15);
        `uvm_info(get_type_name(),
             $psprintf("Driver15 Sending15 Frame15 Parity15 bit:'b%b",
             frame15.calc_parity15(cfg.char_len_val15, cfg.parity_mode15)), UVM_HIGH)
      end
      if (num_of_bits_sent15 == (1 + cfg.char_len_val15 + cfg.parity_en15)) begin
        // sending15 "stop/error bits"
        for (int i = 0; i < cfg.nbstop15; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver15 Sending15 Frame15 Stop bit:'b%b",
               frame15.stop_bits15[i]), UVM_HIGH)
          wait (sample_clk15);
          if (frame15.error_bits15[i]) begin
            vif15.rxd15 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver15 intensionally15 corrupting15 Stop bit since15 error_bits15['b%b] is 'b%b", i, frame15.error_bits15[i]),
                 UVM_HIGH)
          end else
          vif15.rxd15 = frame15.stop_bits15[i];
          num_of_bits_sent15++;
          wait (!sample_clk15);
        end
      end
    num_of_bits_sent15++;
    wait (!sample_clk15);
    end
  end
  
  num_frames_sent15++;
  `uvm_info(get_type_name(),
       $psprintf("Frame15 **%0d** Sent15...", num_frames_sent15), UVM_MEDIUM)
  wait (sample_clk15);
  vif15.rxd15 = 1;

  `uvm_info(get_type_name(), "Frame15 complete...", UVM_MEDIUM)
  this.end_tr(frame15);
   
endtask : send_rx_frame15

//UVM report_phase
function void uart_rx_driver15::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART15 Frames15 Sent15:%0d", num_frames_sent15),
       UVM_LOW )
endfunction : report_phase

`endif // UART_RX_DRIVER15
