package tart.core_internal.resource_plugin {

    import flash.utils.Dictionary;

    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    import tart.core.IResourcePlugin;
    import tart.core.TartResource;
    import tart.core_internal.ResourceRepository;
    import tart.core_internal.resource_handler.TextureResource;

    import dessert_knife.knife;

    /**
     * When XMLs for texture atlas are loaded, creates TextureAtlas object
     * and store to the resource repository.
     */
    public class TextureAtlasPlugin implements IResourcePlugin {

        public static const URL_PREFIX:String = "<atlas>";
        public static const KEY_PREFIX:String = "atlas:";

        private var _textureKeyToAtlasKey:Dictionary;

        public function TextureAtlasPlugin() {
            _textureKeyToAtlasKey = new Dictionary();
        }

        //----------------------------------------------------------------------
        // implements IResourcePlugin
        //----------------------------------------------------------------------

        public function afterLoad(resourcesNewlyLoaded:Array,
                                  tartResource:TartResource,
                                  resourceRepo:ResourceRepository):void
        {
            for each (var resource:* in resourcesNewlyLoaded) {
                if (!(resource is XML)) { continue; }

                var xml:XML = resource as XML;
                if (xml.localName() != "TextureAtlas") { continue; }

                var atlasName:String   = knife.str.fileNameOf(xml.@imagePath.toString());
                var texture:Texture    = tartResource.getTexture(atlasName);
                var atlas:TextureAtlas = new TextureAtlas(texture, xml);

                var dummyUrl:String    = URL_PREFIX + atlasName;
                var resourceKey:String = KEY_PREFIX + atlasName;
                resourceRepo.store(atlas, dummyUrl, resourceKey);

                _textureKeyToAtlasKey[TextureResource.KEY_PREFIX + atlasName] = resourceKey;
                TART::LOG_INFO {
                    trace("[Info :: TextureAtlasPlugin] (+) Create Texture Atlas:", atlasName);
                }
            }
        }

        public function beforeRelease(keysNoLongerUsed:Vector.<String>,
                                      tartResource:TartResource,
                                      resourceRepo:ResourceRepository):void
        {
            for each (var key:String in keysNoLongerUsed) {
                if (!_textureKeyToAtlasKey[key]) { continue; }

                var atlasKey:String           = _textureKeyToAtlasKey[key];
                var textureAtlas:TextureAtlas = resourceRepo.removeByKey(atlasKey);
                textureAtlas.dispose();

                delete _textureKeyToAtlasKey[key];
                TART::LOG_INFO {
                    trace("[Info :: TextureAtlasPlugin] (-) Dispose Texture Atlas:", atlasKey);
                }
            }
        }

        public function findResource(key:String,
                                     tartResource:TartResource,
                                     resourceRepo:ResourceRepository):*
        {
            for (var textureKey:String in _textureKeyToAtlasKey) {
                var atlasKey:String = _textureKeyToAtlasKey[textureKey];
                var resource:*      = resourceRepo.getByKey(atlasKey, true);
                if (!resource) { continue; }
                if (!(resource is TextureAtlas)) { continue; }

                var atlas:TextureAtlas = resource as TextureAtlas;
                var texture:Texture    = atlas.getTexture(key);
                if (texture) { return texture; }
            }
            return null;
        }

    }
}
