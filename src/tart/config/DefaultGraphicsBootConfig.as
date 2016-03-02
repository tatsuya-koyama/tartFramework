package tart.config {

    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    import away3d.containers.View3D;
    import away3d.debug.AwayStats;

    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    import away3d.core.managers.Stage3DProxy;

    import tart.core.IGraphicsBootConfig;

    public class DefaultGraphicsBootConfig implements IGraphicsBootConfig {

        // customizable params
        public var showStats:Boolean = true;
        public var starlingCoordWidth:Number  = 960;
        public var starlingCoordHeight:Number = 640;
        public var stageScaleMode:String = StageScaleMode.NO_SCALE;
        public var stageAlign:String     = StageAlign.TOP_LEFT;
        public var stage3DAntiAlias:int  = 8;
        public var bgColor:uint = 0x222222;

        //----------------------------------------------------------------------
        // implements IGraphicsBootConfig
        //----------------------------------------------------------------------

        public function get STARLING_COORDINATE_WIDTH():Number {
            return starlingCoordWidth;
        }

        public function get STARLING_COORDINATE_HEIGHT():Number {
            return starlingCoordHeight;
        }

        public function onFlashStageInit(stage:Stage):void {
            stage.scaleMode = stageScaleMode;
            stage.align     = stageAlign;
        }

        public function onStage3DProxyInit(stage3DProxy:Stage3DProxy):void {
            stage3DProxy.antiAlias = stage3DAntiAlias;
            stage3DProxy.color     = bgColor;
        }

        public function onAway3DViewInit(away3DView:View3D, rootSprite:Sprite):void {
            if (!showStats) { return; }

            // show debug stats at top-left corner of the screen
            rootSprite.addChild(new AwayStats(away3DView));
        }

        public function onStarlingForeInit(starling:Starling):void {
            if (!showStats) { return; }

            // show debug stats at bottom-right corner of the screen
            starling.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);
        }

        public function onStarlingBackInit(starling:Starling):void {
            if (!showStats) { return; }

            // show debug stats at top-right corner of the screen
            starling.showStatsAt(HAlign.RIGHT, VAlign.TOP);
        }

    }
}
