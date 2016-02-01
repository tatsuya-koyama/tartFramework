package tart.core {

    import flash.display.Sprite;
    import flash.events.Event;

    import away3d.core.managers.Stage3DProxy;

    import dessert_knife.knife;
    import dessert_knife.tools.Async;

    public class TartDirector {

        private var _tartContext:TartContext;
        private var _rootSprite:Sprite;
        private var _scene:TartScene;
        private var _state:DirectorState;

        public function TartDirector() {

        }

        // ToDo: 初期化方法をもろもろまとめた BootConfig を渡すようにするか
        public function boot(rootSprite:Sprite, initialScene:TartScene):void {
            _tartContext = new TartContext();
            _rootSprite  = rootSprite;
            _scene       = initialScene;
            _state       = DirectorState.INIT_ENGINE;

            knife.async([
                _initGraphics,
                _initResource,
                _initSystem,
                _initMainLoop,

                function():void {
                    _state = DirectorState.ENTER_SCENE;
                }
            ]);
        }

        private function _initGraphics(async:Async):void {
            _tartContext.graphics = new TartGraphics();
            _tartContext.graphics.init(_rootSprite, null, async.done);
        }

        private function _initResource(async:Async):void {
            _tartContext.resource = new TartResource();
            // ToDo
            async.done();
        }

        private function _initSystem(async:Async):void {
            _tartContext.system = new TartSystem();
            // ToDo
            async.done();
        }

        private function _initMainLoop(async:Async):void {
            var stage3DProxy:Stage3DProxy = _tartContext.graphics.stage3DProxy;
            stage3DProxy.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
            async.done();
        }

        private function _onEnterFrame(event:Event):void {
            switch (_state) {
            case DirectorState.ENTER_SCENE:
                // todo: Scene の初期化、さらには複数 Scene をまたぐ Section の初期化
                _state = DirectorState.PLAY_SCENE;
                break;
            case DirectorState.PLAY_SCENE:
                // todo
                break;
            }

            // memo: 初期化中でも System のアップデートはすべきだな
        }

    }
}

class DirectorState {

    public static const INIT_ENGINE:DirectorState = new DirectorState();
    public static const ENTER_SCENE:DirectorState = new DirectorState();
    public static const PLAY_SCENE :DirectorState = new DirectorState();

}
