/*-------------------------------------------------------------------------
File2 name   : reg_to_ahb_adapter2.sv
Title2       : Register Operations2 to AHB2 Transactions2 Adapter Sequence
Project2     :
Created2     :
Description2 : UVM_REG - Adapter Sequence converts2 UVM register operations2
            : to AHB2 bus transactions
Notes2       : This2 example2 does not provide2 any random transfer2 delay
            : for the transaction.  This2 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright2 1999-2011 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

class reg_to_ahb_adapter2 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter2)

  function new(string name="reg_to_ahb_adapter2");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer2 transfer2;
    transfer2 = ahb_transfer2::type_id::create("transfer2");
    transfer2.address = rw.addr;
    transfer2.data = rw.data;
    transfer2.direction2 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer2);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer2 transfer2;
    if (!$cast(transfer2, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE2",
       "Provided bus_item is not of the correct2 type. Expecting2 ahb_transfer2")
       return;
    end
    rw.kind =  (transfer2.direction2 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer2.address;
    rw.data = transfer2.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter2
