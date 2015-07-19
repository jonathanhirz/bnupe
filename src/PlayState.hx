import luxe.States;
import pmi.PyxelMapImporter;
import pmi.LuxeHelper;
import luxe.tilemaps.Tilemap;
import luxe.Vector;
import luxe.Sprite;
import phoenix.Texture;

class PlayState extends State {

    public static var map1 : Tilemap;
    var player : Sprite;
    var player_desired_position : Vector;
    var player_texture : Texture;

    public function new(_name:String) {
        super({ name:_name });
    } //new

    override function init() {

        setup_tilemap();
        player_texture = Luxe.resources.texture('assets/player.png');

    } //init

    override function onenter<T>(_value:T) {

        map1.display({ 
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
        player.pos = player_desired_position;

    } //update

    function setup_tilemap() {

        if(map1 == null) {
            var map1_data = new PyxelMapImporter(Luxe.resources.text('assets/level_01.xml').asset.text);
            map1 = LuxeHelper.getTilemap('assets/level_01.png');
            var background = map1_data.getDatasFromLayer('background');
            var ground = map1_data.getDatasFromLayer('ground');
            var decoration = map1_data.getDatasFromLayer('decoration');
            LuxeHelper.fillLayer(map1, background);
            LuxeHelper.fillLayer(map1, ground);
            LuxeHelper.fillLayer(map1, decoration);
        }

    } //setup_tilemap

} //PlayState