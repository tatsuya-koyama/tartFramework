package tart.core {

    import flash.display.Sprite;

    public interface IBootConfig {

        function get rootSprite():Sprite;

        function get firstScene():TartScene;

        function get rootChapter():TartChapter;

        function get tartConstants():TartConstants;

        function get graphicsBootConfig():IGraphicsBootConfig;

        function get resourceBootConfig():IResourceBootConfig;

        function get systemBootConfig():ISystemBootConfig;

    }
}
