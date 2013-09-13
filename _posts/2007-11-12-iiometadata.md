---
layout: post
title: JPEGファイルのコメントを取り出す
category: swing
folder: IIOMetadata
tags: [JTree, ImageIO, ImageReader, IIOMetadata]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-11-12

## JPEGファイルのコメントを取り出す
`JPEG`ファイルからコメントなどのメタデータ(`XML`)を取り出して`JTree`で表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOUrdw9GI/AAAAAAAAAcM/4rakKDY0jI0/s800/IIOMetadata.png)

### サンプルコード
<pre class="prettyprint"><code>InputStream source = getClass().getResourceAsStream("test.jpg");
Iterator readers = ImageIO.getImageReadersByFormatName("jpeg");
ImageReader reader = (ImageReader)readers.next();
//FileInputStream source = new FileInputStream(new File("c:/tmp/test.jpg"));
ImageInputStream iis = ImageIO.createImageInputStream(source);
reader.setInput(iis, true);

//[[MediaTrackerで画像のサイズを取得&gt;Swing/MediaTracker]]
//ImageReadParam param = reader.getDefaultReadParam();
//buf.append(String.format("Width: %d%n", reader.getWidth(0)));
//buf.append(String.format("Height: %d%n", reader.getHeight(0)));

IIOMetadata meta = reader.getImageMetadata(0);
//for(String s:meta.getMetadataFormatNames())
//  buf.append(String.format("MetadataFormatName: %s%n",s));

IIOMetadataNode root = (IIOMetadataNode)meta.getAsTree("javax_imageio_jpeg_image_1.0");
//root = (IIOMetadataNode) meta.getAsTree("javax_imageio_1.0");

NodeList com = root.getElementsByTagName("com");
if(com!=null &amp;&amp; com.getLength()&gt;0) {
  String comment = ((IIOMetadataNode)com.item(0)).getAttribute("comment");
  buf.append(String.format("Comment: %s%n", comment));
}
</code></pre>

### 解説
上記のサンプルは、`GIMP`を使って作成したコメント(このサンプルでは、文字コードが何かなどを考慮していないので日本語が化ける可能性がある)付きの`JPEG`画像から以下の手順でコメントを抽出しています。

1. `ImageReader`から、`IIOMetadata`を取得
1. `IIOMetadata`から`XML`の`DOM`(`org.w3c.dom.Node`)形式でデータを取得
1. `com`タグの`comment`属性からコメントを取得

タグやマーカなどの形式は、[JPEG Metadata Format Specification and Usage Notes](http://docs.oracle.com/javase/jp/6/api/javax/imageio/metadata/doc-files/jpeg_metadata.html)や、以下の`XML`一覧表示を参考にしてください。

- `JTextArea`
    - 属性は頭に`#`をつけて表示
- `JTree`
    - 参考:[Swing - XMLViewer](https://forums.oracle.com/thread/1373824)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JPEG Metadata Format Specification and Usage Notes](http://docs.oracle.com/javase/jp/6/api/javax/imageio/metadata/doc-files/jpeg_metadata.html)
    - via: [javax.imageio.metadata (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/imageio/metadata/package-summary.html)
    - 標準の (プラグインに依存しない) 形式やその他のメタデータ(`PNG`、`GIF`、`BMP`)もこちらから
- [Swing - XMLViewer](https://forums.oracle.com/thread/1373824)
- [MediaTrackerで画像のサイズを取得](http://terai.xrea.jp/Swing/MediaTracker.html)
- [Utilz: 画像の位置情報](http://www.utilz.jp/wiki/ExifGps)
    - via: [Jpegのexif形式ファイルからの画像解像度（幅高）取得について - Java Solution](http://www.atmarkit.co.jp/bbs/phpBB/viewtopic.php?topic=42083&forum=12&4)

<!-- dummy comment line for breaking list -->

### コメント
