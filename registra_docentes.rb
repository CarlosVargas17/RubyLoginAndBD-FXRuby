require "fox16"
require 'mysql2'
require_relative 'window_view_docentes'
require_relative 'delete_docente'
include Fox
class WindowDocentes <FXMainWindow

  def initialize(app)
    helvetica = FXFont.new(app, "helvetica", 10)
    helvetica2 = FXFont.new(app, "helvetica", 18)
    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    x_icon=FXPNGIcon.new(app, File.open("cancelar.png", "rb").read)


    full=super(app,"NEW", :icon => full_icon,:width=>600, :height=>400)
    full.backColor= FXRGB(208,189,241)
    

    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    @conn=conn

    lbl_icon =FXPNGIcon.new(app , File.open("profesor2.png", "rb").read)
    lbl_img=FXLabel.new( self,"", lbl_icon,:opts=>LAYOUT_EXPLICIT, :width=>200, :height=>208, :x=>380, :y=>80)
    lbl_img.icon =lbl_icon
    lbl_img.backColor= FXRGB(208,189,241)

    lbl=FXLabel.new( self,"REGISTRO DE DOCENTES", :opts=>LAYOUT_EXPLICIT, :width=>560, :height=>50, :x=>20, :y=>10)
    lbl.font = helvetica2
    lbl.backColor= FXRGB(117,153,222)

    lbl_Name=FXLabel.new( self,"NOMBRE:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>90, :height=>50, :x=>45, :y=>70)
    lbl_Name.font =helvetica
    lbl_Name.backColor=FXRGB(208,189,241)
    @input_Name=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>80)

    lbl_Apellido=FXLabel.new( self,"APELLIDO:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>120, :height=>50, :x=>30, :y=>110)
    lbl_Apellido.font =helvetica
    lbl_Apellido.backColor=FXRGB(208,189,241)

    @input_Ape=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>120)

    lbl_Username=FXLabel.new( self,"USERNAME:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>120, :height=>50, :x=>30, :y=>150)
    lbl_Username.font =helvetica
    lbl_Username.backColor=FXRGB(208,189,241)

    @input_User=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>160)


    lbl_Password=FXLabel.new( self,"CONTRASEÑA:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>120, :height=>50, :x=>30, :y=>190)
    lbl_Password.font =helvetica
    lbl_Password.backColor=FXRGB(208,189,241)

    @input_Pwd=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>200)



    button_Regis_icon =FXPNGIcon.new(app, File.open("yes.png", "rb").read)
    button_Regis=FXButton.new(self ,"Registrar docente",:icon => button_Regis_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>22, :y=>300)
    button_Regis.font=helvetica
    button_Regis.backColor= FXRGB(60, 169, 255)
    button_Regis.textColor = FXRGB(255,255,255)
    button_Regis.iconPosition = ICON_BEFORE_TEXT

    button_Visual_icon =FXPNGIcon.new(app, File.open("visual_icon.png", "rb").read)
    button_Visual=FXButton.new(self ,"  Ver docentes",:icon => button_Visual_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>200, :y=>300)
    button_Visual.font=helvetica
    button_Visual.backColor= FXRGB(60, 169, 255)
    button_Visual.textColor = FXRGB(255,255,255)
    button_Visual.iconPosition = ICON_BEFORE_TEXT

    button_Delete_icon =FXPNGIcon.new(app, File.open("delete.png", "rb").read)
    button_Delete=FXButton.new(self ,"  Eliminar Docente",:icon => button_Delete_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>378, :y=>300)
    button_Delete.font=helvetica
    button_Delete.backColor= FXRGB(190,51,36)
    button_Delete.textColor = FXRGB(255,255,255)
    button_Delete.iconPosition = ICON_BEFORE_TEXT
    button_Delete.connect(SEL_COMMAND) do
      eliminar_docente
    end

    button_Regis.connect(SEL_COMMAND) do
      nombre=@input_Name.text
      apellido=@input_Ape.text
      user=@input_User.text
      passw=@input_Pwd.text
      regis_docente(nombre,apellido,user,passw)
    end
    button_Visual.connect(SEL_COMMAND) do
      ver_docentes
    end





  end


  def regis_docente(nombre,apellido,user,passw)
    lista=[nombre,apellido,user,passw]
    activador=0
    for i in lista
      if i ==""
        activador+=1
      end

    end
    if activador>0
      FXMessageBox.information(self,MBOX_OK,"Atención","Hay campos vacios")
    else
      ex=existente(user)
      if ex>=1
        FXMessageBox.information(self,MBOX_OK,"Atención","Ya tiene asignado un usuario igual al de #{user}, cambielo")
      else
        consulta="INSERT INTO maestros (Nombre,Apellido,Username,Password) VALUES ('#{nombre}','#{apellido}','#{user}','#{passw}')"
        results=@conn.query(consulta)
        FXMessageBox.information(self,MBOX_OK,"Atención","Docente registrada correctamente")
        clean_inputs
      end
    end
  end

  def existente(user)
    consulta=" SELECT username from maestros where Username='#{user}'"
    results=@conn.query(consulta)
    ex=0
    results.each do |row|
      ex=ex+1
    end
    return ex
  end

  def clean_inputs
    @input_Name.text=""
    @input_Ape.text=""
    @input_User.text=""
    @input_Pwd.text=""
  end
  def eliminar_docente
    new_docen=WindowdeleteDoc.new(app)
    new_docen.create
    new_docen.show(PLACEMENT_SCREEN)

  end

  def ver_docentes
    new_docen=WindowViewDoc.new(app)
    new_docen.create
    new_docen.show(PLACEMENT_SCREEN)

  end

  def consultardocentes
    arreglo_id=[]
    materia=@combo.text
    consulta="SELECT DISTINCT m.ID_Materia from materias m INNER JOIN asignaciones a  ON m.ID_Materia=a.ID_Materia where a.ID_Maestro=#{@id_maestro} and m.Nombre_Materia='#{materia}'"
    results=@conn.query(consulta)
    results.each do |row|
      id_materia=row["ID_Materia"]
      arreglo_id.push([id_materia])
    end
    print"IDD #{arreglo_id}"
    return arreglo_id
  end


  def create
    super
    show(PLACEMENT_SCREEN)
  end

end
