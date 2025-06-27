{
   1. Archivos Secuenciales
Dada la siguiente estructura:
Type
tProducto = record
código: integer;
nombre: string (50];
presentacion: string [100];
end;
tArchProductos = file of Producto ;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros borrados. 
El registro 0 se usa como cabecera de la pila de registros borrados: O en el registro 0 implica que no hay registros borrados y 
N en el registro 0 indica que el próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido. 
El encadenamiento de registros debe realizarse con el campo código de producto pero especificando los números de registro referenciados
con signo negativo.
Implemente los siguientes módulos:
(Abre el archivo y agrega el producto recibido como parámetro manteniendo la política
descripta anteriormente)
procedure agregar (var a: tArchProductos; producto: tProducto);
(Abre el archivo y elimina el producto recibido como parámetro manteniendo la
política descripta anteriormente)
procedure eliminar (var a: tArchProductos; producto: tFroducto) ;
   
   
}


program parcial2;

type
	tProducto=record
		codigo:integer;
		nombre:string[50];
		presentacion:string[50];
	end;
	
	tArchProductos=file of tProducto;

procedure agregar(var a:tArchProductos; producto:tProducto);
var 
	cabecera:tProducto;
begin
	reset(a);
	read(a,cabecera);
	if (cabecera.codigo=0)then 
		begin
			seek(a,filesize(a));
			write(a,producto);
		end
	else //al no ser cero "0" el codigo esto me indica que hay lugar para reutilizar
		begin
			seek(a,cabecera.codigo*-1); //entonces me posisiono en la posicion que es negativa multiplicandola por -1
			read(a,cabecera);
			seek(a,filepos(a)-1); //me posiciono un lugar menos para poder sobreescribir 
			write(a,producto);    // escribo en a con el nuevo producto
			seek(a,0);   //vuelvo al registro a la cabecera
			write(a,cabecera); //se actualiza 
		end;
	close(a);
end;

function ExisteProducto(var a :tArchProductos; codigo:integer):boolean;
var 
	ok:boolean;
	p:tProducto;
begin
	ok:=false;
	reset(a);
	while(not eof(a)) do 
		begin
			read(a,p);
			if(p.codigo=codigo) then
				ok:=true;				
		end;
	close(a);
	ExisteProducto:=ok;
end;

procedure eliminar(var a:tArchProductos; producto:tProducto);
var
	cabecera, p:tProducto;
begin
	if (ExisteProducto(a,producto.codigo)) then
		begin
			reset(a); //abro el archivo
			read(a,cabecera); //leo primero para leer la poscion 0 donde me dice que espacio libre hay para reutilizar
			read(a,p); //leo la posicion 1 donde se encuentra el primer producnto
			while(p.codigo<>producto.codigo) do // buscamos el prodcunto a eliminar
				read(a,p);
				
			seek(a,filepos(a)-1); // RETROCEDEMOS A LA POSICION  DEL PRODUCTO A ELIMINAR 
			write(a,cabecera);	// escribimos la posicion de la cabecera actual 
			p.codigo:=((filepos(a))*-1);	//guardamos la poscicion del prodcuto en negativo para luego escribirla en la cabecera
			seek(a,0);	//nos posicionamos en la posicion 0 del archivo (lugar de la cabecera )
			write(a,p); // escribimos el contenido del prodcuto eliminado al cual modificamos como negatico
			close(a);				
		end;
end;

procedure crearArchivo(var a:tArchProductos);
var
	p:tProducto;
begin 
	assign(a,'ArchivoMaestro');
	rewrite(a);
	p.codigo:=0;
	readln(p.codigo);
	while(p.codigo<>-1) do 
		begin
		readln(p.nombre);
		readln(p.presentacion);
		write(a,p);
		readln(p.codigo);
		end;
	close(a);
end;
procedure imprimirArchivo(var a:tArchProductos);
var
	p:tProducto;
begin
	reset(a);
	while (not eof(a)) do
		begin
			read(a,p);
			write(p.codigo,'~');
		end;
	close(a);
end;

var
	a:tArchProductos;
	p1,p2:tProducto;

BEGIN
	crearArchivo(a);
	p1.codigo:=33;
	p2.codigo:=44;
	agregar(a,p1);
	agregar(a,p2);
	imprimirArchivo(a);
	writeln();
	eliminar(a,p1);
	imprimirArchivo(a);
	
END.

