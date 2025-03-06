{1. Realizar un algoritmo que cree un archivo de números 
enteros no ordenados y permita incorporar datos al archivo. 
Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. 
La carga finaliza cuando se ingrese el número 30000, que no debe 
incorporarse al archivo.}

program ejeUnoCase;

type
	
	tEntero=integer;
	archivo_numeros=file of tEntero;
	
var
	numeros:archivo_numeros;
	nombre_fisico:string[12];
	num:tEntero;
	opc:byte;
	
begin
	writeln('----Programa Numeros----');
	writeln;
	writeln('0.Terminar el programa');
	writeln('1.Crear un archivo de numeros enteros');
	writeln('2.Cargar numero en el archivo creado');
	writeln('3.Leer archivo');

	repeat
		writeln();
		writeln('Elija una opcion: ');
		readln(opc);
		writeln;
		
		case opc of
			1:begin
				writeln('Ingrese el nombre del Archivo a crear');
				readln(nombre_fisico);
				assign(numeros,nombre_fisico);
				
				rewrite(numeros);
				
				writeln('Ingrese numeros enteros, finaliza con 30000:');
				repeat
					readln(num);
					if (num<>30000) then
						write(numeros,num);
				until(num=30000);
				close(numeros);
				
				writeln('Archivo creado correctamente')	
			end;
			
			2:begin
				writeln('Ingrese el nombre del archivo al cual quiere agregar valores: ');
				readln(nombre_fisico);
				
				assign(numeros,nombre_fisico);
				reset(numeros);
				
				writeln('Ingrese numero enteros ,finaliza con 30000: ');
				repeat
					readln(num);
					if (num<>30000) then 
						write(numeros,num)
				until(num=30000);
				close(numeros);
				
				writeln('Numeros agregados correctamente');
			end;
			3:begin
				writeln('Ingrse el nombre del archivo que quiere leer: ');
				readln(nombre_fisico);
			
				assign(numeros,nombre_fisico);
				reset(numeros);
				while not eof(numeros) do begin
					read(numeros,num);
					write('-',num);
				end;
				
			end;
		end;
	until (opc=0);
end.

