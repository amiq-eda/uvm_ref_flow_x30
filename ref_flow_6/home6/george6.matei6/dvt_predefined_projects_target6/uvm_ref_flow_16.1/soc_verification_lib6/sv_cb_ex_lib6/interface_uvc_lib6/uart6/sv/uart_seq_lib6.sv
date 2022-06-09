/*-------------------------------------------------------------------------
File6 name   : uart_seq_lib6.sv
Title6       : sequence library file for uart6 uvc6
Project6     :
Created6     :
Description6 : describes6 all UART6 UVC6 sequences
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

//-------------------------------------------------
// SEQUENCE6: uart_base_seq6
//-------------------------------------------------
class uart_base_seq6 extends uvm_sequence #(uart_frame6);
  function new(string name="uart_base_seq6");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq6)
  `uvm_declare_p_sequencer(uart_sequencer6)

  // Use a base sequence to raise/drop6 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running6 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq6

//-------------------------------------------------
// SEQUENCE6: uart_incr_payload_seq6
//-------------------------------------------------
class uart_incr_payload_seq6 extends uart_base_seq6;
    rand int unsigned cnt;
    rand bit [7:0] start_payload6;

    function new(string name="uart_incr_payload_seq6");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq6)
   `uvm_declare_p_sequencer(uart_sequencer6)

    constraint count_ct6 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART6 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload6 == (start_payload6 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq6

//-------------------------------------------------
// SEQUENCE6: uart_bad_parity_seq6
//-------------------------------------------------
class uart_bad_parity_seq6 extends uart_base_seq6;
    rand int unsigned cnt;
    rand bit [7:0] start_payload6;

    function new(string name="uart_bad_parity_seq6");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq6)
   `uvm_declare_p_sequencer(uart_sequencer6)

    constraint count_ct6 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART6 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create6 the frame6
        `uvm_create(req)
         // Nullify6 the constrain6 on the parity6
         req.default_parity_type6.constraint_mode(0);
   
         // Now6 send the packed with parity6 constrained6 to BAD_PARITY6
        `uvm_rand_send_with(req, { req.parity_type6 == BAD_PARITY6;})
      end
    endtask
endclass: uart_bad_parity_seq6

//-------------------------------------------------
// SEQUENCE6: uart_transmit_seq6
//-------------------------------------------------
class uart_transmit_seq6 extends uart_base_seq6;

   rand int unsigned num_of_tx6;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq6)
   `uvm_declare_p_sequencer(uart_sequencer6)
   
   function new(string name="uart_transmit_seq6");
      super.new(name);
   endfunction

   constraint num_of_tx_ct6 { num_of_tx6 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART6 sequencer: Executing %0d Frames6", num_of_tx6), UVM_LOW)
     for (int i = 0; i < num_of_tx6; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq6

//-------------------------------------------------
// SEQUENCE6: uart_no_activity_seq6
//-------------------------------------------------
class no_activity_seq6 extends uart_base_seq6;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq6)
  `uvm_declare_p_sequencer(uart_sequencer6)

  function new(string name="no_activity_seq6");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART6 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq6

//-------------------------------------------------
// SEQUENCE6: uart_short_transmit_seq6
//-------------------------------------------------
class uart_short_transmit_seq6 extends uart_base_seq6;

   rand int unsigned num_of_tx6;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq6)
   `uvm_declare_p_sequencer(uart_sequencer6)
   
   function new(string name="uart_short_transmit_seq6");
      super.new(name);
   endfunction

   constraint num_of_tx_ct6 { num_of_tx6 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART6 sequencer: Executing %0d Frames6", num_of_tx6), UVM_LOW)
     for (int i = 0; i < num_of_tx6; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq6
