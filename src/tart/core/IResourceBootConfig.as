package tart.core {

    public interface IResourceBootConfig {

        function get baseUrl():String;

        function get resourceHandlers():Vector.<IResourceHandler>;

        function get resourcePlugins():Vector.<IResourcePlugin>;

    }
}
