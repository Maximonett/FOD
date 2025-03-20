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


program ejeCinco;

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
	
	
	
var 

	archivoCeluTexto:text;
	cel:celular;
	


BEGIN


	assign(archivoCeluTexto,'celulares.txt');
	rewrite(archivoCeluTexto);
	
	with cel do begin
		writeln('Ingrese el codigo de Celular: '); readln(cod);
		while cod<>0 do begin
			writeln('Ingrese nombre: '); readln(nombre);
			writeln('Ingrese Descripcion: '); readln(descripcion);
			writeln('Ingrese Marca: '); readln(marca);
			writeln('Ingrese precio: '); readln(precio);
			writeln('Ingrese stock minimo: '); readln(stockMin);
			writeln('Ingrese stock disponible: '); readln(stockDisp);
			
			
			writeln(archivoCeluTexto,cel.cod,' ',cel.descripcion,' ',cel.marca);
			writeln(archivoCeluTexto,cel.precio:0:2,' ',cel.stockMin,' ',cel.stockDisp);
			
			
			writeln('Ingrese el codigo de Celular: '); readln(cod);
		end;
	end;
	
	close(archivoCeluTexto);
END.

