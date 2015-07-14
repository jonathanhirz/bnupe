import luxe.Component;
import luxe.Vector;
import luxe.Sprite;

class Player extends Component {

    var player : Sprite;

    public function new(_name:String) {
        super({ name:_name });
    } //new

    override function init() {

        player = cast entity;

    } //init

    override function update(dt:Float) {

        player.pos.y += 10*dt;

    } //update

} //player