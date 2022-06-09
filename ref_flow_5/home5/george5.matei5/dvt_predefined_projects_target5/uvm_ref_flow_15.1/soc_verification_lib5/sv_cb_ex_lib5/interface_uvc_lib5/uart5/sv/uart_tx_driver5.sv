/*-------------------------------------------------------------------------
File5 name   : uart_tx_driver5.sv
Title5       : TX5 Driver5
Project5     :
Created5     :
Description5 : Describes5 UART5 Trasmit5 Driver5 for UART5 UVC5
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

`ifndef UART_TX_DRIVER5
`define UART_TX_DRIVER5

class uart_tx_driver5 extends uvm_driver #(uart_frame5) ;

  // The virtual interface used to drive5 and view5 HDL signals5.
  virtual interface uart_if5 vif5;

  // handle to  a cfg class
  uart_config5 cfg;

  bit sample_clk5;
  bit baud_clk5;
  bit [15:0] ua_brgr5;
  bit [7:0] ua_bdiv5;
  int num_of_bits_sent5;
  int num_frames_sent5;

  // Provide5 implementations5 of virtual methods5 such5 as get_type_name and create
  `uvm_component_utils_begin(uart_tx_driver5)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(sample_clk5, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk5, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr5, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv5, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  // Constructor5 - required5 UVM syntax5
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // Additional5 class methods5
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task get_and_drive5();
  extern virtual task gen_sample_rate5(ref bit [15:0] ua_brgr5, ref bit sample_clk5);
  extern virtual task send_tx_frame5(input uart_frame5 frame5);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : uart_tx_driver5

// UVM build_phase
function void uart_tx_driver5::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(cfg == null)
      if (!uvm_config_db#(uart_config5)::get(this, "", "cfg", cfg))
       `uvm_error("NOCONFIG5", "uart_config5 not set for this component")
endfunction : build_phase

//UVM connect_phase
function void uart_tx_driver5::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual uart_if5)::get(this, "", "vif5", vif5))
   `uvm_error("NOVIF5",{"virtual interface must be set for: ",get_full_name(),".vif5"})
endfunction : connect_phase

//UVM run_phase
task uart_tx_driver5::run_phase(uvm_phase phase);
  fork
    get_and_drive5();
    gen_sample_rate5(ua_brgr5, sample_clk5);
  join
endtask : run_phase

// reset
task uart_tx_driver5::reset();
  @(negedge vif5.reset);
  `uvm_info(get_type_name(), "Reset5 Asserted5", UVM_MEDIUM)
   vif5.txd5 = 1;        //Transmit5 Data
   vif5.rts_n5 = 0;      //Request5 to Send5
   vif5.dtr_n5 = 0;      //Data Terminal5 Ready5
   vif5.dcd_n5 = 0;      //Data Carrier5 Detect5
   vif5.baud_clk5 = 0;       //Baud5 Data
endtask : reset

//  get_and5 drive5
task uart_tx_driver5::get_and_drive5();
  while (1) begin
    reset();
    fork
      @(negedge vif5.reset)
        `uvm_info(get_type_name(), "Reset5 asserted5", UVM_LOW)
    begin
      forever begin
        @(posedge vif5.clock5 iff (vif5.reset))
        seq_item_port.get_next_item(req);
        send_tx_frame5(req);
        seq_item_port.item_done();
      end
    end
    join_any
    disable fork;
    //If5 we5 are in the middle5 of a transfer5, need to end the tx5. Also5,
    //do any reset cleanup5 here5. The only way5 we5 got5 to this point is via
    //a reset.
    if(req.is_active()) this.end_tr(req);
  end
endtask : get_and_drive5

task uart_tx_driver5::gen_sample_rate5(ref bit [15:0] ua_brgr5, ref bit sample_clk5);
  forever begin
    @(posedge vif5.clock5);
    if (!vif5.reset) begin
      ua_brgr5 = 0;
      sample_clk5 = 0;
    end else begin
      if (ua_brgr5 == ({cfg.baud_rate_div5, cfg.baud_rate_gen5})) begin
        ua_brgr5 = 0;
        sample_clk5 = 1;
      end else begin
        sample_clk5 = 0;
        ua_brgr5++;
      end
    end
  end
endtask : gen_sample_rate5

// -------------------
// send_tx_frame5
// -------------------
task uart_tx_driver5::send_tx_frame5(input uart_frame5 frame5);
  bit [7:0] payload_byte5;
  num_of_bits_sent5 = 0;

  `uvm_info(get_type_name(),
            $psprintf("Driver5 Sending5 TX5 Frame5...\n%s", frame5.sprint()),
            UVM_HIGH)
 
  repeat (frame5.transmit_delay5)
    @(posedge vif5.clock5);
  void'(this.begin_tr(frame5));
   
  wait((!cfg.rts_en5)||(!vif5.cts_n5));
  `uvm_info(get_type_name(), "Driver5 - Modem5 RTS5 or CTS5 asserted5", UVM_HIGH)

  while (num_of_bits_sent5 <= (1 + cfg.char_len_val5 + cfg.parity_en5 + cfg.nbstop5)) begin
    @(posedge vif5.clock5);
    #1;
    if (sample_clk5) begin
      if (num_of_bits_sent5 == 0) begin
        // Start5 sending5 tx_frame5 with "start bit"
        vif5.txd5 = frame5.start_bit5;
        `uvm_info(get_type_name(),
                  $psprintf("Driver5 Sending5 Frame5 SOP5: %b", frame5.start_bit5),
                  UVM_HIGH)
      end
      if ((num_of_bits_sent5 > 0) && (num_of_bits_sent5 < (1 + cfg.char_len_val5))) begin
        // sending5 "data bits" 
        payload_byte5 = frame5.payload5[num_of_bits_sent5-1] ;
        vif5.txd5 = frame5.payload5[num_of_bits_sent5-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver5 Sending5 Frame5 data bit number5:%0d value:'b%b",
             (num_of_bits_sent5-1), payload_byte5), UVM_HIGH)
      end
      if ((num_of_bits_sent5 == (1 + cfg.char_len_val5)) && (cfg.parity_en5)) begin
        // sending5 "parity5 bit" if parity5 is enabled
        vif5.txd5 = frame5.calc_parity5(cfg.char_len_val5, cfg.parity_mode5);
        `uvm_info(get_type_name(),
             $psprintf("Driver5 Sending5 Frame5 Parity5 bit:'b%b",
             frame5.calc_parity5(cfg.char_len_val5, cfg.parity_mode5)), UVM_HIGH)
      end
      if (num_of_bits_sent5 == (1 + cfg.char_len_val5 + cfg.parity_en5)) begin
        // sending5 "stop/error bits"
        for (int i = 0; i < cfg.nbstop5; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver5 Sending5 Frame5 Stop bit:'b%b",
               frame5.stop_bits5[i]), UVM_HIGH)
          wait (sample_clk5);
          if (frame5.error_bits5[i]) begin
            vif5.txd5 = 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver5 intensionally5 corrupting5 Stop bit since5 error_bits5['b%b] is 'b%b", i, frame5.error_bits5[i]),
                 UVM_HIGH)
          end else
          vif5.txd5 = frame5.stop_bits5[i];
          num_of_bits_sent5++;
          wait (!sample_clk5);
        end
      end
    num_of_bits_sent5++;
    wait (!sample_clk5);
    end
  end
  
  num_frames_sent5++;
  `uvm_info(get_type_name(),
       $psprintf("Frame5 **%0d** Sent5...", num_frames_sent5), UVM_MEDIUM)
  wait (sample_clk5);
  vif5.txd5 = 1;

  `uvm_info(get_type_name(), "Frame5 complete...", UVM_MEDIUM)
  this.end_tr(frame5);
   
endtask : send_tx_frame5

//UVM report_phase
function void uart_tx_driver5::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
       $psprintf("UART5 Frames5 Sent5:%0d", num_frames_sent5),
       UVM_LOW )
endfunction : report_phase

`endif // UART_TX_DRIVER5
