package tart.core {

    import flash.display.Sprite;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Async;

    public class BootSequence {

        private var _tartContext:TartContext;
        private var _rootSprite:Sprite;

        public function BootSequence(rootSprite:Sprite) {
            _rootSprite = rootSprite;
        }

        public function run(onComplete:Function):void {
            _tartContext = new TartContext();

            knife.async(
                [
                    _initGraphics,
                    _initResource,
                    _initDirector,
                    _initSystem
                ],
                function():void {
                    onComplete(_tartContext);
                }
            );
        }

        private function _initGraphics(async:Async):void {
            _tartContext.graphics = new TartGraphics();
            _tartContext.graphics.init(_rootSprite, null, async.done);
        }

        private function _initResource(async:Async):void {
            _tartContext.resource = new TartResource();
            async.done();
        }

        private function _initDirector(async:Async):void {
            _tartContext.director = new TartDirector();
            async.done();
        }

        private function _initSystem(async:Async):void {
            _tartContext.system = new TartSystem();
            async.done();
        }

    }
}
