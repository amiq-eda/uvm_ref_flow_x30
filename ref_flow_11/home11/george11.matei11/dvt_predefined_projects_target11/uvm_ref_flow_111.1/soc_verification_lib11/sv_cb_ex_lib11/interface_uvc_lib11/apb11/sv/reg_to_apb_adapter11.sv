/*-------------------------------------------------------------------------
File11 name   : reg_to_apb_adapter11.sv
Title11       : Register Operations11 to APB11 Transactions11 Adapter Sequence
Project11     :
Created11     :
Description11 : UVM_REG - Adapter Sequence converts11 UVM register operations11
            : to APB11 bus transactions
Notes11       : This11 example11 does not provide11 any random transfer11 delay
            : for the transaction.  This11 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright11 1999-2011 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

class reg_to_apb_adapter11 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter11)

  function new(string name="reg_to_apb_adapter11");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer11 transfer11;
    transfer11 = apb_transfer11::type_id::create("transfer11");
    transfer11.addr = rw.addr;
    transfer11.data = rw.data;
    transfer11.direction11 = (rw.kind == UVM_READ) ? APB_READ11 : APB_WRITE11;
    return (transfer11);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer11 transfer11;
    if (!$cast(transfer11, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE11",
       "Provided bus_item is not of the correct11 type. Expecting11 apb_transfer11")
       return;
    end
    rw.kind =  (transfer11.direction11 == APB_READ11) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer11.addr;
    rw.data = transfer11.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO11 NOT11 SET IT11 AT11 ALL11 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter11
