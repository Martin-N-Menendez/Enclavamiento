library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity FSM_Belgrano_tb is
end;

architecture FSM_Belgrano_tb_arq of FSM_Belgrano_tb is
	-- Parte declarativa
	component FSM_Belgrano is
		generic( N: natural := 12 );
		port(
			Circuito_Via: in std_logic_vector(N-1 downto 0);
			clock,reset: in std_logic;
			ruta: in integer; 
			Semaforos: out SEMAFORO;
			Maquina: out std_logic;
			PaN: out std_logic
		);
	end component;
	
	constant N_tb: natural := 12;
	constant N_SM_tb: natural := 16;
	constant delay: time := 500 ns;
	
	signal Circuito_Via_tb: std_logic_vector(N_tb-1 downto 0) := (N_tb-1 downto 0 => '0');
	signal ruta_tb: integer := 0;
	signal clock_tb: std_logic := '0';
	signal reset_tb: std_logic := '0';
	signal Semaforos_tb: SEMAFORO;
	signal Maquina_tb: std_logic;
	signal PaN_tb: std_logic;
begin
	clock_tb <= not clock_tb after 10 ns;
	reset_tb <= '1' after 5000 ns;

	RUTAS: process 
	begin
		wait for delay;
		ruta_tb <= 1;
		wait for delay;
		ruta_tb <= 2;
		wait for delay;
		ruta_tb <= 3;
		wait for delay;
		ruta_tb <= 4;
		wait for delay;
		ruta_tb <= 5;
		wait for delay;
		ruta_tb <= 6;
		wait for 1000 ns;
	end process RUTAS;

	DUT: FSM_Belgrano
		port map(
			Circuito_Via => Circuito_Via_tb,
			ruta => ruta_tb,
			clock => clock_tb,
			reset => reset_tb,
			Semaforos => Semaforos_tb,
			Maquina => Maquina_tb,
			PaN => PaN_tb
		);
end;