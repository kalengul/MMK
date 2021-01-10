unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, Grids, ComCtrls,ComObj, Buttons;

type
  TFMain = class(TForm)
    Pn1: TPanel;
    MeProt: TMemo;
    Pn2: TPanel;
    OdLoad: TOpenDialog;
    Label1: TLabel;
    SeKolKrit: TSpinEdit;
    Pn3: TPanel;
    GbAnt: TGroupBox;
    Label2: TLabel;
    SeKolAnt: TSpinEdit;
    Pn4: TPanel;
    CbAllProt: TCheckBox;
    RgKrit: TRadioGroup;
    SgKrit: TStringGrid;
    SgAntPAr: TStringGrid;
    SdSave: TSaveDialog;
    PnAntGraph: TPanel;
    Memo1: TMemo;
    Pn6: TPanel;
    CbAllGraph: TCheckBox;
    RgKritOst: TRadioGroup;
    Label3: TLabel;
    SeKolIterationEnd: TSpinEdit;
    Label4: TLabel;
    SgKritEnd: TStringGrid;
    Label6: TLabel;
    SeKritKolIteration: TSpinEdit;
    Label7: TLabel;
    TCType: TTabControl;
    PnPareto: TPanel;
    PbPareto: TPaintBox;
    PnStat: TPanel;
    Pn5: TPanel;
    MeStat: TMemo;
    SgStatisticsNat: TStringGrid;
    SgStatisticsKon: TStringGrid;
    Label8: TLabel;
    Label9: TLabel;
    BtInsertSetting: TButton;
    BtGoStatistics: TButton;
    Label10: TLabel;
    SeKolProgon: TSpinEdit;
    SgStatisticsShag: TStringGrid;
    Label11: TLabel;
    LeParKolProhod: TLabeledEdit;
    SgParKrit: TStringGrid;
    Label12: TLabel;
    RgNatFer: TRadioGroup;
    RgTypeNormKrit: TRadioGroup;
    SbGoAnt: TSpeedButton;
    SbClearAntGraph: TSpeedButton;
    GbSetting: TGroupBox;
    SbSaveSetting: TSpeedButton;
    SbLoadSetting: TSpeedButton;
    GbPAretoSet: TGroupBox;
    SbVivodParetoSet: TSpeedButton;
    SbSaveParetoSet: TSpeedButton;
    SbLoadParetoSet: TSpeedButton;
    SbCreateAntGraph: TSpeedButton;
    GbAntGraph: TGroupBox;
    GbSystem: TGroupBox;
    SbLoadDependSystem: TSpeedButton;
    SbGoStatistis: TSpeedButton;
    SbGoAllSolution: TSpeedButton;
    RgParStatistics: TRadioGroup;
    LeNatZnStatiatics: TLabeledEdit;
    LeKonZnStatistics: TLabeledEdit;
    LeShagStatistics: TLabeledEdit;
    Pn: TPanel;
    MeStatProgon: TMemo;
    CbClearMemeoIteration: TCheckBox;
    SbLoadDependSystem4Krit: TSpeedButton;
    CbVivodKrit: TCheckBox;
    RgPheromonQ: TRadioGroup;
    Label5: TLabel;
    EdParNormPheromon: TEdit;
    SbLoadFuzzySystem: TSpeedButton;
    CbExcelIter: TCheckBox;
    SpeedButton1: TSpeedButton;
    RgZaciklivanie: TRadioGroup;
    SbZeroModel: TSpeedButton;
    RgSolutionSetting: TRadioGroup;
    Label13: TLabel;
    SeKolSolutionInGraph: TSpinEdit;
    SpeedButton2: TSpeedButton;
    procedure SeKolKritChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TCTypeChange(Sender: TObject);
    procedure BtInsertSettingClick(Sender: TObject);
    procedure BtGoStatisticsClick(Sender: TObject);
    procedure SbGoAntClick(Sender: TObject);
    procedure SbClearAntGraphClick(Sender: TObject);
    procedure SbSaveSettingClick(Sender: TObject);
    procedure SbLoadSettingClick(Sender: TObject);
    procedure SbVivodParetoSetClick(Sender: TObject);
    procedure SbCreateAntGraphClick(Sender: TObject);
    procedure SbSaveParetoSetClick(Sender: TObject);
    procedure SbLoadDependSystemClick(Sender: TObject);
    procedure SbLoadParetoSetClick(Sender: TObject);
    procedure SbGoAllSolutionClick(Sender: TObject);
    procedure SbGoStatistisClick(Sender: TObject);
    procedure SbLoadDependSystem4KritClick(Sender: TObject);
    procedure SbLoadFuzzySystemClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SbZeroModelClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure VivodGraphToMemo(Me:TMemo);

var
  FMain: TFMain;
  Excel: Variant;
  MaxKolSolutionInOgr:LongWord;
  TypeSystem:byte;
  Vivod:boolean;



implementation

{$R *.dfm}

uses UModelDepend,UAntGraph,UAnt,USolutionNew,UModelFuzzy, UAntFuzzy, UModelFuzzyExcel, UCPM;

procedure VDependSystem(Memo:TMemo);
var
  st:string;
  NomElement:LongWord;
begin
Memo.Lines.Add(DependSystem.Name);
St:='Флот (FL) - '+FloatToStr(DependSystem.FL);
Memo.Lines.Add(St);
St:='Годовой налет одного ВС (FHY) - '+FloatToStr(DependSystem.FHY);
Memo.Lines.Add(St);
St:='Количество полетных циклов (FCY) - '+FloatToStr(DependSystem.FCY);
Memo.Lines.Add(St);
St:='Число летных дней в году (FDY) - '+FloatToStr(DependSystem.FDY);
Memo.Lines.Add(St);
St:='Коэффициент наполнения основной базы (FR_Zad) - '+FloatToStr(DependSystem.Fr_zad);
Memo.Lines.Add(St);
For NomElement:=0 to Length(DependSystem.Element)-1 do
  begin
  Memo.Lines.Add('Элемент - '+DependSystem.Element[NomElement].Name);
  St:='Количество элементов на ВС (QPA) - '+FloatToStr(DependSystem.Element[NomElement].QPA);
  Memo.Lines.Add(St);
  St:='Коэффициент наработки компонента на ВС (OTR) - '+FloatToStr(DependSystem.Element[NomElement].OTR);
  Memo.Lines.Add(St);
  St:='Средняя наработка ЗЧ между заменами (MTBUR) - '+FloatToStr(DependSystem.Element[NomElement].MTBUR);
  Memo.Lines.Add(St);
  St:='Ремонтный цикл (RT) - '+FloatToStr(DependSystem.Element[NomElement].RT);
  Memo.Lines.Add(St);
  St:='Период обеспечения (PT) - '+FloatToStr(DependSystem.Element[NomElement].PT);
  Memo.Lines.Add(St);
  St:='Период экстренного обеспечения (EPT) - '+FloatToStr(DependSystem.Element[NomElement].EPT);
  Memo.Lines.Add(St);
  St:='Количество элементов на ВС (AD) - '+FloatToStr(DependSystem.Element[NomElement].AD);
  Memo.Lines.Add(St);
  St:='Количество элементов на ВС (CP) - '+FloatToStr(DependSystem.Element[NomElement].Cp);
  Memo.Lines.Add(St);
  St:='Количество элементов на ВС (D) - '+FloatToStr(DependSystem.Element[NomElement].D);
  Memo.Lines.Add(St);
  St:='Количество элементов на ВС (FR) - '+FloatToStr(DependSystem.Element[NomElement].FR);
  Memo.Lines.Add(St);
  St:='Количество элементов на ВС (DR) - '+FloatToStr(DependSystem.Element[NomElement].Dr);
  Memo.Lines.Add(St);
  St:='Количество элементов на ВС (RR) - '+FloatToStr(DependSystem.Element[NomElement].RR);
  Memo.Lines.Add(St);
  St:='Количество элементов в составе ЗИП (N) - '+FloatToStr(DependSystem.Element[NomElement].N);
  Memo.Lines.Add(St);
  St:='Время поставки ЗЧ - '+FloatToStr(DependSystem.Element[NomElement].TimeInstalation);
  Memo.Lines.Add(St);
  St:='Время производства партии ЗЧ - '+FloatToStr(DependSystem.Element[NomElement].TimeTransport);
  Memo.Lines.Add(St);
  St:='Объем партии ЗЧ - '+IntToStr(DependSystem.Element[NomElement].KolTransportationInThePart);
  Memo.Lines.Add(St);
  St:='Объем занимаемой складской площади для ЗЧ - '+FloatToStr(DependSystem.Element[NomElement].ValueSklad);
  Memo.Lines.Add(St);
  end;
end;

procedure LoadParAtForm;
var
  NomKrit:LongWord;
begin
with FMain do
begin
 Randomize;
If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Загрузка данных для ММК с формы');
SetLength(IspParArc,KolKrit);
SetLength(IspParNode,KolKrit);
SetLength(NPheromon,KolKrit);
SetLength(ParNaprKrit,KolKrit);
SetLength(ParKrit,KolKrit);
SetLength(ParKritEnd,KolKrit);
SetLength(ParKritMax,KolKrit);
For NomKrit:=0 to KolKrit-1 do
  begin
  ParKritMax[NomKrit]:=StrToFloat(SgAntPAr.Cells[6,NomKrit+1]);
  IspParArc[NomKrit]:=StrToFloat(SgAntPAr.Cells[5,NomKrit+1]);
  IspParNode[NomKrit]:=StrToFloat(SgAntPAr.Cells[4,NomKrit+1]);
  NPheromon[NomKrit]:=StrToFloat(SgAntPAr.Cells[3,NomKrit+1]);
  ParNaprKrit[NomKrit]:=StrToFloat(SgAntPAr.Cells[1,NomKrit+1]);
  ParKrit[NomKrit]:=StrToFloat(SgKrit.Cells[1,NomKrit+1]);
  ParKritEnd[NomKrit]:=StrToFloat(SgKritEnd.Cells[1,NomKrit+1]);
  end;
end;
end;

Procedure GoFuzzySetOnSolution(NomNewSolution:Longword);
var
NomElement:Longword;
begin
ClearAllTask;  //Очищаем все задачи от назначенных работников
For NomElement:=0 to length(ArraySolution[NomNewSolution].ElementArray)-1 do        //Назначаем работников на задачи в соответствии с выбранным решением
  AddPersonTask(StrToInt(ArraySolution[NomNewSolution].ElementArray[NomElement].Element),ArraySolution[NomNewSolution].ElementArray[NomElement].Value);
GoFuzzyTask; //Вычисляем нечеткие функции времени выполнения задач и проводим дефазификацию
end;

Procedure AddSolutionToGraph(NomSolution:longword);
var
NomElementSolution,NomKrit:Longword;
NodeElement:TAntNodeElement;
Node:TAntNodeKol;
begin
for NomElementSolution := 0 to Length(ArraySolution[NomSolution].ElementArray) do
  begin
  NodeElement:=SearchElementSklad(ArraySolution[NomSolution].ElementArray[NomElementSolution].Element);
  if NodeElement<>nil then
    Node:=NodeElement.SearchValueElement(ArraySolution[NomSolution].ElementArray[NomElementSolution].Value);
  if Node<>nil then
    For NomKrit:=0 to KolKrit-1 do
      Node.Pheromon[NomKrit]:=Node.Pheromon[NomKrit]+NPheromon[NomKrit]/(ArraySolution[NomSolution].Krit[NomKrit]/ParKritMax[NomKrit]+0.001)/2;
  end;
end;

procedure GoMMK(var NomIteration:LongWord; var ArrKritNode:TArrDouble; var KritEnd:double);
var
  NomAnt,KolAnt,NomKrit:LongWord;
  KolElement,NomElement:LongWord;
  NomNewSolution:Longword;
  NomParetoSet:LongWord;
  SearchSolutionWay:TArrayElementSolution;
  st:string;
  NewDependSystem:TDependSystem;
  KolPheromon:TArrDouble;
  MaxKolPheromon,MinKolPheromon:TArrDouble;
  KolSolutionBackIteration:Longword;
  MIterationKrit,MBackIterationKrit:TArrDouble;
  BBackNotChange:Boolean;

  MaxKrit,MinKrit:TArrDouble;
  Koef:Double;
  i:LongWord;
  BEnd,NewOptSolution:Boolean;
  BoolNewPareto:boolean;

Procedure GoExcelIteration;
var
MKrit:double;
NomParetoSet,NomElement,NomKrit,NomColExcel:Longword;
begin
Excel.Cells[NomIteration,1]:=NomIteration;
NomColExcel:=2;
Excel.Cells[NomIteration,NomColExcel]:=Length(ArraySolution);
inc(NomColExcel);

NomKrit:=0;
while NomKrit<KolKrit do
  begin
  Excel.Cells[NomIteration,NomColExcel]:=MIterationKrit[NomKrit];
  inc(NomColExcel);
  inc(NomKrit);
  end;

Excel.Cells[NomIteration,NomColExcel]:=Length(ParetoSet);
inc(NomColExcel);
st:='';
     NomParetoSet:=0;
while NomParetoSet<length(ParetoSet) do
  begin
  st:=st+IntToStr(ParetoSet[NomParetoSet])+' ';
  inc(NomParetoSet);
  end;
Excel.Cells[NomIteration,NomColExcel]:=st;
st:='';
NomParetoSet:=0;
while NomParetoSet<length(ParetoSet) do
  begin
  NomKrit:=0;
  while NomKrit<KolKrit do
    begin
    st:=st+FloatToStr(ArraySolution[ParetoSet[NomParetoSet]].Krit[NomKrit])+' ';
    inc(NomKrit);
    end;
    st:=st+';';
  inc(NomParetoSet);
  end;
Excel.Cells[NomIteration,NomColExcel]:=st;
inc(NomColExcel);
st:='';
NomParetoSet:=0;
while NomParetoSet<length(ParetoSet) do
  begin
  NomElement:=0;
  while NomElement<Length(ArraySolution[ParetoSet[NomParetoSet]].ElementArray) do
    begin
    st:=st+ArraySolution[ParetoSet[NomParetoSet]].ElementArray[NomElement].Element+'-'+IntToStr(ArraySolution[ParetoSet[NomParetoSet]].ElementArray[NomElement].Value)+' ';
    inc(NomElement);
    end;
  st:=st+' ; ';
  inc(NomParetoSet);
  end;
Excel.Cells[NomIteration,NomColExcel]:=st;
inc(NomColExcel);
Excel.Workbooks[1].Save;
end;

//Создаем новое решение
Procedure GoNewSolution(var NomNewSolution:Longword);
var
  KolArrSolution:longword;
  begin
  with FMain do
  begin

  if RgSolutionSetting.ItemIndex=0 then
    begin
    KolSolution:=Length(ArraySolution);
    NomNewSolution:=KolSolution;
    If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создается новое решение №'+IntToStr(NomNewSolution)+' для '+IntToStr(NomAnt)+' муравья');
    SetLength(ArraySolution,NomNewSolution+1);
    end
  else
    begin
    if RgSolutionSetting.ItemIndex=2 then
      begin
      if length(ArraySolution)<SeKolSolutionInGraph.value then
        begin
        KolArrSolution:=length(ArraySolution);
        SetLength(ArraySolution,KolArrSolution+1);
        NomNewSolution:=KolArrSolution;
        end
      else
        NomNewSolution:=SeKolSolutionInGraph.value-1;
      end
    else
      NomNewSolution:=1;
    inc(KolSolution);
    end;
  SetLength(ArraySolution[NomNewSolution].ElementArray,KolElement);
  NomElement:=0;
  While NomElement<KolElement do
    begin
    ArraySolution[NomNewSolution].ElementArray[NomElement].Element:=SearchSolutionWay[NomElement].Element;
    ArraySolution[NomNewSolution].ElementArray[NomElement].Value:=SearchSolutionWay[NomElement].Value;
    inc(NomElement);
    end;
  SetLength(SearchSolutionWay,0);  SearchSolutionWay:=nil;
  end;
  end;

 //Создание массива пройденных вершин (решения)
Procedure CreateSolutionWay;
  begin
  SetLength(SearchSolutionWay,KolElement);
  NomElement:=0;
  While NomElement<KolElement do
    begin
    SearchSolutionWay[NomElement].Element:=Ant[NomAnt].Way[NomElement].Element.Name;
    SearchSolutionWay[NomElement].Value:=Ant[NomAnt].Way[NomElement].Value;
    inc(NomElement);
    end;
  end;

//Вычисляем значение критериев нового решения
Procedure GoKritSolution(var NomNewSolution:Longword);
  begin
  Case TypeSystem of
  0: begin
     CopyDependSystem(NewDependSystem);
     NomElement:=0;
     While NomElement<KolElement do
       begin
       NewDependSystem.Element[NomElement].N:=ArraySolution[NomNewSolution].ElementArray[NomElement].Value;
       NewDependSystem.Element[NomElement].GoZnatToN;
       inc(NomElement);
       end;
     NewDependSystem.GoRROb;

     SetLength(ArraySolution[NomNewSolution].Krit,KolKrit);
     ArraySolution[NomNewSolution].Krit[0]:=NewDependSystem.RROb;
     ArraySolution[NomNewSolution].Krit[1]:=NewDependSystem.Cost;
     If Length(ArraySolution[NomNewSolution].Krit)>2 then
       ArraySolution[NomNewSolution].Krit[2]:=NewDependSystem.TimeWait;
     If Length(ArraySolution[NomNewSolution].Krit)>3 then
       ArraySolution[NomNewSolution].Krit[3]:=NewDependSystem.AllValueSklad;

     FreeAndNil(NewDependSystem);
     end;
  1: begin
     SetLength(ArraySolution[NomNewSolution].Krit,KolKrit);
     ArraySolution[NomNewSolution].Krit[0]:=0;
     GoFuzzySetOnSolution(NomNewSolution);          //Вычисляем значение критериев нового решения
     NomElement:=0;
     While NomElement<Length(ArrFuzzyTask) do
        begin
        ArraySolution[NomNewSolution].Krit[0]:=ArraySolution[NomNewSolution].Krit[0]+ArrFuzzyTask[NomElement].KritDefazification;
        inc(NomElement);
        end;

     end;
  255:begin
      SetLength(ArraySolution[NomNewSolution].Krit,KolKrit);
      ArraySolution[NomNewSolution].Krit[0]:=100;
      end;
  End;
  end;

//Вычисление количества феромона, заносимого на граф для определенного критерия
procedure GoKolPheromon(NomKrit:Longword);
begin
With FMain do
begin
Koef:=1;
case StrToInt(SgParKrit.Cells[1,NomKrit+1]) of         //Определение коэффициента для занечения феромона
  0:Koef:=1;
  1:if NomAnt=SortArrayAtn[NomKrit][0] then
      Koef:=StrToFloat(SgParKrit.Cells[2,NomKrit+1])
    else
      koef:=1;
        2:begin
          i:=0;
          while (i<Length(SortArrayAtn[NomKrit])) and (i<StrToFloat(SgParKrit.Cells[2,NomKrit+1])) and (SortArrayAtn[NomKrit][i]<>NomAnt) do
            Inc(i);
          if (i<>StrToFloat(SgParKrit.Cells[2,NomKrit+1])) and (SortArrayAtn[NomKrit][i]=NomAnt) then
            koef:=StrToFloat(SgParKrit.Cells[2,NomKrit+1])-i
          else
            koef:=1;
          end;
        end;
      case RgTypeNormKrit.ItemIndex of                      //Вычисление количества феромона, заносимого агентом
      0:begin
        if ParNaprKrit[NomKrit]=0 then
          KolPheromon[NomKrit]:=NPheromon[NomKrit]/(Ant[NomAnt].Krit[NomKrit]+0.001)*koef
        else
          KolPheromon[NomKrit]:=NPheromon[NomKrit]/(ParKritMax[NomKrit]-Ant[NomAnt].Krit[NomKrit]+0.001)*koef;
        end;
      1:begin
        if ParNaprKrit[NomKrit]=0 then
          KolPheromon[NomKrit]:=NPheromon[NomKrit]/(Ant[NomAnt].Krit[NomKrit]/ParKritMax[NomKrit]+0.001)*koef
        else
          KolPheromon[NomKrit]:=NPheromon[NomKrit]/((ParKritMax[NomKrit]-Ant[NomAnt].Krit[NomKrit])/ParKritMax[NomKrit]+0.001)*koef;
        end;

      2,3: begin
        if ParNaprKrit[NomKrit]=0 then
          KolPheromon[NomKrit]:=NPheromon[NomKrit]/((Ant[NomAnt].Krit[NomKrit]-MinKrit[NomKrit])/(MaxKrit[NomKrit]-MinKrit[NomKrit]+0.00001)+0.001)*koef
        else
          KolPheromon[NomKrit]:=NPheromon[NomKrit]/(ParKritMax[NomKrit]-(Ant[NomAnt].Krit[NomKrit]-MinKrit[NomKrit])/(MaxKrit[NomKrit]-MinKrit[NomKrit]+0.00001)+0.001)*koef;
        end;
        end;
      If RgPheromonQ.ItemIndex=1 then
        begin
        if MinKolPheromon[NomKrit]>KolPheromon[NomKrit] then
          MinKolPheromon[NomKrit]:=KolPheromon[NomKrit];
        if MaxKolPheromon[NomKrit]<KolPheromon[NomKrit] then
          MaxKolPheromon[NomKrit]:=KolPheromon[NomKrit];
        end;
      case RgPheromonQ.ItemIndex of           //Вычисление количества феромона, заносимого агентом
        1: begin
           KolPheromon[NomKrit]:=(KolPheromon[NomKrit]-MinKolPheromon[NomKrit])/(MaxKolPheromon[NomKrit]-MinKolPheromon[NomKrit]+0.00001)*StrToFloat(EdParNormPheromon.Text);
           end;
      end;
      St:=St+FloatToStr(Ant[NomAnt].Krit[NomKrit])+':'+FloatToStr(KolPheromon[NomKrit])+' ';
end;
end;

begin
with FMain do                                            //Определение количества элементов
begin
  Case TypeSystem of
    0: KolElement:=Length(DependSystem.Element);
    1: KolElement:=KolPerson;
  End;
NomIteration:=0;  KolSbrosAntGrap:=0;
KolSolutionBackIteration:=0;                                        //Задание начальных параметров
BEnd:=False;
SetLength(MIterationKrit,KolKrit);   SetLength(MBackIterationKrit,KolKrit);
SetLength(ArrKritNode,KolKrit);
If RgPheromonQ.ItemIndex=1 then
  begin
  SetLength(MaxKolPheromon,KolKrit);
  SetLength(MinKolPheromon,KolKrit);
  For NomKrit:=0 to KolKrit-1 do
    begin
    MaxKolPheromon[NomKrit]:=0;
    MinKolPheromon[NomKrit]:=10000000000000000;
    end;
  end;

if RgTypeNormKrit.ItemIndex=3 then
  begin
  SetLength(MaxKrit,KolKrit);
  SetLength(MinKrit,KolKrit);
  For NomKrit:=0 to KolKrit-1 do
    begin
    MaxKrit[NomKrit]:=0;
    MinKrit[NomKrit]:=10000000000000000;
    end;
  end;

KolAnt:=SeKolAnt.Value;
while not BEnd do                                        //Цикл по итерациям
  begin
  Inc(NomIteration);
  CreateAnt(KolAnt);                                     //Создание агентов
  AntGoGraph;                                            //Установка агентов в начальную вершину графа решений

  If Vivod then  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Итерация №'+IntToStr(NomIteration)+' Решений - '+IntToStr(length(ArraySolution))+' Сбросов - '+IntToStr(KolSbrosAntGrap));
  If CbAllGraph.Checked then VivodGraphToMemo(Memo1);

  if (RgKrit.ItemIndex>4) and (RgKrit.ItemIndex<=7) then
    GoKritAntGraph(RgKrit.ItemIndex-5,StrToFloat(LeParKolProhod.Text),ArrKritNode);

  st:='';
  if KolKrit<>0 then
  For NomKrit:=0 to KolKrit-1 do
    St:=st+FloatToStr(ArrKritNode[NomKrit])+';';
  If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Веса критериев '+st);

  if KolAnt<>0 then
  For NomAnt:=0 to KolAnt-1 do                         //Цикл по всем агентам
    begin
    If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Запуск муравья №'+IntToStr(NomAnt)+' на граф');

    While Length(Ant[NomAnt].Way)<KolElement do        //Цикл по пути агента
      AntGoNextNode(NomAnt,RgKrit.ItemIndex);        //Переход в следующую вершину

    If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Поиск решения для пути '+IntToStr(NomAnt)+' муравья');

    CreateSolutionWay;                                       //Создание массива пройденных вершин (решения)
    NomNewSolution:=ProcSearchSolution(SearchSolutionWay);   //Поиск решения среди уже вычесленных
   //  NomNewSolution:=64000;

    if NomNewSolution>=MaxInt then                        //Если такое решений не найдено
      begin
      GoNewSolution(NomNewSolution); //Создаем новое решение
      GoKritSolution(NomNewSolution); //Вычисляем значение критериев нового решения
      If RgSolutionSetting.ItemIndex=2 then
        SortAllSolution(0);
      AddAntSolutionToParetoSet(NomNewSolution,BoolNewPareto);                     //Добавление решения в множество Парето
      if (BoolNewPareto) and (RgKritOst.ItemIndex=2)  then
        MeStat.Lines.Add(IntToStr(NomIteration)+' Новое решение Парето: '+FloatToStr(ArraySolution[ParetoSet[0]].Krit[0]));
      If RgSolutionSetting.ItemIndex=1 then      //Не обязательно
        ParetoSetToFirstSolution(NomNewSolution);                //Решения из множества Парето в начало
      end
    else
      begin
      If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Для '+IntToStr(NomAnt)+' муравья выбрано решение №'+IntToStr(NomNewSolution));
      end;

    st:='';
    if KolKrit<>0 then                                       //Задаем параметры феромона для муравья в соответствии с найденным решением
    For NomKrit:=0 to KolKrit-1 do
      begin
      Ant[NomAnt].Krit[NomKrit]:=ArraySolution[NomNewSolution].Krit[NomKrit];
      st:=st+FloatToStr(Ant[NomAnt].Krit[NomKrit])+' ';
      end;
    If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Значения критериев '+st);

    end;
  SortAnt;                                                   //Сортировка муравьев

  If CbAllProt.Checked then
    begin
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Сортированные агенты');
    if KolKrit<>0 then
    For NomKrit:=0 to KolKrit-1 do
      begin
      st:='';
      For NomAnt:=0 to KolAnt-1 do
        st:=st+IntToStr(SortArrayAtn[NomKrit][NomAnt])+' ';
      MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+' '+st);
      end;
    end;

  if (RgTypeNormKrit.ItemIndex<>0) and (RgTypeNormKrit.ItemIndex<>1) then     //Вычисление лучшего агента
    begin
    if RgTypeNormKrit.ItemIndex=2 then
      begin
      SetLength(MaxKrit,KolKrit);
      SetLength(MinKrit,KolKrit);
      For NomKrit:=0 to KolKrit-1 do
        begin
        MaxKrit[NomKrit]:=0;
        MinKrit[NomKrit]:=10000000000000000;
        end;
      end;
    For NomAnt:=0 to KolAnt-1 do
      For NomKrit:=0 to KolKrit-1 do
        begin
        If Ant[NomAnt].Krit[NomKrit]>MaxKrit[NomKrit] then MaxKrit[NomKrit]:=Ant[NomAnt].Krit[NomKrit];
        If Ant[NomAnt].Krit[NomKrit]<MinKrit[NomKrit] then MinKrit[NomKrit]:=Ant[NomAnt].Krit[NomKrit];
        end;
    end;

  //Вычисление критерия за итерацию
  NomKrit:=0;
  while NomKrit<KolKrit do
    begin
    MIterationKrit[NomKrit]:=0;
    NomAnt:=0;
    while NomAnt<KolAnt do
      begin
      MIterationKrit[NomKrit]:=MIterationKrit[NomKrit]+Ant[NomAnt].Krit[NomKrit];
      inc(NomAnt);
      end;
    MIterationKrit[NomKrit]:=MIterationKrit[NomKrit]/KolAnt;
    inc(NomKrit);
    end;

  If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Занесение феромона на вершины графа');
  SetLength(KolPheromon,KolKrit);               //Занести феромон на граф
  if KolAnt<>0 then                            //Пройте по всем агентам
  For NomAnt:=0 to KolAnt-1 do
    begin

    st:='';
    if KolKrit<>0 then                         //Пройти по всем критериям
    For NomKrit:=0 to KolKrit-1 do
      begin
      GoKolPheromon(NomKrit);                  //Вычислить количество феромона
      end;
    If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Занесение феромона от муравья № '+IntToStr(NomAnt)+' - '+st);
    AntAddPheromonToGraph(NomAnt,KolPheromon);     //Занесение феромона на граф
    If CbAllGraph.Checked then Memo1.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Занесение феромона от муравья № '+IntToStr(NomAnt)+' - '+st);
    If CbAllGraph.Checked then VivodGraphToMemo(Memo1);
    end;
  SetLength(KolPheromon,0); KolPheromon:=nil;
  SetLength(MaxKrit,0); MaxKrit:=nil;
  SetLength(MinKrit,0); MinKrit:=nil;
  If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Испарение феромона с вершин графа');
  DecreasePheromonAllGraph(IspParArc,IspParNode);       //Испарение феромона

  If CbAllGraph.Checked then Memo1.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Испарение феромона с вершин графа');
  If CbAllGraph.Checked then VivodGraphToMemo(Memo1);


  If CbAllProt.Checked then
    begin
    st:='';
    IF Length(ParetoSet)<>0 then
    For NomParetoSet:=0 to Length(ParetoSet)-1 do
      st:=st+IntToStr(ParetoSet[NomParetoSet])+' ';
    MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Множество Парето '+St);
    end;

  if RgSolutionSetting.ItemIndex=0 then
    KolSolution:=Length(ArraySolution);
  //Проверка на зацикливание
  if Length(ArraySolution)<>0 then
  case RgZaciklivanie.ItemIndex of
    1:If KolSolutionBackIteration=KolSolution then
      begin
      if (RgKritOst.ItemIndex=2) then
      MeStat.Lines.Add(IntToStr(NomIteration)+' Сброс графа');
      ClearAllAntGraph;
      if RgSolutionSetting.ItemIndex=2 then
        for NomKrit := 0 to Length(ArraySolution)-2 do
          AddSolutionToGraph(NomKrit);
      end;
    2:begin
      BBackNotChange:=true;
      NomKrit:=0;
      while (NomKrit<KolKrit) and (BBackNotChange) do
        begin
        if MIterationKrit[NomKrit]<>MBackIterationKrit[NomKrit] then
          BBackNotChange:=false;
        inc(NomKrit);
        end;
      if BBackNotChange then
        begin
        if (RgKritOst.ItemIndex=2) then
        MeStat.Lines.Add(IntToStr(NomIteration)+' Сброс графа'+' Решение Парето: '+FloatToStr(ArraySolution[ParetoSet[0]].Krit[0])+' Критерий сброса '+FloatToStr(MIterationKrit[0]));
        ClearAllAntGraph;
        if RgSolutionSetting.ItemIndex=2 then
          for NomKrit := 0 to Length(ArraySolution)-2 do
            AddSolutionToGraph(NomKrit);
        end;
      NomKrit:=0;
      while (NomKrit<KolKrit)  do
        begin
        MBackIterationKrit[NomKrit]:=MIterationKrit[NomKrit];
        inc(NomKrit);
        end;
      end;
  end;
  KolSolutionBackIteration:=KolSolution;

  Case RgKritOst.ItemIndex of                         //Вычисление окончания прогонов
    0: BEnd:=SeKolIterationEnd.Value=NomIteration;
    1,2: begin
       BEnd:=false;
       NomParetoSet:=0;
       while (NomParetoSet<=Length(ParetoSet)-1) and (not BEnd) do
         begin
         BEnd:=True;
         For NomKrit:=0 to KolKrit-1 do
           begin
           If ParNaprKrit[NomKrit]=0 then   //min
             begin
             if ParKritEnd[NomKrit]<=ArraySolution[ParetoSet[NomParetoSet]].Krit[NomKrit] then
               BEnd:=False;
             end
           else
             begin
             if ParKritEnd[NomKrit]>=ArraySolution[ParetoSet[NomParetoSet]].Krit[NomKrit] then
               BEnd:=False;
             end;
           end;
         inc(NomParetoSet);
         end;
       if (RgKritOst.ItemIndex=2) and (bEnd) then
         begin
         BEnd:=False;
         //Изменить критерий
         st:=' Новые значения критерев: ';
         For NomKrit:=0 to KolKrit-1 do
           begin
           If ParNaprKrit[NomKrit]=0 then   //min
             ParKritEnd[NomKrit]:=ArraySolution[ParetoSet[NomParetoSet-1]].Krit[NomKrit]-0.01
           else
             ParKritEnd[NomKrit]:=ArraySolution[ParetoSet[NomParetoSet-1]].Krit[NomKrit]+0.01;
           st:=st+FloatToStr(ParKritEnd[NomKrit])+', ';
           end;
         MeStat.Lines.Add(IntToStr(NomIteration)+st);
         end;
       end;
    end;


  if CbExcelIter.Checked then    GoExcelIteration;

  IF (RgKritOst.ItemIndex=1) and (SeKritKolIteration.Value<=NomIteration) then
    BEnd:=True;
  if KolAnt<>0 then                            //Обнуление параметров
  For NomAnt:=0 to KolAnt-1 do
    DestroyAnt(NomAnt);
  SetLength(Ant,0);  Ant:=nil;
  if KolKrit<>0 then
  For NomKrit:=0 to KolKrit-1 do
    begin
    SetLength(SortArrayAtn[NomKrit],0); SortArrayAtn[NomKrit]:=nil;
    end;
  SetLength(SortArrayAtn,0); SortArrayAtn:=nil;
  end;
//DestroyAntNode;
end;
KritEnd:=Length(ArraySolution);
end;

procedure TFMain.SeKolKritChange(Sender: TObject);
var
  i:LongWord;
begin
KolKrit:=SeKolKrit.Value;
SgKrit.RowCount:=SeKolKrit.Value+1;
SgKritEnd.RowCount:=SeKolKrit.Value+1;
SgAntPAr.RowCount:=SeKolKrit.Value+1;
SgStatisticsKon.RowCount:=SeKolKrit.Value+1;
SgStatisticsNat.RowCount:=SeKolKrit.Value+1;
SgStatisticsShag.RowCount:=SeKolKrit.Value+1;
SgParKrit.RowCount:=SeKolKrit.Value+1;
For i:=1 to SeKolKrit.Value+1 do
  begin
  SgKrit.Cells[0,i]:='Крит. '+IntToStr(i);
  SgKritEnd.Cells[0,i]:='Крит. '+IntToStr(i);
  SgAntPAr.Cells[0,i]:='Крит. '+IntToStr(i);
  SgStatisticsKon.Cells[0,i]:='Крит. '+IntToStr(i);
  SgStatisticsNat.Cells[0,i]:='Крит. '+IntToStr(i);
  SgStatisticsShag.Cells[0,i]:='Крит. '+IntToStr(i);
  SgParKrit.Cells[0,i]:='Крит. '+IntToStr(i);
  end;
end;


procedure TFMain.FormActivate(Sender: TObject);
begin
Vivod:=true;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
KolKrit:=2;
SgKrit.Cells[0,0]:='Крит. №';
SgKrit.Cells[1,0]:='Вес';
SgAntPAr.Cells[0,0]:='Крит. №';
SgAntPAr.Cells[1,0]:='Тип';
SgAntPAr.Cells[2,0]:='Нач. зн';
SgAntPAr.Cells[3,0]:='Q';
SgAntPAr.Cells[4,0]:='p вер.';
SgAntPAr.Cells[5,0]:='p дуга';
SgAntPAr.Cells[6,0]:='Макс.';
SgKritEnd.Cells[0,0]:='Крит. №';
SgKritEnd.Cells[1,0]:='Огран.';
SgParKrit.Cells[0,0]:='Крит. №';
SgParKrit.Cells[1,0]:='Тип';
SgParKrit.Cells[2,0]:='Парам.';
end;

procedure VivodGraphToMemo(Me:TMemo);
var
  CurrentElement:TAntNodeElement;
  CurrentKol:TAntNodeKol;
  NomKol,MaxKol,CurrentMaxCol,NomKrit:LongWord;
  St:string;
begin
CurrentElement:=FirstNodeAntGraph;
MaxKol:=0;
While CurrentElement<>nil do
  begin
  CurrentMaxCol:=0;
  CurrentKol:=CurrentElement.Kol;
  while CurrentKol<>nil do
    begin
    Inc(CurrentMaxCol);
    CurrentKol:=CurrentKol.NextKol;
    end;
  If CurrentMaxCol>=MaxKol then
    MaxKol:=CurrentMaxCol;
  CurrentElement:=CurrentElement.NextElement;
  end;

for CurrentMaxCol:=1 to MaxKol do
  begin
  CurrentElement:=FirstNodeAntGraph;
  st:='';
  While CurrentElement<>nil do
    begin
    CurrentKol:=CurrentElement.Kol;
    NomKol:=1;
    While (CurrentKol<>nil) and (NomKol<CurrentMaxCol) do
      begin
      CurrentKol:=CurrentKol.NextKol;
      Inc(NomKol);
      end;
    if CurrentKol<>nil then
      begin
      st:=st+FormatFloat('00',CurrentKol.Value)+'(';
      For NomKrit:=0 to KolKrit-1 do
        st:=st+FormatFloat('0000.00',CurrentKol.Pheromon[NomKrit])+';';
      st:=st+')(';
      For NomKrit:=0 to KolKrit-1 do
        st:=st+FormatFloat('0.00',CurrentKol.Krit[NomKrit])+';';
      st:=st+')(';
      st:=st+FormatFloat('000',CurrentKol.KolAntGo);
      st:=st+') ';
      end
    else
      st:=st+'_________________________________';
    CurrentElement:=CurrentElement.NextElement;
    end;
  Me.Lines.Add(st);
  end;

end;

procedure TFMain.TCTypeChange(Sender: TObject);
begin
PnAntGraph.Visible:=TCType.TabIndex=0;
PnPareto.Visible:=TCType.TabIndex=1;
PnStat.Visible:=TCType.TabIndex=1;
end;

procedure TFMain.BtInsertSettingClick(Sender: TObject);
var
  NomKrit,i:LongWord;
begin
For NomKrit:=0 to KolKrit do
    For i:=0 to 6 do
      begin
      SgStatisticsNat.Cells[i,NomKrit]:=SgAntPAr.Cells[i,NomKrit];
      SgStatisticsKon.Cells[i,NomKrit]:=SgAntPAr.Cells[i,NomKrit];
      end;
For i:=0 to 6 do
  SgStatisticsShag.Cells[i,0]:=SgAntPAr.Cells[i,0];
For NomKrit:=0 to KolKrit do
    For i:=1 to 6 do
      SgStatisticsShag.Cells[i,NomKrit+1]:='1';
end;

procedure TFMain.SbGoAntClick(Sender: TObject);
var
  KolIteration:LongWord;
  ArrKritNode:TArrDouble;
  KritEnd:Double;
begin
if CbExcelIter.Checked then
  begin
  Excel := CreateOleObject('Excel.Application');
  Excel.Visible := false;
  Excel.Workbooks.open('Итерация.xlsx')
  end;

LoadParAtForm;
GoMMK(KolIteration,ArrKritNode,KritEnd);

if CbExcelIter.Checked then
  begin
  Excel.Workbooks[1].Save;
  Excel.Workbooks.Close;
  Excel.Quit;
  Excel := Unassigned;
  end;
end;

procedure TFMain.SpeedButton1Click(Sender: TObject);
var
KolSolution,NomElement,KolElement,NomMaxEndElement,NomParetoSolution:Longword;
ValueElement:Array of Longword;
GoNext:Boolean;
st:string;
NewSolution,ParetoSolution:TSolution;
begin
Case TypeSystem of
    0: KolElement:=Length(DependSystem.Element);
    1: KolElement:=KolPerson;
  End;
SetLength(ValueElement,KolElement);
NomElement:=0;
while NomElement<KolElement do
  begin
  ValueElement[NomElement]:=0;
  inc(NomElement);
  end;
KolSolution:=0;

//Определить момент остановки
NomMaxEndElement:=ArrElementGraph[KolElement-1].KolElement+1;
While ValueElement[KolElement-1]<NomMaxEndElement do //Цикл
  begin
  //Создаем новое решение
  SetLength(NewSolution.ElementArray,KolElement);
  NomElement:=0;
  st:='';
  While NomElement<KolElement do
    begin
    st:=st+' '+IntToStr(ValueElement[NomElement]);
    NewSolution.ElementArray[NomElement].Element:=ArrElementGraph[ValueElement[NomElement]].Name;
    NewSolution.ElementArray[NomElement].Value:=ValueElement[NomElement];
    inc(NomElement);
    end;

  //Вычисляем значение критериев нового решения
  Case TypeSystem of
  1: begin
     ClearAllTask;  //Очищаем все задачи от назначенных работников
     SetLength(NewSolution.Krit,KolKrit);
     For NomElement:=0 to length(NewSolution.ElementArray)-1 do        //Назначаем работников на задачи в соответствии с выбранным решением
       AddPersonTask(StrToInt(NewSolution.ElementArray[NomElement].Element),NewSolution.ElementArray[NomElement].Value);
       GoFuzzyTask; //Вычисляем нечеткие функции времени выполнения задач и проводим дефазификацию
       NewSolution.Krit[0]:=0; //Вычисление обобщенного критерия
     if Length(ArrFuzzyTask)<>0 then
     For NomElement:=0 to Length(ArrFuzzyTask)-1 do
       begin
       NewSolution.Krit[0]:=NewSolution.Krit[0]+ArrFuzzyTask[NomElement].KritDefazification;
       end;
     end;
  End;
  If (KolSolution=0) or (NewSolution.Krit[0]<ParetoSolution.Krit[0]) then  //Вычисляем множество Парето
    begin
    ParetoSolution:=NewSolution;
    NomParetoSolution:=KolSolution;
    Memo1.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Новое решение Парето № '+IntToStr(KolSolution)+':'+FloatToStr(NewSolution.Krit[0])+'-'+st);
    end;

  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Решение № '+IntToStr(KolSolution)+':'+FloatToStr(NewSolution.Krit[0])+'-'+st);
  //Изменяем одну вершину из графа решений
  GoNext:=false;
  NomElement:=0;
  repeat
  If NomElement<KolElement then
  begin
  Inc(ValueElement[NomElement]);
  GoNext:=ValueElement[NomElement]<ArrElementGraph[NomElement].KolElement;
  if not GoNext then
    begin
    ValueElement[NomElement]:=0;
    Inc(NomElement);
    end;
  end
  else
    begin
    GoNext:=true;
    ValueElement[KolElement-1]:=NomMaxEndElement
    end;
  until GoNext;
  inc(KolSolution);
  end;
end;


procedure TFMain.SpeedButton2Click(Sender: TObject);
begin
if OdLoad.Execute then
  begin
  LoadCPMAtExcel(OdLoad.FileName);
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Загружены работы из фалйа '+OdLoad.FileName);
  end;
if OdLoad.Execute then
  begin
  LoadCPMPersonAtExcel(OdLoad.FileName);
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Загружены назначения из файла '+OdLoad.FileName);
  end;
GoCPM(StrToDateTime('01.10.2019'));
end;

procedure TFMain.SbClearAntGraphClick(Sender: TObject);
begin
ClearAllAntGraph;
end;

procedure TFMain.SbSaveSettingClick(Sender: TObject);
var
  f:TextFile;
  NomKrit,i:LongWord;
begin
If SdSave.Execute then
  begin
  AssignFile(f,SdSave.FileName);
  Rewrite(f);
  Writeln(f,'Сохраненные настройки программы СППР ММК от '+FormatDateTime('yyyy/mm/dd hh:nn:ss - zzz', Now));
  Writeln(f,IntToStr(KolKrit));
  Writeln(f,IntToStr(RgKrit.ItemIndex));
  For NomKrit:=0 to KolKrit-1 do
    Writeln(f,SgKrit.Cells[1,NomKrit+1]);
  Writeln(f,IntTostr(SeKolAnt.Value));
  For NomKrit:=0 to KolKrit-1 do
    For i:=1 to 6 do
      Writeln(f,SgAntPAr.Cells[i,NomKrit+1]);
  For NomKrit:=0 to KolKrit-1 do
    For i:=1 to 2 do
      Writeln(f,SgParKrit.Cells[i,NomKrit+1]);
  Writeln(f,IntTostr(RgKritOst.ItemIndex));
  Writeln(f,IntTostr(SeKolIterationEnd.Value));
  Writeln(f,LeParKolProhod.text);
  Writeln(f,IntTostr(RgNatFer.ItemIndex));
  Writeln(f,IntTostr(RgTypeNormKrit.ItemIndex));
  Writeln(f,IntTostr(RgZaciklivanie.ItemIndex));    //Нет в DependSystem


  For NomKrit:=0 to KolKrit-1 do
    Writeln(f,SgKritEnd.Cells[1,NomKrit+1]);
  CloseFile(f);
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Настройки сохранены в файл '+SdSave.FileName);
  end;

end;

procedure TFMain.SbLoadSettingClick(Sender: TObject);
var
  f:TextFile;
  NomKrit,i:LongWord;
  st:string;
begin
If OdLoad.Execute then
  begin
  AssignFile(f,OdLoad.FileName);
  Reset(f);
  Readln(f,st);
  Readln(f,st);
  KolKrit:=StrToInt(st);
  SeKolKrit.Value:=KolKrit;
  Readln(f,st);
  RgKrit.ItemIndex:=StrToInt(st);

  if KolKrit<>0 then
  For NomKrit:=0 to KolKrit-1 do
    begin
    Readln(f,st);
    SgKrit.Cells[1,NomKrit+1]:=st;
    end;

  Readln(f,st);
  SeKolAnt.Value:=StrToInt(st);

  if KolKrit<>0 then
  For NomKrit:=0 to KolKrit-1 do
    For i:=1 to 6 do
      begin
      Readln(f,st);
      SgAntPAr.Cells[i,NomKrit+1]:=st;
      end;

  if KolKrit<>0 then
  For NomKrit:=0 to KolKrit-1 do
    For i:=1 to 2 do
      begin
      Readln(f,st);
      SgParKrit.Cells[i,NomKrit+1]:=st;
      end;

  Readln(f,st);
  RgKritOst.ItemIndex:=StrToInt(st);
  Readln(f,st);
  SeKolIterationEnd.Value:=StrToInt(st);
  Readln(f,st);
  LeParKolProhod.text:=st;
  Readln(f,st);
  RgNatFer.ItemIndex:=StrToInt(st);
  Readln(f,st);
  RgTypeNormKrit.ItemIndex:=StrToInt(st);
  Readln(f,st);
  RgZaciklivanie.ItemIndex:=StrToInt(st);

  if KolKrit<>0 then
  For NomKrit:=0 to KolKrit-1 do
    begin
    Readln(f,st);
    SgKritEnd.Cells[1,NomKrit+1]:=st;
    end;

  CloseFile(f);
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Настройки загружены из файла '+SdSave.FileName);
  end;
  SeKolKrit.OnChange(self);
end;

procedure TFMain.SbVivodParetoSetClick(Sender: TObject);
var
  NomParetoSet,NomElement,NomKrit,NomSolution:Longword;
  MinKrit,MaxKrit,ShagKrit:array [0..1] of double;
  st:string;
  x,y:LongWord;
begin
MeProt.Lines.Add('Множество Парето');
SortParetoSet(0);
For NomParetoSet:=0 to Length(ParetoSet)-1 do
  begin
  MeProt.Lines.Add('Решение №'+IntToStr(ParetoSet[NomParetoSet]));
  St:='';
  for NomElement:=0 to Length(ArraySolution[ParetoSet[NomParetoSet]].ElementArray)-1 do
    st:=st+ArraySolution[ParetoSet[NomParetoSet]].ElementArray[NomElement].Element+' '+IntTostr(ArraySolution[ParetoSet[NomParetoSet]].ElementArray[NomElement].Value)+'; ';
  MeProt.Lines.Add('Состав - '+st);
  St:='';
  for NomKrit:=0 to KolKrit-1 do
    st:=st+FloatToStr(ArraySolution[ParetoSet[NomParetoSet]].Krit[NomKrit])+'; ';
  MeProt.Lines.Add('Значения критериев - '+st);
  end;
If KolKrit=2 then
begin
MinKrit[0]:=10000000000000;
MinKrit[1]:=10000000000000;
For NomSolution:=0 to Length(ArraySolution)-1 do
  For NomKrit:=0 to KolKrit do
    begin
    if ArraySolution[NomSolution].Krit[NomKrit]>MaxKrit[NomKrit] then
      MaxKrit[NomKrit]:=ArraySolution[NomSolution].Krit[NomKrit];
    if ArraySolution[NomSolution].Krit[NomKrit]<MinKrit[NomKrit] then
      MinKrit[NomKrit]:=ArraySolution[NomSolution].Krit[NomKrit];
    end;
ShagKrit[0]:=(PbPareto.Height-20)/(MaxKrit[0]-MinKrit[0]);
ShagKrit[1]:=(PbPareto.Width-20)/(MaxKrit[1]-MinKrit[1]);

PbPareto.Canvas.FillRect(Rect(0, 0, PbPareto.Width, PbPareto.Height));
PbPareto.Canvas.MoveTo(10,10);
PbPareto.Canvas.LineTo(PbPareto.Width-5,10);
PbPareto.Canvas.MoveTo(PbPareto.Width-10,5);
PbPareto.Canvas.LineTo(PbPareto.Width-10,PbPareto.Height-5);

For NomSolution:=0 to Length(ArraySolution)-1 do
  begin
  x:=Trunc(ArraySolution[NomSolution].Krit[0]*ShagKrit[0]);
  y:=Trunc(ArraySolution[NomSolution].Krit[1]*ShagKrit[1]);
  x:=x+10-Trunc(MinKrit[0]*ShagKrit[0]);
  y:=y+10-Trunc(MinKrit[1]*ShagKrit[0]);

  PbPareto.Canvas.Ellipse(x-5,y-5,x+5,y+5);
  end;


end;
end;

procedure TFMain.SbCreateAntGraphClick(Sender: TObject);
var
  KolElement,NomElement,n,NomKrit:LongWord;
  NatPheromon,CurrentNatPheromon:TArrDouble;
  CurrentRR,MinRR,MaxRR:Double;
begin
LoadParAtForm;
KolKrit:=SeKolKrit.Value;
KolElement:=Length(DependSystem.Element);
SetLength(NatPheromon,KolKrit);
SetLength(CurrentNatPheromon,KolKrit);
SetLength(NatKolPheromon,KolKrit);
For NomKrit:=0 to KolKrit-1 do
  begin
  NatPheromon[NomKrit]:=StrToFloat(SgAntPAr.Cells[2,NomKrit+1]);
  NatKolPheromon[NomKrit]:=NatPheromon[NomKrit];
  end;
For NomElement:=0 to KolElement-1 do
  begin
  DependSystem.Element[NomElement].GoZnat;
  MinRR:=100000000000000000;
  MaxRR:=0;
  if RgNatFer.ItemIndex=1 then
  begin
  for n:=0 to DependSystem.Element[NomElement].N do
    begin
    CurrentRR:=GoRRToN(DependSystem.Element[NomElement].D,DependSystem.Element[NomElement].AD,DependSystem.FDY,DependSystem.Element[NomElement].EPT,n);
    If CurrentRR>MaxRR then MaxRR:=CurrentRR;
    If CurrentRR<MinRR then MinRR:=CurrentRR;
    end;
  for n:=0 to DependSystem.Element[NomElement].N do
    begin
    CurrentRR:=GoRRToN(DependSystem.Element[NomElement].D,DependSystem.Element[NomElement].AD,DependSystem.FDY,DependSystem.Element[NomElement].EPT,n);
    For NomKrit:=0 to KolKrit-1 do
      if ParNaprKrit[NomKrit]=1 then
        CurrentNatPheromon[NomKrit]:=NatPheromon[NomKrit]*(CurrentRR-MinRR)/(MaxRR-MinRR+0.0000001)
      else
        CurrentNatPheromon[NomKrit]:=NatPheromon[NomKrit]*(MaxRR-CurrentRR)/(MaxRR-MinRR+0.0000001);
    AddNodeAnt(DependSystem.Element[NomElement].Name,n,CurrentNatPheromon);
    end;
  end
  else
  for n:=0 to DependSystem.Element[NomElement].N do
    AddNodeAnt(DependSystem.Element[NomElement].Name,n,NatPheromon);
  end;
VDependSystem(MeProt);
DependSystem.GoRROb;
AddAllAntArc;
CreateAntNode;                                            //Создание начальной вершины графа решений
SetLength(NatPheromon,0);      NatPheromon:=nil;
SetLength(CurrentNatPheromon,0); CurrentNatPheromon:=nil;
end;

procedure TFMain.SbSaveParetoSetClick(Sender: TObject);
var
  NomPareto,KolParetoSet,NomKrit,NomElement:LongWord;
  f:TextFile;
  NomRow,NomCol:Longword;
begin
If SdSave.Execute then
begin
case TypeSystem of
  0:begin
  AssignFile(f,SdSave.FileName);
  Rewrite(f);
  Writeln(f,DependSystem.Name);
  KolParetoSet:=Length(ParetoSet);
  Writeln(f,IntToStr(KolParetoSet));
  For NomPareto:=0 to KolParetoSet-1 do
    begin
    For NomElement:=0 to Length(ArraySolution[ParetoSet[NomPareto]].ElementArray)-1 do
      begin
      Writeln(f,ArraySolution[ParetoSet[NomPareto]].ElementArray[NomElement].Element);
      Writeln(f,IntToStr(ArraySolution[ParetoSet[NomPareto]].ElementArray[NomElement].Value));
      end;
    For NomKrit:=0 to KolKrit-1 do
      Writeln(f,FloatToStr(ArraySolution[ParetoSet[NomPareto]].Krit[NomKrit]))
    end;
  CloseFile(f);
  end;
  1:begin
  NomRow:=1;
  NomCol:=1;
  OpenExcelPersonFuzzySet;
  KolParetoSet:=Length(ParetoSet);
  For NomPareto:=0 to KolParetoSet-1 do
    begin
    GoFuzzySetOnSolution(ParetoSet[NomPareto]);
    AddExcelTaskFuzzySet(NomRow,NomCol,0);
    NomRow:=1;
    NomCol:=NomCol+5;
    end;
  CloseExcelPersonFuzzySet(SdSave.FileName);
  end;
end;
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Множество Парето сохранено в файле '+SdSave.FileName);
end;
end;

procedure TFMain.SbLoadDependSystemClick(Sender: TObject);
begin
if OdLoad.Execute then
  begin
  TypeSystem:=0;
  DependSystem:=TDependSystem.Create;
  LoadDependSystemOnTextFile(OdLoad.FileName);
  VDependSystem(MeProt);
  end;
end;

procedure TFMain.SbZeroModelClick(Sender: TObject);
begin
TypeSystem:=255;
KolKrit:=1;
CreateZeroGraph;
CreateAntNode;
end;


procedure TFMain.SbLoadFuzzySystemClick(Sender: TObject);
var NomRow,NomCol:Longword;
begin
if OdLoad.Execute then
  begin
  TypeSystem:=1;
  LoadFuzzyElTextFile(OdLoad.FileName);
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Нечеткие множества загружены из файла '+OdLoad.FileName);
  CreateSetting;
  If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Вычисленны нечеткие функции производительности работников');
  GoStartFuzzy;
  CreateAntGraphAtFuzzyModel;
  If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создан граф решений');
  end;
end;

procedure TFMain.SbLoadParetoSetClick(Sender: TObject);
var
  NomPareto,KolParetoSet,NomKrit,NomElement:LongWord;
  f:TextFile;
  st:string;
begin
If OdLoad.Execute then
  begin
  AssignFile(f,OdLoad.FileName);
  Reset(f);
  Readln(f,st);
  If DependSystem.Name=St then
    begin
    Readln(f,st);
    KolParetoSet:=StrToInt(st);
    SetLength(ParetoSet,KolParetoSet);

    For NomPareto:=0 to KolParetoSet-1 do
      begin


      end;
    // NomNewSolution:=ProcSearchSolution(SearchSolutionWay);
    {
    if NomNewSolution>60000 then
      begin
      KolSolution:=Length(ArraySolution);
      NomNewSolution:=KolSolution;
      If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Создается новое решение №'+IntToStr(NomNewSolution)+' для '+IntToStr(NomAnt)+' муравья');
      SetLength(ArraySolution,NomNewSolution+1);
      SetLength(ArraySolution[NomNewSolution].ElementArray,KolElement);
      For NomElement:=0 to KolElement-1 do
        begin
        ArraySolution[NomNewSolution].ElementArray[NomElement].Element:=SearchSolutionWay[NomElement].Element;
        ArraySolution[NomNewSolution].ElementArray[NomElement].Value:=SearchSolutionWay[NomElement].Value;
        end;

      CopyDependSystem(NewDependSystem);
      For NomElement:=0 to KolElement-1 do
        begin
        NewDependSystem.Element[NomElement].N:=SearchSolutionWay[NomElement].Value;
        NewDependSystem.Element[NomElement].GoZnatToN;
        end;
      NewDependSystem.GoRROb;

      SetLength(ArraySolution[NomNewSolution].Krit,KolKrit);
      ArraySolution[NomNewSolution].Krit[0]:=NewDependSystem.RROb;
      ArraySolution[NomNewSolution].Krit[1]:=NewDependSystem.Cost;

      end
    else
      begin
      If CbAllProt.Checked then MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Для '+IntToStr(NomAnt)+' муравья выбрано решение №'+IntToStr(NomNewSolution));
      end;

    begin
      For NomElement:=0 to Length(ArraySolution[ParetoSet[NomPareto]].ElementArray)-1 do
        begin
        Writeln(f,ArraySolution[ParetoSet[NomPareto]].ElementArray[NomElement].Element);
        Writeln(f,IntToStr(ArraySolution[ParetoSet[NomPareto]].ElementArray[NomElement].Value));
        end;
      For NomKrit:=0 to KolKrit-1 do
        Writeln(f,FloatToStr(ArraySolution[ParetoSet[NomPareto]].Krit[NomKrit]))}
    //  end;
    end
  else
    ShowMessage('Имя системы не совпадает с именем множества Парето');
  CloseFile(f);
  end;
end;

procedure TFMain.SbGoAllSolutionClick(Sender: TObject);
var
  NomElement,NomSolution,NomKrit,KolElement:LongWord;
  BEndSearch,BAllOgr:Boolean;
  NewDependSystem:TDependSystem;
  st:string;
    MaxKolSolutionInOgrArr:TArrDouble;
begin
LoadParAtForm;
NomSolution:=0;
MaxKolSolutionInOgr:=0;
SetLength(MaxKolSolutionInOgrArr,KolKrit);
For NomKrit:=0 to KolKrit-1 do
  MaxKolSolutionInOgrArr[NomKrit]:=0;
BEndSearch:=False;
While not BEndSearch do
  begin
  KolElement:=Length(DependSystem.Element);
  SetLength(ArraySolution,NomSolution+1);
  SetLength(ArraySolution[NomSolution].ElementArray,KolElement);
  SetLength(ArraySolution[NomSolution].Krit,KolKrit);

  For NomElement:=0 to KolElement-1 do
    begin
    ArraySolution[NomSolution].ElementArray[NomElement].Element:=DependSystem.Element[NomElement].Name;
    IF NomSolution=0 then
      ArraySolution[NomSolution].ElementArray[NomElement].Value:=0
    else
      if NomElement=0 then
        ArraySolution[NomSolution].ElementArray[NomElement].Value:=ArraySolution[NomSolution-1].ElementArray[NomElement].Value+1
      else
        ArraySolution[NomSolution].ElementArray[NomElement].Value:=ArraySolution[NomSolution-1].ElementArray[NomElement].Value;
    end;
  For NomElement:=0 to KolElement-1 do
    begin
    If ArraySolution[NomSolution].ElementArray[NomElement].Value>DependSystem.Element[NomElement].N then
      begin
      ArraySolution[NomSolution].ElementArray[NomElement].Value:=0;
      If NomElement<>KolElement-1 then
        ArraySolution[NomSolution].ElementArray[NomElement+1].Value:=ArraySolution[NomSolution].ElementArray[NomElement+1].Value+1
      else
        BEndSearch:=True;
      end;
    end;

  st:='';
  For NomElement:=0 to KolElement-1 do
    st:=st+IntToStr(ArraySolution[NomSolution].ElementArray[NomElement].Value)+' ; ';
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Рассматривается решение: '+st);

  If not BEndSearch then
  begin
  CopyDependSystem(NewDependSystem);
  For NomElement:=0 to KolElement-1 do
    begin
    NewDependSystem.Element[NomElement].N:=ArraySolution[NomSolution].ElementArray[NomElement].Value;
    NewDependSystem.Element[NomElement].GoZnatToN;
    end;
  NewDependSystem.GoRROb;

  SetLength(ArraySolution[NomSolution].Krit,KolKrit);
  ArraySolution[NomSolution].Krit[0]:=NewDependSystem.RROb;
  ArraySolution[NomSolution].Krit[1]:=NewDependSystem.Cost;
  if Length(ArraySolution[NomSolution].Krit)>2 then
    ArraySolution[NomSolution].Krit[2]:=NewDependSystem.TimeWait;
  If Length(ArraySolution[NomSolution].Krit)>3 then
    ArraySolution[NomSolution].Krit[3]:=NewDependSystem.AllValueSklad;

  BAllOgr:=True;
  For NomKrit:=0 to KolKrit-1 do
    If not (((ParNaprKrit[NomKrit]=1) and (ArraySolution[NomSolution].Krit[NomKrit]>ParKritEnd[NomKrit])) or ((ParNaprKrit[NomKrit]=0) and (ArraySolution[NomSolution].Krit[NomKrit]<ParKritEnd[NomKrit]))) then
      BAllOgr:=False;
  If BAllOgr then
    Inc(MaxKolSolutionInOgr);
  For NomKrit:=0 to KolKrit-1 do
    If ((ParNaprKrit[NomKrit]=1) and (ArraySolution[NomSolution].Krit[NomKrit]>ParKritEnd[NomKrit])) or ((ParNaprKrit[NomKrit]=0) and (ArraySolution[NomSolution].Krit[NomKrit]<ParKritEnd[NomKrit])) then
      MaxKolSolutionInOgrArr[NomKrit]:=MaxKolSolutionInOgrArr[NomKrit]+1;

  inc(NomSolution);
  FreeAndNil(NewDependSystem);
  end;
  end;
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Всего решений - '+IntToStr(NomSolution));
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Всего решений, удовлетворяющих ограничениям - '+IntToStr(MaxKolSolutionInOgr));
st:='';
For NomKrit:=0 to KolKrit-1 do
  st:=st+FloatToStr(MaxKolSolutionInOgrArr[NomKrit])+' ';
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Всего решений, удовлетворяющих каждому ограничению - '+st);
AddSolutionToParetoSet;
  st:='';
  For NomElement:=0 to Length(ParetoSet)-1 do
    st:=st+IntToStr(ParetoSet[NomElement])+' ';
  MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Множество Парето '+St);
end;

procedure TFMain.BtGoStatisticsClick(Sender: TObject);
var
  NomProgon,KolIteration,KolProgon,KolCircleIteration,NomSolution:LongWord;
  MIteration,La2Iteration,DIteration:double;
  NomKrit,i:LongWord;
  BEndProgon:Boolean;
  NomExcel:LongWord;
  TimeStart,TimeStop,MTime:TDateTime;
  ArrKritNode:TArrDouble;
  KritEnd:Double;
begin
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Старт сбора статистики ');
For NomKrit:=0 to KolKrit do
    For i:=1 to 6 do
      SgAntPAr.Cells[i,NomKrit+1]:=SgStatisticsNat.Cells[i,NomKrit+1];
Excel := CreateOleObject('Excel.Application');
Excel.Workbooks.add;
BEndProgon:=False;
NomExcel:=1;
While not BEndProgon do
  begin
  inc(NomExcel);
  LoadParAtForm;
  MIteration:=0;
  La2Iteration:=0;
  KolProgon:=0;
  KolCircleIteration:=0;
  for NomProgon:=1 to SeKolProgon.Value do
    begin

    If Length(ArraySolution)<>0 then
    For NomSolution:=0 to Length(ArraySolution)-1 do
      begin
      SetLength(ArraySolution[NomSolution].Krit,0);
      SetLength(ArraySolution[NomSolution].ElementArray,0);
      end;
    SetLength(ArraySolution,0);
    SetLength(ParetoSet,0);
    
    ClearAllAntGraph;
    TimeStart:=Now;
    GoMMK(KolIteration,ArrKritNode,KritEnd);
    TimeStop:=Now;
    MeStat.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+' Прогон №'+IntToStr(NomProgon)+'  Количество итераций '+IntToStr(KolIteration));

    If KolIteration=SeKritKolIteration.Value then
      Inc(KolCircleIteration)
    else
      begin
      MTime:=MTime+(TimeStop-TimeStart);
      KolProgon:=KolProgon+1;
      MIteration:=MIteration+KolIteration;
      La2Iteration:=La2Iteration+KolIteration*KolIteration;
      end;


    end;


  //NomStr:= Excel.Cells[1,2];

  if KolProgon<>0 then
    begin
    MIteration:=MIteration/KolProgon;
    MTime:=MTime/KolProgon;
    La2Iteration:=La2Iteration/KolProgon;
    DIteration:=La2Iteration-MIteration*MIteration;
    DIteration:=DIteration*KolProgon/(KolProgon-1);
  MeStat.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Процент зацикливаний алгоритма ='+FloatToStr(KolCircleIteration/SeKolProgon.Value));
  MeStat.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Среднее время работы ММК ='+FormatDateTime('hh:nn:ss - zzz', MTime));
  MeStat.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Математическое ожидание ='+FloatToStr(MIteration));
  MeStat.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Второй начальный момент ='+FloatToStr(La2Iteration));
  MeStat.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Дисперсия ='+FloatToStr(DIteration));
  Excel.Cells[NomExcel,1]:=KolCircleIteration/SeKolProgon.Value;
  Excel.Cells[NomExcel,2]:=MTime;
  Excel.Cells[NomExcel,3]:=FormatDateTime('hh:nn:ss - zzz', MTime);
  Excel.Cells[NomExcel,4]:=MIteration;
  Excel.Cells[NomExcel,5]:=La2Iteration;
  Excel.Cells[NomExcel,6]:=DIteration;
    end;

  For NomKrit:=0 to KolKrit do
    For i:=1 to 6 do
      if SgAntPAr.Cells[i,NomKrit+1]<>SgStatisticsKon.Cells[i,NomKrit+1] then
        begin
        SgAntPAr.Cells[i,NomKrit+1]:=FloatToStr(StrToFloat(SgAntPAr.Cells[i,NomKrit+1])+StrToFloat(SgStatisticsShag.Cells[i,NomKrit+1]));
        MeStat.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Новое значение для критерия №'+IntToStr(NomKrit)+' для '+SgAntPAr.Cells[i,0]+' равно '+SgAntPAr.Cells[i,NomKrit+1]);
        end;

  BEndProgon:=True;
  For NomKrit:=0 to KolKrit do
    For i:=1 to 6 do
      if (SgAntPAr.Cells[i,NomKrit+1])<>(SgStatisticsKon.Cells[i,NomKrit+1]) then
        BEndProgon:=False;
  end;
Excel.Workbooks[1].SaveAs('Статистика.xlsx');
Excel.Workbooks.Close;
Excel.Quit;
Excel := Unassigned;
end;

procedure TFMain.SbGoStatistisClick(Sender: TObject);
var
  NomProgon,NomSolution,KolIteration,KolProgon,KolCircleIteration:LongWord;
  MIteration,La2Iteration,DIteration,CurrentZn:double;
  NomKrit,i:LongWord;
  BEndProgon:Boolean;
  NomExcel:LongWord;
  TimeStart,TimeStop,MTime:TDateTime;
  ArrKritNode,ArrKritNodeProgon,LA2ArrKritNodeProgon:TArrDouble;
  ArrKritEndProgon,MaxArrKritEndProgon,LA2ArrKritEndProgon:TArrDouble;
  ArrKolIterationProgon,LA2KolIterationProgon:Double;
  MKolZaciklProgon,LA2KolZaciklProgon:Double;
  st:string;
  KritEnd:Double;
begin
MeProt.Lines.Add(FormatDateTime('nn:ss - zzz', Now)+'  Старт сбора статистики ');
Vivod:=false;
{if not Vivod then
  FMain.Visible := false; }
Excel := CreateOleObject('Excel.Application');
Excel.Workbooks.open('Статистика.xlsx');
NomExcel:=1;
Excel.Cells[NomExcel,1]:='Значение '+IntTostr(RgParStatistics.ItemIndex);
Excel.Cells[NomExcel,2]:='% зацикливаний';
Excel.Cells[NomExcel,3]:='МО(Время)';
Excel.Cells[NomExcel,4]:='МО(Время)';
Excel.Cells[NomExcel,5]:='МО(Критерий)';
Excel.Cells[NomExcel,6]:='Top(Критерий)';
Excel.Cells[NomExcel,7]:='LA2(Критерий)';
Excel.Cells[NomExcel,8]:='D(Критерий)';
Excel.Cells[NomExcel,9]:='МО(Итерации)';
Excel.Cells[NomExcel,10]:='LA2(Итерации)';
Excel.Cells[NomExcel,11]:='D(Итерации)';
Excel.Cells[NomExcel,12]:='МО(Кол Решений)';
Excel.Cells[NomExcel,13]:='LA2(Кол Решений)';
Excel.Cells[NomExcel,14]:='D(Кол Решений)';
Excel.Cells[NomExcel,15]:='МО(Кол Зацик)';
Excel.Cells[NomExcel,16]:='LA2(Кол Зацик)';
Excel.Cells[NomExcel,17]:='D(Кол Зацик)';

  If CbVivodKrit.Checked then
    begin
    For NomKrit:=0 to KolKrit-1 do
      Excel.Cells[NomExcel,18+NomKrit]:='МО(Крит) №'+IntToStr(NomKrit+1);
    end;

SetLength(ArrKritNodeProgon,KolKrit);
SetLength(LA2ArrKritNodeProgon,KolKrit);
SetLength(ArrKritEndProgon,KolKrit);
SetLength(MaxArrKritEndProgon,KolKrit);
SetLength(LA2ArrKritEndProgon,KolKrit);

CurrentZn:=StrToFloat(LeNatZnStatiatics.Text);
While CurrentZn<StrToFloat(LeKonZnStatistics.Text) do
  begin

  Case RgParStatistics.ItemIndex of
    0: SeKolAnt.Value:=Trunc(CurrentZn);
    1: begin
       SgKrit.Cells[1,1]:=FloatToStr(CurrentZn);
       SgKrit.Cells[1,2]:=FloatToStr(1-CurrentZn);
       end;
    2: SgAntPAr.Cells[2,1]:=FloatToStr(CurrentZn);
    3: SgAntPAr.Cells[2,2]:=FloatToStr(CurrentZn);
    4: SgAntPAr.Cells[3,1]:=FloatToStr(CurrentZn);
    5: SgAntPAr.Cells[3,2]:=FloatToStr(CurrentZn);
    6: begin
       SgAntPAr.Cells[3,1]:=FloatToStr(CurrentZn);
       SgAntPAr.Cells[3,2]:=FloatToStr(CurrentZn);
       end;
    7: SgAntPAr.Cells[4,1]:=FloatToStr(CurrentZn);
    8: SgAntPAr.Cells[4,2]:=FloatToStr(CurrentZn);
    9: begin
       SgAntPAr.Cells[4,1]:=FloatToStr(CurrentZn);
       SgAntPAr.Cells[4,2]:=FloatToStr(CurrentZn);
       end;
    10:SgParKrit.Cells[2,1]:=FloatToStr(CurrentZn);
    11:SgParKrit.Cells[2,2]:=FloatToStr(CurrentZn);
    12:LeParKolProhod.Text:=FloatToStr(CurrentZn);
    13:SgKritEnd.Cells[1,1]:=FloatToStr(CurrentZn);
    14:SeKolIterationEnd.Value:=Trunc(CurrentZn);
    15:SeKritKolIteration.Value:=Trunc(CurrentZn);
    16:SeKolSolutionInGraph.Value:=Trunc(CurrentZn);
  end;

  inc(NomExcel);
  LoadParAtForm;
  MIteration:=0;
  La2Iteration:=0;
  KolProgon:=0;
  KolCircleIteration:=0;
  ArrKolIterationProgon:=0; LA2KolIterationProgon:=0;
  MKolZaciklProgon:=0; LA2KolZaciklProgon:=0;

  For NomKrit:=0 to KolKrit-1 do
    begin
    ArrKritNodeProgon[NomKrit]:=0; LA2ArrKritNodeProgon[NomKrit]:=0;
    ArrKritEndProgon[NomKrit]:=0;  LA2ArrKritEndProgon[NomKrit]:=0;
    If ParNaprKrit[NomKrit]=0 then   //min
      MaxArrKritEndProgon[NomKrit]:=100000000000000000
    else
      MaxArrKritEndProgon[NomKrit]:=0;
    end;

  for NomProgon:=1 to SeKolProgon.Value do
    begin
    If Length(ArraySolution)<>0 then
    For NomSolution:=0 to Length(ArraySolution)-1 do
      begin
      SetLength(ArraySolution[NomSolution].Krit,0); ArraySolution[NomSolution].Krit:=nil;
      SetLength(ArraySolution[NomSolution].ElementArray,0);ArraySolution[NomSolution].ElementArray:=nil;
      end;
    KolSolution:=0;
    If (RgSolutionSetting.ItemIndex=0) or (RgSolutionSetting.ItemIndex=2) then
    begin SetLength(ArraySolution,0);ArraySolution:=nil;end;
    If RgSolutionSetting.ItemIndex=1 then
    begin  SetLength(ArraySolution,2);  end;


    SetLength(ParetoSet,0);ParetoSet:=nil;
    ClearAllAntGraph;
    If CbClearMemeoIteration.Checked then
      MeProt.Clear;
    TimeStart:=Now;
    GoMMK(KolIteration,ArrKritNode,KritEnd);
    TimeStop:=Now;
//    if vivod then
    if RgSolutionSetting.ItemIndex=0 then
      KolSolution:=Length(ArraySolution);
    MeStatProgon.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+' Прогон №'+IntToStr(NomProgon)+'  Кол. итераций '+IntToStr(KolIteration)+'  Кол. решений '+IntToStr(KolSolution));
    if vivod then
    begin
    st:='';
    For NomKrit:=0 to KolKrit-1 do
      St:=st+FloatToStr(ArrKritNode[NomKrit])+';';
    MeStatProgon.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Веса критериев '+st+' Критерий='+FloatToStr(ArraySolution[ParetoSet[0]].Krit[0]));
    end;

    If KolIteration=SeKritKolIteration.Value then
      Inc(KolCircleIteration)
    else
      begin
      MTime:=MTime+(TimeStop-TimeStart);
      KolProgon:=KolProgon+1;
      MIteration:=MIteration+KolIteration; La2Iteration:=La2Iteration+sqr(KolIteration);
      ArrKolIterationProgon:=ArrKolIterationProgon+KolSolution; LA2KolIterationProgon:=LA2KolIterationProgon+sqr(KolSolution);
      MKolZaciklProgon:=MKolZaciklProgon+KolSbrosAntGrap; LA2KolZaciklProgon:=LA2KolZaciklProgon+Sqr(KolSbrosAntGrap);
      For NomKrit:=0 to KolKrit-1 do
        begin
        ArrKritNodeProgon[NomKrit]:=ArrKritNodeProgon[NomKrit]+ArrKritNode[NomKrit]; LA2ArrKritNodeProgon[NomKrit]:=La2ArrKritNodeProgon[NomKrit]+sqr(ArrKritNode[NomKrit]);
        ArrKritEndProgon[NomKrit]:=ArrKritEndProgon[NomKrit]+ArraySolution[ParetoSet[0]].Krit[NomKrit]; LA2ArrKritEndProgon[NomKrit]:=La2ArrKritEndProgon[NomKrit]+sqr(ArraySolution[ParetoSet[0]].Krit[NomKrit]);
        If (ParNaprKrit[NomKrit]=0) and (MaxArrKritEndProgon[NomKrit]>ArraySolution[ParetoSet[0]].Krit[NomKrit]) then   //min
          MaxArrKritEndProgon[NomKrit]:=ArraySolution[ParetoSet[0]].Krit[NomKrit];
        If (ParNaprKrit[NomKrit]<>0) and (MaxArrKritEndProgon[NomKrit]<ArraySolution[ParetoSet[0]].Krit[NomKrit]) then  //max
            MaxArrKritEndProgon[NomKrit]:=ArraySolution[ParetoSet[0]].Krit[NomKrit];
        end;
      end;
    end;

  If KolProgon<>0 then
    begin
    ArrKritEndProgon[0]:=ArrKritEndProgon[0]/KolProgon;  LA2ArrKritEndProgon[0]:=LA2ArrKritEndProgon[0]/KolProgon;
    ArrKolIterationProgon:=ArrKolIterationProgon/KolProgon; LA2KolIterationProgon:=LA2KolIterationProgon/KolProgon;
    MKolZaciklProgon:=MKolZaciklProgon/KolProgon; LA2KolZaciklProgon:=LA2KolZaciklProgon/KolProgon;
    MIteration:=MIteration/KolProgon; La2Iteration:=La2Iteration/KolProgon; DIteration:=La2Iteration-MIteration*MIteration;
    If KolProgon<>1 then
      DIteration:=DIteration*KolProgon/(KolProgon-1);
    MTime:=MTime/KolProgon;

    For NomKrit:=0 to KolKrit-1 do
      ArrKritNodeProgon[NomKrit]:=ArrKritNodeProgon[NomKrit]/KolProgon;
    end;
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Значение ='+FloatToStr(CurrentZn));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Процент зацикливаний алгоритма ='+FloatToStr(KolCircleIteration/SeKolProgon.Value));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Среднее время работы ММК ='+FormatDateTime('hh:nn:ss - zzz', MTime));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Математическое ожидание ='+FloatToStr(MIteration));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Второй начальный момент ='+FloatToStr(La2Iteration));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Дисперсия ='+FloatToStr(DIteration));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Критерий Математическое ожидание ='+FloatToStr(ArrKritEndProgon[0]));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Критерий Лучший ='+FloatToStr(MaxArrKritEndProgon[0]));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Критерий Второй начальный момент ='+FloatToStr(LA2ArrKritEndProgon[0]));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Количество решений Математическое ожидание ='+FloatToStr(ArrKolIterationProgon));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Количество решений Второй начальный момент ='+FloatToStr(LA2KolIterationProgon));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Зацикливание Математическое ожидание ='+FloatToStr(MKolZaciklProgon));
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Зацикливание Второй начальный момент ='+FloatToStr(LA2KolZaciklProgon));

  st:='';
  For NomKrit:=0 to KolKrit-1 do
    St:=st+FloatToStr(ArrKritNodeProgon[NomKrit])+';';
  MeStat.Lines.Add(FormatDateTime('hh:nn:ss - zzz', Now)+'  Веса критериев '+st);
  Excel.Cells[NomExcel,1]:=CurrentZn;
  Excel.Cells[NomExcel,2]:=KolCircleIteration/SeKolProgon.Value;
//  Excel.Cells[NomExcel,3]:=MTime;
  Excel.Cells[NomExcel,4]:=FormatDateTime('hh:nn:ss - zzz', MTime);
  Excel.Cells[NomExcel,5]:=ArrKritEndProgon[0];
  Excel.Cells[NomExcel,6]:=MaxArrKritEndProgon[0];
  Excel.Cells[NomExcel,7]:=LA2ArrKritEndProgon[0];
  Excel.Cells[NomExcel,9]:=MIteration;
  Excel.Cells[NomExcel,10]:=La2Iteration;
  Excel.Cells[NomExcel,11]:=DIteration;
  Excel.Cells[NomExcel,12]:=ArrKolIterationProgon;
  Excel.Cells[NomExcel,13]:=LA2KolIterationProgon;
  Excel.Cells[NomExcel,15]:=MKolZaciklProgon;
  Excel.Cells[NomExcel,16]:=LA2KolZaciklProgon;
  If CbVivodKrit.Checked then
    begin
    For NomKrit:=0 to KolKrit-1 do
      Excel.Cells[NomExcel,18+NomKrit]:=ArrKritNodeProgon[NomKrit];
    end;
  Excel.Workbooks[1].Save;
  SetLength(IspParArc,0);
  SetLength(IspParNode,0);
  SetLength(NPheromon,0);
  SetLength(ParNaprKrit,0);
  SetLength(ParKrit,0);
  SetLength(ParKritEnd,0);
  SetLength(ParKritMax,0);
  CurrentZn:=CurrentZn+StrToFloat(LeShagStatistics.Text);
  end;
Excel.Workbooks.Close;
Excel.Quit;
Excel := Unassigned;
if not Vivod then
  FMain.Visible := true;
end;

procedure TFMain.SbLoadDependSystem4KritClick(Sender: TObject);
begin
if OdLoad.Execute then
  begin
  TypeSystem:=0;
  DependSystem:=TDependSystem.Create;
  LoadDependSystem4KritOnTextFile(OdLoad.FileName);
  VDependSystem(MeProt);
  end;
end;

end.
