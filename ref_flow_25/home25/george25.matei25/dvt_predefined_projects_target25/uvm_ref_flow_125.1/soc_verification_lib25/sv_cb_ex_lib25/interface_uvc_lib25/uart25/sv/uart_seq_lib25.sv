/*-------------------------------------------------------------------------
File25 name   : uart_seq_lib25.sv
Title25       : sequence library file for uart25 uvc25
Project25     :
Created25     :
Description25 : describes25 all UART25 UVC25 sequences
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

//-------------------------------------------------
// SEQUENCE25: uart_base_seq25
//-------------------------------------------------
class uart_base_seq25 extends uvm_sequence #(uart_frame25);
  function new(string name="uart_base_seq25");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq25)
  `uvm_declare_p_sequencer(uart_sequencer25)

  // Use a base sequence to raise/drop25 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running25 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq25

//-------------------------------------------------
// SEQUENCE25: uart_incr_payload_seq25
//-------------------------------------------------
class uart_incr_payload_seq25 extends uart_base_seq25;
    rand int unsigned cnt;
    rand bit [7:0] start_payload25;

    function new(string name="uart_incr_payload_seq25");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq25)
   `uvm_declare_p_sequencer(uart_sequencer25)

    constraint count_ct25 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART25 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload25 == (start_payload25 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq25

//-------------------------------------------------
// SEQUENCE25: uart_bad_parity_seq25
//-------------------------------------------------
class uart_bad_parity_seq25 extends uart_base_seq25;
    rand int unsigned cnt;
    rand bit [7:0] start_payload25;

    function new(string name="uart_bad_parity_seq25");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq25)
   `uvm_declare_p_sequencer(uart_sequencer25)

    constraint count_ct25 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART25 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create25 the frame25
        `uvm_create(req)
         // Nullify25 the constrain25 on the parity25
         req.default_parity_type25.constraint_mode(0);
   
         // Now25 send the packed with parity25 constrained25 to BAD_PARITY25
        `uvm_rand_send_with(req, { req.parity_type25 == BAD_PARITY25;})
      end
    endtask
endclass: uart_bad_parity_seq25

//-------------------------------------------------
// SEQUENCE25: uart_transmit_seq25
//-------------------------------------------------
class uart_transmit_seq25 extends uart_base_seq25;

   rand int unsigned num_of_tx25;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq25)
   `uvm_declare_p_sequencer(uart_sequencer25)
   
   function new(string name="uart_transmit_seq25");
      super.new(name);
   endfunction

   constraint num_of_tx_ct25 { num_of_tx25 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART25 sequencer: Executing %0d Frames25", num_of_tx25), UVM_LOW)
     for (int i = 0; i < num_of_tx25; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq25

//-------------------------------------------------
// SEQUENCE25: uart_no_activity_seq25
//-------------------------------------------------
class no_activity_seq25 extends uart_base_seq25;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq25)
  `uvm_declare_p_sequencer(uart_sequencer25)

  function new(string name="no_activity_seq25");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART25 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq25

//-------------------------------------------------
// SEQUENCE25: uart_short_transmit_seq25
//-------------------------------------------------
class uart_short_transmit_seq25 extends uart_base_seq25;

   rand int unsigned num_of_tx25;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq25)
   `uvm_declare_p_sequencer(uart_sequencer25)
   
   function new(string name="uart_short_transmit_seq25");
      super.new(name);
   endfunction

   constraint num_of_tx_ct25 { num_of_tx25 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART25 sequencer: Executing %0d Frames25", num_of_tx25), UVM_LOW)
     for (int i = 0; i < num_of_tx25; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq25
