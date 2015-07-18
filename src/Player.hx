import luxe.Component;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.utils.Maths;
import luxe.tilemaps.Tilemap;

class Player extends Component {

    // player variables
    var player : Sprite;
    var x_flipped : Bool = false;
    var velocity : Vector;
    var acceleration : Vector;
    var dampening_amount : Float = 0.90;
    var cancel_movement_dampening : Float = 0.80;
    var h_movement_speed : Float = 15;
    var max_h_speed : Float = 40;
    var max_v_speed : Float = 30;
    var jump_amount : Float = -7;

    // world variables
    var gravity : Float = 10.0;
    var tilemap : Tilemap;

    public function new(_name:String) {
        super({ name:_name });
    } //new

    override function init() {

        // player variables
        player = cast entity;
        tilemap = cast PlayState.map1;
        velocity = new Vector(0,0);
        acceleration = new Vector(0,0);

    } //init

    override function update(dt:Float) {

        // horizontal movement
        velocity.x += acceleration.x * dt;
        velocity.x = Maths.clamp(velocity.x, -max_h_speed, max_h_speed);
        player.pos.x += velocity.x;

        if(Luxe.input.inputdown('left')) {
            if(velocity.x > 0) velocity.x *= cancel_movement_dampening;
            acceleration.x = -h_movement_speed;
            if(!x_flipped) x_flipped = true;
        }
        if(Luxe.input.inputdown('right')) {
            if(velocity.x < 0) velocity.x *= cancel_movement_dampening;
            acceleration.x = h_movement_speed;
            if(x_flipped) x_flipped = false;
        }

        // if(Luxe.input.inputdown('up')) {
        //     acceleration.y = -h_movement_speed/2;
        // }
        // if(Luxe.input.inputdown('down')) {
        //     acceleration.y = h_movement_speed/2;
        // }
        // if((Luxe.input.inputdown('up') && Luxe.input.inputdown('down')) || (!Luxe.input.inputdown('up') && !Luxe.input.inputdown('down'))) {
        //     acceleration.y = 0;
        //     velocity.y *= dampening_amount;
        // }

        // if both left and right are pressed, or if neither are pressed
        if((Luxe.input.inputdown('left') && Luxe.input.inputdown('right')) || (!Luxe.input.inputdown('left') && !Luxe.input.inputdown('right'))) {
            acceleration.x = 0;
            velocity.x *= dampening_amount;
        }

        // flip sprite horizontally
        if(x_flipped) {
            player.scale.x = -1;
        } else {
            player.scale.x = 1;
        }

        // full stop
        if(Math.abs(velocity.x) < 0.05) velocity.x = 0.0;

        // vertical movement
        acceleration.y = gravity;
        velocity.y += acceleration.y * dt;
        velocity.y = Maths.clamp(velocity.y, -max_v_speed, max_v_speed);
        player.pos.y += velocity.y;

        if(Luxe.input.inputpressed('space')) {
            velocity.y = jump_amount;
        }

        trace(on_tile(player));

        if(on_tile(player) != 0) {
            velocity.y = 0;
        }

    } //update

    function on_tile(_sprite:Sprite) {

        var tile = tilemap.tile_at_pos('ground',_sprite.pos);
        return tile.id;

    } //on_tile

} //player