require "fox16"
require 'mysql2'
include Fox
class Alumnos < FXMainWindow
  def initialize(app,id_maestro,materia,input_C,input_A,input_Carr)

    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
        x_icon=FXPNGIcon.new(app, File.open("cancelar.png", "rb").read)
    
    full=super(app,"Dashboard", :icon => full_icon,:width=>550, :height=>200)
    full.backColor= FXRGB(198,241,166)
    @input_Ctrl=input_C
    @input_Alum=input_A
    @input_Carr=input_Carr
    print"id_maestro:#{id_maestro},#{materia}"
    helvetica = FXFont.new(app, "helvetica", 10)
    helvetica2 = FXFont.new(app, "helvetica", 10)

    lbl_title=FXLabel.new( self,"NO. CONTROL DE ALUMNOS INSCRITOS A #{materia.upcase}", :opts=>LAYOUT_EXPLICIT, :width=>520, :height=>50, :x=>15, :y=>5)
    lbl_title.font =helvetica2
    lbl_title.backColor= FXRGB(166,211,132)

    lbl_estu=FXLabel.new( self,"NO. CONTROL:", :opts=>LAYOUT_EXPLICIT, :width=>120, :height=>50, :x=>20, :y=>55)
    lbl_estu.font =helvetica
    lbl_estu.backColor= FXRGB(198,241,166)

    ida_materia=consultar_id_materia(materia)
    id_materia=ida_materia[0][0]

    arreglo,c=consulta_alumnos_ctrl(id_materia,id_maestro)
    @combo_ctrl=FXComboBox.new(self ,c,:opts=>LAYOUT_EXPLICIT|TEXTFIELD_NORMAL,:width=>200,:height=>30,:x=>150,:y=>70)
    @combo_ctrl.numVisible=c
    @combo_ctrl.editable =false
    a=0
    while a<c
      no_control=arreglo[a][1]
      @combo_ctrl.appendItem(no_control)
      a=a+1
    end

    button_Acept=FXButton.new(self ,"Aceptar",:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>100, :height=>30,:x=>22, :y=>120)
    button_Acept.font=helvetica
    button_Acept.backColor= FXRGB(97, 166, 60)
    button_Acept.textColor = FXRGB(255,255,255)

    button_Acept.connect(SEL_COMMAND) do
      aceptar()
    end

    button_Cancel=FXButton.new(self ,"Cancelar",:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>100, :height=>30,:x=>150, :y=>120)
    button_Cancel.font=helvetica
    button_Cancel.backColor= FXRGB(60, 92, 166)
    button_Cancel.textColor = FXRGB(255,255,255)

    button_Cancel.connect(SEL_COMMAND) do
      cancelar()
    end




  end

  def consulta_alumnos_ctrl(id_materia,id_maestro)
    c=0
    arreglo_students=[]
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    consulta="SELECT a.ID_Alumno, s.Username, s.Nombre, s.Apellido from asignaciones a INNER JOIN alumnos s ON s.ID_Alumno=a.ID_Alumno where a.ID_Maestro=#{id_maestro} and a.ID_Materia='#{id_materia}'"
    results=conn.query(consulta)
    results.each do |row|
      c=c+1
      id_alumno=row["ID_Alumno"]
      username=row["Username"]
      nombre=row["Nombre"]
      apellido=row["Apellido"]
      arreglo_students.push([id_alumno,username,nombre,apellido])
    end
    return arreglo_students,c
  end

  def aceptar
    control=@combo_ctrl.text
    arreglo_data=consultar_datos(control)
    name=arreglo_data[0][0]
    apell=arreglo_data[0][1]
    carrer=arreglo_data[0][2]
    name_apell="#{name} #{apell}"
    @input_Ctrl.text=control
    @input_Alum.text=name_apell
    @input_Carr.text=carrer
    puts name_apell
    self.close
  end

  def cancelar
    self.close
  end

  def consultar_datos(control)
    c=0
    arreglo_data=[]
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    consulta="SELECT Nombre, Apellido,Carrera from alumnos  where Username='#{control}'"
    results=conn.query(consulta)
    results.each do |row|
      c=c+1
      nombre=row["Nombre"]
      apellido=row["Apellido"]
      carrera=row["Carrera"]
      arreglo_data.push([nombre,apellido,carrera])
    end
    return arreglo_data

  end

  def consultar_id_materia(materia)
    ida_materia=[]
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    consulta="SELECT ID_Materia from materias  where Nombre_Materia='#{materia}'"
    results=conn.query(consulta)
    results.each do |row|
      id=row["ID_Materia"]
      ida_materia.push([id])
    end
    return  ida_materia
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end