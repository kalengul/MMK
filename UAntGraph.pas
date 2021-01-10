unit UAntGraph;

interface

Uses
      SysUtils; //FreeAndNill

type
  TAntNodeElement = class;
  TAntNodeKol = class;
  TAntArcKol = class;
  TArrDouble = array of Double;


  TAntNodeElement = class
                    Name:String;
                    Kol:TAntNodeKol;
                    NextElement,LastElement:TAntNodeElement;
                    CostProduction:Double;
                    KolElement:Longword;
                    function SearchValueElement (Value:Word):TAntNodeKol;
                    function AddValueElement (Value:Word):TAntNodeKol;
                    constructor Create;
                    destructor Destroy; override;
                    end;

  TAntNodeKol = class
                Element:TAntNodeElement;
                Value:Word;
                Pheromon:TArrDouble;
                Krit:TArrDouble;
                KolAntGo:LongWord;
                NPheromon:TArrDouble;
                Arc:tAntArcKol;
                NextKol:TAntNodeKol;
                procedure AddAntArc(NodeKolKon:TAntNodeKol);
                function SearchAntArc(NodeKolKon:TAntNodeKol):tAntArcKol;
                constructor Create;
                destructor Destroy; override;
                end;
  TArrayAntNodeKol = array of TAntNodeKol;

  TAntArcKol = class
               NextArc:TAntArcKol;
               Node:TAntNodeKol;
               Pheromon:TArrDouble;
               NPheromon:TArrDouble;
               constructor Create;
               destructor Destroy; override;
               end;

Function AddElementSklad(NameElement:String):TAntNodeElement;
function SearchElementSklad(NameElement:String):TAntNodeElement;
procedure AddNodeAnt(NameElement:string; Value:Word; Pheromon:TArrDouble);
procedure AddAllAntArc;
procedure DelAllAntArc;
procedure ClearAllAntGraph;
procedure DecreasePheromonAllGraph(ParArc:TArrDouble; ParNode:TArrDouble);
procedure SaveAntGraphFromTextFile(NameFile:String);
procedure LoadAntGraphFromTextFile(NameFile:string);
Procedure CreateZeroGraph;

var
  FirstNodeAntGraph:TAntNodeElement;
  ArrElementGraph:array of TAntNodeElement;
  KolKrit:LongWord;
  NatKolPheromon:TArrDouble;
  KolSbrosAntGrap:Longword;

implementation

procedure SaveAntGraphFromTextFile(NameFile:String);
var
  f:TextFile;
  st:string;
  NomKrit:LongWord;
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
begin
AssignFile(f,NameFile);
Rewrite(f);
  CurrentElement:=FirstNodeAntGraph;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      St:=CurrentElement.Name+'@'+IntToStr(CurrentValue.Value)+'@';
      for NomKrit:=0 to KolKrit-1 do
        st:=st+FloatToStr(CurrentValue.Pheromon[NomKrit])+'@';
      Writeln(F,st);
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
CloseFile(f);
end;

procedure LoadAntGraphFromTextFile(NameFile:string);
var
  f:TextFile;
  st:string;
  NameTransportNode,NameElement:string;
  NomValue:LongWord;
  KolPheromon:TArrDouble;
  NomKritPheromon:LongWord;
begin
AssignFile(f,NameFile);
Reset(f);
While not (Eof (f)) do
  begin
  Readln(st);
  NameElement:=Copy(St,1,pos('@',st)-1);
  Delete(St,1,pos('@',st));
  NomValue:=StrToInt(Copy(St,1,pos('@',st)-1));
  Delete(St,1,pos('@',st));
  SetLength(KolPheromon,KolKrit);
  For NomKritPheromon:=0 to KolKrit-1 do
    begin
    KolPheromon[NomKritPheromon]:=StrToFloat(Copy(St,1,pos('@',st)-1));
    Delete(St,1,pos('@',st));
    end;
  AddNodeAnt(NameElement,NomValue,KolPheromon);
  end;
CloseFile(f);
end;

procedure DecreasePheromonAllGraph(ParArc:TArrDouble; ParNode:TArrDouble);
var
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  CurrentArc:TAntArcKol;
  NomKrit:LongWord;
begin
  CurrentElement:=FirstNodeAntGraph;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      CurrentArc:=CurrentValue.Arc;
      While CurrentArc<>nil do
        begin
        For NomKrit:=0 to KolKrit-1 do
          begin
          CurrentArc.Pheromon[NomKrit]:=CurrentArc.Pheromon[NomKrit]*ParArc[NomKrit];
          If CurrentArc.Pheromon[NomKrit]<=0 then
            CurrentArc.Pheromon[NomKrit]:=CurrentArc.NPheromon[NomKrit];
          end;
        CurrentArc:=CurrentArc.NextArc;
        end;
      For NomKrit:=0 to KolKrit-1 do
        begin
        CurrentValue.Pheromon[NomKrit]:=CurrentValue.Pheromon[NomKrit]*ParNode[NomKrit];
        If CurrentValue.Pheromon[NomKrit]<=0 then
          CurrentValue.Pheromon[NomKrit]:=CurrentValue.NPheromon[NomKrit];
        end;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
end;

procedure ClearAllAntGraph;
var
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  CurrentArc:TAntArcKol;
  NomKrit:LongWord;
begin
  inc(KolSbrosAntGrap);
  CurrentElement:=FirstNodeAntGraph;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      CurrentArc:=CurrentValue.Arc;
      While CurrentArc<>nil do
        begin
        For NomKrit:=0 to KolKrit-1 do
          CurrentArc.Pheromon[NomKrit]:=CurrentArc.NPheromon[NomKrit];
        CurrentArc:=CurrentArc.NextArc;
        end;
      For NomKrit:=0 to KolKrit-1 do
        CurrentValue.Pheromon[NomKrit]:=CurrentValue.NPheromon[NomKrit];
      CurrentValue.KolAntGo:=0;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
end;

Procedure CreateZeroGraph;
 var
  KolPheromon:TArrDouble;
  NomPheromon,NomTask,NomKrit:Longword;
  begin
  SetLength(KolPheromon,KolKrit);
  SetLength(NatKolPheromon,KolKrit);
  if KolKrit<>0 then
  for NomKrit := 0 to KolKrit-1 do
    begin
    KolPheromon[NomKrit]:=0.1;
    NatKolPheromon[NomKrit]:=0.1;
    end;
  //ѕон€ть как заносить начальный феромон.
  For NomPheromon:=0 to 9 do
   for NomTask := 0 to 9 do
     AddNodeAnt(IntToStr(NomPheromon),NomTask,KolPheromon);
  AddAllAntArc;
  end;

procedure AddAllAntArc;
var
  CurrentElement,NextElement:TAntNodeElement;
  CurrentValue,NextValue:TAntNodeKol;
begin
  CurrentElement:=FirstNodeAntGraph;
  While CurrentElement.NextElement<>nil do
    begin
    NextElement:=CurrentElement.NextElement;
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      NextValue:=NextElement.Kol;
      While NextValue<>nil do
        begin
        CurrentValue.AddAntArc(NextValue);
        NextValue:=NextValue.NextKol;
        end;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
end;

procedure DelAllAntArc;
var
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  CurrentArc,DelArc:TAntArcKol;
begin
  CurrentElement:=FirstNodeAntGraph;
  While CurrentElement<>nil do
    begin
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      CurrentArc:=CurrentValue.Arc;
      while CurrentArc<>nil do
        begin
        DelArc:=CurrentArc;
        CurrentArc:=CurrentArc.NextArc;
        FreeAndNil(DelArc);
        end;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
end;

procedure AddNodeAnt(NameElement:string; Value:Word; Pheromon:TArrDouble);
var
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  NomKrit:LongWord;
begin
CurrentElement:=SearchElementSklad(NameElement);
If CurrentElement=nil then
  CurrentElement:=AddElementSklad(NameElement);
CurrentValue:=CurrentElement.AddValueElement(Value);
For NomKrit:=0 to KolKrit-1 do
  begin
  CurrentValue.Pheromon[NomKrit]:=Pheromon[NomKrit];
  CurrentValue.NPheromon[NomKrit]:=Pheromon[NomKrit];
  end;
end;

Function AddElementSklad(NameElement:String):TAntNodeElement;
  var
    NewElement,CurrentElement:TAntNodeElement;
    KolElement:Longword;
  begin
  NewElement:=TAntNodeElement.Create;
  NewElement.Name:=NameElement;
  NewElement.KolElement:=0;
  CurrentElement:=FirstNodeAntGraph;
  IF CurrentElement=nil then
    FirstNodeAntGraph:=NewElement
  else
    begin
    While (CurrentElement.NextElement<>nil) and (CurrentElement.Name<NameElement) do
      CurrentElement:=CurrentElement.NextElement;
    If CurrentElement.Name<NameElement then
      begin
      CurrentElement.NextElement:=NewElement;
      NewElement.LastElement:=CurrentElement;
      end
    else
      begin
      NewElement.NextElement:=CurrentElement;
      NewElement.LastElement:=CurrentElement.LastElement;
      If CurrentElement.LastElement<>nil then
        CurrentElement.LastElement.NextElement:=NewElement
      else
        FirstNodeAntGraph:=NewElement;
      CurrentElement.LastElement:=NewElement;
      end;
    end;
  KolElement:=Length(ArrElementGraph);
  SetLength(ArrElementGraph,KolElement+1);
  ArrElementGraph[KolElement]:=NewElement;
  Result:=NewElement;
  end;

function TAntNodeElement.AddValueElement (Value:Word):TAntNodeKol;
  var
    NewKol,CurrentKol:TAntNodeKol;
  begin
  inc(KolElement);
  NewKol:=TAntNodeKol.Create;
  NewKol.Value:=Value;
  NewKol.Element:=Self;
  CurrentKol:=Kol;
  IF CurrentKol=nil then
    Kol:=NewKol
  else
    begin
    While CurrentKol.NextKol<>nil do
      CurrentKol:=CurrentKol.NextKol;
    CurrentKol.NextKol:=NewKol;
    end;
  Result:=NewKol;
  end;

function TAntNodeKol.SearchAntArc(NodeKolKon:TAntNodeKol):tAntArcKol;
  var
    CurrentArc:TAntArcKol;
  begin
  CurrentArc:=Arc;
  While (CurrentArc<>nil) and (CurrentArc.Node<>NodeKolKon) do
    CurrentArc:=CurrentArc.NextArc;
  Result:=CurrentArc;
  end;

procedure TAntNodeKol.AddAntArc(NodeKolKon:TAntNodeKol);
  var
    NewArc,CurrentArc:TAntArcKol;
  begin
  NewArc:=TAntArcKol.Create;
  NewArc.Node:=NodeKolKon;
  CurrentArc:=Arc;
  IF CurrentArc=nil then
    Arc:=NewArc
  else
    begin
    While CurrentArc.NextArc<>nil do
      CurrentArc:=CurrentArc.NextArc;
    CurrentArc.NextArc:=NewArc;
    end;
  end;

function SearchElementSklad(NameElement:String):TAntNodeElement;
  var
    CurrentNodeElement:TAntNodeElement;
  begin
  CurrentNodeElement:=FirstNodeAntGraph;
  While (CurrentNodeElement<>nil) and (CurrentNodeElement.Name<>NameElement) do
    CurrentNodeElement:=CurrentNodeElement.NextElement;
  Result:=CurrentNodeElement;
  end;

function TAntNodeElement.SearchValueElement (Value:Word):TAntNodeKol;
  var
    CurrentNodeKol:TAntNodeKol;
  begin
  CurrentNodeKol:=Kol;
  While (CurrentNodeKol<>nil) and (CurrentNodeKol.Value<>Value) do
    CurrentNodeKol:=CurrentNodeKol.NextKol;
  Result:=CurrentNodeKol;
  end;

constructor TAntNodeElement.Create;
begin
inherited;
Name:='';
Kol:=nil;
NextElement:=nil;
LastElement:=nil;

end;
destructor TAntNodeElement.Destroy;
var
  CurrentKol,DelKol:TAntNodeKol;
begin
CurrentKol:=Kol;
while CurrentKol<>nil do
  begin
  DelKol:=CurrentKol;
  CurrentKol:=CurrentKol.NextKol;
  FreeAndNil(DelKol);
  end;
Name:='';
Kol:=nil;
NextElement:=nil;
LastElement:=nil;
inherited;
end;

constructor TAntNodeKol.Create;
var
  NomKrit:LongWord;
begin
inherited;
Element:=nil;
Arc:=nil;
NextKol:=nil;
KolAntGo:=0;
SetLength(Pheromon,KolKrit);
SetLength(Krit,KolKrit);
SetLength(NPheromon,KolKrit);
if KolKrit<>0 then
For NomKrit:=0 to KolKrit-1 do
  begin
  Pheromon[NomKrit]:=NatKolPheromon[NomKrit];
  NPheromon[NomKrit]:=NatKolPheromon[NomKrit];
  end;
end;

destructor TAntNodeKol.Destroy;
var
  CurrentArc,DelArc:TAntArcKol;
begin
CurrentArc:=Arc;
while CurrentArc<>nil do
  begin
  DelArc:=CurrentArc;
  CurrentArc:=CurrentArc.NextArc;
  FreeAndNil(DelArc);
  end;
SetLength(Pheromon,0); Pheromon:=nil;
SetLength(Krit,0);     Krit:=nil;
SetLength(NPheromon,0);NPheromon:=nil;
Element:=nil;
Arc:=nil;
NextKol:=nil;
inherited;
end;

constructor TAntArcKol.Create;
var
  NomKrit:LongWord;
begin
inherited;
NextArc:=nil;
Node:=nil;
SetLength(Pheromon,KolKrit);
SetLength(NPheromon,KolKrit);
For NomKrit:=0 to KolKrit-1 do
  begin
  Pheromon[NomKrit]:=NatKolPheromon[NomKrit];
  NPheromon[NomKrit]:=NatKolPheromon[NomKrit];
  end;
end;
destructor TAntArcKol.Destroy;
begin
NextArc:=nil;
Node:=nil;
inherited;
end;


end.
