require "fox16"
require 'mysql2'
include Fox
class WindowdeleteDoc <FXMainWindow

  def initialize(app)
    helvetica = FXFont.new(app, "helvetica", 10)
    helvetica2 = FXFont.new(app, "helvetica", 18)
    full_icon=FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"Elimina docente", :icon => full_icon,:width=>600, :height=>220)
    full.backColor= FXRGB(208,189,241)
    conn=Mysql2::Client.new(:host => "localhost", :username => "root",:database =>"escuela")
    @conn=conn

    lbl_icon =FXPNGIcon.new(app , File.open("basura.png", "rb").read)
    lbl_img=FXLabel.new( self,"", lbl_icon,:opts=>LAYOUT_EXPLICIT, :width=>200, :height=>208, :x=>380, :y=>70)
    lbl_img.icon =lbl_icon
    lbl_img.backColor= FXRGB(208,189,241)

    lbl=FXLabel.new( self,"ELIMINAR DOCENTE", :opts=>LAYOUT_EXPLICIT, :width=>560, :height=>50, :x=>20, :y=>10)
    lbl.font = helvetica2
    lbl.backColor= FXRGB(117,153,222)

    lbl_Name=FXLabel.new( self,"NOMBRE:", :opts=>LAYOUT_EXPLICIT|JUSTIFY_RIGHT, :width=>90, :height=>50, :x=>45, :y=>70)
    lbl_Name.font =helvetica
    lbl_Name.backColor=FXRGB(208,189,241)


    arreglo,c=consulta_docentes
    @combo=FXComboBox.new(self ,c,:opts=>LAYOUT_EXPLICIT|TEXTFIELD_NORMAL,:width=>200,:height=>30,:x=>150,:y=>80)
    @combo.numVisible=c
    @combo.editable =false
    i=0
    while i<c
      materia=arreglo[i][0]
      @combo.appendItem(materia)
      i=i+1
    end




    button_Del_icon =FXPNGIcon.new(app, File.open("delete.png", "rb").read)
    button_Del=FXButton.new(self ,"Eliminar",:icon => button_Del_icon,:opts=>FRAME_RAISED|FRAME_THICK|LAYOUT_EXPLICIT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y, :width=>170, :height=>50,:x=>22, :y=>150)
    button_Del.font=helvetica
    button_Del.backColor= FXRGB(60, 169, 255)
    button_Del.textColor = FXRGB(255,255,255)
    button_Del.iconPosition = ICON_BEFORE_TEXT
    button_Del.connect(SEL_COMMAND) do
      eliminar_docente
    end


    
  end

  def consulta_docentes
    c=0
    arreglo=[]
    consulta="SELECT * from maestros"
    results=@conn.query(consulta)
    results.each do |row|
      c+=1
      id=row["ID_Maestro"]
      nombre=row["Nombre"]
      apellido=row["Apellido"]
      username=row["Username"]
      arreglo.push([(id.to_s+"/"+nombre.to_s+" "+apellido.to_s+" - "+username.to_s)])
    end
    return arreglo,c
  end
  def eliminar_docente
    valor=@combo.text
    puts valor
    list1=[]
    list2=[]
    delimitador = "/"
    palabras = valor.split(delimitador)
    palabras.each do |palabra|
      list1.push(palabra)
    end
    id= list1[0]

    delimitador2 = " - "
    palabras2 = list1[1].split(delimitador2)
    palabras2.each do |palabra2|
      list2.push(palabra2)
    end
    name=list2[0]

    answer=FXMessageBox.question(self,MBOX_YES_NO,"Atención","¿Esta seguro que desea eliminar a #{name}?, Esto no se podrá deshacer")
    if answer == MBOX_CLICKED_YES
      consu="DELETE FROM `maestros` WHERE `maestros`.`ID_Maestro` = #{id}"
      resul=@conn.query(consu)
      FXMessageBox.information(self,MBOX_OK,"Atención","Docente Eliminado")
      clean_inputs
    end
  end

  def clean_inputs
    @combo.text=""
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
