require "fox16"
require 'mysql2'
require_relative 'window_alumno'
require_relative 'window_view_calif'
include Fox
class WindowCalificar < FXMainWindow
  def initialize(app,id_maestro)

    @app=app
    @id_maestro=id_maestro
    helvetica = FXFont.new(app, "helvetica", 10)
    helvetica2 = FXFont.new(app, "helvetica", 18)

    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"NEW", :icon => full_icon,:width=>600, :height=>400)
    full.backColor= FXRGB(166,189,241)
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    @conn=conn

    lbl_icon =FXPNGIcon.new(app , File.open("calif_icon.png", "rb").read)
    lbl_img=FXLabel.new( self,"", lbl_icon,:opts=>LAYOUT_EXPLICIT, :width=>200, :height=>208, :x=>380, :y=>170)
    lbl_img.icon =lbl_icon
    lbl_img.backColor= FXRGB(166,189,241)

    lbl=FXLabel.new( self,"CALIFICACIONES", :opts=>LAYOUT_EXPLICIT, :width=>560, :height=>50, :x=>20, :y=>10)
    lbl.font = helvetica2
    lbl.backColor= FXRGB(117,153,222)

    lbl_Asig=FXLabel.new( self,"ASIGNATURA:", :opts=>LAYOUT_EXPLICIT, :width=>90, :height=>50, :x=>35, :y=>70)
    lbl_Asig.font =helvetica
    lbl_Asig.backColor=FXRGB(166,189,241)

    lbl_Ctrl=FXLabel.new( self,"NO. CONTROL:", :opts=>LAYOUT_EXPLICIT, :width=>120, :height=>50, :x=>15, :y=>110)
    lbl_Ctrl.font =helvetica
    lbl_Ctrl.backColor=FXRGB(166,189,241)

    @input_Ctrl=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>120)
    @input_Ctrl.editable=false

    button_Ctrl=FXButton.new(self ,"+",:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>30, :height=>30,:x=>355, :y=>120)
    button_Ctrl.font=helvetica
    button_Ctrl.backColor= FXRGB(97, 166, 60)
    button_Ctrl.textColor = FXRGB(255,255,255)

    lbl_Alum=FXLabel.new( self,"NOMBRE:", :opts=>LAYOUT_EXPLICIT, :width=>120, :height=>50, :x=>30, :y=>150)
    lbl_Alum.font =helvetica
    lbl_Alum.backColor=FXRGB(166,189,241)

    @input_Alum=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>160)
    @input_Alum.editable=false

    lbl_Carr=FXLabel.new( self,"CARRERA:", :opts=>LAYOUT_EXPLICIT, :width=>120, :height=>50, :x=>24, :y=>190)
    lbl_Carr.font =helvetica
    lbl_Carr.backColor=FXRGB(166,189,241)

    @input_Carr=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X|TEXTFIELD_NORMAL, :width=>200, :height=>30,:x=>150, :y=>200)
    @input_Carr.editable=false

    lbl_Cali=FXLabel.new( self,"CALIFICACIÓN:", :opts=>LAYOUT_EXPLICIT, :width=>120, :height=>50, :x=>16, :y=>230)
    lbl_Cali.font =helvetica
    lbl_Cali.backColor=FXRGB(166,189,241)

    @input_Calif=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X|TEXTFIELD_NORMAL, :width=>100, :height=>30,:x=>150, :y=>240)

    button_Regis_icon =FXPNGIcon.new(app, File.open("yes.png", "rb").read)
    button_Regis=FXButton.new(self ,"Registrar calificación",:icon => button_Regis_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>22, :y=>300)
    button_Regis.font=helvetica
    button_Regis.backColor= FXRGB(166, 60, 147)
    button_Regis.textColor = FXRGB(255,255,255)
    button_Regis.iconPosition = ICON_BEFORE_TEXT

    button_Visual_icon =FXPNGIcon.new(app, File.open("visual_icon.png", "rb").read)
    button_Visual=FXButton.new(self ,"  Ver calificaciones",:icon => button_Visual_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>200, :y=>300)
    button_Visual.font=helvetica
    button_Visual.backColor= FXRGB(166, 60, 147)
    button_Visual.textColor = FXRGB(255,255,255)
    button_Visual.iconPosition = ICON_BEFORE_TEXT



    arreglo,c=consulta_materias
    @combo=FXComboBox.new(self ,c,:opts=>LAYOUT_EXPLICIT|TEXTFIELD_NORMAL,:width=>200,:height=>30,:x=>150,:y=>80)
    @combo.numVisible=c
    @combo.editable =false
    i=0
    while i<c
      materia=arreglo[i][0]
      @combo.appendItem(materia)
      i=i+1
    end


    button_Ctrl.connect(SEL_COMMAND) do
      search_alumn(id_maestro)
    end


    button_Visual.connect(SEL_COMMAND) do
      ver_calificaciones
    end

    button_Regis.connect(SEL_COMMAND) do
      arreglo_id=consultar_id_materia
      if arreglo_id==[]
        id_materia=""
      else
        id_materia=arreglo_id[0][0]
      end

      arreglo_alu=consultar_id_alumno
      if arreglo_alu==[]
        id_alumno=""
      else
        id_alumno=arreglo_alu[0][0]
      end
      calificacion=@input_Calif.text
      carrera=@input_Carr.text
      registrar_calificacion(id_materia,id_maestro,id_alumno,calificacion,carrera)
    end

  end




  def consulta_materias
    c=0
    arreglo=[]
    consulta="SELECT DISTINCT m.Nombre_Materia from materias m INNER JOIN asignaciones a ON  m.ID_Materia=a.ID_Materia where a.ID_Maestro=#{@id_maestro}"
    results=@conn.query(consulta)
    results.each do |row|
      c+=1
      name_materia=row["Nombre_Materia"]
      arreglo.push([name_materia])
    end
    return arreglo,c
  end


  def consultar_id_materia
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


  def consultar_id_alumno
    arreglo_alum=[]
    no_control=@input_Ctrl.text
    consulta="SELECT ID_Alumno from alumnos where Username='#{no_control}'"
    results=@conn.query(consulta)
    results.each do |row|
      id_alum=row["ID_Alumno"]
      arreglo_alum.push([id_alum])
    end
    return arreglo_alum
  end


  def registrar_calificacion(id_materia,id_maestro,id_alumno,calificacion,carrera)
    list=[id_materia,id_maestro,id_alumno,calificacion,carrera]
    print"LISTA #{list}"
    active=0
    for i in list
      if i==""
        active=1
      end
    end
    if active==1
       FXMessageBox.information(self,MBOX_OK,"Atención","Hay campos vacios")
    else
       ex,calif=existente(id_materia,id_maestro,id_alumno)
       if ex>=1
         answer=FXMessageBox.question(self,MBOX_YES_NO,"Atención","Ya tiene asignada una calificacion de #{calif}, ¿deseas actualizarla?")
         if answer == MBOX_CLICKED_YES
           actualizar="UPDATE calificaciones SET calificacion=#{calificacion} WHERE ID_Alumno=#{id_alumno} AND ID_Materia=#{id_materia} AND ID_Maestro=#{id_maestro}"
           results=@conn.query(actualizar)
           FXMessageBox.information(self,MBOX_OK,"Atención","Calificacion actualizada")
           clean_inputs
         else
           clean_inputs
         end

       else
         consulta="INSERT INTO calificaciones (ID_Materia,ID_Maestro,ID_Alumno,Calificacion) VALUES ('#{id_materia}','#{id_maestro}','#{id_alumno}','#{calificacion}')"
         results=@conn.query(consulta)
         FXMessageBox.information(self,MBOX_OK,"Atención","Calificación registrada correctamente")
         clean_inputs
       end
    end
  end

  def search_alumn(id_maestro)
    materia=@combo.text
    input_C=@input_Ctrl
    input_A=@input_Alum
    input_Carr=@input_Carr
    new_win_search=Alumnos.new(@app,id_maestro,materia,input_C,input_A,input_Carr)
    new_win_search.create
    new_win_search.show(PLACEMENT_SCREEN)
  end

  def ver_calificaciones
    arreglo_id=consultar_id_materia
    materia=@combo.text
    id_materia=arreglo_id[0][0]
    new_win_califi=WindowViewA.new(@app,@id_maestro,materia,id_materia)
    new_win_califi.create
    new_win_califi.show(PLACEMENT_SCREEN)
  end

  def existente(id_materia,id_maestro,id_alumno)
    consulta=" SELECT calificacion from calificaciones where ID_Materia=#{id_materia} and ID_Maestro=#{id_maestro} and ID_Alumno=#{id_alumno}"
    results=@conn.query(consulta)
    ex=0
    results.each do |row|
      ex=ex+1
      @calif=row["calificacion"]
    end
    return ex,@calif
  end


  def clean_inputs
    @input_Ctrl.text=""
    @input_Calif.text=""
    @input_Alum.text=""
    @input_Carr.text=""
  end


  def create
    super
    show(PLACEMENT_SCREEN)
  end

end

#app=FXApp.new
#WindowCalificar.new(app)
#app.create
#app.run