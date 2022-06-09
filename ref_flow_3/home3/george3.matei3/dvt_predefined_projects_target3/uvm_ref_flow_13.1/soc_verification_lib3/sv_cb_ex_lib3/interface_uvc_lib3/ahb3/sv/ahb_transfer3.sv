// IVB3 checksum3: 2173772784
/*-----------------------------------------------------------------
File3 name     : ahb_transfer3.sv
Created3       : Wed3 May3 19 15:42:20 2010
Description3   :  This3 file declares3 the OVC3 transfer3. It is
              :  used by both master3 and slave3.
Notes3         :
-----------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV3
`define AHB_TRANSFER_SV3

//------------------------------------------------------------------------------
//
// ahb3 transfer3 enums3, parameters3, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE3 = 0,
		HALFWORD3 = 1,
		WORD3 = 2,
		TWO_WORDS3 = 3,
		FOUR_WORDS3 = 4,
		EIGHT_WORDS3 = 5,
		SIXTEEN_WORDS3 = 6,
		K_BITS3 = 7
} ahb_transfer_size3;
typedef enum logic[1:0]  {
		IDLE3 = 0,
		BUSY3 = 1,
		NONSEQ3 = 2,
		SEQ = 3
} ahb_transfer_kind3;
typedef enum logic[1:0]  {
		OKAY3 = 0,
		ERROR3 = 1,
		RETRY3 = 2,
		SPLIT3 = 3
} ahb_response_kind3;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction3;
typedef enum logic[2:0]  {
		SINGLE3 = 0,
		INCR = 1,
		WRAP43 = 2,
		INCR43 = 3,
		WRAP83 = 4,
		INCR83 = 5,
		WRAP163 = 6,
		INCR163 = 7
} ahb_burst_kind3;
 
//------------------------------------------------------------------------------
//
// CLASS3: ahb_transfer3
//
//------------------------------------------------------------------------------

class ahb_transfer3 extends uvm_sequence_item;

  /***************************************************************************
   IVB3-NOTE3 : REQUIRED3 : transfer3 definitions3 : Item3 definitions3
   ---------------------------------------------------------------------------
   Adjust3 the transfer3 attribute3 names as required3 and add any 
   necessary3 attributes3.
   Note3 that if you change an attribute3 name, you must change it in all of your3
   OVC3 files.
   Make3 sure3 to edit3 the uvm_object_utils_begin to get various3 utilities3 (like3
   print and copy) for each attribute3 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH3-1:0] data;
  rand logic [`AHB_ADDR_WIDTH3-1:0] address;
  rand ahb_direction3 direction3 ;
  rand ahb_transfer_size3  hsize3;
  rand ahb_burst_kind3  burst;
  rand logic [3:0] prot3 ;
 
  `uvm_object_utils_begin(ahb_transfer3)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction3,direction3, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size3,hsize3, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind3,burst, UVM_ALL_ON)
    `uvm_field_int(prot3, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor3 - required3 syntax3 for UVM automation3 and utilities3
  function new (string name = "unnamed3-ahb_transfer3");
    super.new(name);
  endfunction : new

endclass : ahb_transfer3

`endif // AHB_TRANSFER_SV3

