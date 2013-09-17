---
layout: post
title: MediaTrackerで画像のサイズを取得
category: swing
folder: MediaTracker
tags: [MediaTracker, Image, JTable, DragAndDrop, DropTargetListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-12-13

## MediaTrackerで画像のサイズを取得
`MediaTracker`で画像のサイズを取得します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPsQMGUsI/AAAAAAAAAeY/B8MAwtKhshY/s800/MediaTracker.png)

### サンプルコード
<pre class="prettyprint"><code>private Dimension getImageDimension(Image img) {
  MediaTracker tracker = new MediaTracker((Container)this);
  tracker.addImage(img, 0);
  try{
    tracker.waitForID(0);
  }catch(InterruptedException e) {}
  return new Dimension(img.getWidth(null), img.getHeight(null));
}
</code></pre>

### 解説
上記のサンプルでは、`MediaTracker`を使って、画像のサイズを取得しています。

- - - -
`JTable`にファイルをドロップすると、画像の幅、高さを一覧表示します。

### 参考リンク
- [Jpegファイルのコメントを取り出す](http://terai.xrea.jp/Swing/IIOMetadata.html)
- [Fileのドラッグ＆ドロップ](http://terai.xrea.jp/Swing/FileListFlavor.html)

<!-- dummy comment line for breaking list -->

### コメント
