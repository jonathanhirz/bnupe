import luxe.States;
import luxe.Vector;
import luxe.Sprite;
import phoenix.Texture;
import luxe.tilemaps.Tilemap;

class PlayState extends State {

    var player : Sprite;
    var player_desired_position : Vector;
    var player_texture : Texture;
    var tilemap : Tilemap;

    public function new(_name:String, _tilemap:Tilemap) {
        super({ name:_name });
        tilemap = _tilemap;
    } //new

    override function init() {

        player_texture = Luxe.resources.texture('assets/player.png');

    } //init

    override function onenter<T>(_value:T) {

        tilemap.display({ 
            // grid:true 
        });

        player = new Sprite({
            texture : player_texture,
            pos : new Vector(100, 500),
        });
        player.add(new Player('player'));

    } //onenter

    override function onleave<T>(_value:T) {


    } //onleave

    override function update(dt:Float) {

        player_desired_position = player.get('player').desired_position.clone();

        // if trying to move right
        if(player_desired_position.x > player.pos.x) {
            var tile_standing_on = tilemap.tile_at_pos('ground', player_desired_position);
            if(tilemap.tile_at('ground', tile_standing_on.x+1, tile_standing_on.y).id != 0) {
                player.get('player').velocity.x = 0;
                player_desired_position = player.pos;
            } else {
                player.pos = player_desired_position;
            }

        }
        if(player_desired_position.x < player.pos.x) {
            var tile_standing_on = tilemap.tile_at_pos('ground', player_desired_position);
            if(tilemap.tile_at('ground', tile_standing_on.x-1, tile_standing_on.y).id != 0) {
                player.get('player').velocity.x = 0;
                player_desired_position = player.pos;
            } else {
                player.pos = player_desired_position;
            }

        } 


    } //update

} //PlayState