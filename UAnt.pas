unit UAnt;

interface

uses USolutionNew,
     SysUtils,
     UAntGraph;

Type
  TAnt = record
         Node:TAntNodeKol;
         Pheromon:TArrDouble;
         Ves:TArrDouble;
         Krit:TArrDouble;
         CostWay:Double;
         Way:TArrayAntNodeKol;
         end;
  TArrayAnt =  array of TAnt;

  procedure AntGoNextNode(NomAnt:Longword; ParNext:Byte);
  procedure AntAddSolutionFromWay(NomAnt:Longword; Time:Double; var ElementArray:TArrayElementSolution);
  function AntSearchWayAndSolution(NomAnt:Longword; NomBasicSolution:Word; Time:Double):Word;
  Procedure AntAddPheromonToGraph(NomAnt:Longword; KolPheromon:TArrDouble);
procedure CreateAntNode;
Procedure DestroyAntNode;
procedure AntGoGraph;
procedure CreateAnt(KolAnt:Word);
Procedure DestroyAnt(NomAnt:Longword);
procedure SortAnt;
procedure GoKritAntGraph(TypeKrit:Byte; Par:Double; var ArrKritNode:TArrDouble);

var
  Ant:TArrayAnt;
  StartAntNode:TAntNodeKol;
  ParKrit:TArrDouble;
  SortArrayAtn:array of array Of LongWord;

implementation

uses UMain;
//uses UMainAnt, UMain,,
//     UTransportGRAPH, UVolna;

procedure GoKritAntGraph(TypeKrit:Byte; Par:Double; var ArrKritNode:TArrDouble);
var
  CurrentElement:TAntNodeElement;
  CurrentValue:TAntNodeKol;
  AllPheromon,AllOtnPheromon:TArrDouble;
  NomKrit,NomKritOtn,KolNodeCurrentValue:LongWord;
  AllKolPheromon,SummPheromonNode,AllParOtnPheromon:Double;
  KolSumm:LongWord;
begin
SetLength(AllPheromon,KolKrit);
SetLength(AllOtnPheromon,KolKrit);

For NomKrit:=0 to KolKrit-1 do
  begin
  ArrKritNode[NomKrit]:=0;
  end;
KolSumm:=0;

CurrentElement:=FirstNodeAntGraph;
While CurrentElement<>nil do
    begin
    For NomKrit:=0 to KolKrit-1 do
      begin
      AllPheromon[NomKrit]:=0;
      AllOtnPheromon[NomKrit]:=0;
      end;
    KolNodeCurrentValue:=0;
    AllParOtnPheromon:=0;
    AllKolPheromon:=0;
    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      For NomKrit:=0 to KolKrit-1 do
        begin
        Case TypeKrit of
          0: begin
             AllPheromon[NomKrit]:=AllPheromon[NomKrit]+CurrentValue.Pheromon[NomKrit];
             AllKolPheromon:=AllKolPheromon+CurrentValue.Pheromon[NomKrit];
             end;
          1:begin
            SummPheromonNode:=0;
            For NomKritOtn:=0 to KolKrit-1 do
              SummPheromonNode:=SummPheromonNode+CurrentValue.Pheromon[NomKritOtn];
            AllOtnPheromon[NomKrit]:=AllOtnPheromon[NomKrit]+CurrentValue.Pheromon[NomKrit]/(SummPheromonNode+0.00001);
            end;
          2:begin
            SummPheromonNode:=0;
            For NomKritOtn:=0 to KolKrit-1 do
              SummPheromonNode:=SummPheromonNode+CurrentValue.Pheromon[NomKritOtn];
            AllOtnPheromon[NomKrit]:=AllOtnPheromon[NomKrit]+exp(Ln(CurrentValue.KolAntGo+0.00001)*Par)*CurrentValue.Pheromon[NomKrit]/(SummPheromonNode+0.000001);
            AllParOtnPheromon      :=AllParOtnPheromon      +exp(Ln(CurrentValue.KolAntGo+0.00001)*Par)*CurrentValue.Pheromon[NomKrit]/(SummPheromonNode+0.000001);
            end;
        end;
        end;
      Inc(KolNodeCurrentValue);
      CurrentValue:=CurrentValue.NextKol;
      end;

    CurrentValue:=CurrentElement.Kol;
    While CurrentValue<>nil do
      begin
      Case TypeKrit of
        0: begin
           For NomKrit:=0 to KolKrit-1 do
             CurrentValue.Krit[NomKrit]:=AllPheromon[NomKrit]/(AllKolPheromon+0.0000001);
           end;
        1: begin
           For NomKrit:=0 to KolKrit-1 do
             CurrentValue.Krit[NomKrit]:=AllOtnPheromon[NomKrit]/(KolNodeCurrentValue+0.0000001);
           end;
        2: begin
           For NomKrit:=0 to KolKrit-1 do
             CurrentValue.Krit[NomKrit]:=AllOtnPheromon[NomKrit]/(AllParOtnPheromon+0.0000001);
           end;
      end;
      If CurrentValue=CurrentElement.Kol then
        begin
        For NomKrit:=0 to KolKrit-1 do
          ArrKritNode[NomKrit]:=ArrKritNode[NomKrit]+CurrentValue.Krit[NomKrit];
        Inc(KolSumm);
        end;
      CurrentValue:=CurrentValue.NextKol;
      end;
    CurrentElement:=CurrentElement.NextElement;
    end;
For NomKrit:=0 to KolKrit-1 do
  ArrKritNode[NomKrit]:=ArrKritNode[NomKrit]/KolSumm;

SetLength(AllPheromon,0);  AllPheromon:=nil;
SetLength(AllOtnPheromon,0); AllOtnPheromon:=nil;
end;

Procedure qSortAntToUP(NomKrit,l,r:LongInt);
var i,j:LongInt;
    w:LongWord;
    q:TAnt;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := Ant[SortArrayAtn[NomKrit,(l+r) div 2]]
  else
    q:=Ant[SortArrayAtn[NomKrit,l]];
  repeat
    while (i<r) and (Ant[SortArrayAtn[NomKrit,i]].Krit[NomKrit] > q.Krit[NomKrit]) do
      inc(i);
    while (j>l) and (q.Krit[NomKrit] > Ant[SortArrayAtn[NomKrit,j]].Krit[NomKrit]) do
      dec(j);
    if (i <= j) then
      begin
      w:=SortArrayAtn[NomKrit,i]; SortArrayAtn[NomKrit,i]:=SortArrayAtn[NomKrit,j]; SortArrayAtn[NomKrit,j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortAntToUP(NomKrit,l,j);
  if (i < r) then qSortAntToUP(NomKrit,i,r);
end;

Procedure qSortAntToDown(NomKrit,l,r:LongInt);
var i,j:LongInt;
    w:LongWord;
    q:TAnt;
begin
  i := l; j := r;
  if ((l+r) div 2<r) and ((l+r) div 2>l) then
    q := Ant[SortArrayAtn[NomKrit,(l+r) div 2]]
  else
    q:=Ant[SortArrayAtn[NomKrit,l]];
  repeat
    while (i<r) and (Ant[SortArrayAtn[NomKrit,i]].Krit[NomKrit] < q.Krit[NomKrit]) do
      inc(i);
    while (j>l) and (q.Krit[NomKrit] < Ant[SortArrayAtn[NomKrit,j]].Krit[NomKrit]) do
      dec(j);
    if (i <= j) then
      begin
      w:=SortArrayAtn[NomKrit,i]; SortArrayAtn[NomKrit,i]:=SortArrayAtn[NomKrit,j]; SortArrayAtn[NomKrit,j]:=w;
      inc(i); dec(j);
      end;
  until (i > j);
  if (l < j) then qSortAntToDown(NomKrit,l,j);
  if (i < r) then qSortAntToDown(NomKrit,i,r);
end;

procedure SortAnt;
  var
    NomKrit:LongWord;
    NomAnt,KolAnt:LongWord;
  begin
  KolAnt:=Length(Ant);
  SetLength(SortArrayAtn,KolKrit);
  For NomKrit:=0 to KolKrit-1 do
    begin
    SetLength(SortArrayAtn[NomKrit],KolAnt);
    For NomAnt:=0 to KolAnt-1 do
      SortArrayAtn[NomKrit][NomAnt]:=NomAnt;

    If ParNaprKrit[NomKrit]=1 then
      qSortAntToUP(NomKrit,0,KolAnt-1)
    else
      qSortAntToDown(NomKrit,0,KolAnt-1);
    end;
{}
  end;

Procedure AntAddPheromonToGraph (NomAnt:Longword; KolPheromon:TArrDouble);
var
  NomNode:Word;
  Arc:TAntArcKol;
  NomKrit:LongWord;
begin
If Length(Ant[NomAnt].Way)<>0 then
For NomNode:=0 to Length(Ant[NomAnt].Way)-1 do
  begin
  For NomKrit:=0 to KolKrit-1 do
    begin
    Ant[NomAnt].Way[NomNode].Pheromon[NomKrit]:=Ant[NomAnt].Way[NomNode].Pheromon[NomKrit]+KolPheromon[NomKrit];

    end;
  Inc(Ant[NomAnt].Way[NomNode].KolAntGo);

  If NomNode<>Length(Ant[NomAnt].Way)-1 then
    begin
    Arc:=Ant[NomAnt].Way[NomNode].SearchAntArc(Ant[NomAnt].Way[NomNode+1]);
    For NomKrit:=0 to KolKrit-1 do
      Arc.Pheromon[NomKrit]:=Arc.Pheromon[NomKrit]+KolPheromon[NomKrit];
    end;
  end;
end;

function AntSearchWayAndSolution(NomAnt:Longword; NomBasicSolution:Word; Time:Double):Word;
  var
    NomElement,n,m:Word;
    ElementArray:TArrayElementSolution;
  begin
  n:=Length(Ant[NomAnt].Way);
  IF Length(ArraySolution)=0 then
    Result:=6400
  else
    begin
    m:=Length(ArraySolution[NomBasicSolution].ElementArray);
    SetLength(ElementArray,n+m);
    If m<>0 then
    for NomElement:=0 to m-1 do
      begin
      ElementArray[NomElement].Element:=ArraySolution[NomBasicSolution].ElementArray[NomElement].Element;
      ElementArray[NomElement].Value:=ArraySolution[NomBasicSolution].ElementArray[NomElement].Value;
      end;
    If n<>0 then
    For NomElement:=0 to n-1 do
      begin
      ElementArray[NomElement+m].Element:=Ant[NomAnt].Way[NomElement].Element.Name;
      ElementArray[NomElement+m].Value:=Ant[NomAnt].Way[NomElement].Value;
      end;

    SortElementArraySolution(ElementArray);
    Result:=ProcSearchSolution(ElementArray);

    SetLength(ElementArray,0); ElementArray:=nil;
    end;
  end;

procedure AntAddSolutionFromWay(NomAnt:Longword; Time:Double; var ElementArray:TArrayElementSolution);
  var
    NomElement,n,m:Word;
  begin
  n:=Length(Ant[NomAnt].Way);
  m:=Length(ElementArray);
  SetLength(ElementArray,n+m);
  For NomElement:=m to m+n-1 do
    begin
    ElementArray[NomElement].Element:=Ant[NomAnt].Way[NomElement].Element.Name;
    ElementArray[NomElement].Value:=Ant[NomAnt].Way[NomElement].Value;
    end;
  SortElementArraySolution(ElementArray);
  end;  

//Процедура перехода Агента в следующую вершину
procedure AntGoNextNode(NomAnt:Longword; ParNext:Byte);//Тип агента (тип выбора агентом следующей вершины)
  var
    CArc:TAntArcKol;                   //Указатель на дугу
    AllKolPheromon:Double; //TArrDouble;      //Суммарное количество весов на всех следующих вершинах
    KolPheromon:TArrDouble;   //Массивы крайних точек отображения весов на числовую прямую (0; 1)
    Rnd:Double;                            //Случайные числа из диапазона (0; 1)
    KolArc,CurrentNomArc:Integer;        //Счетчики количества дуг
    NomArc:array of LongWord;
    n:Word;
    st:string;                                  //Для вывода на экран
    BEndSearch:boolean;                         //Флаг завершения поиска
    NomKrit:LongWord;
  begin
  AllKolPheromon:=0;
  KolArc:=0;
  //Определения суммарного количества весов на всех дугах
  CArc:=Ant[NomAnt].Node.Arc;
  While CArc<>nil do
    begin
    Inc(KolArc);
    Case ParNext of
      0:AllKolPheromon:=AllKolPheromon+CArc.Node.Pheromon[0];
      1:AllKolPheromon:=AllKolPheromon+CArc.Node.Pheromon[1];
      2:begin
        AllKolPheromon:=AllKolPheromon+CArc.Node.Pheromon[0]/(CArc.Node.Pheromon[1]+0.0001);
        end;
      3,8:begin
        For NomKrit:=0 to KolKrit-1 do
          AllKolPheromon:=AllKolPheromon+CArc.Node.Pheromon[NomKrit];
        end;
      4:begin
        For NomKrit:=0 to KolKrit-1 do
          AllKolPheromon:=AllKolPheromon+CArc.Node.Pheromon[NomKrit]*ParKrit[NomKrit];
        end;
      5,6,7:begin
            For NomKrit:=0 to KolKrit-1 do
              AllKolPheromon:=AllKolPheromon+CArc.Node.Pheromon[NomKrit]*CArc.Node.Krit[NomKrit];
            end;
      end;
    CArc:=CArc.NextArc;
    end;
//  If (GoProtocolEvent) or (GoProtocolEventAnt) then
//  FModel.MeProt.Lines.Add('количество дуг '+IntToStr(KolArc)+' Феромон ='+FloatToStr(AllKolPheromon));

  //Создание массива отображения количества веса на прямую [0; 1]
//  SetLength(KolPheromon,KolKrit);
//  For NomKrit:=0 to KolKrit-1 do
    SetLength(KolPheromon,KolArc);
  For CurrentNomArc:=0 to KolArc-1 do
    KolPheromon[CurrentNomArc]:=0;
  CurrentNomArc:=0;
  CArc:=Ant[NomAnt].Node.Arc;
  st:='('+FloatToStr(AllKolPheromon)+')';

  While CArc<>nil do
    begin
//    If CostWay+CArc.Node.Element.CostProduction<LimitCostProduction then
    case ParNext of
    0:begin
      If CurrentNomArc=0 then
        KolPheromon[CurrentNomArc]:=(CArc.Node.Pheromon[0])/AllKolPheromon
      else
        KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc-1]+(CArc.Node.Pheromon[0])/AllKolPheromon;
      end;
    1:begin
      If CurrentNomArc=0 then
        KolPheromon[CurrentNomArc]:=(CArc.Node.Pheromon[1])/AllKolPheromon
      else
        KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc-1]+(CArc.Node.Pheromon[1])/AllKolPheromon;
      end;
    2:begin
      If CurrentNomArc=0 then
        KolPheromon[CurrentNomArc]:=(CArc.Node.Pheromon[0]/(CArc.Node.Pheromon[1]+0.0001))/AllKolPheromon
      else
        KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc-1]+(CArc.Node.Pheromon[0]/(CArc.Node.Pheromon[1]+0.0001))/AllKolPheromon;
      end;
    3:begin
      If CurrentNomArc=0 then
        begin
        For NomKrit:=0 to KolKrit-1 do
          KolPheromon[CurrentNomArc]:=(CArc.Node.Pheromon[NomKrit])/AllKolPheromon;
        end
      else
        begin
        For NomKrit:=0 to KolKrit-1 do
          KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc-1]+(CArc.Node.Pheromon[NomKrit])/AllKolPheromon;
        end;
      end;
    4,8:begin
        For NomKrit:=0 to KolKrit-1 do
          KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc]+(CArc.Node.Pheromon[NomKrit]*ParKrit[NomKrit]);
        KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc]/AllKolPheromon;
        If CurrentNomArc<>0 then
          KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc]+KolPheromon[CurrentNomArc-1]
        end;
    5,6,7: begin
           For NomKrit:=0 to KolKrit-1 do
             KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc]+(CArc.Node.Pheromon[NomKrit]*CArc.Node.Krit[NomKrit]);
           KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc]/AllKolPheromon;
           If CurrentNomArc<>0 then
             KolPheromon[CurrentNomArc]:=KolPheromon[CurrentNomArc]+KolPheromon[CurrentNomArc-1]
           end;
    end;
    If FMain.CbAllProt.Checked then
      St:=st+FloatToStr(CArc.Node.Pheromon[0])+'-'+FloatToStr(CArc.Node.Pheromon[1])+'-'+FloatToStr(KolPheromon[CurrentNomArc])+':';
    CArc:=CArc.NextArc;
    Inc(CurrentNomArc);
    end;
  If FMain.CbAllProt.Checked then FMain.MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+' F('+st+')');
//  FModel.MeProt.Lines.Add(st);

  //Организация цикличесокго поиска вершины для удовлетворения множественных требований
  BEndSearch:=false;
  SetLength(NomArc,KolKrit);
  While not BEndSearch do
    begin

    For NomKrit:=KolKrit-1 downto 0 do
      begin
    //Получение случайного числа в диапазоне (0; 1)
      rnd:=Random;
//    If (GoProtocolEvent) or (GoProtocolEventAnt) then
//    FModel.MeProt.Lines.Add('Число - '+FloatToStr(rnd));

    //Определение диапазона из массива, в который попало случайное число
      NomArc[NomKrit]:=0;
      CArc:=Ant[NomAnt].Node.Arc;
      While (CArc<>nil) and (NomArc[NomKrit]<=KolArc) and (KolPheromon[NomArc[NomKrit]]<Rnd) do
        begin
        inc(NomArc[NomKrit]);
        CArc:=CArc.NextArc;
        end;
      end;


    If (ParNext<>3) then
      BEndSearch:=true
    else
      begin
      BEndSearch:=true;
      For NomKrit:=0 to KolKrit-2 do
        if NomArc[NomKrit]<>NomArc[NomKrit+1] then
          BEndSearch:=false;
      end;
    end;
  //Добавление выбранной вершины в путь агента
  n:=Length(Ant[NomAnt].Way);
  SetLength(Ant[NomAnt].Way,n+1);
  Ant[NomAnt].Way[n]:=CArc.Node;
  Ant[NomAnt].Node:=CArc.Node;
  Ant[NomAnt].CostWay:=Ant[NomAnt].CostWay+Ant[NomAnt].Node.Element.CostProduction;
  For NomKrit:=0 to KolKrit-1 do
    Ant[NomAnt].Pheromon[NomKrit]:=CArc.Node.Pheromon[NomKrit];

  SetLength(KolPheromon,0); KolPheromon:=nil;
  SetLength(NomArc,0); NomArc:=nil;
  end;

//Процедура создания "стартовой" вершины графа решений
procedure CreateAntNode;
  var
    CNode:TAntNodeKol;  //Указатель на первые вершины графа решений
  begin
  StartAntNode:=TAntNodeKol.Create;        //Создание "стартовой" вершины
  CNode:=FirstNodeAntGraph.Kol;
  While CNode<>nil do
    begin
    StartAntNode.AddAntArc(CNode);         //Добавление дуг во все начальные вершины графа решений
    CNode:=CNode.NextKol
    end;
  end;

Procedure DestroyAntNode;
  begin
  StartAntNode.Destroy;
  end;

procedure CreateAnt(KolAnt:Word);
  var
    NomAnt:Word;
  begin
  SetLength(Ant,KolAnt);
  For NomAnt:=0 to KolAnt-1 do
    begin
    Ant[NomAnt].Node:=nil;
    Ant[NomAnt].CostWay:=0;
    SetLength(Ant[NomAnt].Pheromon,KolKrit);
    SetLength(Ant[NomAnt].Ves,KolKrit);
    SetLength(Ant[NomAnt].Krit,KolKrit);
    SetLength(Ant[NomAnt].Way,0);
    end;
  end;

Procedure DestroyAnt(NomAnt:Longword);
begin
  Ant[NomAnt].Node:=nil;
  Ant[NomAnt].CostWay:=0;
  SetLength(Ant[NomAnt].Pheromon,0); Ant[NomAnt].Pheromon:=nil;
  SetLength(Ant[NomAnt].Ves,0); Ant[NomAnt].Ves:=nil;
  SetLength(Ant[NomAnt].Krit,0); Ant[NomAnt].Krit:=nil;
  SetLength(Ant[NomAnt].Way,0); Ant[NomAnt].Way:=nil;
end;

procedure AntGoGraph;
  var
    NomAnt:Word;
  begin
  If Length(Ant)<>0 then
  For NomAnt:=0 to Length(Ant)-1 do
    begin
    Ant[NomAnt].Node:=StartAntNode;
    end;
  end;

end.
 