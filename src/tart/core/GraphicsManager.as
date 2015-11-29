package tart.core {

    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.geom.Rectangle;

    import away3d.containers.View3D;
    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.events.Stage3DEvent;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;

    import tart.config.DefaultGraphicsBootConfig;
    import tart.config.IGraphicsBootConfig;

    import dessert_knife.knife;
    import dessert_knife.tools.Await;

    public class GraphicsManager {

        private var _rootSprite:flash.display.Sprite;
        private var _stage:Stage;
        private var _bootConfig:IGraphicsBootConfig;
        private var _onInitComplete:Function;

        private var _stage3DManager:Stage3DManager;
        private var _stage3DProxy:Stage3DProxy;
        private var _away3DView:View3D;
        private var _starlingFront:Starling;
        private var _starlingBack:Starling;

        public function GraphicsManager() {}

        //----------------------------------------------------------------------
        // accessors
        //----------------------------------------------------------------------

        public function get stage3DProxy():Stage3DProxy {
            return _stage3DProxy;
        }

        public function get away3DView():View3D {
            return _away3DView;
        }

        public function get starlingFront():Starling {
            return _starlingFront;
        }

        public function get starlingBack():Starling {
            return _starlingBack;
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function init(rootSprite:flash.display.Sprite,
                             bootConfig:IGraphicsBootConfig,
                             onInitComplete:Function):void
        {
            _rootSprite     = rootSprite;
            _stage          = _rootSprite.stage;
            _bootConfig     = bootConfig || new DefaultGraphicsBootConfig();
            _onInitComplete = onInitComplete;

            _bootConfig.onFlashStageInit(_stage);
            _initStage3D();
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _initStage3D():void {
            _stage3DManager = Stage3DManager.getInstance(_stage);
            _stage3DProxy   = _stage3DManager.getFreeStage3DProxy();
            _bootConfig.onStage3DProxyInit(_stage3DProxy);

            _stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, _onContextCreated);
        }

        private function _onContextCreated(event:Stage3DEvent):void {
            // init Away3D View
            _away3DView = _makeAway3DView(_stage3DProxy);
            _rootSprite.addChild(_away3DView);
            _bootConfig.onAway3DViewInit(_away3DView, _rootSprite);

            // init 2 layers of Starling instance
            // ToDo: 使わない Starling を初期化しないオプション
            _starlingFront = _makeStarling(_stage3DProxy);
            _starlingBack  = _makeStarling(_stage3DProxy);
            _bootConfig.onStarlingFrontInit(_starlingFront);
            _bootConfig.onStarlingBackInit (_starlingBack);

            _stage.addEventListener(flash.events.Event.RESIZE, _onStageResize);
            _onStageResize();

            knife.await(
                function(await:Await):void {
                    _starlingBack .addEventListener(starling.events.Event.ROOT_CREATED, await.it());
                    _starlingFront.addEventListener(starling.events.Event.ROOT_CREATED, await.it());
                },
                _onInitComplete
            );
        }

        private function _makeAway3DView(stage3DProxy:Stage3DProxy):View3D {
            var view3D:View3D = new View3D();
            view3D.stage3DProxy = stage3DProxy;
            view3D.shareContext = true;
            view3D.width        = _stage.stageWidth;
            view3D.height       = _stage.stageHeight;
            return view3D;
        }

        private function _makeStarling(stage3DProxy:Stage3DProxy):Starling {
            var starling:Starling = new Starling(
                starling.display.Sprite,
                _stage,
                stage3DProxy.viewPort,
                stage3DProxy.stage3D
            );
            return starling;
        }

        private function _onStageResize(event:flash.events.Event=null):void {
            var viewPort:Rectangle = _getBestFitViewPort();

            _away3DView.x        = viewPort.x;
            _away3DView.y        = viewPort.y;
            _away3DView.width    = viewPort.width;
            _away3DView.height   = viewPort.height;

            _stage3DProxy.x      = viewPort.x;
            _stage3DProxy.y      = viewPort.y;
            _stage3DProxy.width  = viewPort.width;
            _stage3DProxy.height = viewPort.height;

            _starlingFront.stage.stageWidth  = _bootConfig.STARLING_COORDINATE_WIDTH;
            _starlingFront.stage.stageHeight = _bootConfig.STARLING_COORDINATE_HEIGHT;

            _starlingBack.stage.stageWidth  = _bootConfig.STARLING_COORDINATE_WIDTH;
            _starlingBack.stage.stageHeight = _bootConfig.STARLING_COORDINATE_HEIGHT;
        }

        private function _getBestFitViewPort():Rectangle {
            var starlingWidth:Number  = _bootConfig.STARLING_COORDINATE_WIDTH;
            var starlingHeight:Number = _bootConfig.STARLING_COORDINATE_HEIGHT;
            const aspectRatio:Number  =  starlingHeight / starlingWidth;

            var screenWidth:Number   = _stage.stageWidth;
            var screenHeight:Number  = _stage.stageHeight;
            var viewPort:Rectangle   = new Rectangle();

            if (screenHeight / screenWidth < aspectRatio) {
                viewPort.height = screenHeight;
                viewPort.width  = int(screenHeight / aspectRatio);
                viewPort.x      = int((screenWidth - viewPort.width) / 2);  // centering horizontally
            } else {
                viewPort.width  = screenWidth;
                viewPort.height = int(screenWidth * aspectRatio);
                viewPort.y      = int((screenHeight - viewPort.height) / 2);  // centering vertically
            }
            return viewPort;
        }

    }
}
