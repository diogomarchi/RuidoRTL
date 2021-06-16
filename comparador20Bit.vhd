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

ENTITY comparador20Bit IS
  PORT (
    i_ADDR : IN  STD_LOGIC_VECTOR(19 DOWNTO 0); -- data input 1	 
	 i_COMPARE : IN  STD_LOGIC_VECTOR(19 DOWNTO 0); -- data input 2
    o_Q : OUT STD_LOGIC                 -- data output
  );
END comparador20Bit;

ARCHITECTURE arch_1 OF comparador20Bit IS

BEGIN
  -- SAIDA
  o_Q <= '1' WHEN (i_ADDR = i_COMPARE) ELSE '0';

END arch_1;
