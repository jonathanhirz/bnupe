import luxe.Component;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.utils.Maths;

class Player extends Component {

    // player variables
    var player : Sprite;
    var x_flipped : Bool = false;
    public var velocity : Vector;
    var acceleration : Vector;
    var dampening_amount : Float = 0.90;
    var cancel_movement_dampening : Float = 0.80;
    var h_movement_speed : Float = 15;
    var max_h_speed : Float = 40;
    var max_v_speed : Float = 30;
    var jump_amount : Float = -7;
    public var on_ground : Bool = false;

    // world variables
    var gravity : Float = 20.0;

    public function new(_name:String) {
        super({ name:_name });
    } //new

    override function init() {

        player = cast entity;
        velocity = new Vector(0,0);
        acceleration = new Vector(0,0);

    } //init

    override function update(dt:Float) {

        //
        // horizontal movement
        velocity.x += acceleration.x * Luxe.physics.step_delta;
        velocity.x = Maths.clamp(velocity.x, -max_h_speed, max_h_speed);
        pos.x += velocity.x;

        if(Luxe.input.inputdown('left')) {
            if(velocity.x > 0) velocity.x *= cancel_movement_dampening;
            acceleration.x = -h_movement_speed;
            if(!x_flipped) x_flipped = true;
            flip_sprite();
        }
        if(Luxe.input.inputdown('right')) {
            if(velocity.x < 0) velocity.x *= cancel_movement_dampening;
            acceleration.x = h_movement_speed;
            if(x_flipped) x_flipped = false;
            flip_sprite();
        }

        // if both left and right are pressed, or if neither are pressed, stop player from moving l/r
        if((Luxe.input.inputdown('left') && Luxe.input.inputdown('right')) || (!Luxe.input.inputdown('left') && !Luxe.input.inputdown('right'))) {
            acceleration.x = 0;
            velocity.x *= dampening_amount;
        }

        // full stop
        if(Math.abs(velocity.x) < 0.05) velocity.x = 0.0;

        //
        // vertical movement
        acceleration.y = gravity;
        velocity.y += acceleration.y * Luxe.physics.step_delta;
        velocity.y = Maths.clamp(velocity.y, -max_v_speed, max_v_speed);
        pos.y += velocity.y;

        if(Luxe.input.inputpressed('space') && on_ground) {
            //todo: add jump stop - if you hold jump, do a full jump. if you let go early, do a short jump
            //todo: when player falls off a ledge, they shouldn't be able to jump
            on_ground = false;
            velocity.y = jump_amount;
        }

    } //update

    function flip_sprite() {

        if(x_flipped) {
            player.scale.x = -1;
        } else {
            player.scale.x = 1;
        }

    } //flip_sprite

} //player