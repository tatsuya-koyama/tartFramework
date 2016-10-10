package tart.core {

    import flash.display.Sprite;

    public interface IBootConfig {

        function get rootSprite():Sprite;

        function get firstScene():TartScene;

        function get rootChapter():TartChapter;

        function get graphicsBootConfig():IGraphicsBootConfig;

        function get systemBootConfig():ISystemBootConfig;

    }
}
