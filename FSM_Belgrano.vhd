library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity FSM_Belgrano is
	generic( N: natural := 12 );
	port(
		Circuito_Via: in std_logic_vector(N-1 downto 0);
		clock,reset: in std_logic;
		ruta: in integer; 
		Semaforos: out SEMAFORO;
		Maquina: out std_logic;
		PaN: out std_logic
	);
end FSM_Belgrano;

architecture FSM_Belgrano_arq of FSM_Belgrano is
	constant N_CV: natural := 12;
	constant N_SM: natural := 16;
	constant N_rutas: natural := 6;	
	
	type rutas is (RUTA0,RUTA1,RUTA2,RUTA3,RUTA4,RUTA5,RUTA6,RUTA7,RUTA8,RUTA9,RUTA10,RUTA11,RUTA12,RUTA13,RUTA14);
	type circuitos_t is (CIRC1,CIRC2,CIRC3,CIRC4,CIRC5,CIRC6,CIRC7,CIRC8,CIRC9,CIRC10,CIRC11,CIRC12);
	type semaforos_t is (SEM_A,SEM_B,SEM_C,SEM_D,SEM_E,SEM_F,SEM_G,SEM_H,SEM_I,SEM_J,SEM_K,SEM_L,SEM_M,SEM_N,SEM_O,SEM_P,SEM_Q);
	
	signal ruta_ascendente: rutas;
	signal ruta_descendente: rutas;
	
	constant OCUPADO: std_logic := '0';
	constant LIBRE: std_logic := '1';
	constant ROJO: SM_ESTADO := "00";		--  0
	constant AMARILLO: SM_ESTADO := "01";	-- +1
	constant VERDE: SM_ESTADO := "11";		-- -1
	constant NORMAL: std_logic := '0';
	constant REVERSA: std_logic := '1';
	constant BARRERA_BAJA: std_logic := '0';
	constant BARRERA_ALTA: std_logic := '1';	
	
	signal habilitacion: std_logic_vector(N_rutas downto 0);
	signal PaN_ASC: std_logic := '0';
	signal PaN_DES: std_logic := '0';
	
begin	
	
	habilitacion(rutas'pos(RUTA0)) <= '1';
	habilitacion(rutas'pos(RUTA1)) <= '1' when 
						 Circuito_Via(circuitos_t'pos(CIRC1)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA2)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC1)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA3)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA4)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA5)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
	habilitacion(rutas'pos(RUTA6)) <= '1' when
						 Circuito_Via(circuitos_t'pos(CIRC2)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC3)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC4)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC5)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC6)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC7)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC8)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC9)) = OCUPADO and 
						 Circuito_Via(circuitos_t'pos(CIRC10)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC11)) = LIBRE and 
						 Circuito_Via(circuitos_t'pos(CIRC12)) = LIBRE else '0';
		
	ASCENDENTE: process(clock, reset)
	begin
		if (reset = '1') then
			ruta_ascendente <= RUTA0;
		elsif (clock'event and clock='1') then
			if (ruta = 1 and habilitacion(rutas'pos(RUTA1)) = '1') then
				ruta_ascendente <= RUTA1;
			end if;
			if (ruta = 2 and habilitacion(rutas'pos(RUTA2)) = '1') then
				ruta_ascendente <= RUTA2;
			end if;
			if (ruta = 5 and habilitacion(rutas'pos(RUTA5)) = '1') then
				ruta_ascendente <= RUTA5;
			end if;
			if (ruta = 6 and habilitacion(rutas'pos(RUTA6)) = '1') then
				ruta_ascendente <= RUTA6;
			end if;
		end if;
	end process ASCENDENTE;	
	
	DESCENDENTE: process(clock, reset)
	begin
		if (reset = '1') then
			ruta_descendente <= RUTA0;
		elsif (clock'event and clock='1') then
			if (ruta = 3 and habilitacion(rutas'pos(RUTA3)) = '1') then
				ruta_descendente <= RUTA3;
			end if;
			if (ruta = 4 and habilitacion(rutas'pos(RUTA4)) = '1') then
				ruta_descendente <= RUTA4;
			end if;
			if (ruta = 5 and habilitacion(rutas'pos(RUTA5)) = '1') then
				ruta_descendente <= RUTA5;
			end if;
			if (ruta = 6 and habilitacion(rutas'pos(RUTA6)) = '1') then
				ruta_descendente <= RUTA6;
			end if;
		end if;
	end process DESCENDENTE;
	
	RUTA_ASC: process (ruta_ascendente,clock)
	begin
		if (clock'event and clock ='1') then
		case ruta_ascendente is
			when RUTA0 => -- Ruta no asignada
				Semaforos(semaforos_t'pos(SEM_A)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_B)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_C)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_D)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_F)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_G)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_H)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_I)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= ROJO;
				Maquina <= NORMAL;
				PaN_ASC <= BARRERA_BAJA;
			when RUTA1 => 
				Semaforos(semaforos_t'pos(SEM_A)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_B)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_C)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_D)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;			
				Maquina <= NORMAL;
				PaN_ASC <= BARRERA_BAJA;
				--contador
			when RUTA2 => 
				Semaforos(semaforos_t'pos(SEM_A)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_B)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_C)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_D)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;			
				Maquina <= NORMAL;
				PaN_ASC <= BARRERA_BAJA;
			when RUTA3 => Maquina <= NORMAL;
			when RUTA4 => Maquina <= NORMAL;
			when RUTA5 => Maquina <= NORMAL;
				Semaforos(semaforos_t'pos(SEM_A)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_B)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_C)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_D)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_F)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_G)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_H)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_I)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;	
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= VERDE;
				Maquina <= REVERSA;
				PaN_ASC <= BARRERA_BAJA;
			when RUTA6 =>
				Semaforos(semaforos_t'pos(SEM_A)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_B)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_C)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_D)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_F)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_G)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_H)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_I)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;	
				Semaforos(semaforos_t'pos(SEM_L)) <= AMARILLO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= ROJO;
				Maquina <= REVERSA;
				PaN_ASC <= BARRERA_BAJA;
			when RUTA7 => Maquina <= NORMAL;	
			when RUTA8 => Maquina <= NORMAL;
			when RUTA9 => Maquina <= NORMAL;
			when RUTA10 => Maquina <= NORMAL;
			when RUTA11 => Maquina <= NORMAL;
			when RUTA12 => Maquina <= NORMAL;
			when RUTA13 => Maquina <= NORMAL;
			when RUTA14 => Maquina <= NORMAL;
		end case;
		end if;		
	end process RUTA_ASC;
	
	RUTA_DES: process (ruta_descendente,clock)
	begin
		if (clock'event and clock ='1') then
		case ruta_descendente is
			when RUTA0 => -- Ruta no asignada
				Semaforos(semaforos_t'pos(SEM_A)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_B)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_C)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_D)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_F)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_G)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_H)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_I)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= ROJO;
				Maquina <= NORMAL;
				PaN_DES <= BARRERA_BAJA;
			when RUTA1 => Maquina <= NORMAL;
			when RUTA2 => Maquina <= NORMAL;
			when RUTA3 => Maquina <= NORMAL;
				Semaforos(semaforos_t'pos(SEM_F)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_G)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_H)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_I)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= ROJO;			
				Maquina <= NORMAL;
				PaN_DES <= BARRERA_BAJA;
				--contador
			when RUTA4 => 
				Semaforos(semaforos_t'pos(SEM_F)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_G)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_H)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_I)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= ROJO;			
				Maquina <= NORMAL;
				PaN_DES <= BARRERA_ALTA;
			when RUTA5 =>
				Semaforos(semaforos_t'pos(SEM_A)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_B)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_C)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_D)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_F)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_G)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_H)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_I)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;	
				Semaforos(semaforos_t'pos(SEM_L)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= VERDE;
				Maquina <= REVERSA;
				PaN_DES <= BARRERA_BAJA;
			when RUTA6 =>
				Semaforos(semaforos_t'pos(SEM_A)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_B)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_C)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_D)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_E)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_F)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_G)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_H)) <= VERDE;
				Semaforos(semaforos_t'pos(SEM_I)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_J)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_K)) <= ROJO;	
				Semaforos(semaforos_t'pos(SEM_L)) <= AMARILLO;
				Semaforos(semaforos_t'pos(SEM_M)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_N)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_O)) <= ROJO;
				Semaforos(semaforos_t'pos(SEM_P)) <= ROJO;
				Maquina <= REVERSA;
				PaN_DES <= BARRERA_BAJA;
			when RUTA7 => Maquina <= NORMAL;
			when RUTA8 => Maquina <= NORMAL;
			when RUTA9 => Maquina <= NORMAL;
			when RUTA10 => Maquina <= NORMAL;
			when RUTA11 => Maquina <= NORMAL;
			when RUTA12 => Maquina <= NORMAL;
			when RUTA13 => Maquina <= NORMAL;
			when RUTA14 => Maquina <= NORMAL;
		end case;
		end if;		
	end process RUTA_DES;
	
	BARRERAS: process(clock, reset)
	begin
		if (reset = '1') then
			PaN <= BARRERA_BAJA;
		elsif (clock'event and clock='1') then
			PaN <= PaN_ASC and PaN_DES;
		end if;
	end process BARRERAS;
	
end architecture;