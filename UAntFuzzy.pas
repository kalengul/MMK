unit UAntFuzzy;

interface

uses UModelFuzzy,UAntGraph,UAnt,SysUtils;
const
  ParConstPr = 1000;

Procedure CreateAntGraphAtFuzzyModel;

var
  TypeNatFeromon:byte; //0-¬рем€ точного выполнени€ работы 1-¬рем€ возможного выполнени€ работы 2-ћатематическое ожидание времени выполнени€ работы

implementation

uses UMain;

Procedure CreateAntGraphAtFuzzyModel;
  var
  KolPheromon:TArrDouble;
  NomPheromon,NomTask,NomKrit:Longword;
  ParTime,ParZn:Double;
  begin
  TypeNatFeromon:=0;
  SetLength(KolPheromon,KolKrit);
  SetLength(NatKolPheromon,KolKrit);
  if KolKrit<>0 then
    for NomKrit := 0 to KolKrit-1 do
      begin
      KolPheromon[NomKrit]:=0.1;
      NatKolPheromon[NomKrit]:=0.1;
      end;
  NomTask:=0;
  while NomTask<Length(ArrFuzzyElPerson) do
    begin
    //«аносим начальный феромон
    If FMain.RgNatFer.ItemIndex=1 then
    case TypeNatFeromon of
    0: begin
       NomPheromon:=0;
       ParZn:=1;
       While NomPheromon<length(ArrFuzzyElPerson[NomTask].FuzzySetTime) do
         begin
         if ParZn<=ArrFuzzyElPerson[NomTask].FuzzySetPr[NomPheromon].FP then
           begin
           ParZn:=ArrFuzzyElPerson[NomTask].FuzzySetPr[NomPheromon].FP;
           ParTime:=ArrFuzzyElPerson[NomTask].FuzzySetPr[NomPheromon].Zn;
           end;
         inc(NomPheromon);
         end;
       if KolKrit<>0 then
         for NomKrit := 0 to KolKrit-1 do
           begin
           KolPheromon[NomKrit]:=ParTime*ParConstPr;
           NatKolPheromon[NomKrit]:=ParTime*ParConstPr;
           end;
       end;
    1: begin
       NomPheromon:=0;
       ParZn:=0;
       While NomPheromon<length(ArrFuzzyElPerson[NomTask].FuzzySetTime) do
         begin
         if ParZn>=ArrFuzzyElPerson[NomTask].FuzzySetPr[NomPheromon].FP then
           begin
           ParZn:=ArrFuzzyElPerson[NomTask].FuzzySetPr[NomPheromon].FP;
           ParTime:=ArrFuzzyElPerson[NomTask].FuzzySetPr[NomPheromon].Zn;
           end;
         inc(NomPheromon);
         end;
       if KolKrit<>0 then
         for NomKrit := 0 to KolKrit-1 do
           begin
           KolPheromon[NomKrit]:=ParTime*ParConstPr;
           NatKolPheromon[NomKrit]:=ParTime*ParConstPr;
           end;
       end;
    3: begin
       NomPheromon:=1;
       ParTime:=0;
       While NomPheromon<length(ArrFuzzyElPerson[NomTask].FuzzySetTime) do
         begin
//         ParTime:=ParTime+
         inc(NomPheromon);
         end;
       if KolKrit<>0 then
         for NomKrit := 0 to KolKrit-1 do
           begin
           KolPheromon[NomKrit]:=ParTime*ParConstPr;
           NatKolPheromon[NomKrit]:=ParTime*ParConstPr;
           end;
       end;
    end;
    AddNodeAnt(IntToStr(ArrFuzzyElPerson[NomTask].Person),ArrFuzzyElPerson[NomTask].Task,KolPheromon);
    inc(NomTask);
    end;
  AddAllAntArc;
  CreateAntNode;
  end;


end.
