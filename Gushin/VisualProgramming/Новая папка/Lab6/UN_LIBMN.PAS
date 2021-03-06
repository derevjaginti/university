unit UN_LIBMN;

interface
  Uses
    Windows,SysUtils,Graphics,Classes;
   const
    m=41;n=41;
    Corners=16;
    K_Max = 150;
   type tMas=array[1..m,1..n]of real;
        tMasSTEP = array[1..K_Max]of real;
        tCorner=record
                  x,y:integer;
                  t:real
                end;
        tMasCorners=array[1..Corners]of tCorner;
   var
      DoubleBuffer : TBitmap;
      BlankBuffer: TBitmap;
      MyRect:TRect;
      W,H:integer;
      flBegin:Boolean=FALSE;
      flBreak:Boolean=FALSE;
      D:real;
   var
      Mas,RabMas:tMas;
      MasSTEP:tMasSTEP;
      MyColor:array[1..31]of TColor;//COLORS of IZOLINES
      t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16:real;
      t0:real=0;
      Epsilon:real=1e-3;
      K_STEPS:integer=0;
      MasCorners:tMasCorners=( //�����������   ����
      (x:1;y:11;t:1),//1
      (x:1;y:31;t:1),//2
      (x:11;y:1;t:1),//3
      (x:11;y:11;t:1),//4
      (x:21;y:31;t:1),//5
      (x:21;y:41;t:1),//6
      (x:16;y:16;t:1),//7
      (x:16;y:26;t:1),//8
      (x:26;y:16;t:1),//9
      (x:26;y:26;t:1),//10
      (x:31;y:1;t:1),//11
      (x:31;y:11;t:1),//12
      (x:31;y:21;t:1),//13
      (x:31;y:41;t:1),//14
      (x:41;y:11;t:1),//15
      (x:41;y:21;t:1));//16
      flResult:Boolean=FALSE;
   procedure FillMas;
   procedure IZOTABL(TargetCanvas:TCanvas;zagl:string;z:tMas;m,n:integer;
                               SX,SY,u0,v0:integer;
                               hh,izo_gr:real;
                               Legenda:Boolean);
   procedure STEP_LIBMAN(var d:real);

implementation
procedure STEP_LIBMAN(var d:real);
var
  t_new,r:real;
  st:string;
  i,j:integer;
begin
  d:=0;
  for i:=2 to m-1 do
    for j:=2 to n-1 do  begin
      //����� ������� ���������� ����� (8 ����!)
      if((i=11)and(j=11))or((i=31)and(j=11))or
          ((i=21)and(j=31))or((i=31)and(j=21))or
          ((i=16)and(j=16))or((i=16)and(j=26))or
          ((i=26)and(j=16))or((i=26)and(j=26))then Continue;
      if(RabMas[i-1,j]<777)and(RabMas[i+1,j]<777) and(RabMas[i,j+1]<777)and(RabMas[i,j-1]<777) then begin
        t_new:=0.25*(RabMas[i-1,j]+RabMas[i+1,j]+RabMas[i,j+1]+RabMas[i,j-1]);
        r:=Abs(t_new-RabMas[i,j]);
        if r>d then d:=r;
        RabMas[i,j]:=t_new;
      end;
    end;
    Inc(K_STEPS);

end;
procedure FillMas;
  var
    ii,i,j:integer;
    t:real;
begin
//��������� ����
  for i:=1 to m do
    for j:=1 to n do Mas[i,j]:=t0;
  //������ � ���������������
  for i:=1 to 10 do
    for j:=1 to 10 do Mas[i,j]:=777;

  for i:=1 to 10 do
    for j:=32 to 41 do Mas[i,j]:=777;

  for i:=17 to 25 do
    for j:=17 to 25 do Mas[i,j]:=777;

  for i:=32 to 41 do
    for j:=17 to 25 do Mas[i,j]:=777;

  for ii:=1 to Corners do begin
    {i:=MasCorners[ii].x;
    j:=MasCorners[ii].y;
    t:=MasCorners[ii].t;
    Mas[i,j]:=t;}
  end;
  //��� ������ �� ��.
  t1:=MasCorners[1].t;
  t2:=MasCorners[2].t;
  t3:=MasCorners[3].t;
  t4:=MasCorners[4].t;
  t5:=MasCorners[5].t;
  t6:=MasCorners[6].t;
  t7:=MasCorners[7].t;
  t8:=MasCorners[8].t;
  t9:=MasCorners[9].t;
  t10:=MasCorners[10].t;
  t11:=MasCorners[11].t;
  t12:=MasCorners[12].t;
  t13:=MasCorners[13].t;
  t14:=MasCorners[14].t;
  t15:=MasCorners[15].t;
  t16:=MasCorners[16].t;

  {for i:=11 to 31 do begin//1,1a
        mas[i,1]:=t3+(t11-t3)*(i-11)/20;
      end;  }

      {for i:=21 to 31 do begin
        Mas[i,41]:=t6 +(t14-t6)*(i-21)/10;
      end;

      for j:=11 to 31 do begin//4,4a
        mas[1,j]:=t1+(t2-t1)*(j-11)/20;
      end;

      for j:=11 to 21 do begin
        Mas[41,j]:=t15+(t16-t15)*(j-11)/10;
      end;

      for j:=1 to 11 do begin//2,2a
        mas[11,j]:=t3+(t4-t3)*(j-1)/10;
        Mas[31,j]:=t11+(t12-t11)*(j-1)/10;
      end;

      for i:=1 to 11 do begin//3,3a
        mas[i,11]:=t1+(t4-t1)*(i-1)/10;
      end;

      for i:=1 to 21 do begin
        mas[i,31]:=t2+(t5-t2)*(i-1)/20;
      end;

      for j:=31 to 41 do begin//6,6a
        mas[21,j]:=t5+(t6-t5)*(j-31)/10;
      end;

      for i:=31 to 41 do begin//9,9a
        mas[i,11]:=t12+(i-31)*(t15-t12)/10;
      end;

      for i:=31 to 41 do begin
        Mas[i,21]:=t13+(i-31)*(t16-t13)/10;
      end;

      for j:=21 to 41 do begin
        mas[31,j]:=t13+(t14-t13)*(j-21)/20;
      end;

      for i:=16 to 26 do begin//7,7a
        mas[i,16]:=t7+(i-16)*(t9-t7)/10;
        mas[i,26]:=t8+(i-16)*(t10-t8)/10;
      end;

      for j:=16 to 26 do begin//8,8a
        mas[16,j]:=t7+(j-16)*(t8-t7)/10;
        mas[26,j]:=t9+(j-16)*(t10-t9)/10;
      end;      }
  RabMas:=Mas; //COPY
  K_STEPS:=0;
end;
procedure IZOTABL(TargetCanvas:TCanvas;zagl:string;z:tMas;m,n:integer;
                               SX,SY,u0,v0:integer;
                               hh,izo_gr:real;
                               Legenda:Boolean);
const
  eps=1e-3;
var
  i,j,u1,u2,v1,v2,u3,v3,kizo:integer;
  xi,xj,xk,yi,yj,yk,zi,zj,zk,cx,cy:real;
  xmin,xmax,ymin,ymax,zmin,zmax,izo,h:real;
  st:string;
  cl:TColor;
{--------------------------------------------}
function x(j:integer):real;
begin
  x:=(1.0/(n-1))*(j-1);
end;{ x }

{--------------------------------------------}
function y(i:integer):real;
begin
  y:=1.0-(1.0/(m-1))*(i-1);
end;{ y }

{--------------------------------------------------------------------}
procedure IZOTRG(TargetCanvas:TCanvas);
var
  i,u1,u2,u3,v1,v2,v3:integer;
  xr1,xr2,xr3,yr1,yr2,yr3:real;
  fl1,fl2,fl3:boolean;
  cl:TColor;
BEGIN
 if (abs(zi-zj)<1e-7) and(abs( zi-zk)<1e-7) then exit;

  for i:=1 to kizo do begin  {Main loop}
    izo:=zmin+(i-1)*h;
    cl:=myColor[i];
    TargetCanvas.Pen.Color:=cl;
    if abs(izo-izo_gr)<1e-3 then TargetCanvas.Pen.Width:=3
    else TargetCanvas.Pen.Width:=2;

    fl1:=false;
    fl2:=false;
    fl3:=false;
    {First side}
    if (abs(zi-zj)>1e-3)and((zi-izo)*(zj-izo)<=0) then {Interpol} begin
      fl1:=true;
      xr1:=xi+(xj-xi)/(zj-zi)*(izo-zi);
      yr1:=yi+(yj-yi)/(zj-zi)*(izo-zi);
      u1:=u0+round(xr1*cx);
      v1:=v0-round(yr1*cy);
    end;
    {Second side}
    if(abs(zj-zk)>1e-3)and((zk-izo)*(zj-izo)<=0) then{Interpol}  begin
      fl2:=true;
      xr2:=xj+(xk-xj)/(zk-zj)*(izo-zj);
      yr2:=yj+(yk-yj)/(zk-zj)*(izo-zj);
      u2:=u0+round(xr2*cx);
      v2:=v0-round(yr2*cy);
    end;
    {Third side}
    if(abs(zk-zi)>1e-3)and((zi-izo)*(zk-izo)<=0) then{Interpol}   begin
      fl3:=true;
      xr3:=xk+(xi-xk)/(zi-zk)*(izo-zk);
      yr3:=yk+(yi-yk)/(zi-zk)*(izo-zk);
      u3:=u0+round(xr3*cx);
      v3:=v0-round(yr3*cy);
    end;
    if fl1 and fl2 then Begin
      TargetCanvas.MoveTo(u1,v1);
      TargetCanvas.LineTo(u2,v2);
    End;
    if fl1 and fl3 then Begin
      TargetCanvas.MoveTo(u1,v1);
      TargetCanvas.LineTo(u3,v3);
    End;
    if fl2 and fl3 then Begin
      TargetCanvas.MoveTo(u2,v2);
      TargetCanvas.LineTo(u3,v3);
    End;
  end;{Loop izolines}
  TargetCanvas.Pen.Width:=1;
end;{IZOTRG}
{----------------------------------------------------------------------}

 procedure FillTRG;{���������� ������������ "�����������" -> ����� }
var
  arr_trg:array[1..3]of tPoint;
begin
  With arr_trg[1] do begin
    x:=u0+round(xi*sx);
    y:=v0-round(yi*sy);
  end;
  With arr_trg[2] do begin
    x:=u0+round(xj*sx);
    y:=v0-round(yj*sy);
  end;
  With arr_trg[3] do begin
    x:=u0+round(xk*sx);
    y:=v0-round(yk*sy);
  end;
  TargetCanvas.Pen.Color:=clSilver;
  TargetCanvas.Brush.Color:=clSilver;
  TargetCanvas.Brush.Style:=bsDiagCross;
  TargetCanvas.Polygon(arr_trg);
  TargetCanvas.Pen.Color:=clBlack;
  TargetCanvas.Brush.Style:=bsClear;
end;
  {===========================================================}
Begin { IzoTabl}
  TargetCanvas.Pen.Color:=clBlack;
  u1:=u0;
  v1:=v0-SY;
  u2:=u0+SX;
  v2:=v0;
  TargetCanvas.Rectangle(u1,v1,u2,v2);
  TargetCanvas.TextOut((u1+u2) div 2 -Length(zagl) div 2,v1-15,zagl);
  cx:=SX;
  cy:=SY;
  zmin:=1e10;
  zmax:=-1e10;
  for i:=1 to m do
    for j:=1 to n do
      if z[i,j]<777 then begin
        if z[i,j]<zmin then zmin:=z[i,j];
        if z[i,j]>zmax then zmax:=z[i,j];
      end;

  if hh<0 then begin
    h:=(zmax-zmin)/24;
    kizo:=25;
  end
  else begin
    h:=hh;
    kizo:=round((zmax-zmin+hh/2)/hh)+1;
    zmin:=round((zmin-hh/2)/hh)*hh;{������ h!}
  end;
  {LEGENDA}
  if Legenda then
    for i:=1 to kizo do begin
      izo:=zmin+(i-1)*h;
      cl:=myColor[i];
      TargetCanvas.Pen.Color:=cl;
      TargetCanvas.Font.Color:=clWhite;
      if abs(izo-izo_gr)<1e-3 then TargetCanvas.Pen.Width:=3
      else TargetCanvas.Pen.Width:=2;
      STR(izo:6:3,st);
      with TargetCanvas do begin
        MoveTo(u0+SX+70,i*18);LineTo(u0+SX+100,i*18);
        TextOut(u0+SX+105,i*18-5 ,st);
      end;//with
    end;

   For i:=1 to m-1 do
      for j:=1 to n-1 do BEGIN
        xi:=x(j);
        xj:=x(j);
        xk:=x(j+1);
        yi:=y(i);
        yj:=y(i+1);
        yk:=y(i);
        zi:=z[i,j];
        zj:=z[i+1,j];
        zk:=z[i,j+1];
        if (zi<777)and(zj<777)and(zk<777) then IZOTRG(TargetCanvas)
        else FillTRG;{}
        xi:=x(j);
        xj:=x(j+1);
        xk:=x(j+1);
        yi:=y(i+1);
        yj:=y(i+1);
        yk:=y(i);
        zi:=z[i+1,j];
        zj:=z[i+1,j+1];
        zk:=z[i,j+1];
        if (zi<777)and(zj<777)and(zk<777) then IZOTRG(TargetCanvas)
        else FillTRG;{}
      END;
End; {IZOTABL}

 Begin  //SHKALA COLORS
   myColor[1]:=RGB(0,0,250);
   myColor[2]:=RGB(0,50,250);
   myColor[3]:=RGB(0,100,250);
   myColor[4]:=RGB(0,150,250);
   myColor[5]:=RGB(0,200,250);
   myColor[6]:=RGB(0,250,250);
   myColor[7]:=RGB(0,250,200);
   myColor[8]:=RGB(0,250,150);
   myColor[9]:=RGB(0,250,100);
   myColor[10]:=RGB(0,250,50);

   myColor[11]:=RGB(0,250,0);
   myColor[12]:=RGB(50,250,0);
   myColor[13]:=RGB(100,250,0);
   myColor[14]:=RGB(150,250,0);
   myColor[15]:=RGB(200,250,0);
   myColor[16]:=RGB(250,250,0);
   myColor[17]:=RGB(250,200,0);
   myColor[18]:=RGB(250,150,0);
   myColor[19]:=RGB(250,100,0);
   myColor[20]:=RGB(250,50,0);

   myColor[21]:=RGB(250,0,0);
   myColor[22]:=RGB(250,0,50);
   myColor[23]:=RGB(250,0,100);
   myColor[24]:=RGB(250,0,150);
   myColor[25]:=RGB(250,0,200);
   myColor[26]:=RGB(250,0,250);
   myColor[27]:=RGB(200,0,250);
   myColor[28]:=RGB(150,0,250);
   myColor[29]:=RGB(100,0,250);
   myColor[30]:=RGB(50,0,250);
   myColor[31]:=RGB(0,0,250);

end.
