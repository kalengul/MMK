unit UModelDepend;

interface

uses SysUtils;

type
  TDependElement = class;
  TArrDouble = array of Double;
  TDependSystem = class
    Element: array of TDependElement;
    Group: array of array of LongWord;
      Name: string;
    FL, FHY, FCY, FDY, Fr_zad: Double;
    TimeWait:Double;
    AllValueSklad:Double;
    KolPersonal:Longword;
    RROb, Cost: Double;
    procedure GoRROb;
    constructor Create;
    destructor Destroy; override;
  end;
  TDependElement = class
    QPA, OTR, MTBUR, RT, PT, EPT, AD, Cp, D, FR, Dr, RR, Price: Double;
    TimeInstalation,TimeTransport:Double;
    KolTransportationInThePart:Longword;
    ValueSklad:Double;
    FRi: TArrDouble;
    N: LongWord;
      Name: string;
    UpSystem: TDependSystem;
    procedure GoZnat;
    procedure GoZnatToN;
    constructor Create;
    destructor Destroy; override;
  end;

procedure LoadDependSystemOnTextFile(NameFile: string);
procedure LoadDependSystem4KritOnTextFile(NameFile: string);
procedure SaveDependSystemOnTextFile(NameFile: string);
procedure CopyDependSystem(var NewDependSystem: TDependSystem);
function GoRRToN(D, AD, FDY, EPT: Double; N: LongWord): Double;

var
  DependSystem: TDependSystem;

implementation

procedure TDependSystem.GoRROb;
var
  NomElement: LongWord;
  CurrentTime:Double;
begin
  RROb := 1;
  Cost := 0;
  TimeWait:=0;
  AllValueSklad:=0;
  for NomElement := 0 to Length(Element) - 1 do
  begin
    RROb := RROb * Element[NomElement].RR;
    Cost := Cost + Element[NomElement].Price * Element[NomElement].N;
    If Element[NomElement].KolTransportationInThePart<>0 then
    CurrentTime:=Element[NomElement].TimeTransport*Trunc(Element[NomElement].N/Element[NomElement].KolTransportationInThePart+1)+Element[NomElement].TimeInstalation
    else
      CurrentTime:=TimeWait;
    If Element[NomElement].N=0 then
      CurrentTime:=0;
    If TimeWait<CurrentTime then TimeWait:=CurrentTime;
    AllValueSklad := AllValueSklad + Element[NomElement].ValueSklad * Element[NomElement].N;
  end;
end;

procedure TDependElement.GoZnat;
var
  Di, Facti: Double;
  i, NomFr: LongWord;
begin
  Ad := UpSystem.FL * QPA * UpSystem.FCY * OTR / MTBUR;
  CP := RT / 365;
  D := Ad * Cp;
  Fr := 0;
  N := 0;
  NomFr := 0;
  while FR < UpSystem.Fr_zad do
  begin
    Di := 1;
    Facti := 1;
    if N <> 0 then
      for i := 1 to N do
      begin
        Di := Di * D;
        Facti := Facti * i;
      end;

    Fr := Fr + Exp(-D) * Di / Facti;
    SetLength(FRi, NomFr + 1);
    FRi[NomFr] := FR;
    NomFr := NomFr + 1;
    N := N + 1;
  end;
  N := N - 1;
  Dr := -Ln(Exp(-AD) + Fr * (1 - exp(-Ad)));
  RR := UpSystem.FDY / (UpSystem.FDY + Dr * Ept);
end;

function GoRRToN(D, AD, FDY, EPT: Double; N: LongWord): Double;
var
  Di, Facti, Dr, Fr, RR: Double;
  i, j, NomFr: LongWord;
begin
  Fr := 0;
  for j := 1 to N do
  begin
    Di := 1;
    Facti := 1;
    if N <> 0 then
      for i := 1 to N do
      begin
        Di := Di * D;
        Facti := Facti * i;
      end;
    Fr := Fr + Exp(-D) * Di / Facti;
  end;
  Dr := -Ln(Exp(-AD) + Fr * (1 - exp(-Ad)));
  RR := FDY / (FDY + Dr * Ept);
  Result := RR;
end;

procedure TDependElement.GoZnatToN;
var
  Di, Facti: Double;
  i, j, NomFr: LongWord;
begin
  Fr := 0;
  for j := 1 to N do
  begin
    Di := 1;
    Facti := 1;
    if N <> 0 then
      for i := 1 to N do
      begin
        Di := Di * D;
        Facti := Facti * i;
      end;
    Fr := Fr + Exp(-D) * Di / Facti;
  end;
  Dr := -Ln(Exp(-AD) + Fr * (1 - exp(-Ad)));
  RR := UpSystem.FDY / (UpSystem.FDY + Dr * Ept);
end;

procedure CopyDependSystem(var NewDependSystem: TDependSystem);
var
  NomElement, KolElement, KolFri, NomFri: LongWord;
begin
  KolElement := Length(DependSystem.Element);
  NewDependSystem := TDependSystem.Create;
  SetLength(NewDependSystem.Element, KolElement);

  NewDependSystem.Name := DependSystem.Name;
  NewDependSystem.FL := DependSystem.FL;
  NewDependSystem.FHY := DependSystem.FHY;
  NewDependSystem.FCY := DependSystem.FCY;
  NewDependSystem.FDY := DependSystem.FDY;
  NewDependSystem.Fr_zad := DependSystem.Fr_zad;
  NewDependSystem.RROb := DependSystem.RROb;
  NewDependSystem.Cost := DependSystem.Cost;
  for NomElement := 0 to KolElement - 1 do
  begin
    NewDependSystem.Element[NomElement] := TDependElement.Create;
    NewDependSystem.Element[NomElement].UpSystem := NewDependSystem;
    NewDependSystem.Element[NomElement].Name := DependSystem.Element[NomElement].Name;
    NewDependSystem.Element[NomElement].QPA := DependSystem.Element[NomElement].QPA;
    NewDependSystem.Element[NomElement].OTR := DependSystem.Element[NomElement].OTR;
    NewDependSystem.Element[NomElement].MTBUR := DependSystem.Element[NomElement].MTBUR;
    NewDependSystem.Element[NomElement].RT := DependSystem.Element[NomElement].RT;
    NewDependSystem.Element[NomElement].PT := DependSystem.Element[NomElement].PT;
    NewDependSystem.Element[NomElement].EPT := DependSystem.Element[NomElement].EPT;
    NewDependSystem.Element[NomElement].AD := DependSystem.Element[NomElement].AD;
    NewDependSystem.Element[NomElement].Cp := DependSystem.Element[NomElement].Cp;
    NewDependSystem.Element[NomElement].D := DependSystem.Element[NomElement].D;
    NewDependSystem.Element[NomElement].FR := DependSystem.Element[NomElement].FR;
    NewDependSystem.Element[NomElement].Dr := DependSystem.Element[NomElement].Dr;
    NewDependSystem.Element[NomElement].RR := DependSystem.Element[NomElement].RR;
    NewDependSystem.Element[NomElement].Price := DependSystem.Element[NomElement].Price;
    NewDependSystem.Element[NomElement].N := DependSystem.Element[NomElement].N;
    NewDependSystem.Element[NomElement].TimeInstalation := DependSystem.Element[NomElement].TimeInstalation;
    NewDependSystem.Element[NomElement].TimeTransport := DependSystem.Element[NomElement].TimeTransport;
    NewDependSystem.Element[NomElement].KolTransportationInThePart := DependSystem.Element[NomElement].KolTransportationInThePart;
    NewDependSystem.Element[NomElement].ValueSklad := DependSystem.Element[NomElement].ValueSklad;
    KolFri := Length(DependSystem.Element[NomElement].FRi);
    SetLength(NewDependSystem.Element[NomElement].FRi, KolFri);
    If KolFri<>0 then
    for NomFri := 0 to KolFri - 1 do
      NewDependSystem.Element[NomElement].FRi[NomFri] := DependSystem.Element[NomElement].FRi[NomFri];
  end;
end;

procedure LoadDependSystemOnTextFile(NameFile: string);
var
  f: TextFile;
  st: string;
  KolElement, NomElement, KolGroup, NomGroup: LongWord;
begin
  AssignFile(f, NameFile);
  Reset(f);
  Readln(f, st);
  Readln(f, DependSystem.Name);

  Readln(f, st);
  DependSystem.FL := StrToFloat(St);
  Readln(f, st);
  DependSystem.FHY := StrToFloat(St);
  Readln(f, st);
  DependSystem.FCY := StrToFloat(St);
  Readln(f, st);
  DependSystem.FDY := StrToFloat(St);
  Readln(f, st);
  DependSystem.Fr_zad := StrToFloat(St);

  Readln(f, st);
  KolElement := StrToInt(st);
  SetLength(DependSystem.Element, KolElement);

  for NomElement := 0 to KolElement - 1 do
  begin
    DependSystem.Element[NomElement] := TDependElement.Create;
    DependSystem.Element[NomElement].UpSystem := DependSystem;
    Readln(f, DependSystem.Element[NomElement].Name);
    Readln(f, st);
    DependSystem.Element[NomElement].N := StrToInt(St);
    Readln(f, st);
    DependSystem.Element[NomElement].QPA := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].OTR := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].MTBUR := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].RT := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].PT := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].EPT := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].Price := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].AD := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].Cp := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].D := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].FR := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].Dr := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].RR := StrToFloat(St);
  end;

  Readln(f, st);
  KolGroup := StrToInt(st);
  SetLength(DependSystem.Group, KolGroup);
  for NomGroup := 0 to KolGroup - 1 do
  begin
    Readln(f, st);
    KolElement := StrToInt(st);
    SetLength(DependSystem.Group[NomGroup], KolElement);
    for NomElement := 0 to KolElement - 1 do
    begin
      Readln(f, st);
      DependSystem.Group[NomGroup][NomElement] := StrToInt(St);
    end;

  end;

  CloseFile(f);
end;

procedure LoadDependSystem4KritOnTextFile(NameFile: string);
var
  f: TextFile;
  st: string;
  KolElement, NomElement, KolGroup, NomGroup: LongWord;
begin
  AssignFile(f, NameFile);
  Reset(f);
  Readln(f, st);
  Readln(f, DependSystem.Name);

  Readln(f, st);
  DependSystem.FL := StrToFloat(St);
  Readln(f, st);
  DependSystem.FHY := StrToFloat(St);
  Readln(f, st);
  DependSystem.FCY := StrToFloat(St);
  Readln(f, st);
  DependSystem.FDY := StrToFloat(St);
  Readln(f, st);
  DependSystem.Fr_zad := StrToFloat(St);

  Readln(f, st);
  KolElement := StrToInt(st);
  SetLength(DependSystem.Element, KolElement);

  for NomElement := 0 to KolElement - 1 do
  begin
    DependSystem.Element[NomElement] := TDependElement.Create;
    DependSystem.Element[NomElement].UpSystem := DependSystem;
    Readln(f, DependSystem.Element[NomElement].Name);
    Readln(f, st);
    DependSystem.Element[NomElement].N := StrToInt(St);
    Readln(f, st);
    DependSystem.Element[NomElement].QPA := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].OTR := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].MTBUR := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].RT := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].PT := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].EPT := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].Price := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].AD := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].Cp := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].D := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].FR := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].Dr := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].RR := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].TimeInstalation := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].TimeTransport := StrToFloat(St);
    Readln(f, st);
    DependSystem.Element[NomElement].KolTransportationInThePart := StrToInt(St);
    Readln(f, st);
    DependSystem.Element[NomElement].ValueSklad := StrToFloat(St);
  end;

  Readln(f, st);
  KolGroup := StrToInt(st);
  SetLength(DependSystem.Group, KolGroup);
  for NomGroup := 0 to KolGroup - 1 do
  begin
    Readln(f, st);
    KolElement := StrToInt(st);
    SetLength(DependSystem.Group[NomGroup], KolElement);
    for NomElement := 0 to KolElement - 1 do
    begin
      Readln(f, st);
      DependSystem.Group[NomGroup][NomElement] := StrToInt(St);
    end;

  end;

  CloseFile(f);
end;

procedure SaveDependSystemOnTextFile(NameFile: string);
var
  f: TextFile;
  KolElement, NomElement, KolGroup, NomGroup: LongWord;
begin
  AssignFile(f, NameFile);
  Rewrite(f);
  Writeln(f, 'Файл с настройками надежности для системы:');
  Writeln(f, DependSystem.Name);

  Writeln(f, FloatToStr(DependSystem.FL));
  Writeln(f, FloatToStr(DependSystem.FHY));
  Writeln(f, FloatToStr(DependSystem.FCY));
  Writeln(f, FloatToStr(DependSystem.FDY));
  Writeln(f, FloatToStr(DependSystem.Fr_zad));

  KolElement := Length(DependSystem.Element);
  Writeln(f, IntToStr(KolElement));

  for NomElement := 0 to KolElement - 1 do
  begin
    Writeln(f, DependSystem.Element[NomElement].Name);
    Writeln(f, IntToStr(DependSystem.Element[NomElement].N));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].QPA));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].OTR));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].MTBUR));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].RT));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].PT));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].EPT));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].Price));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].AD));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].Cp));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].D));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].FR));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].Dr));
    Writeln(f, FloatToStr(DependSystem.Element[NomElement].RR));
  end;

  KolGroup := Length(DependSystem.Group);
  Writeln(f, IntToStr(KolGroup));
  for NomGroup := 0 to KolGroup - 1 do
  begin
    KolElement := Length(DependSystem.Group[NomGroup]);
    Writeln(f, IntToStr(KolElement));
    for NomElement := 0 to KolElement - 1 do
      Writeln(f, IntToStr(DependSystem.Group[NomGroup][NomElement]));
  end;

  CloseFile(f);
end;

constructor TDependSystem.Create;
begin
SetLength(Group,0);
SetLength(Element,0);
end;

destructor TDependSystem.Destroy;
var
  NomElement,NomGroup: LongWord;
begin
  If Length(Group)<>0 then
  For NomGroup:=0 to Length(Group)-1 do
    SetLength(Group[NomGroup],0);
  SetLength(Group,0);

  If Length(Element)<>0 then
  for NomElement := 0 to Length(Element) - 1 do
    FreeAndNil(Element[NomElement]);
  SetLength(Element,0);
  inherited;
end;

constructor TDependElement.Create;
begin
  UpSystem := nil;
  SetLength(FRi,0);
  KolTransportationInThePart:=1;
end;

destructor TDependElement.Destroy;
begin
  UpSystem := nil;
  SetLength(FRi,0);
  inherited;
end;

end.

