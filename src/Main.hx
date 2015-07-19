import luxe.Input;
import luxe.Screen;
import luxe.States;
import luxe.Text;
import luxe.Vector;

class Main extends luxe.Game {

    var machine : States;
    var count_time : Float = 0.0;
    var fps_text : Text;

    override function config(config:luxe.AppConfig) {

        // tilemap assets
        config.preload.textures.push({ id:'assets/level_01.png' });
        config.preload.texts.push({ id:'assets/level_01.xml' });

        // player assets
        config.preload.textures.push({ id:'assets/player.png' });

        return config;

    } //config

    override function ready() {

        connect_input();
        machine = new States({ name:'statemachine' });
        machine.add(new MenuState('menu_state'));
        machine.add(new PlayState('play_state'));
        Luxe.on(init, function(_) {
            machine.set('play_state');
        });

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

        if(Luxe.time - count_time > 0.5) {
            count_time = Luxe.time;
            fps_text.text = 'FPS: ' + Std.int(1.0 / Luxe.dt);
        }


    } //update

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
