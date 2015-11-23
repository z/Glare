style"gtkscale"{
GtkRange::slider-width=14
GtkScale::slider-length=12
GtkRange::trough-border=0
GtkRange::activate-slider=0
engine"pixmap"{
image{
function=BOX
orientation=HORIZONTAL
file="../theme/images/scale-horizontal_trough.svg"
stretch=TRUE
border={3,3,6,6}}
image{
function=BOX
orientation=VERTICAL
detail="trough"
file="../theme/images/scale-vertical_trough.svg"
stretch=TRUE
border={6,6,3,3}}
image{
function=SLIDER
overlay_file="../theme/images/scale_slider.svg"
overlay_stretch=FALSE}}}
class"GtkScale"style"gtkscale"

####i'm only here for qgtkstyle
style"gtkvscale"{
xthickness=0
ythickness=0
GtkRange::slider-width=14
GtkScale::slider-length=12
GtkRange::trough-border=0
GtkRange::activate-slider=0
engine"pixmap"{
image{
function=BOX
detail="trough"
file="../theme/images/scale-vertical_trough.svg"
stretch=TRUE
border={6,6,3,3}}
image{
function=SLIDER
overlay_file="../theme/images/scale_slider.svg"
overlay_stretch=FALSE}}}
widget"*GtkVScale"style"gtkvscale"

style"gtkhscale"{
xthickness=0
ythickness=0
GtkHScale::slider-width=14
GtkHScale::slider-length=12
GtkRange::trough-border=0
GtkRange::activate-slider=0
engine"pixmap"{
image{
function=FLAT_BOX
detail="trough"
file="../theme/images/scale-horizontal_trough.svg"
stretch=TRUE
border={3,3,6,6}}
image{
function=SLIDER
overlay_file="../theme/images/scale_slider.svg"
overlay_stretch=FALSE}}}
widget"*GtkHScale"style"gtkhscale"

