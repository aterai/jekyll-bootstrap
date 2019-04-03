---
layout: post
category: swing
folder: MediaTracker
title: MediaTrackerで画像のサイズを取得
tags: [MediaTracker, Image, JTable, DragAndDrop, DropTargetListener]
author: aterai
pubdate: 2004-12-13T02:15:06+09:00
description: MediaTrackerを使って画像ファイルからイメージの幅と高さを取得します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPsQMGUsI/AAAAAAAAAeY/B8MAwtKhshY/s800/MediaTracker.png
comments: true
---
## 概要
`MediaTracker`を使って画像ファイルからイメージの幅と高さを取得します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPsQMGUsI/AAAAAAAAAeY/B8MAwtKhshY/s800/MediaTracker.png %}

## サンプルコード
<pre class="prettyprint"><code>private Dimension getImageDimension(Image img, int id) {
  MediaTracker tracker = new MediaTracker((Container) this);
  tracker.addImage(img, id);
  try {
    tracker.waitForID(id);
  } catch (InterruptedException e) {
    ex.printStackTrace();
  }
  return new Dimension(img.getWidth(this), img.getHeight(this));
}
</code></pre>

## 解説
上記のサンプルでは、`MediaTracker`を使って画像ファイルをロードし、イメージが描画される領域の幅と高さを取得しています。

- - - -
`JTable`にファイルをドロップすると、画像の幅、高さを一覧表示します。

## 参考リンク
- [MediaTracker (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/MediaTracker.html)
- [Jpegファイルのコメントを取り出す](https://ateraimemo.com/Swing/IIOMetadata.html)
- [Fileのドラッグ＆ドロップ](https://ateraimemo.com/Swing/FileListFlavor.html)

<!-- dummy comment line for breaking list -->

## コメント
