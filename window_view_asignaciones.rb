
require "fox16"
require 'mysql2'
include Fox
class WindowViewasig < FXMainWindow
  def initialize(app)

    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
        x_icon=FXPNGIcon.new(app, File.open("cancelar.png", "rb").read)
    
    full=super(app,"Lista de Asignaciones", :icon => full_icon,:width=>750, :height=>300)
        full.backColor= FXRGB(166,189,241)


    helvetica2 = FXFont.new(app, "helvetica", 14)
    lbl_title=FXLabel.new( self,"Asignaciones", :opts=>MATRIX_BY_COLUMNS|LAYOUT_FILL_X, :width=>600, :height=>60, :x=>0, :y=>5)
    lbl_title.font =helvetica2
    lbl_title.backColor= FXRGB(117,153,222)
    lista=[]
    c=0
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    consulta="SELECT * from asignaciones"
    results=conn.query(consulta)

    results.each do |row|
      id=row["ID_Asignacion"]
      materia=row['ID_Materia']
      maestro=row['ID_Maestro']
      alumno=row['ID_Alumno']
      lista.push([id,materia,maestro,alumno])
      c+=1
    end

    lista2=[]
    c2=0
    consulta2="SELECT * from materias"
    results2=conn.query(consulta2)

    results2.each do |row|
      id=row["ID_Materia"]
      materia=row['Nombre_Materia']
      lista2.push([id,materia])
      c2+=1
    end


    lista3=[]
    c3=0
    consulta3="SELECT * from maestros"
    results3=conn.query(consulta3)

    results3.each do |row|
      id=row["ID_Maestro"]
      maestro=row['Username']
      name=row['Nombre']
      ape=row['Apellido']
      lista3.push([id,maestro,(name+' '+ape)])
      c3+=1
    end

    lista4=[]
    c4=0
    consulta4="SELECT * from alumnos"
    results4=conn.query(consulta4)
    results4.each do |row|
      id=row["ID_Alumno"]
      alumno=row['Username']
      name=row['Nombre']
      ape=row['Apellido']
      lista4.push([id,alumno,(name+' '+ape)])
      c4+=1
    end


    listamat=[]
    listamat2=[]
    listamat3=[]
    listamat4=[]
    listamat5=[]
    for i in (0..lista.length-1)
      for j in (0..lista2.length-1)
        if lista[i][1]==lista2[j][0]
          listamat.push(lista2[j][1])
        end
      end
      for k in (0..lista3.length-1)
        if lista[i][2]==lista3[k][0]
          listamat2.push(lista3[k][1])
          listamat5.push(lista3[k][2])
        end
      end
      for l in (0..lista4.length-1)
        if lista[i][3]==lista4[l][0]
          listamat3.push(lista4[l][1])
          listamat4.push(lista4[l][2])
        end
      end
    end


    @tabla=FXTable.new(self,:opts=>LAYOUT_EXPLICIT,:width=>690,:height=>135,:x=>30,:y=>50)
    @tabla.visibleColumns=6
    @tabla.visibleRows=c
    @tabla.setTableSize(c,6)
    @tabla.editable=false
    @tabla.rowHeaderWidth = 0

    @tabla.setColumnText(0,"ID")
    @tabla.setColumnText(1,"Materia")
    @tabla.setColumnText(2,"ID Maestro")
    @tabla.setColumnText(3,"Nombre del Maestro")
    @tabla.setColumnText(4,"N° de Control")
    @tabla.setColumnText(5,"Nombre del alumno")
    @tabla.setCellColor(0, 0, FXRGB(207, 237, 184))
    @tabla.setCellColor(0, 1, FXRGB(186, 234, 150))
    @tabla.setColumnWidth(0,30)
    @tabla.setColumnWidth(1,200)
    @tabla.setColumnWidth(3,120)
    @tabla.setColumnWidth(5,120)
    i=0
    while i<c
      id=lista[i][0]
      @tabla.setItemText(i,0,"#{id}")
      materia=listamat[i]
      @tabla.setItemText(i,1,"#{materia}")
      maestro=listamat2[i]
      @tabla.setItemText(i,2,"#{maestro}")
      maestro2=listamat5[i]
      @tabla.setItemText(i,3,"#{maestro2}")
      alumno=listamat3[i]
      @tabla.setItemText(i,4,"#{alumno}")
      alumno2=listamat4[i]
      @tabla.setItemText(i,5,"#{alumno2}")
      i=i+1
      end

  end




  def create
    super
    show(PLACEMENT_SCREEN)
  end

end



