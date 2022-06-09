// IVB8 checksum8: 2173772784
/*-----------------------------------------------------------------
File8 name     : ahb_transfer8.sv
Created8       : Wed8 May8 19 15:42:20 2010
Description8   :  This8 file declares8 the OVC8 transfer8. It is
              :  used by both master8 and slave8.
Notes8         :
-----------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
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


`ifndef AHB_TRANSFER_SV8
`define AHB_TRANSFER_SV8

//------------------------------------------------------------------------------
//
// ahb8 transfer8 enums8, parameters8, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE8 = 0,
		HALFWORD8 = 1,
		WORD8 = 2,
		TWO_WORDS8 = 3,
		FOUR_WORDS8 = 4,
		EIGHT_WORDS8 = 5,
		SIXTEEN_WORDS8 = 6,
		K_BITS8 = 7
} ahb_transfer_size8;
typedef enum logic[1:0]  {
		IDLE8 = 0,
		BUSY8 = 1,
		NONSEQ8 = 2,
		SEQ = 3
} ahb_transfer_kind8;
typedef enum logic[1:0]  {
		OKAY8 = 0,
		ERROR8 = 1,
		RETRY8 = 2,
		SPLIT8 = 3
} ahb_response_kind8;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction8;
typedef enum logic[2:0]  {
		SINGLE8 = 0,
		INCR = 1,
		WRAP48 = 2,
		INCR48 = 3,
		WRAP88 = 4,
		INCR88 = 5,
		WRAP168 = 6,
		INCR168 = 7
} ahb_burst_kind8;
 
//------------------------------------------------------------------------------
//
// CLASS8: ahb_transfer8
//
//------------------------------------------------------------------------------

class ahb_transfer8 extends uvm_sequence_item;

  /***************************************************************************
   IVB8-NOTE8 : REQUIRED8 : transfer8 definitions8 : Item8 definitions8
   ---------------------------------------------------------------------------
   Adjust8 the transfer8 attribute8 names as required8 and add any 
   necessary8 attributes8.
   Note8 that if you change an attribute8 name, you must change it in all of your8
   OVC8 files.
   Make8 sure8 to edit8 the uvm_object_utils_begin to get various8 utilities8 (like8
   print and copy) for each attribute8 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH8-1:0] data;
  rand logic [`AHB_ADDR_WIDTH8-1:0] address;
  rand ahb_direction8 direction8 ;
  rand ahb_transfer_size8  hsize8;
  rand ahb_burst_kind8  burst;
  rand logic [3:0] prot8 ;
 
  `uvm_object_utils_begin(ahb_transfer8)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction8,direction8, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size8,hsize8, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind8,burst, UVM_ALL_ON)
    `uvm_field_int(prot8, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor8 - required8 syntax8 for UVM automation8 and utilities8
  function new (string name = "unnamed8-ahb_transfer8");
    super.new(name);
  endfunction : new

endclass : ahb_transfer8

`endif // AHB_TRANSFER_SV8

