/*-------------------------------------------------------------------------
File21 name   : reg_to_apb_adapter21.sv
Title21       : Register Operations21 to APB21 Transactions21 Adapter Sequence
Project21     :
Created21     :
Description21 : UVM_REG - Adapter Sequence converts21 UVM register operations21
            : to APB21 bus transactions
Notes21       : This21 example21 does not provide21 any random transfer21 delay
            : for the transaction.  This21 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright21 1999-2011 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

class reg_to_apb_adapter21 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter21)

  function new(string name="reg_to_apb_adapter21");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer21 transfer21;
    transfer21 = apb_transfer21::type_id::create("transfer21");
    transfer21.addr = rw.addr;
    transfer21.data = rw.data;
    transfer21.direction21 = (rw.kind == UVM_READ) ? APB_READ21 : APB_WRITE21;
    return (transfer21);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer21 transfer21;
    if (!$cast(transfer21, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE21",
       "Provided bus_item is not of the correct21 type. Expecting21 apb_transfer21")
       return;
    end
    rw.kind =  (transfer21.direction21 == APB_READ21) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer21.addr;
    rw.data = transfer21.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO21 NOT21 SET IT21 AT21 ALL21 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter21
