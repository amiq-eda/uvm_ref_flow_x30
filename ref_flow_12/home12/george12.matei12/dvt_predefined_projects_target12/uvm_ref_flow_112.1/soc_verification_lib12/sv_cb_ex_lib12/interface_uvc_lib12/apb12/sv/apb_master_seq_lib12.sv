/*******************************************************************************
  FILE : apb_master_seq_lib12.sv
*******************************************************************************/
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


`ifndef APB_MASTER_SEQ_LIB_SV12
`define APB_MASTER_SEQ_LIB_SV12

//------------------------------------------------------------------------------
// SEQUENCE12: read_byte_seq12
//------------------------------------------------------------------------------
class apb_master_base_seq12 extends uvm_sequence #(apb_transfer12);
  // NOTE12: KATHLEEN12 - ALSO12 NEED12 TO HANDLE12 KILL12 HERE12??

  function new(string name="apb_master_base_seq12");
    super.new(name);
  endfunction
 
  `uvm_object_utils(apb_master_base_seq12)
  `uvm_declare_p_sequencer(apb_master_sequencer12)

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
endclass : apb_master_base_seq12

//------------------------------------------------------------------------------
// SEQUENCE12: read_byte_seq12
//------------------------------------------------------------------------------
class read_byte_seq12 extends apb_master_base_seq12;
  rand bit [31:0] start_addr12;
  rand int unsigned transmit_del12;

  function new(string name="read_byte_seq12");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_byte_seq12)

  constraint transmit_del_ct12 { (transmit_del12 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr12;
        req.direction12 == APB_READ12;
        req.transmit_delay12 == transmit_del12; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr12 = 'h%0h, req_data12 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr12 = 'h%0h, rsp_data12 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_byte_seq12

// SEQUENCE12: write_byte_seq12
class write_byte_seq12 extends apb_master_base_seq12;
  rand bit [31:0] start_addr12;
  rand bit [7:0] write_data12;
  rand int unsigned transmit_del12;

  function new(string name="write_byte_seq12");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_byte_seq12)

  constraint transmit_del_ct12 { (transmit_del12 <= 10); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr12;
        req.direction12 == APB_WRITE12;
        req.data == write_data12;
        req.transmit_delay12 == transmit_del12; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_byte_seq12

//------------------------------------------------------------------------------
// SEQUENCE12: read_word_seq12
//------------------------------------------------------------------------------
class read_word_seq12 extends apb_master_base_seq12;
  rand bit [31:0] start_addr12;
  rand int unsigned transmit_del12;

  function new(string name="read_word_seq12");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_word_seq12)

  constraint transmit_del_ct12 { (transmit_del12 <= 10); }
  constraint addr_ct12 {(start_addr12[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr12;
        req.direction12 == APB_READ12;
        req.transmit_delay12 == transmit_del12; } ) 
    get_response(rsp);
    `uvm_info(get_type_name(), $psprintf("req_addr12 = 'h%0h, req_data12 = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    `uvm_info(get_type_name(), $psprintf("rsp_addr12 = 'h%0h, rsp_data12 = 'h%0h", 
        rsp.addr, rsp.data), UVM_HIGH)
    endtask
endclass : read_word_seq12

// SEQUENCE12: write_word_seq12
class write_word_seq12 extends apb_master_base_seq12;
  rand bit [31:0] start_addr12;
  rand bit [31:0] write_data12;
  rand int unsigned transmit_del12;

  function new(string name="write_word_seq12");
    super.new(name);
  endfunction
 
  `uvm_object_utils(write_word_seq12)

  constraint transmit_del_ct12 { (transmit_del12 <= 10); }
  constraint addr_ct12 {(start_addr12[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_HIGH)
    `uvm_do_with(req, 
      { req.addr == start_addr12;
        req.direction12 == APB_WRITE12;
        req.data == write_data12;
        req.transmit_delay12 == transmit_del12; } )
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
        req.addr, req.data), UVM_HIGH)
    endtask
endclass : write_word_seq12

// SEQUENCE12: read_after_write_seq12
class read_after_write_seq12 extends apb_master_base_seq12;

  rand bit [31:0] start_addr12;
  rand bit [31:0] write_data12;
  rand int unsigned transmit_del12;

  function new(string name="read_after_write_seq12");
    super.new(name);
  endfunction
 
  `uvm_object_utils(read_after_write_seq12)

  constraint transmit_del_ct12 { (transmit_del12 <= 10); }
  constraint addr_ct12 {(start_addr12[1:0] == 0); }
    
  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    `uvm_do_with(req, 
      { req.addr == start_addr12;
        req.direction12 == APB_WRITE12;
        req.data == write_data12;
        req.transmit_delay12 == transmit_del12; } )
    `uvm_do_with(req, 
      { req.addr == start_addr12;
        req.direction12 == APB_READ12;
        req.transmit_delay12 == transmit_del12; } ) 
    `uvm_info(get_type_name(), $psprintf("addr = 'h%0h, data = 'h%0h", 
              req.addr, req.data), UVM_HIGH)
    endtask
  
endclass : read_after_write_seq12

// SEQUENCE12: multiple_read_after_write_seq12
class multiple_read_after_write_seq12 extends apb_master_base_seq12;

    read_after_write_seq12 raw_seq12;
    write_byte_seq12 w_seq12;
    read_byte_seq12 r_seq12;
    rand int unsigned num_of_seq12;

    function new(string name="multiple_read_after_write_seq12");
      super.new(name);
    endfunction
  
    `uvm_object_utils(multiple_read_after_write_seq12)

    constraint num_of_seq_c12 { num_of_seq12 <= 10; num_of_seq12 >= 5; }

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq12; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq12)
      end
      repeat (3) `uvm_do_with(w_seq12, {transmit_del12 == 1;} )
      repeat (3) `uvm_do_with(r_seq12, {transmit_del12 == 1;} )
    endtask
endclass : multiple_read_after_write_seq12
`endif // APB_MASTER_SEQ_LIB_SV12
