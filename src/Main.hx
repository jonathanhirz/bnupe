import luxe.Input;
import luxe.Screen;
import luxe.States;
import luxe.Text;
import luxe.Vector;
import pmi.PyxelMapImporter;
import pmi.LuxeHelper;
import luxe.tilemaps.Tilemap;


class Main extends luxe.Game {

    var machine : States;
    var fps_text : Text;
    var map1 : Tilemap;

    override function config(config:luxe.AppConfig) {

        // tilemap assets
        config.preload.textures.push({ id:'assets/level_01.png' });
        config.preload.texts.push({ id:'assets/level_01.xml' });

        // player assets
        config.preload.textures.push({ id:'assets/player.png' });

        return config;

    } //config

    override function ready() {

        // app.update_rate = 1/30;
        // app.render_rate = 1/30;

        // input
        connect_input();

        // tilemap
        setup_tilemap();

        // state machine setup
        machine = new States({ name:'statemachine' });
        machine.add(new MenuState('menu_state'));
        machine.add(new PlayState('play_state', map1));
        Luxe.on(init, function(_) {
            machine.set('play_state', map1);
        });

        // fps debug text
        fps_text = new Text({
            text : 'FPS: ',
            point_size : 20,
            pos : new Vector(0,0),
            visible : false
        });

    } //ready

    override function onkeyup(e:KeyEvent) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
        if(e.keycode == Key.key_f) {
            fps_text.visible = !fps_text.visible;
        }

    } //onkeyup

    override function onwindowresized(e:WindowEvent) {
        
        // Luxe.camera.viewport = new luxe.Rectangle(0,0,e.event.x, e.event.y);
        // Luxe.camera.zoom = e.event.x / 960;

    } //onwindowresized

    override function update(dt:Float) {

        fps_text.text = 'FPS: ' + Math.round(1.0/Luxe.debug.dt_average);

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

    function connect_input() {

        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('up', Key.key_w);
        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);
        Luxe.input.bind_key('down', Key.down);
        Luxe.input.bind_key('down', Key.key_s);
        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);
        Luxe.input.bind_key('space', Key.space);

    } //connect_input

} //Main
