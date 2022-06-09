// IVB11 checksum11: 2173772784
/*-----------------------------------------------------------------
File11 name     : ahb_transfer11.sv
Created11       : Wed11 May11 19 15:42:20 2010
Description11   :  This11 file declares11 the OVC11 transfer11. It is
              :  used by both master11 and slave11.
Notes11         :
-----------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
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


`ifndef AHB_TRANSFER_SV11
`define AHB_TRANSFER_SV11

//------------------------------------------------------------------------------
//
// ahb11 transfer11 enums11, parameters11, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE11 = 0,
		HALFWORD11 = 1,
		WORD11 = 2,
		TWO_WORDS11 = 3,
		FOUR_WORDS11 = 4,
		EIGHT_WORDS11 = 5,
		SIXTEEN_WORDS11 = 6,
		K_BITS11 = 7
} ahb_transfer_size11;
typedef enum logic[1:0]  {
		IDLE11 = 0,
		BUSY11 = 1,
		NONSEQ11 = 2,
		SEQ = 3
} ahb_transfer_kind11;
typedef enum logic[1:0]  {
		OKAY11 = 0,
		ERROR11 = 1,
		RETRY11 = 2,
		SPLIT11 = 3
} ahb_response_kind11;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction11;
typedef enum logic[2:0]  {
		SINGLE11 = 0,
		INCR = 1,
		WRAP411 = 2,
		INCR411 = 3,
		WRAP811 = 4,
		INCR811 = 5,
		WRAP1611 = 6,
		INCR1611 = 7
} ahb_burst_kind11;
 
//------------------------------------------------------------------------------
//
// CLASS11: ahb_transfer11
//
//------------------------------------------------------------------------------

class ahb_transfer11 extends uvm_sequence_item;

  /***************************************************************************
   IVB11-NOTE11 : REQUIRED11 : transfer11 definitions11 : Item11 definitions11
   ---------------------------------------------------------------------------
   Adjust11 the transfer11 attribute11 names as required11 and add any 
   necessary11 attributes11.
   Note11 that if you change an attribute11 name, you must change it in all of your11
   OVC11 files.
   Make11 sure11 to edit11 the uvm_object_utils_begin to get various11 utilities11 (like11
   print and copy) for each attribute11 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH11-1:0] data;
  rand logic [`AHB_ADDR_WIDTH11-1:0] address;
  rand ahb_direction11 direction11 ;
  rand ahb_transfer_size11  hsize11;
  rand ahb_burst_kind11  burst;
  rand logic [3:0] prot11 ;
 
  `uvm_object_utils_begin(ahb_transfer11)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction11,direction11, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size11,hsize11, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind11,burst, UVM_ALL_ON)
    `uvm_field_int(prot11, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor11 - required11 syntax11 for UVM automation11 and utilities11
  function new (string name = "unnamed11-ahb_transfer11");
    super.new(name);
  endfunction : new

endclass : ahb_transfer11

`endif // AHB_TRANSFER_SV11

