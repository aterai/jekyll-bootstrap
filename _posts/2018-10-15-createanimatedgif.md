---
layout: post
category: swing
folder: CreateAnimatedGif
title: ImageIOでAnimatedGifファイルを生成する
tags: [Graphics, ImageIO, AnimatedGif, File]
author: aterai
pubdate: 2018-10-15T01:33:57+09:00
description: ImageIOを使用してAnimatedGifを生成し、これを画像ファイルとして書き出します。
image: https://drive.google.com/uc?id=1u3A7qx0Lmc-FYjdYhsZkBRrdEChn78_-1A
comments: true
---
## 概要
`ImageIO`を使用して`AnimatedGif`を生成し、これを画像ファイルとして書き出します。

{% download https://drive.google.com/uc?id=1u3A7qx0Lmc-FYjdYhsZkBRrdEChn78_-1A %}

## サンプルコード
<pre class="prettyprint"><code>BufferedImage image = new BufferedImage(
    WIDTH, HEIGHT, BufferedImage.TYPE_INT_ARGB);
Iterator&lt;ImageWriter&gt; it = ImageIO.getImageWritersByFormatName("gif");
try {
  File file = File.createTempFile("anime", ".gif");
  file.deleteOnExit();

  ImageWriter writer = it.hasNext() ? it.next() : null;
  ImageOutputStream stream = ImageIO.createImageOutputStream(file);
  if (Objects.isNull(writer)) {
    throw new IOException();
  }
  writer.setOutput(stream);
  writer.prepareWriteSequence(null);

  IIOMetadataNode gce = new IIOMetadataNode("GraphicControlExtension");
  gce.setAttribute("disposalMethod", "none");
  gce.setAttribute("userInputFlag", "FALSE");
  gce.setAttribute("transparentColorFlag", "FALSE");
  gce.setAttribute("transparentColorIndex", "0");
  gce.setAttribute("delayTime", Objects.toString(DELAY));

  IIOMetadataNode ae = new IIOMetadataNode("ApplicationExtension");
  ae.setAttribute("applicationID", "NETSCAPE");
  ae.setAttribute("authenticationCode", "2.0");
  // last two bytes is an unsigned short (little endian) that
  // indicates the the number of times to loop.
  // 0 means loop forever.
  ae.setUserObject(new byte[] {0x1, 0x0, 0x0});

  IIOMetadataNode aes = new IIOMetadataNode("ApplicationExtensions");
  aes.appendChild(ae);

  // Create animated GIF using imageio | Oracle Community
  // https://community.oracle.com/thread/1264385
  ImageWriteParam iwp = writer.getDefaultWriteParam();
  IIOMetadata metadata = writer.getDefaultImageMetadata(
      new ImageTypeSpecifier(image), iwp);
  String metaFormat = metadata.getNativeMetadataFormatName();
  Node root = metadata.getAsTree(metaFormat);
  root.appendChild(gce);
  root.appendChild(aes);
  metadata.setFromTree(metaFormat, root);

  // make frame
  for (int i = 0; i &lt; list.size() * DELAY; i++) {
    paintFrame(image, list);
    Collections.rotate(list, 1);
    writer.writeToSequence(new IIOImage(image, null, metadata), null);
    metadata = null;
  }
  writer.endWriteSequence();
  stream.close();

  String path = file.getAbsolutePath();
  label.setText(path);
  label.setIcon(new ImageIcon(path));
} catch (IOException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
上記のサンプルでは、[Create animated GIF using imageio | Oracle Community](https://community.oracle.com/thread/1264385)を参考に、`delayTime`が`10`ミリ秒、フレーム数が`80`の`AnimatedGif`を生成し、画像ファイルとしての書き出しと`JLabel`への表示を実行しています。

## 参考リンク
- [Create animated GIF using imageio | Oracle Community](https://community.oracle.com/thread/1264385)

<!-- dummy comment line for breaking list -->

## コメント
