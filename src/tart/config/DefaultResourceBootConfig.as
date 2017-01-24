package tart.config {

    import tart.core.IResourceBootConfig;
    import tart.core.IResourceHandler;
    import tart.core.IResourcePlugin;
    import tart.core_internal.resource_handler.AwdResource;
    import tart.core_internal.resource_handler.Max3dsResource;
    import tart.core_internal.resource_handler.ObjResource;
    import tart.core_internal.resource_handler.TextureResource;
    import tart.core_internal.resource_handler.XmlResource;
    import tart.core_internal.resource_plugin.TextureAtlasPlugin;

    public class DefaultResourceBootConfig implements IResourceBootConfig {

        private var _baseUrl:String;
        private var _handlers:Vector.<IResourceHandler>;
        private var _plugins:Vector.<IResourcePlugin>;

        public function DefaultResourceBootConfig(baseUrl:String, base3dAssetUrl:String) {
            _baseUrl = baseUrl;

            _handlers = new <IResourceHandler>[
                new TextureResource(),
                new XmlResource(),
                new AwdResource(base3dAssetUrl),
                new ObjResource(base3dAssetUrl),
                new Max3dsResource(base3dAssetUrl)
            ];

            _plugins = new <IResourcePlugin>[
                new TextureAtlasPlugin()
            ];
        }

        //----------------------------------------------------------------------
        // implements IResourceBootConfig
        //----------------------------------------------------------------------

        public function get baseUrl():String {
            return _baseUrl;
        }

        public function get resourceHandlers():Vector.<IResourceHandler> {
            return _handlers;
        }

        public function get resourcePlugins():Vector.<IResourcePlugin> {
            return _plugins;
        }

    }
}
