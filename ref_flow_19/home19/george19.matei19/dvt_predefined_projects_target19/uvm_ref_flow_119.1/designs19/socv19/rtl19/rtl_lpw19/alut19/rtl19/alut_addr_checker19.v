//File19 name   : alut_addr_checker19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
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

// compiler19 directives19
`include "alut_defines19.v"


module alut_addr_checker19
(   
   // Inputs19
   pclk19,
   n_p_reset19,
   command,
   mac_addr19,
   d_addr19,
   s_addr19,
   s_port19,
   curr_time19,
   mem_read_data_add19,
   age_confirmed19,
   age_ok19,
   clear_reused19,

   //outputs19
   d_port19,
   add_check_active19,
   mem_addr_add19,
   mem_write_add19,
   mem_write_data_add19,
   lst_inv_addr_nrm19,
   lst_inv_port_nrm19,
   check_age19,
   last_accessed19,
   reused19
);



   input               pclk19;               // APB19 clock19                           
   input               n_p_reset19;          // Reset19                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr19;           // address of the switch19              
   input [47:0]        d_addr19;             // address of frame19 to be checked19     
   input [47:0]        s_addr19;             // address of frame19 to be stored19      
   input [1:0]         s_port19;             // source19 port of current frame19       
   input [31:0]        curr_time19;          // current time,for storing19 in mem    
   input [82:0]        mem_read_data_add19;  // read data from mem                 
   input               age_confirmed19;      // valid flag19 from age19 checker        
   input               age_ok19;             // result from age19 checker 
   input               clear_reused19;       // read/clear flag19 for reused19 signal19           

   output [4:0]        d_port19;             // calculated19 destination19 port for tx19 
   output              add_check_active19;   // bit 0 of status register           
   output [7:0]        mem_addr_add19;       // hash19 address for R/W19 to memory     
   output              mem_write_add19;      // R/W19 flag19 (write = high19)            
   output [82:0]       mem_write_data_add19; // write data for memory             
   output [47:0]       lst_inv_addr_nrm19;   // last invalidated19 addr normal19 op    
   output [1:0]        lst_inv_port_nrm19;   // last invalidated19 port normal19 op    
   output              check_age19;          // request flag19 for age19 check
   output [31:0]       last_accessed19;      // time field sent19 for age19 check
   output              reused19;             // indicates19 ALUT19 location19 overwritten19

   reg   [2:0]         add_chk_state19;      // current address checker state
   reg   [2:0]         nxt_add_chk_state19;  // current address checker state
   reg   [4:0]         d_port19;             // calculated19 destination19 port for tx19 
   reg   [3:0]         port_mem19;           // bitwise19 conversion19 of 2bit port
   reg   [7:0]         mem_addr_add19;       // hash19 address for R/W19 to memory
   reg                 mem_write_add19;      // R/W19 flag19 (write = high19)            
   reg                 reused19;             // indicates19 ALUT19 location19 overwritten19
   reg   [47:0]        lst_inv_addr_nrm19;   // last invalidated19 addr normal19 op    
   reg   [1:0]         lst_inv_port_nrm19;   // last invalidated19 port normal19 op    
   reg                 check_age19;          // request flag19 for age19 checker
   reg   [31:0]        last_accessed19;      // time field sent19 for age19 check


   wire   [7:0]        s_addr_hash19;        // hash19 of address for storing19
   wire   [7:0]        d_addr_hash19;        // hash19 of address for checking
   wire   [82:0]       mem_write_data_add19; // write data for memory  
   wire                add_check_active19;   // bit 0 of status register           


// Parameters19 for Address Checking19 FSM19 states19
   parameter idle19           = 3'b000;
   parameter mac_addr_chk19   = 3'b001;
   parameter read_dest_add19  = 3'b010;
   parameter valid_chk19      = 3'b011;
   parameter age_chk19        = 3'b100;
   parameter addr_chk19       = 3'b101;
   parameter read_src_add19   = 3'b110;
   parameter write_src19      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash19 conversion19 of source19 and destination19 addresses19
// -----------------------------------------------------------------------------
   assign s_addr_hash19 = s_addr19[7:0] ^ s_addr19[15:8] ^ s_addr19[23:16] ^
                        s_addr19[31:24] ^ s_addr19[39:32] ^ s_addr19[47:40];

   assign d_addr_hash19 = d_addr19[7:0] ^ d_addr19[15:8] ^ d_addr19[23:16] ^
                        d_addr19[31:24] ^ d_addr19[39:32] ^ d_addr19[47:40];



// -----------------------------------------------------------------------------
//   State19 Machine19 For19 handling19 the destination19 address checking process and
//   and storing19 of new source19 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state19 or age_confirmed19 or age_ok19)
   begin
      case (add_chk_state19)
      
      idle19:
         if (command == 2'b01)
            nxt_add_chk_state19 = mac_addr_chk19;
         else
            nxt_add_chk_state19 = idle19;

      mac_addr_chk19:   // check if destination19 address match MAC19 switch19 address
         if (d_addr19 == mac_addr19)
            nxt_add_chk_state19 = idle19;  // return dest19 port as 5'b1_0000
         else
            nxt_add_chk_state19 = read_dest_add19;

      read_dest_add19:       // read data from memory using hash19 of destination19 address
            nxt_add_chk_state19 = valid_chk19;

      valid_chk19:      // check if read data had19 valid bit set
         nxt_add_chk_state19 = age_chk19;

      age_chk19:        // request age19 checker to check if still in date19
         if (age_confirmed19)
            nxt_add_chk_state19 = addr_chk19;
         else
            nxt_add_chk_state19 = age_chk19; 

      addr_chk19:       // perform19 compare between dest19 and read addresses19
            nxt_add_chk_state19 = read_src_add19; // return read port from ALUT19 mem

      read_src_add19:   // read from memory location19 about19 to be overwritten19
            nxt_add_chk_state19 = write_src19; 

      write_src19:      // write new source19 data (addr and port) to memory
            nxt_add_chk_state19 = idle19; 

      default:
            nxt_add_chk_state19 = idle19;
      endcase
   end


// destination19 check FSM19 current state
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      add_chk_state19 <= idle19;
   else
      add_chk_state19 <= nxt_add_chk_state19;
   end



// -----------------------------------------------------------------------------
//   Generate19 returned value of port for sending19 new frame19 to
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      d_port19 <= 5'b0_1111;
   else if ((add_chk_state19 == mac_addr_chk19) & (d_addr19 == mac_addr19))
      d_port19 <= 5'b1_0000;
   else if (((add_chk_state19 == valid_chk19) & ~mem_read_data_add19[82]) |
            ((add_chk_state19 == age_chk19) & ~(age_confirmed19 & age_ok19)) |
            ((add_chk_state19 == addr_chk19) & (d_addr19 != mem_read_data_add19[47:0])))
      d_port19 <= 5'b0_1111 & ~( 1 << s_port19 );
   else if ((add_chk_state19 == addr_chk19) & (d_addr19 == mem_read_data_add19[47:0]))
      d_port19 <= {1'b0, port_mem19} & ~( 1 << s_port19 );
   else
      d_port19 <= d_port19;
   end


// -----------------------------------------------------------------------------
//   convert read port source19 value from 2bits to bitwise19 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      port_mem19 <= 4'b1111;
   else begin
      case (mem_read_data_add19[49:48])
         2'b00: port_mem19 <= 4'b0001;
         2'b01: port_mem19 <= 4'b0010;
         2'b10: port_mem19 <= 4'b0100;
         2'b11: port_mem19 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded19 off19 add_chk_state19
// -----------------------------------------------------------------------------
assign add_check_active19 = (add_chk_state19 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate19 memory addressing19 signals19.
//   The check address command will be taken19 as the indication19 from SW19 that the 
//   source19 fields (address and port) can be written19 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19) 
   begin
       mem_write_add19 <= 1'b0;
       mem_addr_add19  <= 8'd0;
   end
   else if (add_chk_state19 == read_dest_add19)
   begin
       mem_write_add19 <= 1'b0;
       mem_addr_add19  <= d_addr_hash19;
   end
// Need19 to set address two19 cycles19 before check
   else if ( (add_chk_state19 == age_chk19) && age_confirmed19 )
   begin
       mem_write_add19 <= 1'b0;
       mem_addr_add19  <= s_addr_hash19;
   end
   else if (add_chk_state19 == write_src19)
   begin
       mem_write_add19 <= 1'b1;
       mem_addr_add19  <= s_addr_hash19;
   end
   else
   begin
       mem_write_add19 <= 1'b0;
       mem_addr_add19  <= d_addr_hash19;
   end
   end


// -----------------------------------------------------------------------------
//   Generate19 databus19 for writing to memory
//   Data written19 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add19 = {1'b1, curr_time19, s_port19, s_addr19};



// -----------------------------------------------------------------------------
//   Evaluate19 read back data that is about19 to be overwritten19 with new source19 
//   address and port values. Decide19 whether19 the reused19 flag19 must be set and
//   last_inval19 address and port values updated.
//   reused19 needs19 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19) 
   begin
      reused19 <= 1'b0;
      lst_inv_addr_nrm19 <= 48'd0;
      lst_inv_port_nrm19 <= 2'd0;
   end
   else if ((add_chk_state19 == read_src_add19) & mem_read_data_add19[82] &
            (s_addr19 != mem_read_data_add19[47:0]))
   begin
      reused19 <= 1'b1;
      lst_inv_addr_nrm19 <= mem_read_data_add19[47:0];
      lst_inv_port_nrm19 <= mem_read_data_add19[49:48];
   end
   else if (clear_reused19)
   begin
      reused19 <= 1'b0;
      lst_inv_addr_nrm19 <= lst_inv_addr_nrm19;
      lst_inv_port_nrm19 <= lst_inv_addr_nrm19;
   end
   else 
   begin
      reused19 <= reused19;
      lst_inv_addr_nrm19 <= lst_inv_addr_nrm19;
      lst_inv_port_nrm19 <= lst_inv_addr_nrm19;
   end
   end


// -----------------------------------------------------------------------------
//   Generate19 signals19 for age19 checker to perform19 in-date19 check
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19) 
   begin
      check_age19 <= 1'b0;  
      last_accessed19 <= 32'd0;
   end
   else if (check_age19)
   begin
      check_age19 <= 1'b0;  
      last_accessed19 <= mem_read_data_add19[81:50];
   end
   else if (add_chk_state19 == age_chk19)
   begin
      check_age19 <= 1'b1;  
      last_accessed19 <= mem_read_data_add19[81:50];
   end
   else 
   begin
      check_age19 <= 1'b0;  
      last_accessed19 <= 32'd0;
   end
   end


`ifdef ABV_ON19

// psl19 default clock19 = (posedge pclk19);

// ASSERTION19 CHECKS19
/* Commented19 out as also checking in toplevel19
// it should never be possible19 for the destination19 port to indicate19 the MAC19
// switch19 address and one of the other 4 Ethernets19
// psl19 assert_valid_dest_port19 : assert never (d_port19[4] & |{d_port19[3:0]});


// COVER19 SANITY19 CHECKS19
// check all values of destination19 port can be returned.
// psl19 cover_d_port_019 : cover { d_port19 == 5'b0_0001 };
// psl19 cover_d_port_119 : cover { d_port19 == 5'b0_0010 };
// psl19 cover_d_port_219 : cover { d_port19 == 5'b0_0100 };
// psl19 cover_d_port_319 : cover { d_port19 == 5'b0_1000 };
// psl19 cover_d_port_419 : cover { d_port19 == 5'b1_0000 };
// psl19 cover_d_port_all19 : cover { d_port19 == 5'b0_1111 };
*/
`endif


endmodule 









