/*-------------------------------------------------------------------------
File7 name   : uart_tx_driver7.sv
Title7       : TX7 Driver7
Project7     :
Created7     :
Description7 : Describes7 UART7 Trasmit7 Driver7 for UART7 UVC7
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER7
`define UART_TX_DRIVER7

class uart_tx_driver7 extends uvm_driver #(uart_frame7) ;

  // The virtual interface used to drive7 and view7 HDL signals7.
  virtual interface uart_if7 vif7;

  // handle to  a cfg class
  uart_config7 cfg;

  bit sample_clk7;
  bit baud_clk7;
  bit [15:0] ua_brgr7;
  bit [7:0] ua_bdiv7;
  int num_of_bits_sent7;
  int num_frames_sent7;

  // Provide7 implementations7 of virtual methods7 such7 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver7)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk7, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk7, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr7, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv7, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor7 - required7 UVM syntax7
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional7 class methods7
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive7();
  extern virtual task gen_sample_rate7(ref bit [15:0] ua_brgr7, ref bit sample_clk7);
  extern virtual task send_tx_frame7(input uart_frame7 frame7);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver7

// UVM build_phase
function void uart_tx_driver7::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config7)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG7", "uart_config7 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver7::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if7)::get(this, "", "vif7", vif7))
   `uvm_error("NOVIF7",{"virtual interface must be set for: ",get_full_name(),".vif7"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver7::run_phase(uvm_phase phase);
  fork
    get_and_drive7();
    gen_sample_rate7(ua_brgr7, sample_clk7);
  join
endtask : run_phase

// reset
task uart_tx_driver7::reset();
  @(negedge vif7.reset);
  `uvm_info(get_type_name(), "Reset7 Asserted7", UVM_MEDIUM)
   vif7.txd7 = 1;        //Transmit7 Data
   vif7.rts_n7 = 0;      //Request7 to Send7
   vif7.dtr_n7 = 0;      //Data Terminal7 Ready7
   vif7.dcd_n7 = 0;      //Data Carrier7 Detect7
   vif7.baud_clk7 = 0;       //Baud7 Data
endtask : reset

//  get_and7 drive7
task uart_tx_driver7::get_and_drive7();
  while (1) begin
    reset();
    fork
      @(negedge vif7.reset)
        `uvm_info(get_type_name(), "Reset7 asserted7", UVM_LOW)
    begin
      forever begin
        @(posedge vif7.clock7 iff (vif7.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame7(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If7 we7 are in the middle7 of a transfer7, need to end the tx7. Also7,
    //do any reset cleanup7 here7. The only way7 we7 got7 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive7

task uart_tx_driver7::gen_sample_rate7(ref bit [15:0] ua_brgr7, ref bit sample_clk7);
  forever begin
    @(posedge vif7.clock7);
    if (!vif7.reset) begin
      ua_brgr7 = 0;
      sample_clk7 = 0;
    end else begin
      if (ua_brgr7 == ({cfg.baud_rate_div7, cfg.baud_rate_gen7})) begin
        ua_brgr7 = 0;
        sample_clk7 = 1;
      end else begin
        sample_clk7 = 0;
        ua_brgr7++;
      end
    end
  end
endtask : gen_sample_rate7

// -------------------
// send_tx_frame7
// -------------------
task uart_tx_driver7::send_tx_frame7(input uart_frame7 frame7);
  bit [7:0] payload_byte7;
  num_of_bits_sent7 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver7 Sending7 TX7 Frame7...\n%s", frame7.sprint()),
            UVM_HIGH)
 
  repeat (frame7.transmit_delay7)
    @(posedge vif7.clock7);
  void'(this.begin_tr(frame7));
   
  wait((!cfg.rts_en7)||(!vif7.cts_n7));
  `uvm_info(get_type_name(), "Driver7 - Modem7 RTS7 or CTS7 asserted7", UVM_HIGH)

  while (num_of_bits_sent7 <= (1 + cfg.char_len_val7 + cfg.parity_en7 + cfg.nbstop7)) begin
    @(posedge vif7.clock7);
    #1;
    if (sample_clk7) begin
      if (num_of_bits_sent7 == 0) begin
        // Start7 sending7 tx_frame7 with "start bit"
        vif7.txd7 = frame7.start_bit7;
        `uvm_info(get_type_name(),
                  $psprintf("Driver7 Sending7 Frame7 SOP7: %b", frame7.start_bit7),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent7 > 0) && (num_of_bits_sent7 < (1 + cfg.char_len_val7))) begin
        // sending7 "data bits" 
        payload_byte7 = frame7.payload7[num_of_bits_sent7-1] ;
        vif7.txd7 = frame7.payload7[num_of_bits_sent7-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver7 Sending7 Frame7 data bit number7:%0d value:'b%b",
             (num_of_bits_sent7-1), payload_byte7), UVM_HIGH)
      end
      if ((num_of_bits_sent7 == (1 + cfg.char_len_val7)) && (cfg.parity_en7)) begin
        // sending7 "parity7 bit" if parity7 is enabled
        vif7.txd7 = frame7.calc_parity7(cfg.char_len_val7, cfg.parity_mode7);
        `uvm_info(get_type_name(),
             $psprintf("Driver7 Sending7 Frame7 Parity7 bit:'b%b",
             frame7.calc_parity7(cfg.char_len_val7, cfg.parity_mode7)), UVM_HIGH)
      end
      if (num_of_bits_sent7 == (1 + cfg.char_len_val7 + cfg.parity_en7)) begin
        // sending7 "stop/error bits"
        for (int i = 0; i < cfg.nbstop7; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver7 Sending7 Frame7 Stop bit:'b%b",
               frame7.stop_bits7[i]), UVM_HIGH)
          wait (sample_clk7);
          if (frame7.error_bits7[i]) begin
            vif7.txd7 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver7 intensionally7 corrupting7 Stop bit since7 error_bits7['b%b] is 'b%b", i, frame7.error_bits7[i]),
                 UVM_HIGH)
          end else
          vif7.txd7 = frame7.stop_bits7[i];
          num_of_bits_sent7++;
          wait (!sample_clk7);
        end
      end
    num_of_bits_sent7++;
    wait (!sample_clk7);
    end
  end
  
  num_frames_sent7++;
  `uvm_info(get_type_name(),
       $psprintf("Frame7 **%0d** Sent7...", num_frames_sent7), UVM_MEDIUM)
  wait (sample_clk7);
  vif7.txd7 = 1;

  `uvm_info(get_type_name(), "Frame7 complete...", UVM_MEDIUM)
  this.end_tr(frame7);
   
endtask : send_tx_frame7

//UVM report_phase
function void uart_tx_driver7::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART7 Frames7 Sent7:%0d", num_frames_sent7),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER7
