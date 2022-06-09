// IVB2 checksum2: 2173772784
/*-----------------------------------------------------------------
File2 name     : ahb_transfer2.sv
Created2       : Wed2 May2 19 15:42:20 2010
Description2   :  This2 file declares2 the OVC2 transfer2. It is
              :  used by both master2 and slave2.
Notes2         :
-----------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
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


`ifndef AHB_TRANSFER_SV2
`define AHB_TRANSFER_SV2

//------------------------------------------------------------------------------
//
// ahb2 transfer2 enums2, parameters2, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE2 = 0,
		HALFWORD2 = 1,
		WORD2 = 2,
		TWO_WORDS2 = 3,
		FOUR_WORDS2 = 4,
		EIGHT_WORDS2 = 5,
		SIXTEEN_WORDS2 = 6,
		K_BITS2 = 7
} ahb_transfer_size2;
typedef enum logic[1:0]  {
		IDLE2 = 0,
		BUSY2 = 1,
		NONSEQ2 = 2,
		SEQ = 3
} ahb_transfer_kind2;
typedef enum logic[1:0]  {
		OKAY2 = 0,
		ERROR2 = 1,
		RETRY2 = 2,
		SPLIT2 = 3
} ahb_response_kind2;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction2;
typedef enum logic[2:0]  {
		SINGLE2 = 0,
		INCR = 1,
		WRAP42 = 2,
		INCR42 = 3,
		WRAP82 = 4,
		INCR82 = 5,
		WRAP162 = 6,
		INCR162 = 7
} ahb_burst_kind2;
 
//------------------------------------------------------------------------------
//
// CLASS2: ahb_transfer2
//
//------------------------------------------------------------------------------

class ahb_transfer2 extends uvm_sequence_item;

  /***************************************************************************
   IVB2-NOTE2 : REQUIRED2 : transfer2 definitions2 : Item2 definitions2
   ---------------------------------------------------------------------------
   Adjust2 the transfer2 attribute2 names as required2 and add any 
   necessary2 attributes2.
   Note2 that if you change an attribute2 name, you must change it in all of your2
   OVC2 files.
   Make2 sure2 to edit2 the uvm_object_utils_begin to get various2 utilities2 (like2
   print and copy) for each attribute2 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH2-1:0] data;
  rand logic [`AHB_ADDR_WIDTH2-1:0] address;
  rand ahb_direction2 direction2 ;
  rand ahb_transfer_size2  hsize2;
  rand ahb_burst_kind2  burst;
  rand logic [3:0] prot2 ;
 
  `uvm_object_utils_begin(ahb_transfer2)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction2,direction2, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size2,hsize2, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind2,burst, UVM_ALL_ON)
    `uvm_field_int(prot2, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor2 - required2 syntax2 for UVM automation2 and utilities2
  function new (string name = "unnamed2-ahb_transfer2");
    super.new(name);
  endfunction : new

endclass : ahb_transfer2

`endif // AHB_TRANSFER_SV2

