{Los registros del archivo de productos contienen el código del producto, la
descripción, la cantidad en existencia, y el precio de venta actual}

Uses CRT;

Type
	tRegistroProducto=Record
		codProd: Word;
        descrip: String;
		existencia: Word;
        precio: Real
		End;

	tArchProductos=File of tRegistroProducto;

Var
   opc: Byte;
   nomArch, nomArch2: String;
   arch: tArchProductos; carga: Text;
   producto: tRegistroProducto;

begin
Repeat
WriteLn('PRODUCTOS');
WriteLn;
WriteLn('0. Terminar el Programa');
WriteLn('1. Crear un archivo');
WriteLn('2. Abrir un archivo existente');
WriteLn;
Write('Ingrese el nro. de opcion: '); ReadLn(opc);
If (opc=1) or (opc=2) then begin
   WriteLn;
   Write('Nombre del archivo de productos: ');
   ReadLn(nomArch);
   Assign(arch, nomArch)
   end;
Case opc of
     1: begin
        Write('Nombre del archivo de carga: ');
        ReadLn(nomArch2);
        Assign(carga, nomArch2); Reset(carga); Rewrite(arch);
        Repeat
        With producto do
             Read(carga, codProd, existencia, precio, descrip);
        Write(arch, producto)
        until eof(carga);
        Write('Archivo cargado. Oprima tecla de ingreso para continuar...');
        ReadLn;
        Close(arch); Close(carga)
        end;
     2: begin
        Reset(arch);
        WriteLn;
        Repeat
        Read(arch, producto);
        With producto do
             WriteLn(codProd: 5, existencia:5, precio:7:2, ' << '+descrip);
        until eof(arch);
        Close(arch);
        WriteLn;
        Write('Oprima cualquier tecla para continuar...');
        ReadLn
        end;
end;
ClrScr
until opc=0;
end.
