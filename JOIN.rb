require "fox16"
include Fox
class JOIN < FXMainWindow
  def initialize(app,name,tipo,id)
    full=super(app,"Dashboard", :width=>600, :height=>400)
    full.backColor= FXRGB(165,249,229)
    helvetica = FXFont.new(app, "helvetica", 14)
    helvetica2 = FXFont.new(app, "helvetica", 18)
    lbl=FXLabel.new( self,"BIENVENIDO #{name} eres rol de #{tipo}, tu id es #{id}", :opts=>LAYOUT_EXPLICIT, :width=>560, :height=>50, :x=>0, :y=>20)
    lbl.font = helvetica2
    lbl.backColor= FXRGB(165,249,229)

  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end
