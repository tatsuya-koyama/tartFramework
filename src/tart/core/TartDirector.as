package tart.core {

    import flash.display.Sprite;

    public class TartDirector {

        private var _tartContext:TartContext;

        public function TartDirector() {

        }

        public function boot(rootSprite:Sprite):void {
            _tartContext = new TartContext();

            _tartContext.graphics = new GraphicsManager();
            _tartContext.graphics.init(rootSprite, null, function():void {
                trace("on init");
            });
        }

    }
}
