---
layout: post
title: Animated Gifからフレーム画像を抽出する
category: swing
folder: ExtractFramesFromAnimatedGif
tags: [ImageIO, ImageReader, BufferedImage, Animation]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-03-18

## Animated Gifからフレーム画像を抽出する
`AnimatedGif`から各フレームの画像を抽出します。主に[OTN Discussion Forums : Reading gif animation frame rates and such?](https://forums.oracle.com/forums/thread.jspa?messageID=5386516)の回答を参考に作成しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-_xu1jNmYJe0/UUX3d_PzwKI/AAAAAAAABoA/cyS5ABVZdkM/s800/ExtractFramesFromAnimatedGif.png)

### サンプルコード
<pre class="prettyprint"><code>ImageReader reader = null;
Iterator&lt;ImageReader&gt; readers = ImageIO.getImageReaders(imageStream);
while(readers.hasNext()) {
  reader = readers.next();
  String metaFormat = reader.getOriginatingProvider().getNativeImageMetadataFormatName();
  if("gif".equalsIgnoreCase(reader.getFormatName()) &amp;&amp;
            !"javax_imageio_gif_image_1.0".equals(metaFormat)) {
    continue;
  }else{
    break;
  }
}
if(reader == null) {
  throw new IOException("Can not read image format!");
}
boolean isGif = reader.getFormatName().equalsIgnoreCase("gif");
reader.setInput(imageStream, false, !isGif);
ArrayList&lt;BufferedImage&gt; list = new ArrayList&lt;BufferedImage&gt;();
for(int i=0;i&lt;reader.getNumImages(true);i++) {
  IIOImage frame = reader.readAll(i, null);
  list.add((BufferedImage)frame.getRenderedImage());
}
reader.dispose();
</code></pre>

### 解説
上記のサンプルでは、`ImageReader`に`AnimatedGif`ファイルを読み込ませて、`IIOImage#getRenderedImage()`で各フレームの`BufferedImage`を取得しています。

- 注:
    - 背景色や差分フレームを無視している
    - `try-with-resources`を使っているので、`JDK 1.7.0`以上が必要

<!-- dummy comment line for breaking list -->

### 参考リンク
- [OTN Discussion Forums : Reading gif animation frame rates and such?](https://forums.oracle.com/forums/thread.jspa?messageID=5386516)
- [JPEGファイルのコメントを取り出す](http://terai.xrea.jp/Swing/IIOMetadata.html)
- [JLabelに表示したAnimated Gifのアニメーションを停止する](http://terai.xrea.jp/Swing/DisableAnimatedGif.html)
- [Animated GIFでのコマ描画時処理](http://terai.xrea.jp/Swing/AnimatedGif.html)

<!-- dummy comment line for breaking list -->

### コメント