{
   Se cuenta con un archivo con información de las diferentes mascotas que están registradas en 
   una veterinaria. De cada mascota se conoce: código, nombre, especie, edad, nombre del dueño 
   y teléfono de contacto. El código de mascota no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de 
reutilización de espacio libre mediante una lista invertida con registro cabecera. 
(Si el campo código en el registro cabecera es cero, significa que no hay espacio disponible para reutilizar).
Se pide escribir la definición de las estructuras de datos necesarias y los siguientes procedimientos:

ExisteMascota:
Módulo que, dado un código de mascota, devuelve la posición (NRR) en el archivo donde se
encuentra la mascota con el código especificado (en caso de que exista).
Si no existe una mascota con ese código, el módulo debe devolver el valor cero.

AltaMascota:
Módulo que lee por teclado los datos de una nueva mascota y la agrega al archivo, 
reutilizando espacio disponible en caso de que hubiera.
Si la mascota que se desea agregar ya existe en el archivo (mismo código), 
se debe informar por pantalla que ya existe la mascota registrada (el control de unicidad 
debe realizarse utilizando el módulo ExisteMascota).

BajaMascota:
Módulo que da de baja lógicamente una mascota, cuyo código se lee por teclado.
Para marcar una mascota como borrada se debe utilizar el campo código, manteniendo actualizada la lista invertida.
Para buscar la mascota a borrar y verificar que exista se debe utilizar el   
   
}


program untitled;

type
	mascota=record 
		codigo:integer;
		nombre:String;
		especie:String;
		edad:integer;
		nombreDelDuenio:String;
		telContacto:integer;
	end;
	
	archivo=file of mascota;
	
procedure ExisteMascota(var a:archivo;var codigo:integer;var pos:integer);
var 
	m:mascota;encontre:boolean;
begin
	encontre:=false;
	reset(a);
	pos:=0;
	while not EOF(a) and not encontre do begin 
		read(a,m);
		if (m.codigo=codigo) then begin
			pos:=filepos(a)-1; //para que devuelva la posicion que estoy leyendo
			encontre:=true;
			writeln('Mascota encontrada.');
		end;	
	end;
	close(a);
end;



procedure AltaMascota(var a:archivo);
var 
	posLibre:integer;
	cabecera,m,regLibre:mascota;
begin
	writeln('Escriba el codigo de la Mascota a dar de alta');readln(m.codigo);
	
	ExisteMascota(a,m.codigo, posLibre);
	
	if (posLibre<>0) then 
		Writeln('El codigo de mascota ya existe')
	else begin
			writeln('Nombre: '); readln(m.nombre); 
			writeln('Especie: '); readln(m.especie);
			writeln('Edad: '); readln(m.edad);
			writeln('Nombre del Dueño: '); readln(m.nombreDelDuenio);
			writeln('Telefono de contacto: '); readln(m.telContacto);
			
			reset(a);
			read(a,cabecera);
			if(cabecera.codigo=0) then begin //si la cabecera es cero entonces agrego al final
				seek(a,filesize(a));
				write(a,m);
				writeln('La mascota ha sido agregada al final del archivo');
			end
			else begin
				posLibre:=-1*(cabecera.codigo);
				
				seek(a,posLibre); //se busca el primer registro libre
				read(a,regLibre); //se lee
				
				seek(a,filepos(a)-1); // se vuelve a la posicion del espacio libre ya que al hacer el read se avanzo
				write(a,m); // se escribe la nueva mascota
				
				seek(a,0); //se va a la posicion cero CABECeRA
				write(a,regLibre); // se escribe la siguiente posicion libre  en la cabecera 
				
				writeln('La mascota fue agregada en el espacio libre');
			end;
			close(a);
	end;
	
end;


procedure BajaMascota(var a:archivo);
var
	pos:integer;
	cabecera,m:mascota;
begin
	writeln('Escriba el codigo de la Mascota a dar de Baja');readln(m.codigo);
	
	ExisteMascota(a,m.codigo, pos);
	
	if (pos=0) then 
		Writeln('El codigo de mascota No existe')
		
	else begin
		reset(a);
		read(a,cabecera); //se lee la cabecera
		
		seek(a,pos); //se busca el registro a borrar
		read(a,m); //se lee el registro de la mascota
		
		m.codigo:=cabecera.codigo;  // se modifica el campo codigo de este registro para que apunte al siguiente registro libre. Se le asigna el codigo de la cabecera
		seek(a,pos)// vuelvo a la posicion pos ya que el read me adelanto en 1, podia haber hecho un filepos(a)-
		write(a,m); //se sobre escribe
		
		cabecera.codigo:=-1*pos; // se modifica la cabecera para que apunte al registro recien borrado
		seek(a,0); // se posiciona en la pos cero
		write(a,cabecera);	//se sobreescribe la cabecera con la nueva pos negativa
		
		close(a);
		
		writeln('La mascota ha sido borrada');
	end;


BEGIN
	
	
END.

