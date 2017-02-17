package tart.core {

    import flash.display.Sprite;
    import flash.display.Stage;

    import away3d.containers.View3D;
    import away3d.core.managers.Stage3DProxy;

    import starling.core.Starling;

    public interface IGraphicsBootConfig {

        /** @return Logical screen width of Starling layer. */
        function get STARLING_COORDINATE_WIDTH():Number;

        /** @return Logical screen height of Starling layer. */
        function get STARLING_COORDINATE_HEIGHT():Number;

        function onFlashStageInit(stage:Stage):void;

        function onStage3DProxyInit(stage3DProxy:Stage3DProxy):void;

        function onAway3DViewInit(away3DView:View3D, rootSprite:Sprite):void;

        function beforeInitStarling():void;

        function onStarlingForeInit(starling:Starling):void;

        function onStarlingBackInit(starling:Starling):void;

    }
}
