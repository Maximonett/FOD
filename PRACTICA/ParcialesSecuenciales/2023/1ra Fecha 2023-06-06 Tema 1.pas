{
   1. Archivos Secuenciales
Suponga que tiene un archivo con información referente a los productos que se comercializan 
en un supermercado. De cada producto se conoce código de producto (único), nombre del producto, 
descripción, precio de compra, precio de venta y ubicación en depósito.
Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de
espacio llamada lista invertida.
Declare las estructuras de datos necesarias e implemente los siguientes módulos:
Agregar producto: recibe el archivo sin abrir y solicita al usuario que ingrese los datos del 
producto y lo agrega al archivo sólo si el código ingresado no existe. Suponga que existe una 
función llamada existeProducto que recibe un código de producto y un archivo y devuelve verdadero 
si el código existe en el archivo o falso en caso contrario. La función
existe en el
existeProducto no debe implementarla. Si el producto ya existe debe informarlo en pantalla.
Quitar producto: recibe el archivo sin abrir y solicita al usuario que ingrese un código y lo 
elimina del archivo solo si este código existe. Puede utilizar la función existeProducto. 
En caso de que el producto no exista debe informarse en pantalla.
Nota: Los módulos que debe implementar deberán guardar en memoria secundaria todo
cambio que se produzca en el archivo.
   
   
}


program untitled;

const
	VA=-1;

type
	cadena=string[30];
	
	producto=record 
		codigo:integer;
		nombre:cadena;
		descripcion:cadena;
		precioCompra:real;
		precioVenta:real;
		ubicacion:cadena;
		next:integer; // solo se usa cuando el registro esta libre
	end;
	
	archivoProductos=file of producto;

function existeProducto(cod:integer;var arch:archivoProductos):boolean;

procedure agregarProducto(var arch:archivoProductos);
var
	p,cabecera,regLibre:producto;
	posLibre:integer;
begin
	//Pedir los datos al usuario
	writeln('Ingrese codigod de producto: ');
	readln(p.codigo);
	
	if (exiteProducto(p.codigo,arch)) then begin
		writeln('EL producto ya existe');
		exit;
	end;
	
	writeln ('Ingrese Nombre: ');readln(p.nombre);
	writeln ('Ingrese Descripcion: ');readln(p.descripcion);
	writeln ('Ingrese precio de compra: ');readln(p.precioCompra);
	writeln ('Ingrese precio de venta: ');readln(p.precioVenta);
	writeln ('Ingrese ubicacion: ');readln(p.ubicacion);
	
	//ABRO EL ARCHIVO PARA LEER LA CABECERA(posicion 0) Y VER DONDE HAY LUGAR PARA ESCRIBIR
	
	reset(arch);
	read(arch,cabecera);
	
	if (cabecera.next=VA) then begin
		//No hay espacio libre , debo escribir en el final
		seek(arch,filesize(arch));
		write(arch,p);
	end
	else begin
		//HAY UN LUGAR LIBRE BUSCO LA POSCION 
		posLibre:=cabecera.next;
		seek(arch,posLibre);
		//DEbo leer el registro libre para ver donde es la proxima posicion  libre
		read(arch,regLibre); //ahora la informacion de la posicion libre , la puse en un regLibre
		seek(arch,0); //me posiciono en la posicion 0
		cabecera.next:=regLibre.next; // Actualizo la posicion de la cabecera con el nueva poscion libre
		write(arch,cabecera); // escribo en la posicion 0 con la informacion que hay en cabecera
		
		//Escribo el nuev registro
		seek(arch,posLibre);
		write(arch,p); 
	end;
	close(arch);
end;

procedure quitarProdcuto(var arch:archivoProductos);
var
	cod,pos:integer;
	p,cabecera:producto;
begin
	writeln('Ingrese el codigo de producto a eliminar: '); readln(cod);
	
	if (not existeProducto(cod,arch)) then begin
		writeln('El producto no exite');
		exit;
	end; 
	
	reset(arch); // abro el archivo
	read(arch,cabecera);
	
	pos:=1; //primera poscion en el archivo con un producto real
	while (not eof(arch)) do begin
		read(arch,p);
		if (p.codigo=cod) then begin
			//Marcarlo como libre
			p.next:=cabecera.next; // le pongo el valor que hay en la cabecera (si es un lugar libre un numero, sino, -1)
			cabecera.next:=pos; 
			
			// Escribir la cabecera
			seek(arch,0);
			write(arch,cabecera);
			
			//Escribir el regitro elimniado
			seek(arch,pos);
			write(arch,p);
			
			writeln('Producto elimninado correctamente');
			break; 
		end;
		pos:=pos+1;
	end;
	
	close(arch);	
end;


BEGIN
	
	
END.

