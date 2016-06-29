package tests.dessert_knife.blades {

    import org.hamcrest.assertThat;
    import org.hamcrest.core.allOf;
    import org.hamcrest.number.closeTo;
    import org.hamcrest.number.lessThan;
    import org.hamcrest.object.equalTo;

    import dessert_knife.knife;
    import dessert_knife.blades.StringKnife;

    public class StringKnifeTests {

        [Test]
        public function extensionOf():void {
            assertThat(knife.str.extensionOf("path/to/file.txt"), equalTo("txt"));
            assertThat(knife.str.extensionOf("path.to.file.png"), equalTo("png"));
            assertThat(knife.str.extensionOf("path.to.file."),    equalTo(""));
            assertThat(knife.str.extensionOf("path/to/file"),     equalTo(null));
        }

        [Test]
        public function fileNameOf():void {
            assertThat(knife.str.fileNameOf("path/to/file.txt"), equalTo("file"));
            assertThat(knife.str.fileNameOf("path.to.file.png"), equalTo("path"));
            assertThat(knife.str.fileNameOf("path.to.file."),    equalTo("path"));
            assertThat(knife.str.fileNameOf("path/to/file"),     equalTo("file"));
            assertThat(knife.str.fileNameOf("/file"),            equalTo("file"));
            assertThat(knife.str.fileNameOf(".file"),            equalTo(""));
            assertThat(knife.str.fileNameOf("file"),             equalTo("file"));
        }

    }
}
