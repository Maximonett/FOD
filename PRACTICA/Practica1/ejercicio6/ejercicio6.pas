{
   6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.
   
   
}


program ejercicio6;

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

procedure agregarCelulares(var A:archivo_registros; var archTexto:text);
var
	cel:celular;
begin
	reset(A);
	seek(A,fileSize(A));
	with cel do begin
		writeln('Ingrese el codigo del celular a agregar: ');readln(codigo);
		while codigo<>0 do begin
			writeln('Ingrese el nombre: ');readln(nombre);
			writeln('Ingrese la descripcion: ');readln(descripcion);
			writeln('Ingrese la marca: ');readln(marca);
			writeln('Ingrese el precio'); readln(precio);
			writeln('Ingrese el stock minimo');readln(stockMin);
			writeln('Ingrese el stock disponible');readln(stockDisp);
			
			write(A,cel);
			writeln('Ingrese el codigo del celular a agregar: ');readln(codigo);
		end;
	end;
	close(A);
	
	// **Actualizar el archivo de texto "celulares.txt" con todos los celulares**
	assign(archTexto,'celulares.txt');
	rewrite(archTexto); //reescribimos el archivo de texto
	
	reset(A); //volvemos a abrir el archivo binario
	
	while not eof(A) do begin
        read(A, cel);
        writeln(archTexto, cel.codigo, ' ', cel.precio:0:2, ' ', cel.marca);
        writeln(archTexto, cel.stockMin, ' ', cel.stockDisp, ' ', cel.descripcion);
        writeln(archTexto, cel.nombre);
    end;
    close(A);
    close(archTexto);  // Cerramos el archivo de texto

    writeln('Celulares añadidos y archivo "celulares.txt" actualizado correctamente.');
	
end;


procedure actualizarStockPorNombre(var A:archivo_registros; var archTexto:text; var nombreBuscado:cadena);
var 
	cel:celular;
	encontro:boolean;
	nuevoStock:integer;
	pos:integer;
begin
	encontro:=false;
	reset(A);
	
	while not eof(A) do begin
		
		pos:=filePos(A); //guardo la posicion actual en el archivo
		read(A,cel);
		
		if (LowerCase(nombreBuscado)=LowerCase(cel.nombre)) then begin
			encontro:=true;
			writeln('Celular encontrado: ',cel.nombre);
			writeln('Stock actual: ',cel.stockDisp);
			writeln('Ingrse el nuevo stock: '); readln(nuevoStock);
			
			//se actualiza el stock
			cel.stockDisp:=nuevoStock;
			
			//Volvemos a la posicion antes del read A
			seek(A,pos);
			write(A,cel);
		
			writeln('Stock actualizado correctamente.');
            break;  // Salimos del bucle porque ya encontramos el celular
		end;
	
	end;
	if not encontro then 
		writeln('El archivo binario se actualizo correctamente');
	
	close(A);
	
	// **Actualizar el archivo de texto "celulares.txt" con todos los celulares**
	assign(archTexto,'celulares.txt');
	rewrite(archTexto); //reescribimos el archivo de texto
	
	reset(A); //volvemos a abrir el archivo binario
	
	while not eof(A) do begin
        read(A, cel);
        writeln(archTexto, cel.codigo, ' ', cel.precio:0:2, ' ', cel.marca);
        writeln(archTexto, cel.stockMin, ' ', cel.stockDisp, ' ', cel.descripcion);
        writeln(archTexto, cel.nombre);
    end;
    close(A);
    close(archTexto);  // Cerramos el archivo de texto

    writeln('Stock actualizado en el archivo de texto');
	
end;

procedure sinStock(var A:archivo_registros; var archTexto:text);
var
	cel:celular;
	encontro:boolean;
begin
	encontro:=false;
	reset(A);
	assign(archTexto,'sinStock.txt');
	rewrite(archTexto);
	while not eof(A) do begin
		read(A,cel);
		if (cel.stockDisp=0) then begin
			encontro:=true;
			writeln('---------------------------');
			writeln('Codigo de Celular: ',cel.codigo);
			writeln('Precio',cel.precio);
			writeln('Marca: ',cel.marca);
			writeln('Stock Minimo: ',cel.stockMin);
			writeln('Stock disponible: ',cel.stockDisp);
			writeln('Descripcion: ', cel.descripcion);
			writeln('Nombre: ',cel.nombre);
			writeln('---------------------------');
			
		
			writeln(archTexto, cel.codigo, ' ', cel.precio:0:2, ' ', cel.marca);
			writeln(archTexto, cel.stockMin, ' ', cel.stockDisp, ' ', cel.descripcion);
			writeln(archTexto, cel.nombre);
		end;
		writeln('se ha producido correctamente el archivo "sinStock.txt" ');
	end;
	
	close(A);
	close(archTexto);
	if not encontro then
		writeln('No se encontraron Celulares sin stock');
	
end;



var
	A:archivo_registros; 
	opc:byte;
	archTexto:text;
	nomArchivo:cadena;
	descripcionBuscada:cadena;
	nombreBuscado:cadena;

BEGIN

	repeat
		
		
		writeln('Elija una opcion...');
		writeln('-------------------');
		writeln('0.Salir');
		writeln('1.Crear Archivo de Texto de celulares (celulares.txt)');
		writeln('2.Crear un Archivo de Registros a partir de (celualres.txt)');
		writeln('3.Listar celulares con menor stock que el minimo');
		writeln('4.Buscar por descripcion');
		writeln('5.Añadir uno o mas celulares (para salir codigo de celular = 0');
		writeln('6.Modificar Stock (busqueda por nombre)');
		writeln('7.Crear sinStock.txt');
		
		readln(opc);
		
		if (opc=2) or (opc=3) or (opc=4) or (opc=5) or (opc=6) or (opc=7) then begin
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
			agregarCelulares(A,archTexto);
		end;
		6:begin
			writeln('Ingrese el nombre del celular a modificar:');
			readln(nombreBuscado);
			actualizarStockPorNombre(A,archTexto,nombreBuscado);
		end;
		7:begin
			sinStock(A,archTexto);
		end;	
		end;
	until (opc=0);
	
END.



BEGIN
	
	
END.

