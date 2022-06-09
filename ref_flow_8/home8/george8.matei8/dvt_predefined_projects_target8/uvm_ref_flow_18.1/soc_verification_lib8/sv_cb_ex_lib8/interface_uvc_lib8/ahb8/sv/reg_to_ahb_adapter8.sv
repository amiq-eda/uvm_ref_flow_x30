/*-------------------------------------------------------------------------
File8 name   : reg_to_ahb_adapter8.sv
Title8       : Register Operations8 to AHB8 Transactions8 Adapter Sequence
Project8     :
Created8     :
Description8 : UVM_REG - Adapter Sequence converts8 UVM register operations8
            : to AHB8 bus transactions
Notes8       : This8 example8 does not provide8 any random transfer8 delay
            : for the transaction.  This8 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright8 1999-2011 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

class reg_to_ahb_adapter8 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter8)

  function new(string name="reg_to_ahb_adapter8");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer8 transfer8;
    transfer8 = ahb_transfer8::type_id::create("transfer8");
    transfer8.address = rw.addr;
    transfer8.data = rw.data;
    transfer8.direction8 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer8);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer8 transfer8;
    if (!$cast(transfer8, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE8",
       "Provided bus_item is not of the correct8 type. Expecting8 ahb_transfer8")
       return;
    end
    rw.kind =  (transfer8.direction8 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer8.address;
    rw.data = transfer8.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter8
