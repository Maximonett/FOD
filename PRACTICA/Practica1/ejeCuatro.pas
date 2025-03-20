{
   4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.
   
   
}

program ejeCuatro;

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
	numeroBuscado:integer;
	archivoSalida:string[30];
	carga:Text;

procedure buscarEmpleadoXNro(var E:empleados; var esta:boolean; nroBuscado:integer);
var 
	emp:empleado;
begin
	esta:=false;
	while not eof(E) do begin
		read(E,emp);
		if (emp.nro=nroBuscado) then 
			esta:=true;
	end;
end;
	
	
begin
	
	
	repeat
		writeln('Elija una opcion: ');
		
		writeln('--------------');
		writeln('0.Salir');
		writeln('1.Crear Archivo');
		writeln('2.Buscar Empleado y Listar Datos');
		writeln('3.Listar Empleados');
		writeln('4.Empleados mayores de 70 años');
		writeln('5.Agregar empleados');
		writeln('6.Modificar la edad');
		writeln('7.Exportar a un .TXT (todos_empleados.txt)');
		writeln('8.Exportar a .TXT empleados que no hayan agregado el DNI(faltaDNIEmpleado.txt)');
		readln(opc);

		if (opc=1) or (opc=2) or (opc=3) or (opc=4) or (opc=5) or (opc=6) or (opc=7) or (opc=8) then begin
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
			5:begin 
				reset(E);
				with emp do begin
					writeln('Ingrese el numero de empleado: ');readln(nro);
					buscarEmpleadoXNro(E,found,nro);
					if found then
						writeln('El empleado ya esta registrado')
					else begin
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
				end;
				close(E);
			end;
			6:begin
				reset(E);
				writeln('Ingrese el número de empleado a modificar su edad:'); 
				readln(numeroBuscado);
    
				found := false;
    
				while (not eof(E)) and (not found) do begin
					read(E, emp); // Leer el registro
        
					if (emp.nro = numeroBuscado) then begin
						found := true;
						writeln('Edad actual: ', emp.edad);
						writeln('Ingrese la nueva edad: ');
						readln(emp.edad);
            
			// Mover el puntero atrás una posición antes de escribir el registro modificado
						seek(E, FilePos(E) - 1);
						write(E, emp);
            
						writeln('Edad modificada correctamente.');
					end;
				end;
    
				if not found then
					writeln('No se encontró el empleado con número ', numeroBuscado);
    
				close(E);
			end;
			7:begin
				archivoSalida:='todos_empleados.txt';
				assign(carga,archivoSalida);
				
				rewrite(carga); { Crea el archivo de texto }
				reset(E); { Abre el archivo binario }
                
                while not eof(E) do begin
					read(E, emp); { Leer registro del archivo binario }
					with emp do begin
						writeln(carga,nombre,'-',apellido,'-',nro,'-',edad,'',dni);
					end;
                end;
                writeln('Archivo exportado a texto correctamente.');
                close(E);
                close(carga);
			end;
			8:begin 
				archivoSalida:='faltaDNIempleado.txt';
				assign(carga,archivoSalida);
				rewrite(carga);
				reset(E);
				while not eof(E) do begin
					read(E,emp); 
					if (emp.dni=00) then begin
						with emp do begin
							writeln(carga,nombre,'-',apellido,'-',nro,'-',edad,'',dni);
						end;
					end
				end;
				writeln('Archivo exportado a texto correctamente.');
                close(E);
                close(carga);
			end;	
		end;
		
	until(opc=0);
	
end.
	
	

	
	
END.

