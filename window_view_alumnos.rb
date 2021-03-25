
require "fox16"
require 'mysql2'
include Fox
class WindowViewAlum < FXMainWindow
  def initialize(app)

    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"Lista de alumnos", :icon => full_icon,:width=>650, :height=>300)
    full.backColor= FXRGB(166,189,241)


    helvetica2 = FXFont.new(app, "helvetica", 14)
    lbl_title=FXLabel.new( self,"ALUMNOS", :opts=>MATRIX_BY_COLUMNS|LAYOUT_FILL_X, :width=>600, :height=>50, :x=>0, :y=>5)
    lbl_title.font =helvetica2
    lbl_title.backColor= FXRGB(117,153,222)
    lista=[]
    c=0
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    consulta="SELECT * from alumnos"
    results=conn.query(consulta)

    results.each do |row|
      id=row["ID_Alumno"]
      name=row["Nombre"]
      ape=row["Apellido"]
      user=row["Username"]
      carr=row["Carrera"]

      lista.push([id,name,ape,user,carr])
      c+=1
    end
    puts lista




    @tabla=FXTable.new(self,:opts=>LAYOUT_EXPLICIT,:width=>600,:height=>136,:x=>20,:y=>50)
    @tabla.visibleColumns=5
    @tabla.visibleRows=c
    @tabla.setTableSize(c,5)
    @tabla.editable=false
    @tabla.rowHeaderWidth = 0

    @tabla.setColumnText(0,"ID")
    @tabla.setColumnText(1,"Nombre")
    @tabla.setColumnText(2,"Apellido")
    @tabla.setColumnText(3,"Username")
    @tabla.setColumnText(4,"Carrera")
    @tabla.setCellColor(0, 0, FXRGB(207, 237, 184))
    @tabla.setCellColor(0, 1, FXRGB(186, 234, 150))
    i=0
    while i<c
      id=lista[i][0]
      nombre=lista[i][1]
      apellido=lista[i][2]
      user=lista[i][3]
      carrera=lista[i][4]
      @tabla.setItemText(i,0,"#{id}")
      @tabla.setItemText(i,1,"#{nombre}")
      @tabla.setItemText(i,2,"#{apellido}")
      @tabla.setItemText(i,3,"#{user}")
      @tabla.setItemText(i,4,"#{carrera}")
      i=i+1
    end
  end



  def create
    super
    show(PLACEMENT_SCREEN)
  end

end



