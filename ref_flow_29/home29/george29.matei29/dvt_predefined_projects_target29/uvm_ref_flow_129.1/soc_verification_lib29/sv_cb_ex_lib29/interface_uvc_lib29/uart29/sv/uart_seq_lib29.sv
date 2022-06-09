/*-------------------------------------------------------------------------
File29 name   : uart_seq_lib29.sv
Title29       : sequence library file for uart29 uvc29
Project29     :
Created29     :
Description29 : describes29 all UART29 UVC29 sequences
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE29: uart_base_seq29
//-------------------------------------------------
class uart_base_seq29 extends uvm_sequence #(uart_frame29);
  function new(string name="uart_base_seq29");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq29)
  `uvm_declare_p_sequencer(uart_sequencer29)

  // Use a base sequence to raise/drop29 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running29 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq29

//-------------------------------------------------
// SEQUENCE29: uart_incr_payload_seq29
//-------------------------------------------------
class uart_incr_payload_seq29 extends uart_base_seq29;
    rand int unsigned cnt;
    rand bit [7:0] start_payload29;

    function new(string name="uart_incr_payload_seq29");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq29)
   `uvm_declare_p_sequencer(uart_sequencer29)

    constraint count_ct29 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART29 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload29 == (start_payload29 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq29

//-------------------------------------------------
// SEQUENCE29: uart_bad_parity_seq29
//-------------------------------------------------
class uart_bad_parity_seq29 extends uart_base_seq29;
    rand int unsigned cnt;
    rand bit [7:0] start_payload29;

    function new(string name="uart_bad_parity_seq29");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq29)
   `uvm_declare_p_sequencer(uart_sequencer29)

    constraint count_ct29 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART29 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create29 the frame29
        `uvm_create(req)
         // Nullify29 the constrain29 on the parity29
         req.default_parity_type29.constraint_mode(0);
   
         // Now29 send the packed with parity29 constrained29 to BAD_PARITY29
        `uvm_rand_send_with(req, { req.parity_type29 == BAD_PARITY29;})
      end
    endtask
endclass: uart_bad_parity_seq29

//-------------------------------------------------
// SEQUENCE29: uart_transmit_seq29
//-------------------------------------------------
class uart_transmit_seq29 extends uart_base_seq29;

   rand int unsigned num_of_tx29;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq29)
   `uvm_declare_p_sequencer(uart_sequencer29)
   
   function new(string name="uart_transmit_seq29");
      super.new(name);
   endfunction

   constraint num_of_tx_ct29 { num_of_tx29 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART29 sequencer: Executing %0d Frames29", num_of_tx29), UVM_LOW)
     for (int i = 0; i < num_of_tx29; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq29

//-------------------------------------------------
// SEQUENCE29: uart_no_activity_seq29
//-------------------------------------------------
class no_activity_seq29 extends uart_base_seq29;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq29)
  `uvm_declare_p_sequencer(uart_sequencer29)

  function new(string name="no_activity_seq29");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART29 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq29

//-------------------------------------------------
// SEQUENCE29: uart_short_transmit_seq29
//-------------------------------------------------
class uart_short_transmit_seq29 extends uart_base_seq29;

   rand int unsigned num_of_tx29;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq29)
   `uvm_declare_p_sequencer(uart_sequencer29)
   
   function new(string name="uart_short_transmit_seq29");
      super.new(name);
   endfunction

   constraint num_of_tx_ct29 { num_of_tx29 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART29 sequencer: Executing %0d Frames29", num_of_tx29), UVM_LOW)
     for (int i = 0; i < num_of_tx29; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq29
