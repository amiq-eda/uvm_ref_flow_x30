/*-------------------------------------------------------------------------
File3 name   : uart_seq_lib3.sv
Title3       : sequence library file for uart3 uvc3
Project3     :
Created3     :
Description3 : describes3 all UART3 UVC3 sequences
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE3: uart_base_seq3
//-------------------------------------------------
class uart_base_seq3 extends uvm_sequence #(uart_frame3);
  function new(string name="uart_base_seq3");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq3)
  `uvm_declare_p_sequencer(uart_sequencer3)

  // Use a base sequence to raise/drop3 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running3 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq3

//-------------------------------------------------
// SEQUENCE3: uart_incr_payload_seq3
//-------------------------------------------------
class uart_incr_payload_seq3 extends uart_base_seq3;
    rand int unsigned cnt;
    rand bit [7:0] start_payload3;

    function new(string name="uart_incr_payload_seq3");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq3)
   `uvm_declare_p_sequencer(uart_sequencer3)

    constraint count_ct3 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART3 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload3 == (start_payload3 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq3

//-------------------------------------------------
// SEQUENCE3: uart_bad_parity_seq3
//-------------------------------------------------
class uart_bad_parity_seq3 extends uart_base_seq3;
    rand int unsigned cnt;
    rand bit [7:0] start_payload3;

    function new(string name="uart_bad_parity_seq3");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq3)
   `uvm_declare_p_sequencer(uart_sequencer3)

    constraint count_ct3 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART3 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create3 the frame3
        `uvm_create(req)
         // Nullify3 the constrain3 on the parity3
         req.default_parity_type3.constraint_mode(0);
   
         // Now3 send the packed with parity3 constrained3 to BAD_PARITY3
        `uvm_rand_send_with(req, { req.parity_type3 == BAD_PARITY3;})
      end
    endtask
endclass: uart_bad_parity_seq3

//-------------------------------------------------
// SEQUENCE3: uart_transmit_seq3
//-------------------------------------------------
class uart_transmit_seq3 extends uart_base_seq3;

   rand int unsigned num_of_tx3;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq3)
   `uvm_declare_p_sequencer(uart_sequencer3)
   
   function new(string name="uart_transmit_seq3");
      super.new(name);
   endfunction

   constraint num_of_tx_ct3 { num_of_tx3 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART3 sequencer: Executing %0d Frames3", num_of_tx3), UVM_LOW)
     for (int i = 0; i < num_of_tx3; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq3

//-------------------------------------------------
// SEQUENCE3: uart_no_activity_seq3
//-------------------------------------------------
class no_activity_seq3 extends uart_base_seq3;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq3)
  `uvm_declare_p_sequencer(uart_sequencer3)

  function new(string name="no_activity_seq3");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART3 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq3

//-------------------------------------------------
// SEQUENCE3: uart_short_transmit_seq3
//-------------------------------------------------
class uart_short_transmit_seq3 extends uart_base_seq3;

   rand int unsigned num_of_tx3;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq3)
   `uvm_declare_p_sequencer(uart_sequencer3)
   
   function new(string name="uart_short_transmit_seq3");
      super.new(name);
   endfunction

   constraint num_of_tx_ct3 { num_of_tx3 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART3 sequencer: Executing %0d Frames3", num_of_tx3), UVM_LOW)
     for (int i = 0; i < num_of_tx3; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq3
