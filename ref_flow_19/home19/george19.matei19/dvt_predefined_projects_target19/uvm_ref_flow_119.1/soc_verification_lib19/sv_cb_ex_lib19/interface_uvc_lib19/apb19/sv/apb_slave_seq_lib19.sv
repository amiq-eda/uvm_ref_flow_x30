/*******************************************************************************
  FILE : apb_slave_seq_lib19.sv
*******************************************************************************/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV19
`define APB_SLAVE_SEQ_LIB_SV19

//------------------------------------------------------------------------------
// SEQUENCE19: simple_response_seq19
//------------------------------------------------------------------------------

class simple_response_seq19 extends uvm_sequence #(apb_transfer19);

  function new(string name="simple_response_seq19");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq19)
  `uvm_declare_p_sequencer(apb_slave_sequencer19)

  apb_transfer19 req;
  apb_transfer19 util_transfer19;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port19.peek(util_transfer19);
      if((util_transfer19.direction19 == APB_READ19) && 
        (p_sequencer.cfg.check_address_range19(util_transfer19.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range19 Matching19 read.  Responding19...", util_transfer19.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction19 == APB_READ19; } )
      end
    end
  endtask : body

endclass : simple_response_seq19

//------------------------------------------------------------------------------
// SEQUENCE19: mem_response_seq19
//------------------------------------------------------------------------------
class mem_response_seq19 extends uvm_sequence #(apb_transfer19);

  function new(string name="mem_response_seq19");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data19;

  `uvm_object_utils(mem_response_seq19)
  `uvm_declare_p_sequencer(apb_slave_sequencer19)

  //simple19 assoc19 array to hold19 values
  logic [31:0] slave_mem19[int];

  apb_transfer19 req;
  apb_transfer19 util_transfer19;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port19.peek(util_transfer19);
      if((util_transfer19.direction19 == APB_READ19) && 
        (p_sequencer.cfg.check_address_range19(util_transfer19.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range19 Matching19 APB_READ19.  Responding19...", util_transfer19.addr), UVM_MEDIUM);
        if (slave_mem19.exists(util_transfer19.addr))
        `uvm_do_with(req, { req.direction19 == APB_READ19;
                            req.addr == util_transfer19.addr;
                            req.data == slave_mem19[util_transfer19.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction19 == APB_READ19;
                            req.addr == util_transfer19.addr;
                            req.data == mem_data19; } )
         mem_data19++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range19(util_transfer19.addr) == 1) begin
        slave_mem19[util_transfer19.addr] = util_transfer19.data;
        // DUMMY19 response with same information
        `uvm_do_with(req, { req.direction19 == APB_WRITE19;
                            req.addr == util_transfer19.addr;
                            req.data == util_transfer19.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq19

`endif // APB_SLAVE_SEQ_LIB_SV19
