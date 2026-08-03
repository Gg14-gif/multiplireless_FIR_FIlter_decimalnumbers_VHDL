library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Project0 is
    port (
        clk : in std_logic;
        d_in : in std_logic;
        
        q_out : out std_logic_vector(17 downto 0)
    );
end entity;

architecture rtl of Project0 is
-- D FLIP FLOPS
  signal  q0_to_q1 :std_logic := '0';
  signal  q1_to_q2 :std_logic := '0';
  signal  q2_to_q3 :std_logic  := '0';
  signal  q3_to_end :std_logic := '0';
  --Hilfsumwandlung°
   signal q0_to_q1_16bit : unsigned(15 downto 0);
   signal q1_to_q2_16bit : unsigned(15 downto 0);
   signal q2_to_q3_16bit : unsigned(15 downto 0);
   signal q3_to_end_16bit :unsigned(15 downto 0);
  --SHIFTER ERSTE MULTIPLIKATION° 
  signal input_shifter : unsigned(15 downto 0);--1ter°0,9
  signal input_x_times_8 :  unsigned(19 downto 0);
  signal input_x_add_1 : unsigned (19 downto 0);
  signal input_x_is_9    : unsigned (19 downto 0);
  
  signal input_shifter_1 : unsigned(15 downto 0);--2ter° 0,8
  signal input_x_times_8_1 :  unsigned(19 downto 0);
  
  signal input_shifter_2 : unsigned(15 downto 0);--3ter° 0,7
  signal input_x_times_8_2 :unsigned(19 downto 0);
  signal input_x_subtract_1 :unsigned(19 downto 0);
  signal input_x_is_7  : unsigned (19 downto 0);     
  
  -- SHIFTER 2 TE MULTIPLIKATION°
  signal input_x_times_205 :unsigned (27 downto 0);--1ter°
  signal input_x_divided_2048 : unsigned (27 downto 0);
  
  signal input_x_times_205_1 :unsigned (27 downto 0);--2ter°
  signal input_x_divided_2048_1 : unsigned (27 downto 0);
  
   signal input_x_times_205_2:unsigned (27 downto 0);--3ter°
  signal input_x_divided_2048_2 : unsigned (27 downto 0);
  -- ADDER
  signal input_x_adder : unsigned(17 downto 0);
begin
--Hilfsumwandlung 2 wir packen die mit nullen voll°
 q0_to_q1_16bit  <= unsigned'("000000000000000" & q0_to_q1);
 q1_to_q2_16bit  <= unsigned'("000000000000000" & q1_to_q2);
 q2_to_q3_16bit  <= unsigned'("000000000000000" & q2_to_q3);
 q3_to_end_16bit <= unsigned'("000000000000000" & q3_to_end);
    
     -- SHIFTER 9° 
 input_x_times_8 <= resize(shift_left(q1_to_q2_16bit ,3) , 20);--mal8
 input_x_add_1 <= resize((q1_to_q2_16bit) ,20 );
 input_x_is_9 <= input_x_add_1 + input_x_times_8;
  --SHIFTER 8°
input_x_times_8_1<= resize(shift_left(q2_to_q3_16bit ,3) ,20);--mal8
--SHIFTER 7
input_x_times_8_2 <= resize(shift_left(q3_to_end_16bit ,3) , 20);
input_x_subtract_1 <= resize((q3_to_end_16bit) ,20);
 input_x_is_7 <= input_x_times_8_2 - input_x_subtract_1;
     --SHIFTER 2 TE MULTIPLIKATION
 input_x_times_205 <= input_x_is_9 * to_unsigned(205,8); --1ter°
 input_x_divided_2048 <= shift_right(input_x_times_205,11);
  
 input_x_times_205_1 <= input_x_times_8_1* to_unsigned(205,8); --2ter°
 input_x_divided_2048_1 <= shift_right(input_x_times_205_1,11);
 
input_x_times_205_2 <= input_x_is_7* to_unsigned(205,8); --3ter°
 input_x_divided_2048_2 <= shift_right(input_x_times_205_2,11);
  
      -- Addierer
 input_x_adder <= resize(q0_to_q1_16bit ,18) +
                   resize(input_x_divided_2048(15 downto 0),18) +
                   resize(input_x_divided_2048_1(15 downto 0),18) +
                  resize( input_x_divided_2048_2(15 downto 0),18);  
    process(clk)
    begin
        if rising_edge(clk) then
        -- D FLIPFLOPS
            q0_to_q1 <= d_in;
            q1_to_q2 <= q0_to_q1;
            q2_to_q3 <= q1_to_q2;
            q3_to_end <= q2_to_q3;
         
            q_out <= std_logic_vector(input_x_adder);
        end if;
        
    end process;
end architecture rtl;
