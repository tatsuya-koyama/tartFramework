package tart.core {

    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import starling.display.Image;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class TartResource {

        public function TartResource() {

        }

        //----------------------------------------------------------------------
        // getters
        //----------------------------------------------------------------------

        public function getImage(name:String):Image {
            return null;
        }

        public function getTexture(name:String):Texture {
            return null;
        }

        public function getTextureAtlas(name:String):TextureAtlas {
            return null;
        }

        public function getSound(name:String):Sound {
            return null;
        }

        public function getObject(name:String):Object {
            return null;
        }

        public function getXml(name:String):XML {
            return null;
        }

        public function getByteArray(name:String):ByteArray {
            return null;
        }

    }
}
