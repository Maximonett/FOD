{
 2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
}


program ejeDos;

type

	tEntero=integer; 
	archivo_numeros=file of tEntero;
	
var
	num:tEntero;
	numeros:archivo_numeros;
	nombre_fisico:string[12];
	opc:byte;
	contadorMenores:integer;
	cantidad:integer;
	suma:integer;
	promedio:real;
begin

	repeat 
		
		writeln('-----------------');
		writeln('Elija una opcion: ');
		writeln();
		writeln('0.Salir');
		writeln('1.Crear Archivo');
		writeln('2.Agregar numeros');
		writeln('3.Imprimir');
		writeln('4.Cantidad de numeros Menosres a 1500');
		writeln('5.Promedio Total y cantidad Total de numeros ingresados');
	
		readln(opc);
		
		if (opc=1)or (opc=2) or (opc=3) or (opc=4) or (opc=5) then begin
			writeln('Nombre del archivo a crear o a utilizar');
			readln(nombre_fisico);
			assign(numeros,nombre_fisico);
		end;
		
		case opc of 
			1:begin
				rewrite(numeros);
				writeln('Ingrese numeros Enteros (finaliza con 30000)');
				repeat
					readln(num);
					if (num<>30000) then
						write(numeros,num);
				until( num=30000);
				close(numeros);
				writeln('Numeros ingresados correctamente');
			end;
			2:begin
				reset(numeros);
				writeln('Ingrese los numeros que desea agregar (finaliza con 30000');
				repeat
					readln(num);
					if(num<>30000)then
						write(numeros,num);
				until(num=30000);
				close(numeros);
				writeln('Numeros ingresados correctamente');
			end;
			3:begin
				reset(numeros);
				while not eof(numeros) do begin
					read(numeros,num);
					writeln('-',num);
				end;
			end;
			4:begin
				reset(numeros);
				contadorMenores:=0;
				while not eof(numeros) do begin
					read(numeros,num);
					if (num<1500) then
						contadorMenores:=contadorMenores+1;
				end;
				writeln();
				writeln('La cantidad de numeros menores a 1500 es: ',contadorMenores);
			end;
			5:begin
				reset(numeros);
				suma:=0;
				cantidad:=0;
				while not eof(numeros) do begin
					read(numeros,num);
					suma:=suma+num;
					cantidad:=cantidad+1;
				end;
				promedio:=suma/cantidad;
				writeln('El promedio de los numeros insertados es de ',promedio:0:2);
				writeln();
				writeln('La cantidad de numeros insertados es ',cantidad);
			end;
		end;
	until(opc=0);
end.

