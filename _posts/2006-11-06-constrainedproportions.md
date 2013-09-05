---
layout: post
title: JFrameの縦横比を一定にする
category: swing
folder: ConstrainedProportions
tags: [JFrame]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-11-06

## JFrameの縦横比を一定にする
`JFrame`の幅と高さの比率が一定になるように制限します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTKJeWlAAI/AAAAAAAAAVg/GMclfo0TYBM/s800/ConstrainedProportions.png)

### サンプルコード
<pre class="prettyprint"><code>final int mw = 320;
final int mh = 200;
frame.addComponentListener(new ComponentAdapter() {
  @Override public void componentResized(ComponentEvent e) {
    int fw = frame.getSize().width;
    int fh = mh*fw/mw;
    frame.setSize((mw&gt;fw)?mw:fw, (mh&gt;fh)?mh:fh);
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JFrame`のサイズを変更した後、その幅から縦横比が同じになるような高さを計算して、`JFrame#setSize(int,int)`でサイズを設定し直しています。

### 参考リンク
- [JFrameの最小サイズ](http://terai.xrea.jp/Swing/MinimumFrame.html)
- [DynamicLayoutでレイアウトの動的評価](http://terai.xrea.jp/Swing/DynamicLayout.html)

<!-- dummy comment line for breaking list -->

### コメント
- これはドラッグ中は自由なサイズでボタンを離したときにサイズが正しく変更されます。ドラッグ中も正しい比率になるのは無理でしょうか？ --  2007-11-10 (土) 00:17:13
    - ども。今の`Java`だけだと難しいかもしれません。すこし調べてみます。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-11-12 (月) 11:45:22

<!-- dummy comment line for breaking list -->
