// IVB19 checksum19: 2173772784
/*-----------------------------------------------------------------
File19 name     : ahb_transfer19.sv
Created19       : Wed19 May19 19 15:42:20 2010
Description19   :  This19 file declares19 the OVC19 transfer19. It is
              :  used by both master19 and slave19.
Notes19         :
-----------------------------------------------------------------*/
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


`ifndef AHB_TRANSFER_SV19
`define AHB_TRANSFER_SV19

//------------------------------------------------------------------------------
//
// ahb19 transfer19 enums19, parameters19, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE19 = 0,
		HALFWORD19 = 1,
		WORD19 = 2,
		TWO_WORDS19 = 3,
		FOUR_WORDS19 = 4,
		EIGHT_WORDS19 = 5,
		SIXTEEN_WORDS19 = 6,
		K_BITS19 = 7
} ahb_transfer_size19;
typedef enum logic[1:0]  {
		IDLE19 = 0,
		BUSY19 = 1,
		NONSEQ19 = 2,
		SEQ = 3
} ahb_transfer_kind19;
typedef enum logic[1:0]  {
		OKAY19 = 0,
		ERROR19 = 1,
		RETRY19 = 2,
		SPLIT19 = 3
} ahb_response_kind19;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction19;
typedef enum logic[2:0]  {
		SINGLE19 = 0,
		INCR = 1,
		WRAP419 = 2,
		INCR419 = 3,
		WRAP819 = 4,
		INCR819 = 5,
		WRAP1619 = 6,
		INCR1619 = 7
} ahb_burst_kind19;
 
//------------------------------------------------------------------------------
//
// CLASS19: ahb_transfer19
//
//------------------------------------------------------------------------------

class ahb_transfer19 extends uvm_sequence_item;

  /***************************************************************************
   IVB19-NOTE19 : REQUIRED19 : transfer19 definitions19 : Item19 definitions19
   ---------------------------------------------------------------------------
   Adjust19 the transfer19 attribute19 names as required19 and add any 
   necessary19 attributes19.
   Note19 that if you change an attribute19 name, you must change it in all of your19
   OVC19 files.
   Make19 sure19 to edit19 the uvm_object_utils_begin to get various19 utilities19 (like19
   print and copy) for each attribute19 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH19-1:0] data;
  rand logic [`AHB_ADDR_WIDTH19-1:0] address;
  rand ahb_direction19 direction19 ;
  rand ahb_transfer_size19  hsize19;
  rand ahb_burst_kind19  burst;
  rand logic [3:0] prot19 ;
 
  `uvm_object_utils_begin(ahb_transfer19)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction19,direction19, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size19,hsize19, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind19,burst, UVM_ALL_ON)
    `uvm_field_int(prot19, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor19 - required19 syntax19 for UVM automation19 and utilities19
  function new (string name = "unnamed19-ahb_transfer19");
    super.new(name);
  endfunction : new

endclass : ahb_transfer19

`endif // AHB_TRANSFER_SV19

