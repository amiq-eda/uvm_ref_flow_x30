/*******************************************************************************
  FILE : apb_slave_seq_lib7.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_SEQ_LIB_SV7
`define APB_SLAVE_SEQ_LIB_SV7

//------------------------------------------------------------------------------
// SEQUENCE7: simple_response_seq7
//------------------------------------------------------------------------------

class simple_response_seq7 extends uvm_sequence #(apb_transfer7);

  function new(string name="simple_response_seq7");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq7)
  `uvm_declare_p_sequencer(apb_slave_sequencer7)

  apb_transfer7 req;
  apb_transfer7 util_transfer7;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port7.peek(util_transfer7);
      if((util_transfer7.direction7 == APB_READ7) && 
        (p_sequencer.cfg.check_address_range7(util_transfer7.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range7 Matching7 read.  Responding7...", util_transfer7.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction7 == APB_READ7; } )
      end
    end
  endtask : body

endclass : simple_response_seq7

//------------------------------------------------------------------------------
// SEQUENCE7: mem_response_seq7
//------------------------------------------------------------------------------
class mem_response_seq7 extends uvm_sequence #(apb_transfer7);

  function new(string name="mem_response_seq7");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data7;

  `uvm_object_utils(mem_response_seq7)
  `uvm_declare_p_sequencer(apb_slave_sequencer7)

  //simple7 assoc7 array to hold7 values
  logic [31:0] slave_mem7[int];

  apb_transfer7 req;
  apb_transfer7 util_transfer7;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port7.peek(util_transfer7);
      if((util_transfer7.direction7 == APB_READ7) && 
        (p_sequencer.cfg.check_address_range7(util_transfer7.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range7 Matching7 APB_READ7.  Responding7...", util_transfer7.addr), UVM_MEDIUM);
        if (slave_mem7.exists(util_transfer7.addr))
        `uvm_do_with(req, { req.direction7 == APB_READ7;
                            req.addr == util_transfer7.addr;
                            req.data == slave_mem7[util_transfer7.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction7 == APB_READ7;
                            req.addr == util_transfer7.addr;
                            req.data == mem_data7; } )
         mem_data7++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range7(util_transfer7.addr) == 1) begin
        slave_mem7[util_transfer7.addr] = util_transfer7.data;
        // DUMMY7 response with same information
        `uvm_do_with(req, { req.direction7 == APB_WRITE7;
                            req.addr == util_transfer7.addr;
                            req.data == util_transfer7.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq7

`endif // APB_SLAVE_SEQ_LIB_SV7
