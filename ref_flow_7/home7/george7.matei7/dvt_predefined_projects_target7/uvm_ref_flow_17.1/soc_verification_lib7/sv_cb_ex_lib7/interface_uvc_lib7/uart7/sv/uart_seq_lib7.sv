/*-------------------------------------------------------------------------
File7 name   : uart_seq_lib7.sv
Title7       : sequence library file for uart7 uvc7
Project7     :
Created7     :
Description7 : describes7 all UART7 UVC7 sequences
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

//-------------------------------------------------
// SEQUENCE7: uart_base_seq7
//-------------------------------------------------
class uart_base_seq7 extends uvm_sequence #(uart_frame7);
  function new(string name="uart_base_seq7");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq7)
  `uvm_declare_p_sequencer(uart_sequencer7)

  // Use a base sequence to raise/drop7 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running7 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq7

//-------------------------------------------------
// SEQUENCE7: uart_incr_payload_seq7
//-------------------------------------------------
class uart_incr_payload_seq7 extends uart_base_seq7;
    rand int unsigned cnt;
    rand bit [7:0] start_payload7;

    function new(string name="uart_incr_payload_seq7");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq7)
   `uvm_declare_p_sequencer(uart_sequencer7)

    constraint count_ct7 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART7 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload7 == (start_payload7 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq7

//-------------------------------------------------
// SEQUENCE7: uart_bad_parity_seq7
//-------------------------------------------------
class uart_bad_parity_seq7 extends uart_base_seq7;
    rand int unsigned cnt;
    rand bit [7:0] start_payload7;

    function new(string name="uart_bad_parity_seq7");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq7)
   `uvm_declare_p_sequencer(uart_sequencer7)

    constraint count_ct7 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART7 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create7 the frame7
        `uvm_create(req)
         // Nullify7 the constrain7 on the parity7
         req.default_parity_type7.constraint_mode(0);
   
         // Now7 send the packed with parity7 constrained7 to BAD_PARITY7
        `uvm_rand_send_with(req, { req.parity_type7 == BAD_PARITY7;})
      end
    endtask
endclass: uart_bad_parity_seq7

//-------------------------------------------------
// SEQUENCE7: uart_transmit_seq7
//-------------------------------------------------
class uart_transmit_seq7 extends uart_base_seq7;

   rand int unsigned num_of_tx7;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq7)
   `uvm_declare_p_sequencer(uart_sequencer7)
   
   function new(string name="uart_transmit_seq7");
      super.new(name);
   endfunction

   constraint num_of_tx_ct7 { num_of_tx7 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART7 sequencer: Executing %0d Frames7", num_of_tx7), UVM_LOW)
     for (int i = 0; i < num_of_tx7; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq7

//-------------------------------------------------
// SEQUENCE7: uart_no_activity_seq7
//-------------------------------------------------
class no_activity_seq7 extends uart_base_seq7;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq7)
  `uvm_declare_p_sequencer(uart_sequencer7)

  function new(string name="no_activity_seq7");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART7 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq7

//-------------------------------------------------
// SEQUENCE7: uart_short_transmit_seq7
//-------------------------------------------------
class uart_short_transmit_seq7 extends uart_base_seq7;

   rand int unsigned num_of_tx7;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq7)
   `uvm_declare_p_sequencer(uart_sequencer7)
   
   function new(string name="uart_short_transmit_seq7");
      super.new(name);
   endfunction

   constraint num_of_tx_ct7 { num_of_tx7 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART7 sequencer: Executing %0d Frames7", num_of_tx7), UVM_LOW)
     for (int i = 0; i < num_of_tx7; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq7
