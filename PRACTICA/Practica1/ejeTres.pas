{
   3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
   
   
}


program ejeTres;

type

	empleado=record
		nro:integer;
		apellido:string[20];
		nombre:string[20];
		edad:integer;
		dni:integer;
	end;
		
	empleados=file of empleado; 
	
var
	E:empleados; 
	emp:empleado;
	nomArchivo:string[20];
	opc:byte;
	apellidoBuscado:string[20];
	nombreBuscado:string[20];
	found:boolean;
	
begin
	repeat
		writeln('Elija una opcion: ');
		
		writeln('--------------');
		writeln('0.Salir');
		writeln('1.Crear Archivo');
		writeln('2.Buscar Empleado y Listar Datos');
		writeln('3.Listar Empleados');
		writeln('4.Empleados mayores de 70 años');
		
		readln(opc);

		if (opc=1) or (opc=2) or (opc=3) or (opc=4) then begin
			writeln('Ingrese el nombre del archivo a crear o utilizar');
			readln(nomArchivo);
			assign(E,nomArchivo + '.dat');
		end;
		
		case opc of
			1:begin
				rewrite(E);
				with emp do begin
					writeln('Ingrese el numero de empleado: ');readln(nro);
					writeln('Ingrese el apellido ("fin" para salir"): '); readln(apellido);
					while (apellido <> 'fin') do begin
						writeln('Ingrese el nombre: ');readln(nombre);
						writeln('Ingrese la edad: ');readln(edad);
						writeln('Ingrese el dni: ');readln(dni);
						write(E,emp);
						writeln('Ingrese el numero de empleado: ');readln(nro);
						writeln('Ingrese el apellido ("fin" para salir"): ');readln(apellido);
					end;
				end;	
				close(E);
			end;
			2:begin
				writeln('Ingrese el nombre del empleado a buscar: ');readln(nombreBuscado);
				writeln('Ingrese el apellido del empleado a buscar: ');readln(apellidoBuscado);
				reset(E);{ABRIR EL ARCHIVO}
					while not eof(E) do begin
						read(E,emp);{LEER el archivo}
						if (emp.apellido=apellidoBuscado) or (emp.nombre=nombreBuscado) then begin
							writeln('++++++++++++++++++++');
							writeln('Nombre: ',emp.nombre);
							writeln('Apellido: ',emp.apellido);
							writeln('Numero de empleado: ',emp.nro);
							writeln('Edad: ',emp.edad);
							writeln('DNI: ',emp.dni);
							writeln('++++++++++++++++++++');
						end;
					end;
				close(E);{CERRAR EL ARCHIVO}
			end;
			3:begin
				reset(E);
				while not eof(E) do begin
					read(E,emp);
					writeln('++++++++++++++++++++');
					writeln('Nombre: ',emp.nombre);
					writeln('Apellido: ',emp.apellido);
					writeln('Numero de empleado: ',emp.nro);
					writeln('Edad: ',emp.edad);
					writeln('DNI: ',emp.dni);
				end;	
				close(E);
			end;
			4:begin
				reset(E);
				found:=false;
				while not eof(E) do begin
					read(E,emp);
					if (emp.edad>70) then begin
						writeln('--------------------');
						writeln('Empleados con mas de 70 años');
						writeln('++++++++++++++++++++');
						found:=true;
						writeln('Nombre: ',emp.nombre);
						writeln('Apellido: ',emp.apellido);
						writeln('Numero de empleado: ',emp.nro);
						writeln('Edad: ',emp.edad);
						writeln('DNI: ',emp.dni);
					end;
				end;
				if not found then
					writeln('No hay empleados con mas de 70 años');
				close(E);	
			end;
		end;
		
	until(opc=0);
	
end.
	
	
