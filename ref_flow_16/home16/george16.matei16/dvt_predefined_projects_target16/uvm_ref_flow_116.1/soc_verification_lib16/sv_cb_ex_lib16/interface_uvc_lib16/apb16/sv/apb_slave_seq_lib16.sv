/*******************************************************************************
  FILE : apb_slave_seq_lib16.sv
*******************************************************************************/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV16
`define APB_SLAVE_SEQ_LIB_SV16

//------------------------------------------------------------------------------
// SEQUENCE16: simple_response_seq16
//------------------------------------------------------------------------------

class simple_response_seq16 extends uvm_sequence #(apb_transfer16);

  function new(string name="simple_response_seq16");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq16)
  `uvm_declare_p_sequencer(apb_slave_sequencer16)

  apb_transfer16 req;
  apb_transfer16 util_transfer16;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port16.peek(util_transfer16);
      if((util_transfer16.direction16 == APB_READ16) && 
        (p_sequencer.cfg.check_address_range16(util_transfer16.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range16 Matching16 read.  Responding16...", util_transfer16.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction16 == APB_READ16; } )
      end
    end
  endtask : body

endclass : simple_response_seq16

//------------------------------------------------------------------------------
// SEQUENCE16: mem_response_seq16
//------------------------------------------------------------------------------
class mem_response_seq16 extends uvm_sequence #(apb_transfer16);

  function new(string name="mem_response_seq16");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data16;

  `uvm_object_utils(mem_response_seq16)
  `uvm_declare_p_sequencer(apb_slave_sequencer16)

  //simple16 assoc16 array to hold16 values
  logic [31:0] slave_mem16[int];

  apb_transfer16 req;
  apb_transfer16 util_transfer16;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port16.peek(util_transfer16);
      if((util_transfer16.direction16 == APB_READ16) && 
        (p_sequencer.cfg.check_address_range16(util_transfer16.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range16 Matching16 APB_READ16.  Responding16...", util_transfer16.addr), UVM_MEDIUM);
        if (slave_mem16.exists(util_transfer16.addr))
        `uvm_do_with(req, { req.direction16 == APB_READ16;
                            req.addr == util_transfer16.addr;
                            req.data == slave_mem16[util_transfer16.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction16 == APB_READ16;
                            req.addr == util_transfer16.addr;
                            req.data == mem_data16; } )
         mem_data16++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range16(util_transfer16.addr) == 1) begin
        slave_mem16[util_transfer16.addr] = util_transfer16.data;
        // DUMMY16 response with same information
        `uvm_do_with(req, { req.direction16 == APB_WRITE16;
                            req.addr == util_transfer16.addr;
                            req.data == util_transfer16.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq16

`endif // APB_SLAVE_SEQ_LIB_SV16
