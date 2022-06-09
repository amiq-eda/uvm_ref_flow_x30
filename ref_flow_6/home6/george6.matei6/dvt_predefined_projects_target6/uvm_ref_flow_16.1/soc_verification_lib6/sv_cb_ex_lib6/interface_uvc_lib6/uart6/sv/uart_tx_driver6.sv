/*-------------------------------------------------------------------------
File6 name   : uart_tx_driver6.sv
Title6       : TX6 Driver6
Project6     :
Created6     :
Description6 : Describes6 UART6 Trasmit6 Driver6 for UART6 UVC6
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER6
`define UART_TX_DRIVER6

class uart_tx_driver6 extends uvm_driver #(uart_frame6) ;

  // The virtual interface used to drive6 and view6 HDL signals6.
  virtual interface uart_if6 vif6;

  // handle to  a cfg class
  uart_config6 cfg;

  bit sample_clk6;
  bit baud_clk6;
  bit [15:0] ua_brgr6;
  bit [7:0] ua_bdiv6;
  int num_of_bits_sent6;
  int num_frames_sent6;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver6)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk6, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk6, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr6, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv6, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor6 - required6 UVM syntax6
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional6 class methods6
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive6();
  extern virtual task gen_sample_rate6(ref bit [15:0] ua_brgr6, ref bit sample_clk6);
  extern virtual task send_tx_frame6(input uart_frame6 frame6);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver6

// UVM build_phase
function void uart_tx_driver6::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config6)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG6", "uart_config6 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver6::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if6)::get(this, "", "vif6", vif6))
   `uvm_error("NOVIF6",{"virtual interface must be set for: ",get_full_name(),".vif6"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver6::run_phase(uvm_phase phase);
  fork
    get_and_drive6();
    gen_sample_rate6(ua_brgr6, sample_clk6);
  join
endtask : run_phase

// reset
task uart_tx_driver6::reset();
  @(negedge vif6.reset);
  `uvm_info(get_type_name(), "Reset6 Asserted6", UVM_MEDIUM)
   vif6.txd6 = 1;        //Transmit6 Data
   vif6.rts_n6 = 0;      //Request6 to Send6
   vif6.dtr_n6 = 0;      //Data Terminal6 Ready6
   vif6.dcd_n6 = 0;      //Data Carrier6 Detect6
   vif6.baud_clk6 = 0;       //Baud6 Data
endtask : reset

//  get_and6 drive6
task uart_tx_driver6::get_and_drive6();
  while (1) begin
    reset();
    fork
      @(negedge vif6.reset)
        `uvm_info(get_type_name(), "Reset6 asserted6", UVM_LOW)
    begin
      forever begin
        @(posedge vif6.clock6 iff (vif6.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame6(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If6 we6 are in the middle6 of a transfer6, need to end the tx6. Also6,
    //do any reset cleanup6 here6. The only way6 we6 got6 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive6

task uart_tx_driver6::gen_sample_rate6(ref bit [15:0] ua_brgr6, ref bit sample_clk6);
  forever begin
    @(posedge vif6.clock6);
    if (!vif6.reset) begin
      ua_brgr6 = 0;
      sample_clk6 = 0;
    end else begin
      if (ua_brgr6 == ({cfg.baud_rate_div6, cfg.baud_rate_gen6})) begin
        ua_brgr6 = 0;
        sample_clk6 = 1;
      end else begin
        sample_clk6 = 0;
        ua_brgr6++;
      end
    end
  end
endtask : gen_sample_rate6

// -------------------
// send_tx_frame6
// -------------------
task uart_tx_driver6::send_tx_frame6(input uart_frame6 frame6);
  bit [7:0] payload_byte6;
  num_of_bits_sent6 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver6 Sending6 TX6 Frame6...\n%s", frame6.sprint()),
            UVM_HIGH)
 
  repeat (frame6.transmit_delay6)
    @(posedge vif6.clock6);
  void'(this.begin_tr(frame6));
   
  wait((!cfg.rts_en6)||(!vif6.cts_n6));
  `uvm_info(get_type_name(), "Driver6 - Modem6 RTS6 or CTS6 asserted6", UVM_HIGH)

  while (num_of_bits_sent6 <= (1 + cfg.char_len_val6 + cfg.parity_en6 + cfg.nbstop6)) begin
    @(posedge vif6.clock6);
    #1;
    if (sample_clk6) begin
      if (num_of_bits_sent6 == 0) begin
        // Start6 sending6 tx_frame6 with "start bit"
        vif6.txd6 = frame6.start_bit6;
        `uvm_info(get_type_name(),
                  $psprintf("Driver6 Sending6 Frame6 SOP6: %b", frame6.start_bit6),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent6 > 0) && (num_of_bits_sent6 < (1 + cfg.char_len_val6))) begin
        // sending6 "data bits" 
        payload_byte6 = frame6.payload6[num_of_bits_sent6-1] ;
        vif6.txd6 = frame6.payload6[num_of_bits_sent6-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver6 Sending6 Frame6 data bit number6:%0d value:'b%b",
             (num_of_bits_sent6-1), payload_byte6), UVM_HIGH)
      end
      if ((num_of_bits_sent6 == (1 + cfg.char_len_val6)) && (cfg.parity_en6)) begin
        // sending6 "parity6 bit" if parity6 is enabled
        vif6.txd6 = frame6.calc_parity6(cfg.char_len_val6, cfg.parity_mode6);
        `uvm_info(get_type_name(),
             $psprintf("Driver6 Sending6 Frame6 Parity6 bit:'b%b",
             frame6.calc_parity6(cfg.char_len_val6, cfg.parity_mode6)), UVM_HIGH)
      end
      if (num_of_bits_sent6 == (1 + cfg.char_len_val6 + cfg.parity_en6)) begin
        // sending6 "stop/error bits"
        for (int i = 0; i < cfg.nbstop6; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver6 Sending6 Frame6 Stop bit:'b%b",
               frame6.stop_bits6[i]), UVM_HIGH)
          wait (sample_clk6);
          if (frame6.error_bits6[i]) begin
            vif6.txd6 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver6 intensionally6 corrupting6 Stop bit since6 error_bits6['b%b] is 'b%b", i, frame6.error_bits6[i]),
                 UVM_HIGH)
          end else
          vif6.txd6 = frame6.stop_bits6[i];
          num_of_bits_sent6++;
          wait (!sample_clk6);
        end
      end
    num_of_bits_sent6++;
    wait (!sample_clk6);
    end
  end
  
  num_frames_sent6++;
  `uvm_info(get_type_name(),
       $psprintf("Frame6 **%0d** Sent6...", num_frames_sent6), UVM_MEDIUM)
  wait (sample_clk6);
  vif6.txd6 = 1;

  `uvm_info(get_type_name(), "Frame6 complete...", UVM_MEDIUM)
  this.end_tr(frame6);
   
endtask : send_tx_frame6

//UVM report_phase
function void uart_tx_driver6::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART6 Frames6 Sent6:%0d", num_frames_sent6),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER6
