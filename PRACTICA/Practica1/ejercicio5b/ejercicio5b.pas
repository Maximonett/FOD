{
   5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.
   
   
}


program ejercicio5b;
type 

	cadena=string[30];
		
	celular=record
		codigo:integer;
		nombre:cadena;
		descripcion:cadena;
		marca:cadena;
		precio:real;
		stockMin:integer;
		stockDisp:integer;
		end;
	
	archivo_registros=file of celular;
	

	
procedure crearArchivoTexto(var archTexto:text);
var
	cel:celular;
begin
	assign(archTexto,'celulares.txt');
	rewrite(archTexto);
	
	with cel do begin
		writeln('Ingrese el codigo de celular: ');readln(codigo);
		while codigo<>0 do begin
			writeln('Ingrese el nombre: ');readln(nombre);
			writeln('Ingrese la descripcion: ');readln(descripcion);
			writeln('Ingrese la marca: ');readln(marca);
			writeln('Ingrese el precio'); readln(precio);
			writeln('Ingrese el stock minimo');readln(stockMin);
			writeln('Ingrese el stock disponible');readln(stockDisp);
			
			// Guardar datos respetando el formato indicado en la consigna
			writeln(archTexto, codigo, ' ', precio:0:2, ' ', marca);
			writeln(archTexto, stockDisp, ' ', stockMin, ' ', descripcion);
			writeln(archTexto, nombre);
			
			
			writeln('Ingrese el codigo de celular: ');readln(codigo);
			
		end;
	end;
	writeln('Archivo de Texto creado correctamente.');
	close(archTexto);
end;


procedure crearArchivoRegistroDesdeTxt(var A:archivo_registros;var archTexto:text);
var 
	cel:celular;
begin
	assign(archTexto,'celulares.txt');
	reset(archTexto);
	rewrite(A);
	while not eof(archTexto) do begin
		readln(archTexto,cel.codigo,cel.precio,cel.marca);
		readln(archTexto,cel.stockMin,cel.stockDisp,cel.descripcion);
		readln(archTexto,cel.nombre);
		write(A,cel);
	end;
	close(A);
	close(archTexto);
	writeln('Archivo de Registro creado correctamente');
end;

procedure celularesConMenorStock(var A:archivo_registros);
var
	cel:celular;
	encontro:boolean;
begin
	encontro:=false;
	reset(A);
	seek(A,0);
	while not eof(A) do begin
		read(A,cel);
		if (cel.stockDisp<cel.stockMin) then begin
			writeln('---------------------------');
			writeln('Codigo de Celular: ',cel.codigo);
			writeln('Precio',cel.precio);
			writeln('Marca: ',cel.marca);
			writeln('Stock Minimo: ',cel.stockMin);
			writeln('Stock disponible: ',cel.stockDisp);
			writeln('Descripcion: ', cel.descripcion);
			writeln('Nombre: ',cel.nombre);
			writeln('---------------------------');
			encontro:=true
		end;
	end;
	if not encontro then
		writeln('No se encontraron celulares con bajo stock');
		
	close(A);
end;

procedure buscarPorDescripcion(var A:archivo_registros; var descripcionBuscada:cadena);
var 
	cel:celular;
	encontro:boolean;
begin
	encontro:=false;
	reset(A);
	seek(A,0);
	
	while not eof(A) do begin
		read(A,cel);
		if Pos(LowerCase(descripcionBuscada),LowerCase(cel.descripcion)) >0 then begin
			writeln('---------------------------');
			writeln('Codigo de Celular: ',cel.codigo);
			writeln('Precio',cel.precio);
			writeln('Marca: ',cel.marca);
			writeln('Stock Minimo: ',cel.stockMin);
			writeln('Stock disponible: ',cel.stockDisp);
			writeln('Descripcion: ', cel.descripcion);
			writeln('Nombre: ',cel.nombre);
			writeln('---------------------------');
			encontro:=true
		end;
	end;
	if not encontro then 
		writeln('No se encontro un celular con esa descripcion');
		
	close(A);
end;


var
	A:archivo_registros; 
	opc:byte;
	archTexto:text;
	nomArchivo:cadena;
	descripcionBuscada:cadena;

BEGIN

	repeat
		
		
		writeln('Elija una opcion...');
		writeln('-------------------');
		writeln('0.Salir');
		writeln('1.Crear Archivo de Texto de celulares (celulares.txt)');
		writeln('2.Crear un Archivo de Registros a partir de (celualres.txt)');
		writeln('3.Listar celulares con menor stock que el minimo');
		writeln('4.Buscar por descripcion');
		
		readln(opc);
		
		if (opc=2) or (opc=3) or (opc=4) or (opc=5) then begin
			writeln('Ingrese el nombre del archivo de registro a crear o utilizar: ');
			readln(nomArchivo);
			assign(A,nomArchivo + '.dat');
		end;
	
		case opc of 
		1:begin
			crearArchivoTexto(archTexto);
		end;
		2:begin
			crearArchivoRegistroDesdeTxt(A,archTexto);
		end;
		3:begin
			celularesConMenorStock(A);
		end;
		4:begin
			writeln('Ingrese una descripcion para hacer la busqueda');
			readln(descripcionBuscada);
			buscarPorDescripcion(A,descripcionBuscada);
		end;
		5:begin
		
		end;
		
		end;
	until (opc=0);
	
END.

