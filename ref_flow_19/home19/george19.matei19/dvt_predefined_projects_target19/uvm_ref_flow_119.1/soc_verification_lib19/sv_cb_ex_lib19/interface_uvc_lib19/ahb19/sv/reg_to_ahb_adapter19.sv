/*-------------------------------------------------------------------------
File19 name   : reg_to_ahb_adapter19.sv
Title19       : Register Operations19 to AHB19 Transactions19 Adapter Sequence
Project19     :
Created19     :
Description19 : UVM_REG - Adapter Sequence converts19 UVM register operations19
            : to AHB19 bus transactions
Notes19       : This19 example19 does not provide19 any random transfer19 delay
            : for the transaction.  This19 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright19 1999-2011 Cadence19 Design19 Systems19, Inc19.
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

class reg_to_ahb_adapter19 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter19)

  function new(string name="reg_to_ahb_adapter19");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer19 transfer19;
    transfer19 = ahb_transfer19::type_id::create("transfer19");
    transfer19.address = rw.addr;
    transfer19.data = rw.data;
    transfer19.direction19 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer19);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer19 transfer19;
    if (!$cast(transfer19, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE19",
       "Provided bus_item is not of the correct19 type. Expecting19 ahb_transfer19")
       return;
    end
    rw.kind =  (transfer19.direction19 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer19.address;
    rw.data = transfer19.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter19
