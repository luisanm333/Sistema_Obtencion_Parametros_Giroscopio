---------------------------------------------------------------------------------
-- Escuela: 		E.S.I.M.E. IPN
-- Programadores: Luis Sánchez Márquez
--						Ricardo Flores Martínez
-- Asesor: 			M. en C. Luis Martin Flores Nava
-- Proyecto:   	TESIS
-- Modulo:     	Trans
-- Descripción: 	Transmision de datos del FPGA a LabVIEW
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use WORK.Componentes_pkg.ALL;

entity Trans is
port (	clk, rst: in  STD_LOGIC;
			tx : out  STD_LOGIC;
			etx : inout STD_LOGIC;
			V, T, P : in std_logic_vector(15 downto 0));	
end Trans;

architecture Arq of Trans is


begin

com1: serial port map (clk,rst,V,T,P,etx,tx);
com2: generador port map (clk,rst,etx);

end Arq;

