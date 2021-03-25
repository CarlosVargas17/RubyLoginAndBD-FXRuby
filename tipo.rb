require_relative"Login"
require 'fox16'
include Fox

class Usuarios <FXMainWindow
  def initialize(app)
    @app=app
    logoicon =FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"Usuarios",:icon => logoicon,:opts => LAYOUT_FILL, :width=>500, :height=>280)
    full.backColor= FXRGB(165,249,229)

    helvetica = FXFont.new(app, "helvetica", 14)

    boton_volver_icon =FXPNGIcon.new(app, File.open("exit.png", "rb").read)
    boton_volver=FXButton.new(self,"",:icon=>boton_volver_icon, :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>66, :height=>66,:x=>430, :y=>-10)
    boton_volver.backColor= FXRGB(165,249,229)
    boton_volver.connect(SEL_COMMAND) do
      volver()
    end

    
    lbl=FXLabel.new( self,"Selecciona un tipo de Usuario", :opts=>LAYOUT_EXPLICIT, :width=>300, :height=>50, :x=>93, :y=>20)
    lbl.backColor= FXRGB(165,249,229)
    lbl.font = helvetica
    alumnoicon =FXPNGIcon.new(app, File.open("alumno2.png", "rb").read)
    profeicon =FXPNGIcon.new(app, File.open("profesor.png", "rb").read)
    adminicon =FXPNGIcon.new(app, File.open("administrador.png", "rb").read)

    boton=FXButton.new(self,"    Alumno", :icon => alumnoicon,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|JUSTIFY_LEFT, :width=>165, :height=>40,:x=>165, :y=>70)
    boton.font=helvetica
    boton.backColor= FXRGB(47, 167, 78)
    boton.iconPosition = ICON_BEFORE_TEXT
    boton.textColor = FXRGB(255,255,255)

    boton2=FXButton.new(self,"    Docente", :icon => profeicon,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|JUSTIFY_LEFT, :width=>165, :height=>40,:x=>165, :y=>120)
    boton2.font=helvetica
    boton2.backColor= FXRGB(254, 195, 57)
    boton2.iconPosition = ICON_BEFORE_TEXT
    boton2.textColor = FXRGB(255,255,255)

    boton3=FXButton.new(self,"Administrador", :icon => adminicon,:opts=>LAYOUT_EXPLICIT|FRAME_GROOVE|JUSTIFY_LEFT, :width=>165, :height=>40,:x=>165, :y=>170)
    boton3.font=helvetica
    boton3.backColor= FXRGB(6, 123, 249)
    boton3.iconPosition = ICON_BEFORE_TEXT
    boton3.textColor = FXRGB(255,255,255)


    boton.connect(SEL_COMMAND) do
      tipo="Alumno"
      redirigir(tipo)
    end
    boton2.connect(SEL_COMMAND) do
      tipo="Docente"
      redirigir(tipo)
    end
    boton3.connect(SEL_COMMAND) do
      tipo="Administrador"
      redirigir(tipo)
    end


  end

  def volver()

    answer=FXMessageBox.question(self,MBOX_YES_NO,"Atención","¿Deseas salir?")
    if answer == MBOX_CLICKED_YES
      self.close
    end

  end


  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def redirigir(tipo)
    tipoUser=tipo
    new_ventana=Programa.new(@app,tipoUser)
    new_ventana.create
    new_ventana.show(PLACEMENT_SCREEN)
    self.close
  end
end
