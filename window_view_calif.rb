require "fox16"
require 'mysql2'
include Fox
class WindowViewA < FXMainWindow
  def initialize(app,id_maestro,materia,id_materia)
    @materia=materia
    @id_maestro=id_maestro
    @id_materia=id_materia

    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"Calificaciones de alumnos", :icon => full_icon,:width=>650, :height=>300)
    full.backColor= FXRGB(166,189,241)


    helvetica2 = FXFont.new(app, "helvetica", 14)
    lbl_title=FXLabel.new( self,"Calificaciones de la materia  #{@materia}", :opts=>MATRIX_BY_COLUMNS|LAYOUT_FILL_X, :width=>600, :height=>50, :x=>0, :y=>5)
    lbl_title.font =helvetica2
    lbl_title.backColor= FXRGB(117,153,222)

    arreglo_data,c=consultar_calificaciones
    @tabla=FXTable.new(self,:opts=>LAYOUT_EXPLICIT,:width=>600,:height=>136,:x=>20,:y=>50)
    @tabla.visibleColumns=5
    @tabla.visibleRows=c
    @tabla.setTableSize(c,5)
    @tabla.editable=false
    @tabla.rowHeaderWidth = 50

    @tabla.setColumnText(0,"No Control")
    @tabla.setColumnText(1,"Nombre")
    @tabla.setColumnText(2,"Apellido")
    @tabla.setColumnText(3,"Carrera")
    @tabla.setColumnText(4,"Calificación")

    i=0



    while i<c
      user=arreglo_data[i][0]
      nombre=arreglo_data[i][1]
      apellido=arreglo_data[i][2]
      carrer=arreglo_data[i][3]
      cali=arreglo_data[i][4]


      val=i+1
      @tabla.setRowText(i,"#{val}")
      @tabla.setItemText(i,0,user)
      @tabla.setItemText(i,1,nombre)
      @tabla.setItemText(i,2,apellido)
      @tabla.setItemText(i,3,carrer)
      @tabla.setItemText(i,4,cali)
      @tabla.setCellColor(i, 0, FXRGB(207, 237, 184))
      @tabla.setCellColor(i, 1, FXRGB(186, 234, 150))
      i=i+1


    end




  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def consultar_calificaciones
    c=0
    arreglo_data=[]
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    consulta="SELECT c.calificacion, a.Nombre, a.Apellido, a.Username, a.Carrera from  alumnos a INNER JOIN calificaciones c ON (a.ID_ALUMNO=c.ID_ALUMNO)WHERE c.ID_Materia=#{@id_materia}"
    results=conn.query(consulta)
    results.each do |row|
      c=c+1
      calif=row["calificacion"]
      name=row["Nombre"]
      apell=row["Apellido"]
      user=row["Username"]
      carrera=row["Carrera"]
      puts"Here", arreglo_data
      arreglo_data.push([user,name,apell,carrera,calif])
    end
    return arreglo_data,c
  end

end





#app=FXApp.new
#WindowView.new(app)
#app.create
#app.run