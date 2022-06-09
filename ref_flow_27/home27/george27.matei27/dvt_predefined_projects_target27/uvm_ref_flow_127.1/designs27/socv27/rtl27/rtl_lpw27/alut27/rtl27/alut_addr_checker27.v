//File27 name   : alut_addr_checker27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

// compiler27 directives27
`include "alut_defines27.v"


module alut_addr_checker27
(   
   // Inputs27
   pclk27,
   n_p_reset27,
   command,
   mac_addr27,
   d_addr27,
   s_addr27,
   s_port27,
   curr_time27,
   mem_read_data_add27,
   age_confirmed27,
   age_ok27,
   clear_reused27,

   //outputs27
   d_port27,
   add_check_active27,
   mem_addr_add27,
   mem_write_add27,
   mem_write_data_add27,
   lst_inv_addr_nrm27,
   lst_inv_port_nrm27,
   check_age27,
   last_accessed27,
   reused27
);



   input               pclk27;               // APB27 clock27                           
   input               n_p_reset27;          // Reset27                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr27;           // address of the switch27              
   input [47:0]        d_addr27;             // address of frame27 to be checked27     
   input [47:0]        s_addr27;             // address of frame27 to be stored27      
   input [1:0]         s_port27;             // source27 port of current frame27       
   input [31:0]        curr_time27;          // current time,for storing27 in mem    
   input [82:0]        mem_read_data_add27;  // read data from mem                 
   input               age_confirmed27;      // valid flag27 from age27 checker        
   input               age_ok27;             // result from age27 checker 
   input               clear_reused27;       // read/clear flag27 for reused27 signal27           

   output [4:0]        d_port27;             // calculated27 destination27 port for tx27 
   output              add_check_active27;   // bit 0 of status register           
   output [7:0]        mem_addr_add27;       // hash27 address for R/W27 to memory     
   output              mem_write_add27;      // R/W27 flag27 (write = high27)            
   output [82:0]       mem_write_data_add27; // write data for memory             
   output [47:0]       lst_inv_addr_nrm27;   // last invalidated27 addr normal27 op    
   output [1:0]        lst_inv_port_nrm27;   // last invalidated27 port normal27 op    
   output              check_age27;          // request flag27 for age27 check
   output [31:0]       last_accessed27;      // time field sent27 for age27 check
   output              reused27;             // indicates27 ALUT27 location27 overwritten27

   reg   [2:0]         add_chk_state27;      // current address checker state
   reg   [2:0]         nxt_add_chk_state27;  // current address checker state
   reg   [4:0]         d_port27;             // calculated27 destination27 port for tx27 
   reg   [3:0]         port_mem27;           // bitwise27 conversion27 of 2bit port
   reg   [7:0]         mem_addr_add27;       // hash27 address for R/W27 to memory
   reg                 mem_write_add27;      // R/W27 flag27 (write = high27)            
   reg                 reused27;             // indicates27 ALUT27 location27 overwritten27
   reg   [47:0]        lst_inv_addr_nrm27;   // last invalidated27 addr normal27 op    
   reg   [1:0]         lst_inv_port_nrm27;   // last invalidated27 port normal27 op    
   reg                 check_age27;          // request flag27 for age27 checker
   reg   [31:0]        last_accessed27;      // time field sent27 for age27 check


   wire   [7:0]        s_addr_hash27;        // hash27 of address for storing27
   wire   [7:0]        d_addr_hash27;        // hash27 of address for checking
   wire   [82:0]       mem_write_data_add27; // write data for memory  
   wire                add_check_active27;   // bit 0 of status register           


// Parameters27 for Address Checking27 FSM27 states27
   parameter idle27           = 3'b000;
   parameter mac_addr_chk27   = 3'b001;
   parameter read_dest_add27  = 3'b010;
   parameter valid_chk27      = 3'b011;
   parameter age_chk27        = 3'b100;
   parameter addr_chk27       = 3'b101;
   parameter read_src_add27   = 3'b110;
   parameter write_src27      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash27 conversion27 of source27 and destination27 addresses27
// -----------------------------------------------------------------------------
   assign s_addr_hash27 = s_addr27[7:0] ^ s_addr27[15:8] ^ s_addr27[23:16] ^
                        s_addr27[31:24] ^ s_addr27[39:32] ^ s_addr27[47:40];

   assign d_addr_hash27 = d_addr27[7:0] ^ d_addr27[15:8] ^ d_addr27[23:16] ^
                        d_addr27[31:24] ^ d_addr27[39:32] ^ d_addr27[47:40];



// -----------------------------------------------------------------------------
//   State27 Machine27 For27 handling27 the destination27 address checking process and
//   and storing27 of new source27 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state27 or age_confirmed27 or age_ok27)
   begin
      case (add_chk_state27)
      
      idle27:
         if (command == 2'b01)
            nxt_add_chk_state27 = mac_addr_chk27;
         else
            nxt_add_chk_state27 = idle27;

      mac_addr_chk27:   // check if destination27 address match MAC27 switch27 address
         if (d_addr27 == mac_addr27)
            nxt_add_chk_state27 = idle27;  // return dest27 port as 5'b1_0000
         else
            nxt_add_chk_state27 = read_dest_add27;

      read_dest_add27:       // read data from memory using hash27 of destination27 address
            nxt_add_chk_state27 = valid_chk27;

      valid_chk27:      // check if read data had27 valid bit set
         nxt_add_chk_state27 = age_chk27;

      age_chk27:        // request age27 checker to check if still in date27
         if (age_confirmed27)
            nxt_add_chk_state27 = addr_chk27;
         else
            nxt_add_chk_state27 = age_chk27; 

      addr_chk27:       // perform27 compare between dest27 and read addresses27
            nxt_add_chk_state27 = read_src_add27; // return read port from ALUT27 mem

      read_src_add27:   // read from memory location27 about27 to be overwritten27
            nxt_add_chk_state27 = write_src27; 

      write_src27:      // write new source27 data (addr and port) to memory
            nxt_add_chk_state27 = idle27; 

      default:
            nxt_add_chk_state27 = idle27;
      endcase
   end


// destination27 check FSM27 current state
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      add_chk_state27 <= idle27;
   else
      add_chk_state27 <= nxt_add_chk_state27;
   end



// -----------------------------------------------------------------------------
//   Generate27 returned value of port for sending27 new frame27 to
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      d_port27 <= 5'b0_1111;
   else if ((add_chk_state27 == mac_addr_chk27) & (d_addr27 == mac_addr27))
      d_port27 <= 5'b1_0000;
   else if (((add_chk_state27 == valid_chk27) & ~mem_read_data_add27[82]) |
            ((add_chk_state27 == age_chk27) & ~(age_confirmed27 & age_ok27)) |
            ((add_chk_state27 == addr_chk27) & (d_addr27 != mem_read_data_add27[47:0])))
      d_port27 <= 5'b0_1111 & ~( 1 << s_port27 );
   else if ((add_chk_state27 == addr_chk27) & (d_addr27 == mem_read_data_add27[47:0]))
      d_port27 <= {1'b0, port_mem27} & ~( 1 << s_port27 );
   else
      d_port27 <= d_port27;
   end


// -----------------------------------------------------------------------------
//   convert read port source27 value from 2bits to bitwise27 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      port_mem27 <= 4'b1111;
   else begin
      case (mem_read_data_add27[49:48])
         2'b00: port_mem27 <= 4'b0001;
         2'b01: port_mem27 <= 4'b0010;
         2'b10: port_mem27 <= 4'b0100;
         2'b11: port_mem27 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded27 off27 add_chk_state27
// -----------------------------------------------------------------------------
assign add_check_active27 = (add_chk_state27 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate27 memory addressing27 signals27.
//   The check address command will be taken27 as the indication27 from SW27 that the 
//   source27 fields (address and port) can be written27 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27) 
   begin
       mem_write_add27 <= 1'b0;
       mem_addr_add27  <= 8'd0;
   end
   else if (add_chk_state27 == read_dest_add27)
   begin
       mem_write_add27 <= 1'b0;
       mem_addr_add27  <= d_addr_hash27;
   end
// Need27 to set address two27 cycles27 before check
   else if ( (add_chk_state27 == age_chk27) && age_confirmed27 )
   begin
       mem_write_add27 <= 1'b0;
       mem_addr_add27  <= s_addr_hash27;
   end
   else if (add_chk_state27 == write_src27)
   begin
       mem_write_add27 <= 1'b1;
       mem_addr_add27  <= s_addr_hash27;
   end
   else
   begin
       mem_write_add27 <= 1'b0;
       mem_addr_add27  <= d_addr_hash27;
   end
   end


// -----------------------------------------------------------------------------
//   Generate27 databus27 for writing to memory
//   Data written27 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add27 = {1'b1, curr_time27, s_port27, s_addr27};



// -----------------------------------------------------------------------------
//   Evaluate27 read back data that is about27 to be overwritten27 with new source27 
//   address and port values. Decide27 whether27 the reused27 flag27 must be set and
//   last_inval27 address and port values updated.
//   reused27 needs27 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27) 
   begin
      reused27 <= 1'b0;
      lst_inv_addr_nrm27 <= 48'd0;
      lst_inv_port_nrm27 <= 2'd0;
   end
   else if ((add_chk_state27 == read_src_add27) & mem_read_data_add27[82] &
            (s_addr27 != mem_read_data_add27[47:0]))
   begin
      reused27 <= 1'b1;
      lst_inv_addr_nrm27 <= mem_read_data_add27[47:0];
      lst_inv_port_nrm27 <= mem_read_data_add27[49:48];
   end
   else if (clear_reused27)
   begin
      reused27 <= 1'b0;
      lst_inv_addr_nrm27 <= lst_inv_addr_nrm27;
      lst_inv_port_nrm27 <= lst_inv_addr_nrm27;
   end
   else 
   begin
      reused27 <= reused27;
      lst_inv_addr_nrm27 <= lst_inv_addr_nrm27;
      lst_inv_port_nrm27 <= lst_inv_addr_nrm27;
   end
   end


// -----------------------------------------------------------------------------
//   Generate27 signals27 for age27 checker to perform27 in-date27 check
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27) 
   begin
      check_age27 <= 1'b0;  
      last_accessed27 <= 32'd0;
   end
   else if (check_age27)
   begin
      check_age27 <= 1'b0;  
      last_accessed27 <= mem_read_data_add27[81:50];
   end
   else if (add_chk_state27 == age_chk27)
   begin
      check_age27 <= 1'b1;  
      last_accessed27 <= mem_read_data_add27[81:50];
   end
   else 
   begin
      check_age27 <= 1'b0;  
      last_accessed27 <= 32'd0;
   end
   end


`ifdef ABV_ON27

// psl27 default clock27 = (posedge pclk27);

// ASSERTION27 CHECKS27
/* Commented27 out as also checking in toplevel27
// it should never be possible27 for the destination27 port to indicate27 the MAC27
// switch27 address and one of the other 4 Ethernets27
// psl27 assert_valid_dest_port27 : assert never (d_port27[4] & |{d_port27[3:0]});


// COVER27 SANITY27 CHECKS27
// check all values of destination27 port can be returned.
// psl27 cover_d_port_027 : cover { d_port27 == 5'b0_0001 };
// psl27 cover_d_port_127 : cover { d_port27 == 5'b0_0010 };
// psl27 cover_d_port_227 : cover { d_port27 == 5'b0_0100 };
// psl27 cover_d_port_327 : cover { d_port27 == 5'b0_1000 };
// psl27 cover_d_port_427 : cover { d_port27 == 5'b1_0000 };
// psl27 cover_d_port_all27 : cover { d_port27 == 5'b0_1111 };
*/
`endif


endmodule 









