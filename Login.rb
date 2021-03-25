require_relative "JOIN"
require "fox16"
require 'mysql2'
require_relative 'tipo'
include Fox
class Programa < FXMainWindow
  def initialize(app,tipo)

    @app=app #EL ARROBA PERMITE QUE LA VARIABLE SE VUELVA GLOBAL
    logoicon =FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"LOGIN",:icon => logoicon,:opts => LAYOUT_FILL, :width=>400, :height=>400)
    full.backColor= FXRGB(165,249,229)
    #self.backColor = app.backColor="black"
    yesicon =FXPNGIcon.new(app, File.open("yes2.png", "rb").read)
    boton_volver_icon =FXPNGIcon.new(app, File.open("flecha_icono.png", "rb").read)
    boton_volver=FXButton.new(self,"",:icon=>boton_volver_icon, :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>66, :height=>66,:x=>0, :y=>0)
    boton_volver.backColor= FXRGB(165,249,229)
    boton_volver.connect(SEL_COMMAND) do
      volver()
    end
    if tipo=="Alumno"
      lbl0=FXLabel.new(self,"Usuario #{tipo}",:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>300, :height=>50, :x=>50, :y=>0)
      lbl0.backColor= FXRGB(47, 167, 78)
      lbl0.textColor = FXRGB(255,255,255)
    end
    if tipo=="Docente"
      lbl0=FXLabel.new(self,"Usuario #{tipo}",:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>300, :height=>50, :x=>50, :y=>0)
      lbl0.backColor= FXRGB(254, 195, 57)
      lbl0.textColor = FXRGB(255,255,255)
    end
    if tipo=="Administrador"
      lbl0=FXLabel.new(self,"Usuario #{tipo}",:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>300, :height=>50, :x=>80, :y=>0)
      lbl0.backColor= FXRGB(6, 123, 249)
      lbl0.textColor = FXRGB(255,255,255)
    end

    lbl1=FXLabel.new( self,"INICIAR SESIÓN", :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>300, :height=>50, :x=>50, :y=>60)

    lbl2=FXLabel.new( self,"USUARIO:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>200, :height=>40, :x=>100, :y=>120)
    @user=FXTextField.new(self,50, :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>200, :height=>30,:x=>100, :y=>160)
    @user.backColor="white"
    lbl3=FXLabel.new( self,"CONTRASEÑA:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>200, :height=>40, :x=>100, :y=>190)
    @pass=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|TEXTFIELD_PASSWD|JUSTIFY_CENTER_X, :width=>200, :height=>30,:x=>100, :y=>230)
    @pass.backColor="white"
    boton=FXButton.new(self,"", :icon=>yesicon, :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>66, :height=>66,:x=>174, :y=>280)


    helvetica = FXFont.new(app, "helvetica", 14)
    helvetica2 = FXFont.new(app, "helvetica", 22)
    lbl0.font = helvetica2

    lbl1.font = helvetica
    lbl1.backColor= FXRGB(165,249,229)
    lbl2.font = helvetica
    lbl2.backColor= FXRGB(165,249,229)
    lbl3.font = helvetica
    lbl3.backColor= FXRGB(165,249,229)

    boton.font = helvetica
    boton.backColor= FXRGB(165,249,229)



    boton.connect(SEL_COMMAND) do #QUE VA SUCEDER SI SE PRESIONA EL BOTON
    user_value=@user.text #OBTENER EL VALOR DE TIPO TEXTO DE LOS INPUTS
    pass_value=@pass.text
    verificar(user_value,pass_value,tipo)




    end


  end

  def volver()
    volver_win=Usuarios.new(@app)
    volver_win.create
    volver_win.show(PLACEMENT_SCREEN)
    self.close
  end



  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def invoque_window(name,tipo,ide)
    nombre=name
    new_ventana=JOIN.new(@app,nombre,tipo,ide)
    new_ventana.create
    new_ventana.show(PLACEMENT_SCREEN)
    self.close
  end


  def verificar(user,password,tipo)
    c=0
    arreglo=[]
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    if tipo=="Alumno"
      consulta='SELECT * FROM alumnos'
      identi="ID_Alumno"
    end
    if tipo=="Docente"
      consulta='SELECT * FROM maestros'
      identi="ID_Maestro"
    end
    if tipo=="Administrador"
      consulta='SELECT * FROM administradores'
      identi="ID_Admin"
    end

    results=conn.query(consulta)

    results.each do |row|
      c+=1
      id=row[identi]
      username=row["Username"]
      pass=row["Password"]
      name=row["Nombre"]
      arreglo.push([id,username,pass,name])
    end
    i=0
    si=0
    while i<arreglo.length
      if user==arreglo[i][1]
        if password==arreglo[i][2]
          nombre=arreglo[i][3]
          ide=arreglo[i][0]
          invoque_window(nombre,tipo,ide)
          i=9999999
          si=1
        elsif password!=arreglo[i][2]
          FXMessageBox.information(self,MBOX_OK,"Atencion","Contraseña incorrecta")
          si=1
        end


      end
      i+=1
    end
    if i==arreglo.length and si==0
      FXMessageBox.information(self,MBOX_OK,"Atencion","Usuario incorrecto")
    end
    end

end


