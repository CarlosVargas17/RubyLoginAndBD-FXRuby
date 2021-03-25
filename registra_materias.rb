require "fox16"
require 'mysql2'
require_relative 'window_view_materias'
require_relative 'delete_materia'
include Fox
class Windowmaterias <FXMainWindow

  def initialize(app)
    helvetica = FXFont.new(app, "helvetica", 10)
    helvetica2 = FXFont.new(app, "helvetica", 18)
    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"NEW", :icon => full_icon,:width=>600, :height=>400)
    full.backColor= FXRGB(208,189,241)
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    @conn=conn

    lbl_icon =FXPNGIcon.new(app , File.open("books.png", "rb").read)
    lbl_img=FXLabel.new( self,"", lbl_icon,:opts=>LAYOUT_EXPLICIT, :width=>200, :height=>208, :x=>380, :y=>80)
    lbl_img.icon =lbl_icon
    lbl_img.backColor= FXRGB(208,189,241)

    lbl=FXLabel.new( self,"REGISTRO DE MATERIAS", :opts=>LAYOUT_EXPLICIT, :width=>560, :height=>50, :x=>20, :y=>10)
    lbl.font = helvetica2
    lbl.backColor= FXRGB(117,153,222)

    lbl_Name=FXLabel.new( self,"NOMBRE:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>90, :height=>50, :x=>45, :y=>70)
    lbl_Name.font =helvetica
    lbl_Name.backColor=FXRGB(208,189,241)
    @input_Name=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>80)



    button_Regis_icon =FXPNGIcon.new(app, File.open("yes.png", "rb").read)
    button_Regis=FXButton.new(self ,"Registrar Materia",:icon => button_Regis_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>22, :y=>300)
    button_Regis.font=helvetica
    button_Regis.backColor= FXRGB(60, 169, 255)
    button_Regis.textColor = FXRGB(255,255,255)
    button_Regis.iconPosition = ICON_BEFORE_TEXT

    button_Visual_icon =FXPNGIcon.new(app, File.open("visual_icon.png", "rb").read)
    button_Visual=FXButton.new(self ,"  Ver Materias",:icon => button_Visual_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>200, :y=>300)
    button_Visual.font=helvetica
    button_Visual.backColor= FXRGB(60, 169, 255)
    button_Visual.textColor = FXRGB(255,255,255)
    button_Visual.iconPosition = ICON_BEFORE_TEXT

    button_Delete_icon =FXPNGIcon.new(app, File.open("delete.png", "rb").read)
    button_Delete=FXButton.new(self ,"  Eliminar Materia",:icon => button_Delete_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>378, :y=>300)
    button_Delete.font=helvetica
    button_Delete.backColor= FXRGB(190,51,36)
    button_Delete.textColor = FXRGB(255,255,255)
    button_Delete.iconPosition = ICON_BEFORE_TEXT
    button_Delete.connect(SEL_COMMAND) do
      eliminar_mat
    end

    button_Regis.connect(SEL_COMMAND) do
      nombre=@input_Name.text
      regis_materia(nombre)
    end
    button_Visual.connect(SEL_COMMAND) do
      ver_materias
    end
    
  end

  def eliminar_mat
    new_docen=WindowdeleteMat.new(app)
    new_docen.create
    new_docen.show(PLACEMENT_SCREEN)

  end

  def regis_materia(nombre)
    lista=[nombre]
    activador=0
    for i in lista
      if i ==""
        activador+=1
      end
    end
    if activador>0
      FXMessageBox.information(self,MBOX_OK,"Atención","No ha insertado información")
    else
      ex=existente(nombre)
      if ex>=1
        FXMessageBox.information(self,MBOX_OK,"Atención","Ya tiene asignada una materia igual a #{nombre}, cambiela")
      else
        consulta="INSERT INTO materias (Nombre_Materia) VALUES ('#{nombre}')"
        results=@conn.query(consulta)
        FXMessageBox.information(self,MBOX_OK,"Atención","Materia registrada correctamente")
        clean_inputs
      end
    end
  end

  def existente(nombre)
    consulta=" SELECT nombre_materia from materias where Nombre_Materia='#{nombre}'"
    results=@conn.query(consulta)
    ex=0
    results.each do |row|
      ex=ex+1
    end
    return ex
  end

  def clean_inputs
    @input_Name.text=""
  end


  def ver_materias
    new_mat=WindowViewMat.new(app)
    new_mat.create
    new_mat.show(PLACEMENT_SCREEN)

  end



  def create
    super
    show(PLACEMENT_SCREEN)
  end

end
