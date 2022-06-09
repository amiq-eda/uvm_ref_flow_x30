/*-------------------------------------------------------------------------
File22 name   : uart_seq_lib22.sv
Title22       : sequence library file for uart22 uvc22
Project22     :
Created22     :
Description22 : describes22 all UART22 UVC22 sequences
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE22: uart_base_seq22
//-------------------------------------------------
class uart_base_seq22 extends uvm_sequence #(uart_frame22);
  function new(string name="uart_base_seq22");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq22)
  `uvm_declare_p_sequencer(uart_sequencer22)

  // Use a base sequence to raise/drop22 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running22 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq22

//-------------------------------------------------
// SEQUENCE22: uart_incr_payload_seq22
//-------------------------------------------------
class uart_incr_payload_seq22 extends uart_base_seq22;
    rand int unsigned cnt;
    rand bit [7:0] start_payload22;

    function new(string name="uart_incr_payload_seq22");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq22)
   `uvm_declare_p_sequencer(uart_sequencer22)

    constraint count_ct22 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART22 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload22 == (start_payload22 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq22

//-------------------------------------------------
// SEQUENCE22: uart_bad_parity_seq22
//-------------------------------------------------
class uart_bad_parity_seq22 extends uart_base_seq22;
    rand int unsigned cnt;
    rand bit [7:0] start_payload22;

    function new(string name="uart_bad_parity_seq22");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq22)
   `uvm_declare_p_sequencer(uart_sequencer22)

    constraint count_ct22 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART22 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create22 the frame22
        `uvm_create(req)
         // Nullify22 the constrain22 on the parity22
         req.default_parity_type22.constraint_mode(0);
   
         // Now22 send the packed with parity22 constrained22 to BAD_PARITY22
        `uvm_rand_send_with(req, { req.parity_type22 == BAD_PARITY22;})
      end
    endtask
endclass: uart_bad_parity_seq22

//-------------------------------------------------
// SEQUENCE22: uart_transmit_seq22
//-------------------------------------------------
class uart_transmit_seq22 extends uart_base_seq22;

   rand int unsigned num_of_tx22;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq22)
   `uvm_declare_p_sequencer(uart_sequencer22)
   
   function new(string name="uart_transmit_seq22");
      super.new(name);
   endfunction

   constraint num_of_tx_ct22 { num_of_tx22 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART22 sequencer: Executing %0d Frames22", num_of_tx22), UVM_LOW)
     for (int i = 0; i < num_of_tx22; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq22

//-------------------------------------------------
// SEQUENCE22: uart_no_activity_seq22
//-------------------------------------------------
class no_activity_seq22 extends uart_base_seq22;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq22)
  `uvm_declare_p_sequencer(uart_sequencer22)

  function new(string name="no_activity_seq22");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART22 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq22

//-------------------------------------------------
// SEQUENCE22: uart_short_transmit_seq22
//-------------------------------------------------
class uart_short_transmit_seq22 extends uart_base_seq22;

   rand int unsigned num_of_tx22;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq22)
   `uvm_declare_p_sequencer(uart_sequencer22)
   
   function new(string name="uart_short_transmit_seq22");
      super.new(name);
   endfunction

   constraint num_of_tx_ct22 { num_of_tx22 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART22 sequencer: Executing %0d Frames22", num_of_tx22), UVM_LOW)
     for (int i = 0; i < num_of_tx22; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq22
