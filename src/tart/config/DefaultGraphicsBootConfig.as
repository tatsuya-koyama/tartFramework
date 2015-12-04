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

    public class DefaultGraphicsBootConfig implements IGraphicsBootConfig {

        public function get STARLING_COORDINATE_WIDTH():Number {
            return 960;
        }

        public function get STARLING_COORDINATE_HEIGHT():Number {
            return 640;
        }

        public function onFlashStageInit(stage:Stage):void {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align     = StageAlign.TOP_LEFT;
        }

        public function onStage3DProxyInit(stage3DProxy:Stage3DProxy):void {
            stage3DProxy.antiAlias = 8;
            stage3DProxy.color     = 0x222222;
        }

        public function onAway3DViewInit(away3DView:View3D, rootSprite:Sprite):void {
            // show debug stats at top-left corner of the screen
            rootSprite.addChild(new AwayStats(away3DView));
        }

        public function onStarlingForeInit(starling:Starling):void {
            // show debug stats at bottom-right corner of the screen
            starling.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);
        }

        public function onStarlingBackInit(starling:Starling):void {
            // show debug stats at top-right corner of the screen
            starling.showStatsAt(HAlign.RIGHT, VAlign.TOP);
        }

    }
}
