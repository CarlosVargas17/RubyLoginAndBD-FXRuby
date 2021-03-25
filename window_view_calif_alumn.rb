require "fox16"
require 'mysql2'
include Fox
class WindowView < FXMainWindow
  def initialize(app,id_alumno)
    @id_alumno=id_alumno
    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
        x_icon=FXPNGIcon.new(app, File.open("cancelar.png", "rb").read)
    
    full=super(app,"Ver calificaciones",:icon => full_icon, :width=>600, :height=>400)
        full.backColor= FXRGB(166,189,241)
    helvetica = FXFont.new(app, "helvetica", 10)
    helvetica2 = FXFont.new(app, "helvetica", 12)

    @conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")

    lbl_title=FXLabel.new( self,"CALIFICACIONES GENERALES", :opts=>LAYOUT_EXPLICIT, :width=>600, :height=>50, :x=>0, :y=>5)
    lbl_title.font =helvetica2
    lbl_title.backColor= FXRGB(117,153,222)

    arreglo=buscar_informacion
    value=arreglo[0][0]

    lbl_perso=FXLabel.new( self,"  INFORMACIÓN PERSONAL", :opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT, :width=>365, :height=>40, :x=>20, :y=>70)
    lbl_perso.backColor= FXRGB(117,153,222)

    lbl_name=FXLabel.new(self,"NOMBRE: #{value[0]}", :opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT, :width=>100, :height=>30, :x=>20, :y=>120)
    lbl_apell=FXLabel.new(self,"APELLIDO: #{value[1]}", :opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT, :width=>100, :height=>30, :x=>20, :y=>150)
    lbl_ctrl=FXLabel.new(self,"CLAVE: #{value[2]}", :opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT, :width=>100, :height=>30, :x=>20, :y=>180)
    lbl_carr=FXLabel.new(self,"CARRERA: #{value[3]}", :opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT, :width=>100, :height=>30, :x=>20, :y=>210)
    lbl_name.backColor=FXRGB(166,189,241)
    lbl_apell.backColor=FXRGB(166,189,241)
    lbl_ctrl.backColor=FXRGB(166,189,241)
    lbl_carr.backColor=FXRGB(166,189,241)



    lbl_icon =FXPNGIcon.new(app , File.open("calif_icon1.png", "rb").read)
    lbl_img=FXLabel.new( self,"", lbl_icon,:opts=>LAYOUT_EXPLICIT, :width=>200, :height=>208, :x=>390, :y=>45)
    lbl_img.icon =lbl_icon
    lbl_img.backColor=FXRGB(166,189,241)


    lbl_Contra=FXLabel.new(self,"CONTRASEÑA:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_LEFT, :width=>100, :height=>30, :x=>200, :y=>120)
    lbl_Contra.backColor=FXRGB(166,189,241)

    @pass=FXTextField.new(self,50, nil,0,:opts=>LAYOUT_EXPLICIT|JUSTIFY_CENTER_X|TEXTFIELD_NORMAL, :width=>150, :height=>30,:x=>200, :y=>150)
    button_Contra_icon =FXPNGIcon.new(app , File.open("contra.png", "rb").read)
    button_Contra=FXButton.new(self ,"+",:icon => button_Contra_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>30, :height=>30,:x=>355, :y=>150)
    button_Contra.font=helvetica
    button_Contra.backColor= FXRGB(97, 166, 60)
    button_Contra.textColor = FXRGB(255,255,255)

    button_Contra.connect(SEL_COMMAND) do
      pass=@pass.text
      if pass==""
        FXMessageBox.information(self,MBOX_OK,"Atención","Espacio en blanco")
      else
         actualizar_contrasena(pass)
      end
    end

    arreglo,c=buscar_calificaciones
    @tabla=FXTable.new(self,:opts=>LAYOUT_EXPLICIT,:width=>360,:height=>125,:x=>20,:y=>255)
    @tabla.visibleColumns=3
    @tabla.rowHeaderWidth = 0
    @tabla.visibleRows=c
    @tabla.setTableSize(c,3)

    @tabla.setColumnText(0,"ID")
    @tabla.setColumnWidth(0,50)
    @tabla.setColumnText(1,"Materia")
    @tabla.setColumnWidth(1,210)
    @tabla.setColumnText(2,"Calificación")

    @tabla.editable=false
    i=0

    while i<c
      id=arreglo[i][0]
      calificacion=arreglo[i][1]
      materia=arreglo[i][2]
      @tabla.setItemText(i,0,"#{id}")
      @tabla.setItemText(i,1,materia)
      @tabla.setItemText(i,2,calificacion)
      @tabla.setCellColor(0,0, FXRGB(207, 237, 184))
      @tabla.setCellColor(0,1, FXRGB(186, 234, 150))


      i=i+1
    end




  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def actualizar_contrasena(pass)
    answer=FXMessageBox.question(self,MBOX_YES_NO,"Atención","¿Estas seguro de actualizar la contraseña?")
    if answer == MBOX_CLICKED_YES
       consulta="UPDATE alumnos SET Password='#{pass}' where ID_Alumno=#{@id_alumno}"
       results=@conn.query(consulta)
       @pass.text=""
       FXMessageBox.information(self,MBOX_OK,"Atención","Contraseña actualizada")
    else
       @pass.text=""
    end


  end

  def buscar_informacion
    arreglo=[]
    c=0
    consulta="SELECT * from alumnos where ID_Alumno=#{@id_alumno}"
    results=@conn.query(consulta)
    results.each do |row|
      nombre=row["Nombre"]
      apellido=row["Apellido"]
      username=row["Username"]
      carrera=row["Carrera"]
      arreglo.push([nombre,apellido,username,carrera])
      c=c+1
    end
    return  arreglo,c
  end

  def buscar_calificaciones
    arreglo=[]
    c=0
    consulta="SELECT c.Calificacion,m.ID_Materia, m.Nombre_Materia from calificaciones c INNER JOIN materias m ON (c.ID_Materia=m.ID_Materia) where c.ID_Alumno=#{@id_alumno}"
    results=@conn.query(consulta)
    results.each do |row|
      id_materia=row["ID_Materia"]
      calificacion=row["Calificacion"]
      nombre_materia=row["Nombre_Materia"]
      arreglo.push([id_materia,calificacion,nombre_materia])
      c=c+1
    end
    print"ARRRE",arreglo
    return  arreglo,c
  end

end





#app=FXApp.new
#WindowView.new(app)
#app.create
#app.run
