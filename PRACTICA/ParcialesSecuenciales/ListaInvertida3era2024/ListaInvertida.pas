{
   FOD -Examen de trabajos prácticos- Tercera fecha 30/07/2024
Escribir claramente en la primera hoja del examen: legajo, apellido y nombre, turo ( MM, MT) y 
temas que rinde (por su número). En cada hoja indicar: legajo/ apellido y nombre y número de hoja/total.

1. Archivos Secuenciales
Se cuenta con un archivo con información de los diferentes empleados que trabajan en una empresa.
De cada empleado se conoce: número, nombre, apellido, dni, fecha de nacimiento y género. 
El número de empleado no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización 
de espacio libre llamada lista invertida con registro cabecera (si el campo número en el registro
cabecera es cero no hay espacio para reutilizar).
Escriba la definición de las estructuras de datos necesarias y los siguientes procedimientos:

ExisteEmpleado: módulo que dado un número de empleado devuelve la posición (NRR) en el archivo 
donde se encuentra el empleado con el número especificado (en caso de que exista). 
En caso de que el empleado no exista devuelve el valor cero.

AltaEmpleado: módulo que lee por teclado los datos de un nuevo empleado y lo agrega al archivo, 
reutilizando espacio disponible en caso de que hubiera. En caso de que el empleado que se desea 
agregar ya exista en el archivo, se debe informar por pantalla que ya existe el empleado en cuestión
(el control de unicidad se debe realizar utilizando el módulo ExisteEmpleado).

BajaEmpleado: módulo que da de baja lógicamente un empleado cuyo número se lee por teclado.
Para marcar un empleado como borrado se debe utilizar el campo número para mantener actualizada 
la lista invertida. Para buscar el empleado a borrar y verificar que exista debe utilizar el módulo 
ExisteEmpleado. En caso de no existir se debe informar "Empleado no existente".
   
}


program untitled;

type
	cadena=string[30];

	empleado=record
		numero:integer;
		nombre:cadena;
		apellido:cadena;
		dni:longInt;
		fecha:longInt;
		genero:cadena;
	end;
	
	archivo=file of empleado;
	
function ExisteEmpleado(var a:archivo; var buscado:integer):integer;
var
	pos:integer;
	e:empleado;
begin
	reset(a);
	pos:=1;
	ExisteEmpleado:=0; // si no se encuentra
	
	while not eof(a) do begin
		read(a,e);
		if (e.numero=buscado) then begin
			ExisteEmpleado:=pos;
			close(a);
			exit;
		end;
		pos:=pos+1;
	end;
	close(a);
end;


procedure AltaEmpleado(var a:archivo);
var
	
	posLibre:integer;
	cabecera,e,regLibre:empleado;
begin
	writeln('Escriba el numero de empleado a dar de alta');readln(e.numero);
	if (ExisteEmpleado(a,e.numero)<>0) then begin
		writeln('El empleado ya existe.');
		break;
	end;
	
	writeln('Nombre: '); readln(e.nombre);
	writeln('Apellido: '); readln(e.apellido);
	writeln('DNI: '); readln(e.dni);
	writeln('Fecha(AAAAMMDD): '); readln(e.fecha);
	writeln('Genero: '); readln(e.genero);
	
	reset(a);
	read(a,cabecera);
	if(cabecera.numero=0)then begin //Como la cabecera tiene el nuemero "0" no hay lugar escribo al final del archivo
		seek(a,filesize(a));
		write(a,e);
		writeln('El empleado ha sido agregado al final');
		close(a);
		exit;
	end
	else begin
		posLibre:=-(cabecera.numero); // 1. Obtener la posición libre desde la cabecera
		
		seek(a,posLibre);
		read(a,regLibre);
		
		cabecera.numero:=regLibre.numero; // 3. Actualizar la cabecera con el "siguiente" espacio libre
		seek(a,0);
		write(a,cabecera);
		
		seek(a,posLibre);
		write(a,e);
		writeln('El empleado se agregado reutilizando espacio.');
		close(a);
	end;	
end;

procedure BajaEmpleado(var a:archivo);
var 
	pos,numero:integer;
	cabecera,e:empleado;
begin
	writeln('Escribir el numero de empleado a dar de baja: '); readln(numero);
	
	pos:=ExisteEmpleado(a,numero);
	if pos=0 then begin
		writeln('El empleado No existe.');
		exit;
	end;
	
	reset(a);
	read(a,cabecera);
	
	//ir a la posicion a borrar logicamente
	seek(a,pos);
	read(a,e);
	
	//enlazar el espacio libre a la lista invertida
	e.numero:=cabecera.numero;
	cabecera.numero:=-pos;
	
	//escribir la cabecera
	seek(a,0);
	write(a,cabecera);
	
	//escribir el registro dado de baja
	seek(a,pos);
	write(a,e);
	
	writeln('El empleado ha sido dado de baja');
	
	close(a);
end;
	
	
	

BEGIN
	
	
END.

