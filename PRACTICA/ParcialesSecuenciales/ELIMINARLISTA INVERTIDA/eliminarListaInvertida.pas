{
   Archivos
Se cuenta con un archivo que almacena información sobre los tipos de dinosaurios que habitaron durante 
la era mesozoica, de cada tipo se almacena: código, tipo de dinosaurio, altura y peso promedio, 
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice un programa 
que elimine tipos  de dinosaurios que estuvieron en el periodo jurásico de la era mesozoica. Para ello 
se recibe por teclado los códigos de los tipos a eliminar.
Las bajas se realizan apilando registros borrados y las altas reutilizando registros borrados. 
El registro 0 se usa como cabecera de la pila de registros borrados: el número 0 en el campo código 
implica que no hay registros borrados y -N indica que el próximo registro a reutilizar es el N, 
siendo éste un número relativo de registro válido. 

Dada la estructura planteada en el ejercicio, implemente los siguientes módulos:
Abre el archivo y elimina el tipo de dinosaurio recibido como parámetro manteniendo la política 
descripta anteriormente
a.  procedure eliminarDinos (var a: tArchDinos ; tipoDinosaurio: String);
b. Liste en un txt (archivo de texto) el contenido del archivo omitiendo los tipos 
de dinosaurios eliminados. Modifique lo que considere necesario para obtener el listado.
Nota: Las bajas deben finalizar al recibir el código 100000
}


program untitled;

const
	VA=0;
type
	cadena=string[30];

	dinosaurio=record
		codigo:integer;
		tipo:cadena;
		altura:real;
		peso:real;
		descripcion:cadena;
		zona:cadena;
	end;
	
	archivo=file of dinosaurio;

procedure eliminarDinos(var arch: archivo; tipo: cadena);
var
	D, cabecera: dinosaurio;
	pos: integer;
begin
	reset(arch);
	read(arch, cabecera);
	while not eof(arch) do begin
		pos := filepos(arch);
		read(arch, D);
		if (D.tipo = tipo) and (D.codigo > 0) then begin
			D.codigo := cabecera.codigo;
			cabecera.codigo := -pos;

			seek(arch, 0);
			write(arch, cabecera);

			seek(arch, pos);
			write(arch, D);

			writeln('El tipo de dinosaurio fue eliminado');
		end;
	end;
	close(arch);
end;

procedure 		

var
	arch: archivo;
	tipoBuscado: cadena;
begin
	assign(arch, 'dinosaurios.dat');
	readln(tipoBuscado);
	while tipoBuscado <> '100000' do begin
		eliminarDinos(arch, tipoBuscado);
		readln(tipoBuscado);
	end;
end.
