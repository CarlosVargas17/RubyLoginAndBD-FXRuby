
require "fox16"
require 'mysql2'
include Fox
class WindowViewMat < FXMainWindow
  def initialize(app)

    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"Lista de Materias", :icon => full_icon,:width=>650, :height=>300)
    full.backColor= FXRGB(166,189,241)


    helvetica2 = FXFont.new(app, "helvetica", 14)
    lbl_title=FXLabel.new( self,"Materias", :opts=>MATRIX_BY_COLUMNS|LAYOUT_FILL_X, :width=>600, :height=>50, :x=>0, :y=>5)
    lbl_title.font =helvetica2
    lbl_title.backColor= FXRGB(117,153,222)
    lista=[]
    c=0
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    consulta="SELECT * from materias"
    results=conn.query(consulta)

    results.each do |row|
      id=row["ID_Materia"]
      name=row["Nombre_Materia"]

      lista.push([id,name])
      c+=1
    end
    puts lista




    @tabla=FXTable.new(self,:opts=>LAYOUT_EXPLICIT,:width=>600,:height=>136,:x=>20,:y=>50)
    @tabla.visibleColumns=2
    @tabla.visibleRows=c
    @tabla.setTableSize(c,2)
    @tabla.editable=false
    @tabla.rowHeaderWidth = 30

    @tabla.setColumnText(0,"ID")
    @tabla.setColumnText(1,"Nombre")
    @tabla.setCellColor(0, 0, FXRGB(207, 237, 184))
    @tabla.setCellColor(0, 1, FXRGB(186, 234, 150))
    i=0
    while i<c
      id=lista[i][0]
      nombre=lista[i][1]
      @tabla.setItemText(i,0,"#{id}")
      @tabla.setItemText(i,1,"#{nombre}")


      i=i+1
    end

  end




  def create
    super
    show(PLACEMENT_SCREEN)
  end

end



