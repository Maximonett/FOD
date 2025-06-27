{
  Enunciado
Una plataforma digital organiza cada año una serie de eventos de sesiones musicales en vivo.
Cada evento cuenta con múltiples presentaciones realizadas en distintas fechas, y un mismo
artista puede participar varias veces en el mismo evento un mismo año.
Se dispone de un archivo que contiene la información de cada presentación individual. Cada
registro indica: el código del artista, el nombre del artista, el año en el que se realizó la
presentación, el código del evento, el nombre del evento, la cantidad de "likes" recibidos durante
esa presentación, la cantidad de "dislikes" recibidos, y el puntaje otorgado por el jurado técnico a
dicha presentación. El archivo está ordenado por año, luego por código de evento, y finalmente
por código de artista.
Se solicita definir las estructuras de datos necesarias y escribir el módulo que reciba el archivo y
genere un informe por pantalla con el siguiente formato de ejemplo:
Resumen de menor influencia por evento.
Año: 2022
Evento: nombreEvento1 (Código: códigoEvento1)
Artista: nombreArtista1 (Código: códigoArtista1)
Likes totales: total likes artista 1
Dislikes totales: total dislikes artista 1
Diferencia: diferencia (likes totales - dislikes totales) de artista 1
Puntaje total del jurado: puntaje total obtenido por el artista 1
…
Artista: nombreArtistaN (Código: códigoArtistaN)
idem anterior pero para artista N
El artista “nomArtistaMenosInfluyente” fue el menos influyente de nombreEvento1 del año 2022.
…
Evento: nombreEventoN (Código: códigoEventoN)
idem anterior para cada artista en el evento N
Durante el año 2022 se registraron “nroPresentaciones” de presentaciones de artistas.
…
Año: N
idem anterior para cada evento del año N
Durante el año N se registraron “nroPresentaciones” de presentaciones de artistas.
El promedio total de presentaciones por año es de: “promedioPresentacionesPorAño” presentaciones.
   
   
}


program parcial;

const
	VA=9999;
	MAX=-1;
	
type
	cadena=string[30];
	
	TRegistro=record
		codArtista:integer;
		nombreArtista:cadena;
		ano:integer;
		codEvento:integer;
		nombreEvento:cadena;
		cantLikes:longint;
		cantDisLikes:longint;
		puntaje:real;
	end;
	
	TArchivo=file of TRegistro;
	
procedure leer(var a:TArchivo; var reg:TRegistro);
begin
	if ( not eof(a)) then
		read(a,reg)
	else
		reg.ano:=VA;
end;

procedure informe(var a:TArchivo);
var
	reg,act:TRegistro;
	anos,presentacionesAno, presentacionesTotal:integer;
	puntajeMin:real;
	nombreArtista:cadena;
	dislikesMax:longint;
begin
	anos:=0; 
	reset(a);
	leer(a,reg);
	presentacionesTotal:=0;
	
	writeln('Resumen de menor influencia por evento');
	
	while(reg.ano<>VA) do begin
		act.ano:=reg.ano;
		writeln(' Año: ', act.ano);
		anos:=anos+1;
		presentacionesAno:=0;
		while (act.ano=reg.ano) do begin
			act.codEvento:=reg.codEvento;
			act.nombreEvento:=reg.nombreEvento;
			puntajeMin:=VA;
			dislikesMax:=MAX;
			writeln('Evento: ', act.nombreEvento,' ( Codigo: ',act.codEvento,' )');
			while (act.ano=reg.ano) and (act.codEvento=reg.codEvento)do begin
				act.codArtista:=reg.codArtista;
				act.nombreArtista:=reg.nombreArtista;
				act.cantLikes:=0;
				act.cantDisLikes:=0;
				act.puntaje:=0;
				writeln('Artist: ',act.nombreArtista, '(Codigo: ',act.codArtista,' ) ');
				while( (act.ano =reg.ano) and (act.codEvento= reg.codEvento) and (act.codArtista=reg.codArtista)) do begin
					act.cantLikes:=act.cantLikes+reg.cantLikes;
					act.cantDisLikes:=act.cantDisLikes+reg.cantDisLikes;
					act.puntaje:=act.puntaje+ reg.puntaje;
					presentacionesAno:=presentacionesAno+1;
					leer(a,reg);
				end;
				if (act.puntaje<puntajeMin) or (act.puntaje=puntajeMin) and (act.cantDisLikes>dislikesMax) then begin
						puntajeMin:=act.puntaje;
						dislikesMax:=act.cantDisLikes;
						nombreArtista:=act.nombreArtista;
				end;
				writeln('Likes totales: ',act.cantLikes); 
				writeln('Dislikes Totales',act.cantDisLikes); 
				writeln('Diferencia: ',(act.cantLikes-act.cantDisLikes)); 
				writeln('Puntaje total del jurado: ',act.puntaje);			
			end;
			writeln('El Artista ', nombreArtista, ' fue el menos influyente de ', act.nombreEvento,' del año ',act.ano,' . ');
		end;
		writeln('Durante el año ', act.ano,' se registraron ',presentacionesAno, ' presentaciones de artistas');
		presentacionesTotal:=presentacionesTotal+presentacionesAno;
	end;
	writeln;
	if anos>0 then
		writeln('El promedio total de presentaciones por año es de: ', (presentacionesTotal /anos):0:2, ' presentaciones.')
	else
		writeln('No se registraron presentaciones.');
	close(a);
end;

	
BEGIN
	
	
END.

