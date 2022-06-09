//File23 name   : alut_addr_checker23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

// compiler23 directives23
`include "alut_defines23.v"


module alut_addr_checker23
(   
   // Inputs23
   pclk23,
   n_p_reset23,
   command,
   mac_addr23,
   d_addr23,
   s_addr23,
   s_port23,
   curr_time23,
   mem_read_data_add23,
   age_confirmed23,
   age_ok23,
   clear_reused23,

   //outputs23
   d_port23,
   add_check_active23,
   mem_addr_add23,
   mem_write_add23,
   mem_write_data_add23,
   lst_inv_addr_nrm23,
   lst_inv_port_nrm23,
   check_age23,
   last_accessed23,
   reused23
);



   input               pclk23;               // APB23 clock23                           
   input               n_p_reset23;          // Reset23                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr23;           // address of the switch23              
   input [47:0]        d_addr23;             // address of frame23 to be checked23     
   input [47:0]        s_addr23;             // address of frame23 to be stored23      
   input [1:0]         s_port23;             // source23 port of current frame23       
   input [31:0]        curr_time23;          // current time,for storing23 in mem    
   input [82:0]        mem_read_data_add23;  // read data from mem                 
   input               age_confirmed23;      // valid flag23 from age23 checker        
   input               age_ok23;             // result from age23 checker 
   input               clear_reused23;       // read/clear flag23 for reused23 signal23           

   output [4:0]        d_port23;             // calculated23 destination23 port for tx23 
   output              add_check_active23;   // bit 0 of status register           
   output [7:0]        mem_addr_add23;       // hash23 address for R/W23 to memory     
   output              mem_write_add23;      // R/W23 flag23 (write = high23)            
   output [82:0]       mem_write_data_add23; // write data for memory             
   output [47:0]       lst_inv_addr_nrm23;   // last invalidated23 addr normal23 op    
   output [1:0]        lst_inv_port_nrm23;   // last invalidated23 port normal23 op    
   output              check_age23;          // request flag23 for age23 check
   output [31:0]       last_accessed23;      // time field sent23 for age23 check
   output              reused23;             // indicates23 ALUT23 location23 overwritten23

   reg   [2:0]         add_chk_state23;      // current address checker state
   reg   [2:0]         nxt_add_chk_state23;  // current address checker state
   reg   [4:0]         d_port23;             // calculated23 destination23 port for tx23 
   reg   [3:0]         port_mem23;           // bitwise23 conversion23 of 2bit port
   reg   [7:0]         mem_addr_add23;       // hash23 address for R/W23 to memory
   reg                 mem_write_add23;      // R/W23 flag23 (write = high23)            
   reg                 reused23;             // indicates23 ALUT23 location23 overwritten23
   reg   [47:0]        lst_inv_addr_nrm23;   // last invalidated23 addr normal23 op    
   reg   [1:0]         lst_inv_port_nrm23;   // last invalidated23 port normal23 op    
   reg                 check_age23;          // request flag23 for age23 checker
   reg   [31:0]        last_accessed23;      // time field sent23 for age23 check


   wire   [7:0]        s_addr_hash23;        // hash23 of address for storing23
   wire   [7:0]        d_addr_hash23;        // hash23 of address for checking
   wire   [82:0]       mem_write_data_add23; // write data for memory  
   wire                add_check_active23;   // bit 0 of status register           


// Parameters23 for Address Checking23 FSM23 states23
   parameter idle23           = 3'b000;
   parameter mac_addr_chk23   = 3'b001;
   parameter read_dest_add23  = 3'b010;
   parameter valid_chk23      = 3'b011;
   parameter age_chk23        = 3'b100;
   parameter addr_chk23       = 3'b101;
   parameter read_src_add23   = 3'b110;
   parameter write_src23      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash23 conversion23 of source23 and destination23 addresses23
// -----------------------------------------------------------------------------
   assign s_addr_hash23 = s_addr23[7:0] ^ s_addr23[15:8] ^ s_addr23[23:16] ^
                        s_addr23[31:24] ^ s_addr23[39:32] ^ s_addr23[47:40];

   assign d_addr_hash23 = d_addr23[7:0] ^ d_addr23[15:8] ^ d_addr23[23:16] ^
                        d_addr23[31:24] ^ d_addr23[39:32] ^ d_addr23[47:40];



// -----------------------------------------------------------------------------
//   State23 Machine23 For23 handling23 the destination23 address checking process and
//   and storing23 of new source23 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state23 or age_confirmed23 or age_ok23)
   begin
      case (add_chk_state23)
      
      idle23:
         if (command == 2'b01)
            nxt_add_chk_state23 = mac_addr_chk23;
         else
            nxt_add_chk_state23 = idle23;

      mac_addr_chk23:   // check if destination23 address match MAC23 switch23 address
         if (d_addr23 == mac_addr23)
            nxt_add_chk_state23 = idle23;  // return dest23 port as 5'b1_0000
         else
            nxt_add_chk_state23 = read_dest_add23;

      read_dest_add23:       // read data from memory using hash23 of destination23 address
            nxt_add_chk_state23 = valid_chk23;

      valid_chk23:      // check if read data had23 valid bit set
         nxt_add_chk_state23 = age_chk23;

      age_chk23:        // request age23 checker to check if still in date23
         if (age_confirmed23)
            nxt_add_chk_state23 = addr_chk23;
         else
            nxt_add_chk_state23 = age_chk23; 

      addr_chk23:       // perform23 compare between dest23 and read addresses23
            nxt_add_chk_state23 = read_src_add23; // return read port from ALUT23 mem

      read_src_add23:   // read from memory location23 about23 to be overwritten23
            nxt_add_chk_state23 = write_src23; 

      write_src23:      // write new source23 data (addr and port) to memory
            nxt_add_chk_state23 = idle23; 

      default:
            nxt_add_chk_state23 = idle23;
      endcase
   end


// destination23 check FSM23 current state
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      add_chk_state23 <= idle23;
   else
      add_chk_state23 <= nxt_add_chk_state23;
   end



// -----------------------------------------------------------------------------
//   Generate23 returned value of port for sending23 new frame23 to
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      d_port23 <= 5'b0_1111;
   else if ((add_chk_state23 == mac_addr_chk23) & (d_addr23 == mac_addr23))
      d_port23 <= 5'b1_0000;
   else if (((add_chk_state23 == valid_chk23) & ~mem_read_data_add23[82]) |
            ((add_chk_state23 == age_chk23) & ~(age_confirmed23 & age_ok23)) |
            ((add_chk_state23 == addr_chk23) & (d_addr23 != mem_read_data_add23[47:0])))
      d_port23 <= 5'b0_1111 & ~( 1 << s_port23 );
   else if ((add_chk_state23 == addr_chk23) & (d_addr23 == mem_read_data_add23[47:0]))
      d_port23 <= {1'b0, port_mem23} & ~( 1 << s_port23 );
   else
      d_port23 <= d_port23;
   end


// -----------------------------------------------------------------------------
//   convert read port source23 value from 2bits to bitwise23 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      port_mem23 <= 4'b1111;
   else begin
      case (mem_read_data_add23[49:48])
         2'b00: port_mem23 <= 4'b0001;
         2'b01: port_mem23 <= 4'b0010;
         2'b10: port_mem23 <= 4'b0100;
         2'b11: port_mem23 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded23 off23 add_chk_state23
// -----------------------------------------------------------------------------
assign add_check_active23 = (add_chk_state23 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate23 memory addressing23 signals23.
//   The check address command will be taken23 as the indication23 from SW23 that the 
//   source23 fields (address and port) can be written23 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23) 
   begin
       mem_write_add23 <= 1'b0;
       mem_addr_add23  <= 8'd0;
   end
   else if (add_chk_state23 == read_dest_add23)
   begin
       mem_write_add23 <= 1'b0;
       mem_addr_add23  <= d_addr_hash23;
   end
// Need23 to set address two23 cycles23 before check
   else if ( (add_chk_state23 == age_chk23) && age_confirmed23 )
   begin
       mem_write_add23 <= 1'b0;
       mem_addr_add23  <= s_addr_hash23;
   end
   else if (add_chk_state23 == write_src23)
   begin
       mem_write_add23 <= 1'b1;
       mem_addr_add23  <= s_addr_hash23;
   end
   else
   begin
       mem_write_add23 <= 1'b0;
       mem_addr_add23  <= d_addr_hash23;
   end
   end


// -----------------------------------------------------------------------------
//   Generate23 databus23 for writing to memory
//   Data written23 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add23 = {1'b1, curr_time23, s_port23, s_addr23};



// -----------------------------------------------------------------------------
//   Evaluate23 read back data that is about23 to be overwritten23 with new source23 
//   address and port values. Decide23 whether23 the reused23 flag23 must be set and
//   last_inval23 address and port values updated.
//   reused23 needs23 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23) 
   begin
      reused23 <= 1'b0;
      lst_inv_addr_nrm23 <= 48'd0;
      lst_inv_port_nrm23 <= 2'd0;
   end
   else if ((add_chk_state23 == read_src_add23) & mem_read_data_add23[82] &
            (s_addr23 != mem_read_data_add23[47:0]))
   begin
      reused23 <= 1'b1;
      lst_inv_addr_nrm23 <= mem_read_data_add23[47:0];
      lst_inv_port_nrm23 <= mem_read_data_add23[49:48];
   end
   else if (clear_reused23)
   begin
      reused23 <= 1'b0;
      lst_inv_addr_nrm23 <= lst_inv_addr_nrm23;
      lst_inv_port_nrm23 <= lst_inv_addr_nrm23;
   end
   else 
   begin
      reused23 <= reused23;
      lst_inv_addr_nrm23 <= lst_inv_addr_nrm23;
      lst_inv_port_nrm23 <= lst_inv_addr_nrm23;
   end
   end


// -----------------------------------------------------------------------------
//   Generate23 signals23 for age23 checker to perform23 in-date23 check
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23) 
   begin
      check_age23 <= 1'b0;  
      last_accessed23 <= 32'd0;
   end
   else if (check_age23)
   begin
      check_age23 <= 1'b0;  
      last_accessed23 <= mem_read_data_add23[81:50];
   end
   else if (add_chk_state23 == age_chk23)
   begin
      check_age23 <= 1'b1;  
      last_accessed23 <= mem_read_data_add23[81:50];
   end
   else 
   begin
      check_age23 <= 1'b0;  
      last_accessed23 <= 32'd0;
   end
   end


`ifdef ABV_ON23

// psl23 default clock23 = (posedge pclk23);

// ASSERTION23 CHECKS23
/* Commented23 out as also checking in toplevel23
// it should never be possible23 for the destination23 port to indicate23 the MAC23
// switch23 address and one of the other 4 Ethernets23
// psl23 assert_valid_dest_port23 : assert never (d_port23[4] & |{d_port23[3:0]});


// COVER23 SANITY23 CHECKS23
// check all values of destination23 port can be returned.
// psl23 cover_d_port_023 : cover { d_port23 == 5'b0_0001 };
// psl23 cover_d_port_123 : cover { d_port23 == 5'b0_0010 };
// psl23 cover_d_port_223 : cover { d_port23 == 5'b0_0100 };
// psl23 cover_d_port_323 : cover { d_port23 == 5'b0_1000 };
// psl23 cover_d_port_423 : cover { d_port23 == 5'b1_0000 };
// psl23 cover_d_port_all23 : cover { d_port23 == 5'b0_1111 };
*/
`endif


endmodule 









