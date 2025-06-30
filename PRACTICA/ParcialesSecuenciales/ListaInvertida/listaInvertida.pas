{
   1. Archivos Secuenciales
Suponga que tiene un archivo con información referente a los empleados que trabajan 
en una mutinacional. De cada empleado se conoce 
el dni (único), nombre, apellido, edad, domicilio y fecha de nacimiento.
Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de
espacio llamada lista invertida.
Declare las estructuras de datos necesarias e implemente los siguientes módulos:
Agregar empleado: solicita al usuario que ingrese los datos del empleado y 
lo agrega al archivo sólo si el dni ingresado no existe. Suponga que existe una 
función llamada existeEmpleado que recibe un dni y un archivo y devuelve verdadero 
si el dni existe en el archivo o falso en caso contrario. La función existeEmpleado 
no debe implementarla. Si el empleado ya existe, debe informarlo en pantalla.
Quitar empleado: solicita al usuario que ingrese un dni y lo elimina del archivo solo 
si este dni existe. Debe utilizar la función existeEmpleado. En caso de que el empleado no exista
debe informarse en pantalla.
Nota: Los módulos que debe implementar deberán guardar en memoria secundaria todo
cambio que se produzca en el archivo.
   
   
}


program untitled;

const
	VA=-1;

type
	cadena=string[30];
	
	empleado=record
		dni:integer;
		nombre:cadena;
		apellido:cadena;
		edad:integer;
		domicilio:cadena;
		fechaN:cadena;
		next:integer;
	end;
	
	archivo=file of empleado;
	
function existeEmpleado(var arch:archivo; var dni:integer):boolean;

procedure agregarEmpleado(var arch:archivo);
var
	e,cabecera,regLibre:empleado;
	posLibre:integer;
begin
	writeln('Ingrese el DNI del empleado:'); readln(e.dni);
	if (existeEmpleado(arch,e.dni)) then begin
		writeln('El empleado ya exite.');
		exit;
	end;
	writeln('Nombre: ');readln(e.nombre);
	writeln('Apellido: ');readln(e.apellido);
	writeln('Edad: ');readln(e.edad);
	writeln('Domicilio: ');readln(e.domicilio);
	writeln('Fecha de nacimiento: ');readln(e.fechaN);
	
	reset(arch);
	read(arch,cabecera);
	
	if (cabecera.next=VA) then begin
		seek(arch,filesize(arch));
		write(arch,e);
	end
	else begin
		posLibre:=cabecera.next;
		
		seek(arch,posLibre);
		read(arch,regLibre);
		seek(arch,0);
		cabecera.next:=regLibre.next;
		write(arch,cabecera);
		
		seek(arch,posLibre);
		write(arch,e);
	end;
	close(arch);
end;

procedure quitarEmpleado(var arch:archivo);
var
	dni,pos:integer;
	cabecera,e:empleado;
begin
	writeln('Ingrese el DNI del empleado a quitar: '); readln(dni);
	
	if (not existeEmpleado(arch,e.dni)) then begin
		writeln('No exite el empleado.');
		exit;
	end;
	
	reset(arch);
	read(arch,cabecera);
	
	pos:=1;
	
	while not eof(arch) do begin
		read(arch,e);   //leo el empleado
		if (e.dni=dni) then begin
			e.next:=cabecera.next;
			cabecera.next:=pos;
			
			seek(arch,0);
			write(arch,cabecera);
			
			seek(arch,pos);
			write(arch,e);
			
			writeln('El empleado fue quitado');
			break;
		end;
		pos:=pos+1;
	end;
	close(arch);
end;	

BEGIN
	
	
END.

