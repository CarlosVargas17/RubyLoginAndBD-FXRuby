require "fox16"
require 'mysql2'
require_relative 'window_view_asignaciones'
include Fox
class WindowAsigmaterias <FXMainWindow

  def initialize(app)
    helvetica = FXFont.new(app, "helvetica", 10)
    helvetica2 = FXFont.new(app, "helvetica", 18)
    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)

    full=super(app,"NEW", :icon => full_icon,:width=>600, :height=>400)
    full.backColor= FXRGB(208,189,241)
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    @conn=conn

    lbl_icon =FXPNGIcon.new(app , File.open("backpack.png", "rb").read)
    lbl_img=FXLabel.new( self,"", lbl_icon,:opts=>LAYOUT_EXPLICIT, :width=>200, :height=>208, :x=>380, :y=>100)
    lbl_img.icon =lbl_icon
    lbl_img.backColor= FXRGB(208,189,241)

    lbl=FXLabel.new( self,"ASIGNACIÓN DE MATERIAS", :opts=>LAYOUT_EXPLICIT, :width=>560, :height=>50, :x=>20, :y=>10)
    lbl.font = helvetica2
    lbl.backColor= FXRGB(117,153,222)

    lbl_Mat=FXLabel.new( self,"MATERIA:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>90, :height=>50, :x=>45, :y=>70)
    lbl_Mat.font =helvetica
    lbl_Mat.backColor=FXRGB(208,189,241)

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



    lbl_Mto=FXLabel.new( self,"DOCENTE:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>90, :height=>50, :x=>45, :y=>110)
    lbl_Mto.font =helvetica
    lbl_Mto.backColor=FXRGB(208,189,241)

    arreglo2,c2=consulta_docentes
    @combo2=FXComboBox.new(self ,c2,:opts=>LAYOUT_EXPLICIT|TEXTFIELD_NORMAL,:width=>200,:height=>30,:x=>150,:y=>120)
    @combo2.numVisible=c2
    @combo2.editable =false
    j=0
    while j<c2
      docente=arreglo2[j][0]
      @combo2.appendItem(docente)
      j=j+1
    end



    lbl_Alu=FXLabel.new( self,"ALUMNO:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>90, :height=>50, :x=>45, :y=>150)
    lbl_Alu.font =helvetica
    lbl_Alu.backColor=FXRGB(208,189,241)

    arreglo3,c3=consulta_alumnos
    @combo3=FXComboBox.new(self ,c3,:opts=>LAYOUT_EXPLICIT|TEXTFIELD_NORMAL,:width=>200,:height=>30,:x=>150,:y=>160)
    @combo3.numVisible=c3
    @combo3.editable =false
    k=0
    while k<c3
      alumno=arreglo3[k][0]
      @combo3.appendItem(alumno)
      k=k+1
    end








    button_Regis_icon =FXPNGIcon.new(app, File.open("yes.png", "rb").read)
    button_Regis=FXButton.new(self ,"Asignar Materia",:icon => button_Regis_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>22, :y=>300)
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

    button_Regis.connect(SEL_COMMAND) do

      asign_materia()
    end
    button_Visual.connect(SEL_COMMAND) do
      ver_materias
    end
    
  end

  def consulta_materias
    c=0
    arreglo=[]
    consulta="SELECT Nombre_Materia from materias"
    results=@conn.query(consulta)
    results.each do |row|
      c+=1
      name_materia=row["Nombre_Materia"]
      arreglo.push([name_materia])
    end
    return arreglo,c
  end

  def consulta_docentes
    c=0
    arreglo=[]
    consulta="SELECT * from maestros"
    results=@conn.query(consulta)
    results.each do |row|
      c+=1
      name_doc=row["Username"]
      arreglo.push([name_doc])
    end
    return arreglo,c
  end

  def consulta_alumnos
    c=0
    arreglo=[]
    consulta="SELECT * from alumnos"
    results=@conn.query(consulta)
    results.each do |row|
      c+=1
      name_alu=row["Username"]
      arreglo.push([name_alu])
    end
    return arreglo,c
  end



  def asign_materia()
    materia=@combo
    maestro=@combo2
    alumno=@combo3

    consulta0=" SELECT * from maestros where Username='#{maestro}'"
    results0=@conn.query(consulta0)
    id=[]
    results0.each do |row|
      id=row['ID_Maestro']
    end
    consulta1=" SELECT * from materias where Nombre_Materia='#{materia}'"
    results1=@conn.query(consulta1)
    id1=[]
    results1.each do |row|
      id1=row['ID_Materia']
    end
    consulta2=" SELECT * from alumnos where Username='#{alumno}'"
    results2=@conn.query(consulta2)
    id2=[]
    results2.each do |row|
      id2=row['ID_Alumno']
    end
    puts id1,id,id2

    idmateria=id1
    idmaestro=id
    idalumno=id2

    lista=[materia,maestro,alumno]
    activador=0
    for i in lista
      if i ==""
        activador+=1
      end
    end
    if activador>0
      FXMessageBox.information(self,MBOX_OK,"Atención","No ha insertado información")
    else
      ex=existente(idmateria,idmaestro,idalumno)
      if ex>=1
        answer=FXMessageBox.question(self,MBOX_YES_NO,"Atención","Ya tiene asignado a un docente en la materia  #{materia}, ¿deseas actualizarlo?")
        if answer == MBOX_CLICKED_YES
          consu=" SELECT * from asignaciones where ID_Materia='#{idmateria}'"
          resul=@conn.query(consu)
          lis=[]
          co=0
          resul.each do |row|
            co+=1
            lis.push(row['ID_Asignacion'])
          end
          for op in (0..co)
            opc=lis[op]
            actualizar="UPDATE asignaciones SET ID_Maestro = '#{idmaestro}' WHERE ID_Asignacion = '#{opc}'"
            results=@conn.query(actualizar)
          end

          FXMessageBox.information(self,MBOX_OK,"Atención","Docente actualizado")
          clean_inputs

        else
          clean_inputs
        end
      else
        ex2=existente2(materia,maestro,alumno,idmateria,idmaestro,idalumno)
        if ex2>=1
          FXMessageBox.information(self,MBOX_OK,"Atención","#{materia} ya fue asignada a #{alumno} y ya es impartida por #{maestro}.")
        else
          consulta="INSERT INTO asignaciones (ID_Materia,ID_Maestro,ID_Alumno) VALUES ('#{id1}','#{id}','#{id2}')"
          results=@conn.query(consulta)
          FXMessageBox.information(self,MBOX_OK,"Atención","Materia asignada correctamente")
          clean_inputs
        end

      end
    end
  end

  def existente(materia,maestro,alumno)
    consulta2="SELECT * from asignaciones WHERE ID_Materia='#{materia}'"
    results2=@conn.query(consulta2)
    ex2=0
    maes=[]
    mat=[]
    results2.each do |row|
      maes=row['ID_Maestro']
      mat=row['ID_Materia']
    end
    if maes!=maestro and mat==materia
      ex2+=1
    end
    return ex2
  end

  def clean_inputs
    @combo.text=""
    @combo2.text=""
    @combo3.text=""
  end

  def existente2(materia,maestro,alumno,idmateria,idmaestro,idalumno)
    consulta0=" SELECT * from maestros where Username='#{maestro}'"
    results0=@conn.query(consulta0)
    id=[]
    results0.each do |row|
      id=row['ID_Maestro']
    end
    consulta1=" SELECT * from materias where Nombre_Materia='#{materia}'"
    results1=@conn.query(consulta1)

    id1=[]
    results1.each do |row|
      id1=row['ID_Materia']
    end
    consulta2=" SELECT * from alumnos where Username='#{alumno}'"
    results2=@conn.query(consulta2)
    id2=[]
    results2.each do |row|
      id2=row['ID_Alumno']
    end


    consulta3=" SELECT * from asignaciones WHERE ID_Materia='#{id1}' and ID_Maestro='#{id}' and ID_Alumno='#{id2}'"
    results3=@conn.query(consulta3)
    ex2=0
    results3.each do |row|
      ex2=ex2+1
    end
    return ex2
  end



  def ver_materias
    new_mat=WindowViewasig.new(app)
    new_mat.create
    new_mat.show(PLACEMENT_SCREEN)

  end



  def create
    super
    show(PLACEMENT_SCREEN)
  end

end



