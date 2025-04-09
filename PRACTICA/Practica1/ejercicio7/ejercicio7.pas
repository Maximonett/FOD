{
   7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
   
   
}


program ejercicio7;

type
	
	cadena=string[30];
	
	novela=record
		codigo:integer;
		nombre:cadena;
		genero:cadena;
		precio:real;
	end;
	
	archivo_binario=file of novela;


procedure crearArchivoBinario (var arch_bin:archivo_binario;var arch_text:text);
var 
	n:novela;
begin
	assign(arch_text,'novelas.txt');
	reset(arch_text);
	rewrite(arch_bin);
	while not eof(arch_text) do begin
		readln(arch_text,n.codigo,n.precio,n.genero);
		readln(arch_text,n.nombre);
		write(arch_bin,n);
	end;
	close(arch_bin);
	close(arch_text);
	writeln('Archivo binario creado correctamente');
end;

procedure buscarYActulizarPorCodigo(var arch_bin:archivo_binario);
var
	n:novela;
	codigoBuscado:integer;
	encontro:boolean;
begin
	writeln('Ingrese un codigo para buscar y actualizar: ');
	readln(codigoBuscado);
	encontro:=false;
	reset(arch_bin);
	while not eof(arch_bin) do begin
		read(arch_bin,n);
		if (codigoBuscado = n.codigo) then begin
			encontro:=true;
			writeln('----------------------');
			writeln('Nº de codigo: ',n.codigo);
			writeln('Precio: $',n.precio);
			writeln('Genero: ',n.genero);
			writeln('Nombre: ',n.nombre);
			writeln('----------------------');
			
			seek(arch_bin,filepos(arch_bin)-1);
			
			writeln('Actualice el precio: '); readln(n.precio);
			write(arch_bin,n);
		end;
	end;
	if not encontro then
			writeln('La novela no se encontro.');
	close(arch_bin);
	
end;

procedure agregarNovela(var arch_bin:archivo_binario);
var 
	n:novela;
begin
	reset(arch_bin);
	seek(arch_bin,filesize(arch_bin));
	writeln('Ingrese el codigo de la novela');readln(n.codigo);
	writeln('Ingrese el genero: ');readln(n.genero);
	writeln('Ingrese el precio');readln(n.precio);
	writeln('Ingrese el nombre: ');readln(n.nombre);
	
	write(arch_bin,n);
	close(arch_bin);
	writeln('Novela agregada correctamente');
end;


procedure exportaATxt(var arch_bin:archivo_binario;var arch_text:text);
var
	n:novela;
begin
	assign(arch_text,'novelas.txt');
	rewrite(arch_text);
	reset(arch_bin);
	
	while not eof(arch_bin) do begin
		read(arch_bin,n);
		writeln(arch_text,n.codigo,' ',n.precio:0:2,' ',n.genero);
		writeln(arch_text,n.nombre)
	end;
	close(arch_bin);
	close(arch_text);
	writeln('archivo binario exportado con exito a novelas.txt');
end;

var
	arch_bin:archivo_binario;
	arch_text:text;
	opc:byte;
	nombre:cadena;

BEGIN
	repeat
		writeln('0.Salir');
		writeln('1.Crear un archivo binario de un .txt');
		writeln('2.Buscar por codigo de novela y actualizar');
		writeln('3.Agregar una novela');
		writeln('4.Actualizar el .txt');

		readln(opc);
	
	
	If (opc=1) or (opc=2) or (opc=3)  or (opc=4) then begin
		writeln('Ingrese el nombre del archivo binario  a  crear o actualizar o exportar a txt: '); 
		readln(nombre);
		assign(arch_bin,nombre+'.dat');
	end;
	
		case opc of 
		1:begin
			crearArchivoBinario(arch_bin,arch_text);
		end;
		2:begin
			buscarYActulizarPorCodigo(arch_bin);
		end;
		3:begin
			agregarNovela(arch_bin);
		end;
		4:begin
			exportaATxt(arch_bin,arch_text);
		end;
		end;
	until opc=0;
	
END.

