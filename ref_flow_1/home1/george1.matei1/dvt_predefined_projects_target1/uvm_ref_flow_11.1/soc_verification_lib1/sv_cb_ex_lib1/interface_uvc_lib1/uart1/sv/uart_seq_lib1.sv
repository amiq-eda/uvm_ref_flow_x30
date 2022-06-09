/*-------------------------------------------------------------------------
File1 name   : uart_seq_lib1.sv
Title1       : sequence library file for uart1 uvc1
Project1     :
Created1     :
Description1 : describes1 all UART1 UVC1 sequences
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE1: uart_base_seq1
//-------------------------------------------------
class uart_base_seq1 extends uvm_sequence #(uart_frame1);
  function new(string name="uart_base_seq1");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq1)
  `uvm_declare_p_sequencer(uart_sequencer1)

  // Use a base sequence to raise/drop1 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running1 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq1

//-------------------------------------------------
// SEQUENCE1: uart_incr_payload_seq1
//-------------------------------------------------
class uart_incr_payload_seq1 extends uart_base_seq1;
    rand int unsigned cnt;
    rand bit [7:0] start_payload1;

    function new(string name="uart_incr_payload_seq1");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq1)
   `uvm_declare_p_sequencer(uart_sequencer1)

    constraint count_ct1 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART1 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload1 == (start_payload1 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq1

//-------------------------------------------------
// SEQUENCE1: uart_bad_parity_seq1
//-------------------------------------------------
class uart_bad_parity_seq1 extends uart_base_seq1;
    rand int unsigned cnt;
    rand bit [7:0] start_payload1;

    function new(string name="uart_bad_parity_seq1");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq1)
   `uvm_declare_p_sequencer(uart_sequencer1)

    constraint count_ct1 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART1 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create1 the frame1
        `uvm_create(req)
         // Nullify1 the constrain1 on the parity1
         req.default_parity_type1.constraint_mode(0);
   
         // Now1 send the packed with parity1 constrained1 to BAD_PARITY1
        `uvm_rand_send_with(req, { req.parity_type1 == BAD_PARITY1;})
      end
    endtask
endclass: uart_bad_parity_seq1

//-------------------------------------------------
// SEQUENCE1: uart_transmit_seq1
//-------------------------------------------------
class uart_transmit_seq1 extends uart_base_seq1;

   rand int unsigned num_of_tx1;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq1)
   `uvm_declare_p_sequencer(uart_sequencer1)
   
   function new(string name="uart_transmit_seq1");
      super.new(name);
   endfunction

   constraint num_of_tx_ct1 { num_of_tx1 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART1 sequencer: Executing %0d Frames1", num_of_tx1), UVM_LOW)
     for (int i = 0; i < num_of_tx1; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq1

//-------------------------------------------------
// SEQUENCE1: uart_no_activity_seq1
//-------------------------------------------------
class no_activity_seq1 extends uart_base_seq1;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq1)
  `uvm_declare_p_sequencer(uart_sequencer1)

  function new(string name="no_activity_seq1");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART1 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq1

//-------------------------------------------------
// SEQUENCE1: uart_short_transmit_seq1
//-------------------------------------------------
class uart_short_transmit_seq1 extends uart_base_seq1;

   rand int unsigned num_of_tx1;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq1)
   `uvm_declare_p_sequencer(uart_sequencer1)
   
   function new(string name="uart_short_transmit_seq1");
      super.new(name);
   endfunction

   constraint num_of_tx_ct1 { num_of_tx1 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART1 sequencer: Executing %0d Frames1", num_of_tx1), UVM_LOW)
     for (int i = 0; i < num_of_tx1; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq1
