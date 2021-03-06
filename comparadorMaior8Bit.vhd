------------------------------------------------
-- Design: comparador 8 bits
-- Entity: comparador
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 03/15/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY comparadorMaior8Bit IS
  PORT (
    i_A : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 1	 
	 i_B : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
END comparadorMaior8Bit;

ARCHITECTURE arch_1 OF comparadorMaior8Bit IS

BEGIN
  -- SAIDA
  o_Q <= '1' WHEN (i_A > i_B) ELSE '0';

END arch_1;
