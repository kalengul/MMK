unit USolutionNew;

interface

uses UAntGraph;

type
  TArrayLongword = array of LongWord;
  TElementSolution = record
                          Element:string;
                          Value:LongWord;
                          end;
  TArrayElementSolution = array of TElementSolution;
  TSolution = record
              ElementArray:TArrayElementSolution;
              Krit:TArrDouble;
              end;

Procedure SortAllSolution(NomKrit:Longword);
procedure ParetoSetToFirstSolution(var NomSolution:Longword);
procedure SortElementArraySolution(ElementArray:TArrayElementSolution);
procedure AddAntSolutionToParetoSet(NomSolution:Longword; var BoolNewPareto:boolean);
procedure AddSolutionToParetoSet;
Procedure SortParetoSet(NomKrit:LOngword);
Function ProcSearchSolution(SearchSolution:TArrayElementSolution):LongWord;

var
  ArraySolution:array of TSolution;
  KolSolution:Longword;
  ParetoSet:TArrayLongword;
  ParNaprKrit:TArrDouble;
  IspParArc,IspParNode:TArrDouble;
  ParKritEnd,ParKritMax:TArrDouble;
  NPheromon:TArrDouble;
  LimitCostProduction:Double;  //Заглушка

implementation

//Установка решений из множества Парето в начало списка решений
procedure ParetoSetToFirstSolution(var NomSolution:Longword);
var
  Buf:TSolution;
  NomParetoSet:Longword;
begin
NomParetoSet:=0;
while NomParetoSet<Length(ParetoSet) do
  begin
{  if ParetoSet[NomParetoSet]<>NomParetoSet then
    begin                          }
    if NomSolution=ParetoSet[NomParetoSet] then
      NomSolution:=NomParetoSet;
    Buf:=ArraySolution[ParetoSet[NomParetoSet]];
    ArraySolution[ParetoSet[NomParetoSet]]:=ArraySolution[NomParetoSet];
    ArraySolution[NomParetoSet]:=Buf;
    ParetoSet[NomParetoSet]:=NomParetoSet;
{    end;   }
  inc(NomParetoSet);
  end;
end;


Procedure SortAllSolution(NomKrit:Longword);
var
  i,j:longword;
  w:TSolution;
  begin
  i:=0;
  while i<Length(ArraySolution)-1 do
    begin
    j:=i+1;
    while (j<Length(ArraySolution)) do
      begin
      if ArraySolution[i].Krit[NomKrit]>ArraySolution[j].Krit[NomKrit] then
        begin w:=ArraySolution[i]; ArraySolution[i]:=ArraySolution[j]; ArraySolution[j]:=w; end;
      inc (j);
      end;
    inc(i);
    end;
  end;

//Проверка решения на вхождение его в множество Парето
procedure AddAntSolutionToParetoSet(NomSolution:Longword; var BoolNewPareto:boolean);
var
  CurrentSolution,CurrentSolutionDel,NomKrit,KolElementParetoset:LongWord;
  BParetoSet,BAllKrit:Boolean;
begin
If (Length(ArraySolution)<>0) and (NomSolution<Length(ArraySolution)) then
begin
BoolNewPareto:=false;
KolElementParetoset:=Length(ParetoSet);
if KolElementParetoset=0 then   //Множество Парето - пустое
  begin
  SetLength(ParetoSet,1);
  ParetoSet[0]:=NomSolution;
  end
else
  begin
  BParetoSet:=true;  //Включить в множество Парето
  //Пройтись по всему множеству Парето
  CurrentSolution:=0;
  while (CurrentSolution<KolElementParetoset) and (BParetoSet) do
    begin
    //Проверить вытеснит ли решение из множество текущее?
    BAllKrit:=True;
    for NomKrit:=0 to KolKrit-1 do            //По всем критериям
        If ParNaprKrit[NomKrit]=0 then   //min
          begin
          if ArraySolution[ParetoSet[CurrentSolution]].Krit[NomKrit]>=ArraySolution[NomSolution].Krit[NomKrit] then
            BAllKrit:=False;
          end
        else
          begin
          if ArraySolution[ParetoSet[CurrentSolution]].Krit[NomKrit]<=ArraySolution[NomSolution].Krit[NomKrit] then
            BAllKrit:=False;
          end;
    BParetoSet:=not BAllKrit;
    inc(CurrentSolution);
    end;
  if BParetoSet then     //Если не нашли решение, которое вытеснит текущее из множества Парето
    begin
    BoolNewPareto:=true;
    SetLength(ParetoSet,KolElementParetoset+1);
    ParetoSet[KolElementParetoset]:=NomSolution;
    inc(KolElementParetoset);

     //Проверить вытеснит ли текущее решение каке-нибудь решение из множества?
    CurrentSolution:=0;
    while (CurrentSolution<KolElementParetoset-1) do
    begin

    BAllKrit:=True;
    for NomKrit:=0 to KolKrit-1 do            //По всем критериям
        If ParNaprKrit[NomKrit]=0 then   //min
          begin
          if ArraySolution[ParetoSet[CurrentSolution]].Krit[NomKrit]<ArraySolution[NomSolution].Krit[NomKrit] then
            BAllKrit:=False;
          end
        else
          begin
          if ArraySolution[ParetoSet[CurrentSolution]].Krit[NomKrit]>ArraySolution[NomSolution].Krit[NomKrit] then
            BAllKrit:=False;
          end;
    if BAllKrit then  //Если по всем критериям текущее решение лучше
      begin
      //Удалить решение из множества
      CurrentSolutionDel:=CurrentSolution;
      While CurrentSolutionDel<KolElementParetoset-1 do
        begin
        ParetoSet[CurrentSolutionDel]:=ParetoSet[CurrentSolutionDel+1];
        inc(CurrentSolutionDel);
        end;
      KolElementParetoset:=KolElementParetoset-1;
      SetLength(ParetoSet,KolElementParetoset)
      end;
    inc(CurrentSolution);
    end;
    end;
  end;
end;
end;

//Проверка всех решений и выбор тех, которые входят в множество Парето
procedure AddSolutionToParetoSet;
var
  CurrentSolution,NomSolution,NomKrit,KolElementParetoset:LongWord;
  BParetoSet,BAllKrit:Boolean;
begin
If Length(ArraySolution)<>0 then
begin
KolElementParetoset:=0;

NomSolution:=0;
While NomSolution<=Length(ArraySolution)-1 do          //Проход по всем решениям
  begin
  BParetoSet:=True;
  CurrentSolution:=0;
  While (CurrentSolution<=Length(ArraySolution)-1) and (BParetoSet) do    //Проход по всем другим решениям для сравнения
    begin

    BAllKrit:=True;
    If CurrentSolution=NomSolution then  BAllKrit:=false
    else
      for NomKrit:=0 to KolKrit-1 do            //По всем критериям
        If ParNaprKrit[NomKrit]=0 then   //min
          begin
          if ArraySolution[CurrentSolution].Krit[NomKrit]>=ArraySolution[NomSolution].Krit[NomKrit] then
            BAllKrit:=False;
          end
        else
          begin
          if ArraySolution[CurrentSolution].Krit[NomKrit]<=ArraySolution[NomSolution].Krit[NomKrit] then
            BAllKrit:=False;
          end;
    BParetoSet:=not BAllKrit;
    Inc(CurrentSolution);
    end;
  If BParetoSet then                 //Если нет решения лучше - добавить в множество Парето
    begin
    Inc(KolElementParetoset);
    SetLength(ParetoSet,KolElementParetoset);
    ParetoSet[KolElementParetoset-1]:=NomSolution;
    end;
  Inc(NomSolution);
  end;
end;
end;

Function ProcSearchSolution(SearchSolution:TArrayElementSolution):LongWord;
  var
    NomSolution,NomElement,NextNomElement,KolTrueElement:LongWord;
    SearchTrue:Boolean;
  begin
  NomSolution:=0;
  SearchTrue:=False;
  While (not SearchTrue) and (NomSolution<Length(ArraySolution)) do
    begin
    NomElement:=0;
    If Length(ArraySolution[NomSolution].ElementArray)<>0 then
      begin
      While (NomElement<Length(ArraySolution[NomSolution].ElementArray)) and
             ((ArraySolution[NomSolution].ElementArray[NomElement].Element=SearchSolution[NomElement].Element)
             and (ArraySolution[NomSolution].ElementArray[NomElement].Value=SearchSolution[NomElement].Value)) do
         begin
         Inc (NomElement);
         end;
      SearchTrue:=NomElement=Length(ArraySolution[NomSolution].ElementArray);
      end;
    If not SearchTrue then
      Inc(NomSolution);
    end;
  IF SearchTrue then
    Result:=NomSolution
  else
    Result:=MaxInt;
  end;


Procedure qSortElementArraySolution(ElementArray:TArrayElementSolution; l,r:LongInt);
var i,j:LongInt;
    w,q:TElementSolution;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := ElementArray[(l+r) div 2]
  else
    q:=ElementArray[l];
  repeat
    while (i<r) and (ElementArray[i].Element < q.Element) do
      inc(i);
    while (j>l) and (q.Element < ElementArray[j].Element) do
      dec(j);
    if (i <= j) then
      begin
      w:=ElementArray[i]; ElementArray[i]:=ElementArray[j]; ElementArray[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortElementArraySolution(ElementArray,l,j);
  if (i < r) then qSortElementArraySolution(ElementArray,i,r);
end;

Procedure SortElementArraySolution(ElementArray:TArrayElementSolution);
  begin
  If Length(ElementArray)<>0 then
    qSortElementArraySolution(ElementArray,0, Length(ElementArray)-1);
  end;

Procedure qSortParetoSet(NomKrit:LongWord; ParetoSet:TArrayLongword; l,r:LongInt);
var i,j:LongInt;
    w,q:LongWord;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := ParetoSet[(l+r) div 2]
  else
    q:=ParetoSet[l];
  repeat
    while (i<r) and (ArraySolution[ParetoSet[i]].Krit[NomKrit] < ArraySolution[q].Krit[NomKrit]) do
      inc(i);
    while (j>l) and (ArraySolution[q].Krit[NomKrit] < ArraySolution[ParetoSet[j]].Krit[NomKrit]) do
      dec(j);
    if (i <= j) then
      begin
      w:=ParetoSet[i]; ParetoSet[i]:=ParetoSet[j]; ParetoSet[j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortParetoSet(NomKrit,ParetoSet,l,j);
  if (i < r) then qSortParetoSet(NomKrit,ParetoSet,i,r);
end;

Procedure SortParetoSet(NomKrit:LOngword);
  begin
  if Length(ParetoSet)<>0 then
    qSortParetoSet(NomKrit,ParetoSet,0, Length(ParetoSet)-1);
  end;

end.
