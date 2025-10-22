{
   1. Archivos Secuenciales
Una cadena de restaurantes posee un archivo de productos 
que tiene a la venta, de cada producto se registra: 
código de producto, nombre, descripción, código de barras, categoría de producto, 
stock actual y stock mínimo. Diariamente el depósito debe efectuar envios a cada 
uno de los tres restaurantes que se encuentran en la ciudad de Laprida. Para esto, 
cada restaurante envía un archivo por mail con los pedidos de productos. Cada pedido 
contiene: código de producto, cantidad pedida y una breve descripción del producto. 
Se pide realizar el proceso de actualización del archivo maestro con los tres archivos 
de detalle, obteniendo un informe de aquellos productos que quedaron por debajo del 
stock mínimo y sobre estos productos informar la categoría a la que pertenecen. 
Además, informar aquellos pedidos que no pudieron satisfacerse totalmente por falta de stock, 
indicando la diferencia que no pudo ser enviada a cada restaurante. 
Si el stock no es suficiente para satisfacer un pedido en su totalidad, 
entonces el mismo debe satisfacerse con la cantidad
que se disponga.
Nota: Todos los archivos están ordenados por código de producto.
   
}
program untitled;

const
	va=9999;
	DF=3;
type
	
	cadena=string[30];	
	
	producto=record 
		codigoP:integer;
		nombre:cadena;
		descPro:cadena;
		codigoDeBarras:integer;
		categoria:integer;
		stockAct:integer;
		stockMin:integer;
	end;
	
	pedido=record
		codigoP:integer;
		cantPedida:integer;
		descPe:cadena;
	end;
	
	maestro=file of producto;
	detalle=file of pedido;
	
	vecDetalle=array[1..3] of detalle;
	vecRegistro=array[1..3] of pedido;
		


procedure leer(var det:detalle;var reg:pedido);
begin
	if (not eof(det))then
		read(det,reg)
	else
		reg.codigoP:=va;
end;


procedure minimo(var vecDet:vecDetalle;var vecReg:vecRegistro;var min:pedido);
var
	i,pos:integer;
begin
	min.codigoP:=va;
	for i:=1 to DF do begin
		if (vecReg[i].codigoP<min.codigoP)then begin
			min:=vecReg[i];
			pos:=i;
		end;
	end;
	if (min.codigoP<>va)then
			leer(vecDet[pos],vecReg[pos]);
end;

{obteniendo un informe de aquellos productos que quedaron por debajo del 
stock mínimo y sobre estos productos informar la categoría a la que pertenecen. 
Además, informar aquellos pedidos que no pudieron satisfacerse totalmente por falta de stock, 
indicando la diferencia que no pudo ser enviada a cada restaurante. 
Si el stock no es suficiente para satisfacer un pedido en su totalidad, 
entonces el mismo debe satisfacerse con la cantidad
que se disponga.}

procedure actualizarMaestroYGenerarInforme(var mae:maestro;var vecDet:vecDetalle);
var
	vecReg:vecRegistro;
	p:producto;
	min:pedido;
	pedidos:integer;
	diferencia:integer;
	i:integer;
begin
	
	//Abro los archivos detalle
	for i:=1 to DF do begin
		reset(vecDet[i]);
		leer(vecDet[i],vecReg[i]);
	end;

	reset(mae); //abro el maestro
	
	minimo(vecDet,vecReg,min);
	
	while min.codigoP<>va do begin
		read(mae,p);
		while (p.codigoP<>min.codigoP) do begin
			read(mae,p);
			pedidos:=0;
		end;
		while (min.codigoP=p.codigoP) do begin
			if (min.cantPedida>p.stockAct) then begin
				pedidos:=pedidos +p.stockAct;
				diferencia:=min.cantPedida-p.stockAct;
				p.stockAct:=0;
				writeln('No se pudo satisfacer completamente el pedido del producto ',
                p.codigoP, ' (Categoria ', p.categoria, ').');
				writeln('   Faltaron ', diferencia, ' unidades.');
			end else if (min.cantPedida<p.stockAct) then begin
				pedidos:=pedidos+min.cantPedida;
				p.stockAct:=p.stockAct-min.cantPedida;
			end;
			minimo(vecDet,vecReg,min);	
		end;
		if (p.stockAct<p.stockMin) then 
			writeln('El producto ', p.codigoP, ' de la categoría ',
              p.categoria, ' quedó por debajo del stock mínimo. Stock actual: ',
              p.stockAct, ' (mínimo: ', p.stockMin, ').');
        
		//actualizo el maestro
		seek(mae,filepos(mae)-1);
		write(mae,p);
		
		//ciero todos los archivos
		close(mae);
		
		for i:=1 to DF do 
			close(vecDet[i]);
		
		writeln('Actualizacion finalizada');
	end;
end;
var
	
	mae:maestro;
	vecDet:vecDetalle;

BEGIN
	
	actualizarMaestroYGenerarInforme(mae,vecDet);

	
	
end.

