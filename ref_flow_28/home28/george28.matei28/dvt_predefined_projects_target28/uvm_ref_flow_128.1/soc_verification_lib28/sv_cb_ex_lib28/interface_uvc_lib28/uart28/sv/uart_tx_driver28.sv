/*-------------------------------------------------------------------------
File28 name   : uart_tx_driver28.sv
Title28       : TX28 Driver28
Project28     :
Created28     :
Description28 : Describes28 UART28 Trasmit28 Driver28 for UART28 UVC28
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER28
`define UART_TX_DRIVER28

class uart_tx_driver28 extends uvm_driver #(uart_frame28) ;

  // The virtual interface used to drive28 and view28 HDL signals28.
  virtual interface uart_if28 vif28;

  // handle to  a cfg class
  uart_config28 cfg;

  bit sample_clk28;
  bit baud_clk28;
  bit [15:0] ua_brgr28;
  bit [7:0] ua_bdiv28;
  int num_of_bits_sent28;
  int num_frames_sent28;

  // Provide28 implementations28 of virtual methods28 such28 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver28)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk28, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk28, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr28, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv28, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor28 - required28 UVM syntax28
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional28 class methods28
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive28();
  extern virtual task gen_sample_rate28(ref bit [15:0] ua_brgr28, ref bit sample_clk28);
  extern virtual task send_tx_frame28(input uart_frame28 frame28);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver28

// UVM build_phase
function void uart_tx_driver28::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config28)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG28", "uart_config28 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver28::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if28)::get(this, "", "vif28", vif28))
   `uvm_error("NOVIF28",{"virtual interface must be set for: ",get_full_name(),".vif28"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver28::run_phase(uvm_phase phase);
  fork
    get_and_drive28();
    gen_sample_rate28(ua_brgr28, sample_clk28);
  join
endtask : run_phase

// reset
task uart_tx_driver28::reset();
  @(negedge vif28.reset);
  `uvm_info(get_type_name(), "Reset28 Asserted28", UVM_MEDIUM)
   vif28.txd28 = 1;        //Transmit28 Data
   vif28.rts_n28 = 0;      //Request28 to Send28
   vif28.dtr_n28 = 0;      //Data Terminal28 Ready28
   vif28.dcd_n28 = 0;      //Data Carrier28 Detect28
   vif28.baud_clk28 = 0;       //Baud28 Data
endtask : reset

//  get_and28 drive28
task uart_tx_driver28::get_and_drive28();
  while (1) begin
    reset();
    fork
      @(negedge vif28.reset)
        `uvm_info(get_type_name(), "Reset28 asserted28", UVM_LOW)
    begin
      forever begin
        @(posedge vif28.clock28 iff (vif28.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame28(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If28 we28 are in the middle28 of a transfer28, need to end the tx28. Also28,
    //do any reset cleanup28 here28. The only way28 we28 got28 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive28

task uart_tx_driver28::gen_sample_rate28(ref bit [15:0] ua_brgr28, ref bit sample_clk28);
  forever begin
    @(posedge vif28.clock28);
    if (!vif28.reset) begin
      ua_brgr28 = 0;
      sample_clk28 = 0;
    end else begin
      if (ua_brgr28 == ({cfg.baud_rate_div28, cfg.baud_rate_gen28})) begin
        ua_brgr28 = 0;
        sample_clk28 = 1;
      end else begin
        sample_clk28 = 0;
        ua_brgr28++;
      end
    end
  end
endtask : gen_sample_rate28

// -------------------
// send_tx_frame28
// -------------------
task uart_tx_driver28::send_tx_frame28(input uart_frame28 frame28);
  bit [7:0] payload_byte28;
  num_of_bits_sent28 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver28 Sending28 TX28 Frame28...\n%s", frame28.sprint()),
            UVM_HIGH)
 
  repeat (frame28.transmit_delay28)
    @(posedge vif28.clock28);
  void'(this.begin_tr(frame28));
   
  wait((!cfg.rts_en28)||(!vif28.cts_n28));
  `uvm_info(get_type_name(), "Driver28 - Modem28 RTS28 or CTS28 asserted28", UVM_HIGH)

  while (num_of_bits_sent28 <= (1 + cfg.char_len_val28 + cfg.parity_en28 + cfg.nbstop28)) begin
    @(posedge vif28.clock28);
    #1;
    if (sample_clk28) begin
      if (num_of_bits_sent28 == 0) begin
        // Start28 sending28 tx_frame28 with "start bit"
        vif28.txd28 = frame28.start_bit28;
        `uvm_info(get_type_name(),
                  $psprintf("Driver28 Sending28 Frame28 SOP28: %b", frame28.start_bit28),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent28 > 0) && (num_of_bits_sent28 < (1 + cfg.char_len_val28))) begin
        // sending28 "data bits" 
        payload_byte28 = frame28.payload28[num_of_bits_sent28-1] ;
        vif28.txd28 = frame28.payload28[num_of_bits_sent28-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver28 Sending28 Frame28 data bit number28:%0d value:'b%b",
             (num_of_bits_sent28-1), payload_byte28), UVM_HIGH)
      end
      if ((num_of_bits_sent28 == (1 + cfg.char_len_val28)) && (cfg.parity_en28)) begin
        // sending28 "parity28 bit" if parity28 is enabled
        vif28.txd28 = frame28.calc_parity28(cfg.char_len_val28, cfg.parity_mode28);
        `uvm_info(get_type_name(),
             $psprintf("Driver28 Sending28 Frame28 Parity28 bit:'b%b",
             frame28.calc_parity28(cfg.char_len_val28, cfg.parity_mode28)), UVM_HIGH)
      end
      if (num_of_bits_sent28 == (1 + cfg.char_len_val28 + cfg.parity_en28)) begin
        // sending28 "stop/error bits"
        for (int i = 0; i < cfg.nbstop28; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver28 Sending28 Frame28 Stop bit:'b%b",
               frame28.stop_bits28[i]), UVM_HIGH)
          wait (sample_clk28);
          if (frame28.error_bits28[i]) begin
            vif28.txd28 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver28 intensionally28 corrupting28 Stop bit since28 error_bits28['b%b] is 'b%b", i, frame28.error_bits28[i]),
                 UVM_HIGH)
          end else
          vif28.txd28 = frame28.stop_bits28[i];
          num_of_bits_sent28++;
          wait (!sample_clk28);
        end
      end
    num_of_bits_sent28++;
    wait (!sample_clk28);
    end
  end
  
  num_frames_sent28++;
  `uvm_info(get_type_name(),
       $psprintf("Frame28 **%0d** Sent28...", num_frames_sent28), UVM_MEDIUM)
  wait (sample_clk28);
  vif28.txd28 = 1;

  `uvm_info(get_type_name(), "Frame28 complete...", UVM_MEDIUM)
  this.end_tr(frame28);
   
endtask : send_tx_frame28

//UVM report_phase
function void uart_tx_driver28::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART28 Frames28 Sent28:%0d", num_frames_sent28),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER28
