{
  1. Archivos Secuenciales
Una cadena de restaurantes posee un archivo de productos que tiene a la venta, de cada
producto se registra: código de producto, nombre, descripción, código de barras, categoría
de producto, stock actual y stock mínimo. Diariamente el depósito debe efectuar envíos a
cada uno de los tres restaurantes que se encuentran en la ciudad de Laprida. Para esto,
cada restaurante envía un archivo por mail con los pedidos de productos. Cada pedido
contiene: código de producto, cantidad pedida y una breve descripción del producto. Se pide
realizar el proceso de actualización del archivo maestro con los tres archivos de detalle,
obteniendo un informe de aquellos productos que quedaron por debajo del stock mínimo y
sobre estos productos informar la categoría a la que pertenecen. Además , informar
aquellos pedidos que no pudieron satisfacerse totalmente por falta de stock, indicando la
diferencia que no pudo ser enviada a cada restaurante. Si el stock no es suficiente para
satisfacer un pedido en su totalidad, entonces el mismo debe satisfacerse con la cantidad
que se disponga.
   
}


program untitled;

const
	VA:9999;

type
	cadena=string[30];
	
	producto=record
		codigo:integer;
		nombre:cadena;
		descripcion:cadena;
		codBarra:integer;
		categoria:cadena;
		stockActual:integer;
		stockMin:integer;
	end;
	
	pedido=record
		codigo:integer;
		cantidad:integer;
		descripcion:cadena;
	end;
	
	maestro=file of producto;
	detalle=file of pedido;
	
procedure leer(var det:detalle,var infoDet:pedido);
begin
	if (not eof(det)) then 
		read(det,infoDet)
	else
		infoDet.codigo:=VA;
end;

procedure minimo(var det1,det2,det3:detalle;var infoDet1,infoDet2,infoDet3,min:pedido);
begin
	if(infoDet1.codigo<infoDet2.codigo)  then begin
		min:=infoDet1;
		leer(det1,infoDet1);
	end
	else if (infoDet2.codigo<infoDet3.codigo)then begin
		min:infoDet2;
		leer(det2,infoDet2);
	end
	else begin
		min:=infoDet3.codigo;
		leer(det3,infoDet3);
	end;
end;
	

	
BEGIN
	
	
END.

