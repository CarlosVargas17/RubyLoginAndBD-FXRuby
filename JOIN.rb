require "fox16"
require 'mysql2'
require_relative 'tipo'
require_relative 'window_calif'
require_relative 'window_view_calif_alumn'
require_relative 'registra_docentes'
require_relative 'registra_alumnos'
require_relative 'registra_materias'
require_relative 'asignar_materias'
include Fox
class JOIN < FXMainWindow
  def initialize(app,name,tipo,id)
    @app=app
    tipo=tipo
    name=name
    id=id.to_s
    logoicon =FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"Inicio",:icon => logoicon,:opts => LAYOUT_FILL, :width=>600, :height=>400)
    full.backColor= FXRGB(165,249,229)
    helvetica = FXFont.new(app, "helvetica", 14)
    helvetica2 = FXFont.new(app, "helvetica", 18, :slant => FXFont::Italic)

    boton_volver_icon =FXPNGIcon.new(app, File.open("exit.png", "rb").read)
    boton_volver=FXButton.new(self,"",:icon=>boton_volver_icon, :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>66, :height=>66,:x=>534, :y=>-10)
    boton_volver.backColor= FXRGB(165,249,229)
    boton_volver.connect(SEL_COMMAND) do
      volver()
    end


    lbl=FXLabel.new( self,"BIENVENIDO #{name.upcase} \nTU ROL ES #{tipo.upcase}", :opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X, :width=>560, :height=>50, :x=>20, :y=>20)
    lbl.font = helvetica2
    lbl.backColor= FXRGB(165,249,229)





    if tipo=="Docente"
      docente_icon=FXPNGIcon.new(app, File.open("profesor2.png", "rb").read)
      imagen=FXLabel.new(self,"",:icon=>docente_icon,:opts=>LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>250,:x=>320, :y=>50)
      imagen.backColor=FXRGB(165,249,229)
      boton_captura_icon=FXPNGIcon.new(app, File.open("note_icon.png", "rb").read)
      boton_captura=FXButton.new(self ,"Capturar calificaciones",:icon => boton_captura_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>50,:x=>70, :y=>150)
      boton_captura.font=helvetica
      boton_captura.backColor= FXRGB(97, 166, 60)
      boton_captura.textColor = FXRGB(255,255,255)
      boton_captura.iconPosition=ICON_BEFORE_TEXT

      boton_captura.connect(SEL_COMMAND) do
        ventana_captura(id)
      end


    elsif tipo=="Alumno"
      alumno_icon=FXPNGIcon.new(app, File.open("alumno3.png", "rb").read)
      imagen=FXLabel.new(self,"",:icon=>alumno_icon,:opts=>LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>250,:x=>320, :y=>50)
      imagen.backColor=FXRGB(165,249,229)

      boton_alumno_icon=FXPNGIcon.new(app, File.open("note_icon.png", "rb").read)
      boton_alumno=FXButton.new(self ,"Ver calificaciones",:icon => boton_alumno_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>50,:x=>70, :y=>150)
      boton_alumno.font=helvetica
      boton_alumno.backColor= FXRGB(97, 166, 60)
      boton_alumno.textColor = FXRGB(255,255,255)
      boton_alumno.iconPosition=ICON_BEFORE_TEXT

      boton_alumno.connect(SEL_COMMAND) do
        ventana_view_alum(id)
      end

    else
      admin_icon=FXPNGIcon.new(app, File.open("administrador2.png", "rb").read)
      imagen=FXLabel.new(self,"",:icon=>admin_icon,:opts=>LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>250,:x=>320, :y=>85)
      imagen.backColor=FXRGB(165,249,229)

      boton_admin_icon1=FXPNGIcon.new(app, File.open("profesor.png", "rb").read)
      boton_admin=FXButton.new(self ,"Registrar Docentes",:icon => boton_admin_icon1,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>50,:x=>70, :y=>120)
      boton_admin.font=helvetica
      boton_admin.backColor= FXRGB(193,0,75)
      boton_admin.textColor = FXRGB(255,255,255)
      boton_admin.iconPosition=ICON_BEFORE_TEXT

      boton_admin.connect(SEL_COMMAND) do
        ventana_reg_doc()
      end

      boton_admin_icon2=FXPNGIcon.new(app, File.open("alumno2.png", "rb").read)
      boton_admin2=FXButton.new(self ,"Registrar Alumnos",:icon => boton_admin_icon2,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>50,:x=>70, :y=>180)
      boton_admin2.font=helvetica
      boton_admin2.backColor= FXRGB(23, 141, 205)
      boton_admin2.textColor = FXRGB(255,255,255)
      boton_admin2.iconPosition=ICON_BEFORE_TEXT

      boton_admin2.connect(SEL_COMMAND) do
        ventana_reg_alu()

      end

      boton_admin_icon3=FXPNGIcon.new(app, File.open("note_icon.png", "rb").read)

      boton_admin3=FXButton.new(self ,"Registrar Materias",:icon => boton_admin_icon3,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>50,:x=>70, :y=>240)
      boton_admin3.font=helvetica
      boton_admin3.backColor= FXRGB(255,121,0)
      boton_admin3.textColor = FXRGB(255,255,255)
      boton_admin3.iconPosition=ICON_BEFORE_TEXT

      boton_admin3.connect(SEL_COMMAND) do
        ventana_reg_mat()
      end

      boton_admin_icon4=FXPNGIcon.new(app, File.open("administrador.png", "rb").read)

      boton_admin4=FXButton.new(self ,"Asignar materias",:icon => boton_admin_icon4,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>250, :height=>50,:x=>70, :y=>300)
      boton_admin4.font=helvetica
      boton_admin4.backColor= FXRGB(97, 166, 60)
      boton_admin4.textColor = FXRGB(255,255,255)
      boton_admin4.iconPosition=ICON_BEFORE_TEXT

      boton_admin4.connect(SEL_COMMAND) do
        ventana_asig_mat()
      end


    end
  end

  def volver()

    answer=FXMessageBox.question(self,MBOX_YES_NO,"Atención","¿Deseas cerrar sesión?")
    if answer == MBOX_CLICKED_YES
      volver_win=Usuarios.new(@app)
      volver_win.create
      volver_win.show(PLACEMENT_SCREEN)
      self.close
    end

  end



  def ventana_captura(id)
      id_maestro=id
      new_captura=WindowCalificar.new(@app,id_maestro)
      new_captura.create
      new_captura.show(PLACEMENT_SCREEN)
    end

    def ventana_view_alum(id)
      id_alumno=id
      new_view_cal=WindowView.new(@app,id_alumno)
      new_view_cal.create
      new_view_cal.show(PLACEMENT_SCREEN)
    end
      def ventana_reg_doc()
        new_view_doc=WindowDocentes.new(app)
        new_view_doc.create
        new_view_doc.show(PLACEMENT_SCREEN)
      end
    def ventana_reg_alu()
      new_view_alu=Windowalumnos.new(app)
      new_view_alu.create
      new_view_alu.show(PLACEMENT_SCREEN)

    end
    def ventana_reg_mat()
      new_view_alu=Windowmaterias.new(app)
      new_view_alu.create
      new_view_alu.show(PLACEMENT_SCREEN)

    end
    def ventana_asig_mat()
      new_view_alu=WindowAsigmaterias.new(app)
      new_view_alu.create
      new_view_alu.show(PLACEMENT_SCREEN)

    end







  def create
    super
    show(PLACEMENT_SCREEN)
  end
end
