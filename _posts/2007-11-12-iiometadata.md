---
layout: post
category: swing
folder: IIOMetadata
title: JPEGファイルのコメントを取り出す
tags: [JTree, ImageIO, ImageReader, IIOMetadata]
author: aterai
pubdate: 2007-11-12T12:24:17+09:00
description: JPEGファイルからコメントなどのメタデータ(XML)を取り出してJTreeで表示します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOUrdw9GI/AAAAAAAAAcM/4rakKDY0jI0/s800/IIOMetadata.png
comments: true
---
## 概要
`JPEG`ファイルからコメントなどのメタデータ(`XML`)を取り出して`JTree`で表示します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOUrdw9GI/AAAAAAAAAcM/4rakKDY0jI0/s800/IIOMetadata.png %}

## サンプルコード
<pre class="prettyprint"><code>InputStream source = getClass().getResourceAsStream("test.jpg");
Iterator readers = ImageIO.getImageReadersByFormatName("jpeg");
ImageReader reader = (ImageReader) readers.next();
//FileInputStream source = new FileInputStream(new File("c:/tmp/test.jpg"));
ImageInputStream iis = ImageIO.createImageInputStream(source);
reader.setInput(iis, true);

//[[MediaTrackerで画像のサイズを取得&gt;Swing/MediaTracker]]
//ImageReadParam param = reader.getDefaultReadParam();
//buf.append(String.format("Width: %d%n", reader.getWidth(0)));
//buf.append(String.format("Height: %d%n", reader.getHeight(0)));

IIOMetadata meta = reader.getImageMetadata(0);
//for (String s: meta.getMetadataFormatNames())
//  buf.append(String.format("MetadataFormatName: %s%n",s));

IIOMetadataNode root = (IIOMetadataNode) meta.getAsTree("javax_imageio_jpeg_image_1.0");
//root = (IIOMetadataNode) meta.getAsTree("javax_imageio_1.0");

NodeList com = root.getElementsByTagName("com");
if (com != null &amp;&amp; com.getLength() &gt; 0) {
  String comment = ((IIOMetadataNode) com.item(0)).getAttribute("comment");
  buf.append(String.format("Comment: %s%n", comment));
}
</code></pre>

## 解説
上記のサンプルは、コメント付きの`JPEG`画像から以下の手順でコメントを抽出しています。

1. `ImageReader`から、`IIOMetadata`を取得
1. `IIOMetadata`から`XML`の`DOM`(`org.w3c.dom.Node`)形式でデータを取得
1. `com`タグの`comment`属性からコメントを取得

タグやマーカなどの形式は、[JPEG メタデータ形式の仕様および使用上の注意](http://docs.oracle.com/javase/jp/7/api/javax/imageio/metadata/doc-files/jpeg_metadata.html)や、以下の`XML`一覧表示を参考にしてください。

- `JTextArea`
    - 属性は頭に`#`をつけて表示
- `JTree`
    - 参考: [Swing - XMLViewer](https://community.oracle.com/thread/1373824)

<!-- dummy comment line for breaking list -->

- 注:
    - このサンプルでは、`GIMP`を使用してコメントを追加して文字コードについては考慮していないので日本語が化ける可能性がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JPEG メタデータ形式の仕様および使用上の注意](https://docs.oracle.com/javase/jp/8/docs/api/javax/imageio/metadata/doc-files/jpeg_metadata.html)
    - via: [javax.imageio.metadata (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/imageio/metadata/package-summary.html)
    - 標準の (プラグインに依存しない) 形式やその他のメタデータ(`PNG`、`GIF`、`BMP`)もこちらから
- [Swing - XMLViewer](https://community.oracle.com/thread/1373824)
- [MediaTrackerで画像のサイズを取得](https://ateraimemo.com/Swing/MediaTracker.html)

<!-- dummy comment line for breaking list -->

## コメント
