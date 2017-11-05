package tartlab.actors {

    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    import tart.components.KeyInput;
    import tart.core.ActorCore;
    import tart.core.TartScene;

    public class ResetKey extends ActorCore {

        public override function build():void {
            compose(KeyInput);
        }

        public function ResetKey(rebootSceneClass:Class, triggerKey:uint = Keyboard.R):void {
            afterAwake(function():void {

                _keyInput.keyDownSignal.connect(function(event:KeyboardEvent):void {
                    if (event.keyCode == triggerKey) {
                        var rebootScene:TartScene = new rebootSceneClass() as TartScene;
                        tart.director.navigateTo(rebootScene);
                    }
                });

            });
        }

    }
}
