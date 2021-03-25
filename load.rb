require_relative "tipo"
require "fox16"
include Fox

class Barra < FXMainWindow
  def initialize(app)
    @app=app
    logoicon =FXPNGIcon.new(app, File.open("school2.png", "rb").read)
    full=super(app,"NEW", :icon => logoicon,:width=>500, :height=>280)

    @dataTarget=FXDataTarget.new(10)
    barra=FXProgressBar.new(full,@dataTarget,FXDataTarget::ID_VALUE,LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|FRAME_SUNKEN|FRAME_THICK)
    barra.barColor="green"
    barra.backColor="black"
    imagebox = FXVerticalFrame.new(full,LAYOUT_FILL_X|LAYOUT_FILL_Y)
    imageView = FXImageView.new(imagebox, nil, nil, 0,
                                VSCROLLER_ALWAYS|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    image = FXPNGImage.new(app, nil)
    FXFileStream.open("school2.png", FXStreamLoad) {|stream|
      image.loadPixels(stream)}
    image.create
    imageView.image = image




  end

  def create
    super
    getApp().addTimeout(50,method(:tiempo))
    show(PLACEMENT_SCREEN)
  end

  def tiempo(sender,sel,ptr)
    @dataTarget.value=@dataTarget.value + 2
    if(@dataTarget.value>=99)
      ventana_login=Usuarios.new(@app)
      ventana_login.create
      ventana_login.show(PLACEMENT_SCREEN)
      self.close
    else
      getApp().addTimeout(50,method(:tiempo))
    end


  end
end

app=FXApp.new
Barra.new(app)
app.create
app.run