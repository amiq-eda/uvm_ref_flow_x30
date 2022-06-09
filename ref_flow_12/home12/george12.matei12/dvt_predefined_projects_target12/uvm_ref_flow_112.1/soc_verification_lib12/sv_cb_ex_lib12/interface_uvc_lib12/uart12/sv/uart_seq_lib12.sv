/*-------------------------------------------------------------------------
File12 name   : uart_seq_lib12.sv
Title12       : sequence library file for uart12 uvc12
Project12     :
Created12     :
Description12 : describes12 all UART12 UVC12 sequences
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

//-------------------------------------------------
// SEQUENCE12: uart_base_seq12
//-------------------------------------------------
class uart_base_seq12 extends uvm_sequence #(uart_frame12);
  function new(string name="uart_base_seq12");
    super.new(name);
  endfunction

  `uvm_object_utils(uart_base_seq12)
  `uvm_declare_p_sequencer(uart_sequencer12)

  // Use a base sequence to raise/drop12 objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running12 sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : uart_base_seq12

//-------------------------------------------------
// SEQUENCE12: uart_incr_payload_seq12
//-------------------------------------------------
class uart_incr_payload_seq12 extends uart_base_seq12;
    rand int unsigned cnt;
    rand bit [7:0] start_payload12;

    function new(string name="uart_incr_payload_seq12");
      super.new(name);
    endfunction

   // register sequence with a sequencer 
   `uvm_object_utils(uart_incr_payload_seq12)
   `uvm_declare_p_sequencer(uart_sequencer12)

    constraint count_ct12 { cnt > 0; cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(), "UART12 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        `uvm_do_with(req, {req.payload12 == (start_payload12 +i*3)%256; })
      end
    endtask
endclass: uart_incr_payload_seq12

//-------------------------------------------------
// SEQUENCE12: uart_bad_parity_seq12
//-------------------------------------------------
class uart_bad_parity_seq12 extends uart_base_seq12;
    rand int unsigned cnt;
    rand bit [7:0] start_payload12;

    function new(string name="uart_bad_parity_seq12");
      super.new(name);
    endfunction
   // register sequence with a sequencer 
   `uvm_object_utils(uart_bad_parity_seq12)
   `uvm_declare_p_sequencer(uart_sequencer12)

    constraint count_ct12 {cnt <= 10;}

    virtual task body();
      `uvm_info(get_type_name(),  "UART12 sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create12 the frame12
        `uvm_create(req)
         // Nullify12 the constrain12 on the parity12
         req.default_parity_type12.constraint_mode(0);
   
         // Now12 send the packed with parity12 constrained12 to BAD_PARITY12
        `uvm_rand_send_with(req, { req.parity_type12 == BAD_PARITY12;})
      end
    endtask
endclass: uart_bad_parity_seq12

//-------------------------------------------------
// SEQUENCE12: uart_transmit_seq12
//-------------------------------------------------
class uart_transmit_seq12 extends uart_base_seq12;

   rand int unsigned num_of_tx12;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_transmit_seq12)
   `uvm_declare_p_sequencer(uart_sequencer12)
   
   function new(string name="uart_transmit_seq12");
      super.new(name);
   endfunction

   constraint num_of_tx_ct12 { num_of_tx12 <= 250; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART12 sequencer: Executing %0d Frames12", num_of_tx12), UVM_LOW)
     for (int i = 0; i < num_of_tx12; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_transmit_seq12

//-------------------------------------------------
// SEQUENCE12: uart_no_activity_seq12
//-------------------------------------------------
class no_activity_seq12 extends uart_base_seq12;
   // register sequence with a sequencer 
  `uvm_object_utils(no_activity_seq12)
  `uvm_declare_p_sequencer(uart_sequencer12)

  function new(string name="no_activity_seq12");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "UART12 sequencer executing sequence...", UVM_LOW)
  endtask
endclass : no_activity_seq12

//-------------------------------------------------
// SEQUENCE12: uart_short_transmit_seq12
//-------------------------------------------------
class uart_short_transmit_seq12 extends uart_base_seq12;

   rand int unsigned num_of_tx12;
   // register sequence with a sequencer 
   `uvm_object_utils(uart_short_transmit_seq12)
   `uvm_declare_p_sequencer(uart_sequencer12)
   
   function new(string name="uart_short_transmit_seq12");
      super.new(name);
   endfunction

   constraint num_of_tx_ct12 { num_of_tx12 inside {[2:10]}; }

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART12 sequencer: Executing %0d Frames12", num_of_tx12), UVM_LOW)
     for (int i = 0; i < num_of_tx12; i++) begin
        `uvm_do(req)
     end
   endtask: body
endclass: uart_short_transmit_seq12
