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


program ejeCincoMain;


type
	
{código de celular, nombre,descripción, marca, precio, stock mínimo y stock disponible}
	celular=record
		cod:integer;
		nombre:string[20];
		descripcion:string[50];
		marca:string[20];
		precio:real;
		stockMin:integer;
		stockDisp:integer;
	end;
	
	archivo_registros=file of celular; 
	
procedure listaCelularesConStock(var archCel:archivo_registros);
var
	cel:celular;
	hay:boolean;
begin
	hay:=false;
	seek(archCel,0);   {pongo el puntero en cero}
	while not (eof(archCel)) do begin
		read(archCel,cel);  
		
		if (cel.stockMin> cel.stockDisp) then begin
			writeln('Celulares con stock menor al minimo: Codigo: ',cel.cod:7,'.Precio:',cel.precio:7:2,'.Stock Minimo: ',cel.stockMin:7,'.Stock Disponible: ',cel.stockDisp:7,'Nombre: ',cel.nombre,'.Descripcion: ',cel.descripcion,'.Marca: ',cel.marca,'.');
			hay:=true;
		end;		
	end;
	if (not hay) then 
			writeln('No se encontraron celulares con stock menor al minimo.');
end;		


procedure crearArchivoTexto(var archTexto:text);
var 
	cel:celular;
begin
	assign(archTexto,'celulares.txt');
	rewrite(archTexto);
	
	with cel do begin
		writeln('Ingrese el codigo de Celular: '); readln(cod);
		while cod<>0 do begin
			writeln('Ingrese nombre: '); readln(nombre);
			writeln('Ingrese Descripcion: '); readln(descripcion);
			writeln('Ingrese Marca: '); readln(marca);
			writeln('Ingrese precio: '); readln(precio);
			writeln('Ingrese stock minimo: '); readln(stockMin);
			writeln('Ingrese stock disponible: '); readln(stockDisp);
			
			
			with cel do begin
				writeln(archTexto, cod, ' ', precio:0:2, ' ', marca);
				writeln(archTexto, stockDisp, ' ', stockMin, ' ', descripcion);
				writeln(archTexto, nombre);
			end;
			
			
			writeln('Ingrese el codigo de Celular: '); readln(cod);
		end;
	end;
	
	close(archTexto);
end;


procedure buscarPorDescripcion(var archCel:archivo_registros);
var
	descripcionBuscada:string[50];
	cel:celular;
	encontro:boolean;
begin
	encontro:=false;
	seek(archCel,0);
	writeln('Ingrese la descripcion buscada: '); readln(descripcionBuscada);
	
	while not eof(archCel) do begin
		read(archCel,cel);
		
		if Pos(LowerCase(descripcionBuscada),LowerCase(cel.descripcion)) >0 then begin  {si la posicion es mayor a 0 quiere decir que se encontro la descripcion}
			writeln('Celular Encontrado: Codigo: ',cel.cod:7,'.Precio:',cel.precio:7:2,'.Stock Minimo: ',cel.stockMin:7,'.Stock Disponible: ',cel.stockDisp:7,'Nombre: ',cel.nombre,'.Descripcion: ',cel.descripcion,'.Marca: ',cel.marca,'.');
			encontro:=true;
		end;
	end;
	if not encontro then 
		writeln('No se encontro un celular con esa descripcion.')	
end;


procedure seleccionarOpcion(var archCel:archivo_registros; var archTexto:text);
var 
	opc:byte;
begin
	repeat 
		writeln('----------------------------');
		writeln('Ingrese una opcion: ');
		writeln('0.Salir');
		writeln('1.Listar todos los celulares con estock menor al minimo');
		writeln('2.Buscar un celular por su descripcion');
		writeln('3.Cear Archivo de Texto');
		readln(opc);
		
		case opc of
		
		0:writeln('EL PROGRAMA SE HA FINALIZADO...');
		1:listaCelularesConStock(archCel);
		2:buscarPorDescripcion(archCel);
		3:crearArchivoTexto(archTexto);
		
		else
			writeln('Opcion invalida');
		end;
	
	until opc=0;
end;	

procedure cargarRegistros(var archTexto:text; var archCel:archivo_registros);
var 
	cel:celular;
begin
	while not eof(archTexto) do begin 
		with cel do begin
			readln(archTexto,cod,precio,marca);
			readln(archTexto,stockMin,stockDisp,descripcion);
			readln(archTexto,nombre);
			write(archCel,cel);
		
		end;
	end;
end;

procedure exportar(var archTexto:text; var archCel:archivo_registros);
var
	cel:celular;
begin
	seek(archCel,0);
	while not eof(archCel) do begin
		read(archCel,cel);
		with cel do begin
			writeln(archTexto,cod:7,precio:7:2,marca:7);
			writeln(archTexto,stockMin:7,stockDisp:7,descripcion:7);
			writeln(archTexto,nombre:7);
		end;
	end;
end;


var
	archTexto:text;
	archCel:archivo_registros;
	nombre:string;
begin 
	writeln('Ingrese el nombre del archivo de registro: '); readln(nombre);

	
	
	assign(archCel,nombre + '.dat');
	rewrite(archCel);
	
	seleccionarOpcion(archCel,archTexto);
	
	assign(archTexto,'celulares.txt');
	reset(archTexto);
	
	cargarRegistros(archTexto,archCel);
	
	exportar(archTexto,archCel);
	close(archTexto);
	close(archCel);
	
	
end.
