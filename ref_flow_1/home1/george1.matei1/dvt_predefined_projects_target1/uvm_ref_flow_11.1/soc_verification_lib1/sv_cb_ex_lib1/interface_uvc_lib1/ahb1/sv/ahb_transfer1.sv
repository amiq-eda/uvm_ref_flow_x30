// IVB1 checksum1: 2173772784
/*-----------------------------------------------------------------
File1 name     : ahb_transfer1.sv
Created1       : Wed1 May1 19 15:42:20 2010
Description1   :  This1 file declares1 the OVC1 transfer1. It is
              :  used by both master1 and slave1.
Notes1         :
-----------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV1
`define AHB_TRANSFER_SV1

//------------------------------------------------------------------------------
//
// ahb1 transfer1 enums1, parameters1, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE1 = 0,
		HALFWORD1 = 1,
		WORD1 = 2,
		TWO_WORDS1 = 3,
		FOUR_WORDS1 = 4,
		EIGHT_WORDS1 = 5,
		SIXTEEN_WORDS1 = 6,
		K_BITS1 = 7
} ahb_transfer_size1;
typedef enum logic[1:0]  {
		IDLE1 = 0,
		BUSY1 = 1,
		NONSEQ1 = 2,
		SEQ = 3
} ahb_transfer_kind1;
typedef enum logic[1:0]  {
		OKAY1 = 0,
		ERROR1 = 1,
		RETRY1 = 2,
		SPLIT1 = 3
} ahb_response_kind1;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction1;
typedef enum logic[2:0]  {
		SINGLE1 = 0,
		INCR = 1,
		WRAP41 = 2,
		INCR41 = 3,
		WRAP81 = 4,
		INCR81 = 5,
		WRAP161 = 6,
		INCR161 = 7
} ahb_burst_kind1;
 
//------------------------------------------------------------------------------
//
// CLASS1: ahb_transfer1
//
//------------------------------------------------------------------------------

class ahb_transfer1 extends uvm_sequence_item;

  /***************************************************************************
   IVB1-NOTE1 : REQUIRED1 : transfer1 definitions1 : Item1 definitions1
   ---------------------------------------------------------------------------
   Adjust1 the transfer1 attribute1 names as required1 and add any 
   necessary1 attributes1.
   Note1 that if you change an attribute1 name, you must change it in all of your1
   OVC1 files.
   Make1 sure1 to edit1 the uvm_object_utils_begin to get various1 utilities1 (like1
   print and copy) for each attribute1 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH1-1:0] data;
  rand logic [`AHB_ADDR_WIDTH1-1:0] address;
  rand ahb_direction1 direction1 ;
  rand ahb_transfer_size1  hsize1;
  rand ahb_burst_kind1  burst;
  rand logic [3:0] prot1 ;
 
  `uvm_object_utils_begin(ahb_transfer1)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction1,direction1, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size1,hsize1, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind1,burst, UVM_ALL_ON)
    `uvm_field_int(prot1, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor1 - required1 syntax1 for UVM automation1 and utilities1
  function new (string name = "unnamed1-ahb_transfer1");
    super.new(name);
  endfunction : new

endclass : ahb_transfer1

`endif // AHB_TRANSFER_SV1

