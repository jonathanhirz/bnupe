import luxe.States;
import luxe.Vector;
import luxe.Sprite;
import phoenix.Texture;
import luxe.tilemaps.Tilemap;

class PlayState extends State {

    var player : Sprite;
    var player_desired_position : Vector;
    var tilemap : Tilemap;

    public function new(_name:String, _tilemap:Tilemap, _player:Sprite) {
        super({ name:_name });
        tilemap = _tilemap;
        player = _player;
    } //new

    override function init() {


    } //init

    override function onenter<T>(_value:T) {

        tilemap.display({ 
            // grid:true 
        });
        player.visible = true;

        player_desired_position = player.get('player').desired_position;

    } //onenter

    override function onleave<T>(_value:T) {


    } //onleave

    override function update(dt:Float) {

        var player_tile_position = tilemap.worldpos_to_map(player_desired_position);
        // moving right
        if(player.get('player').velocity.x > 0) {

        }
        // moving left
        if(player.get('player').velocity.x < 0) {

        }
        // moving down
        if(player.get('player').velocity.y > 0) {

        }
        // moving up
        if(player.get('player').velocity.y < 0) {

        }
        


        tilemap.remove_tile('background', Std.int(player_tile_position.x), Std.int(player_tile_position.y));
        player.pos = player_desired_position;


    } //update

} //PlayState