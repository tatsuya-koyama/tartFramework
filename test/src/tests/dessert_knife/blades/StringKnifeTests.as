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

        [Test]
        public function padLeft():void {
            assertThat(knife.str.padLeft("abc",      8      ), equalTo("     abc"));
            assertThat(knife.str.padLeft("abc",      8, "-" ), equalTo("-----abc"));
            assertThat(knife.str.padLeft("",         6, "*" ), equalTo("******"));
            assertThat(knife.str.padLeft("ABCDEFG",  6, "*" ), equalTo("ABCDEFG"));
            assertThat(knife.str.padLeft("ABCDEFG", -1, "*" ), equalTo("ABCDEFG"));
            assertThat(knife.str.padLeft("123",      5, "AB"), equalTo("AA123"));
        }

        [Test]
        public function padRight():void {
            assertThat(knife.str.padRight("abc",      8      ), equalTo("abc     "));
            assertThat(knife.str.padRight("abc",      8, "-" ), equalTo("abc-----"));
            assertThat(knife.str.padRight("",         6, "*" ), equalTo("******"));
            assertThat(knife.str.padRight("ABCDEFG",  6, "*" ), equalTo("ABCDEFG"));
            assertThat(knife.str.padRight("ABCDEFG", -1, "*" ), equalTo("ABCDEFG"));
            assertThat(knife.str.padRight("123",      5, "AB"), equalTo("123AA"));
        }

    }
}
