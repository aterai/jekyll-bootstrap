---
layout: post
category: swing
folder: ExtractFramesFromAnimatedGif
title: Animated Gifからフレーム画像を抽出する
tags: [ImageIO, ImageReader, BufferedImage, Animation]
author: aterai
pubdate: 2013-03-18T02:26:09+09:00
description: Animated GIFから各フレームの画像を抽出します。
image: https://lh4.googleusercontent.com/-_xu1jNmYJe0/UUX3d_PzwKI/AAAAAAAABoA/cyS5ABVZdkM/s800/ExtractFramesFromAnimatedGif.png
comments: true
---
## 概要
`Animated GIF`から各フレームの画像を抽出します。主に[Swing - Reading gif animation frame rates and such?](https://community.oracle.com/thread/1271862)の回答を参考に作成しています。

{% download https://lh4.googleusercontent.com/-_xu1jNmYJe0/UUX3d_PzwKI/AAAAAAAABoA/cyS5ABVZdkM/s800/ExtractFramesFromAnimatedGif.png %}

## サンプルコード
<pre class="prettyprint"><code>ImageReader reader = null;
Iterator&lt;ImageReader&gt; readers = ImageIO.getImageReaders(imageStream);
while (readers.hasNext()) {
  reader = readers.next();
  String metaFormat = reader.getOriginatingProvider().getNativeImageMetadataFormatName();
  if ("gif".equalsIgnoreCase(reader.getFormatName()) &amp;&amp;
          !"javax_imageio_gif_image_1.0".equals(metaFormat)) {
    continue;
  } else {
    break;
  }
}
reader = Objects.requireNonNull(reader, "Can not read image format!");
boolean isGif = reader.getFormatName().equalsIgnoreCase("gif");
reader.setInput(imageStream, false, !isGif);
List&lt;BufferedImage&gt; list = new ArrayList&lt;&gt;();
for (int i = 0; i &lt; reader.getNumImages(true); i++) {
  IIOImage frame = reader.readAll(i, null);
  list.add((BufferedImage) frame.getRenderedImage());
}
reader.dispose();
</code></pre>

## 解説
上記のサンプルでは、`ImageReader`に`Animated GIF`ファイルを読み込んで、`IIOImage#getRenderedImage()`メソッドで各フレームの`BufferedImage`を取得しています。

- 注:
    - 背景色や差分フレームは無視している
    - `try-with-resources`を使っているので、`JDK 1.7.0`以上が必要

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - Reading gif animation frame rates and such?](https://community.oracle.com/thread/1271862)
- [JPEGファイルのコメントを取り出す](http://ateraimemo.com/Swing/IIOMetadata.html)
- [JLabelに表示したAnimated Gifのアニメーションを停止する](http://ateraimemo.com/Swing/DisableAnimatedGif.html)
- [Animated GIFでのコマ描画時処理](http://ateraimemo.com/Swing/AnimatedGif.html)

<!-- dummy comment line for breaking list -->

## コメント
